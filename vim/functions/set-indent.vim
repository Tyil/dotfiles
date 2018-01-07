" SetIndent
"
" Set the size of indents and whether to use tabs or spaces.
"
" @param int size The width of the indents.
" @param bool tabs Whether to use hard tabs or not. Defaults to 1.
function SetIndent (...)
	let size = get(a:, 1)
	let tabs = get(a:, 2, 1)

	if (tabs)
		set noet
	else
		set et
	endif

	exe "set sw=" . size
	exe "set ts=" . size
endfunction
