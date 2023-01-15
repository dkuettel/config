local M = {}

function M.setup()
    vim.cmd("packadd funky-formatter.nvim")
    local funky_formatter = require("funky-formatter")
    funky_formatter.setup({
        formatters = {
            python = { command = { "isort-and-black" } },
            -- TODO if I want to have more smartness, we need to allow function here?
            -- so that I can check if there is a stylua, and alternatively choose another one?
            -- or we say do some shell kungfu yourself, yeah probably nicer
            lua = { command = { "stylua", "--config-path", "./stylua.toml", "-" } },
            json = { command = { "jq" } },
            rust = { command = { "rustfmt" } },
            markdown = { command = { "pandoc", "--from=markdown", "--to=markdown" } },
            gitignore = { command = { "sort", "--unique" } },
        },
    })
    vim.keymap.set("n", "==", funky_formatter.format, { desc = "funky formatter" })
end

return M
