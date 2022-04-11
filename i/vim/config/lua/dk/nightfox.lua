local M = {}

function M.setup(variant)
    -- variants: nightfox, nordfox, palefox, dayfox
    vim.opt.termguicolors = true
    -- https://github.com/oxalica/nightfox.vim
    vim.cmd("packadd nightfox.vim")
    variant = variant or "nightfox"
    vim.cmd("colorscheme " .. variant)
end

return M
