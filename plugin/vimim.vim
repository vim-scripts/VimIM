" ===============================================================
"        vimim -- input method by vim, of vim, for vimmers
" ===============================================================
" == The vimim Introduction == {{{
" ---------------------------------------------------------------
"        File:  vimim.vim
"      Author:  Sean Ma <maxiangjiang_at_cornell_dot_edu>
" Last Change:  20090118T105950
"         URL:  http://vim.sourceforge.net/scripts/script.php?script_id=2506
" Description:  This is a vim plugin designed as an independent
"               IM (Input Method) using vim omni completion feature.
"               It can be used as the 3rd way for vim to input non-ascii
"               using i_<C-^> in addition to i_<C-V> and i_<C-K>.
"    Features:  - CJK can be input if it can be read within vim.
"               - It is independent of the Operating System.
"               - It is independent of vim "mbyte-XIM/mbyte-IME" API.
"               - The input methods can be freely defined.
"               - The data file format is open, simple and flexible.
"               - The all power wildcard is supported.
"               - The One_key speeds up ad hoc Chinese input.
"               - The Smart_Space_Key makes using vimim comfortable.
"               - The menu label can be used for selection & navigation.
" Installation: (1) download any data file you like from the link below
"               (2) save this file and data file in the plugin directory
"   Data File:  http://maxiangjiang.googlepages.com/vimim.pinyin
"               http://maxiangjiang.googlepages.com/vimim.wubi
"               http://maxiangjiang.googlepages.com/vimim.cangjie
"               http://maxiangjiang.googlepages.com/vimim.english
"               http://maxiangjiang.googlepages.com/vimim.quick
"               http://maxiangjiang.googlepages.com/vimim.4corner
"  ScreenShot:  http://maxiangjiang.googlepages.com/vimim.vim.gif
" Latest Code:  http://maxiangjiang.googlepages.com/vimim.vim
" Chinese URL:  http://maxiangjiang.googlepages.com/vimim.html
" ----------------------------------------------------------- }}}

" == The vimim Backgrounds == {{{
" ===============================
" Design Goals:
" -------------
"   (1) Chinese can be input using vim regardless of encoding
"   (2) Without any negative impact to vim if vimim is not used
"   (3) Useful options to make using vimim comfortable
"   (4) No comprise for high speed and low memory usage

" About vimim Options:
" --------------------
"  (1) One_Key to get the default value right away
"      let g:vimim_one_key_input=1
"      ---------------------------
"      => One_Key to pick up the default
"      => One_Key to perform proper cycle navigation
"      The default key is i_<C-^>
"
"  (2) Smart_Space_Key to make vimim comfortable
"      let g:vimim_smart_space_key=1
"      -------------------------------
"      => Smart <Space> to trigger the popup menu
"      => Toggle vimim Insert Mode automatically
"      => Toggle English and Chinese punctuation
"      => Toggle cursor color to identify the "IM mode"
"      Note: It is consistent to and better than other IM
"      The default key is i_<C-\>
"
"  (3) Smart_Number_Key
"      let g:vimim_enable_number_label=1
"      ---------------------------------
"      => add label to the popup menu
"      => number key can be used for selectioin
"      => number key can be used for navigation
"      The default are [1:9] number keys
"
"  (4) Other supported features:
"      # support wildcard * as in grep
"      # toggle English and Chinese punctuation
"      # switch two data files on the fly
"      # support all capitals English input

" About the data file:
" --------------------
" The data file has to be sorted (:sort) before it can be used.
" The basic format of the data file is simple and flexible:
"
"                 +-------+---------+---------+
"                 | <key> | <space> | <value> |
"                 +=======+=========+=========+
"                 |  ma   |         |    馬   |
"                 +-------+---------+---------+
"
" The <key> is what is typed in alphabet, ready to be replaced.
" The <value>, separated by spaces, is what will be input.
" The 2nd column and the 3rd column can be repeated many times.
"
" In principle, any input method (Wubi, Pinyin, English, etc)
" can be used as long as a valid data file is available.
" The advanced vimim users can create their own input method by
" using their own data file.
"
" Several sample data files are provided, ready to be played.
" --------------  ---------------------------
"   vimim.vim           vimim data file
" --------------  ---------------------------
"  vimim.pinyin     input method for PinYin
"  vimim.wubi       input method for WuBi
"  vimim.cangjie    input method for CangJie
"  vimim.english    input method for English
"  vimim.quick      input method for Quick
"  vimim.4corner    input method for 4 Corner
" --------------  ---------------------------

" References:
" -----------
" (1) http://groups.google.com/group/vim_use/topics
" (2) http://www.newsmth.net/bbsdoc.php?board=VIM
" (3) http://vim.sourceforge.net/scripts/script.php?script_id=999
" (4) http://maxiangjiang.googlepages.com/chinese.html
" ================================================ }}}

" == The vimim Core == {{{
" ========================
if exists("loaded_vimim_VIM")
    finish
endif
let loaded_vimim_VIM=1

if !exists("g:vimim_datafile")
    let g:vimim_datafile=0
endif

let path = expand("<sfile>:p:h")."/"
let datafile  =        g:vimim_datafile
let datafileA = path . g:vimim_datafile
let datafileB = path .  "vimim.pinyin"
let datafileC = path .  "vimim.wubi"
let datafileD = path .  "vimim.cangjie"
let datafileE = path .  "vimim.english"
let datafileF = path .  "vimim.quick"
let datafileG = path .  "vimim.4corner"

if filereadable(datafile)
    let s:lines1 = readfile(datafile)
elseif filereadable(datafileA)
    let s:lines1 = readfile(datafileA)
elseif filereadable(datafileB)
    let s:lines1 = readfile(datafileB)
elseif filereadable(datafileC)
    let s:lines1 = readfile(datafileC)
elseif filereadable(datafileD)
    let s:lines1 = readfile(datafileD)
elseif filereadable(datafileE)
    let s:lines1 = readfile(datafileE)
elseif filereadable(datafileF)
    let s:lines1 = readfile(datafileF)
elseif filereadable(datafileG)
    let s:lines1 = readfile(datafileG)
else
    let s:lines1 = []
endif

let s:lines = s:lines1
let s:DataFileToggle=0
" support switch datafile on the fly
" ----------------------------------
if !exists("g:vimim_datafile2")
    let g:vimim_datafile2=0
else
    let datafile2  = g:vimim_datafile2
    let datafile2A = path . datafile2
    if filereadable(datafile2)
        let s:lines2 = readfile(datafile2)
    elseif filereadable(datafile2A)
        let s:lines2 = readfile(datafile2A)
    endif
endif
" -------------------------------
function! VimIM_Datafile_Toggle()
" -------------------------------
    if s:DataFileToggle==0
        let s:DataFileToggle=1
        let s:lines = s:lines2
    else
        let s:DataFileToggle=0
        let s:lines = s:lines1
    endif
endfunction

if !exists("g:vimim_popup_label_start")
    let g:vimim_popup_label_start=0
endif
" ----------------------------
if !exists("g:vimim_enable_number_label")
    let g:vimim_enable_number_label=0
endif

set completefunc=VimIM
" --------------------------
function! VimIM(start, base)
" --------------------------
  if a:start

    let current_line = getline('.')
    let start_col = col('.')-1
    let char_before = current_line[start_col-1]
    let char_valid = '[*0-9A-Za-z]'

    " to avoid hanging on triggering nothing
    " --------------------------------------
    if start_col < 1
        return
    endif

    " to avoid hanging on triggering non-word char
    " --------------------------------------------
    if char_before !~ char_valid
        return
    endif

    " use =~# test if do case sensitive search
    " ----------------------------------------
    while start_col > 0 && current_line[start_col-1] =~ char_valid
        let start_col -= 1
    endwhile
    return start_col

  else

    let abase = a:base
    let errmsg = '-- User defined completion (^U^N^P) Pattern not found'

    " to avoid hanging on empty or non-word
    " -------------------------------------
    if strlen(abase) < 1
        return
    endif

    " to avoid hanging on pattern with <Bslash>
    " -----------------------------------------
    if abase =~ '\\'
        return
    endif

    " to avoid hanging on [pattern]
    " -----------------------------
    if abase =~ '[' && abase =~ ']'
        return
    endif

    " to avoid hanging on multiple wildcard showed first
    " --------------------------------------------------
    if abase =~ '^[*]\+'
        return
    endif

    " to avoid hanging on pattern with all zeroes
    " -------------------------------------------
    if abase =~ '^0\+'
        return
    endif

    " take care of all CAPITALS, return the same
    " ------------------------------------------
    if abase !~ '^\d\+'
        if abase ==# toupper(abase)
            return
        endif
    endif

    " removing everything after * if it is used
    " ------------------------------------------------
    let wildcard = match(abase, '[*]')
    if wildcard > 0
        let abase_head = strpart(abase, 0, wildcard)
        let pat = abase_head
    else
        let pat = abase
    endif

    " Note: limitation for 4 corner data file:
    " (1) assuming exact 4 digits as the key
    " (2) no * support for key with leading zero
    " ---------------------------------------------
    if wildcard < 0
        if pat >0 && pat < 1000
            let pat = printf('%04o',pat)
        else
            let pat = printf('%s',pat)
        endif
    endif

    " no more cache, no more full table scan
    " find out the exact range on the sorted data file
    " ------------------------------------------------
    let pat = '^' . pat
    let start_match = match(s:lines, pat, 0)

    " no more processing if no match
    " ------------------------------
    if start_match < 0
        return
    endif

    " When no wildcard, limit search for 2 characters
    " for example, ma<C-X><C-U> only search ^ma\>
    " ---------------------------------------------------
    if wildcard < 0
        if strlen(a:base) <= 2
            let pat = pat . '\> '
        endif
    endif

    let counts = 0
    let next_match = 1
    while next_match >= 0
        let counts += 1
        let next_match = match(s:lines, pat, start_match, counts)
    endwhile

    let end_match = start_match + counts - 2

    " now simply store the list from start index to end index
    " -------------------------------------------------------
    let matched_range_list = s:lines[start_match : end_match]

    let label = g:vimim_popup_label_start
    let popupmenu_list = []
    for line in matched_range_list

        " to relieve UTF-8 encoding restriction
        " -------------------------------------
        let line = iconv(line, "utf-8", &enc)

        let oneline_list = split(line, '\s\+')
        let menu = remove(oneline_list, 0)

        " filter out items not matching * (zero or more)    */star*
        " ---------------------------------------------------------
        if wildcard > 0
            let abase_wildcard = substitute(abase, '[*]', '.*', 'g')
            let abase_wildcard = abase_wildcard . '\>'
            if menu !~ abase_wildcard
                continue
            endif
        endif

        for word in oneline_list
            let complete_items = {}
            let abbr = printf('%2s',label) . "\t" . word
            let complete_items["word"] = word
            if g:vimim_enable_number_label || g:vimim_popup_label_start
                let complete_items["abbr"] = abbr
            endif
            let complete_items["menu"] = menu
            let label = label + 1
            call add(popupmenu_list, complete_items)
        endfor
    endfor
    return popupmenu_list
  endif
endfunction
" ====================== }}}

" == The vimim Helper == {{{
" ==========================

" ################################  VimIM__Menu_Label

" ----------------------
function! VimIM_Labels()
" ----------------------
    for n in range(1,9)
        exe 'imap <silent> <expr> '.n.' VimIM_Label('.n.')'
    endfor
endfunction

" ----------------------
function! VimIM_Label(n)
" ----------------------
    if pumvisible()
        let count_lines_downward = repeat("\\<C-N>", a:n)
        exe 'return "' . count_lines_downward . '"'
    else
        return a:n
    endif
endfunction

if g:vimim_enable_number_label
    call VimIM_Labels()
endif

" ################################  VimIM__One_Key

if !exists("g:vimim_one_key_input")
    let g:vimim_one_key_input=0
endif
" ----------------------------
if g:vimim_one_key_input
    imap <silent> <expr> <C-^> VimIMOneKey()
endif

function! VimIMOneKey()
    if pumvisible()
        return "\<C-N>"
    else
        return "\<C-X>\<C-U>\<C-P>\<C-N>"
    endif
endfunction

" ################################  VimIM__Chinese_Punctuation

let s:vimim_punctuation=0
" ------------------------------
function! VimIM_Punctuation_On()
" ------------------------------
    let s:vimim_punctuation=1
    inoremap  (  <C-V>uff08
    inoremap  )  <C-V>uff09
    inoremap  {  <C-V>u300e
    inoremap  }  <C-V>u300f
    inoremap  [  <C-V>u3010
    inoremap  ]  <C-V>u3011
    inoremap  <  <C-V>u300a
    inoremap  >  <C-V>u300b
    inoremap  +  <C-V>uff0b
    inoremap  -  <C-V>uff0d
    inoremap  ,  <C-V>uff0c
    inoremap  .  <C-V>u3002
    inoremap  :  <C-V>uff1a
    inoremap  ;  <C-V>uff1b
    inoremap  ?  <C-V>uff1f
    inoremap  !  <C-V>uff01
    inoremap  ~  <C-V>uff5e
    inoremap  #  <C-V>uff03
    inoremap  %  <C-V>uff05
    inoremap  $  <C-V>uffe5
    inoremap  &  <C-V>u203b
    inoremap  @  <C-V>u25ce
    inoremap  \\ <C-V>u3001
    inoremap  ^  <C-V>u2026<C-V>u2026
    inoremap  _  <C-V>u2014<C-V>u2014
    inoremap  "  <C-V>u201c<C-V>u201D
    inoremap  '  <C-V>u2018<C-V>u2019
endfunction

" -------------------------------
function! VimIM_Punctuation_Off()
" -------------------------------
    let s:vimim_punctuation=0
    imap  (  (
    imap  )  )
    imap  {  {
    imap  }  }
    imap  [  [
    imap  ]  ]
    imap  <  <
    imap  >  >
    imap  +  +
    imap  -  -
    imap  ,  ,
    imap  .  .
    imap  :  :
    imap  ;  ;
    imap  ?  ?
    imap  !  !
    imap  ~  ~
    imap  #  #
    imap  %  %
    imap  $  $
    imap  &  &
    imap  @  @
    imap  ^  ^
    imap  _  _
    imap  "  "
    imap  '  '
    imap  \\ \\
endfunction

" ----------------------------------
function! VimIM_Punctuation_Toggle()
" ----------------------------------
    if s:vimim_punctuation == 0
        call VimIM_Punctuation_On()
    else
        call VimIM_Punctuation_Off()
    endif
endfunction

" ################################  VimIM__Smart_Space_Key

if !exists("g:vimim_smart_space_key")
    let g:vimim_smart_space_key=0
endif
" ----------------------------
if g:vimim_smart_space_key
    imap <silent> <expr> <C-\> VimIM_Insert_Toggle()
endif

if !exists("g:vimim_punctation_english")
    let g:vimim_punctation_english=0
endif
" ----------------------------
if !exists("g:vimim_punctuation_toggle")
    let g:vimim_punctuation_toggle=0
endif
" ----------------------------
if !exists("g:vimim_datafile_toggle")
    let g:vimim_datafile_toggle=0
endif
" ----------------------------
if !exists("g:vimim_pumheight")
    let vimim_pumheight=10
endif

let s:ab=0
let s:ba=0
let s:saved_pumheight=&pumheight
let s:saved_completeopt=&completeopt
let s:saved_lazyredraw=&lazyredraw

" -------------------------
function! VimIM_Insert_On()
" -------------------------
    let s:ba=1
    let s:saved_pumheight=&pumheight
    let s:saved_completeopt=&completeopt
    let s:saved_lazyredraw=&lazyredraw
    let &pumheight = g:vimim_pumheight
    set completeopt=menuone,longest
    set nolazyredraw
    imap <Space> <C-X><C-U><C-U><C-P><C-N><C-R>=VimIMSmartSpaceKey()<CR>
    highlight Cursor   guifg=bg guibg=Green
    highlight CursorIM guifg=bg guibg=Green
    if g:vimim_datafile_toggle
        imap <F11> <C-O>:call VimIM_Datafile_Toggle()<CR>
    endif
    if g:vimim_punctuation_toggle
        imap <S-F11> <C-O>:call VimIM_Punctuation_Toggle()<CR>
    endif
    if g:vimim_punctation_english == 0
        call VimIM_Punctuation_On()
    endif
endfunction

" --------------------------
function! VimIM_Insert_Off()
" --------------------------
    let s:ba=0
    let &pumheight=s:saved_pumheight
    let &completeopt=s:saved_completeopt
    let &lazyredraw=s:saved_lazyredraw
    imap <Space> <Space>
    highlight Cursor   guifg=bg guibg=fg
    highlight CursorIM guifg=bg guibg=fg
    if g:vimim_datafile_toggle
        imap  <F11> <F11>
    endif
    if g:vimim_punctuation_toggle
        imap <S-F11> <S-F11>
    endif
    if g:vimim_punctation_english == 0
        call VimIM_Punctuation_Off()
    endif
endfunction

" -----------------------
function! VimIM_iToggle()
" -----------------------
    if s:ba==1
        call VimIM_Insert_On()
    else
        call VimIM_Insert_Off()
    endif
    return ""
endfunction

" -----------------------------
function! VimIM_Insert_Toggle()
" -----------------------------
    if s:ba==0
        autocmd InsertEnter * let s:ba=s:ab|call VimIM_iToggle()
        autocmd InsertLeave * let s:ab=s:ba|call VimIM_Insert_Off()
        call VimIM_Insert_On()
    else
        autocmd! InsertEnter
        autocmd! InsertLeave
        call VimIM_Insert_Off()
    endif
    return ""
endfunction

" ----------------------------
function! VimIMSmartSpaceKey()
" ----------------------------
    if pumvisible()
        return "\<C-N>\<C-P>"
    else
        return " "
    endif
endfunction

" =================================================}}}

