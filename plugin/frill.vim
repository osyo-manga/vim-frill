scriptencoding utf-8
if exists('g:loaded_frill')
  finish
endif
let g:loaded_frill = 1

let s:save_cpo = &cpo
set cpo&vim


let g:frill_data_dir = get(g:, "frill_data_dir", expand('~/.frill'))
let g:frill_data_sizes = get(g:, "frill_data_sizes", {})
let g:frill_root_env = get(g:, "frill_root_env", "")


augroup frill
	autocmd!
	autocmd BufEnter *
\		if &buftype !=# 'help'
\|			call frill#add_file("file", expand("<afile>"))
\|		endif

	autocmd VimLeave * call frill#save_all()
" 	autocmd VimLeave * call frill#refresh_file("file") | call frill#save("file")
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo
