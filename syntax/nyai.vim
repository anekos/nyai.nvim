scriptencoding utf-8

" syntax reset

syntax match userTag /^<🤔\?user>$/ contained
syntax region userContent start=/^<🤔\?user>$/ end=/^\.$/ contains=userTag

syntax match systemTag /^<🖥\?system>$/ contained
syntax region systemContent start=/^<🖥\?system>$/ end=/^\.$/ contains=systemTag

syntax match assistantTag /^<🤖\?assistant>$/ contained
syntax region assistantContent start=/^<🤖\?assistant>$/ end=/^\.$/ contains=assistantTag

syntax match waitingTag /<WAITING>/

highlight link userTag Title
highlight link userContent Comment

highlight link systemTag userTag
highlight link systemContent userContent

highlight link assistantTag userTag
highlight link assistantContent userContent

highlight link waitingTag WarningMsg

" function! s:show()
"     let l:syntaxgroup = synIDattr(synID(line('.'), col('.'), 1), 'name')
"     echomsg l:syntaxgroup
" endfunction
" nnoremap . :call <SID>show()<CR>
