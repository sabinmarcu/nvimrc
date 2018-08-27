if !executable('pip')
    echoerr "You need pip installed for neovim python support"
else
    silent !pip show neovim
    if v:shell_error != 0
        echo "Installing NeoVim python plugin with pip"
        silent !pip install neovim
    endif
endif

colorscheme iosvkem

noremap <silent> <leader>t :NERDTreeToggle<CR>
noremap <silent> <C-E> :NERDTreeToggle<CR>

noremap <Leader>H :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

noremap <silent> <leader>; A;<esc>
noremap <silent> <leader>, A,<esc>

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
