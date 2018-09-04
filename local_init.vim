if !executable('pip')
    echoerr "You need pip installed for neovim python support"
else
    silent !pip show neovim
    if v:shell_error != 0
        echo "Installing NeoVim python plugin with pip"
        silent !pip install neovim
    endif
endif

colorscheme Tomorrow-Night

set cursorline
set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:.

set history=1000

au BufWinLeave *.* silent! mkview  "make vim save view (state) (folds, cursor, etc)
au BufWinEnter *.* silent! loadview "make vim load view (state) (folds, cursor, etc)

set backup
if has('persistent_undo')
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

function! InitializeDirectories()
    let separator = "."
    let parent = $HOME
    let prefix = '.vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = parent . '/' . prefix . dirname . "/"
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

noremap <silent> <leader>t :NERDTreeToggle<CR>
noremap <silent> <C-E> :NERDTreeToggle<CR>

noremap <Leader>H :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

noremap <silent> <leader>; A;<esc>
noremap <silent> <leader>, A,<esc>
noremap <silent> <C-;> A;<esc>
noremap <silent> <C-,> A,<esc>

noremap <silent> <leader>l <C-W><C-L>
noremap <silent> <leader>h <C-W><C-H>
noremap <silent> <leader>j <C-W><C-J>
noremap <silent> <leader>k <C-W><C-K>

noremap <silent> <C-S-P> :CtrlP<CR>
noremap <silent> <leader>p :CtrlP<CR>
noremap <silent> <leader>P :CtrlPClearCache<CR>

nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

if executable("ag")
    noremap <silent> <leader>f :Ag<CR>
endif

let g:ctrlp_custom_ignore = {
    \ 'dir': '\.git$\|node_modules',
    \ 'file': '\.DS_Store$\|\.lock$',
    \ }

" Syntastic configuration
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'yarn lint --'

" Machine Dependent Settings
let local_config = expand("~/.nvimrc")
if filereadable(local_config)
    source local_config
endif

" Project Settings
let g:projects_path = expand(get(g:, 'projects_path', '~/Projects'))
if isdirectory(g:projects_path)
    let g:project_enable_welcome = 0
    let g:project_use_nerdtree = 1
    call project#rc(g:projects_path)
    let projects = system("ls " . g:projects_path)
    for project in split(projects)
        let project_path = g:projects_path . "/" . project
        if isdirectory(project_path)
            Project project_path
        endif
    endfor
    if argc() == 0
        Welcome
    endif
endif

function FixEslintAndReopen()
    if executable(eslint)
        !eslint --fix %
        edit!
    endif
endfunction

autocmd FileType js,jsx
    \ autocmd BufWritePre * call FixEslintAndReopen()
