" SetCharLimit
"
" Set's character limit for a file.
"
" @param int chars The number of chars to put the limit on.
function SetCharLimit (chars)
	exe "set cc=" . a:chars
	exe "set tw=" . a:chars
endfunction
