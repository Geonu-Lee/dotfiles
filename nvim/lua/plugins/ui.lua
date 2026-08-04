-- 상태줄 · 버퍼 탭줄 · 키맵 안내
return {
  -- 상태줄
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "dracula-nvim",
        globalstatus = true, -- 분할해도 상태줄은 화면 아래 하나만
        section_separators = "",
        component_separators = "│",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 } }, -- 상대 경로까지
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- 열린 버퍼를 상단에 탭처럼 (S-h / S-l 로 이동)
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = false, -- LSP 를 안 쓰므로 진단 표시 불필요
        show_close_icon = false,
        show_buffer_close_icons = false,
        offsets = {
          { filetype = "snacks_layout_box", text = "파일", highlight = "Directory" },
        },
      },
    },
  },

  -- 키를 누르면 다음에 뭘 누를 수 있는지 보여준다.
  -- 키맵이 늘어날 때 외우지 않아도 되게 해주는 장치.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>f", group = "찾기" },
        { "<leader>g", group = "git" },
        { "<leader>b", group = "버퍼" },
        { "<leader>i", group = "이미지" },
        { "<leader>u", group = "토글·undo" },
        { "<leader>s", group = "찾기·바꾸기" },
        { "<leader>q", group = "세션" },
        { "<leader>x", group = "quickfix" },
        { "[", group = "이전으로" },
        { "]", group = "다음으로" },
      },
    },
  },
}
