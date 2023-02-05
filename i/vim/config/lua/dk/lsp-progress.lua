---global settings
--@type nil | { on_updates: function, interval_ms: number, log: boolean }
local settings = nil

---Is the lsp_progress_handler already registered with vim.lsp.handlers["$/progress"]?
--@type boolean
local handler_is_registered = false

---access like progress[client_id][token] -> percentage or nil
---@type table<integer, table<string, number>>
local client_progress = {}

---last on_update call from lsp_progress_handler
local last_update = nil

---scheduled update from vim.defer_fn -> vim.loop.new_timer()
local scheduled_update = nil

---log buffer id
---@type nil | integer
local log_buffer = nil

local function log_lsp_progress_reply(err, result, ctx, config)
    if log_buffer == nil then
        log_buffer = vim.api.nvim_create_buf(true, true)
    end
    vim.fn.appendbufline(log_buffer, "$", vim.inspect(err))
    vim.fn.appendbufline(log_buffer, "$", vim.inspect(result))
    vim.fn.appendbufline(log_buffer, "$", vim.inspect(ctx))
    vim.fn.appendbufline(log_buffer, "$", vim.inspect(config))
    vim.fn.appendbufline(log_buffer, "$", "")
end

local function update_progress(ctx, result)
    local client_id = ctx.client_id
    if client_progress[client_id] == nil then
        client_progress[client_id] = {}
    end
    local token = result.token
    local percentage = result.value.percentage -- nil when done
    client_progress[client_id][token] = percentage
end

local function maybe_callback()
    if settings.on_update == nil then
        return
    end
    if scheduled_update ~= nil then
        return
    end
    local wait_ms = settings.interval_ms - vim.fn.reltimefloat(vim.fn.reltime(last_update)) * 1000
    if wait_ms <= 0 then
        settings.on_update()
        last_update = vim.fn.reltime()
        return
    end
    scheduled_update = vim.defer_fn(function()
        settings.on_update()
        last_update = vim.fn.reltime()
        scheduled_update = nil
    end, settings.interval_ms)
end

---callback to update client_progress according to the lsp's reply
---see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#progress
---@diagnostic disable-next-line: unused-local
local function lsp_progress_handler(err, result, ctx, config)
    if settings.log then
        log_lsp_progress_reply(err, result, ctx, config)
    end
    update_progress(ctx, result)
    maybe_callback()
    if config.chain ~= nil then
        -- NOTE I think this is messed up with vims lsp handler handling
        -- is config part of the signature? then what I'm supposed to pass on?
        -- when I chain, I cannot know what was the intention
        -- plus vim.lsp.with seems to wrap anyway so why have it part of
        -- the signature to begin with?
        config.chain(err, result, ctx, {})
    end
end

---from all parallel progress, get the lowest one
---@param progress table<string, number>
---@return nil | number
local function get_lowest_percentage(progress)
    if progress == nil then
        return nil
    end
    local lowest_percentage = 101
    for _, percentage in pairs(progress) do
        lowest_percentage = math.min(lowest_percentage, percentage)
    end
    if lowest_percentage == 101 then
        return nil
    end
    return lowest_percentage
end

---nerdfont-style indicator of progress percentage
---@param percentage number
---@param icons string
---@return string
local function get_progress_icon(percentage, icons)
    local n = vim.fn.strcharlen(icons)
    local index = math.floor(0.5 + percentage / 100 * (n - 1))
    return vim.fn.strcharpart(icons, index, 1)
end

---turn progress percentage into an icon
---@param client_id integer
---@param theme table
---@return string
local function format_progress(client_id, theme)
    -- TODO not clear if client.id is unique and never reused
    local progress = client_progress[client_id]
    if progress == nil then
        return theme.idle
    end
    local percentage = get_lowest_percentage(progress)
    if percentage == nil then
        return theme.idle
    end
    return get_progress_icon(percentage, theme.progress)
end

---to sort by client name, increasing
local function compare_client_names(a, b)
    return a.name < b.name
end

---format all clients
---@param bufnr nil | integer
---@param theme table
---@return string
local function format(bufnr, theme)
    local clients = vim.lsp.get_active_clients { bufnr = bufnr }
    table.sort(clients, compare_client_names)
    local function format_client(client)
        if theme.name then
            return format_progress(client.id, theme) .. " " .. client.name
        else
            return format_progress(client.id, theme)
        end
    end
    local formatted = vim.tbl_map(format_client, clients)
    if theme.name then
        return vim.fn.join(formatted, " ")
    else
        return vim.fn.join(formatted, "")
    end
end

return { -- public interface

    -- NOTE there is also vim.lsp.buf.server_ready()
    -- it only indicates if the current buffer's lsps are responsive
    -- it doesnt mean they are not busy scanning or with other background tasks
    -- that means completion or diagnostic can still be out of date

    -- NOTE there is also vim.lsp.util.get_progress_messages
    -- but it's marked as private and not documented
    -- it seems to give messages since last call, so it's difficult to manage the side-effects
    -- plus it doesnt correctly aggregate and multiplex on the progress token from the lsp

    ---setup lsp-progress, can be called more than once to change settings
    ---the on_updates callback will be called when progress changes
    ---this callback is rate limited by interval_ms
    ---log is only for debugging the lsp messages, they will be written to a scratch buffer
    ---@param config { on_updates: function, interval_ms: number, log: boolean }
    setup = function(config)
        settings = vim.tbl_extend("keep", config or {}, { on_update = nil, interval_ms = 500, log = false })
        if not handler_is_registered then
            vim.lsp.handlers["$/progress"] = vim.lsp.with(
                lsp_progress_handler,
                { chain = vim.lsp.handlers["$/progress"] }
            )
            handler_is_registered = true
        end
    end,

    ---return something like " rust  lua" showing all lsp's progresses
    ---@param bufnr nil | integer
    ---@return string
    get_named_progress = function(bufnr)
        local theme = {
            name = true,
            progress = "",
            idle = "",
        }
        return format(bufnr, theme)
    end,

    ---return same as get_named_progress but without the names
    ---@param bufnr nil | integer
    ---@return string
    get_progress = function(bufnr)
        local theme = {
            name = false,
            progress = "",
            idle = "",
        }
        return format(bufnr, theme)
    end,

    ---return something like " rust  lua" showing all lsp's states
    ---@param bufnr nil | integer
    ---@return string
    get_named_state = function(bufnr)
        local theme = { name = true, progress = "", idle = "" }
        return format(bufnr, theme)
    end,

    ---return same as get_named_state but without the names
    ---@param bufnr nil | integer
    ---@return string
    get_state = function(bufnr)
        local theme = { name = false, progress = "", idle = "" }
        return format(bufnr, theme)
    end,
}
