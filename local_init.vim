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
if filereadable(expand("~/.nvimrc"))
    source ~/.nvimrc
endif

" Project Settings
let g:projects_paths = expand(get(g:, 'projects_paths', '~/Projects'))
let projects_paths = split(g:projects_paths)
if isdirectory(expand(projects_paths[0]))
    let g:project_enable_welcome = 0
    let g:project_use_nerdtree = 1
    call project#rc(expand(projects_paths[0]))
    for projects_path in projects_paths
        let projects_path = expand(projects_path)
        let projects = system("ls " . projects_path)
        for project in split(projects)
            let project_path = projects_path . "/" . project
            if isdirectory(project_path)
                Project project_path
            endif
        endfor
    endfor
    if argc() == 0
        Welcome
    endif
endif
