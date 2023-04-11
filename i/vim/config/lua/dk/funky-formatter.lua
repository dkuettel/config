local M = {}

function M.setup()
    vim.cmd("packadd funky-formatter.nvim")
    local funky_formatter = require("funky-formatter")
    funky_formatter.setup({
        formatters = {
            python = { command = { "isort-and-black" } },
            lua = { command = { "some-stylua" } },
            json = { command = { "jq" } },
            rust = { command = { "rustfmt" } },
            markdown = { command = { "pandoc", "--from=markdown", "--to=markdown" } },
            gitignore = { command = { "sort", "--unique" } },
            ["requirements.in"] = { command = { "sort", "--unique" } },
        },
    })
    vim.keymap.set("n", "==", funky_formatter.format, { desc = "funky formatter" })
end

return M
