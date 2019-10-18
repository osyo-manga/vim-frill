scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" python like
" see: http://qiita.com/quenhulu/items/61edc5dffa711b08d64c
function! s:user()
	return get(filter([$LOGNAME, $USER, $LNAME, $USERNAME], { -> v:val != "" }), 1, "")
endfunction


let s:obj = {
\}


function! s:obj.config()
	return extend({ "capacity" : 0 }, self.__config())
endfunction


function! s:obj._is_exists(it)
	return glob(a:it) != ""
endfunction


function! s:obj.add(xs)
	if type(a:xs) != type([])
		return self.add([a:xs])
	endif
	call map(reverse(a:xs), { -> self.__list.push_front(v:val) })
	return self
endfunction


function! s:obj._load(filepath)
	let xs = readfile(a:filepath)
	return xs

	let env = "$" . self.config().root_env
	if env == "" || !exists(env)
		return xs
	endif

	let env_path = expand(env)
	return map(xs, { -> substitute(v:val, '^' . env, env_path, "") })
endfunction


function! s:obj.load(filepath)
	if !filereadable(a:filepath)
		return self
	endif

	let list = self._load(a:filepath)
	call self.add(list)

	return self
endfunction


function! s:obj.refresh()
" 	call self.__list.resize_front()
	call filter(self.__list.list, { -> self._is_exists(v:val) })
	return self
endfunction


function! s:obj.list()
	return self.__list.list
endfunction


function! frill#base#make(config)
	let obj = deepcopy(s:obj)
	let obj.__config = a:config
	let obj.__list   = frill#uniq_list#make(obj.config().capacity)
	return obj
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
