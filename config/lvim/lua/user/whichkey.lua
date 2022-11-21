lvim.leader = "space"

lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
}
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('dap-python').test_method()<cr>", "Test Method" }
lvim.builtin.which_key.mappings["df"] = { "<cmd>lua require('dap-python').test_class()<cr>", "Test Class" }
-- lvim.builtin.which_key.mappings["C-9"] = {"<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint"}
lvim.keys.normal_mode["<C-9>"] = ":lua require'dap'.toggle_breakpoint()<cr>"
lvim.keys.normal_mode["<C-0>"] = ":lua require'dap'.step_into()<cr>"
lvim.keys.normal_mode["<C-->"] = ":lua require'dap'.step_over()<cr>"
lvim.keys.normal_mode["<C-5>"] = ":lua require'dap'.continue()<cr>"
lvim.keys.normal_mode["<C-1>"] = ":lua require'dap'.close()<cr>"
lvim.keys.normal_mode["<C-,>"] = ":lua require'dapui'.toggle()<cr>"
