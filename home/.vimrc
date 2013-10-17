set nocompatible " be iMproved

" Vundle {
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" }

filetype plugin indent on

" General Vim settings {

  autocmd FileType vim setlocal foldmarker={,} foldlevel=9 foldmethod=marker
  " Save folds when saving
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent loadview
  set mouse=a           " Automatically enable mouse usage
  set mousehide         " Hide the mouse cursor while typing
  scriptencoding utf-8
  set viewoptions=folds,options,cursor,unix,slash
  set hidden            " Allow buffer switching without saving

  set nobackup
  set nowritebackup
  set backspace=2   " Backspace deletes like most programs in insert mode
  set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
  set history=50
  set autowrite     " Automatically :write before running commands

  " Use persistent undo if it is available
  if has('persistent_undo')
    set undofile            " Enable persistent undo
    set undodir=~/.backup/undo/,~/tmp,.
    set undolevels=1000     " Maximum number of changes that can be undone
    set undoreload=10000    " Maximum number of lines to save for undo on a buffer reload
  endif

" }

" Vim UI {
set background=dark   " Assume a dark background
colorscheme base16-eighties
syntax on
set tabpagemax=15         " Only show 15 tabs
set showmode              " Display the current mode
" set cursorline            " Highlight the current line

if has('cmdline_info')
  set ruler               " Show the ruler
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
  set showcmd             " Show partial commands in status line
endif

if has('statusline')
  set laststatus=2

  set statusline=%<%f\                      " Filename
  set statusline+=%w%h%m%r                  " Options
  set statusline+=%{fugitive#statusline()}  " Git
  set statusline+=\ [%{&ff}/%Y]             " Filetype
  set statusline+=\ [%{getcwd()}]           " Current dir
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%   " Right aligned file nav info
endif

set backspace=2                   " Backspace deletes like most programs in insert mode
set linespace=0                   " No extra spaces between rows
set number                        " Line numbers on
set numberwidth=5                 " Number column 5 characters wide
set showmatch                     " Show matching brackets/parenthesis
set incsearch                     " Find as you type search
set hlsearch                      " Highlight search terms
set ignorecase                    " Case insensitive searching
set smartcase                     " Case sensitive when uppercase present
set wildmenu                      " Show list instead of just completing
set wildmode=list:longest,full    " Command <tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]     " Backspace and cursor keys wrap too
set scrolljump=5                  " Lines to scroll when cursor leaves screen
set scrolloff=8                   " Minimum lines to keep above and below cursor
"set foldenable                    " Auto fold code
set list
set listchars=tab:>\ ,trail:*,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Vim formatting {

" Softtabs, 2 spaces
"
set nowrap                        " Wrap long lines
set autoindent                    " Indent at the same level of the previous line
set shiftwidth=2                  " Use indents of 2 spaces
set expandtab                     " Tabs are spaces, not tabs
set tabstop=2                     " An indentation every four colums
set softtabstop=2                 " Let backspace delete indent
set nojoinspaces                  " Prevents inserting two spaces after punctuation on a join (J)
set splitright                    " Puts new vsplit windows to the right of the current
set splitbelow                    " Puts new split windows to the bottom of the current
set matchpairs+=<:>               " Match, to be used with %
set pastetoggle=<F2>              "pastetoggle (sane indentation on pastes)

" }

" Key Mappings {

  let mapleader = ','
  " Easier typing of some keys in insert mode
  imap jj <Esc>
  imap aa @
  imap uu _

  " Sudo save file
  cmap w!! w !sudo tee % >/dev/null

  " Easier reload/editing of .vimrc
  nnoremap <leader>sv :source $MYVIMRC<cr>
  nnoremap <leader>ev :e $MYVIMRC

  " Install new vundle bundles
  nmap <Leader>bi :source ~/.vimrc<cr>:BundleInstall<cr>

  nnoremap <leader>. :CtrlPTag<cr>

  " Yank from the cursor to the end of the line
  nnoremap Y y$

  " Remove all trailing whitespace
  nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z

  " Yank to the OS X clipboard
  map <Leader>co ggVG"*y

  " Easily comment/uncomment lines
  map <Leader>/ <plug>NERDCommenterToggle

  " Turn off highlighting
  map <C-h> :nohl<cr>

  " Open a new tab
  map <C-t> <esc>:tabnew<CR>

  " Jump to the beginning and ending of a line while in insert mode
  imap <c-e> <c-o>$
  imap <c-a> <c-o>^

  " Switch to last file
  nnoremap <c-e> <c-^>

  " Jump to end and begining of line easily
  nmap H ^
  nmap L $

  " Set vim to keep current line in center of viewport
  nnoremap <leader>C :let &scrolloff=999-&scrolloff<cr>

  " Find merge conflict markers
  map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

  " Simple git mappings {

    map <Leader>gd :Git diff<cr>
    map <Leader>gs :Gstatus<CR>

  " }

  " Rails mappings {
    map <Leader>bb :!bundle install<cr>

  " }

  " Folding {
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>
  "}

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <c-e> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-rspec mappings
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>
nnoremap <Leader>a :call RunAllSpecs()<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Quicker window movement
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-h> <C-w>h
"nnoremap <C-l> <C-w>l

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1

" Disable ex mode
nnoremap Q <Nop>

" Ruby Refactoring tricks
nnoremap <Leader>: :%s/:\([^ ]*\)\(\s*\)=>/\1:/gc<CR>
nnoremap <Leader>{ :%s/{\([^ ]\)/{ \1/gc<CR>
nnoremap <Leader>} :%s/\([^ ]\)}/\1 }/gc<CR>

" Paste code from sytem clipboard at current indentation and exit paste mode
map <Leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>
" Turn off highlighting of searched for text
nmap <leader>h :nohlsearch<cr>


" Paste code from sytem clipboard at current indentation and exit paste mode
map <Leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>
" Turn off highlighting of searched for text
nmap <leader>h :nohlsearch<cr>

map <Leader>e :NERDTreeToggle<CR>:NERDTreeMirror<CR>
set nospell
let g:nerdtree_tabs_open_on_gui_startup=1
let NERDTreeKeepTreeInNewTab=0


map <Leader>rt :call RunCurrentSpecFile()<CR>
map <Leader>rs :call RunNearestSpec()<CR>
map <Leader>rl :call RunLastSpec()<CR>
map <Leader>ra :call RunAllSpecs()<CR>
let g:indent_guides_enable_on_vim_startup = 0
" }

" Python Specific {
autocmd FileType python setlocal shiftwidth=5 tabstop=4 softtabstop=4

" }

" Silver Surfer {
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
" }


" Custom Vim Functions {
  function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
      exec ':saveas ' . new_name
      exec ':silent !rm ' . old_name
      redraw!
    endif
  endfunction
  map <Leader>n :call RenameFile()<cr>
" }

" Plugins {

  " Tabularize {
    nmap <Leader>a& :Tabularize /&<CR>
    vmap <Leader>a& :Tabularize /&<CR>
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:<CR>
    vmap <Leader>a: :Tabularize /:<CR>
    nmap <Leader>a:: :Tabularize /:\zs<CR>
    vmap <Leader>a:: :Tabularize /:\zs<CR>
    nmap <Leader>a, :Tabularize /,<CR>
    vmap <Leader>a, :Tabularize /,<CR>
    nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
  "}
  " JSON {
    nmap <Leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
  " }
  " PyMode {
    let g:pymode_lint_checker = "pyflakes"
    let g:pymode_utils_whitespaces = 0
    let g:pymode_options = 0
  " }
  " TagBar {
    nnoremap <silent> <leader>tt :TagBarToggle<CR>
  " }
  " Fugitive {
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>:GitGutter<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>:GitGutter<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    nnoremap <silent> <leader>gg :GitGutterToggle<CR>
  " }
  " NeoComplete {
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      "return neocomplete#smart_close_popup() . "\<CR>"
      " For no inserting <CR> key.
      return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

    " For cursor moving in insert mode(Not recommended)
    "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
    "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
    "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
    "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
    " Or set this.
    "let g:neocomplete#enable_cursor_hold_i = 1
    " Or set this.
    "let g:neocomplete#enable_insert_char_pre = 1

    " AutoComplPop like behavior.
    let g:neocomplete#enable_auto_select = 1

    " Shell like behavior(not recommended).
    "set completeopt+=longest
    "let g:neocomplete#enable_auto_select = 1
    "let g:neocomplete#disable_auto_complete = 1
    "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

    " Plugin key-mappings.
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)

    " SuperTab like snippets behavior.
    imap <expr><TAB> neosnippet#jumpable() ?
          \ "\<Plug>(neosnippet_jump)"
          \: pumvisible() ? "\<C-n>" : "\<TAB>"
    imap <expr><S-Tab> neosnippet#expandable() ?
          \ "\<Plug>(neosnippet_expand)"
          \: "\<Plug>(neosnippet_expand)"

    " For snippet_complete marker.
    if has('conceal')
        set conceallevel=2 concealcursor=i
    endif

    " Enable neosnippet snipmate compatibility mode
    let g:neosnippet#enable_snipmate_compatibility = 1

    " Use honza's snippets
    let g:neosnippet#snippets_directory='~/.vim/bundle/vim-scripts/snippets'


  "}
  " Git Gitgutter {
    let g:gitgutter_realtime = 0
  "}

"}

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Syntax specfic {

  " Set syntax highlighting for specific file types
  au BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  au BufRead,BufNewFile *.md setlocal spell
  " Disable spell checking on ruby files
  au BufRead,BufNewFile *.rb setlocal nospell

  " Automatically wrap at 80 characters for Markdown
  au BufRead,BufNewFile *.md setlocal textwidth=80

" }

