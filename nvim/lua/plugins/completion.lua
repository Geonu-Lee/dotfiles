-- 자동완성 — LSP 없이 "경로"와 "버퍼 안 단어"만.
--
-- LSP 를 쓰지 않으므로 함수 시그니처·타입 같은 건 안 나온다. 대신
--   · 파일 경로 보완 (마크다운에 이미지 경로 쓸 때 특히 유용)
--   · 열려 있는 버퍼의 단어 보완 (긴 변수명 반복 입력 줄임)
-- 두 가지만 얻는다. 나중에 LSP 를 넣으면 sources 에 "lsp" 를 추가하면 된다.
--
-- version 을 고정하면 미리 빌드된 fuzzy 라이브러리를 받으므로
-- Rust 툴체인이 필요 없다 (원격 서버에서도 동작).
return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = "default", -- C-y 로 확정, C-n/C-p 로 이동, C-e 로 취소
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      completion = {
        -- 자동으로 창을 띄우되 첫 항목을 미리 선택하지 않는다.
        -- 엔터를 눌렀을 때 원치 않는 보완이 들어가는 걸 막는다.
        list = { selection = { preselect = false, auto_insert = false } },
        menu = { border = "rounded" },
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
      },
      sources = {
        default = { "path", "buffer" },
      },
      -- treesitter 로 표시를 다듬음
      appearance = { nerd_font_variant = "mono" },
    },
  },
}
