au BufWritePost *.elm call BuildBoth()

function! BuildBoth()
  echo "Building"
  ElmMake
endfunction
