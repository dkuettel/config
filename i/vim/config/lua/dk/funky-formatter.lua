local M = {}

function M.setup()
    vim.cmd("packadd funky-formatter.nvim")
    local funky_formatter = require("funky-formatter")
    funky_formatter.setup({
        formatters = {
            python = { command = { "isort-and-black" } },
            lua = { command = { "stylua", "--config-path", "./stylua.toml", "-" } },
            json = { command = { "jq" } },
        },
    })
    vim.keymap.set("n", "==", funky_formatter.format, { desc = "funky formatter" })
end

return M
