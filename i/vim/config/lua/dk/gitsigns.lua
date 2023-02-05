local M = {}

function M.setup()
    -- https://github.com/lewis6991/gitsigns.nvim
    -- before I used https://github.com/airblade/vim-gitgutter
    vim.cmd("packadd gitsigns.nvim")
    require("gitsigns").setup {
        signs = {
            -- add = { text = "" },
            -- change = { text = "" },
            -- delete = { text = "ﲐ" },
            -- topdelete = { text = "ﲓ" },
            -- changedelete = { text = "" },
        },
        on_attach = M.on_attach,
    }
end

function M.on_attach(bufnr)
    -- TODO easier operation with a git mode?
    -- have keys mapped directly only when in git mode
    -- indicate with git signs active, or in status line?
    -- then easy work without the long leader

    local gs = require("gitsigns")
    local leader = ",G"

    local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, leader .. lhs, rhs, opts)
    end

    -- Navigation
    map("n", "]", function()
        if vim.wo.diff then
            return "]c"
        end
        vim.schedule(function()
            gs.next_hunk()
        end)
        return "<Ignore>"
    end, { expr = true, desc = "gitsigns next hunk" })

    map("n", "[", function()
        if vim.wo.diff then
            return "[c"
        end
        vim.schedule(function()
            gs.prev_hunk()
        end)
        return "<Ignore>"
    end, { expr = true, desc = "gitsigns previous hunk" })

    -- Actions
    map({ "n", "v" }, "s", ":Gitsigns stage_hunk<CR>")
    map({ "n", "v" }, "r", ":Gitsigns reset_hunk<CR>")
    map("n", "S", gs.stage_buffer, { desc = "gitsigns stage buffer" })
    map("n", "u", gs.undo_stage_hunk, { desc = "gitsigns unstage hunk" })
    map("n", "R", gs.reset_buffer, { desc = "gitsigns reset buffer" })
    map("n", "p", gs.preview_hunk, { desc = "gitsigns preview hunk" })
    map("n", "b", function()
        gs.blame_line { full = true }
    end, { desc = "gitsigns blame" })
    map("n", "tb", gs.toggle_current_line_blame, { desc = "gitsigns toggle line blame" })
    map("n", "d", gs.diffthis, { desc = "gitsigns diffthis" })
    map("n", "D", function()
        gs.diffthis("~")
    end, { desc = "gitsigns diffthis ~" })
    map("n", "d", gs.toggle_deleted, { desc = "gitsigns toggle deleted" })

    -- Text object
    vim.keymap.set(
        { "o", "x" },
        "ih",
        ":<c-u>Gitsigns select_hunk<enter>",
        { buffer = bufnr, desc = "gitsigns select hunk" }
    )
end

return M
