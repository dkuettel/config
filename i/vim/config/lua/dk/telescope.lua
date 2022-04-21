local M = {}

function M.packer(use)
    use({
        -- https://github.com/nvim-telescope/telescope.nvim
        "nvim-telescope/telescope.nvim",
        commit = "1a72a92",
        -- https://github.com/nvim-lua/plenary.nvim
        requires = { "nvim-lua/plenary.nvim", commit = "0d66015" },
        setup = M.before,
        config = M.after,
    })

    -- done
    --
    -- https://github.com/BurntSushi/ripgrep
    -- installed using apt-get install ripgrep
    --
    -- https://www.nerdfonts.com/ for fonts, they are pretty nice and easy to get
    -- also https://github.com/ryanoasis/nerd-fonts
    -- so many, going for ubuntu mono with icons for now
    -- TODO they also seem to have some cool related projects, colorls, zsh theme, more ls stuff
    -- nvim-web-devicons needs it

    -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
    -- needs 'make' when installing/updating, it's in C
    -- faster, and allow fzf syntax in query window

    -- interesting extension eventually
    -- https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions#extensions-that-offer-telescope-integration-for-another-plugin

    -- https://github.com/nvim-treesitter/nvim-treesitter
    -- TODO needs :TSUpdate and probably specifically those languages that we want
    -- probably gonna have a file just for that, here it's just a dependency

    -- https://github.com/sharkdp/fd#installation
    -- optional dependency, but I'm not sure what we use it for
    -- TODO sudo apt install fd-find, install fdfind, they want you to alias it to fd
    -- maybe I should use it in find_files with find_command myself?
    -- it is supposed to be easier than find?
    -- can I make it smartly detect what project I'm in and use the right fdfind command?
    -- no more local files per project? pragmatic, but not scalable
    -- example: lua require("telescope.builtin").find_files({find_command={"fdfind", "-t", "f", ".", "lua"}})
    -- they also mention to use it with fzf as default for ctrl-T and similar
end

function M.setup()
    M.before()
    vim.cmd("packadd plenary.nvim")
    vim.cmd("packadd nvim-web-devicons")
    vim.cmd("packadd telescope-fzf-native.nvim")
    vim.cmd("packadd nvim-treesitter")
    vim.cmd("packadd telescope.nvim")
    M.after()
end

function M.before() end

function M.after()
    local telescope = require("telescope")

    local defaults = require("telescope.themes").get_dropdown()
    defaults.layout_config.width = function(_, max_columns, _)
        return math.min(max_columns, 120)
    end
    defaults.mappings = {
        i = {
            ["<c-j>"] = "move_selection_next",
            ["<c-k>"] = "move_selection_previous",
            ["<c-s>"] = "select_horizontal",
        },
    }
    defaults.path_display = { "truncate" }

    telescope.setup({
        defaults = defaults,
        extensions = {
            -- https://github.com/nvim-telescope/telescope-fzf-native.nvim#telescope-setup-and-configuration
            fzf = {},
        },
    })
    telescope.load_extension("fzf")

    local map = vim.keymap.set
    local bi = require("telescope.builtin")

    map("n", ",f", bi.find_files, { desc = "telescope find files" })
    map("n", ",g", bi.live_grep, { desc = "telescope live grep" })
    map("n", ",b", bi.buffers, { desc = "telescope buffers" })
    map("n", ",h", bi.help_tags, { desc = "telescope help tags" })
    map("n", ",m", bi.man_pages, { desc = "telescope man pages" })

    map("n", ",.", bi.lsp_document_symbols, {desc="telescope document symbols"})
    --map("n", ",.", bi.current_buffer_fuzzy_find) -- TODO cool when there is no LSP?
    --map("n", ",.", bi.treesitter) -- TODO other alternative if no LSP?
    -- TODO see https://github.com/nvim-telescope/telescope.nvim/pull/705
    map("n", ",,", bi.lsp_dynamic_workspace_symbols, {desc="telescope workspace symbols"})
end

return M
