local M = {}

function M.setup()
    -- https://github.com/jose-elias-alvarez/null-ls.nvim
    vim.cmd("packadd null-ls.nvim")
    local N = require("null-ls")
    -- TODO another option for formatting could be https://github.com/mhartington/formatter.nvim
    local F = N.builtins.formatting
    -- TODO used to have sbdchd/neoformat and then it's clear what we use
    -- now not sure if another lsp will interfere with "=="
    N.setup({
        sources = {
            F.stylua,
            --require("null-ls").builtins.diagnostics.eslint,
            --require("null-ls").builtins.completion.spell,
        },
    })
end

return M
