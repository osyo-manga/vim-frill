scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:uniq(list)
	let list = []
	let result = {}
	for _ in a:list
		if !has_key(result, _)
			call add(list, _)
		endif
		let result[_] = 0
	endfor
	return list
endfunction


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


function! frill#uniq_list#make(...)
	return call("s:uniq_list", a:000)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
