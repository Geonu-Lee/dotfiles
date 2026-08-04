-- 이동 · 세션
return {
  -- 화면에 보이는 아무 곳으로 두 글자 점프.
  -- s 를 누르고 목표 글자 두 개를 치면 라벨이 붙고, 라벨을 누르면 이동한다.
  -- f/t 도 강화되어 여러 줄에 걸쳐 동작한다.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        -- / 검색 중에는 끈다. 평소 검색 습관을 바꾸지 않기 위해.
        search = { enabled = false },
        char = { enabled = true, jump_labels = true },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "점프" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "구문 단위 선택" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "원격 조작" },
    },
  },

  -- 디렉토리별로 열었던 버퍼·창 배치를 복원한다.
  -- 서버·프로젝트를 오갈 때 매번 파일을 다시 찾지 않게 해준다.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "이 폴더 세션 복원" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "마지막 세션 복원" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "세션 저장 끄기" },
    },
  },
}
