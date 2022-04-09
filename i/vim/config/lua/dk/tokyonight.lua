local M = {}

function M.setup(background, style)
    -- variants are (dark, storm), (dark, night), (light, day)
    vim.opt.termguicolors = true
    -- https://github.com/folke/tokyonight.nvim
    vim.cmd("packadd tokyonight.nvim")
    vim.opt.background = background or "dark"
    vim.g.tokyonight_style = style or "storm"
    vim.g.tokyonight_day_brightness = 0.3
    vim.cmd("colorscheme tokyonight")
end

return M
