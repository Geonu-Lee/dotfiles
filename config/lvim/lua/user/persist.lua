local M = {}

M.config = function()
  local opt = {
    save_dir = vim.fn.expand(get_cache_dir() .. "/sessions/"),
    silent = false,
    use_git_branch = true,
    autosave = true,
    should_autosave = function()
      if vim.bo.filetype == 'alpha' then
        return false
      end
    return true
    end,
    autoload = false,
    on_autoload_no_session = nil,
    follow_cwd = true,
    allowed_dirs = nil,
    ignored_dirs = nil,
    telescope = {
      reset_prompt_after_deletion = true,
    },
  }
  require("persisted").setup(opt)
end

return M
