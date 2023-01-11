local function setup(name)
    -- TODO wrap it an let it fail to still have a functional vim?
    -- maybe reloading could sometimes work when using dofile instead of require?
    return require("dk." .. name).setup
end

local function load()
    setup("basics")()
    setup("neovide")()

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
    -- setup("null-ls")()  -- trying funky-formatter for now
    setup("lspconfig")()
    setup("hop")()
    setup("gitsigns")()
    setup("comment")()
    setup("fugitive")()
    setup("indent-blankline")()
    setup("funky-formatter")()
    setup("funky-contexts")()

    require("dk.basics").active_window()
end

load()
