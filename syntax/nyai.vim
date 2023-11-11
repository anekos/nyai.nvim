syntax match userTag /<user>/ contained
syntax region userContent start=/<user>/ end=/\./ contains=userTag

syntax match systemTag /<system>/ contained
syntax region systemContent start=/<system>/ end=/\./ contains=systemTag

syntax match assistantTag /<assistant>/ contained
syntax region assistantContent start=/<assistant>/ end=/\./ contains=assistantTag

syntax match waitingTag /<WAITING>/

highlight userTag cterm=bold gui=bold guibg=red
highlight link userContent Comment

highlight systemTag cterm=bold gui=bold guibg=green
highlight link systemContent Comment

highlight assistantTag cterm=bold gui=bold guibg=blue
highlight link assistantContent Comment

highlight waitingTag cterm=bold gui=bold guibg=red

" function! s:show()
"     let l:syntaxgroup = synIDattr(synID(line('.'), col('.'), 1), 'name')
"     echomsg l:syntaxgroup
" endfunction
" nnoremap . :call <SID>show()<CR>
