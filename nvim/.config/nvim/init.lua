vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
require('config.opts')

local gh = function(x) return 'https://github.com/' .. x end


-- catppuccin --
vim.pack.add({ { src = gh('catppuccin/nvim'), name = 'catppuccin' } })
vim.cmd.colorscheme('catppuccin-nvim')


-- vim-tmux-navigator --
vim.pack.add({gh('christoomey/vim-tmux-navigator')})


-- LSP --
vim.pack.add({gh('neovim/nvim-lspconfig')})
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('lua_ls')

vim.filetype.add({
    extension = {
        sage = 'python'
    }
})
vim.lsp.config('ruff', {
    filetypes = {
        'python', 'sage'
    },
    settings = {
        extend_include = {'*.sage'},
        extension = {
            sage = 'python'
        }
    }
})
vim.lsp.enable('ruff')

-- Rename the variable under your cursor.
--  Most Language Servers support renaming across files, etc.
vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })

-- Execute a code action, usually your cursor needs to be on top of an error
-- or a suggestion from your LSP for this to activate.
vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, { desc = '[G]oto Code [A]ction' })

-- WARN: This is not Goto Definition, this is Goto Declaration.
--  For example, in C this would take you to the header.
vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration'})

vim.keymap.set('n', '<leader>th', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, { desc = '[T]oggle Inlay [H]ints' })

vim.keymap.set('n', '<leader>tc', function()
    vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = 0 }))
end, { desc = '[T]oggle [C]odelens' })

vim.cmd[[set completeopt+=menuone,noselect,popup]]
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    -- if client:supports_method('textDocument/implementation') then
    --   -- Create a keymap for vim.lsp.buf.implementation ...
    -- end

    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
    end

    -- Auto-format ('lint') on save.
    -- Usually not needed if server supports 'textDocument/willSaveWaitUntil'.
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})


-- oil.nvim --
vim.pack.add({gh('stevearc/oil.nvim')})
require('oil').setup()
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })


-- telescope.nvim --
vim.pack.add({gh('nvim-lua/plenary.nvim'), gh('nvim-telescope/telescope.nvim')})
local telescope = require('telescope')
pcall(telescope.load_extension, 'fzf')
pcall(telescope.load_extension, 'ui-select')

--- telescope keymaps ---
--- See `:help telescope.builtin` ---
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', telescope_builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', telescope_builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', telescope_builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', telescope_builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', telescope_builtin.buffers, { desc = '[ ] Find existing buffers' })

-- Find references for the word under your cursor.
vim.keymap.set('n', 'grr', telescope_builtin.lsp_references, { desc = '[G]oto [R]eferences' })

-- Jump to the implementation of the word under your cursor.
--  Useful when your language has ways of declaring types without an actual implementation.
vim.keymap.set('n', 'gri', telescope_builtin.lsp_implementations, { desc = '[G]oto [I]mplementation' })

-- Jump to the definition of the word under your cursor.
--  This is where a variable was first declared, or where a function is defined, etc.
--  To jump back, press <C-t>.
vim.keymap.set('n', 'grd', telescope_builtin.lsp_definitions, { desc = '[G]oto [D]efinition' })

-- Fuzzy find all the symbols in your current document.
--  Symbols are things like variables, functions, types, etc.
vim.keymap.set('n', 'gO', telescope_builtin.lsp_document_symbols, { desc = 'Open Document Symbols' })

-- Fuzzy find all the symbols in your current workspace.
--  Similar to document symbols, except searches over your entire project.
vim.keymap.set('n', 'gW', telescope_builtin.lsp_dynamic_workspace_symbols, { desc = 'Open Workspace Symbols' })

-- Jump to the type of the word under your cursor.
--  Useful when you're not sure what type a variable is and you want to see
--  the definition of its *type*, not where it was *defined*.
vim.keymap.set('n', 'grt', telescope_builtin.lsp_type_definitions, { desc = '[G]oto [T]ype Definition' })

