"
" ~/.vim/vimsrc/autocommand.vim
"

autocmd!
" This auto command is from the Vim wikia, and jumps to the last cursor position when reopening a file. I have no idea how it works.
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
" exit insert mode while idling
	autocmd CursorHoldI * stopinsert
	autocmd InsertEnter * let updaterestore=&updatetime
	autocmd InsertEnter * let &updatetime=4000
	autocmd InsertLeave * let &updatetime=updaterestore
