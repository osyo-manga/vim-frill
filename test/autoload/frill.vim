
function! s:owl_begin()
	let g:owl_success_message_format = ""
endfunction

function! s:owl_end()
	let g:owl_success_message_format = "%f:%l:[Success] %e"
endfunction


function! s:test_uniq_list()
" 	let owl_SID = owl#filename_to_SID("vim-frill/autoload/frill.vim")
	
	let list = frill#make_uniq_list(5)
	call list.push_back(1)
	call list.push_back(2)
	call list.push_back(3)
	OwlCheck list.get_list() == [1, 2, 3]
	call list.push_front(4)
	call list.push_front(5)
	call list.push_front(6)
	OwlCheck list.get_list() ==[6, 5, 4, 1, 2]

	call list.push_back(7)
	OwlCheck list.get_list() ==[5, 4, 1, 2, 7]

	call list.resize_back(3)
	OwlCheck list.get_list() == [5, 4, 1]
	call list.resize_front(1)
	OwlCheck list.get_list() == [1]

	call list.push_back(1)
	call list.push_back(1)
	call list.push_back(1)
	OwlCheck list.get_list() == [1]

	let list2 = frill#make_uniq_list(0)
	call list.push_front(5)
	call list.push_front(6)
	call list.push_front(7)
	call list.push_front(8)
	OwlCheck list.get_list() == [8, 7, 6, 5]
	
endfunction



