-- VSCode 전용 키맵핑
local vscode = require("vscode-neovim")
local keymap = vim.keymap.set

-- VSCode 명령어 실행 헬퍼 함수
local function action(cmd)
  return function()
    vscode.action(cmd)
  end
end

-- ========== 파일 & 에디터 관리 ==========
keymap("n", "<leader>e", action("workbench.action.toggleSidebarVisibility"))
keymap("n", "<leader>t", action("workbench.action.togglePanel"))
keymap("n", "<leader>w", action("workbench.action.files.save"))
keymap("n", "<leader>f", action("workbench.action.quickOpen"))
keymap("n", "<leader>c", action("workbench.action.closeActiveEditor"))

-- ========== 에디터 이동 ==========
keymap("n", "H", action("workbench.action.previousEditor"))
keymap("n", "L", action("workbench.action.nextEditor"))
keymap("n", "<C-h>", action("workbench.action.focusLeftGroup"))
keymap("n", "<C-j>", action("workbench.action.focusBelowGroup"))
keymap("n", "<C-k>", action("workbench.action.focusAboveGroup"))
keymap("n", "<C-l>", action("workbench.action.focusRightGroup"))

-- ========== 화면 분할 ==========
keymap("n", "<leader>s", action("workbench.action.splitEditor"))
keymap("n", "<leader>]", action("workbench.action.increaseViewWidth"))
keymap("n", "<leader>[", action("workbench.action.decreaseViewWidth"))
keymap("n", "<leader>=", action("workbench.action.increaseViewHeight"))
keymap("n", "<leader>-", action("workbench.action.decreaseViewHeight"))

-- ========== 편집 ==========
keymap("n", "<leader>/", action("editor.action.commentLine"))
keymap("v", "<leader>/", action("editor.action.commentLine"))
keymap("n", ">", action("editor.action.indentLines"))
keymap("n", "<", action("editor.action.outdentLines"))
keymap("v", ">", action("editor.action.indentLines"))
keymap("v", "<", action("editor.action.outdentLines"))

-- ========== 네비게이션 ==========
keymap("n", "gd", action("editor.action.revealDefinition"))
keymap("n", "gr", action("editor.action.goToReferences"))
keymap("n", "gi", action("editor.action.goToImplementation"))
keymap("n", "gt", action("editor.action.goToTypeDefinition"))

-- ========== 문제 & 진단 ==========
keymap("n", "]d", action("editor.action.marker.nextInFiles"))
keymap("n", "[d", action("editor.action.marker.prevInFiles"))

-- ========== 코드 액션 ==========
keymap("n", "<leader>ca", action("editor.action.quickFix"))
keymap("n", "<leader>rn", action("editor.action.rename"))
keymap("n", "<leader>fm", action("editor.action.formatDocument"))
keymap("v", "<leader>fm", action("editor.action.formatSelection"))

-- ========== 접기/펼치기 ==========
keymap("n", "za", action("editor.toggleFold"))
keymap("n", "zR", action("editor.unfoldAll"))
keymap("n", "zM", action("editor.foldAll"))

-- ========== 기타 ==========
keymap("t", "<C-n>", "<C-\\><C-n>")
keymap("n", "<leader>p", action("workbench.action.showCommands"))
