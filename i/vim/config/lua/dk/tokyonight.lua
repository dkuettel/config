local M = {}

function M.packer(use)
    use({
        -- https://github.com/folke/tokyonight.nvim
        "folke/tokyonight.nvim",
        commit = "8223c97",
        setup = M.before,
        config = M.after,
    })
end

function M.setup()
    M.before()
    vim.cmd("packadd tokyonight.nvim")
    M.after()
end

function M.before()
    vim.opt.termguicolors = true
end

function M.after()
    local variant = { "dark", "storm" }
    -- local variant = {'dark', 'night'}
    -- local variant = {'light', 'day'}
    vim.opt.background, vim.g.tokyonight_style = unpack(variant)

    vim.g.tokyonight_day_brightness = 0.3

    vim.cmd("colorscheme tokyonight")
end

return M
