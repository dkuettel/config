-- https://github.com/sainnhe/everforest
local M = {}

function M.setup()
    -- TODO does tmux let it thru? or does it to color translation?
    vim.opt.termguicolors = true
    vim.cmd("packadd everforest")
    M.after()
end

function M.after()
    vim.opt.background = "light" -- dark, light
    vim.g.everforest_background = "medium" -- hard, medium, soft
    --vim.g.everforest_better_performance = true
    vim.cmd("colorscheme everforest")
    -- I think lualine should take it automatically
    -- but everforest doc says to pass to lualine
end

return M
