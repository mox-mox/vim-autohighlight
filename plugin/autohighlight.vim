" ------------------------------------------------------------------------------
" Exit when your app has already been loaded (or "compatible" mode set)
if exists("g:loaded_autohighlight") || &cp
  finish
endif
let g:loaded_autohighlight   = 001
let s:keepcpo           = &cpo
set cpo&vim




" Variables that control the plugin behaviour ----------------------------------

" g:autohighlight_enabled:
" Jump to next result after starting a search, like the default word search '*'
" does
if !exists('g:autohighlight_enabled')
	let g:autohighlight_enabled = v:true
endif

" g:autohighlight_highlight:
" Define the colours that are used to highlight the cursor word
if !exists('g:autohighlight_highlight')
	let g:autohighlight_highlight = { 'ctermfg':'green', 'ctermbg':'NONE', 'cterm':'NONE', 'guifg':'#ff0000', 'guibg':'NONE', 'gui':'NONE' }
endif

" g:autohighlight_priority:
" Set the match priority. Set to a negative value to leave search highlighting
" alone.  See :help matchadd().
if !exists('g:autohighlight_priority')
	let g:autohighlight_priority = -1
endif

" g:autohighlight_event:
" When to start autohighlighting (if enabled).
"  - Can be either "CursorMoved" to update the highlight on every cursor move,
"  - Or "CursorHold" to update |updatetime| after the last cursor movement.
" Use "setl updatetime=100" to adjust the wait after the last cursor movement.
if !exists('g:autohighlight_event')
	let g:autohighlight_event = 'CursorMoved'
endif


" Public Commands --------------------------------------------------------------

" Enable, Disable and Toggle Autohighlight
command AutohighlightEnable  :let g:autohighlight_enabled = v:true
command AutohighlightDisable :let g:autohighlight_enabled = v:false
command AutohighlightToggle  :let g:autohighlight_enabled = !g:autohighlight_enabled

" Change the Autohighlight colours
command -nargs=1 AutohighlightSetFG
	\ let g:autohighlight_highlight['ctermfg']='<args>'
	\|let g:autohighlight_highlight['guifg']='<args>'

command -nargs=1 AutohighlightSetBG
	\ let g:autohighlight_highlight['ctermbg']='<args>'
	\|let g:autohighlight_highlight['guibg']='<args>'

command -nargs=1 AutohighlightSetATTR
	\ let g:autohighlight_highlight['cterm']='<args>'
	\|let g:autohighlight_highlight['gui']='<args>'

" Set the Autohighlight priority
command -nargs=1 AutohighlightPriority let g:autohighlight_priority = <args>


" Set the Autohighlight event
command AutohighlightCursorMoved :let g:autohighlight_event = 'CursorMoved'
command AutohighlightCursorHold  :let g:autohighlight_event = 'CursorHold'


" Public Mappings --------------------------------------------------------------

nnoremap <script> <Plug>autohighlight_toggle :     AutohighlightToggle<CR>
vnoremap <script> <Plug>autohighlight_toggle :<C-U>AutohighlightToggle<CR>



" Watchers for the configuration variables -------------------------------------

silent! call dictwatcherdel(g:, 'autohighlight_enabled', 'autohighlight#changed_enabled')
call dictwatcheradd(g:, 'autohighlight_enabled', 'autohighlight#changed_enabled')

silent! call dictwatcherdel(g:autohighlight_highlight, '*', 'autohighlight#changed_highlight')
call dictwatcheradd(g:autohighlight_highlight, '*', 'autohighlight#changed_highlight')

silent! call dictwatcherdel(g:, 'autohighlight_event', 'autohighlight#changed_event')
call dictwatcheradd(g:, 'autohighlight_event', 'autohighlight#changed_event')



if g:autohighlight_enabled
	silent call autohighlight#enable()
endif

let &cpo= s:keepcpo
unlet s:keepcpo
