local M = {}

function M.setup()
    -- https://github.com/lewis6991/gitsigns.nvim
    -- before I used https://github.com/airblade/vim-gitgutter
    vim.cmd("packadd gitsigns.nvim")
    require("gitsigns").setup({
        signs = {
            -- add = { text = "" },
            -- change = { text = "" },
            -- delete = { text = "ﲐ" },
            -- topdelete = { text = "ﲓ" },
            -- changedelete = { text = "" },
        },
        on_attach = M.on_attach,
    })
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
    end, { expr = true })

    map("n", "[", function()
        if vim.wo.diff then
            return "[c"
        end
        vim.schedule(function()
            gs.prev_hunk()
        end)
        return "<Ignore>"
    end, { expr = true })

    -- Actions
    map({ "n", "v" }, "s", ":Gitsigns stage_hunk<CR>")
    map({ "n", "v" }, "r", ":Gitsigns reset_hunk<CR>")
    map("n", "S", gs.stage_buffer)
    map("n", "u", gs.undo_stage_hunk)
    map("n", "R", gs.reset_buffer)
    map("n", "p", gs.preview_hunk)
    map("n", "b", function()
        gs.blame_line({ full = true })
    end)
    map("n", "tb", gs.toggle_current_line_blame)
    map("n", "d", gs.diffthis)
    map("n", "D", function()
        gs.diffthis("~")
    end)
    map("n", "d", gs.toggle_deleted)

    -- Text object
    vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr })
end

return M
