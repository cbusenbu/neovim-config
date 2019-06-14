
if exists('g:GtkGuiLoaded')
    let g:default_font = 9

    function! s:set_font(font_size)
        call rpcnotify(1, 'Gui', 'Font', 'Iosevka '.a:font_size)
    endfunction
    command! -nargs=1 SetFont call s:set_font(<q-args>)
    command! -nargs=0 ResetFont call s:set_font(g:default_font)

    call s:set_font(g:default_font)
    call rpcnotify(1, 'Gui', 'FontFeatures', 'PURS, cv17')
    call rpcnotify(1, 'Gui', 'Option', 'Popupmenu', 0)
else
    Guifont! Iosevka Term:h9
endif
