local M = {}

local namespace = nil

local function command(ctx)
    local output = vim.fn.system(ctx.fargs)
    -- TODO this will freeze vim until done
    -- TODO ah well, non-zero is what you expect :)
    -- if vim.v.shell_error ~= 0 then
    --     print("pylint failed: " .. output)
    --     return
    -- end
    local json = vim.fn.json_decode(output) or {} -- json_decode has wrong type annotation?
    print("Pylint reports " .. #json .. " problems.")

    -- TODO hm how about unloaded stuff? workspace diagnostics? works with LSP
    -- vim.diagnostic.set(namespace, bufnr, diagnostics)

    local diagnostics = {}
    for _, message in ipairs(json) do
        table.insert(diagnostics, {
            filename = message.path,
            lnum = message.line,
            col = message.column + 1,
            text = message.message,
        })
    end

    vim.fn.setqflist(diagnostics)
end

function M.setup()
    vim.cmd("packadd funky-contexts.nvim")
    namespace = vim.api.nvim_create_namespace("pylint")
    require("funky-contexts").setup()
    vim.api.nvim_create_user_command("Pylint", command, { nargs = "+" })
end

return M
