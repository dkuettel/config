local M = {}

function M.setup()
    vim.opt.termguicolors = true
    -- https://github.com/jacoborus/tender.vim
    vim.cmd("packadd tender.vim")
    vim.cmd("colorscheme tender")
end

return M
