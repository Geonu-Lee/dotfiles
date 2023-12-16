local m = {}
-- local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local themes = require "telescope.themes"
local builtin = require "telescope.builtin"
local actions = require "telescope.actions"
local telescope_utils = require "telescope.utils"

function m._multiopen(prompt_bufnr, open_cmd)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = table.getn(picker:get_multi_selection())
  local border_contents = picker.prompt_border.contents[1]
  if not (string.find(border_contents, "find files") or string.find(border_contents, "git files")) then
    actions.select_default(prompt_bufnr)
    return
  end
  if num_selections > 1 then
    vim.cmd "bw!"
    for _, entry in ipairs(picker:get_multi_selection()) do
      vim.cmd(string.format("%s %s", open_cmd, entry.value))
    end
    vim.cmd "stopinsert"
  else
    if open_cmd == "vsplit" then
      actions.file_vsplit(prompt_bufnr)
    elseif open_cmd == "split" then
      actions.file_split(prompt_bufnr)
    elseif open_cmd == "tabe" then
      actions.file_tab(prompt_bufnr)
    else
      actions.file_edit(prompt_bufnr)
    end
  end
end
function m.multi_selection_open_vsplit(prompt_bufnr)
  m._multiopen(prompt_bufnr, "vsplit")
end
function m.multi_selection_open_split(prompt_bufnr)
  m._multiopen(prompt_bufnr, "split")
end
function m.multi_selection_open_tab(prompt_bufnr)
  m._multiopen(prompt_bufnr, "tabe")
end
function m.multi_selection_open(prompt_bufnr)
  m._multiopen(prompt_bufnr, "edit")
end

-- beautiful default layout for telescope prompt
function m.layout_config()
  return {
    width = 0.90,
    height = 0.85,
    preview_cutoff = 120,
    prompt_position = "bottom",
    horizontal = {
      preview_width = function(_, cols, _)
        return math.floor(cols * 0.6)
      end,
    },
    vertical = {
      width = 0.9,
      height = 0.95,
      preview_height = 0.5,
    },

    flex = {
      horizontal = {
        preview_width = 0.9,
      },
    },
  }
end

-- another file string search
function m.find_string()
  local opts = {
    border = true,
    previewer = false,
    shorten_path = false,
    layout_strategy = "flex",
    layout_config = {
      width = 0.9,
      height = 0.8,
      horizontal = { width = { padding = 0.15 } },
      vertical = { preview_height = 0.75 },
    },
    file_ignore_patterns = {
      "vendor/*",
      "node_modules",
      "%.jpg",
      "%.jpeg",
      "%.png",
      "%.svg",
      "%.otf",
      "%.ttf",
    },
  }
  builtin.live_grep(opts)
end

-- show refrences to this using language server
function m.lsp_references()
  local opts = {
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
  }
  builtin.lsp_references(opts)
end

-- show implementations of the current thingy using language server
function m.lsp_implementations()
  local opts = {
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
  }
  builtin.lsp_implementations(opts)
end

-- find files in the upper directory
function m.find_updir()
  local up_dir = vim.fn.getcwd():gsub("(.*)/.*$", "%1")
  local opts = {
    cwd = up_dir,
  }

  builtin.find_files(opts)
end

function m.installed_plugins()
  builtin.find_files {
    cwd = join_paths(vim.env.lunarvim_runtime_dir, "site", "pack", "lazy"),
  }
end

function m.project_search()
  builtin.find_files {
    previewer = false,
    layout_strategy = "vertical",
    cwd = require("lspconfig/util").root_pattern ".git"(vim.fn.expand "%:p"),
  }
end

function m.curbuf()
  local opts = themes.get_dropdown {
    winblend = 10,
    previewer = false,
    shorten_path = false,
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    border = {},
    layout_config = {
      width = 0.45,
      prompt_position = "top",
    },
  }
  builtin.current_buffer_fuzzy_find(opts)
end

function m.git_status()
  local opts = themes.get_dropdown {
    winblend = 10,
    previewer = false,
    shorten_path = false,
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    border = {},
    layout_config = {
      width = 0.45,
      prompt_position = "top",
    },
  }

  -- can change the git icons using this.
  -- opts.git_icons = {
  --   changed = "m"
  -- }

  builtin.git_status(opts)
end

function m.search_only_certain_files()
  builtin.find_files {
    find_command = {
      "rg",
      "--files",
      "--type",
      vim.fn.input "type: ",
    },
  }
end

function m.builtin()
  builtin.builtin()
end

function m.git_files()
  local path = vim.fn.expand "%:h"
  if path == "" then
    path = nil
  end

  local width = 0.45
  if path and string.find(path, "sourcegraph.*sourcegraph", 1, false) then
    width = 0.6
  end

  local opts = themes.get_dropdown {
    winblend = 5,
    previewer = false,
    shorten_path = false,
    borderchars = {
      prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    },
    border = {},
    cwd = path,
    layout_config = {
      width = width,
      prompt_position = "top",
    },
  }

  opts.file_ignore_patterns = {
    "^[.]vale/",
  }
  builtin.git_files(opts)
end

function m.grep_string_visual()
  local visual_selection = function()
    local save_previous = vim.fn.getreg "a"
    vim.api.nvim_command 'silent! normal! "ay'
    local selection = vim.fn.trim(vim.fn.getreg "a")
    vim.fn.setreg("a", save_previous)
    return vim.fn.substitute(selection, [[\n]], [[\\n]], "g")
  end
  require("telescope.builtin").live_grep {
    default_text = visual_selection(),
  }
end

function m.find_project_files(opts)
  opts = opts or {}
  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  else
    opts.cwd = vim.loop.cwd()
  end

  local _, ret = telescope_utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, opts.cwd)
  if ret ~= 0 then
    local in_worktree = telescope_utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, opts.cwd)
    local in_bare = telescope_utils.get_os_command_output({ "git", "rev-parse", "--is-bare-repository" }, opts.cwd)
    if in_worktree[1] ~= "true" and in_bare[1] ~= "true" then
      builtin.find_files(opts)
      return
    end
  end
  builtin.git_files(opts)
end

return m
