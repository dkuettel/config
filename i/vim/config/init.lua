-- break up into mappings and theme stuff?
require("dk.basics").config()

local themes = {
    s = "solarized",
    tn = "tokyonight",
    gb = "gruvbox",
    e = "everforest",
    -- other options
    -- maybe see https://vimcolorschemes.com/
    -- https://github.com/LunarVim/Colorschemes
    -- https://github.com/LunarVim/onedarker.nvim
    -- https://github.com/LunarVim/darkplus.nvim
    -- https://github.com/sainnhe/edge
    -- https://github.com/sainnhe/sonokai
}

-- TODO basics would fit here the same as the others
-- more generic, and still indiviually usable
local configs = {
    themes.tn,
    -- "auto-pairs",
    -- "vim-surround",
    "autosave",
    "telescope",
    "lualine",
    -- "coc",
    "null-ls",
    "lspconfig",
    "hop",
    "gitsigns",
    "comment",
    "neogit",
}
-- TODO above rename into more general names instead of plugin names?
-- sometimes it includes a set of plugins to make something happen, like git-handling

-- TODO make it so that it continues if one fails
for _, config in ipairs(configs) do
    require("dk." .. config).setup()
end
-- require("dk.basics").active_window()

-- TODO doesnt quite work I think because
-- a) doesnt reload "requires"
-- b) not sure if all plugin setup()s can be used more than once
vim.cmd("command! Reload source $MYVIMRC | echo 'config reloaded'")
vim.keymap.set("n", ",R", "<cmd>Reload<enter>")
