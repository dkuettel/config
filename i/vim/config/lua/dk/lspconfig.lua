local M = {}

function M.setup()
    -- see https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
    vim.cmd("packadd cmp-nvim-lsp")
    vim.cmd("packadd cmp-nvim-lua")
    vim.cmd("packadd cmp-buffer")
    vim.cmd("packadd cmp-path")
    vim.cmd("packadd cmp-cmdline")
    vim.cmd("packadd LuaSnip") -- should that be here?
    vim.cmd("packadd cmp_luasnip")
    vim.cmd("packadd lspkind-nvim")

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
    local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
    M.setup_completion()

    M.setup_lua(capabilities)
    M.setup_python(capabilities)
end

function M.setup_completion()
    -- setup cmp
    -- from https://github.com/hrsh7th/nvim-cmp/#setup

    local cmp = require("cmp")

    vim.keymap.set("i", "<c-n>", cmp.complete)

    cmp.setup({
        completion = { autocomplete = false },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = {
            ["<c-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<c-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
            ["<c-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ["<c-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ["<enter>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        -- see https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
        -- TODO removed buffer as source, but still seems to be happening ...
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            -- TODO should not be here for most filetypes, ah but I think it does it itself
            { name = "nvim_lua" },
            --{name='buffer'},
        }),
        formatting = {
            format = require("lspkind").cmp_format({
                mode = "symbol_text",
                maxwidth = 50,
                menu = {
                    buffer = "[buffer]",
                    nvim_lsp = "[lsp]",
                    nvim_lua = "[lua]",
                },
            }),
        },
    })

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

    local function nmap(lhs, rhs)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr })
    end

    local function imap(lhs, rhs)
        vim.keymap.set("i", lhs, rhs, { buffer = bufnr })
    end

    vim.cmd([[
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        "autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    ]])

    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local D = vim.diagnostic
    nmap(",d", D.open_float)
    nmap("[d", D.goto_prev)
    nmap("]d", D.goto_next)
    nmap(",q", D.setloclist)

    -- Enable completion triggered by <c-x><c-o>
    -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- TODO that's probably newbish, read about omnifunc and stuff
    -- anyway to use it fuzzy? maybe compare with coc from yves? complete I like, not autocomplete probably
    --vim.keymap.set("i", "<c-n>", "<c-x><c-o>", {buffer=bufnr})

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local b = vim.lsp.buf
    nmap("gD", b.declaration)
    nmap("gd", b.definition)
    nmap("K", b.hover)
    nmap("gi", b.implementation)
    nmap("<c-k>", b.signature_help)
    imap("<c-k>", b.signature_help)
    nmap("gr", b.references)
    -- TODO not sure when to use lsp formatter and when to use a separate thing
    -- used to have sbdchd/neoformat and then it's clear what we use
    -- TODO make visual indication when formatting has been executed, or failed
    nmap("==", b.formatting_seq_sync)
    nmap(",ca", b.code_action)
    nmap(",rn", b.rename)
    nmap("gtd", b.type_definition)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
end

function M.setup_lua(capabilities)
    -- using sumneko https://github.com/sumneko
    -- alternative language server https://github.com/Alloyed/lua-lsp

    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    -- TODO does this the right thing? vim seems to resolve last match, but lua originally does first match?

    -- TODO probably that goes to individual config files or function, one per LSP?
    -- from https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
    require("lspconfig").sumneko_lua.setup({
        cmd = { os.getenv("HOME") .. "/bin/sumneko/bin/lua-language-server" },
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
        on_attach = M.mappings,
        capabilities = capabilities,
    })
end

function M.setup_python(capabilities)
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright

    -- https://github.com/microsoft/pyright
    -- sudo npm install -g pyright

    require("lspconfig").pyright.setup({
        on_attach = M.python_mappings,
        capabilities = capabilities,
        settings = {},
    })
end

function M.python_mappings()
    M.mappings()

    -- pyright, jedi, and language servers in general dont seem to index project symbols fullly qualified
    -- replace for python with pdocs instead of the original generic LSP call in lspconfig.lua
    -- TODO builtin.treesitter() could be adapted to make things fully qualified?

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- TODO function make_entry.gen_from_treesitter(opts) could be interesting for generic tags? if we collect parent identifiers

    local function pdocs_entry_maker(raw_line)
        local name, line, kind, file = string.match(raw_line, "^(.*)%z(.*)%z(.*)%z(.*)$")
        line = tonumber(line)
        return {
            value = { name = name, line = line, kind = kine, file = file },
            display = kind .. ": " .. name,
            ordinal = kind .. ": " .. name,
            path = file,
            lnum = line,
            col = 0,
        }
    end

    local function ptags(sources, opts)
        if not sources then
            -- TODO for now no ./.pdocs or ./.list-symbols, just try to discover things
            local Path = require("plenary.path")
            if Path:new("python"):is_dir() then
                sources = { "python" }
            else
                sources = { "." }
            end
        end
        local pdocs_command = {
            "ptags",
            "--out=-",
            "--fmt=vim-telescope",
            "--quiet",
            unpack(sources),
        }
        opts = opts or {}
        pickers.new(opts, {
            prompt_title = "ptags",
            finder = finders.new_oneshot_job(pdocs_command, {
                entry_maker = pdocs_entry_maker,
            }),
            -- attach_mappings = function(prompt_bufnr, map)
            --     actions.select_default:replace(function()
            --         actions.close(prompt_bufnr)
            --         local selection = action_state.get_selected_entry()
            --         -- print(vim.inspect(selection))
            --         vim.api.nvim_put({ selection[1] }, "", false, true)
            --     end)
            --     return true
            -- end,
            sorter = conf.generic_sorter(opts),
            -- see "~/config/i/vim/config/pack/plugins/opt/telescope.nvim/lua/telescope/builtin/lsp.lua" for config
            -- and "~/config/i/vim/config/pack/plugins/opt/telescope.nvim/lua/telescope/make_entry.lua" for display
            -- there is also some pre-sorter stuff, maybe for any->class->func and so on?
            -- and displayer stuff to make it aligned? or shorten? coloring?
            -- in general the lsp ones they wait for an answer from lsp before opening, fix?
            -- TODO I dont see the difference between the previewers here
            previewer = conf.grep_previewer(opts),
            -- previewer = conf.qflist_previewer(opts),
        }):find()
    end

    -- TODO long entries dont scroll left and right to the important parts, like fzf did?
    -- maybe use dropdown or so, with full width?

    vim.keymap.set("n", ",.", function()
        ptags({ vim.fn.expand("%") })
    end)
    vim.keymap.set("n", ",,", ptags)
end
        on_attach = M.mappings,
        capabilities = capabilities,
    })
end

return M
