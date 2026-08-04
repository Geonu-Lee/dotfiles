-- 변경 표시와 hunk 이동만. 커밋·브랜치 작업은 이미 쓰는 lazygit 에 맡긴다.
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end

        map("n", "]h", gs.next_hunk, "다음 변경")
        map("n", "[h", gs.prev_hunk, "이전 변경")
        map("n", "<leader>gp", gs.preview_hunk, "변경 미리보기")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "이 줄 blame")
        map("n", "<leader>gr", gs.reset_hunk, "변경 되돌리기")
        map("n", "<leader>gd", gs.diffthis, "이 파일 diff")
      end,
    },
  },
}
