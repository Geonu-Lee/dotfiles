require("user.all")
require("user.plugins")
require("user.whichkey")
require("user.options")

-- Additional Plugins
lvim.plugins = {
  -- You can switch between vritual environmnts.
  "Mofiqul/dracula.nvim",
  "mfussenegger/nvim-dap-python",
  "lithammer/nvim-pylance",
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
}
pcall(function()
  require("dap-python").setup("/home/ljj/virtualenvs/venv/bin/python3.8")
  -- require("dap-python").setup("python")
end)

-- Supported test frameworks are unittest, pytest and django. By default it
-- tries to detect the runner by probing for pytest.ini and manage.py, if
-- neither are present it defaults to unittest.
pcall(function()
  require("dap-python").test_runner = "pytest"
end)
