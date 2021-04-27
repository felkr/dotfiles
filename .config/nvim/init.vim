call plug#begin('~/.config/nvim/plugged')
Plug 'JuliaEditorSupport/julia-vim'
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'airblade/vim-gitgutter'
call plug#end()
lua << END
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local lspconfig = require('lspconfig')
require'lspinstall'.setup() -- important

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{}
end
lspconfig.julials.setup{
    on_new_config = function(new_config,new_root_dir)
      server_path = "/home/felix/.julia/packages/LanguageServer/y1ebo/src"
      cmd = {
        "julia",
        "--project="..server_path,
        "--startup-file=no",
        "--history-file=no",
        "-e", [[
          using Pkg;
          Pkg.instantiate()
          using LanguageServer; using SymbolServer;
          depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
          project_path = dirname(something(Base.current_project(pwd()), Base.load_path_expand(LOAD_PATH[2])))
          # Make sure that we only load packages from this environment specifically.
          @info "Running language server" env=Base.load_path()[1] pwd() project_path depot_path
          server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path);
          server.runlinter = true;
          run(server);
	]]
    };
      new_config.cmd = cmd
    end
}
END

" nnoremap <SPACE> <Nop>
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :so %<CR> 
nnoremap <leader>n :NvimTreeFindFile<CR>
" NvimTreeOpen and NvimTreeClose are also available if you need them


set termguicolors " this variable must be enabled for colors to be applied properly
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
highlight Comment cterm=italic

" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=blu
let mapleader = "\<Space>"
syntax on
" set cursorline
set clipboard=unnamed
set nowrap
set mouse=a
set number
set smartcase
colorscheme onehalfdark

let g:nvim_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
let g:nvim_tree_tab_open = 1
