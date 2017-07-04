" vim-blade
au BufNewFile,BufRead *.blade.php set filetype=blade

" git-gutter
let g:gitgutter_max_signs = 100

" additional syntastic checkers
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ["perl", "perlcritic"]

" set options for syntastic checkers
let g:syntastic_perl_perlcritic_args = "--brutal"

" enable CamelCaseMotion
call camelcasemotion#CreateMotionMappings('<silent>')
