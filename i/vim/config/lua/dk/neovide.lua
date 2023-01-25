local M = {}

local function setup_neovide()
    -- vim.go.guifont = "UbuntuMono Nerd Font Mono:h13"  -- no ligatures
    vim.go.guifont = "FiraCode Nerd Font Mono:h13" -- with ligatures
    vim.g.neovide_scale_factor = 1.0
    -- vim.g.neovide_cursor_vfx_mode = "railgun"  # default is ""
    -- vim.g.neovide_scroll_animation_length = 1.0  # default is 0.3
    vim.o.winblend = 30
    vim.go.pumblend = 30

    if os.getenv("vim_is_flip_flopping") == "yes" then
        vim.g.neovide_fullscreen = true
        vim.cmd("autocmd VimLeave * execute 'mksession! flip-flop.vim'")
        vim.cmd("autocmd SessionLoadPost * ++once execute 'silent !rm flip-flop.vim'")
    end

    vim.api.nvim_create_user_command("NeovideToggleFullscreen", function()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
    end, { nargs = 0 })
end

local function cmd_neovide()
    vim.cmd("mksession! flip-flop.vim")
    -- NOTE we set wm-class to make it floating
    -- and use 'let g:neovide_fullscreen = v:true' inside neovide to make it "modal"
    -- however, other options are:
    -- - tile it like normal, let the user decide, maybe monocle, or move
    -- - use "--maximized" but it doesnt seem to work in dwm
    -- note that a floating window is always on top, so not so nice to switch
    local cmd = {
        "neovide",
        "--nofork",
        "--multigrid",
        "--x11-wm-class",
        "neovide-flip-flop",
        "--",
        "-S",
        "flip-flop.vim",
    }
    local job_id = vim.fn.jobstart(cmd, { env = { vim_is_flip_flopping = "yes" } })
    vim.fn.jobwait({ job_id })
    vim.cmd("source flip-flop.vim")
    vim.fn.system("rm flip-flop.vim")
end

local function setup_vim()
    vim.api.nvim_create_user_command("Neovide", cmd_neovide, { nargs = 0 })
end

function M.setup()
    if vim.g.neovide then
        setup_neovide()
    else
        setup_vim()
    end
end

return M
