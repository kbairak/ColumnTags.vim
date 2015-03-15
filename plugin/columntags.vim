" Vim global plugin to navigate through tags like mac finder's column view
" Last Change: 2015 Mar 14
" Maintainer: Konstantinos Bairaktaris <ikijob@gmail.com>
" License: This file is placed in the public domain
" Version: 0.1

if exists("g:loaded_columntags")
    finish
endif
let g:loaded_columntags = 1

" Globals
let g:max_columns = 3

" Stash
" camelCase for staticmethods, underscore for instance methods
let s:Stash = {}
function s:Stash.New()
    let l:new_stash = copy(self)
    let l:new_stash['_stash'] = []
    return l:new_stash
endfunction

function s:Stash.getForTab()
    if ! exists('t:stash')
        let t:stash = s:Stash.New()
    endif
    return t:stash
endfunction

function s:Stash.push(value)
    call add(self['_stash'], a:value)
endfunction

function s:Stash.pop()
    let l:tail = len(self['_stash']) - 1
    let l:return_value = self['_stash'][l:tail]
    call remove(self['_stash'], l:tail)
    return l:return_value
endfunction

function s:Stash.is_empty()
    return len(self['_stash']) == 0
endfunction

" Utils
function s:get_window_count()
    return winnr('$')
endfunction

function s:get_focused_window()
    return winnr()
endfunction

function s:is_rightmost()
    return s:get_focused_window() == s:get_window_count()
endfunction

function s:is_leftmost()
    return s:get_focused_window() == 1
endfunction

function s:split_right()
    vsplit
    wincmd l
    execute 'tjump ' . expand('<cword>')
    silent! foldopen!
endfunction

function s:focus_window(target)
    let l:source = s:get_focused_window()
    if l:source < a:target
        execute (a:target - l:source) . 'wincmd l'
    elseif a:target < l:source
        execute (l:source - a:target) . 'wincmd h'
    endif
endfunction

function s:delete_window(target)
    let l:source = s:get_focused_window()
    call s:focus_window(a:target)
    quit
    if l:source < a:target
        call s:focus_window(l:source)
    elseif a:target < l:source
        call s:focus_window(l:source - 1)
    endif
endfunction

function s:delete_righter()
    let l:source = s:get_focused_window()
    while s:get_focused_window() < s:get_window_count()
        call s:delete_window(l:source + 1)
    endwhile
endfunction

" Main functions
function s:column_tag_open()
    if ! s:is_rightmost()
        call s:delete_righter()
    endif

    let l:stash = s:Stash.getForTab()
    if s:get_window_count() >= g:max_columns
        call s:focus_window(1)
        call l:stash.push({'file': expand('%'), 'line': line('.')})
        call s:delete_window(1)
        call s:focus_window(g:max_columns - 1)
    endif
    call s:split_right()

    while ! l:stash.is_empty() && s:get_window_count() < g:max_columns
        call s:column_tag_shift_left()
    endwhile
endfunction

function s:column_tag_back()
    if ! s:is_leftmost()
        wincmd h
        return
    endif

    let l:stash = s:Stash.getForTab()
    if l:stash.is_empty()
        return
    endif

    let l:window_count = s:get_window_count()
    if l:window_count >= g:max_columns
        call s:delete_window(l:window_count)
        call s:focus_window(1)
    endif

    vsplit
    let l:value = l:stash.pop()
    let l:filepath = l:value['file']
    let l:linenumber = l:value['line']
    execute 'edit ' . l:filepath
    execute 'goto ' . line2byte(l:linenumber)
    foldopen!
endfunction

function s:column_tag_shift_left()
    let l:stash = s:Stash.getForTab()
    if l:stash.is_empty()
        return
    endif

    let l:source = s:get_focused_window()
    if s:get_window_count() == g:max_columns
        call s:delete_window(g:max_columns)
    endif

    call s:focus_window(1)
    call s:column_tag_back()

    if l:source == g:max_columns
        let l:source -= 1
    endif
    call s:focus_window(l:source + 1)
endfunction

" Mappings
command CollumnTagOpen call s:column_tag_open()
command CollumnTagBack call s:column_tag_back()
command CollumnTagShiftLeft call s:column_tag_shift_left()

if ! hasmapto('CollumnTagOpen')
    nmap <silent> <C-]> :CollumnTagOpen<CR>
endif
if ! hasmapto('CollumnTagBack')
    nmap <silent> <C-t> :CollumnTagBack<CR>
endif
if ! hasmapto('CollumnTagShiftLeft')
    nmap <silent> <C-,> :CollumnTagShiftLeft<CR>
endif
