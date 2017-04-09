" Tests for tabsidebar

function! s:cleanup()
  silent! tabonly!
  set tabline&
  set showtabline&
  set tabsidebar&
  set showtabsidebar&
  set tabsidebarcolumns&
endfunc

function! Test_settabsidebar()
  call s:cleanup()
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
  call s:cleanup()
endfunc

function! Test_gettabsidebar()
  call s:cleanup()
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
  call s:cleanup()
endfunc

function! Test_tabsidebar()
  call s:cleanup()
  set showtabsidebar=2
  set tabsidebarcolumns=10
  call settabsidebar(1, "Test_tabsidebar")
  tabnew
  call settabsidebar(2, "vim")
  tabnew
  call settabsidebar(3, "%{g:actual_curtabpage}")
  tabnew
  call settabsidebar(4, "%=!")
  tabnew
  call settabsidebar(5, "%{g:actual_curtabpage}")
  tabnew
  set tabsidebar=hi
  tabnew
  call settabsidebar(7, "%{g:actual_curtabpage}")
  tabnew
  call settabsidebar(8, "%{g:actual_curtabpage}")
  tabnew
  call settabsidebar(9, "%{g:actual_curtabpage}")
  tabnew
  call settabsidebar(10, "%{g:actual_curtabpage}")
  redraw!

  call assert_equal('<', nr2char(screenchar(1, 1)))
  call assert_equal('a', nr2char(screenchar(1, 2)))
  call assert_equal('b', nr2char(screenchar(1, 3)))
  call assert_equal('s', nr2char(screenchar(1, 4)))
  call assert_equal('i', nr2char(screenchar(1, 5)))
  call assert_equal('d', nr2char(screenchar(1, 6)))
  call assert_equal('e', nr2char(screenchar(1, 7)))
  call assert_equal('b', nr2char(screenchar(1, 8)))
  call assert_equal('a', nr2char(screenchar(1, 9)))
  call assert_equal('r', nr2char(screenchar(1, 10)))

  call assert_equal('v', nr2char(screenchar(2, 1)))
  call assert_equal('i', nr2char(screenchar(2, 2)))
  call assert_equal('m', nr2char(screenchar(2, 3)))
  for i in range(4, &tabsidebarcolumns)
    call assert_equal(' ', nr2char(screenchar(2, i)))
  endfor

  call assert_equal('3', nr2char(screenchar(3, 1)))

  for i in range(1, &tabsidebarcolumns - 1)
    call assert_equal(' ', nr2char(screenchar(4, i)))
  endfor
  call assert_equal('!', nr2char(screenchar(4, &tabsidebarcolumns)))

  call assert_equal('5', nr2char(screenchar(5, 1)))

  call assert_equal('h', nr2char(screenchar(6, 1)))
  call assert_equal('i', nr2char(screenchar(6, 2)))

  call assert_equal('7', nr2char(screenchar(7, 1)))

  call assert_equal('8', nr2char(screenchar(8, 1)))

  call assert_equal('9', nr2char(screenchar(9, 1)))

  call assert_equal('1', nr2char(screenchar(10, 1)))
  call assert_equal('0', nr2char(screenchar(10, 2)))

  call s:cleanup()
endfunc

function! Test_tabsidebar_local_or_global()
  call s:cleanup()
  let text1 = 'abc'
  let text2 = 'def'
  let text3 = 'ghi'
  tabnew
  tabnew
  call settabsidebar(1, text1)
  call settabsidebar(2, text2)
  call settabsidebar(3, text3)

  call assert_equal(text1, gettabsidebar(1))
  call assert_equal(text2, gettabsidebar(2))
  call assert_equal(text3, gettabsidebar(3))

  tabclose

  call assert_equal(text1, gettabsidebar(1))
  call assert_equal(text2, gettabsidebar(2))
  call assert_equal('', gettabsidebar(3))

  tabclose

  call assert_equal(text1, gettabsidebar(1))
  call assert_equal('', gettabsidebar(2))
  call assert_equal('', gettabsidebar(3))

  tabnew

  call assert_equal(text1, gettabsidebar(1))
  call assert_equal('', gettabsidebar(2))
  call assert_equal('', gettabsidebar(3))

  call s:cleanup()
endfunc

" vim: shiftwidth=2 sts=2 expandtab
