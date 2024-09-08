if exists('b:current_syntax')
  finish
endif

syntax match NyaiParameterLine /^@model.*$/
highlight link NyaiParameterLine Special

syntax match NyaiWaitMessage /\.\.\. WAITING \.\.\./ containedin=ALL
highlight NyaiWaitMessage ctermbg=red guibg=red

runtime! syntax/markdown.vim
syntax cluster markdownBlock add=NyaiParameterLine,NyaiWaitMessage

let b:current_syntax = 'nyai'
