local M = {}

function M.setup()
    vim.cmd("packadd plenary.nvim")

    -- https://github.com/sindrets/diffview.nvim
    -- has much to offer independent of neogit
    -- TODO but I dont know yet how to use it to stage stuff, craft commits
    -- TODO in a video or picture the filename included [index] or so to know what is what, I dont see it, because of lualine?
    vim.cmd("packadd diffview.nvim")
    require("diffview").setup({
        file_panel = {
            position = "right",
            listing_style = "tree",
        },
    })

    -- https://github.com/TimUntersberger/neogit
    -- before I used https://github.com/tpope/vim-fugitive
    vim.cmd("packadd neogit")
    local neogit = require("neogit")
    neogit.setup({
        signs = {
            section = { "", "" },
            item = { "", "" },
            hunk = { "", "" },
        },
        integrations = { diffview = true },
        disable_commit_confirmation = true,
        disable_builtin_notifications = true,
        disable_insert_on_commit = false,
        sections = { recent = { folded = false } },
    })
    vim.keymap.set("n", ",GG", neogit.open, { desc = "neogit open" })
end

return M
