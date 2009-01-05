" ===============================================================
"        File:  ChineseIME.vim
"      Author:  Sean Ma <maxiangjiang_at_gmail.com>
" Last Change:  January 4, 2009
"         URL:  http://vim.sourceforge.net/scripts/script.php?script_id=2506
" Description:  This is a vim plugin used as an independent built-in
"               IME (Input Method Editor) to input Chinese using vim
"               omni completion feature. The input method could be
"               anything, depending on the data file.
" Installation: (a) download a sample data file from link below
"               (b) save this file and data file in the plugin directory
"   Data File:  http://maxiangjiang.googlepages.com/ChineseIME.dict
" Screen Shot:  http://maxiangjiang.googlepages.com/vim_ime.gif
"    Features:  (a) Chinese can be input if it can be read within vim
"               (b) It is independent of the Operating System
"               (c) It is independent of vim |+multi_byte_ime| API
"               (d) The data file is under one's own control
"               (e) The input method is controlled by the data file
" ===============================================================

" ===============================================================
"                       Chinese IME Backgrounds
" ===============================================================
"  Assumptions:
"  (1) Chinese can be read from within vim
"  (2) The utf-8 format is used both in memory and on disk
"  (3) The .vimrc is correctly set, for example, on my W2K box:
"      set enc=utf8
"      set gfn=Courier_New:h12:w7
"      set gfw=SimSun-18030,Arial_Unicode_MS
" ---------------------------------------------------------------
"  References:
"  (1) http://en.wikipedia.org/wiki/Input_method_editor
"  (2) http://en.wikipedia.org/wiki/Chinese_input_methods_for_computers
"  (3) http://blah.blogsome.com/2006/06/27/vim7_tut_oc/
"  (4) http://blah.blogsome.com/2007/08/23/vim_cn_faq/
"  (5) http://www.vim.org/scripts/script.php?script_id=1879
"  (6) http://vim.sourceforge.net/scripts/script.php?script_id=999
"  (7) http://maxiangjiang.googlepages.com/chinese.html
" ---------------------------------------------------------------
"  The data file:
"
"  Note: The data file has to be sorted before it can be used.
"        This is for performance consideration.
"
"  The basic format of the data file is made of three columns:
"
"  +=========+=========+=========+
"  |column A |column B |column C |
"  +---------+---------+---------+
"  |  <key>  | <space> | <value> |
"  +=========+=========+=========+
"  |   ma    |         |    馬   |
"  +=========+=========+=========+
"
"  The <key> is what is typed in alphabet, ready to be replaced.
"  The <apace> can be any whitespace character in any combination
"  The <value> is what will be input
"
"  In principle, any input method (Wubi, Pinyin, Four corner, etc)
"  can be used as long as a data file is made available.
"
"  A sample data file based on Pinyin can be found from
"  http://maxiangjiang.googlepages.com/ChineseIME.dict
"  It has 30127 lines, which are extracted from
"  http://maxiangjiang.googlepages.com/ChineseIME.html
" ---------------------------------------------------------------
"  Tips:
"  (1) The data file can also include English as the key
"  (2) The data file can contain comments with any non-word character
"  (3) The sequence of data file can be adjusted based on frequency
"  (4) Reference #5 may be used to automatically open the popup menu
" ---------------------------------------------------------------
"  The .vimrc setting preference:
"  (1) map i_<C-^> to pick up the default right away
"      let g:ChineseIMEMappingCtrl6=1
"  (2) map i_<Tab> to make <Space> "intelligent"
"      let g:ChineseIMESpaceToggle=1
"  (3) to limit the maximum height of popup menu
"      setlocal pumheight=10
"  (4) to make sure 'menu' is added
"      setlocal completeopt=menu,preview,longest
"  (5) to avoid screen mess up
"      setlocal nolazyredraw
"  (6) to make popup menu less "offensive"
"      highlight! Pmenu      NONE
"      highlight! PmenuThumb NONE
" ---------------------------------------------------------------

" ---------------------------------------------------------------
" Options:
"
"   g:ChineseIMESpaceToggle:
"     toggle the use of <Space> to trigger popup menu
"     i_<Tab> is used to toggle this feature
"     :pro: convenient and consistent like other IMEs
"     :con: need to get used to <Space> key
"     default: 0
"
"   g:ChineseIMEMappingCtrl6:
"     define i_<C-^> as <C-X><C-U><C-U><C-P><C-N>
"     default: 0
" ---------------------------------------------------------------


" ===============================================================
"                         VIM Control Logic
" ===============================================================
if exists("loaded_ChineseIME")
  finish
endif
let loaded_ChineseIME = 1

set completefunc=ChineseIME
let s:datafile=expand("<sfile>:p:h") ."/". "ChineseIME.dict"
let s:lines = readfile(s:datafile)

if !exists("g:ChineseIMESpaceToggle")
    let g:ChineseIMESpaceToggle = 0
endif

if !exists("g:ChineseIMESpaceToggle")
    let g:ChineseIMEMappingCtrl6 = 0
endif


function! ChineseIME(start, base)

  let current_line = getline('.')
  let start_col = col('.')-1
  let start_char = current_line[start_col-1]

  if a:start

    " to avoid hang on triggering non-word char
    if( start_char =~ '\w' )
       while start_col > 0 && current_line[start_col-1] =~ '\w'
         let start_col -= 1
       endwhile
       return start_col
    endif

  else

    " no more cache, no more full range scan
    " find out the exact range on the sorted data file
    let start_match = match(s:lines, "^".a:base)

    let counts = 0
    let next_match = start_match
    while next_match > 0 
      let counts += 1
      let next_match = match(s:lines, "^".a:base, 0, counts)
    endwhile

    let end_match = start_match + counts -2

    let match_range_list = s:lines[start_match : end_match]

    for line in match_range_list
       let popupmenu_list = split(line,'\s\+')
       let line = get(popupmenu_list,1)
       call complete_add(line)
    endfor

    return []

  endif
endfunction


let s:n = 0
function! ChineseIMESpaceToggle()
     if s:n%2 == 0
         imap <Space> <C-X><C-U><C-U><C-P><C-N>
     else
         iunmap <Space>
     endif
     let s:n += 1
endfunction


if g:ChineseIMESpaceToggle
    imap <buffer><C-I> <C-O>:call ChineseIMESpaceToggle()<CR>
endif


if g:ChineseIMEMappingCtrl6
    imap <buffer><C-^> <C-X><C-U><C-U><C-P><C-N>
endif


