local M = {}

function M.setup(background)
    vim.opt.termguicolors = true
    -- https://github.com/sainnhe/everforest
    vim.cmd("packadd everforest")
    vim.opt.background = background or "light"
    vim.g.everforest_background = "hard" -- hard, medium, soft
    --vim.g.everforest_better_performance = true
    vim.cmd("colorscheme everforest")
end

return M
