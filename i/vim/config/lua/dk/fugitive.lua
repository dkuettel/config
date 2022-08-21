local M = {}

function M.setup()
    -- https://github.com/tpope/vim-fugitive
    vim.cmd("packadd vim-fugitive")

    -- NOTE alternatives
    -- (see git history for lua/dk/neogit.lua)
    -- https://github.com/TimUntersberger/neogit but not very mature, yet?
    -- https://github.com/sindrets/diffview.nvim but only for viewing, not staging?

    vim.keymap.set("n", ",gs", ":tab Git<enter>")

    -- NOTE shortcuts to remember or maybe remap if easier to remember
    -- in summary git status overview
    -- < and > to open and close inline diffs (instead of =, remap tab to =?)
    -- s and u to stage and unstage (instead of -)
    -- i goes thru hunks (but doesnt center or scroll to top, remap?)
    -- J and K are similar to i for up and down (map to Jzt and Kzt?)

    -- TODO fugitive doesnt have good colors in summary overview, check my history, I think I adapted that before?
    -- sections not so easy to see, additions are good, removes look same color? make more gray?
    -- also the file of the current inline diff could be more prominent if possible
    -- for gruvbox https://github.com/morhetz/gruvbox#light-mode-1
    -- just trying, not very awesome
    --   diffLine is also for diff views, not just for the overvier
    --   fugitiveUnstagedSection leaks into other headers a bit
    vim.cmd([[
        highlight fugitiveUnstagedSection guibg=#d65d0e
        highlight diffLine guibg=#d79921
    ]])

    -- TODO generally fugitive has good mappings, read again and again before trying to fix things
    -- it also extends vims diffview a bit, same there before mapping stuff
    -- was thinking about < and > to put and get (dp and do)
end

return M
