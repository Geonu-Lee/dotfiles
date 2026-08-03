-- VSCode에서 실행 중인지 확인
if vim.g.vscode then
  -- VSCode 전용 설정만 로드
  require("vscode-config")
else
  -- 기존 LazyVim 설정 로드
  -- bootstrap lazy.nvim, LazyVim and your plugins
  require("config.lazy")
end
