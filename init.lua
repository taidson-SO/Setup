-- Instalação de plugins usando Vim-Plug
vim.cmd [[
call plug#begin('~/.config/nvim/plugged')

" PlantUML Previewer Plugin
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim'
Plug 'aklt/plantuml-syntax'

" Plugin para autocompletar
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Suporte a LSP (para lint e autoindentação)
Plug 'neovim/nvim-lspconfig'

" Suporte para Python
Plug 'vim-python/python-syntax'

" Suporte para Rust
Plug 'rust-lang/rust.vim'

" Suporte para HTML5
Plug 'othree/html5.vim'

" Suporte para Java (usando jdtls)
Plug 'neovim/nvim-lspconfig'

" Suporte para Node.js e JavaScript
Plug 'HerringtonDarkholme/yats.vim'

" Suporte para Ruby
Plug 'vim-ruby/vim-ruby'

" Emmet para HTML/CSS
Plug 'mattn/emmet-vim'

" Plugin de navegação por diretórios
Plug 'kyazdani42/nvim-tree.lua'

" Plugin para gerenciar sessões
Plug 'rmagatti/auto-session'

" Plugin para statusline (opcional)
Plug 'nvim-lualine/lualine.nvim'

" Plugin Telescope para fuzzy finding
Plug 'nvim-telescope/telescope.nvim'

" Dependência do Telescope
Plug 'nvim-lua/plenary.nvim'

" Tema Gruvbox
Plug 'morhetz/gruvbox'

call plug#end()
]]

-- Certifique-se de adicionar 'localoptions' ao 'sessionoptions'
vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,localoptions"

-- Ativa o suporte ao clipboard
vim.o.clipboard = "unnamedplus"

-- Mapeamentos para navegação no popup de autocompletar
vim.api.nvim_set_keymap('i', '<TAB>', 'pumvisible() ? "\\<C-n>" : "\\<TAB>"', { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-TAB>', 'pumvisible() ? "\\<C-p>" : "\\<S-TAB>"', { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<CR>', 'pumvisible() ? "\\<C-y>" : "\\<CR>"', { noremap = true, expr = true, silent = true })

-- Extensões globais do Coc.nvim
vim.g.coc_global_extensions = {
  'coc-python', 'coc-html', 'coc-tsserver', 'coc-java', 'coc-rust-analyzer', 'coc-solargraph', 'coc-emmet'
}

local lspconfig = require('lspconfig')

-- Configurações LSP
lspconfig.pyright.setup{}
lspconfig.rust_analyzer.setup{}
lspconfig.html.setup{}
lspconfig.jdtls.setup{}
lspconfig.ts_ls.setup{}
lspconfig.solargraph.setup{}

-- Ativa autoindentação
vim.cmd [[
  filetype plugin indent on
  autocmd FileType python,html,rust,java,javascript,ruby setlocal shiftwidth=4 tabstop=4
]]

-- Linting com flake8 para Python
vim.g.coc_pyright_settings = { python = { linting = { flake8Enabled = true } } }

-- Linting para JavaScript
vim.g.coc_tsserver_settings = { javascript = { format = { enable = true } } }

-- Emmet keybindings
vim.g.user_emmet_leader_key = '<C-e>'
vim.cmd [[
  autocmd FileType html,css,jsx,tsx,js EmmetInstall
]]

-- Configuração do nvim-tree.lua
require'nvim-tree'.setup {
  auto_reload_on_write = false,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  view = {
    width = 30,
    side = 'left',
  },
  renderer = {
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
      }
    }
  },
  on_attach = function(bufnr)
    local api = require 'nvim-tree.api'

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    buf_set_keymap('n', '<CR>', ":lua require'nvim-tree.api'.node.open.edit()<CR>", { noremap = true, silent = true })
    buf_set_keymap('n', 'v', ":lua require'nvim-tree.api'.node.open.vertical()<CR>", { noremap = true, silent = true })
    buf_set_keymap('n', 'h', ":lua require'nvim-tree.api'.node.open.horizontal()<CR>", { noremap = true, silent = true })
    buf_set_keymap('n', 'R', ":lua require'nvim-tree.api'.tree.reload()<CR>", { noremap = true, silent = true })
    buf_set_keymap('n', 'a', ":lua require'nvim-tree.api'.fs.create()<CR>", { noremap = true, silent = true })
    buf_set_keymap('n', 'd', ":lua require'nvim-tree.api'.fs.remove()<CR>", { noremap = true, silent = true })
    buf_set_keymap('n', 'r', ":lua require'nvim-tree.api'.fs.rename()<CR>", { noremap = true, silent = true })
    buf_set_keymap('n', 'x', ":lua require'nvim-tree.api'.fs.cut()<CR>", { noremap = true, silent = true })
    buf_set_keymap('n', 'c', ":lua require'nvim-tree.api'.fs.copy.node()<CR>", { noremap = true, silent = true })
    buf_set_keymap('n', 'p', ":lua require'nvim-tree.api'.fs.paste()<CR>", { noremap = true, silent = true })
  end
}

vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Mapeamentos para clipboard
vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>p', '"+p', { noremap = true, silent = true })

-- Configuração do auto-session
require'auto-session'.setup {
  log_level = 'info',
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath('data')..'/sessions/',
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = true,
}

vim.api.nvim_set_keymap('n', '<leader>ss', ':SaveSession<CR>', { noremap = true, silent = true })

-- Configuração do lualine.nvim
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

-- Adiciona o tema Gruvbox
vim.cmd [[
  colorscheme gruvbox
  set background=dark
]]

-- Configuração do PlantUML
vim.g['plantuml_previewer#plantuml_jar_path'] = ''  -- Defina o caminho do JAR do PlantUML
vim.g['plantuml_previewer#browser'] = 'firefox'     -- Ou outro navegador de sua escolha
vim.api.nvim_set_keymap('n', '<Leader>p', ':PlantumlOpen<CR>', { noremap = true, silent = true })

-- Função Lua para gerar e visualizar diagramas PlantUML
function PlantumlPreview()
  local current_file = vim.fn.expand('%:p')
  local output_file = current_file:gsub('%.puml$', '.png')
  local cmd = string.format('plantuml -tpng %s -o %s', current_file, output_file)
  vim.fn.system(cmd)
  vim.cmd(string.format('silent !xdg-open %s', output_file))
end

