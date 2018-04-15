" Private Functions ------------------------------------------------------------

"{{{
function! autohighlight#changed_enabled(d,k,z)
	if a:z['new']
		call autohighlight#enable()
	else
		call autohighlight#disable()
	endif
endfunction
"}}}

"{{{
function! autohighlight#changed_highlight(d,k,z)
	if g:autohighlight_enabled
		call autohighlight#set_highlight()
	endif
endfunction
"}}}

"{{{
function! autohighlight#changed_event(d,k,z)
	if g:autohighlight_enabled
		" When the event is changed, the autocommand needs to be
		" re-registered. autohighlight#enable() does this among others.
		silent call autohighlight#enable()
	endif
endfunction
"}}}

"{{{
function! autohighlight#set_highlight()
	exec printf('highlight Autohighlight ctermfg=%s ctermbg=%s cterm=%s guifg=%s guibg=%s gui=%s', 
		\ get(g:autohighlight_highlight, 'ctermfg', 'NONE'),
		\ get(g:autohighlight_highlight, 'ctermbg', 'NONE'),
		\ get(g:autohighlight_highlight, 'cterm', 'NONE'),
		\ get(g:autohighlight_highlight, 'guifg', 'NONE'),
		\ get(g:autohighlight_highlight, 'guibg', 'NONE'),
		\ get(g:autohighlight_highlight, 'gui', 'NONE'),
		\)
endfunction
"}}}

"{{{
function! autohighlight#enable()
	call autohighlight#set_highlight()
	if g:autohighlight_event ==? 'CursorHold'
		augroup autohighlight
			autocmd!
			autocmd CursorHold * :call autohighlight#match_cword()
		augroup END
	elseif g:autohighlight_event ==? 'CursorMoved'
		augroup autohighlight
			autocmd!
			autocmd CursorMoved * :call autohighlight#match_cword()
		augroup END
	else
		echoerr 'Please set g:autohighlight_event to either CursorMoved or CursorHold'
		return
	endif
	echo 'Highlight current word: ON'
endfunction
"}}}

"{{{
function! autohighlight#disable()
	augroup autohighlight
		autocmd!
	augroup END
	if get(w:, 'autohighlight_matcher', -1) != -1
		call matchdelete(w:autohighlight_matcher)
	endif
	let w:autohighlight_matcher = -1
	highlight clear Autohighlight
	echo 'Highlight current word: off'
endfunction
"}}}

"{{{
function! autohighlight#match_cword()
	if get(w:, 'autohighlight_matcher', -1) != -1
		call matchdelete(w:autohighlight_matcher)
	endif
	let w:autohighlight_matcher = matchadd("Autohighlight", '\V\<'.escape(expand('<cword>'), '/\').'\>', g:autohighlight_priority )
endfunction
"}}}
