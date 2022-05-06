local M = {}

function M.setup()
    vim.cmd("packadd funky-formatter.nvim")
    local funky_formatter = require("funky-formatter")
    funky_formatter.setup({
        formatters = {
            python = { command = { "some-isort-and-black" } },
            -- TODO black has "--fast" but it makes no different, the majority is black (0.23) not isort (0.06s)
            lua = { command = { "stylua", "--config-path", "./stylua.toml", "-" } },
            json = { command = { "jq" } },
        },
    })
    vim.keymap.set("n", "==", funky_formatter.format, { desc = "funky formatter" })
end

return M
