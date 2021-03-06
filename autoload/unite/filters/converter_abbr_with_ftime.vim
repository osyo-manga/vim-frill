scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! unite#filters#converter_abbr_with_ftime#define()
	return s:converter
endfunction


let s:converter = {
\	"name" : "converter_abbr_with_ftime",
\	"description" : ""
\}


function! s:converter.filter(candidates, context)
" 	let candidates = deepcopy(a:candidates)
	let candidates = a:candidates
	let format = "(%Y/%m/%d %H:%M:%S)"
	for candidate in candidates
		if !has_key(candidate, "__converter_abbr_with_ftime")
			let abbr = get(candidate, "abbr", candidate.action__path)
			let candidate.abbr = strftime(format, getftime(expand(candidate.action__path))) . " " . abbr
			let candidate.__converter_abbr_with_ftime = 1
		endif

	endfor
	return candidates
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
