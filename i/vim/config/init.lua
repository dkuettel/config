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

local function setup(name)
    -- TODO wrap it an let it fail to still have a functional vim?
    return require("dk." .. name).setup
end

setup("basics")()
setup(themes.gb)()
-- setup("auto-pairs")()
-- setup("vim-surround")()
setup("autosave")()
setup("telescope")()
setup("lualine")()
-- setup("coc")()
setup("null-ls")()
setup("lspconfig")()
setup("hop")()
setup("gitsigns")()
setup("comment")()
setup("neogit")()
-- require("dk.basics").active_window()

-- TODO doesnt quite work I think because
-- a) doesnt reload "requires"
-- b) not sure if all plugin setup()s can be used more than once
vim.cmd("command! Reload source $MYVIMRC | echo 'config reloaded'")
vim.keymap.set("n", ",R", "<cmd>Reload<enter>")
