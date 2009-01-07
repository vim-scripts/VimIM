" ===============================================================
"        File:  ChineseIM.vim
"      Author:  Sean Ma <maxiangjiang_at_gmail.com>
" Last Change:  January 7, 2009
"         URL:  http://vim.sourceforge.net/scripts/script.php?script_id=2506
" Description:  This is a vim plugin used as an independent built-in
"               IM (Input Method) to input Chinese using vim
"               omni completion feature. The input method could be
"               anything, depending on the data file.
"   Quick Demo: (1) Assumption: vim is configured to show Chinese
"               (2) source this script file by :source %
"               (3) when in Insert mode, type:  chin<C-X><C-U>
" Installation: (1) download a sample data file from link below
"               (2) save this file and data file in the plugin directory
"   Data File:  http://maxiangjiang.googlepages.com/ChineseIM.dict
" Screen Shot:  http://maxiangjiang.googlepages.com/vim_ime.gif
"    Features:  # Chinese can be input if it can be read within vim
"               # It is independent of the Operating System
"               # It is independent of vim |mbyte-XIM| API
"               # It is independent of vim |mbyte-IME| API
"               # The data file is under one's own control
"               # The input method is controlled by the data file
" ===============================================================

" ===============================================================
"                       Chinese IM Backgrounds
" ===============================================================
"  Assumptions:
"  (1) Chinese can be read from within vim
"  (2) The utf-8 format is used both in memory and on disk
"  (3) The .vimrc is correctly set, for example, on my W2K box:
"      set enc = utf8
"      set gfn = Courier_New:h12:w7
"      set gfw = SimSun-18030,Arial_Unicode_MS
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
"  can be used as long as a valid data file is made available.
"
"  A sample data file based on Pinyin can be found from
"  http://maxiangjiang.googlepages.com/ChineseIM.dict
"  It has 37395 lines, which are basically extracted from
"  http://maxiangjiang.googlepages.com/Chinese.html
" ---------------------------------------------------------------
" Options:
"
"   -----------------------------
"   g:ChineseIM_InsertMode_Toggle
"   -----------------------------
"     => toggle punctuation: , .  : ; ? \ () <> []
"     => toggle the use of <Space> to trigger the popup menu
"     => toggle options 'pumheight', 'completeopt', 'lazyredraw'
"     => toggle cursor color to identify the 'IM mode'
"     => toggle status line  to identify the 'IM mode'
"     Note: i_<C-\> is used to toggle this feature
"           pro: convenient and consistent like other IM
"           con: need to get used to <Space> key
"           default: 0
"
"   ------------------------
"   g:ChineseIM_Ctrl6_Toggle
"   ------------------------
"     Note: purpose: define i_<C-^> as <C-X><C-U><C-U><C-P><C-N>
"           pro: input the default right away
"           default: 0
"
" ---------------------------------------------------------------
"  The .vimrc setting preference:
"
"  (1) i_<C-^> => to pick up the default right away      
"      let g:ChineseIM_Ctrl6_Toggle=1
"  (2) i_<C-\> => to make IM Insert mode more "intelligent" 
"      let g:ChineseIM_InsertMode_Toggle=1
"  (3) to make popup menu less "offensive"
"      highlight! Pmenu      NONE
"      highlight! PmenuThumb NONE
"  (4) [optional, experimental] install "autocomplpop.vim" plugin
"      to automatically open the popup menu
" ---------------------------------------------------------------
"  References:
"
"  (1) http://en.wikipedia.org/wiki/Input_method_editor
"  (2) http://en.wikipedia.org/wiki/Chinese_input_methods_for_computers
"  (3) http://blah.blogsome.com/2006/06/27/vim7_tut_oc/
"  (4) http://blah.blogsome.com/2007/08/23/vim_cn_faq/
"  (5) http://www.vim.org/scripts/script.php?script_id=1879
"  (6) http://vim.sourceforge.net/scripts/script.php?script_id=999
"  (7) http://maxiangjiang.googlepages.com/chinese.html
"  (8) http://groups.google.com/group/vim_use/topics
" ---------------------------------------------------------------


" ===============================================================
"                         VIM Control Logic
" ===============================================================
if exists("loaded_ChineseIM")
  finish
endif
let loaded_ChineseIM = 1

let datafile = "ChineseIM.dict"
let datafile = expand("<sfile>:p:h")."/".datafile
if getftype(datafile) == 'file'
    let s:lines = readfile(datafile)
else
    let line1 = "ma " . nr2char(39340)
    let line2 = "ma " . nr2char(21527)
    let line3 = "ma " . nr2char(22920)
    let line4 = "ma " . nr2char(39532)
    let line5 = "china    中国"
    let line6 = "chinese  中国人"
    let line7 = "chinese  中文"
    let line8 = "chinese  汉字"
    let demo_list = [line1,line2,line3,line4,line5,line6,line7,line8]
    let s:lines = demo_list
endif

if !exists("g:ChineseIM_InsertMode_Toggle")
    let g:ChineseIM_InsertMode_Toggle = 0
endif

if !exists("g:ChineseIM_Ctrl6_Toggle")
     let g:ChineseIM_Ctrl6_Toggle = 0
endif

set completefunc=ChineseIM
function! ChineseIM(start, base)

  if a:start

    let current_line = getline('.')
    let start_col = col('.')-1
    let start_char = current_line[start_col-1]
    " to avoid hang on triggering non-word char
    " -----------------------------------------
    if( start_char =~ '\w' )
       while start_col > 0 && current_line[start_col-1] =~ '\w'
         let start_col -= 1
       endwhile
       return start_col
    endif

  else

    " no more cache, no more full range scan
    " find out the exact range on the sorted data file
    " ------------------------------------------------
    let counts = 0
    let pat = '^' . a:base
    let pat_one      = pat .   '\> '
    let pat_one_more = pat . '\w\> '
    let start_match = match(s:lines, pat)
    let next_match = start_match

    " to limit search where short characters are typed
    " the default setting is hard-coded to be 2
    " for example, a<C-^> only shows maps for a only, not 'aiqing'
    " ------------------------------------------------
    if len(a:base) <= 2
      " ------------------------------------------------
      " only works when the datafile is sorted by len(word)
      " let pat = pat_one . '\|' .  pat_one_more
      " ------------------------------------------------
      let pat = pat_one
    endif

    while next_match >= 0
      let counts += 1
      let next_match = match(s:lines, pat, start_match, counts)
    endwhile

    " now simply store the list from start index to end index
    " -------------------------------------------------------
    let end_match = start_match + counts - 2
    let matched_range_list = s:lines[start_match : end_match]

    let popupmenu = []
    for line in matched_range_list
      let popupmenu_list = split(line,'\s\+')
      let first_value = get(popupmenu_list,0)
      let last_value  = get(popupmenu_list,-1)

      " showing Chinese only on the popup menu
      " --------------------------------------
      " call add(popupmenu, last_value)

      " showing more info on the popup menu
      " -----------------------------------
      let menu_dict = {}
      let menu_dict["word"] = last_value
      let menu_dict["menu"] = first_value

      call add(popupmenu, menu_dict)
    endfor
    return popupmenu

  endif

endfunction


let s:n = 0
function! ChineseIM_InsertMode_Toggle()
     if s:n%2 == 0
         " -----------------------------------  options
         let s:saved_pumheight=&pumheight
         let s:saved_completeopt=&completeopt
         let s:saved_lazyredraw=&lazyredraw
         let s:saved_iminsert=&iminsert
         set pumheight=10
         set completeopt=menu,longest
         set nolazyredraw
         " -----------------------------------  IM mode indication
         set iminsert=1
         highlight Cursor guifg=bg guibg=bg
         " -----------------------------------  <Space>
         imap <Space> <C-X><C-U><C-U><C-P><C-N>
         " -----------------------------------  bracket
         imap (  <C-V>uff08
         imap )  <C-V>uff09
         imap <  <C-V>u3008
         imap >  <C-V>u3009
         imap [  <C-V>u3010
         imap ]  <C-V>u3011
         " -----------------------------------  punctuation
         imap ,  <C-V>uff0c<Space>
         imap .  <C-V>u3002<Space>
         imap :  <C-V>uff1a<Space>
         imap ;  <C-V>uff1b<Space>
         imap ?  <C-V>uff1f<Space>
         imap \\ <C-V>u3001<Space>
         " -----------------------------------
     else
         " -----------------------------------  options
         let &pumheight=s:saved_pumheight
         let &completeopt=s:saved_completeopt
         let &lazyredraw=s:saved_lazyredraw
         " -----------------------------------  IM mode indication
         let &iminsert=s:saved_iminsert
         highlight Cursor guifg=bg guibg=fg
         " -----------------------------------  <Space>
         imap <Space> <Space>
         " -----------------------------------  bracket
         imap (  (
         imap )  )
         imap <  <
         imap >  >
         imap [  [
         imap ]  ]
         " -----------------------------------  punctuation
         imap ,  ,
         imap .  .
         imap :  :
         imap ;  ;
         imap ?  ?
         imap \\ \\
         " -----------------------------------
     endif
     let s:n += 1
endfunction


if g:ChineseIM_InsertMode_Toggle
    imap <buffer> <C-\>  <C-O>:call ChineseIM_InsertMode_Toggle()<CR>
endif

if g:ChineseIM_Ctrl6_Toggle
    imap <buffer> <C-^>  <C-X><C-U><C-U><C-P><C-N>
endif


