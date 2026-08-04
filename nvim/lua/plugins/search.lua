-- 프로젝트 전역 찾기·바꾸기.
-- LSP 를 쓰지 않아 rename 이 없으므로, 심볼 이름을 바꿀 때 실질적으로 이걸 쓴다.
-- ripgrep 으로 찾고 결과를 버퍼에서 직접 편집하듯 치환한다.
return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sr",
        function()
          -- 현재 파일 확장자만 대상으로 미리 채워서 연다
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e") or nil
          require("grug-far").open({
            transient = true,
            prefills = { filesFilter = ext and ext ~= "" and ("*." .. ext) or nil },
          })
        end,
        desc = "찾기·바꾸기 (현재 확장자)",
      },
      {
        "<leader>sR",
        function() require("grug-far").open({ transient = true }) end,
        desc = "찾기·바꾸기 (전체)",
      },
      {
        "<leader>sw",
        mode = { "n", "x" },
        function()
          require("grug-far").open({ transient = true, prefills = { search = vim.fn.expand("<cword>") } })
        end,
        desc = "커서 단어 찾기·바꾸기",
      },
    },
  },
}
