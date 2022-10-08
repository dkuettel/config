local M = {}

function M.setup()
    vim.cmd("packadd funky-contexts.nvim")
    require("funky-contexts").setup()
end

return M
