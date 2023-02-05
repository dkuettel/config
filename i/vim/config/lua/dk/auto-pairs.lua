-- https://github.com/jiangmiao/auto-pairs
local M = {}

function M.packer(use)
    use {
        "jiangmiao/auto-pairs",
        commit = "39f06b8",
        setup = M.setup,
    }
end

function M.setup()
    -- inserts closing pairs and also skips over closing pairs
    -- TODO there is a good chance for my subset it could be done with just mappings
    vim.g.AutoPairsShortcutToggle = ""
    vim.g.AutoPairsShortcutFastWrap = ""
    vim.g.AutoPairsShortcutJump = ""
    vim.g.AutoPairsMapBS = 0
    vim.g.AutoPairsMapCh = 0
    -- conflicts with iabbrev because it remaps <enter>
    -- but probably would make indentation better when hitting enter?
    vim.g.AutoPairsMapCR = 0
    vim.g.AutoPairsCenterLine = 0
    vim.g.AutoPairsShortcutBackInsert = ""
    vim.g.AutoPairsMoveCharacter = ""
end

return M
