import re
from pathlib import Path

from waffle_box.dx.maker_manager import MakerManager, ONNXConvConfigs
from waffle_box.dx.maker_manager.thread_handler import ConvertThreadHandler

from waffle_box_exception.waffle_box_exception import ExceptionCode, WaffleBoxException


class BakeService:
    """ONNX 모델을 trt 엔진으로 변환
    사용자가 입력한 ONNX 모델을 타겟 Autocare-D 버전에 맞춰 trt 엔진 파일로 변환한다.

    실행 순서:
        1. is_local_maker_installed: Waffle Maker 이미지가
            로컬에 설치되어 있는지 확인한다.
        2. convert_model: 모델을 trt 엔진으로 변환한다.

    Attributes:
        workspace (Path): 작업할 경로, 일반적으로 ~/.waffle_box
        origin_app_path (Path): 사용자가 입력한 기존 App 경로
        final_app_path (Path): 새로운 App을 저장할 경로
        img_tag (str): trt 변환을 위한 컨테이너 태그명
        maker_manager (MakerManager): maker manager

    """

    def __init__(
        self, workspace: Path, input: Path, output: Path, dx_target_version: str, gpu_num: int
    ) -> None:
        """
        Args:
            workspace (Path): 작업할 경로
            input (Path): 변환할 모델 경로
            output (Path): 변환한 trt 엔진 파일을 저장할 경로
            dx_target_version (str): 변환할 App의 target Autocare-D 버전
            gpu_num (int): 작업할 GPU 번호

        Raises:
            MakerManagerError

        """
        self.origin_model_path: Path = input
        self.final_model_path: Path = output

        # TODO: make image tag converter
        self.img_tag = "snuailab/trt:8.5.2.2"

        self.maker_manager = MakerManager(self.img_tag, gpu_num, workspace)

    def is_local_maker_installed(self) -> bool:
        """Waffle maker가 local에 설치되어 있는가?

        Returns:
            True: 설치되어 있음
            False: 설치되어 있지 않음
        """
        return self.maker_manager.check_image_exist_at_local()

    def convert_model(
        self,
        print_output: bool,
        input_shapes: str,
        precision: str = 'fp16',
        max_batch: int = 16,
        using_thread: bool = False,
        allow_multiple_containers: bool = False,
        thread_handler: ConvertThreadHandler = None,
    ) -> ConvertThreadHandler | None:
        """모델 변환

        Args:
            print_output (bool): 변환 과정 출력 여부
            precision (str): 모델의 precision,
                fp32, fp16, int8 중 하나
            input_shapes (str): 모델의 인풋 크기, {channel}x{width}x{height} 포맷
                예) 3x640x640
            using_thread (bool): thread로 동작할지 여부
            allow_multiple_containers (bool): convert container 실행 중복 허용 여부

        Raises:
            INVALID_ARGUMENT: input shapes의 포맷이 잘못됨

        """
        # validate input shapes
        p = re.compile(r"\d+x\d+x\d+")
        m = p.match(input_shapes)

        if m == None or m.start() != 0 or m.end() != len(input_shapes):
            raise WaffleBoxException("Invalid input shapes", ExceptionCode.INVALID_ARGUMENT)
        onnx_config = ONNXConvConfigs(precision, input_shapes, max_batch)
        handler = self.maker_manager.convert_onnx_to_engine_at_local(
            input=self.origin_model_path,
            output=self.final_model_path,
            convert_config=onnx_config,
            print_output=print_output,
            using_thread=using_thread,
            allow_multiple_containers=allow_multiple_containers,
            thread_handler=thread_handler,
        )

        return handler if handler is not None else None, self.final_model_path
