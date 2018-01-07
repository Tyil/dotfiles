" PickTheme
"
" Pick a customized theme. If no specific theme is given, a random one will be
" loaded instead.
"
" @param string name The name of the theme to load, if any.
function PickTheme (...)
	let name = get(a:, 1, "")

	if name
		exe "ru " . g:path . "/themes/" . name . ".vim"
		return 0
	endif

	let s:themes = split(globpath(g:path . "/themes", "*.vim"), "\n")
	let s:index = system("perl -e 'print int(rand(" . len(s:themes) . "))'")

	exe "so " . s:themes[s:index]
endfunction
