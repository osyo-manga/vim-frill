scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:uniq_list(...)
	let self = {
\		"capacity" : get(a:, 1, 0),
\		"list" : []
\	}

	function! self.remove_index(index)
		if a:index != -1
			unlet self.list[a:index]
		endif
	endfunction


	function! self.remove(item)
		call self.remove_index(index(self.list, a:item))
	endfunction

	function! self.push_back(item)
		call self.remove(a:item)
		call add(self.list, a:item)
		call self.refresh_front()
	endfunction

	function! self.refresh_back()
		if self.capacity != 0
			call self.resize_back(self.capacity)
		endif
	endfunction

	function! self.resize_back(size)
		let len = len(self.list)
		if (len - a:size) == 1
			unlet self.list[-1]
		elseif len >= a:size
			let self.list = self.list[ : a:size - 1]
		endif
	endfunction

	function! self.push_front(item)
		call self.remove(a:item)
		call insert(self.list, a:item)
		call self.refresh_back()
	endfunction

	function! self.refresh_front()
		if self.capacity != 0
			call self.resize_front(self.capacity)
		endif
	endfunction

	function! self.resize_front(size)
		let len = len(self.list)
		if (len - a:size) == 1
			unlet self.list[0]
		elseif len >= a:size
			let self.list = self.list[len - a:size : ]
		endif
	endfunction

	function! self.get_list()
		return self.list
	endfunction

	return self
endfunction


function! frill#make_uniq_list(...)
	return call("s:uniq_list", a:000)
endfunction


function! s:load(file, size)
	let uniq_list = frill#make_uniq_list(a:size)
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


let &cpo = s:save_cpo
unlet s:save_cpo
