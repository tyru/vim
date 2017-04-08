" Tests for tabsidebar

" &tabsidebar
" &tabsidebarcolumns
" g:actual_curtabpage
" gettabsidebar({tabnr})
" settabsidebar({tabnr}, {text})
" screenchar({row}, {col})
" screencol()
" screenrow()

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
endfunc

" vim: shiftwidth=2 sts=2 expandtab
