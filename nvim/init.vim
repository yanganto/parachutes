call plug#begin('~/.config/nvim/plugged')
let g:plug_url_format = 'git@github.com:%s.git'
" Displays
Plug 'kshenoy/vim-signature'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'RRethy/vim-illuminate'

" Brosing
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'liuchengxu/vim-clap'
Plug 'ludovicchabant/vim-gutentags'
Plug 'liuchengxu/vista.vim'

" Editor
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-speeddating'
Plug 'easymotion/vim-easymotion'
Plug 'Konfekt/FastFold'
Plug 'ntpeters/vim-better-whitespace'
Plug 'jiangmiao/auto-pairs'
Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}
Plug 'gyim/vim-boxdraw'
Plug 'embear/vim-localvimrc'

" Version Control Helper
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Syntax
Plug 'cespare/vim-toml'
Plug 'peterhoeg/vim-qml'
Plug 'jceb/vim-orgmode'
Plug 'rhysd/vim-clang-format'
Plug 'digitaltoad/vim-pug'
Plug 'ekalinin/Dockerfile.vim'
Plug 'ap/vim-css-color'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'LnL7/vim-nix'
Plug 'tasn/vim-tsx'
Plug 'qnighy/lalrpop.vim'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'chase/vim-ansible-yaml'
Plug 'tomlion/vim-solidity'
Plug 'jvirtanen/vim-hcl'
" Plug 'zchee/nvim-go', { 'do': 'make'}
" Plug 'posva/vim-vue'
Plug 'hashivim/vim-terraform'
Plug 'yorinasub17/vim-terragrunt'
Plug 'yanganto/move.vim', {'branch': 'sui-move'}

" Linter
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
" Plug 'nvim-lua/completion-nvim'
Plug 'heavenshell/vim-tslint'
Plug 'ojroques/nvim-lspfuzzy'

" TODO: fix this on Nix
Plug 'yanganto/nvim-translate', {'branch': 'master'}
Plug 'yanganto/nvim-translate-byte-literal', {'branch': 'master'}

Plug 'editorconfig/editorconfig-vim'

Plug 'folke/lsp-colors.nvim'

call plug#end()

""""""""""""""""""
""" Preset Env """
""""""""""""""""""

set encoding=utf-8
set termencoding=utf-8
set langmenu=zh_TW.UTF-8
set guifont=Fira\ Code:h12


hi Comment ctermfg=12 gui=bold guifg=Blue
hi Search cterm=NONE ctermfg=black ctermbg=gray
highlight ExtraWhitespace ctermbg=DarkGray

let g:line_number_mode = "number"
set nu
function! ToggleLineNumberStyle()
  if g:line_number_mode == "hybrid"
    echo "Set Line number relative"
    set nu!
    set rnu
    let g:line_number_mode = "relative"
  elseif g:line_number_mode == "relative"
    echo "Set Line number only"
    set nu
    set rnu!
    let g:line_number_mode = "number"
  elseif g:line_number_mode == "number"
    echo "Set Line number None"
    set nornu
    set nonu
    let g:line_number_mode = "none"
  else
    echo "Set Line number hybrid"
    set nu rnu
    let g:line_number_mode = "hybrid"
  endif
endfunction

map <F12> <Esc>:call ToggleLineNumberStyle()<CR>
set ts=4 sts=4 sw=4 expandtab
autocmd Filetype text setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype html setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype css setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype scss setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype sass setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype rasi setlocal syntax=css
autocmd Filetype js setlocal ts=2 sts=2 sw=2 expandtab

autocmd Filetype json setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype toml setlocal ts=4 sts=4 sw=4 expandtab

autocmd Filetype vue setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype javascript setlocal ts=4 sts=4 sw=4 expandtab
autocmd Filetype typescript setlocal ts=4 sts=4 sw=4 expandtab

autocmd Filetype python setlocal ts=4 sts=4 sw=4 expandtab

autocmd Filetype c setlocal ts=4 sts=4 sw=4 expandtab
autocmd Filetype cpp setlocal ts=4 sts=4 sw=4 expandtab
autocmd Filetype rust setlocal ts=4 sts=4 sw=4 expandtab
autocmd Filetype ron setlocal ts=2 sts=2 sw=2 expandtab syntax=rust
autocmd Filetype move setlocal ts=4 sts=4 sw=4 expandtab

autocmd Filetype markdown setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype asciidoc setlocal ts=4 sts=4 sw=4 expandtab

autocmd Filetype sh setlocal ts=4 sts=4 sw=4 expandtab
autocmd Filetype bash setlocal ts=4 sts=4 sw=4 expandtab
autocmd Filetype zsh setlocal ts=4 sts=4 sw=4 expandtab
autocmd Filetype just setlocal ts=2 sts=2 sw=2 expandtab syntax=make
autocmd Filetype tftpl setlocal ts=4 sts=4 sw=4 expandtab syntax=yml
autocmd Filetype org setlocal ts=2 sts=2 sw=2 expandtab

autocmd Filetype vim setlocal ts=2 sts=2 sw=2 expandtab


execute "set colorcolumn=" . join(range(80,99), ',') . ',' . join(range(101,119), ',')
hi ColorColumn ctermbg=236


"""""""""""""""""""
"" Plug Settings ""
"""""""""""""""""""

"NERDTree"
map <F5> <ESC>:NERDTreeToggle<CR>
let g:NERDTreeHighlightCursorline = 1
let g:NERDTreeShowHidden=1

"indentLine"
let g:indentLine_char = '┆'
let g:indentLine_color_term = 236
set list lcs=tab:\┆\
let g:indent_line_mode = "enable"
highlight default TabIndent ctermfg=60 guifg=60
match TabIndent /\t/
function! ToggleIndentLineMode()
  if g:indent_line_mode == "enable"
    set list lcs=tab:\ \
    IndentLinesToggle
    let g:indent_line_mode = "disable"
  else
    set list lcs=tab:\┆\
    IndentLinesToggle
    let g:indent_line_mode = "enable"
  endif
endfunction
map <F6> <ESC>:call ToggleIndentLineMode()<CR>

" Clap
map <C-n> <ESC>:Clap files<CR>


" ALE
" let g:ale_linters = {
" \   'python': ['pylint -j2', 'flake8'],
" \}
" let g:ale_fixers = {
" \   'javascript': ['eslint'],
" \}
" let g:ale_python_pylint_options ='--disable=C0301,F0401,C0111'
" " F0401 - Unable to import
" " C0111 - doc string check
" " C0301 - line too long

" let g:ale_python_flake8_options ='--ignore=E302,E303,E501'
" " E501  - line too long
" " E302  - two line spacing
" " E302  - too many blank lines

" " Auto remove tailing space in python
" autocmd BufWritePre *.py :%s/\s\+$//e

" let g:ale_sign_column_always = 1
" let g:ale_sign_error = '◉'
" let g:ale_sign_warning = '◉'
" highlight clear ALEErrorSign
" highlight clear ALEWarningSign
" highlight ALEErrorSign ctermfg=DarkMagenta guifg=#4B0082
" highlight ALEWarningSign ctermfg=8 ctermbg=DarkGray guifg=#444444
" highlight ALEWarning ctermbg=8 ctermbg=DarkGray
" highlight ALEError ctermbg=9 ctermfg=DarkGray
" let g:ale_echo_msg_error_str = 'E'
" let g:ale_echo_msg_warning_str = 'W'
" let g:ale_echo_msg_format = '【%severity%｜%linter%】%s'
" nmap <silent> <C-k> <Plug>(ale_previous_wrap)
" nmap <silent> <C-j> <Plug>(ale_next_wrap)
" let g:airline#extensions#ale#enabled = 1
" let g:ale_set_signs = 0

" hi Warn gui=bold cterm=bold

" GitGutter
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" illuminate
hi illuminatedWord cterm=underline,bold gui=underline,bold

" Translate
let g:translate_dest_lang='zh-TW'
let g:translate_display_option='status'

" " Go Debug
" let g:ConqueTerm_Color = 2
" let g:ConqueTerm_CloseOnEnd = 1
" let g:ConqueTerm_StartMessages = 0

" " CtrlP
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP'

" " Ag
" let g:ag_working_path_mode="r"

" gutentags
let g:gutentags_cache_dir = '~/.cache/gutentags'

" Vista
" let g:vista_default_executive = 'TagbarToggle'
let g:vista_mode = "none"
function! ToggleVistaWindow()
  if g:vista_mode == "none"
    let g:vista_sidebar_width = 30
    let g:vista_mode = "small"
    Vista
    echo "Set Vista Window Small"
  elseif g:vista_mode == "small"
    let g:vista_sidebar_width = 60
    let g:vista_mode = "mid"
    Vista! | Vista
    echo "Set Vista Window Middle"
  elseif g:vista_mode == "mid"
    let g:vista_sidebar_width = 90
    let g:vista_mode = "large"
    Vista! | Vista
    echo "Set Vista Window Large"
  else
    let g:vista_mode = "none"
    Vista!
  endif
endfunction
map <F8> <Esc>:call ToggleVistaWindow()<CR>

" Table Mode
map <M-t> <Esc>:TableModeToggle<CR>

" Spell check
function! ToggleSpellCheck()
  set spell!
  if &spell
    echo "Spellcheck ON"
  else
    echo "Spellcheck OFF"
  endif
endfunction
map <F9> <Esc>:call ToggleSpellCheck()<CR>
map <F10> <Esc>]s
" Translate
map <F2> <ESC>:Translate<CR>

" Fold
highlight Folded ctermbg=black ctermfg=239
set foldmethod=syntax
au BufRead,BufNewFile *.py set foldmethod=indent

" FastFold
let g:markdown_folding = 1
let g:tex_fold_enabled = 1
let g:xml_syntax_folding = 1
let g:javaScript_fold = 1
let g:rust_fold = 0

" vim table
let g:table_mode_corner='|'

" Rust fmt
let g:rustfmt_autosave = 1

:lua << END
  require'lspconfig'.rust_analyzer.setup {
      diagnostics = {
        enable = true,
        enableExperimental = true,
    },
  }
  require("lsp-colors").setup({
    Error = "#db4b4b",
    Warning = "#e0af68",
    Information = "#0db9d7",
    Hint = "#10B981"
  })
  require'lspconfig'.tsserver.setup {}
  " require'lspconfig'.pyls.setup {}
  require'lspfuzzy'.setup {
    methods = 'all',
    jump_one = true,
    fzf_preview = {
      'right:+{2}-/2'
    },
    fzf_action = {
      ['ctrl-t'] = 'tabedit',
      ['ctrl-v'] = 'vsplit',
      ['ctrl-x'] = 'split',
    },
    fzf_modifier = ':~:.',
    fzf_trim = true,
  }
 require'compe'.setup {
   enabled = true;
   autocomplete = true;
   debug = false;
   min_length = 1;
   preselect = 'enable';
   throttle_time = 80;
   source_timeout = 200;
   incomplete_delay = 400;
   max_abbr_width = 100;
   max_kind_width = 100;
   max_menu_width = 100;
   documentation = true;
   source = {
     path = true;
     buffer = true;
     calc = true;
     nvim_lsp = true;
     nvim_lua = true;
     spell = true;
     tags = true;
     snippets_nvim = true;
    }
  }
END

autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc
sign define LspDiagnosticsErrorSign text=!
sign define LspDiagnosticsWarningSign text=?
sign define LspDiagnosticsInformationSign text=i
sign define LspDiagnosticsHintSign text=.

let g:completion_enable_auto_popup = 1

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

nnoremap <silent> <c-]>      <cmd>:vsplit<CR>:lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K          <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi         <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent><leader> gi <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <c-k>      <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr         <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gw         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd         <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent><Leader> rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent><leader> gs <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent><leader> ga <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <c-'>      <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <c-;>      <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" command! -nargs=* <leader>rn :call lua <q-args>)

" vim-translate-byte
nmap tt :<C-u>TranslateByteArray<CR>


" Fmt notify checker
if !exists("g:rustfmt_autosave")
  echo "[WARN] Rust fmt autosave disabled"
endif

" easymotion
nmap s <Plug>(easymotion-s2)

" local vimrc
let g:localvimrc_enable = 1
let g:localvimrc_sandbox = 0
let g:localvimrc_debug = 1

command! CargoPlay !cargo play %
