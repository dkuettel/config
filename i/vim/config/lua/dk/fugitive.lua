local M = {}

function M.setup()
    -- https://github.com/tpope/vim-fugitive
    vim.cmd("packadd vim-fugitive")

    vim.keymap.set("n", "<space>g", ":tab Git<enter>")
end

return M
