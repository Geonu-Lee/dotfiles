-- 마크다운을 편집하면서 렌더링된 모습으로 본다.
-- LazyVim 의 lang.markdown extra 가 넣어주던 것과 같은 플러그인.
-- glow 와 달리 읽기 전용이 아니라 편집 중에도 렌더링된다.
--
-- snacks.image 와 함께 쓰면 마크다운 안의 이미지까지 인라인으로 보인다
-- (kitty graphics 지원 터미널 필요 — Terminal.app 은 미지원).
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      heading = { sign = false },
      code = {
        sign = false,
        width = "block", -- 코드블록 배경을 블록 폭만큼
        min_width = 60,
      },
      -- 커서가 있는 줄은 원본 문법을 보여준다 (편집할 때 필요)
      anti_conceal = { enabled = true },
    },
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown toggle<CR>", desc = "마크다운 렌더 토글" },
    },
  },
}
