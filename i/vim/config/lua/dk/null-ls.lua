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
            -- TODO target version will change, black doesnt read it from the venv
            -- the order seems to be as configured here, so we want isort first
            F.isort.with({command="./.venv/bin/isort", extra_args={"--profile=black", "--combine-as"}}),
            F.black.with({command="./.venv/bin/black", extra_args={"--target-version=py39"}}),
            --require("null-ls").builtins.diagnostics.eslint,
            --require("null-ls").builtins.completion.spell,
        },
    })
end

return M
