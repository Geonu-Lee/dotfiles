import atexit
import os
import shutil
import subprocess
import tarfile
import time
from pathlib import Path
from typing import Union
from uuid import uuid4

import docker
from waffle_box.dx.maker_manager.convert_option import ONNXConvConfigs
from waffle_box.dx.maker_manager.thread_handler import ConvertThreadHandler

from waffle_box_exception.waffle_box_exception import ExceptionCode, WaffleBoxException


class MakerManager:
    """Waffle Maker Manager

    ONNX 파일을 TensorRT 엔진 파일로 변환하는 Waffle Maker를 관리하는 클래스.
    이미지 다운로드, 모델 파일 변환 등의 기능을 제공한다.

    Attributes:
        img_tag (str): 실행할 이미지 태그
        gpu_num (int): 컨테이너를 동작할 gpu 번호
        container_id (int | None): 실행한 컨테이너 ID로
            컨테이너를 정상적으로 종료시키지 못했을 때 회수하기 위해 저장한다.
            None일경우 회수할 컨테이너 없음
        workspace (Path): 압축푸는 작업 등 파일 관리를 위한 workspace
        client (DockerClient): 도커 클라이언트

    """

    def __init__(self, img_tag: str, gpu_num: int, workspace: Path) -> None:
        """
        Args:
            img_tag (str): 실행할 이미지 태그
            gpu_num (str): 컨테이너를 동작할 gpu 번호
            workspace (Path): 작업할 경로, 일반적으로 ~/.waffle_box

        Raises:
            DockerDaemonError: Docker daemon에 접속 불가

        """
        self.img_tag = img_tag
        self.gpu_num = gpu_num
        self.container_id = None
        self.log = []
        self.workspace = workspace.joinpath(f"{uuid4()}/")

        os.mkdir(self.workspace)

        self.client = docker.from_env()

        atexit.register(self.exit_container_handler)

        if not self.client.ping():
            raise WaffleBoxException("Docker daemon eror.", ExceptionCode.DOCKER_EXCEPTION)

    def __del__(self):
        os.rmdir(self.workspace)

    def check_image_exist_at_local(self) -> bool:
        """로컬에 이미지가 설치되어 있는지 확인한다.

        MakerManager를 생성할 때 입력한 이미지 태그가 로컬에 존재하는지 확인한다.

        Returns:
            True: 이미지가 설치되어 있음
            False: 이미지가 설치되어 있지 않음
        """
        try:
            self.client.images.get(self.img_tag)

        except Exception as e:
            return False

        return True

    def pull_image_at_local(self, print_output: bool, id: str = "", pw: str = "") -> None:
        """로컬에 이미지를 다운받는다.

        MakerManager를 생성할 때 입력한 이미지 태그를 로컬에 다운받는다.
        만약 id와 pw를 입력했다면 docker hub에 로그인을 한 후 다운받는다.

        Args:
            id (str): docker hub id, 빈값이라면 로그인을 하지 않는다.
            pw (str): docker hub password, 빈값이라면 로그인을 하지 않는다.

        Raises:
            LoginError: id 혹은 pw가 잘못됨
            AlreadExistError: 이미 이미지가 설치되어 있음
            PermissionError: 이미지를 설치할 권한이 없음

        """
        if id and pw:
            try:
                self.client.login(id, pw)

            except docker.errors.APIError as e:
                raise WaffleBoxException("Login error.", ExceptionCode.DOCKER_IMAGE_EXCEPTION)

        if self.check_image_exist_at_local():
            raise WaffleBoxException("Image already exist.", ExceptionCode.DOCKER_IMAGE_EXCEPTION)

        try:
            if print_output:
                progress = {}

                for line in self.client.api.pull(self.img_tag, stream=True, decode=True):
                    if line.get("id"):
                        progress[line["id"]] = line

                    subprocess.call("clear", shell=True)
                    for i, val in progress.items():
                        print(val)

            else:
                self.client.images.pull(self.img_tag)

        except docker.errors.APIError as e:
            raise WaffleBoxException("Permission error.", ExceptionCode.DOCKER_IMAGE_EXCEPTION)

    def run_container_at_local(self, print_output: bool, allow_multiple_containers: bool) -> None:
        device_info = docker.types.DeviceRequest(
            device_ids=[str(self.gpu_num)], capabilities=[["gpu"]]
        )

        if not allow_multiple_containers:
            for i in self.client.api.containers():
                if i["Image"] == self.img_tag:
                    raise WaffleBoxException(
                        "Already run container. If you want runing multiple_container, \
                            set allow_multiple_containers=True.",
                        ExceptionCode.DOCKER_RUN_EXCEPTION,
                    )
        try:
            container = self.client.containers.run(
                self.img_tag,
                stdin_open=True,
                detach=True,
                auto_remove=True,
                device_requests=[device_info],
            )
            self.container_id = container.id

        except docker.errors.ImageNotFound as e:
            raise WaffleBoxException("Wrong image error.", ExceptionCode.DOCKER_RUN_EXCEPTION)

        except docker.errors.APIError as e:
            raise WaffleBoxException("Http error.", ExceptionCode.DOCKER_RUN_EXCEPTION)

        except docker.errors.ContainerError as e:
            raise WaffleBoxException("Container error.", ExceptionCode.DOCKER_RUN_EXCEPTION)

    def convert_onnx_to_engine_at_local(
        self,
        input: Path,
        output: Path,
        convert_config: ONNXConvConfigs,
        print_output: bool,
        using_thread: bool,
        allow_multiple_containers: bool,
        thread_handler: ConvertThreadHandler,
    ) -> Union[ConvertThreadHandler, None]:
        def convert(
            self,
            input: Path,
            output: Path,
            convert_config: ONNXConvConfigs,
            print_output: bool,
            allow_multiple_containers: bool,
        ) -> None:
            """입력한 모델 파일을 trt 엔진으로 변환

            입력한 모델을 컨테이너 내부에서 TensorRT 엔진으로 변환한다.
            변환한 모델은 output path에 저장한다.

            Args:
                input (Path): 변환할 모델 경로
                output (Path): 변환한 모델 저장 경로
                convert_config (ONNXConvConfigs): trtexec를 실행할 os.remove('temp.tar') 때 필요한 설정값들
                print_output (bool): container 출력 결과 표시 여부

            Raises:
                IOError: input 파일이 존재하지 않음, output 파일이 이미 존재함
                ConvertError: 변환 실패

            """

            def create_tar_file(input_path: Path):
                def set_permissions(tarinfo):
                    tarinfo.mode = 0o777
                    return tarinfo

                with tarfile.open(self.workspace.joinpath("model.tar"), "w") as tar:
                    tar.add(input_path, filter=set_permissions, arcname=f"{file_name}.onnx")

            def get_tar_file(input_path: Path, output_path: Path):
                container = self.client.containers.get(self.container_id)
                data, _ = container.get_archive(input_path)

                tar_path = self.workspace.joinpath("engine.tar")

                with open(tar_path, "wb") as f:
                    for chunk in data:
                        f.write(chunk)

                with tarfile.open(tar_path, "r") as tar:
                    tar.extractall(self.workspace)

                origin_path = self.workspace

                os.rename(origin_path.joinpath(f"{file_name}.engine"), output_path)
                os.remove(tar_path)

            if not os.path.exists(input):
                raise WaffleBoxException("Input_file not exists.", ExceptionCode.MODEL_IO_EXCEPTION)

            if os.path.exists(output):
                raise WaffleBoxException(
                    "Already output_file exists", ExceptionCode.MODEL_IO_EXCEPTION
                )

            self.run_container_at_local(
                print_output=print_output, allow_multiple_containers=allow_multiple_containers
            )

            try:
                tmp_input = "/" + str(input)

                file_name = tmp_input[tmp_input.rfind("/") + 1 : tmp_input.rfind(".")]

                create_tar_file(input)

                with open(self.workspace.joinpath("model.tar"), "rb") as f:
                    container = self.client.containers.get(self.container_id)
                    result = container.put_archive(path="/opt", data=f.read())

                if not result:
                    raise WaffleBoxException("put_archive error.", ExceptionCode.MODEL_IO_EXCEPTION)

                convert_option_list = convert_config.to_trtexec_args()
                convert_option = " ".join(convert_option_list)

                exec_result = self.client.api.exec_create(
                    container=self.container_id,
                    cmd=f"trtexec --onnx=/opt/{file_name}.onnx \
                                                                        {convert_option} \
                                                                        --saveEngine={file_name}.engine",
                    privileged=True,
                )
                exec_output = self.client.api.exec_start(exec_result["Id"], stream=True)

                if print_output:
                    for line in exec_output:
                        temp = line.decode("utf-8")
                        self.log.append(temp)
                        print(temp)
                else:
                    for line in exec_output:
                        temp = line.decode("utf-8")
                        self.log.append(temp)

                get_tar_file(
                    Path(f"/workspace/{file_name}.engine"),
                    Path(output),
                )

            except Exception as e:
                raise WaffleBoxException("Convert error.", ExceptionCode.MODEL_CONVERT_EXCEPTION)

            finally:
                os.remove(self.workspace.joinpath("model.tar"))

                try:
                    container = self.client.containers.get(self.container_id)
                    container.kill()

                    st_time = time.time()
                    while self.client.containers.get(self.container_id):
                        if time.time() - st_time > 5:
                            raise WaffleBoxException(
                                "Container kill time out.", ExceptionCode.DOCKER_RUN_EXCEPTION
                            )

                except docker.errors.NotFound:
                    print("Container killed.")

                except WaffleBoxException as e:
                    print(e)

                if print_output:
                    print("Convert finished.")

        if using_thread:
            if thread_handler is None:
                thread_handler = ConvertThreadHandler(convert)

            thread_handler.add_work(
                self, input, output, convert_config, print_output, allow_multiple_containers
            )

            return thread_handler

        else:
            convert(self, input, output, convert_config, print_output, allow_multiple_containers)
            return None

    def exit_container_handler(self):
        try:
            container = self.client.containers.get(self.container_id)
            container.kill()

            st_time = time.time()
            while self.client.containers.get(self.container_id):
                if time.time() - st_time > 5:
                    raise WaffleBoxException(
                        "Container kill time out.", ExceptionCode.DOCKER_RUN_EXCEPTION
                    )

        except docker.errors.NotFound as e:
            print("Container killed.")

        except WaffleBoxException as e:
            print(e)
