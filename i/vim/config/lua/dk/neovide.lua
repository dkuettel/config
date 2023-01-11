local M = {}

function M.setup()
    if not vim.g.neovide then
        return
    end

    -- TODO ubuntu nerdfont has no ligatures, firacode has
    -- and others
    -- vim.go.guifont = "UbuntuMono Nerd Font Mono:h15"
    -- TODO revisit font installation, just get all? versioned?
    vim.go.guifont = "FiraCode Nerd Font Mono:h12"
    -- test ligatures: -> != >=
    vim.g.neovide_scale_factor = 1.0
    -- vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.o.winblend = 30
    vim.go.pumblend = 30
end

return M
