local M = {}

function M.setup()
    -- https://github.com/jose-elias-alvarez/null-ls.nvim
    vim.cmd("packadd null-ls.nvim")
    -- dependency
    vim.cmd("packadd plenary.nvim")

    local null = require("null-ls")

    null.setup({
        sources = {
            -- NOTE works in theory, but pylint is just too slow for large projects
            -- need something that does things on demand only
            -- maybe lsp is not the right thing here
            -- TODO ruff might work since it's faster
            -- null.builtins.diagnostics.pylint,

            -- NOTE didnt do anything for me :/
            -- null.builtins.diagnostics.zsh,
        },
    })
end

return M
