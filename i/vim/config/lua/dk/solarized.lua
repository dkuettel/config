local M = {}

function M.setup(background, variant)
    vim.opt.termguicolors = true
    -- https://github.com/lifepillar/vim-solarized8
    -- the original doesnt work anymore with modern vim (https://github.com/altercation/vim-colors-solarized)
    vim.cmd("packadd vim-solarized8")
    vim.opt.background = background or "light"
    if variant then
        vim.cmd("colorscheme solarized8_" .. variant)
    else
        vim.cmd("colorscheme solarized8")
    end
end

return M
