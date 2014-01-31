scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#frill#define()
	return s:source
endfunction


function! s:as_relative_path(filename)
	return a:filename
" 	return fnamemodify(a:filename, ':.')
" 	return substitute(fnamemodify(a:filename, ':.'), '\\', '/', "g")
endfunction

let s:source = {
\	"name" : "frill",
\	"description" : "mru",
\	"max_candidates" : 100,
\	"action_table" : {
\		"remove" : {
\			"description" : "remove",
\			"is_selectable" : 1,
\		},
\	},
\	"hooks" : {}
\}

" function! s:source.hooks.on_syntax(args, context)
" 	syntax match uniteSource__Frill_Time
" 		\ /([^)]*)\s\+/
" 		\ contained containedin=uniteSource__Frill_Time
" 	highlight default link uniteSource__Frill_Time Statement
" endfunction


function! s:source.action_table.remove.func(candidates)
	for candidate in a:candidates
		call frill#remove_index(candidate.action__name, candidate.action__index)
	endfor
endfunction


function! s:source.gather_candidates(args, context)
" 	echom "unite-frill start"
" 	TimerStart
" 	try
" 		let name = get(a:args, 0, "file")
" 		echom "unite-frill get"
" 		let list = frill#get(name)
" 		echom "unite-frill get end"
" 		return map(list, '{
" 	\		"word" : v:val,
" 	\		"kind" : "file",
" 	\		"action__path": v:val,
" 	\		"action__index": v:key,
" 	\		"action__name": name,
" 	\	}')
" 	finally
" 		TimerEnd
" 		echom "unite-frill finish"
" 	endtry


	let name = get(a:args, 0, "file")
	let list = frill#get(name)
	return map(list, '{
\		"word" : v:val,
\		"kind" : "file",
\		"action__path": v:val,
\		"action__index": v:key,
\		"action__name": name,
\	}')
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
