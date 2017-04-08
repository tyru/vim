" Tests for tabsidebar

function! Test_settabsidebar()
  silent! tabonly!
  let text = "Test_settabsidebar"
  let n = 3
  for i in range(1, n)
    tabnew
  endfor
  call assert_equal(0, settabsidebar(-1, text))
  call assert_equal(0, settabsidebar(0, text))
  for i in range(0, n)
    call assert_equal(1, settabsidebar(i + 1, text))
  endfor
  call assert_equal(0, settabsidebar(n + 2, text))
  call assert_equal(0, settabsidebar(n + 3, text))
  for i in range(1, n)
    quit
  endfor
endfunc

function! Test_gettabsidebar()
  silent! tabonly!
  let text = 'Test_gettabsidebar'
  let n = 3
  for i in range(1, n)
    tabnew
  endfor
  for i in range(0, n)
    call settabsidebar(i + 1, text . i)
  endfor
  call assert_equal("", gettabsidebar(-1))
  call assert_equal("", gettabsidebar(0))
  for i in range(0, n)
    call assert_equal(text . i, gettabsidebar(i + 1))
  endfor
  call assert_equal("", gettabsidebar(n + 2))
  call assert_equal("", gettabsidebar(n + 3))
endfunc

function! Test_tabsidebar()
  silent! tabonly!
  set showtabsidebar=2
  set tabsidebarcolumns=20
  call settabsidebar(1, "Test_tabsidebar")
  tabnew
  call settabsidebar(2, "vim")
  tabnew
  call settabsidebar(3, "%{g:actual_curtabpage}")
  tabnew
  call settabsidebar(4, "%{g:actual_curtabpage}")
  tabnew
  call settabsidebar(5, "%{g:actual_curtabpage}")
  redraw!

  call assert_equal('T', nr2char(screenchar(1, 1)))
  call assert_equal('e', nr2char(screenchar(1, 2)))
  call assert_equal('s', nr2char(screenchar(1, 3)))
  call assert_equal('t', nr2char(screenchar(1, 4)))
  call assert_equal('_', nr2char(screenchar(1, 5)))
  call assert_equal('t', nr2char(screenchar(1, 6)))
  call assert_equal('a', nr2char(screenchar(1, 7)))
  call assert_equal('b', nr2char(screenchar(1, 8)))
  call assert_equal('s', nr2char(screenchar(1, 9)))
  call assert_equal('i', nr2char(screenchar(1, 10)))
  call assert_equal('d', nr2char(screenchar(1, 11)))
  call assert_equal('e', nr2char(screenchar(1, 12)))
  call assert_equal('b', nr2char(screenchar(1, 13)))
  call assert_equal('a', nr2char(screenchar(1, 14)))
  call assert_equal('r', nr2char(screenchar(1, 15)))

  call assert_equal('v', nr2char(screenchar(2, 1)))
  call assert_equal('i', nr2char(screenchar(2, 2)))
  call assert_equal('m', nr2char(screenchar(2, 3)))
  call assert_equal(' ', nr2char(screenchar(2, 4)))
  call assert_equal(' ', nr2char(screenchar(2, 5)))
  call assert_equal(' ', nr2char(screenchar(2, 6)))
  call assert_equal(' ', nr2char(screenchar(2, 7)))
  call assert_equal(' ', nr2char(screenchar(2, 8)))
  call assert_equal(' ', nr2char(screenchar(2, 9)))

  call assert_equal('3', nr2char(screenchar(3, 1)))

  call assert_equal('4', nr2char(screenchar(4, 1)))

  call assert_equal('5', nr2char(screenchar(5, 1)))
endfunc

" vim: shiftwidth=2 sts=2 expandtab
