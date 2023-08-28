"
" ~/.config/nvim/init.vim
"
" vim: fdm=marker cms="%s


" This file is poorly organized.

nnoremap <leader>Te :source ~/.config/nvim/misc/eo-x/start.vim<CR>
nnoremap <leader>TE :source ~/.config/nvim/misc/eo-x/start.vim<CR>

" nnoremap "+y   :w !wl-copy -n<CR><CR>
" nnoremap "+yy :.w !wl-copy<CR><CR>
" nnoremap "+p   :r !wl-paste -n<CR>






set nocompatible
filetype plugin on
filetype indent on
" se tw=80 fo+=c
" default fo is tcqj
" options -- all options and mappings (also global values for local options)
" disabling this means :mks doesn't store global stuff (can be reloaded!)
set sessionoptions-=options
set updatetime=100

" {{{ backup, undo, swap
	set backup
	set undofile
	" let &backupdir = "~/.config/nvim/data/backup/" . hostname() . "/,~/.config/nvim/data/backup/,~/.vim/backup/,~/,."
	" let &directory = "~/.config/nvim/data/swap/"   . hostname() . "//,~/.config/nvim/data/swap//,~/.vim/swap//,~//,.//"
	" let &undodir   = "~/.config/nvim/data/undo/"   . hostname() . "/,~/.config/nvim/data/undo/,~/.vim/undo/,~/,."
	let &backupdir = "~/.config/nvim/data/backup/" . hostname() . "/,~/.config/nvim/data/backup/"
	let &directory = "~/.config/nvim/data/swap/"   . hostname() . "//,~/.config/nvim/data/swap//"
	let &undodir   = "~/.config/nvim/data/undo/"   . hostname() . "/,~/.config/nvim/data/undo/"
	:exe "set backupdir=" . &backupdir
	:exe "set undodir="   . &undodir
	:exe "set directory=" . &directory
	" set backupdir="~/.config/nvim/data/backup/,~/.vim/backup/,~/,."
	" set directory="~/.config/nvim/data/swap//,~/.vim/swap//,~//,.//"
	" set undodir=~/.config/nvim/data/undo/,~/.vim/undo/,~/,."

" }}}
" {{{ plugins
	execute pathogen#infect('bundle/tpope/vim-commentary')
	execute pathogen#infect('bundle/tpope/vim-surround')
	execute pathogen#infect('bundle/machakann/vim-highlightedyank')
	" quick-scope {{{
		execute pathogen#infect('bundle/unblevable/quick-scope')
		" let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
		" unlet g:qs_highlight_on_keys
	" }}}
	" gitgutter {{{
		execute pathogen#infect('bundle/airblade/vim-gitgutter')
		" highlight SignColumn      guibg=#000000 ctermbg=0
		highlight! link SignColumn LineNr
		highlight GitGutterAdd    guifg=#009900 ctermfg=2
		highlight GitGutterChange guifg=#bbbb00 ctermfg=3
		highlight GitGutterDelete guifg=#ff2222 ctermfg=1
		let g:gitgutter_sign_added                   = '+'
		let g:gitgutter_sign_modified                = '~'
		let g:gitgutter_sign_removed                 = '-'
		let g:gitgutter_sign_removed_first_line      = '^'
		let g:gitgutter_sign_removed_above_and_below = '{'
		let g:gitgutter_sign_modified_removed        = 'w'
	" }}}
" }}}

" {{{ tabs (ts sw sta sts et ci pi)
	" {{{ here's the defaults for some stuff (by experimentation)
		" set	shiftwidth=8
		" set	tabstop=8
		" set	softtabstop=0
		" set noexpandtab
		" set	smarttab
		" set	autoindent
		" set nosmartindent
		" set nocindent
		" set nocopyindent
		" set nopreserveindent
	" }}}
	set ts=4 sw=0 sta	sts=0 noet	ci nopi
	set ts=4 sw=0 sts=0 sta noet ci nopi
	" {{{ notes on these settings
		" tabs are 4, sw matches
		" sts=0 et -- because fuck that noise
		" ci nopi -- ci is nice, pi can be fucky I change 'ts'
		" P.S. anyone who thinks i should use ts=8 can go bug off.
		" this is my house, i do what i want
		" I try to set them with modelines, anyway, so that
		" at least other vim users get my experinece? maybe that's
		" bad for setting defaults for other ppl, but it's 4am right now.
	" }}}
" }}}
" {{{ interface settings (bars, buffers, folds)
	" {{{ status bar
		set wildmenu
		set laststatus=2
		set showcmd
		" status line
			"todo: maybe a better stl?
			"todo: this WILL make \V break lightline
			set statusline=
			set stl+=%f\ %<%m%r%y
			set stl+=%=
			set stl+=0x%B\ 
			set stl+=%-8(%l/%L%)\ %-7(%c%V%)\ %P
		set showmode
	" }}}
	" tabs, windows, buffers
		set splitbelow splitright
		set hidden
	" folds
		set foldmethod=marker
		set foldlevelstart=2
	" search
		set nohlsearch
		set ignorecase smartcase
	" movement
		set number relativenumber
		set cursorline nocursorcolumn
		set nostartofline "todo: default on, why?
		" buffer space at edge of screen:
		set scrolloff=5
	" formatoptions
		set fo+=cro
	" wrapping
		set wrap linebreak
		set breakindent breakindentopt=min:20,shift:4
	" miscellaneous
		set list listchars=tab:>-,trail:~,extends:>,precedes:<,nbsp:+
		" set list listchars=tab:\|\ ,trail:~,extends:>,precedes:<,nbsp:+
		" set list listchars=tab:│\ ,trail:~,extends:>,precedes:<,nbsp:+
		" set list listchars=tab:>\ ,trail:~,extends:>,precedes:<,nbsp:+
		" j command adds 1 space rather than 2 after .?!
		set nojoinspaces
" }}}
" {{{ mappings
	map <leader>W :w<CR>
	map <leader>V :source ~/.config/nvim/init.vim<CR>
	nnoremap <leader>r :reg<CR>
	nnoremap <leader>b :ls<CR>:buffer 
	nnoremap <leader>ln 80\|bhru
	nnoremap <leader>lp 80\|bi"+ "<ESC>
	nnoremap <leader>xx :%!xxd<CR>
	nnoremap <leader>xX :%!xxd -r<CR>
	" map keys so jk move the way i want
	nnoremap j gj
	nnoremap k gk
	nnoremap gj j
	nnoremap gk k
	" :r!date mappings
	" the == at the end re-indents the inserted line
	nnoremap <leader>iD  :r !date '+\# \%F \%T'<CR>==
	nnoremap <leader>idd :r !date '+\# \%F'<CR>==
	nnoremap <leader>idt :r !date '+\# \%T'<CR>==
	nnoremap <leader>idh :r !date '+\# \%a, \%b \%-d \%Y, \%H:\%M'<CR>==
	nnoremap <leader>idH :r !date '+\# \%A, \%B \%-d \%Y, \%H:\%M'<CR>==
	nnoremap <leader>idr :r !date '+\# \%s'<CR>==
	" {{{ toggle simple settings
		nnoremap <leader>ta :set autoindent! autoindent?<CR>
		nnoremap <leader>tcc :set cursorcolumn! cursorcolumn?<CR>
		nnoremap <leader>tcl :set cursorline! cursorline?<CR>
		nnoremap <leader>th :set hlsearch! hlsearch?<CR>
		nnoremap <leader>tl :set list! list?<CR>
		nnoremap <leader>tn :set number! number?<CR>
		nnoremap <leader>tN :set relativenumber! relativenumber?<CR>
		nnoremap <leader>tp :set paste! paste?<CR>
		nnoremap <leader>ts :set spell! spell?<CR>
		nnoremap <leader>tw :set wrap! wrap?<CR>
	" }}}
	" {{{ more complicated toggles
		" nnoremap <leader>TS :syntax off<CR>:syntax on<CR>
		nnoremap <leader>Td :windo set diff<CR>
		nnoremap <leader>TD :windo set nodiff<CR>
	" }}}
	" {{{ yank to X11 buffers
		vnoremap <leader>yp :w !xsel -pi<CR><CR>
		vnoremap <leader>ys :w !xsel -si<CR><CR>
		vnoremap <leader>yc :w !xsel -bi<CR><CR>
	" }}}
" }}}
" {{{ autocommands
	" {{{ filetype autocommands
		augroup by_FileType
			autocmd!
			" commentstring
			au FileType python,conf,sh,zsh	setl cms=#%s
			au FileType cpp					setl cms=//%s
			au FileType html				setl cms=<!--%s-->
			au FileType vim					setl cms=\"%s		com+=:\"
			au FileType asm					setl cms=\;%s
			" tabs and indents
			au FileType python				setl ai nosi nocin
			au FileType cpp					setl noai nosi cin
			au FileType html				setl ts=2 sw=0 sts=0 sta et
			au FileType asm					setl ts=8 sw=0 sts=0 sta noet
			" miscellaneous
			au FileType python,cpp			setl fdm=indent
			au FileType python				setl fdl=1
			au FileType python,zsh			setl tw=80 fo-=t
			au FileType python				setl fo-=t
			" other stuff
			au BufNewFile,BufRead *.gmi,*.gemini		setf gemtext
			au FileType gemtext				setl fo-=o
		augroup END
	" }}}
	augroup InsertIdle
		autocmd!
		" exit insert mode while idling
		" autocmd CursorHoldI * stopinsert
		" autocmd InsertEnter * let updaterestore=&updatetime
		" autocmd InsertEnter * let &updatetime=4000
		" autocmd InsertLeave * let &updatetime=updaterestore
		"todo: this is fully disabled lmfao
		autocmd!
	augroup END
	" :help last-position-jump
	au BufReadPost *
		\ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
		\ |   exe "normal! g`\""
		\ | endif
	" {{{ dumb cursorline augroup
	" augroup CursorLine
	"	au!
	"	au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
	"	au WinLeave * setlocal nocursorline
	" augroup END
	" }}}
" }}}

" nothing in this fold is active
" unsorted options (and testing?) {{{
	" {{{ stuff from the old conf that i have questions about
		" set ttimeoutlen=50
		" this one might have been set because you mapped kj to <ESC>?
		" set updatetime=250
		"todo: if you touch this part, read this post you found:
		" https://old.reddit.com/r/vim/comments/3ql651/what_do_you_set_your_updatetime_to/
	" }}}
" }}}

" this must go at the end?
" {{{ appearance (cursor, TERM, syntax, :hi)

	set guicursor=
	" autocmd OptionSet guicursor noautocmd set guicursor=

	if $TERM == "xterm-kitty"
		set termguicolors
	endif

	syntax on

	" colorscheme default
	" highlight CursorLine guibg=Grey15
	" highlight Comment guifg=Cyan
	" highlight NonText guifg=SlateBlue
	" highlight Folded guibg=Grey25 guifg=Cyan

	" Mon, Mar 13 2023, 15:20
	" highlight CursorLine cterm=underline guibg=LightGrey
	" highlight Comment ctermfg=4 guifg=#8cdaff
	" highlight Comment ctermfg=4 guifg=grey
	" highlight Visual ctermbg=7 guibg=#ff8cda
	colorscheme peachpuff
	" setting `:hi Normal` and only setting one value might break something, but I'm not sure what. Mon, Apr 3 2023, 13:17
	highlight Normal guibg=#f5e4e5
" }}}





