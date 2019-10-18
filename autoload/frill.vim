scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:load(file, size)
	let uniq_list = frill#uniq_list#make(a:size)
	if filereadable(a:file)
		let uniq_list.list = readfile(a:file)
		call uniq_list.refresh_back()
	endif
	return uniq_list
endfunction


function! s:save(file, list)
	if !isdirectory(g:frill_data_dir)
		call mkdir(g:frill_data_dir)
	endif
	return writefile(a:list, a:file)
endfunction


let s:mrus = {}
function! s:get(name)
	if !has_key(s:mrus, a:name)
		let s:mrus[a:name] = s:load(g:frill_data_dir . "/" . a:name, get(g:frill_data_sizes, a:name, 0))
	endif
	return s:mrus[a:name]
endfunction


function! frill#get(name)
	return deepcopy(s:get(a:name).get_list())
endfunction


function! frill#add(name, item)
	call s:get(a:name).push_front(a:item)
endfunction


function! frill#add_file(name, file)
	let file = substitute(fnamemodify(a:file, ":p"), '\\', '/', "g")
	if filereadable(file)
		let root = substitute(expand(g:frill_root_env), '\\', '/', "g")
" 		echom root
" 		echom g:frill_root_env
" 		echom substitute(file, root, g:frill_root_env, "g")
		call frill#add(a:name, substitute(file, root, g:frill_root_env, "g"))
	endif
endfunction


function! s:refresh(name, expr)
	call filter(s:get(a:name).list, a:expr)
endfunction


function! frill#refresh_file(name)
	call s:refresh(a:name, "!empty(glob(expand(v:val)))")
endfunction


function! frill#save(name)
	return s:save(g:frill_data_dir . "/" . a:name, s:get(a:name).get_list())
endfunction


function! frill#save_all()
	for name in keys(s:mrus)
		call frill#save(name)
	endfor
endfunction


function! frill#remove_index(name, index)
	call s:get(a:name).remove_index(a:index)
endfunction


function! s:error_msg(msg)
	echohl ErrorMsg
	echo "fril.vim : " . a:msg
	echohl NONE
endfunction


function! frill#import_unite_file_mru(name, mru_file)
	if !filereadable(a:mru_file)
		call s:error_msg("import error not found '" . a:mru_file . "'")
		return
	endif
	let mru_file = readfile(a:mru_file)
	if mru_file[0] !=# "0.2.0"
		return s:error_msg("Not supported unite-mru version")
	endif
	let mru = s:get(a:name)
	let mru.list = map(mru_file[1:], 'matchstr(v:val, ''^\zs.\{-}\ze	\d\+$'')')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
