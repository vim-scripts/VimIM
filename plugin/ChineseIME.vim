" ===============================================================
"        File:  ChineseIME.vim
"      Author:  Sean Ma <maxiangjiang_at_gmail.com>
" Last Change:  January 5, 2009
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
"      set enc = utf8
"      set gfn = Courier_New:h12:w7
"      set gfw = SimSun-18030,Arial_Unicode_MS
" ---------------------------------------------------------------
"  References:
"  (1) http://en.wikipedia.org/wiki/Input_method_editor
"  (2) http://en.wikipedia.org/wiki/Chinese_input_methods_for_computers
"  (3) http://blah.blogsome.com/2006/06/27/vim7_tut_oc/
"  (4) http://blah.blogsome.com/2007/08/23/vim_cn_faq/
"  (5) http://www.vim.org/scripts/script.php?script_id=1879
"  (6) http://vim.sourceforge.net/scripts/script.php?script_id=999
"  (7) http://maxiangjiang.googlepages.com/chinese.html
"  (8) http://groups.google.com/group/vim_use/topics
" ---------------------------------------------------------------
"  The data file:
"
"  Note: The data file has to be sorted before it can be used.
"        This is for performance consideration.
"
"  The basic format of the data file is made of three columns:
"
"  +=========|==============================|=========+
"  |column A |          column B            |column C |
"  +---------|------------------------------|---------+
"  |  <key>  | <space>   comments   <space> | <value> |
"  +=========|==============================|=========+
"  |   ma    |          (optional)          |    馬   |
"  +=========|==============================|=========+
"
"  The <key> is what is typed in alphabet, ready to be replaced.
"  The middle column can add additional comments                 
"  The <value> is in the last column, which is what will be input
"
"  In principle, any input method (Wubi, Pinyin, English, etc)
"  can be used as long as a data file is made available.
"
"  A sample data file based on Pinyin can be found from
"  http://maxiangjiang.googlepages.com/ChineseIME.dict
"  It has 30127 lines, which are extracted from
"  http://maxiangjiang.googlepages.com/ChineseIME.html
" ---------------------------------------------------------------
"
"  The .vimrc setting preference:
"
"  (1) to pick up the default right away  (i_<C-^>)
"      let g:ChineseIME_Toggle_i_Ctrl6=1
"  (2) to make input more "intelligent"   (i_<C-\>)
"      let g:ChineseIME_Toggle_InertMode=1
"  (3) to make popup menu less "offensive"
"      highlight! Pmenu      NONE
"      highlight! PmenuThumb NONE
"  (4) [optional, experimental] install "autocomplpop.vim" plugin
"      to automatically open the popup menu
" ---------------------------------------------------------------

" ---------------------------------------------------------------
" Options:
"
"   g:ChineseIME_Toggle_InertMode:
"     => toggle punctuation
"     => toggle the use of <Space> to trigger popup
"     => toggle cursor color to identify the 'IME mode'
"     => toggle options 'pumheight', 'completeopt', 'lazyredraw'
"     Note: i_<C-\> is used to toggle this feature
"           :pro: convenient and consistent like other IME
"           :con: need to get used to <Space> key
"           default: 0
"
"   g:ChineseIME_Toggle_i_Ctrl6:
"     define i_<C-^> as <C-X><C-U><C-U><C-P><C-N>
"     Note: default: 0
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

if !exists("g:ChineseIME_Toggle_InertMode")
    let g:ChineseIME_Toggle_InertMode = 0
endif

if !exists("g:ChineseIME_Toggle_i_Ctrl6")
     let g:ChineseIME_Toggle_i_Ctrl6 = 0
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
       let last_value = get(popupmenu_list,-1)
       call complete_add(last_value)
    endfor

    return []

  endif
endfunction


let s:n = 0
function! ChineseIME_Toggle_InertMode()
     if s:n%2 == 0
         " -----------------------------------  options
         let s:saved_pumheight=&pumheight
         let s:saved_completeopt=&completeopt
         let s:saved_lazyredraw=&lazyredraw
         set pumheight=10
         set completeopt=menu,preview,longest
         set nolazyredraw
         " -----------------------------------  cursor highlight
         highlight Cursor guifg=bg guibg=Green
         " -----------------------------------  <Space>
         imap <Space> <C-X><C-U><C-U><C-P><C-N>
         " -----------------------------------  punctuation
         imap (  <C-V>uff08
         imap )  <C-V>uff09
         imap ,  <C-V>uff0c
         imap .  <C-V>u3002
         imap :  <C-V>uff1a
         imap ;  <C-V>uff1b
         imap <  <C-V>u3008
         imap >  <C-V>u3009
         imap ?  <C-V>uff1f
         imap [  <C-V>u3010
         imap ]  <C-V>u3011
         imap \\ <C-V>u3001
         " -----------------------------------
     else
         " -----------------------------------  options
         let &pumheight=s:saved_pumheight
         let &completeopt=s:saved_completeopt
         let &lazyredraw=s:saved_lazyredraw
         " -----------------------------------  cursor highlight
         highlight Cursor guifg=bg guibg=fg
         " -----------------------------------  <Space>
         iunmap <Space>
         " -----------------------------------  punctuation
         iunmap (
         iunmap )
         iunmap ,
         iunmap .
         iunmap :
         iunmap ;
         iunmap <
         iunmap >
         iunmap ?
         iunmap [
         iunmap ]
         iunmap \\
         " -----------------------------------
     endif
     let s:n += 1
endfunction


if g:ChineseIME_Toggle_InertMode
    imap <buffer> <C-\>  <C-O>:call ChineseIME_Toggle_InertMode()<CR>
endif


if g:ChineseIME_Toggle_i_Ctrl6
    imap <buffer> <C-^>  <C-X><C-U><C-U><C-P><C-N>
endif

