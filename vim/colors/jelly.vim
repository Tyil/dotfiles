set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "jelly"

" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine   cterm=inverse
  hi CursorColumn cterm=inverse
  hi MatchParen   ctermbg=13
  hi Pmenu        ctermfg=8
  hi PmenuSel     ctermfg=8
endif

" General colors
hi Cursor       ctermfg=15
hi Normal       ctermfg=15
hi NonText      ctermfg=7
hi LineNr       ctermfg=8
hi StatusLine   ctermfg=8
hi StatusLineNC ctermfg=15
hi VertSplit    ctermfg=8
hi Folded       ctermfg=8
hi Title        ctermfg=10
hi Visual       ctermbg=5
hi SpecialKey   ctermfg=8

" Syntax highlighting
hi Comment    ctermfg=8
hi Todo       ctermfg=8
hi Constant   ctermfg=1
hi String     ctermfg=9
hi Identifier ctermfg=4
hi Function   ctermfg=5
hi Type       ctermfg=15
hi Statement  ctermfg=12
hi Keyword    ctermfg=11
hi PreProc    ctermfg=7
hi Number     ctermfg=2
hi Special    ctermfg=10

