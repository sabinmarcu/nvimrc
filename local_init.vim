if !executable('pip')
    echoerr "You need pip installed for neovim python support"
else
    silent !pip show neovim
    if v:shell_error != 0
        echo "Installing NeoVim python plugin with pip"
        silent !pip install neovim
    endif
endif

set autochdir
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

let g:ctrlp_custom_ignore = {
    \ 'dir': '\.git$\|node_modules',
    \ 'file': '\.DS_Store$\|\.lock$',
    \ }

" Syntastic configuration
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'yarn lint --'
