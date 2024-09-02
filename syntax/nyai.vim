runtime! syntax/markdown.vim
unlet b:current_syntax
syntax include @markdown syntax/markdown.vim

syntax match Comment /^@model.*$/ contains=@markdown
highlight link Comment Comment

syntax match WaitMessage /\.\.\. WAITING \.\.\./ containedin=ALL
highlight WaitMessage ctermbg=red guibg=red
