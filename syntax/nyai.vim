if exists('b:current_syntax')
  finish
endif

syntax match NyaiModelLine /^@model.*$/
highlight link NyaiModelLine Special

syntax match WaitMessage /\.\.\. WAITING \.\.\./ containedin=ALL
highlight WaitMessage ctermbg=red guibg=red

runtime! syntax/markdown.vim
syntax cluster markdownBlock add=NyaiModelLine,WaitMessage

let b:current_syntax = 'nyai'
