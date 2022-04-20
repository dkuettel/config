local function setup(name)
    -- TODO wrap it an let it fail to still have a functional vim?
    return require("dk." .. name).setup
end

setup("basics")()

-- themes
-- TODO themes also try to set cursor colors, but my alacritty, tmux, or term vim doesnt react to that?
setup("gruvbox")("light") -- could gruvbox material be interesting?
-- setup("tender")()
-- setup("tokyonight")("dark")
-- setup("everforest")("light")
-- setup("tender")()
-- setup("nord")()
-- setup("solarized")("light")
-- setup("nightfox")("nordfox")

-- setup("auto-pairs")()
-- setup("vim-surround")()
setup("autosave")()
setup("treesitter")()
setup("telescope")()
setup("lualine")()
-- setup("coc")()
setup("null-ls")()
setup("lspconfig")()
setup("hop")()
setup("gitsigns")()
setup("comment")()
setup("neogit")()

-- TODO playing
setup("funky-format")()
vim.keymap.set("n", ",R", dofile("lua/dk/funky-format.lua").setup())

require("dk.basics").active_window()

-- TODO doesnt quite work I think because
-- a) doesnt reload "requires"
-- b) not sure if all plugin setup()s can be used more than once
-- vim.cmd("command! Reload source $MYVIMRC | echo 'config reloaded'")
-- vim.keymap.set("n", ",R", "<cmd>Reload<enter>")
