syntax match userTag /<USER>/ contained
syntax region userContent start=/<USER>/ end=/\./ contains=userTag

syntax match assistantTag /<ASSISTANT>/ contained
syntax region assistantContent start=/<ASSISTANT>/ end=/\./ contains=assistantTag

highlight userTag cterm=bold gui=bold guibg=red
highlight link userContent Comment

highlight assistantTag cterm=bold gui=bold guibg=blue
highlight link assistantContent Comment

" function! s:show()
"     let l:syntaxgroup = synIDattr(synID(line('.'), col('.'), 1), 'name')
"     echomsg l:syntaxgroup
" endfunction
" nnoremap . :call <SID>show()<CR>
