local M = {}

function M.setup()
    -- see https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
    vim.cmd("packadd cmp-nvim-lsp")
    -- vim.cmd("packadd cmp-nvim-lua") -- not needed anymore because of neodev.vim
    vim.cmd("packadd cmp-buffer")
    vim.cmd("packadd cmp-path")
    vim.cmd("packadd cmp-cmdline")
    vim.cmd("packadd LuaSnip") -- should that be here?
    vim.cmd("packadd cmp_luasnip")
    vim.cmd("packadd lspkind-nvim")
    vim.cmd("packadd lsp_signature.nvim") -- could also be separate, like many others

    -- https://github.com/hrsh7th/nvim-cmp
    -- TODO used to have it on commit 272cbdc
    vim.cmd("packadd nvim-cmp")

    -- another option?
    -- https://github.com/ms-jpq/coq_nvim

    -- https://github.com/neovim/nvim-lspconfig
    -- TODO used to have it on tag v0.1.2 ?
    vim.cmd("packadd nvim-lspconfig")

    -- could be interesting to show more info from lsp
    -- https://github.com/nvim-lua/lsp-status.nvim

    -- TODO not sure why that is needed
    -- from https://github.com/hrsh7th/nvim-cmp/#setup
    -- that makes vim the client say it can accept more from the LS?
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    M.setup_luasnip()
    M.setup_completion()

    -- TODO can we control the characters used for warning and error markers?  and others instead?
    -- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.config()
    -- :Telescope diagnostics (?)
    vim.diagnostic.config {
        -- underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = {
            -- TODO https://neovim.io/doc/user/diagnostic.html#diagnostic-severity
            severity = { min = vim.diagnostic.severity.WARN },
            prefix = "", -- alternatives ﲑﲒﲕﲖ
            format = function(diagnostic)
                -- local icons = {"", "", "", ""}
                local icons = { "E", "W", "I", "H" }
                if diagnostic.code == nil then
                    return icons[diagnostic.severity] .. " " .. diagnostic.message
                else
                    return icons[diagnostic.severity] .. "/" .. diagnostic.code
                end
            end,
            -- TODO doesnt seem to disable, which signs are they? I want to change them
            -- signs = false,
            -- TODO doesnt seem to apply to open_float ...
            -- float = {
            --     prefix = function(diagnostics, i, total)
            --         return "somee: "
            --     end,
            -- },
            -- TODO not sure I see an effect either way, with false it was maybe flickery and out of date?
            update_in_insert = true,
            severity_sort = true, -- is it working?
            spacing = 0,
        },
    }
    -- TODO all hard-coded for https://github.com/morhetz/gruvbox#light-mode-1
    -- TODO or use the same icons as the lualine bottom right? lightbulb for hint, eg? trying
    vim.cmd([[
        highlight DiagnosticFloatingError guifg=#3c3836
        highlight DiagnosticVirtualTextError guifg=#bdae93
        highlight DiagnosticUnderlineError gui=undercurl guisp=#cc241d
        highlight DiagnosticSignError guifg=#cc241d
        " sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
        sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=

        highlight DiagnosticFloatingWarn guifg=#3c3836
        highlight DiagnosticVirtualTextWarn guifg=#bdae93
        highlight DiagnosticUnderlineWarn gui=undercurl guisp=#cc241d
        highlight DiagnosticSignWarn guifg=#cc241d
        " sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
        sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=

        highlight DiagnosticFloatingInfo guifg=#3c3836
        highlight DiagnosticVirtualTextInfo guifg=#bdae93
        highlight DiagnosticUnderlineInfo gui=underdotted guisp=#076678
        highlight DiagnosticSignInfo guifg=#076678
        " sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
        sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=

        highlight DiagnosticFloatingHint guifg=#3c3836
        highlight DiagnosticVirtualTextHint guifg=#bdae93
        highlight DiagnosticUnderlineHint gui=underdotted guisp=#076678
        highlight DiagnosticSignHint guifg=#076678
        " sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=
        sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=

        highlight LspSignatureActiveParameter gui=bold
    ]])

    M.setup_lua(capabilities)
    M.setup_python(capabilities)
    -- M.setup_python_jedi(capabilities)
    M.setup_rust(capabilities)

    -- TODO if this works well, maybe remove ctrl-K for insert mode?
    -- https://github.com/ray-x/lsp_signature.nvim#full-configuration-with-default-values
    require("lsp_signature").setup {
        hint_prefix = " ", -- alternatives 
    }
end

function M.setup_luasnip()
    -- see https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    ls.add_snippets("all", { s("!class", { t("class") }) })
end

function M.setup_completion()
    -- setup cmp
    -- from https://github.com/hrsh7th/nvim-cmp/#setup

    local cmp = require("cmp")

    vim.keymap.set("i", "<c-n>", cmp.complete, { desc = "completion" })

    -- TODO doesnt work, how to easily have the completion menu in normal mode? for autoimports?
    -- TODO this is probably very specific for python, and not yet robust either
    -- could we programatically go to insert mode, call complete, first element, and select?
    -- we expect to be in normal mode after that, so we have to do it directly
    -- we cannot wait, unless we can give an additional mapping into complete?
    -- cmp.complete() does accept config, and cmp.ContextReason?, but config is the same config
    -- where we can have a lot of control
    -- TODO this works, poc, could we have virtual text for the guess import?
    -- and then we just do ctrl-n in normal mode if we like that
    vim.keymap.set("n", "<c-n>", function()
        -- TODO we should go to the end of the word, plus one more character
        -- at least for params, not necessarily for vim
        -- TODO or instead we could use only the additionalTextEdits and ignore the current symbol edit
        -- but still, it looks like the proposals are better when done at the end of the symbol
        -- maybe there is an option fo the complete LSP call that gives a hint? no it doesnt
        local params = vim.lsp.util.make_position_params()
        local function handler(_, result, _, _)
            -- full signature: err, result, ctx, config
            for _, item in ipairs(result.items) do
                if item.detail == "Auto-import" then
                    vim.lsp.buf_request(0, "completionItem/resolve", item, function(_, result, ctx, _)
                        -- full signature: err, result, ctx, config
                        local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
                        if result.textEdit ~= nil then
                            vim.lsp.util.apply_text_edits({ result.textEdit }, 0, offset_encoding)
                        end
                        if result.additionalTextEdits ~= nil then
                            vim.lsp.util.apply_text_edits(result.additionalTextEdits, 0, offset_encoding)
                        end
                        if result.documentation ~= nil then
                            -- TODO used to be there always in my tests, but not anymore?
                            print(vim.split(result.documentation.value, "\n")[2])
                        else
                            vim.pretty_print(result)
                        end
                    end)
                    return
                end
            end
            print("Did not find any auto-import candidates.")
        end
        vim.lsp.buf_request(0, "textDocument/completion", params, handler)
    end, { desc = "auto-import" })

    cmp.setup {
        -- completion = { autocomplete = false },
        -- TODO definitely it seems very responsive, could have it in background always
        -- and only show on ctrl-n?
        -- or at least have it smaller, dont show 100 results! less flickery, just very few
        -- kinda only useful if the top match is right, so maybe instead to virtual text?
        -- and ctrl-n stays manual as it used to be? and tab is for ghost text
        -- plus autocomplete is nice, but maybe not in comments?
        -- check there was something that does virtual text completion for first hit I believe
        -- or an easy quick hack to test it is to hardcode in nvim-cmp the result list to 1 or 5 or so, see how it feels
        -- TODO with autocomplete tab is quite natural to execute it
        completion = {
            autocomplete = { cmp.TriggerEvent.InsertEnter, cmp.TriggerEvent.TextChanged },
            -- NOTE this makes it select the first entry
            -- including showing the doc, so you know what, eg, imports are considered
            completeopt = "menu,menuone",
        },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        -- TODO does lua do window.completion = {...}?
        window = {
            -- TODO btw, could we know the pid of the lsp and show the cpu usage for business?
            -- TODO hm wait max_height is only for documentation, not for completion :/ ?
            completion = vim.tbl_extend("force", cmp.config.window.bordered(), { max_height = 20 }),
            documentation = vim.tbl_extend("force", cmp.config.window.bordered(), { max_height = 20 }),
        },
        -- NOTE None no preselect, but we anyway preselect ourselves the first one
        -- Item preselects what the LSP says is the best, not sure if all LSP implement that
        preselect = cmp.PreselectMode.None,
        mapping = {
            ["<c-j>"] = cmp.mapping.select_next_item(),
            ["<c-k>"] = cmp.mapping.select_prev_item(),
            ["<c-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<c-e>"] = cmp.mapping.abort(),
            ["<c-n>"] = cmp.mapping.confirm { select = true },
            -- TODO tab, just like terminal, c-space a good idea?
            -- TODO tab especially very natural for cmp.complete_common_string() ?
        },
        -- see https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
        -- TODO removed buffer as source, but still seems to be happening ...
        sources = cmp.config.sources {
            { name = "nvim_lsp" },
            -- TODO should not be here for most filetypes, ah but I think it does it itself
            { name = "nvim_lua" },
            -- TODO start trying, and see how to work with or combine with iabbrev?
            { name = "luasnip" },
            --{name='buffer'},
        },
        formatting = {
            format = require("lspkind").cmp_format {
                mode = "symbol_text",
                maxwidth = 50,
                menu = {
                    buffer = "[buffer]",
                    nvim_lsp = "[lsp]",
                    nvim_lua = "[lua]",
                },
            },
        },
    }

    --[[ -- `/` cmdline setup.
    cmp.setup.cmdline("/", {
        sources = {
            { name = "buffer" },
        },
    })
    -- `:` cmdline setup.
    cmp.setup.cmdline(":", {
        -- TODO always these weird one-too-many tables? is this correct?
        -- difference between cmp.config.sources and just sources to tables?
        -- ah those are groups, and the first group that produces results gets it
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    }) ]]
end

---@diagnostic disable-next-line: unused-local
function M.mappings(client, bufnr)
    -- started with https://github.com/neovim/nvim-lspconfig#suggested-configuration

    -- TODO this is a window option, not buffer, not sure if the current window is active
    -- maybe just go for global setting, or do it with an autocommand if only for those?
    vim.api.nvim_win_set_option(0, "signcolumn", "yes")
    -- TODO some of the coc recommended setting make sense here? updatetime or something?

    local function nmap(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end

    local function imap(lhs, rhs, desc)
        vim.keymap.set("i", lhs, rhs, { buffer = bufnr, desc = desc })
    end

    vim.cmd([[
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        "autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    ]])

    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local D = vim.diagnostic
    -- TODO vim.diagnostic.config({float={...}}) should configer this, doesnt work for me
    nmap(",d", function()
        D.open_float {
            prefix = function(d, i, t)
                return vim.diagnostic.severity[d.severity] .. ": "
            end,
        }
    end, "diagnostics float")
    nmap("[d", D.goto_prev, "diagnostics previous")
    nmap("]d", D.goto_next, "diagnostics next")
    nmap(",q", D.setloclist, "diagnostics loclist")

    -- Enable completion triggered by <c-x><c-o>
    -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- TODO that's probably newbish, read about omnifunc and stuff
    -- anyway to use it fuzzy? maybe compare with coc from yves? complete I like, not autocomplete probably
    --vim.keymap.set("i", "<c-n>", "<c-x><c-o>", {buffer=bufnr})

    -- from looking at
    --   nvim/runtime/lua/vim/lsp/buf.lua
    --   nvim/runtime/lua/vim/lsp/handlers.lua
    --   nvim/runtime/lua/vim/lsp/util.lua
    -- all the lsp jumps are done async, but I need it sync
    -- and there is no option to control this
    -- I want: sync, optional splits or tabs before, move target line to the top (like "zt")
    local function lsp_jumper(method, before)
        -- methods
        --   textDocument/definition
        return function()
            local params = vim.lsp.util.make_position_params()
            local function handler(_, result, ctx, _)
                -- full signature: err, result, ctx, config
                local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding
                if vim.tbl_islist(result) then
                    -- TODO we only use the first result
                    -- like the original, it would be better to open quickfix with options?
                    result = result[1]
                end
                if before then
                    vim.cmd(before)
                end
                vim.lsp.util.jump_to_location(result, offset_encoding, false)
                vim.cmd("normal! zt")
            end
            -- TODO kinda works, but still async, user might get bored, switches buffer/windows, and then it gets weird
            vim.lsp.buf_request(0, method, params, handler)
        end
    end

    -- See `:help vim.lsp.*` for documentation on any of the functions below
    -- TODO for now disabled some, in python declartion vs definition vs implementation is not so meaningful
    -- TODO ? document_highlight() wanna try? also the type inferred higlights in alexis VC could be cool to try
    -- ? incoming_calls() *vim.lsp.buf.incoming_calls()*, and there is also outgoing_calls()
    -- server_ready() *vim.lsp.buf.server_ready()* better for the busy indicator?
    -- to make completion faster, is always-on good? or always-on, but only _show_ on demand, faster?
    -- the whole codeaction thing would be nice too, imports, fast and clear? auto shortcut for import?
    -- can we make signature help on every key, like enabled or disabled? so I see as I move from arg to arg?
    -- also can it be formatted more helpfully?
    local b = vim.lsp.buf

    nmap("gd", lsp_jumper("textDocument/definition"), "go to definition")
    nmap("gD", lsp_jumper("textDocument/definition", "tab split"), "go to definition in a new tab")
    nmap("gt", lsp_jumper("textDocument/definition", "tab split"), "go to definition in a new tab")
    nmap("gv", lsp_jumper("textDocument/definition", "vsplit"), "go to definition in a new tab")
    nmap("gs", lsp_jumper("textDocument/definition", "split"), "go to definition in a new tab")

    nmap("K", b.hover, "hover symbol")
    -- nmap("gi", b.implementation, "go to implementation")
    nmap("<c-k>", b.signature_help, "signature help")
    imap("<c-k>", b.signature_help, "signature help")
    nmap("gr", b.references, "find references")
    -- TODO not sure when to use lsp formatter and when to use a separate thing
    -- used to have sbdchd/neoformat and then it's clear what we use
    -- TODO make visual indication when formatting has been executed, or failed
    -- nmap("==", b.formatting_seq_sync, "format using lsp") -- trying funky-formatter
    nmap(",ca", b.code_action, "code action")
    nmap(",rn", b.rename, "rename symbol")
    -- nmap("gtd", b.type_definition, "go to type definition")
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

    -- TODO do it on every keypress in insert mode
    -- or after every reply from the server only? max speed
    -- hl-LspSignatureActiveParameter should show the current param, just not set for me?
    -- generally, go for state-based, sig on, compl on? and then it stays on, until you disable it
    -- right now, signatures disappears as soon as you type
    -- vim.api.nvim_create_autocmd({ "TextChangedI" }, {
    --     desc = "signature",
    --     callback = function()
    --         local params = vim.lsp.util.make_position_params()
    --         local function sig(err, result, ctx, config)
    --             vim.pretty_print(result)
    --         end
    --         -- vim.lsp.buf_request(0, "textDocument/signatureHelp", params, sig)
    --         vim.lsp.buf_request(0, "textDocument/signatureHelp", params, vim.lsp.handlers.signature_help)
    --         -- this works, but it moves, plus it doesnt highlight the current parameter still
    --         -- TSHighlight... thing doesnt give any highlight groups, not sure if it would though in this window
    --         -- there is highlighting obviously, but not hl groups
    --     end,
    -- })
end

local function get_sumneko_lua_settings_neodev()
    -- NOTE sumneko will not complain for wrong keys or value, it just ignores them
    return {
        Lua = {
            runtime = {
                -- I dont know why "Lua 5.1" needs a number, but "LuaJIT" doesnt
                -- https://api7.ai/learning-center/openresty/luajit-vs-lua says LuaJIT is 5.1 syntax (?)
                version = "LuaJIT",
            },
            workspace = {
                ignoreDir = {}, -- uses gitignore grammar, files or dirs
                ignoreSubmodules = false,
                maxPreload = 10000, -- count
                preloadFileSize = 50000, -- kb
                useGitIgnore = true,
                userThirdParty = {}, -- what is the difference here? also it says absolute path
                checkThirdParty = false, -- TODO not sure, but it always pops up
            },
            telemetry = {
                enable = false,
            },
            -- see https://github.com/sumneko/lua-language-server/wiki/Settings
            completion = {
                -- NOTE could be okay to enable
                showWord = "Disable",
                whorkspaceWord = false,
            },
            diagnostics = {
                -- globals = { "vim" },  -- TODO neodev does it?
                workspaceDelay = 1000,
                workspaceEvent = "OnChange",
            },
            format = {
                enable = false,
            },
            hint = {
                -- TODO doesnt work, nvim lsp problem instead? inline hints?
                -- or is it meant to be seen only in shift-k mode? hover?
                enable = true,
                arrayIndex = "Enable",
                setType = true,
            },
            -- TODO enabled by default, but does nvim do it?
            -- semantic coloring
            -- semantic = {
            --     enable=true,
            -- }
        },
    }
end

function M.setup_lua(capabilities)
    -- using sumneko https://github.com/sumneko
    -- alternative language server https://github.com/Alloyed/lua-lsp (looks unfinished and inactive)

    -- see https://github.com/folke/neodev.nvim
    -- sets up things for neovim lua development
    vim.cmd("packadd neodev.nvim")
    require("neodev").setup {}

    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
    require("lspconfig").sumneko_lua.setup {
        cmd = { vim.fn.expand("~/bin/sumneko/bin/lua-language-server") },
        -- see https://github.com/sumneko/lua-language-server/wiki/Configuration-File
        settings = get_sumneko_lua_settings_neodev(),
        on_attach = M.mappings,
        capabilities = capabilities,
    }
end

function M.manual_lua()
    -- TODO not working, just trying to figure it out

    if M.client_id ~= nil then
        vim.lsp.buf_detach_client(M.manual_lua_buffer_id, M.manual_lua_client_id)
        vim.lsp.stop_client(M.manual_lua_client_id)
        M.manual_lua_client_id = nil
    end

    local binary = vim.fn.expand("~/bin/sumneko/bin/lua-language-server")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local paths = {} -- runtime.path
    local lpaths = {} -- workspace.library
    for _, p in ipairs(vim.api.nvim_list_runtime_paths()) do
        table.insert(paths, p .. "/lua/?.lua")
        table.insert(paths, p .. "/lua/?/init.lua")
        table.insert(lpaths, p .. "/lua")
    end
    -- TODO package.path has strange paths in it, not sure I should use them

    local settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                pathStrict = true,
                path = paths,
            },
            workspace = {
                library = lpaths,
                ignoreDir = {}, -- uses gitignore grammar, files or dirs
                ignoreSubmodules = false,
                maxPreload = 10000, -- count
                preloadFileSize = 50000, -- kb
                useGitIgnore = true,
                userThirdParty = {}, -- what is the difference here? also it says absolute path
                checkThirdParty = false, -- TODO not sure, but it always pops up
            },
            telemetry = {
                enable = false,
            },
            completion = {
                showWord = "Disable",
                whorkspaceWord = false,
            },
            diagnostics = {
                globals = { "vim" },
                workspaceDelay = 1000,
                workspaceEvent = "OnChange",
            },
            format = {
                enable = false,
            },
            hint = {
                enable = true,
                arrayIndex = "Enable",
                setType = true,
            },
        },
    }

    local function ws(path)
        return {
            name = path,
            uri = "file://" .. path,
        }
    end

    local client_id = vim.lsp.start_client {
        cmd = {
            binary,
            -- NOTE configpath needs an absolute path
            -- "--configpath=/home/dkuettel/config/i/vim/config/config.lua",
            -- "--logpath=/home/dkuettel/Downloads/lua-logs",
            -- "--loglevel=trace",
        },
        -- cmd_cwd = "/home/dkuettel/config/i/vim/config/test",
        -- just to make sure there is nothing
        cmd_cwd = "/home/dkuettel/config/i/vim/config/cwd",
        cmd_env = {},
        -- NOTE workspace only controls what files are considered worthy of producing diagnosis for to the user
        -- other files are scanned as needed to make that diagnosis
        workspace_folders = {
            ws("/home/dkuettel/config/i/vim/config/test"),
            -- ws("/home/dkuettel/config/i/vim/config/test2"),
            -- ws("/home/dkuettel/config/i/vim/config/lua"),
            -- ws("/home/dkuettel/config/i/vim/config/pack/plugins/opt/nvim-lspconfig/lua"),
        },
        capabilities = capabilities,
        handlers = vim.lsp.handlers, -- TODO copy or shared?
        -- TODO not sure if sent, or only if server asks
        -- try --configpath to be sure for the moment?
        settings = settings,
        -- init_options={}, -- TODO check spec
        name = "sumneko_lua",
        on_attach = M.mappings,
        -- TODO needed?
        -- offset_encoding
        -- on_error
        -- before_init
        -- on_init
        -- on_exit
    }

    vim.lsp.buf_attach_client(M.manual_lua_buffer_id, client_id)

    M.manual_lua_client_id = client_id

    -- TODO notes/problems/findings
    -- lua-language-server does not complain for anything, it just ignores any setting or arg that it doesnt like
    -- often it doesnt accept relative paths and doesnt complain, just ignores :/
    -- root_dir and workspace_folders only control what files are considered when reporting problems
    -- other files are still scanned to understand typing information and require()s
    -- runtime.path supposed to only matter for requires(), but I dont see completions
    -- workspace.library not sure what part it covers
    -- but I need things in both runtime.path and workspace.library to actually complete
    -- (require still doesnt complete, but rest is typed once included)
    -- see vim.lsp.buf.list_workspace_folders()
end

-- for when testing manual_lua
M.manual_lua_buffer_id = 1 -- the one buffer with some lua cod
M.manual_lua_client_id = nil -- previous client, to stop when retrying

function M.setup_python(capabilities)
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
    -- https://github.com/microsoft/pyright

    require("lspconfig").pyright.setup {
        on_attach = M.python_mappings,
        capabilities = capabilities,
        -- root_dir = function(startpath)
        --     return vim.fn.getcwd()
        -- end,
        -- NOTE this is part of the LS protocol, sending changes to the configuration
        -- it will be sent as a request, not part of the command line
        -- but I think it's parallel to config files like pyrightconfig.json (?)
        -- it notifies the LS that we want something changed there
        -- lspconfig has some defaults here, is that smart? doesnt that overwrite a config file?
        -- also, 2 out of 3 lspconfig defaults I cannot find anymore in the documentation of pyright
        -- https://github.com/microsoft/pyright/blob/main/docs/settings.md , not sure if that is really part of the config file
        settings = {},
    }
end

function M.python_mappings(client, bufnr)
    M.mappings(client, bufnr)

    -- pyright, jedi, and language servers in general dont seem to index project symbols fully qualified
    -- replace for python with pdocs instead of the original generic LSP call in lspconfig.lua
    -- TODO builtin.treesitter() could be adapted to make things fully qualified?

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    -- TODO function make_entry.gen_from_treesitter(opts) could be interesting for generic tags? if we collect parent identifiers. and faster than the lsps probably, with fully qualified elements

    local kinds = { ["function"] = " func", ["variable"] = "  var", ["class"] = "class" }
    local function pdocs_entry_maker(raw_line)
        local name, line, kind, file = string.match(raw_line, "^(.*)%z(.*)%z(.*)%z(.*)$")
        line = tonumber(line)
        kind = kinds[kind]
        if not kind then
            kind = "???"
        end
        local display = kind .. ": " .. name
        return {
            value = { name = name, line = line, kind = kind, file = file },
            display = display,
            ordinal = display,
            path = file,
            lnum = line,
            col = 0,
        }
    end

    local function ptags_from_command(cmd, opts)
        opts = opts or {}
        pickers.new(opts, {
            prompt_title = "ptags",
            finder = finders.new_oneshot_job(cmd, {
                entry_maker = pdocs_entry_maker,
            }),
            sorter = conf.generic_sorter(opts),
            previewer = conf.grep_previewer(opts),
        }):find()
    end

    local function ptags(sources, opts)
        if sources == nil and vim.fn.filereadable("./.vim-ptags-telescope") == 1 then
            ptags_from_command({ "./.vim-ptags-telescope" }, opts)
            return
        end
        if sources == nil then
            -- guess some source locations
            sources = {
                vim.fn.glob("python", false, true) or { "." },
                vim.fn.glob("libs/*/python", false, true),
            }
            sources = vim.tbl_flatten(sources)
        end
        local cmd = {
            "ptags",
            "--format=telescope",
            unpack(sources),
        }
        ptags_from_command(cmd, opts)
    end

    -- TODO long entries dont scroll left and right to the important parts, like fzf did?
    -- maybe use dropdown or so, with full width?

    vim.keymap.set("n", ",.", function()
        ptags { vim.fn.expand("%") }
    end, { buffer = bufnr, desc = "ptags local symbols" })
    vim.keymap.set("n", ",,", ptags, { buffer = bufnr, desc = "ptags workspace symbols" })
end

function M.setup_python_jedi(capabilities)
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jedi_language_server
    -- pip installed https://github.com/pappasam/jedi-language-server
    -- TODO pff same useless workspace symbol search
    require("lspconfig").jedi_language_server.setup {
        on_attach = M.mappings,
        capabilities = capabilities,
    }
end

function M.setup_rust(capabilities)
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    -- https://rust-analyzer.github.io/manual.html

    require("lspconfig").rust_analyzer.setup {
        on_attach = M.mappings,
        capabilities = capabilities,
        -- TODO https://rust-analyzer.github.io/manual.html#rustup
        cmd = { "rustup", "run", "stable", "rust-analyzer" },
        settings = {
            -- TODO copied from https://rust-analyzer.github.io/manual.html#nvim-lsp
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                procMacro = {
                    enable = true,
                },
            },
        },
    }
end

return M
