local M = {}

function M.setup(background)
    vim.opt.termguicolors = true
    -- https://github.com/morhetz/gruvbox
    vim.cmd("packadd gruvbox")
    vim.opt.background = background
    vim.g.gruvbox_italic = 1
    vim.cmd("colorscheme gruvbox")
end

return M
