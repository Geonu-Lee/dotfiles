-- Neovim
-- =========================================
lvim.leader = ' '
lvim.colorscheme = 'dracula'
lvim.builtin.time_based_themes = true
lvim.transparent_window = false
lvim.debug = false
vim.lsp.set_log_level = "error"
lvim.log.level = "warn" 
require("user.neovim").config()
lvim.lsp.code_lens_refresh = true
lvim.lsp.installer.setup.automatic_installation = true


-- Customization
-- =========================================
lvim.builtin.sell_your_soul_to_devil = { active = false, prada = false, openai = false } -- if you want microsoft to abuse your soul
lvim.builtin.lastplace = { active = true }
lvim.builtin.tabnine = { active = true}
lvim.builtin.dap.active = true -- change this to enable/disable debugging
lvim.builtin.harpoon = { active = true } -- use the harpoon plugin
lvim.builtin.sidebar = { active = true } -- enable/disable sidebar
lvim.builtin.file_browser = { active = false } -- enable/disable telescope file browser
lvim.builtin.dressing = { active = true } -- enable to override vim.ui.input and vim.ui.select with telescope
lvim.builtin.neoclip = { active = true, enable_persistent_history = false }
lvim.builtin.persistence = { active = true } -- change to false if you don't want persistence
lvim.builtin.tmux_lualine = true -- use vim-tpipeline to integrate lualine and tmux
lvim.builtin.python_programming = { active = true } -- swenv.nvim + nvim-dap-python + requirements.txt.vim
lvim.builtin.fancy_wild_menu = { active = true }
lvim.builtin.fancy_diff = { active = true } -- enable/disable fancier git diff
lvim.builtin.noice = { active = true }
lvim.builtin.motion_provider = "hop" -- change this to use different motion providers ( hop or leap or flash)
lvim.builtin.mind = { active = true, root_path = "~/.mind" } -- enable/disable mind.nvim
lvim.builtin.sql_integration = { active = false } -- use sql integration
lvim.builtin.symbols_usage = { active = false } -- enable/disable symbols-usage.nvim
lvim.builtin.tag_provider = "symbols-outline" -- change this to use different tag providers ( symbols-outline or vista )
lvim.builtin.test_runner = { active = true, runner = "ultest" } -- change this to enable/disable ultest or neotest
lvim.builtin.winbar_provider = "navic" -- can be "filename" or "treesitter" or "navic" or ""
lvim.builtin.cursorline = { active = true } -- use a bit fancier cursorline
lvim.builtin.tree_provider = "nvimtree" -- can be "neo-tree" or "nvimtree" or ""
lvim.builtin.file_browser = { active = false } -- enable/disable telescope file browser


if lvim.builtin.winbar_provider == "navic" then
  vim.opt.showtabline = 1
  lvim.keys.normal_mode["<tab>"] =
    "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal'})<cr>"
  lvim.builtin.bufferline.active = false
  lvim.builtin.breadcrumbs.active = true
end
lvim.builtin.breadcrumbs.active = true
if lvim.builtin.breadcrumbs.active and lvim.builtin.noice.active then
  table.insert(lvim.builtin.breadcrumbs.winbar_filetype_exclude, "vim")
end
lvim.builtin.nvimtree.active = lvim.builtin.tree_provider == "nvimtree"
if lvim.builtin.cursorline.active then
  lvim.lsp.document_highlight = false
end

-- Override Lunarvim defaults
-- =========================================
require("user.builtin").config()

-- StatusLine
-- =========================================
require("user.lualine").config()

-- Debugging
-- =========================================
require("user.dap").config()


-- Language Specific
-- =========================================
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  "dockerls",
  "pyright",
  "yamlls",
})

-- Additional Plugins
-- =========================================
require("user.plugins").config()

-- Autocommands
-- =========================================
require("user.autocommands").config()

-- Additional Keybindings
-- =========================================
require("user.keybindings").config()
