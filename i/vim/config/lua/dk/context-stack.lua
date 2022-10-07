local M = {}

local base = { ".", "contexts" }
local current_context = {}

local function get_paths(context)
    local folder = {}
    vim.list_extend(folder, base)
    vim.list_extend(folder, context)
    local file = {}
    vim.list_extend(file, base)
    vim.list_extend(file, context)
    vim.list_extend(file, { "Session.vim" })
    return table.concat(folder, "/"), table.concat(file, "/")
end

local function save(context)
    local folder, file = get_paths(context)
    -- TODO make sure parent folders exist
    -- TODO default mksession and sourcing might do too much (like restore global key mappings)
    vim.fn.system({ "mkdir", "-p", folder })
    vim.cmd("mksession! " .. file)
end

local function load(context)
    local _, file = get_paths(context)
    vim.cmd("source " .. file)
end

local function delete(context)
    local _, file = get_paths(context)
    -- TODO but we can only delete leaves?
    -- or should it drop all below? or disconnect a tree?
    vim.fn.system({ "rm", file })
end

function M.push(name)
    -- TODO often we want to start clean, or just with one new buffer, the current one, close all other?
    save(current_context)
    -- TODO name should not exist yet (path)
    table.insert(current_context, name)
    save(current_context)
end

function M.pop()
    delete(current_context)
    table.remove(current_context)
    load(current_context)
end

function M.up()
    save(current_context)
    table.remove(current_context)
    load(current_context)
end

function M.jump(context)
    save(current_context)
    current_context = context
    load(current_context)
end

function M.list()
    local found = vim.fn.systemlist("cd " .. table.concat(base, "/") .. "; find . -name Session.vim")
    local contexts = {}
    for i = 1, #found do
        local context = vim.split(found[i], "/")
        table.remove(context, 1)
        table.remove(context)
        table.insert(contexts, context)
    end
    return contexts
end

function M.setup()
    vim.api.nvim_create_user_command("Cpush", function(cmd)
        M.push(cmd["args"][1] or "unnamed")
    end, { nargs = 1, desc = "push context" })
    vim.api.nvim_create_user_command("Cpop", M.pop, { nargs = 0, desc = "pop context" })
    vim.api.nvim_create_user_command("Cup", M.up, { nargs = 0, desc = "one context up" })
    vim.api.nvim_create_user_command("Cjump", function(cmd)
        M.jump(cmd["args"])
    end, { nargs = "+", desc = "jump to any context" })
    vim.api.nvim_create_user_command("Clist", function()
        vim.pretty_print(M.list())
    end, { nargs = 0, desc = "list all contexts" })
end

return M
