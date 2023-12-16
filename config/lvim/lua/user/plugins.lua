local M = {}
M.config = function()
  local neoclip_req = { "kkharji/sqlite.lua" }
  if lvim.builtin.neoclip.enable_persistent_history == false then
    neoclip_req = {}
  end
  lvim.plugins ={
    {
      "Mofiqul/dracula.nvim",
      name = 'dracula',
      config = function()
        require("user.theme").dracula()
        lvim.colorscheme = 'dracula'
      end,
    },
    {
      "folke/trouble.nvim",
      config = function()
        require("trouble").setup {
          auto_open = false,
          auto_close = true,
          padding = false,
          height = 10,
          use_diagnostic_signs = true,
        }
      end,
      event = "VeryLazy",
      cmd = "Trouble",
    },
    {
      "hrsh7th/cmp-cmdline",
      enabled = lvim.builtin.fancy_wild_menu.active,
    },
    {
      "stevearc/dressing.nvim",
      lazy = true,
      config = function()
        require("user.dress").config()
      end,
      enabled = lvim.builtin.dressing.active,
      event = "BufWinEnter",
    },
    {
      "fgheng/winbar.nvim",
      config = function()
        require("user.winb").config()
      end,
      event = { "InsertEnter", "CursorHoldI" },
      enabled = lvim.builtin.winbar_provider == "treesitter",
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      cmd = "Neotree",
      dependencies = {
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("user.neotree").config()
      end,
      enabled = lvim.builtin.tree_provider == "neo-tree",
    },
    { "MunifTanjim/nui.nvim" },
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      config = function()
        require("user.noice").config()
      end,
      dependencies = {
        "rcarriga/nvim-notify",
      },
      enabled = lvim.builtin.noice.active,
    },
    {
      "AckslD/swenv.nvim",
      enabled = lvim.builtin.python_programming.active,
      ft = "python",
      event = { "BufRead", "BufNew" },
    },
    {
      "mfussenegger/nvim-dap-python",
      config = function()
        local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
        require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
        require("dap-python").test_runner = "pytest"
      end,
      ft = "python",
      event = { "BufRead", "BufNew" },
      enabled = lvim.builtin.python_programming.active,
    },
    {
      "raimon49/requirements.txt.vim",
      event = "VeryLazy",
      enabled = lvim.builtin.python_programming.active,
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      enabled = lvim.builtin.file_browser.active,
    },
    {
      "ibhagwan/fzf-lua",
      config = function()
        -- calling `setup` is optional for customization
        local ff = require "user.fzf"
        require("fzf-lua").setup(vim.tbl_deep_extend("keep", vim.deepcopy(ff.active_profile), ff.default_opts))
      end,
      enabled = not lvim.builtin.telescope.active,
    },
    {
      "m-demare/hlargs.nvim",
      lazy = true,
      event = "VeryLazy",
      config = function()
        require("hlargs").setup {
          excluded_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
        }
      end,
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      enabled = lvim.builtin.colored_args,
    },
    {
      "phaazon/hop.nvim",
      event = "VeryLazy",
      cmd = { "HopChar1CurrentLineAC", "HopChar1CurrentLineBC", "HopChar2MW", "HopWordMW" },
      config = function()
        require("user.hop").config()
      end,
      enabled = lvim.builtin.motion_provider == "hop",
    },
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      keys = require("user.flash").keys,
      enabled = lvim.builtin.motion_provider == "flash",
    },
    {
      "ThePrimeagen/harpoon",
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-lua/popup.nvim" },
      },
      enabled = lvim.builtin.harpoon.active,
    },
    {
      "sindrets/diffview.nvim",
      lazy = true,
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
      keys = { "<leader>gd", "<leader>gh" },
      config = function()
        require("user.diffview").config()
      end,
      enabled = lvim.builtin.fancy_diff.active,
    },
    {
      "cshuaimin/ssr.nvim",
      lazy = true,
      config = function()
        require("ssr").setup {
          min_width = 50,
          min_height = 5,
          keymaps = {
            close = "q",
            next_match = "n",
            prev_match = "N",
            replace_all = "<leader><cr>",
          },
        }
      end,
      event = { "BufReadPost", "BufNew" },
    },
  }
end

return M
