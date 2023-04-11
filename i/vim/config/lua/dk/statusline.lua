local M = {}

local progress = require("dk.lsp-progress")

-- see
-- https://elianiva.my.id/post/neovim-lua-statusline/
-- https://github.com/j-hui/fidget.nvim/blob/main/lua/fidget.lua#L528

function M.statusline()
    -- TODO for completeness, or easyness, also keep a plain one around, that always works
    local window = "%{winnr()}"
    local mode = "%{mode(1)}" -- also visible in command line it seems
    local filename = "%f" -- t tail, f relative, F full
    local filetype = "%y" -- vim.bo.filetype is nicer
    -- TODO this is not evaluated in the buffer context, probably need another %{...}
    -- local lsp_progress = progress.get_status_line()
    -- kinda works, but still need to get/pass buffer
    -- and think about inactive vs active
    -- maybe instead just show a busy non-busy here so you know, actual progress is high up
    local lsp_progress = "%{v:lua.require'dk.lsp-progress'.get_state()}"
    local position = "%p%%" -- I prefer analog, and ctrl-g can do it on demand
    local location = "@%l:%v" -- too noisy?

    -- local time = os.time() -- to see updates happening
    local other = " q %q h %h w %w m %m r %r "
    -- vim.go.statusline = window .. " " .. filename .. other
    -- vim.go.statusline = window .. "%=" .. filename .. "%=" .. "%% @%l:%v"

    -- TODO join works, but no control over spaces, otherwise table.concat, or just a .. b
    return vim.fn.join({
        window,
        filename,
        "%=",
        filetype,
        lsp_progress,
        -- time,
        position,
        location,
    }, " ")
end

function M.tabline()
    return "%=" .. progress.get_named_progress()
end

function M.setup()
    progress.setup({
        on_update = function()
            -- TODO not clear if all (with "!") or not, but current window could be anything in this callback
            vim.cmd("redrawstatus!")
            vim.cmd("redrawtabline")
        end,
    })
    -- TODO some problem with instances of M? when I do require it seems to be another one
    -- and then M.progress doesnt work, or access the same, it stays on "..."
    -- vim.go.statusline = '%!v:lua.require("dk/statusline").statusline()'
    -- vim.go.statusline = "%!v:lua.dk_statusline()"
    -- this works, so must use this syntax to be in same instance?
    -- vim.go.statusline = "%{v:lua.require'dk.statusline'.progresser()}"
    vim.go.statusline = "%!v:lua.require'dk.statusline'.statusline()"
    vim.go.tabline = "%!v:lua.require'dk.statusline'.tabline()"
    vim.go.showtabline = 2 -- always, even when just one tab
end

return M
