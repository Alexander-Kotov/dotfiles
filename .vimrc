execute pathogen#infect()

set number
syntax on
filetype plugin indent on

set t_ut=

let g:solarized_termcolors=256
set t_Co=256
set background=dark
colorscheme solarized

set laststatus=2

let s:hard_mode = 1

if s:hard_mode == 1
	noremap <left> <nop>
	noremap <right> <nop>
	noremap <up> <nop>
	noremap <down> <nop>
else
	unmap <left>
	unmap <right>
	unmap <up>
	unmap <down>
endif

set nowrap
set sidescrolloff=5
set scrolloff=3

nmap <F4> :cnext<CR>
nmap <S-F4> :cprevious<CR>

imap <F4> <C-O>:cnext
imap <S-F4> <C-O>:cprevious

nmap <F2> :w<CR>
imap <F2> <C-O>:w<CR>

set makeprg=bjam

nmap <F7> :wall<CR>:make<CR>:cw<CR>

set splitbelow
set splitright
set cursorline

augroup vimrc
	au!

	au BufReadPost * call s:GotoLastKnownCursorPos()
augroup end

function! s:GotoLastKnownCursorPos()
	let lineNr = line("'\"")
	if lineNr > 1 && lineNr <= line("$")
		execute "normal! g`\""
	endif
endfunction

function! GotoTab(tabn)
	execute "tabfirst"
	execute a:tabn . "tabnext"
endfunction

function! GetStatusLine()
	return "%<%F\ %m%r%y%q%=(%l:%c)[%02B]{%n}\ %P"
endfunction

function! GetTabLine()
	let result = ''
	for i in range(1, tabpagenr('$'))
		if i == tabpagenr()
			let result .= '%#TabLineSel#'
		else
			let result .= '%#TabLine#'
		endif
		let result .= ' [' . i . ']'
		let result .= ' %{GetTabLabel('. i .')} '
	endfor
	let result .= '%#TabLineFill#%='
	return result
endfunction

function! GetTabLabel(n)
	let bufs = tabpagebuflist(a:n)
	let windowNr = tabpagewinnr(a:n)
	let bufferName = bufname(bufs[windowNr - 1])
	if bufferName == ''
		return '[No Name]'
	endif
	return bufferName
endfunction

function! NewFile()
	let name = input('filename: ')
	execute "vnew" name
endfunction

function! s:ToggleHighlightSearch()
	execute "set hlsearch!"
endfunction

function! s:InitCppMode()
	set shiftwidth=4
	set expandtab
	set cinoptions=:0,l1,g0,N-s,(0
endfunction

nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>

nnoremap <leader>t1 :call GotoTab(1)<CR>
nnoremap <leader>t2 :call GotoTab(2)<CR>
nnoremap <leader>t3 :call GotoTab(3)<CR>
nnoremap <leader>t4 :call GotoTab(4)<CR>
nnoremap <leader>t5 :call GotoTab(5)<CR>
nnoremap <leader>t6 :call GotoTab(6)<CR>
nnoremap <leader>t7 :call GotoTab(7)<CR>
nnoremap <leader>t8 :call GotoTab(8)<CR>
nnoremap <leader>t9 :call GotoTab(9)<CR>

nnoremap <leader>fn :call NewFile()<CR>

set statusline=%!GetStatusLine()
set tabline=%!GetTabLine()

augroup codeformat
	au!

	au BufNewFile,BufRead *.cpp call s:InitCppMode()
	au BufNewFile,BufRead *.h call s:InitCppMode()
augroup end

augroup workplace
	au!

	au FileType cpp nnoremap <buffer> <localleader>cc I//<esc>
augroup end
