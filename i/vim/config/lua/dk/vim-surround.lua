-- https://github.com/tpope/vim-surround
-- some nice operators to work with pairs
-- like 'S)' to surround a visual selection
-- plus much more
local M = {}

function M.packer(use)
    use {
        "tpope/vim-surround",
        commit = "baf89ad",
    }
end

return M
