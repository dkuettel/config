local M = {}

function M.setup()
    vim.opt.termguicolors = true
    -- https://github.com/arcticicestudio/nord-vim
    vim.cmd("packadd nord-vim")
    vim.cmd("colorscheme nord")
end

return M
