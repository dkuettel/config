local M = {}

function M.setup()
    vim.cmd("packadd funky-formatter.nvim")
    local funky_formatter = require("funky-formatter")
    funky_formatter.setup({
        formatters = {
            python = { command = { "isort-and-black" } },
            lua = { command = { "some-stylua" } },
            json = { command = { "jq" } },
            -- yaml = { command = { "prettier", "--parser", "yaml" } },
            rust = { command = { "rustfmt" } },
            markdown = { command = { "pandoc", "--from=markdown", "--to=markdown" } },
            gitignore = { command = { "env", "-", "LC_ALL=C", "sort", "--unique" } },
            ["requirements.in"] = { command = { "env", "-", "LC_ALL=C", "sort", "--unique" } },
            ["requirements-dev.in"] = { command = { "env", "-", "LC_ALL=C", "sort", "--unique" } },
        },
    })
    vim.keymap.set("n", "==", funky_formatter.format, { desc = "funky formatter" })
end

return M
