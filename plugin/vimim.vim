" ==================================================
"              " VimIM —— Vim 中文输入法 "
" --------------------------------------------------
"  VimIM -- Input Method by Vim, of Vim, for Vimmers
" ==================================================
" $Revision: 687 $
" $Date: 2009-11-25 16:54:08 -0800 (Wed, 25 Nov 2009) $

" BUG:    http://code.google.com/p/vimim/issues/entry 
" GROUP:  http://groups.google.com/group/vimim
" MANUAL: http://vimim.googlecode.com/svn/vimim/vimim.html
" HTML:   http://vimim.googlecode.com/svn/vimim/vimim.vim.html
" URL:    http://vim.sourceforge.net/scripts/script.php?script_id=2506

" ====  VimIM Introduction    ==== {{{
" ====================================
"       File: vimim.vim
"     Author: vimim <vimim@googlegroups.com>
"    License: GNU Lesser General Public License
" -----------------------------------------------------------
"    Readme: VimIM is a Vim plugin designed as an independent IM
"            (Input Method) to support the input of multi-byte.
"            VimIM aims to complete the Vim as the greatest editor.
" -----------------------------------------------------------
"  Features: * "Plug & Play"
"            * "Plug & Play": "Cloud Input" through SouGou
"            * "Plug & Play": Pinyin and four_corner together
"            * "Plug & Play": Pinyin and five_stroke together
"            * Support five popular "Shuang Pin"
"            * Support "Pin Yin", "Wu Bi", "Cang Jie", "4Corner", etc
"            * Support "modeless" whole sentence input
"            * Support "Chinese search" using search key '/' or '?'.
"            * Support "fuzzy search" and "wildcard search"
"            * Support popup menu navigation using "vi key" (hjkl)
"            * Support direct "UNICODE input" using integer or hex
"            * Support direct "GBK input" and "Big5 input"
"            * Support "non-stop-typing" for Wubi
"            * Support "non-stop-typing" for 4Corner and Telegraph Code
"            * Support "Do It Yourself" input method defined by users
"            * The "OneKey" can input Chinese without mode change.
"            * The "static"  Chinese Input Mode smooths mixture input.
"            * The "dynamic" Chinese Input Mode uses sexy input style.
"            * It is independent of the Operating System.
"            * It is independent of Vim mbyte-XIM/mbyte-IME API.
" -----------------------------------------------------------
"   Install: (1) download a datafile of your choice from Data link above
"            (2) drop vimim.vim and the datafile to the plugin directory
" -----------------------------------------------------------
" EasterEgg: (in Vim Insert Mode, type 4 chars:) vim<C-\>
" -----------------------------------------------------------
" Usage (1): [in Insert Mode] "to insert/search Chinese ad hoc":
"            # to insert: type keycode and hit <C-\> to trigger
"            # to search: hit '/' or '?' from popup menu
" -----------------------------------------------------------
" Usage (2): [in Insert Mode] "to type Chinese continuously":
"            # hit <C-^> to toggle to Chinese Input Mode:
"            # just type any valid keycode and enjoy
" -----------------------------------------------------------

" ================================ }}}
" ====  VimIM Instruction     ==== {{{
" ====================================

" -------------
" "Design Goal"
" -------------
" # Chinese can be input using Vim regardless of encoding
" # Without negative impact to Vim when VimIM is not used
" # No compromise for high speed and low memory usage
" # Making the best use of Vim for popular input methods
" # Most VimIM options are activated based on input methods
" # All  VimIM options can be explicitly disabled at will

" ---------------
" "VimIM Options"
" ---------------
" Comprehensive usages of all options are from Demo URL above

"   VimIM "OneKey", without mode change
"    - use OneKey to insert multi-byte candidates
"    - use OneKey to search multi-byte using "/" or "?"
"    - use OneKey to insert Unicode/GBK/Big5, integer or hex
"    - use OneKey to input Chinese sentence as we do for English
"   The default key is <C-\> (Vim Insert Mode)

"   VimIM "Chinese Input Mode"
"   - [dynamic mode] show dynamic menu as one types
"   - [static mode] <Space> => Chinese  <Enter> => English
"   - <Esc> key is in consistence with Vim
"   The default key is <C-^> (Vim Insert Mode)

" ----------------
" "VimIM Datafile"
" ----------------
" The datafile is assumed to be in order, otherwise, it is auto sorted.
" The basic datafile format is simple and flexible:
"
"     +------+--+-------+
"     |<key> |  |<value>|
"     |======|==|=======|
"     | mali |  |  馬力 |
"     +------+--+-------+
"
" The <key> is what is typed in alphabet, ready to be replaced.
" The <value>, separated by spaces, is what will be inserted.
" The 2nd and the 3rd column can be repeated without restriction.

" ================================ }}}
" ====  VimIM Initialization  ==== {{{
" ====================================
if exists("b:loaded_vimim") || &cp || v:version<700
    finish
endif
let b:loaded_vimim=1
let s:path=expand("<sfile>:p:h")."/"
set completeopt=menuone
set completefunc=VimIM
scriptencoding utf-8
" --------------------------------

" --------------------------------
function! s:vimim_initialization()
" --------------------------------
    call s:vimim_initialize_global()
    call s:vimim_initialize_settings()
    call s:vimim_initialize_session()
    call s:vimim_initialize_debug()
    " -----------------------------------------
    call s:vimim_initialize_datafile_primary()
    call s:vimim_initialize_datafile_privates()
    call s:vimim_initialize_www_sogou()
    " -----------------------------------------
    call s:vimim_initialize_datafile_4corner()
    call s:vimim_initialize_datafile_pinyin()
    call s:vimim_initialize_diy_pinyin_digit()
    " -----------------------------------------
    call s:vimim_initialize_shuangpin()
    call s:vimim_initialize_datafile_erbi()
    call s:vimim_initialize_datafile_wubi()
    call s:vimim_initialize_valid_keys()
    " -----------------------------------------
    call s:vimim_initialize_color()
    call s:vimim_initialize_encoding()
    call s:vimim_initialize_punctuations()
    call s:vimim_initialize_quantifiers()
    call s:vimim_finalize_session()
    " -----------------------------------------
endfunction

" -----------------------------------
function! s:vimim_initialize_global()
" -----------------------------------
    let G = []
    call add(G, "g:vimim_auto_spell")
    call add(G, "g:vimim_ctrl_space_as_ctrl_6")
    call add(G, "g:vimim_datafile")
    call add(G, "g:vimim_privates_txt")
    call add(G, "g:vimim_english_in_datafile")
    call add(G, "g:vimim_shuangpin_abc")
    call add(G, "g:vimim_shuangpin_microsoft")
    call add(G, "g:vimim_shuangpin_nature")
    call add(G, "g:vimim_shuangpin_plusplus")
    call add(G, "g:vimim_shuangpin_purple")
    call add(G, "g:vimim_apostrophe_in_pinyin")
    call add(G, "g:vimim_dummy_shuangpin")
    call add(G, "g:vimim_fuzzy_search")
    call add(G, "g:vimim_latex_suite")
    call add(G, "g:vimim_match_word_after_word")
    call add(G, "g:vimim_custom_skin")
    call add(G, "g:vimim_number_as_navigation")
    call add(G, "g:vimim_reverse_pageup_pagedown")
    call add(G, "g:vimim_save_input_history_frequency")
    call add(G, "g:vimim_sexy_input_style")
    call add(G, "g:vimim_static_input_style")
    call add(G, "g:vimim_tab_for_one_key")
    call add(G, "g:vimim_unicode_lookup")
    call add(G, "g:vimim_wildcard_search")
    call add(G, "g:vimim_english_punctuation")
    call add(G, "g:vimim_www_sogou")
    call add(G, "g:vimim_smart_punctuations")
    " -----------------------------------
    call s:vimim_set_global_default(G, 0)
    " -----------------------------------
    let G = []
    call add(G, "g:vimim_auto_copy_clipboard")
    call add(G, "g:vimim_chinese_input_mode")
    call add(G, "g:vimim_chinese_punctuation")
    call add(G, "g:vimim_dynamic_mode_autocmd")
    call add(G, "g:vimim_first_candidate_fix")
    call add(G, "g:vimim_internal_code_input")
    call add(G, "g:vimim_match_dot_after_dot")
    call add(G, "g:vimim_menu_label")
    call add(G, "g:vimim_one_key")
    call add(G, "g:vimim_punctuation_navigation")
    call add(G, "g:vimim_custom_lcursor_color")
    call add(G, "g:vimim_quick_key")
    call add(G, "g:vimim_save_new_entry")
    call add(G, "g:vimim_wubi_non_stop")
    call add(G, "g:vimim_smart_backspace")
    call add(G, "g:vimim_smart_ctrl_h")
    call add(G, "g:vimim_seamless_english_input")
    " -----------------------------------
    call s:vimim_set_global_default(G, 1)
    " -----------------------------------
endfunction

" ----------------------------------------------------
function! s:vimim_set_global_default(options, default)
" ----------------------------------------------------
    for variable in a:options
        let s_variable = substitute(variable,"g:","s:",'')
        if !exists(variable)
            exe 'let '. s_variable . '=' . a:default
        else
            exe 'let '. s_variable .'='. variable
            exe 'unlet! ' . variable
        endif
    endfor
endfunction

" -------------------------------------
function! s:vimim_initialize_settings()
" -------------------------------------
    let s:saved_cpo=&cpo
    let s:saved_lazyredraw=&lazyredraw
    let s:saved_hlsearch=&hlsearch
    let s:saved_pumheight=&pumheight
endfunction

" ------------------------------------
function! s:vimim_initialize_session()
" ------------------------------------
    let s:wubi_flag = 0
    let s:erbi_flag = 0
    let s:privates_flag = 0
    let s:english_flag = 0
    let s:www_executable = 0
    let s:four_corner_flag = 0
    let s:diy_pinyin_4corner = 0
    " --------------------------------
    let s:pinyin_flag = 0
    let s:shuangpin_flag = 0
    let s:shuangpin_in_quanpin = 0
    let s:shuangpin_table = {}
    " --------------------------------
    let s:current_datafile = 0
    let s:current_datafile_has_dot = 0
    " --------------------------------
    let s:start_row_before = 0
    let s:start_column_before = 1
    let s:pattern_not_found = 0
    " --------------------------------
    let s:pageup_pagedown = 0
    let s:menu_reverse = 0
    " --------------------------------
    let s:ecdict = {}
    let s:unicode_prefix = 'u'
    let s:chinese_insert_flag = 0
    let s:chinese_input_mode = 0
    let s:chinese_punctuation = (s:vimim_chinese_punctuation+1)%2
    let s:search_key_slash = 0
    " --------------------------------
    let s:insert_without_popup_flag = 0
    let s:sentence_input = 0
    let s:onekey_loaded_flag = 0
    let s:trash_code_flag = 0
    " --------------------------------
    let s:smart_enter = 0
    let s:smart_backspace = 0
    " --------------------------------
    let s:no_internet_connection = 0
    let s:sentence_match = 0
    let s:keyboard_leading_zero = 0
    let s:keyboard_counts = 0
    let s:keyboards = ['', '']
    let s:keyboard_wubi = ''
    " --------------------------------
    let s:seamless_positions = []
    let s:current_positions = [0,0,1,0]
    let s:start_positions   = [0,0,1,0]
    let s:lines_datafile = []
    let s:alphabet_lines = []
    " --------------------------------
endfunction

" ----------------------------------
function! s:vimim_finalize_session()
" ----------------------------------
    if s:vimim_english_in_datafile > 0
        let s:english_flag = 1
    endif
    if s:vimim_www_sogou > 0
        let s:vimim_static_input_style = 1
    endif
    if s:four_corner_flag > 1
        let s:vimim_fuzzy_search = 0
        let s:vimim_static_input_style = 1
    endif
endfunction

" ----------------------------------
function! s:vimim_initialize_color()
" ----------------------------------
    if s:vimim_custom_skin > 0
        highlight! link PmenuSel  Title
        highlight! Pmenu          NONE
        highlight! PmenuSbar	  NONE
        highlight! PmenuThumb	  NONE
        if s:vimim_custom_skin > 2
            highlight! clear
            highlight! PmenuSbar  NONE
            highlight! PmenuThumb NONE
        endif
    endif
endfunction

" ---------------------------------------------
function! s:vimim_initialize_datafile_primary()
" ---------------------------------------------
    let datafile = s:current_datafile
    if empty(datafile)
        let msg = 'no user-specified datafile'
    else
        return
    endif
    " --------------------------------------
    let input_methods = []
    call add(input_methods, "pinyin")
    call add(input_methods, "pinyin_huge")
    call add(input_methods, "pinyin_fcitx")
    call add(input_methods, "pinyin_canton")
    call add(input_methods, "pinyin_hongkong")
    call add(input_methods, "wu")
    call add(input_methods, "phonetic")
    call add(input_methods, "yong")
    call add(input_methods, "nature")
    call add(input_methods, "cangjie")
    call add(input_methods, "zhengma")
    call add(input_methods, "xinhua")
    call add(input_methods, "quick")
    call add(input_methods, "array30")
    call add(input_methods, "wubi")
    call add(input_methods, "wubi98")
    call add(input_methods, "wubijd")
    call add(input_methods, "erbi")
    call add(input_methods, "english")
    call add(input_methods, "4corner")
    call add(input_methods, "ctc")
    call add(input_methods, "cns11643")
    call add(input_methods, "12345")
    call add(input_methods, "hangul")
    call map(input_methods, '"vimim." . v:val . ".txt"')
    call add(input_methods, "privates.txt")
    " --------------------------------------
    for file in input_methods
        let datafile = s:path . file
        if filereadable(datafile)
            break
        else
            continue
        endif
    endfor
    " --------------------------------------
    if filereadable(datafile)
        if datafile =~# 'erbi'
            let s:erbi_flag = 1
        elseif datafile =~# 'wubi'
            let s:wubi_flag = 1
        elseif datafile =~# 'pinyin'
            let s:pinyin_flag = 1
        elseif datafile =~# 'english'
            let s:english_flag = 1
        elseif datafile =~# '4corner'
            let s:four_corner_flag = 2
        elseif datafile =~# 'ctc'
            let s:four_corner_flag = 4
        elseif datafile =~# '12345'
            let s:four_corner_flag = 5
        elseif datafile =~# 'privates'
            let s:privates_flag = 2
        endif
        let s:current_datafile = datafile
    endif
endfunction

" ---------------------------------
function! <SID>vimim_set_seamless()
" ---------------------------------
    if s:vimim_seamless_english_input > 0
        let s:seamless_positions = getpos(".")
    endif
    let s:sentence_match = 0
    return ""
endfunction

" -----------------------------------------------
function! s:vimim_get_seamless(current_positions)
" -----------------------------------------------
    if empty(s:vimim_seamless_english_input)
    \|| empty(s:seamless_positions)
    \|| empty(a:current_positions)
        return -1
    endif
    let seamless_bufnum = s:seamless_positions[0]
    let seamless_lnum = s:seamless_positions[1]
    let seamless_off = s:seamless_positions[3]
    if seamless_bufnum != a:current_positions[0]
    \|| seamless_lnum != a:current_positions[1]
    \|| seamless_off != a:current_positions[3]
        return -1
    endif
    let seamless_column = s:seamless_positions[2]-1
    let start_column = a:current_positions[2]-1
    let len = start_column - seamless_column
    let start_row = a:current_positions[1]
    let current_line = getline(start_row)
    let snip = strpart(current_line, seamless_column, len)
    if empty(len(snip))
        return -1
    endif
    let snips = split(snip, '\zs')
    for char in snips
        if char !~# s:valid_key
            return -1
        endif
    endfor
    let s:start_column_before = seamless_column
    let s:start_row_before = seamless_lnum
    let s:smart_enter = 0
    return seamless_column
endfunction

let s:translators = {}
" ------------------------------------------
function! s:translators.translate(line) dict
" ------------------------------------------
    return join(map(split(a:line),'get(self.dict,tolower(v:val),v:val)'))
endfunction

" -------------------------------------------------------
function! s:vimim_expand_character_class(character_class)
" -------------------------------------------------------
    let character_string = ""
    let i = 0
    while i < 256
        let x = nr2char(i)
        if x =~# a:character_class
            let character_string .= x
        endif
        let i += 1
    endwhile
    return character_string
endfunction

" ---------------------------------------
function! s:vimim_initialize_valid_keys()
" ---------------------------------------
    let key = "[0-9a-z.]"
    let input_method = s:current_datafile
    " -----------------------------------
    if input_method =~ 'phonetic'
        let s:current_datafile_has_dot = 1
        let key = "[-0-9a-z.,;/]"
    elseif input_method =~ 'array'
        let s:current_datafile_has_dot = 1
        let key = "[a-z.,;/]"
    elseif input_method =~ 'cns11643'
        let key = "[0-9a-f]"
    elseif input_method =~ 'yong'
        let key = "[a-z;'/]"
    elseif input_method =~ 'wu'
        let key = "[a-z'.]"
    elseif input_method =~ 'nature'
        let key = "[a-z'.]"
    elseif input_method =~ 'zhengma'
        let key = "[a-z.]"
    elseif input_method =~ 'cangjie'
        let key = "[a-z.]"
    endif
    " -----------------------------------
    if s:four_corner_flag > 1 && empty(s:privates_flag)
        let key = "[0-9]"
    elseif s:erbi_flag > 0
        let s:current_datafile_has_dot = 1
        let key = "[a-z'.,;/]"
    elseif s:wubi_flag > 0
        let key = "[a-z.]"
    elseif s:pinyin_flag > 0
        let key = "[0-9a-z'.]"
    endif
    " -----------------------------
    call s:vimim_set_valid_key(key)
    " -----------------------------
endfunction

" ----------------------------------
function! s:vimim_set_valid_key(key)
" ----------------------------------
    let key = a:key
    if s:vimim_wildcard_search > 0 && empty(s:wubi_flag)
        let wildcard = '[*]'
        let key_valid = strpart(key, 1, len(key)-2)
        let key_wildcard = strpart(wildcard, 1, len(wildcard)-2)
        let key = '[' . key_valid . key_wildcard . ']'
    endif
    let s:valid_key = key
    let key = s:vimim_expand_character_class(key)
    let s:valid_keys = split(key, '\zs')
endfunction

" ================================ }}}
" ====  VimIM Easter Egg      ==== {{{
" ====================================

" ----------------------------
function! s:vimim_easter_egg()
" ----------------------------
    let easter_eggs = []
    let easter_eggs += ["vi    文本編輯器"]
    let easter_eggs += ["vim   最牛文本編輯器"]
    let easter_eggs += ["vim   精力"]
    let easter_eggs += ["vim   生氣"]
    let easter_eggs += ["vimim 中文輸入法"]
    return s:vimim_popupmenu_list(easter_eggs)
endfunction

" ================================ }}}
" ====  VimIM Unicode         ==== {{{
" ====================================

" -------------------------------------
function! s:vimim_initialize_encoding()
" -------------------------------------
    let s:localization = s:vimim_localization()
    let s:multibyte = 2
    let s:max_ddddd = 64928
    if &encoding == "utf-8"
        let s:multibyte = 3
        let s:max_ddddd = 40869
        if s:chinese_input_mode < 2 && s:four_corner_flag > 0
            let s:four_corner_unicode_flag = 1
        endif
    endif
    if s:localization > 0
        let s:vimim_save_input_history_frequency = 0
    endif
endfunction

" ------------------------------
function! s:vimim_localization()
" ------------------------------
    let localization = 0
    let datafile_fenc_chinese = 0
    if s:current_datafile =~# "chinese"
        let datafile_fenc_chinese = 1
    endif
    " ------------ ----------------- --------------
    " vim encoding datafile encoding s:localization
    " ------------ ----------------- --------------
    "   utf-8          utf-8                0
    "   utf-8          chinese              1
    "   chinese        utf-8                2
    "   chinese        chinese              8
    " ------------ ----------------- --------------
    if &encoding == "utf-8"
        if datafile_fenc_chinese > 0
            let localization = 1
        endif
    elseif empty(datafile_fenc_chinese)
        let localization = 2
    endif
    return localization
endfunction

" -------------------------------------
function! s:vimim_i18n_read_list(lines)
" -------------------------------------
    if empty(a:lines)
        return []
    endif
    let results = []
    if empty(s:localization)
        return a:lines
    else
        for line in a:lines
            let line = s:vimim_i18n_read(line)
            call add(results, line)
        endfor
    endif
    return results
endfunction

" -------------------------------
function! s:vimim_i18n_read(line)
" -------------------------------
    let line = a:line
    if s:localization == 1
        let line = iconv(line, "chinese", "utf-8")
    elseif s:localization == 2
        let line = iconv(line, "utf-8", &enc)
    endif
    return line
endfunction

" --------------------------------
function! s:vimim_i18n_write(line)
" --------------------------------
    let line = a:line
    if s:localization == 1
        let line = iconv(line, "utf-8", &enc)
    elseif s:localization == 2
        let line = iconv(line, &enc, "utf-8")
    endif
    return line
endfunction

" -------------------------------------
function! s:vimim_hex_unicode(keyboard)
" -------------------------------------
    if s:four_corner_unicode_flag < 1
    \|| match(a:keyboard, '^\d\{4}$') != 0
        return []
    endif
    let dddd = str2nr(a:keyboard, 16)
    if dddd > s:max_ddddd
        return []
    endif
    let unicode = nr2char(dddd)
    let menu = s:unicode_prefix . a:keyboard .'　'. dddd
    return [menu.' '.unicode]
endfunction

" ------------------
function! CJK16(...)
" ------------------
" This function outputs unicode block by block as:
" ----------------------------------------------------
"      0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
" 4E00 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
" ----------------------------------------------------
    if &encoding != "utf-8"
        $put='Your Vim encoding has to be set as utf-8.'
        $put='[usage]'
        $put='(in .vimrc):      :set encoding=utf-8'
        $put='(in Vim Command): :call CJK16()<CR>'
        $put='(in Vim Command): :call CJK16(0x8000,16)<CR>'
    else
        let a = 0x4E00| let n = 112-24| let block = 0x00F0
        if (a:0>=1)| let a = a:1| let n = 1| endif
        if (a:0==2)| let n = a:2| endif
        let z = a + n*block - 128
        while a <= z
            if empty(a%(16*16))
                $put='----------------------------------------------------'
                $put='     0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F '
                $put='----------------------------------------------------'
            endif
            let c = printf('%04X ',a)
            for j in range(16)|let c.=nr2char(a).' '|let a+=1|endfor
            $put=c
        endwhile
    endif
endfunction

" -------------
function! CJK()
" -------------
" This function outputs unicode as:
" ---------------------------------
"   decimal  hex    CJK
"   39340    99ac    馬
" ---------------------------------
    if &encoding != "utf-8"
        $put='Your Vim encoding has to be set as utf-8.'
        $put='[usage]    :call CJK()<CR>'
    else
        let unicode_start = 19968  "| 一
        let unicode_end   = 40869  "| 龥
        for i in range(unicode_start, unicode_end)
            $put=printf('%d %x ',i,i).nr2char(i)
        endfor
    endif
    return ''
endfunction

" ================================ }}}
" ====  VimIM GBK             ==== {{{
" ====================================

" -------------
function! GBK()
" -------------
" This function outputs GBK as:
" ----------------------------- gb=6763
"   decimal  hex    GBK
"   49901    c2ed    马
" ----------------------------- gbk=883+21003=21886
    if  &encoding == "chinese"
    \|| &encoding == "cp936"
    \|| &encoding == "gb2312"
    \|| &encoding == "gbk"
    \|| &encoding == "euc-cn"
        let start = str2nr('8140',16) "| 33088 丂
        for i in range(125)
            for j in range(start, start+190)
                if j <= 64928 && j != start+63
                    $put=printf('%d %x ',j,j).nr2char(j)
                endif
            endfor
            let start += 16*16
        endfor
    else
        $put='Your Vim encoding has to be set as chinese.'
        $put='[usage]    :call GBK()<CR>'
    endif
    return ''
endfunction

" ---------------------------------------
function! s:vimim_internal_code(keyboard)
" ---------------------------------------
    if s:chinese_input_mode > 1
    \|| strlen(a:keyboard) > 5
    \|| strlen(a:keyboard) < 4
        return []
    endif
    let &pumheight=0
    let s:unicode_menu_display_flag = 0
    let numbers = []
    let keyboard = a:keyboard
    let last_char = strpart(keyboard,len(keyboard)-1,1)
    " support unicode popup menu, if ending with 'u'
    " ----------------------------------------------
    if last_char == s:unicode_prefix
        let keyboard = strpart(keyboard,0,len(keyboard)-1)
        if keyboard =~ '^\d\{4}$'        "| 2222u
            let digit_ranges = range(10)
            for i in digit_ranges
                let keyboard = strpart(keyboard,0,4) . i
                let digit = str2nr(keyboard)
                call add(numbers, digit)
            endfor
        elseif keyboard =~ '^\x\{3}$'    "| 808u
            let hex_ranges = extend(range(10),['a','b','c','d','e','f'])
            for i in hex_ranges
                let keyboard = strpart(keyboard,0,3) . i
                let digit = str2nr(keyboard, 16)
                call add(numbers, digit)
            endfor
        endif
        let msg = "support direct unicode insert by 22221 or u808f"
    elseif s:four_corner_flag < 4
    " -----------------------------------------------------
        if keyboard =~ '^\d\{5}$'     "| 32911
            let numbers = [str2nr(keyboard)]
        elseif keyboard =~ '\x\{4}$'  "| 808f
            let four_hex   = match(keyboard, '^\x\{4}$')
            let four_digit = match(keyboard, '^\d\{4}$')
            if empty(four_hex) && four_digit < 0
                let keyboard = s:unicode_prefix . keyboard
            endif
            if strpart(keyboard,0,1) == s:unicode_prefix
                let keyboard = strpart(keyboard,1)
            else
                return []
            endif
            let ddddd = str2nr(keyboard, 16)
            if ddddd > s:max_ddddd
                return []
            else
                let numbers = [ddddd]
            endif
        else
            return []
        endif
    endif
    let internal_codes = []
    for digit in numbers
        let hex = printf('%04x', digit)
        let menu = '　' . hex .'　'. digit
        let internal_code = menu.' '.nr2char(digit)
        call add(internal_codes, internal_code)
    endfor
    return internal_codes
endfunction

" ================================ }}}
" ====  VimIM BIG5            ==== {{{
" ====================================

" --------------
function! BIG5()
" --------------
" This function outputs BIG5 as:
" -----------------------------
"   decimal  hex    BIG5
"   45224    b0a8    馬
" ----------------------------- big5=408+5401+7652=13461
    if  &encoding == "taiwan"
    \|| &encoding == "cp950"
    \|| &encoding == "big5"
    \|| &encoding == "euc-tw"
        let start = str2nr('A440',16) "| 42048  一
        for i in range(86)
            for j in range(start, start+(4*16)-2)
                $put=printf('%d %x ',j,j).nr2char(j)
            endfor
            let start2 = start + 6*16+1
            for j in range(start2, start2+93)
                $put=printf('%d %x ',j,j).nr2char(j)
            endfor
            let start += 16*16
        endfor
    else
        $put='Your Vim encoding has to be set as taiwan.'
        $put='[usage]    :call BIG5()<CR>'
    endif
    return ''
endfunction

" ================================ }}}
" ====  VimIM OneKey          ==== {{{
" ====================================

" -----------------------------------
function! s:vimim_insert_setting_on()
" -----------------------------------
    let &pumheight=9
    set nolazyredraw
    set hlsearch
endfunction

" ------------------------------------
function! s:vimim_insert_setting_off()
" ------------------------------------
    let &lazyredraw=s:saved_lazyredraw
    let &hlsearch=s:saved_hlsearch
    let &pumheight=s:saved_pumheight
endfunction

" ---------------------------
function! <SID>vimim_onekey()
" ---------------------------
    let s:sentence_match = 0
    let s:chinese_input_mode = 0
    let s:punctuations['&']='※'
    let s:punctuations['"']="“”"
    let s:punctuations['\']="、"
    call s:vimim_resume_shuangpin()
    call s:vimim_hjkl_navigation_on()
    if s:vimim_tab_for_one_key > 0
        call s:vimim_insert_setting_on()
    endif
    if empty(s:onekey_loaded_flag)
        let s:onekey_loaded_flag = 1
        call s:vimim_label_on()
        call s:vimim_punctuation_navigation_on()
    endif
    let onekey = ""
    if pumvisible()
        let onekey = s:vimim_keyboard_block_by_block()
    else
        inoremap<silent><Space> <C-R>=g:vimim_smart_space_onekey()<CR>
        let onekey = s:vimim_smart_punctuation(s:punctuations, "\t")
        if empty(onekey)
            let onekey = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . onekey . '"'
endfunction

" ------------------------------------
function! s:vimim_hjkl_navigation_on()
" ------------------------------------
    if s:chinese_input_mode > 0
        return
    endif
    " hjkl navigation for onekey, always
    let hjkl_list = split('hjklegGycxd', '\zs')
    for _ in hjkl_list
        sil!exe 'inoremap<silent><expr> '._.'
        \ <SID>vimim_hjkl("'._.'")'
    endfor
endfunction

" -----------------------------------
function! g:vimim_space_key_for_yes()
" -----------------------------------
    let space = ''
    if pumvisible()
        let space = s:vimim_keyboard_block_by_block()
        if empty(s:chinese_input_mode)
            sil!call s:vimim_insert_setting_off()
        endif
        sil!call g:vimim_reset_after_insert()
    else
        let space = ' '
    endif
    sil!exe 'sil!return "' . space . '"'
endfunction

" ------------------------------------
function! g:vimim_smart_space_onekey()
" ------------------------------------
    let space = ' '
    if pumvisible()
        let space = s:vimim_keyboard_block_by_block()
        sil!call s:vimim_insert_setting_off()
        sil!call g:vimim_reset_after_insert()
        sil!exe 'sil!return "' . space . '"'
    else
        iunmap <Space>
        let s:smart_backspace = 0
        if s:insert_without_popup_flag > 0
            let s:insert_without_popup_flag = 0
            let space = ""
        endif
    endif
    return space
endfunction

" ------------------------------------
function! g:vimim_smart_space_static()
" ------------------------------------
    let space = ' '
    if pumvisible()
        call g:vimim_reset_after_insert()
        let space = s:vimim_keyboard_block_by_block()
    else
        let s:smart_backspace = 0
        let space = s:vimim_smart_punctuation(s:punctuations, space)
        if empty(space)
            let space = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        endif
        if s:pattern_not_found > 0
            let s:pattern_not_found = 0
            let space = ' '
        endif
    endif
    sil!exe 'sil!return "' . space . '"'
endfunction

" -------------------------------------
function! g:vimim_smart_space_dynamic()
" -------------------------------------
    let space = ' '
    if pumvisible()
        let space = "\<C-Y>"
        sil!call g:vimim_reset_after_insert()
        sil!exe 'sil!return "' . space . '"'
    else
        let space = s:vimim_smart_punctuation(s:punctuations, space)
        if empty(space)
            let space = ' '
        endif
        if s:pattern_not_found > 0
            let s:pattern_not_found = 0
            let space = " "
        endif
    endif
    return space
endfunction

" --------------------------
function! s:vimim_label_on()
" --------------------------
    if s:vimim_menu_label < 1
        return
    endif
    for _ in range(0,9)
        sil!exe'inoremap<silent> '._.'
        \ <C-R>=<SID>vimim_label("'._.'")<CR>'.
        \'<C-R>=g:vimim_reset_after_insert()<CR>'
    endfor
endfunction

" ---------------------------
function! <SID>vimim_label(n)
" ---------------------------
    let n = a:n
    let label = a:n
    if pumvisible()
        if empty(n)
            call g:vimim_reset_after_insert()
            let label = '\<C-E>\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        else
            let counts = ""
            let yes = ""
            if empty(s:vimim_number_as_navigation)
                if empty(s:chinese_input_mode)
                    call s:vimim_insert_setting_off()
                endif
                if n > 1
                    let n -= 1
                    let counts = repeat("\<Down>", n)
                endif
            endif
            let yes = s:vimim_keyboard_block_by_block()
            let label = counts . yes
        endif
    else
        let s:smart_backspace = 0
        let s:seamless_positions = []
    endif
    sil!exe 'sil!return "' . label . '"'
endfunction

" --------------------------------
function! g:vimim_d_delete_trash()
" --------------------------------
    let d  = 'd'
    if pumvisible()
        call g:vimim_reset_after_insert()
        let s:trash_code_flag = 1
        let d = '\<C-E>'
    endif
    sil!exe 'sil!return "' . d . '"'
endfunction

" ---------------------------------
function! g:vimim_copy_popup_word()
" ---------------------------------
    let word = s:vimim_popup_word(s:start_column_before)
    return s:vimim_clipboard_register(word)
endfunction

" ----------------------------------------
function! s:vimim_clipboard_register(word)
" ----------------------------------------
    if len(a:word) > 0
        if s:vimim_auto_copy_clipboard>0 && has("gui_running")
            let @+ = a:word
        else
            let @0 = a:word
        endif
    endif
    return "\<Esc>"
endfunction

" ----------------------------------------
function! s:vimim_popup_word(column_start)
" ----------------------------------------
    let column_end = col('.') - 1
    let range = column_end - a:column_start
    let current_line = getline(".")
    let word = strpart(current_line, a:column_start, range)
    return word
endfunction

" ================================ }}}
" ====  VimIM Chinese Mode    ==== {{{
" ====================================

" ---------------------------
function! <SID>vimim_toggle()
" ---------------------------
    set nopaste
    if s:chinese_insert_flag < 1
        sil!call s:vimim_chinese_mode_on()
    else
        sil!call s:vimim_chinese_mode_off()
    endif
    if s:vimim_dynamic_mode_autocmd > 0 && has("autocmd")
        if !exists("s:dynamic_mode_autocmd_loaded")
            let s:dynamic_mode_autocmd_loaded = 1
            sil!au InsertEnter sil!call s:vimim_chinese_mode_on()
            sil!au InsertLeave sil!call s:vimim_chinese_mode_off()
            sil!au BufUnload   autocmd! InsertEnter,InsertLeave
        endif
    endif
    sil!return "\<C-O>:redraw\<CR>"
endfunction

" --------------------------------------
function! s:vimim_alphabet_auto_select()
" --------------------------------------
    if s:chinese_input_mode != 1
        return
    endif
    " always do alphabet auto selection for static mode
    let A = char2nr('A')
    let Z = char2nr('Z')
    let a = char2nr('a')
    let z = char2nr('z')
    let az_nr_list = extend(range(A,Z), range(a,z))
    let az_char_list = map(az_nr_list,"nr2char(".'v:val'.")")
    for char in az_char_list
        sil!exe 'inoremap <silent> ' . char . '
        \ <C-R>=pumvisible()?"\<lt>C-Y>":""<CR>'. char
     endfor
endfunction

" ----------------------------
function! <SID>vimim_hjkl(key)
" ----------------------------
    let hjkl = a:key
    if pumvisible()
        if a:key == 'e'
            let hjkl  = '\<C-E>'
        elseif a:key == 'y'
            let hjkl  = '\<C-R>=g:vimim_space_key_for_yes()\<CR>'
        elseif a:key == 'h'
            let hjkl  = '\<PageUp>'
        elseif a:key == 'j'
            let hjkl  = '\<Down>'
        elseif a:key == 'k'
            let hjkl  = '\<Up>'
        elseif a:key == 'l'
            let hjkl  = '\<PageDown>'
        elseif a:key == 'c'
            let hjkl  = '\<C-R>=g:vimim_space_key_for_yes()\<CR>'
            let hjkl .= '\<C-R>=g:vimim_copy_popup_word()\<CR>'
        elseif a:key == 'd'
            let hjkl  = '\<C-R>=g:vimim_d_delete_trash()\<CR>'
            let hjkl .= '\<C-X>\<C-U>\<BS>'
        elseif a:key ==? 'g'
            let s:menu_reverse = 0
            if a:key ==# 'G'
                let s:menu_reverse = 1
            endif
            let s:pageup_pagedown = 0
            let hjkl = '\<C-E>\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . hjkl . '"'
endfunction

" ---------------------------------
function! s:vimim_chinese_mode_on()
" ---------------------------------
    set cpo&vim
    let &l:iminsert=1
    let s:chinese_insert_flag = 1
    if empty(s:vimim_static_input_style)
    " ------------------------------ chinese mode dynamic
        let s:chinese_input_mode = 2
        " --------------------------
        inoremap<silent><Space> <C-R>=g:vimim_smart_space_dynamic()<CR>
        let valid_keys = copy(s:valid_keys)
        call remove(valid_keys, match(valid_keys,'[.]'))
        for char in valid_keys
            sil!exe 'inoremap<silent> ' . char . '
            \ <C-R>=<SID>vimim_dynamic_End()<CR>'. char .
            \'<C-R>=g:vimim_ctrl_x_ctrl_u()<CR>'
        endfor
    else
        " -------------------------- chinese mode static
        let s:chinese_input_mode = 1
        " --------------------------
        sil!call s:vimim_resume_shuangpin()
        sil!call s:vimim_alphabet_auto_select()
        inoremap<silent><Space> <C-R>=g:vimim_smart_space_static()<CR>
    endif
    sil!call s:vimim_one_key_mapping_off()
    sil!call s:vimim_insert_for_both_static_dynamic()
endfunction

" ------------------------------------------------
function! s:vimim_insert_for_both_static_dynamic()
" ------------------------------------------------
    let s:smart_enter = 0
    let s:smart_backspace = 0
    if s:vimim_custom_lcursor_color > 0
        highlight! lCursor guifg=bg guibg=green
    endif
    sil!call s:vimim_label_on()
    sil!call s:vimim_insert_setting_on()
    sil!call g:vimim_reset_after_insert()
    sil!call <SID>vimim_set_seamless()
    inoremap<silent><CR> <C-R>=<SID>vimim_smart_enter()<CR>
        \<C-R>=<SID>vimim_set_seamless()<CR>
    inoremap<silent><expr><C-\> <SID>vimim_toggle_punctuation()
    return  <SID>vimim_toggle_punctuation()
endfunction

" ----------------------------------
function! s:vimim_chinese_mode_off()
" ----------------------------------
    let &cpo=s:saved_cpo
    let &l:iminsert=0
    let s:onekey_loaded_flag = 0
    let s:chinese_input_mode = 0
    let s:chinese_insert_flag = 0
    if s:vimim_custom_lcursor_color > 0
        highlight lCursor NONE
    endif
    if s:vimim_auto_copy_clipboard>0 && has("gui_running")
        sil!exe ':%y +'
    endif
    sil!call s:vimim_iunmap()
    sil!call s:vimim_insert_setting_off()
    sil!call s:vimim_one_key_mapping_on()
    if exists('*Fixcp')
        sil!call FixAcp()
    endif
endfunction

" --------------------------------
function! <SID>vimim_dynamic_End()
" --------------------------------
    let end = ""
    if pumvisible()
        let end = "\<C-E>"
        if s:wubi_flag > 0
        \&& s:vimim_wubi_non_stop > 0
        \&& empty(len(s:keyboard_wubi)%4)
            let end = "\<C-Y>"
        endif
    endif
    sil!exe 'sil!return "' . end . '"'
endfunction

" ------------------------
function! s:vimim_iunmap()
" ------------------------
    let unmap_list = range(0,9)
    call extend(unmap_list, s:valid_keys)
    call extend(unmap_list, keys(s:punctuations))
    call extend(unmap_list, ['<CR>', '<BS>', '<Space>'])
    for _ in unmap_list
        sil!exe 'iunmap '. _
    endfor
    " --------------------------------------------------
    let unmap_list = ['<C-W>', '<C-U>', '<C-H>'])
    for _ in unmap_list
        if !hasmapto('_', 'i')
            sil!exe 'iunmap '. _
        endif
    endfor
endfunction

" ================================ }}}
" ====  VimIM Punctuations    ==== {{{
" ====================================

" -----------------------------------------
function! s:vimim_initialize_punctuations()
" -----------------------------------------
    let s:punctuations = {}
    let s:punctuations['&']='、'
    let s:punctuations['#']='＃'
    let s:punctuations['%']='％'
    let s:punctuations['$']='￥'
    let s:punctuations['!']='！'
    let s:punctuations['~']='～'
    let s:punctuations['+']='＋'
    let s:punctuations['*']='﹡'
    let s:punctuations['@']='・'
    let s:punctuations[':']='：'
    let s:punctuations['(']='（'
    let s:punctuations[')']='）'
    let s:punctuations['{']='〖'
    let s:punctuations['}']='〗'
    let s:punctuations['[']='【'
    let s:punctuations[']']='】'
    let s:punctuations['^']='……'
    let s:punctuations['_']='——'
    let s:punctuations['<']='《'
    let s:punctuations['>']='》'
    let s:punctuations['-']='－'
    let s:punctuations['=']='＝'
    let s:punctuations[';']='；'
    let s:punctuations[',']='，'
    let s:punctuations['.']='。'
    let s:punctuations['?']='？'
    if empty(s:vimim_latex_suite)
        let s:punctuations["'"]="“”"
        let s:punctuations['`']='“”'
    endif
    let s:punctuations_all = copy(s:punctuations)
    for char in s:valid_keys
        if has_key(s:punctuations, char) && char != '.'
            unlet s:punctuations[char]
        endif
    endfor
endfunction

" ---------------------------------------
function! <SID>vimim_toggle_punctuation()
" ---------------------------------------
    let s:chinese_punctuation = (s:chinese_punctuation+1)%2
    sil!call s:vimim_punctuation_on()
    sil!call s:vimim_punctuation_navigation_on()
    return ""
endfunction

" --------------------------------
function! s:vimim_punctuation_on()
" --------------------------------
    let punctuations  = s:punctuations
    if s:chinese_input_mode > 0
        let s:punctuations['&']='、'
        unlet punctuations['"']
        unlet punctuations['\']
    endif
    if s:erbi_flag > 0
	unlet punctuations[',']
	unlet punctuations['.']
	unlet punctuations['/']
	unlet punctuations[';']
	unlet punctuations["'"]
    endif
    for _ in keys(punctuations)
        sil!exe 'inoremap<silent><expr> '._.'
        \ <SID>vimim_punctuation_mapping("'._.'")'
    endfor
endfunction

" -------------------------------------------
function! <SID>vimim_punctuation_mapping(key)
" -------------------------------------------
    call g:vimim_reset_after_insert()
    let value = s:vimim_get_chinese_punctuation(a:key)
    if pumvisible()
        let value = "\<C-Y>" . value
    endif
    sil!exe 'sil!return "' . value . '"'
endfunction

" -------------------------------------------
function! s:vimim_punctuation_navigation_on()
" -------------------------------------------
    if empty(s:vimim_punctuation_navigation)
        return
    endif
    let hjkl_list = split(',.=-;[]','\zs')
    if s:search_key_slash < 0
        let msg = "search keys are reserved"
    else
        call add(hjkl_list, '/')
        call add(hjkl_list, '?')
    endif
    for _ in hjkl_list
        sil!exe 'inoremap<silent><expr> '._.'
        \ <SID>vimim_punctuations_navigation("'._.'")'
    endfor
endfunction

" -----------------------------------------------
function! <SID>vimim_punctuations_navigation(key)
" -----------------------------------------------
    let hjkl = a:key
    if pumvisible()
        if a:key == ";"
            let hjkl  = '\<C-E>\<C-X>\<C-U>\<Down>'
            let hjkl .= '\<C-R>=g:vimim_space_key_for_yes()\<CR>'
        elseif a:key == "["
            let hjkl  = '\<C-R>=g:vimim_left_bracket()\<CR>'
        elseif a:key == "]"
            let hjkl  = '\<C-R>=g:vimim_right_bracket()\<CR>'
        elseif a:key == "/"
            let hjkl  = '\<C-R>=g:vimim_search_forward()\<CR>'
        elseif a:key == "?"
            let hjkl  = '\<C-R>=g:vimim_search_backward()\<CR>'
        elseif a:key =~ "[-,=.]"
            if a:key == ',' || a:key == '-'
                if s:vimim_reverse_pageup_pagedown > 0
                    let s:pageup_pagedown += 1
                else
                    let s:pageup_pagedown -= 1
                endif
            elseif a:key == '.' || a:key == '='
                if s:vimim_reverse_pageup_pagedown > 0
                    let s:pageup_pagedown -= 1
                else
                    let s:pageup_pagedown += 1
                endif
            endif
            let hjkl = '\<C-E>\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        endif
    else
        if s:chinese_input_mode > 0
            let hjkl = s:vimim_get_chinese_punctuation(hjkl)
        endif
    endif
    sil!exe 'sil!return "' . hjkl . '"'
endfunction

" ------------------------------------------------------------
function! s:vimim_get_chinese_punctuation(english_punctuation)
" ------------------------------------------------------------
    let value = a:english_punctuation
    if s:chinese_punctuation > 0
    \&& has_key(s:punctuations, value)
        let current_positions = getpos(".")
        let start_column = current_positions[2]-1
        let current_line = getline(current_positions[1])
        let char_before = current_line[start_column-1]
        let filter = '\w'     |" english_punctuation_after_english
        if empty(s:vimim_english_punctuation)
            let filter = '\d' |" english_punctuation_after_digit
        endif
        if char_before !~ filter
            let value = s:punctuations[value]
        endif
    endif
    return value
endfunction

" ----------------------------------------------------
function! s:vimim_smart_punctuation(punctuations, key)
" ----------------------------------------------------
    let key = ""
    let current_positions = getpos(".")
    let start_column = current_positions[2]-1
    let current_line = getline(current_positions[1])
    let char_before = current_line[start_column-1]
    let char_before_before = current_line[start_column-2]
    " -----------------------------------------------
    if empty(s:vimim_smart_punctuations)
    \&& s:chinese_input_mode > 0
        let msg = 'punctuation is better to be dummy'
        " make dummy punctuations dummy
        let space = ' '
        " when a valid key before, trigger the menu
        if char_before =~# s:valid_key
        \&& char_before != '.'
            let space = ''
        endif
        return space
    endif
    " -----------------------------------------------
    if char_before == '.' && char_before_before == '.'
        return key
    endif
    if (char_before_before =~ '\W' || char_before_before == '')
    \&& has_key(a:punctuations, char_before)
        let replacement = a:punctuations[char_before]
        let key = "\<BS>" . replacement
    elseif char_before !~# s:valid_key
        let key = a:key
    endif
    return key
endfunction

" ================================ }}}
" ====  VimIM Chinese number  ==== {{{
" ====================================

" ----------------------------------------
function! s:vimim_initialize_quantifiers()
" ----------------------------------------
    let s:quantifiers = {}
    if empty(s:pinyin_flag)
        return
    endif
    if s:pinyin_flag == 2 && empty(s:vimim_shuangpin_abc)
        return
    endif
    let s:quantifiers['1'] = '一壹㈠①⒈⑴甲'
    let s:quantifiers['2'] = '二贰㈡②⒉⑵乙'
    let s:quantifiers['3'] = '三叁㈢③⒊⑶丙'
    let s:quantifiers['4'] = '四肆㈣④⒋⑷丁'
    let s:quantifiers['5'] = '五伍㈤⑤⒌⑸戊'
    let s:quantifiers['6'] = '六陆㈥⑥⒍⑹己'
    let s:quantifiers['7'] = '七柒㈦⑦⒎⑺庚'
    let s:quantifiers['8'] = '八捌㈧⑧⒏⑻辛'
    let s:quantifiers['9'] = '九玖㈨⑨⒐⑼壬'
    let s:quantifiers['0'] = '〇零㈩⑩⒑⑽癸十拾'
    let s:quantifiers['a'] = '秒'
    let s:quantifiers['b'] = '百佰把班包杯本笔部'
    let s:quantifiers['c'] = '厘次餐场串处'
    let s:quantifiers['d'] = '第度点袋道滴碟顶栋堆对朵堵顿'
    let s:quantifiers['e'] = '亿'
    let s:quantifiers['f'] = '分份发封付副幅峰方服'
    let s:quantifiers['g'] = '个根股管'
    let s:quantifiers['h'] = '时毫行盒壶户回'
    let s:quantifiers['i'] = '毫'
    let s:quantifiers['j'] = '斤家具架间件节剂具捲卷茎记'
    let s:quantifiers['k'] = '克口块棵颗捆孔'
    let s:quantifiers['l'] = '里粒类辆列轮厘升领缕'
    let s:quantifiers['m'] = '米名枚面门'
    let s:quantifiers['n'] = '年'
    let s:quantifiers['o'] = '度'
    let s:quantifiers['p'] = '磅盆瓶排盘盆匹片篇撇喷'
    let s:quantifiers['q'] = '千仟群'
    let s:quantifiers['r'] = '日'
    let s:quantifiers['s'] = '十拾时升艘扇首双所束手'
    let s:quantifiers['t'] = '吨条头通堂台套桶筒贴趟'
    let s:quantifiers['u'] = '微'
    let s:quantifiers['w'] = '万位味碗窝'
    let s:quantifiers['x'] = '升席些项'
    let s:quantifiers['y'] = '月亿叶'
    let s:quantifiers['z'] = '兆只张株支枝指盏座阵桩尊则种站幢宗'
endfunction

" -----------------------------------
function! s:vimim_date_time(keyboard)
" -----------------------------------
    if empty(s:vimim_debug_flag)
        return []
    endif
    let time = 0
    if a:keyboard ==? 'itoday'
        " 2009 year February 22 day Wednesday
        let time = strftime("%Y year %B %d day %A")
    elseif a:keyboard ==? 'inow'
        " Sunday AM 8 hour 8 minute 8 second
        let time=strftime("%A %p %I hour %M minute %S second")
    endif
    if empty(time)
        return []
    endif
    let time = s:vimim_translator(time)
    let keyboards = split(time, '\ze')
    let i = strpart(a:keyboard,0,1)
    let time = s:vimim_get_chinese_number(keyboards, i)
    if len(time) > 0
        let s:insert_without_popup_flag = 1
    endif
    return [time]
endfunction

" ----------------------------------------
function! s:vimim_chinese_number(keyboard)
" ----------------------------------------
    if s:chinese_input_mode > 1
        return []
    endif
    if empty(s:pinyin_flag)
        return []
    elseif s:pinyin_flag==2 && empty(s:vimim_shuangpin_abc)
        return []
    endif
    let keyboard = a:keyboard
    let ii = strpart(keyboard,0,2)
    if ii ==# 'ii'
        let keyboard = 'I' . strpart(keyboard,2)
    endif
    let ii_keyboard = keyboard
    let keyboard = strpart(keyboard,1)
    if keyboard !~ '^\d\+' && keyboard !~# '^[ds]'
    \&& len(substitute(keyboard,'\d','','')) > 1
        return []
    endif
    " ------------------------------------
    let digit_alpha = keyboard
    if keyboard =~# '^\d*\l\{1}$'
        let digit_alpha = strpart(keyboard,0,len(keyboard)-1)
    endif
    let keyboards = split(digit_alpha, '\ze')
    let i = strpart(ii_keyboard,0,1)
    let number = s:vimim_get_chinese_number(keyboards, i)
    if empty(number)
        return []
    endif
    let numbers = [number]
    let last_char = strpart(keyboard, len(keyboard)-1, 1)
    if !empty(last_char) && has_key(s:quantifiers, last_char)
        let quantifier = s:quantifiers[last_char]
        let quantifiers = split(quantifier, '\zs')
        if keyboard =~# '^[ds]\=\d*\l\{1}$'
            if keyboard =~# '^[ds]'
                let number = strpart(number,0,len(number)-s:multibyte)
            endif
            let numbers = map(copy(quantifiers), 'number . v:val')
        elseif keyboard =~# '^\d*$' && len(keyboards)<2 && i ==# 'i'
            let numbers = quantifiers
        endif
    endif
    if len(numbers) == 1
        let s:insert_without_popup_flag = 1
    endif
    return numbers
endfunction

" ------------------------------------------------
function! s:vimim_get_chinese_number(keyboards, i)
" ------------------------------------------------
    if empty(a:keyboards) && a:i !~? 'i'
        return 0
    endif
    let chinese_number = ''
    for char in a:keyboards
        if has_key(s:quantifiers, char)
            let quantifier = s:quantifiers[char]
            let quantifiers = split(quantifier,'\zs')
            if a:i ==# 'i'
                let chinese_number .= get(quantifiers,0)
            elseif a:i ==# 'I'
                let chinese_number .= get(quantifiers,1)
            endif
        else
            let chinese_number .= char
        endif
    endfor
    return chinese_number
endfunction

" ================================ }}}
" ====  VimIM English2Chinese ==== {{{
" ====================================

" -----------------------------------
function! s:vimim_translator(english)
" -----------------------------------
    if a:english !~ '\p'
        return ''
    endif
    if empty(s:ecdict)
        call s:vimim_initialize_e2c()
    endif
    let english = substitute(a:english, '\A', ' & ', 'g')
    let chinese = substitute(english, '.', '&\n', 'g')
    let chinese = s:ecdict.translate(english)
    let chinese = substitute(chinese, "[ ']", '', 'g')
    let chinese = substitute(chinese, '\a\+', ' & ', 'g')
    return chinese
endfunction

" --------------------------------
function! s:vimim_initialize_e2c()
" --------------------------------
    if empty(s:english_flag) || len(s:ecdict) > 1
        return ''
    endif
    let lines = s:vimim_load_datafile(0)
    if empty(lines)
        return ''
    endif
    " --------------------------------------------------
    " VimIM rule for entry of English Chinese dictionary
    " obama 奥巴马 欧巴马 #
    " --------------------------------------------------
    let english_pattern = "#$"
    let matched_english_lines = match(lines, english_pattern)
    if matched_english_lines < 0
        return ''
    endif
    let dictionary_lines = filter(copy(lines),'v:val=~english_pattern')
    if empty(dictionary_lines)
        return ''
    endif
    let s:ecdict = copy(s:translators)
    let s:ecdict.dict = {}
    for line in dictionary_lines
        if empty(line)
            continue
        endif
        let line = s:vimim_i18n_read(line)
        let words = split(line)
        if len(words) < 2
            continue
        endif
        let s:ecdict.dict[words[0]] = words[1]
    endfor
endfunction

" ================================ }}}
" ====  VimIM Smart Keys      ==== {{{
" ====================================

" --------------------------------
function! g:vimim_search_forward()
" --------------------------------
    return s:vimim_search("/")
endfunction

" ---------------------------------
function! g:vimim_search_backward()
" ---------------------------------
    return s:vimim_search("?")
endfunction

" ---------------------------
function! s:vimim_search(key)
" ---------------------------
    let slash = ""
    if pumvisible()
        let slash  = '\<C-R>=g:vimim_space_key_for_yes()\<CR>'
        let slash .= '\<C-R>=g:vimim_slash_search()\<CR>'
        let slash .= a:key . '\<CR>'
    endif
    sil!exe 'sil!return "' . slash . '"'
endfunction

" -----------------------------------------
function! s:vimim_first_char_current_line()
" -----------------------------------------
    let char = ''
    let current_line = getline(".")
    let line_no_leading_space = substitute(current_line,'^\s\+','','')
    let first_non_blank_character = line_no_leading_space[0]
    let second_character = line_no_leading_space[1]
    if first_non_blank_character =~ '[/?]'
    \&& char2nr(second_character) > 127
        let char = first_non_blank_character
    endif
    return char
endfunction

" ---------------------------------------
function! s:vimim_slash_register(chinese)
" ---------------------------------------
    if empty(a:chinese)
        let @/ = @_
    else
        let @/ = a:chinese
    endif
    return "\<Esc>"
endfunction

" ---------------------------------------
function! s:vimim_remove_popup_word(word)
" ---------------------------------------
    if empty(a:word) || char2nr(a:word) < 127
        return ""
    endif
    let repeat_times = len(a:word)/s:multibyte
    let row_start = s:start_row_before
    let row_end = line('.')
    let delete_chars = ""
    if repeat_times > 0 && row_end == row_start
        let delete_chars = repeat("\<BS>", repeat_times)
    endif
    let slash = delete_chars . "\<Esc>"
    sil!exe 'sil!return "' . slash . '"'
endfunction

" ------------------------------
function! g:vimim_slash_search()
" ------------------------------
    let slash = s:vimim_first_char_current_line()
    if empty(slash)
        "-- case 1: search from popup menu, all modes
        let word = s:vimim_popup_word(s:start_column_before)
        call s:vimim_slash_register(word)
        return s:vimim_remove_popup_word(word)
    else
        "-- case 2: search by Enter with leading / or ?
        let current_line = getline(".")
        let column_start = match(current_line,'[/?]') + 1
        let word = s:vimim_popup_word(column_start)
        call s:vimim_slash_register(word)
        let slash = "\<End>\<C-U>\<Esc>"
    endif
    sil!exe 'sil!return "' . slash . '"'
endfunction

" ------------------------------
function! g:vimim_left_bracket()
" ------------------------------
    return s:vimim_square_bracket("[")
endfunction

" -------------------------------
function! g:vimim_right_bracket()
" -------------------------------
    return s:vimim_square_bracket("]")
endfunction

" -----------------------------------
function! s:vimim_square_bracket(key)
" -----------------------------------
    let bracket = a:key
    if pumvisible()
        let i = -1
        let left = ""
        let right = ""
        if bracket == "]"
            let i = 0
            let left = "\<Left>"
            let right = "\<Right>"
        endif
        let backspace = '\<C-R>=g:vimim_bracket_backspace('.i.')\<CR>'
        let yes = '\<C-R>=g:vimim_space_key_for_yes()\<CR>'
        let bracket = yes . left . backspace . right
    endif
    sil!exe 'sil!return "' . bracket . '"'
endfunction

" -----------------------------------------
function! g:vimim_bracket_backspace(offset)
" -----------------------------------------
    let column_end = col('.')-1
    let column_start = s:start_column_before
    let range = column_end - column_start
    let repeat_times = range/s:multibyte
    let repeat_times += a:offset
    let row_end = line('.')
    let row_start = s:start_row_before
    let delete_char = ""
    if repeat_times > 0 && row_end == row_start
        let delete_char = repeat("\<BS>", repeat_times)
    endif
    if repeat_times < 1
        let current_line = getline(".")
        let chinese = strpart(current_line, column_start, s:multibyte)
        let delete_char = chinese
        if empty(a:offset)
            let delete_char = "\<Right>\<BS>【".chinese."】\<Left>"
        endif
    endif
    return delete_char
endfunction

" --------------------------------
function! <SID>vimim_smart_enter()
" --------------------------------
    let key = ''
    if pumvisible()
        let s:smart_enter = 0
        let key = "\<C-E>"
    else
        let char_before = getline(".")[col(".")-2]
        if char_before =~# s:valid_key
            let s:smart_enter += 1
        endif
        if s:smart_enter == 1
            let msg = "first time to press <Enter>"
        else
            let s:smart_enter = 0
            let key = "\<CR>"
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ---------------------------------
function! <SID>vimim_smart_ctrl_h()
" ---------------------------------
    " support intelligent sentence match for wozuixihuandeliulanqi
    " first try maximum-match, after <C-H>, try minimum match
    let key = '\<BS>'
    if pumvisible() && empty(s:chinese_input_mode)
        let s:smart_backspace += 1
        if s:smart_backspace == 1
            let key = '\<C-E>\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        elseif s:smart_backspace == 2
            let s:smart_backspace = 0
            let key = "\<C-E>"
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ----------------------------------------
function! <SID>vimim_backspace_trash_all()
" ----------------------------------------
    let key = ''
    let s:trash_code_flag = 0
    if pumvisible()
        let key = '\<C-E>'
        let s:trash_code_flag = 1
        call g:vimim_reset_after_insert()
    else
        let char_before = getline(".")[col(".")-2]
        if char_before =~# s:valid_key
            let s:trash_code_flag = -1
            let key = '\<BS>'
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" -------------------------------------
function! <SID>vimim_ctrl_x_ctrl_u_bs()
" -------------------------------------
    let key = ''
    if pumvisible()
        let msg = "support one-key-correction"
    else
        if s:trash_code_flag < 0
            let s:trash_code_flag = 0
        else
            let key = '\<C-X>\<C-U>\<BS>'
        endif
    endif
    let s:sentence_match = 0
    sil!exe 'sil!return "' . key . '"'
endfunction

" ================================ }}}
" ====  VimIM Popup Menu      ==== {{{
" ====================================

" ---------------------------------------
function! s:vimim_pair_list(matched_list)
" ---------------------------------------
    let matched_list = a:matched_list
    if len(s:private_matches) > 0
        call extend(matched_list, s:private_matches, 0)
        let s:private_matches = []
    endif
    if empty(matched_list)
        return []
    endif
    let pair_matched_list = []
    " ----------------------
    for line in matched_list
    " ----------------------
        if len(line) < 2
            continue
        endif
        if s:english_flag > 0
            let line = substitute(line,'#',' ','g')
        endif
        if s:localization > 0
            let line = s:vimim_i18n_read(line)
        endif
        let oneline_list = split(line, '\s\+')
        let menu = remove(oneline_list, 0)
        for chinese in oneline_list
            call add(pair_matched_list, menu .' '. chinese)
        endfor
    endfor
    return pair_matched_list
endfunction

" ------------------------------------
function! g:vimim_reset_after_insert()
" ------------------------------------
    let s:seamless_positions = []
    let s:pageup_pagedown = 0
    let s:menu_reverse = 0
    let s:smart_enter = 0
    let s:keyboard_wubi = ''
    return ""
endfunction

" ---------------------------------------------
function! s:vimim_pageup_pagedown(matched_list)
" ---------------------------------------------
    let matched_list = a:matched_list
    let page = &pumheight-1
    if page < 1
        let page = 8
    endif
    if empty(s:pageup_pagedown) || len(matched_list) < page+2
        let s:pageup_pagedown = 0
        return matched_list
    endif
    let shift = s:pageup_pagedown * page
    let length = len(matched_list)
    if length > page
        if shift >= length || shift*(-1) >= length
            let s:pageup_pagedown = 0
            return matched_list
        endif
        let partition = shift
        if shift < 0
            let partition = length + shift
        endif
        let A = matched_list[: partition-1]
        let B = matched_list[partition :]
        let matched_list = B + A
    endif
    return matched_list
endfunction

" --------------------------------------------
function! s:vimim_popupmenu_list(matched_list)
" --------------------------------------------
    let matched_list = a:matched_list
    if empty(matched_list)
        return []
    endif
    if s:menu_reverse > 0
        let matched_list = reverse(matched_list)
    endif
    let matched_list = s:vimim_pageup_pagedown(matched_list)
    let label = 0
    if empty(s:vimim_number_as_navigation)
        let label = 1
    endif
    let popupmenu_list = []
    let menu = 0
    let keyboard = s:keyboard_leading_zero
    " ----------------------
    for pair in matched_list
    " ----------------------
        let complete_items = {}
        let pairs = split(pair)
        if len(pairs) < 2
            continue
        endif
        let menu = get(pairs, 0)
        if s:unicode_menu_display_flag > 0
            let complete_items["menu"] = menu
        endif
        let chinese = get(pairs, 1)
        if s:vimim_custom_skin < 2
            let extra_text = menu
            if s:four_corner_unicode_flag > 0
            \&& empty(match(extra_text, '^\d\{4}$'))
                let unicode = printf('u%04x', char2nr(chinese))
                let extra_text = menu.'　'.unicode
            endif
            let complete_items["menu"] = extra_text
        endif
        if s:vimim_menu_label > 0
            let abbr = printf('%2s',label) . "\t" . chinese
            let complete_items["abbr"] = abbr
        endif
        let tail = ''
        if keyboard =~ '[.]'
            let dot = stridx(keyboard, '.')
            let dot_at_end = len(keyboard) - dot
            if dot_at_end == 1
                let tail = strpart(keyboard, len(menu))
            else
                let tail = strpart(keyboard, dot+1)
            endif
        elseif s:sentence_match > 0
            let tail = strpart(keyboard, len(menu))
        endif
        if tail =~ '\w'
            let chinese .=  tail
        endif
        let complete_items["word"] = chinese
        let complete_items["dup"] = 1
        let label += 1
        call add(popupmenu_list, complete_items)
    endfor
    let s:keyboards[0] = menu
    if label == 2
        let s:keyboards = ['','']
    endif
    let s:pattern_not_found = 0
    return popupmenu_list
endfunction

" ----------------------------------------
function! s:vimim_datafile_range(keyboard)
" ----------------------------------------
    let lines = s:vimim_load_datafile(0)
    if empty(lines) || empty(a:keyboard)
        return []
    endif
    let ranges = s:vimim_search_boundary(lines, a:keyboard)
    if empty(ranges)
        return []
    elseif len(ranges) == 1
        let ranges = s:vimim_search_boundary(sort(lines), a:keyboard)
        if empty(ranges)
            return
        else
            call s:vimim_update_datafile(lines)
            call s:vimim_save_datafile(lines)
        endif
    endif
    let results = lines[get(ranges,0) : get(ranges,1)]
    return results
endfunction

" ------------------------------------------------
function! s:vimim_search_boundary(lines, keyboard)
" ------------------------------------------------
    if empty(a:lines) || empty(a:keyboard)
        return []
    endif
    let first_char_typed = strpart(a:keyboard,0,1)
    if s:current_datafile_has_dot > 0 && first_char_typed == "."
        let first_char_typed = '\.'
    endif
    let patterns = '^' . first_char_typed
    let match_start = match(a:lines, patterns)
    if match_start < 0
        return []
    endif
    " add boundary to datafile search by exact one letter
    " ---------------------------------------------------
    let ranges = []
    call add(ranges, match_start)
    let match_next = match_start
    " allow empty lines at the end of datafile
    let last_line = a:lines[-1]
    let len_lines = len(a:lines)
    let solid_last_line = substitute(last_line,'\s','','g')
    while empty(solid_last_line)
        let len_lines -= 1
        let last_line = a:lines[len_lines]
        let solid_last_line = substitute(last_line,'\s','','g')
    endwhile
    let first_char_last_line = strpart(last_line,0,1)
    if first_char_typed == first_char_last_line
        let match_next = len(a:lines)-1
    else
        let pattern_next = '^[^' . first_char_typed . ']'
        let result = match(a:lines, pattern_next, match_start)
        if result > 0
            let match_next = result
        endif
    endif
    call add(ranges, match_next)
    if match_start > match_next
        let ranges = ['the_datafile_is_not_sorted_well']
    endif
    return ranges
endfunction

" ---------------------------------------------------
function! s:vimim_exact_match(lines, keyboard, start)
" ---------------------------------------------------
    let keyboard = a:keyboard
    if empty(keyboard)
    \|| empty(a:lines)
    \|| keyboard !=# tolower(keyboard)
        return []
    endif
    let words_limit = 128
    let match_start = a:start
    let match_end = match_start
    let patterns = '^\(' . keyboard. '\)\@!'
    let result = match(a:lines, patterns, match_start)-1
    if result - match_start < 1
        return a:lines[match_start : match_end]
    endif
    if s:vimim_quick_key > 0
        let list_length = result - match_start
        let do_search_on_word = 0
        let quick_limit = 2
        if len(keyboard) < quick_limit
        \|| list_length > words_limit*2
            let do_search_on_word = 1
        elseif s:pinyin_flag > 0
            let chinese = join(a:lines[match_start : result],'')
            let chinese = substitute(chinese,'\p\+','','g')
            if len(chinese) > words_limit*4
                let do_search_on_word = 1
            endif
        endif
        if do_search_on_word > 0
            let patterns = '^\(' . keyboard . '\>\)\@!'
            let result = match(a:lines, patterns, match_start)-1
        endif
    endif
    if empty(result)
        let match_end = match_start
    elseif result > 0 && result > match_start
        let match_end = result
    elseif match_end - match_start > words_limit
        let match_end = match_start + words_limit -1
    endif
    let results = a:lines[match_start : match_end]
    return results
endfunction

" --------------------------------------------
function! s:vimim_fuzzy_match(lines, keyboard)
" --------------------------------------------
    let keyboard = a:keyboard
    if empty(keyboard) || empty(a:lines)
        return []
    endif
    let patterns = s:vimim_fuzzy_pattern(keyboard)
    let results = filter(a:lines, 'v:val =~ patterns')
    if s:english_flag > 0
        call filter(results, 'v:val !~ "#$"')
    endif
    if s:chinese_input_mode < 2
        let results = s:vimim_filter(results, keyboard, 0)
    endif
    return results
endfunction

" ---------------------------------------
function! s:vimim_fuzzy_pattern(keyboard)
" ---------------------------------------
    let keyboard = a:keyboard
    let fuzzy = '\l\+'
    if s:vimim_dummy_shuangpin(keyboard) > 0
        let fuzzy = '.*'
    endif
    if strpart(keyboard,len(keyboard)-1,1) ==# '.'
        let keyboard = strpart(keyboard,0,len(keyboard)-1)
        let fuzzy = '.*'
    endif
    let start = '^'
    let fuzzies = join(split(keyboard,'\ze'), fuzzy)
    let end = fuzzy . '\d\=' . '\>'
    let patterns = start . fuzzies . end
    return patterns
endfunction

" -------------------------------------------------
function! s:vimim_filter(results, keyboard, length)
" -------------------------------------------------
    let filter_length = a:length
    let results = a:results
    let length = len((substitute(a:keyboard,'\A','','')))
    if empty(length) || &encoding != "utf-8"
        return results
    endif
    if empty(filter_length)
        if s:vimim_dummy_shuangpin(a:keyboard) > 0
            let filter_length = length/2 |" 4_char => 2_chinese
        elseif length < 5                |" 4_char => 4_chinese
            let filter_length = length
        endif
    endif
    if filter_length > 0
        let patterns = '\s\+.\{'. filter_length .'}$'
        call filter(results, 'v:val =~ patterns')
    endif
    return results
endfunction

" ---------------------------------------------
function! s:vimim_dummy_shuangpin(keyboard)
" ---------------------------------------------
    if empty(s:vimim_dummy_shuangpin)
    \|| empty(s:pinyin_flag)
    \|| len(a:keyboard) < 4
        return 0
    endif
    let sheng_mu = "[aeiouv]"
    let dummy_shuangpin = 0
    let keyboards = split(a:keyboard, '\(..\)\zs')
    for key in keyboards
        if len(key) < 2
            continue
        endif
        let char = get(split(key,'\zs'),0)
        if char =~ sheng_mu
            let dummy_shuangpin = 0
            break
        endif
        let char = get(split(key,'\zs'),1)
        if char !~ sheng_mu
            let dummy_shuangpin = 0
            break
        endif
        let dummy_shuangpin = 1
    endfor
    return dummy_shuangpin
endfunction

" ================================ }}}
" ====  VimIM Sentence Match  ==== {{{
" ====================================

" --------------------------------------------------
function! s:vimim_keyboard_analysis(lines, keyboard)
" --------------------------------------------------
    let keyboard = a:keyboard
    if empty(a:lines)
    \|| s:chinese_input_mode > 1
    \|| s:current_datafile_has_dot > 0
    \|| s:privates_flag > 1
    \|| len(s:private_matches) > 0
    \|| len(a:keyboard) < 7
        return keyboard
    endif
    if keyboard =~ '^\l\+\d\+\l\+\d\+$'
        let msg = "[diy] ma7712li4002 => [mali,7712,4002]"
        return keyboard
    endif
    let blocks = []
    if keyboard =~ '[.]'
        " step 1: try to break up dot-separated sentence
        " ----------------------------------------------
        let blocks = s:vimim_keyboard_dot_by_dot(keyboard)
        if len(blocks) > 0
            let msg = "enjoy.1010.2523.4498.7429.girl"
            let keyboard = remove(blocks, 0)
        endif
    endif
    let match_start = match(a:lines, '^'.keyboard)
    if match_start < 0
        " step 2: try to match 4-char set wubi or 4corner
        " --------------------------------------------------
        if s:wubi_flag > 0
            let blocks = s:vimim_wubi_whole_match(keyboard)
        elseif s:four_corner_flag > 0
            let blocks = s:vimim_4corner_whole_match(keyboard)
        endif
        " --------------------------------------------------
        if empty(blocks)
            " step 3: try to break up long whole sentence
            let blocks = s:vimim_sentence_whole_match(a:lines, keyboard)
        endif
        " --------------------------------------------------
        if !empty(blocks)
            let keyboard = get(blocks, 0)
        endif
    endif
    return keyboard
endfunction

" ---------------------------------------------
function! s:vimim_keyboard_dot_by_dot(keyboard)
" ---------------------------------------------
    if empty(s:vimim_match_dot_after_dot)
        return []
    endif
    " ---------------------------------------------------
    " meet.teacher.say.hello.sssjj.zdolo.hhyy.sloso.nfofo
    " ---------------------------------------------------
    let keyboards = split(a:keyboard, '[.]')
    return keyboards
endfunction

" -----------------------------------------------------
function! s:vimim_sentence_whole_match(lines, keyboard)
" -----------------------------------------------------
    if empty(s:vimim_match_word_after_word)
    \|| empty(a:lines)
    \|| a:keyboard =~ '\d'
    \|| len(a:keyboard) < 5
        return []
    endif
    let keyboard = a:keyboard
    let pattern = '^' . keyboard . '\>'
    let match_start = match(a:lines, pattern)
    if match_start < 0
        let msg = "let's try backward maximum match"
    else
        return []
    endif
    " -------------------------------------------
    let min = 1
    let max = len(keyboard)
    let block = ''
    let last_part = ''
    " -------------------------------------------
    while max > 2 && min < len(keyboard)
        " -------------------------
        " jiandaolaoshiwenshenghao.
        " -------------------------
        let max -= 1
        let position = max
        if s:smart_backspace > 0
            " ----------------------
            " wozuixihuandeliulanqi.
            " ----------------------
            let min += 1
            let position = min
        endif
        let block = strpart(keyboard, 0, position)
        let pattern = '^' . block . '\>'
        let match_start = match(a:lines, pattern)
        if  match_start < 0
            let msg = "continue until match is found"
        else
            let last_part = strpart(keyboard, position)
            break
        endif
    endwhile
    " -------------------------------------------
    let blocks = []
    if !empty(block)
    \&& !empty(last_part)
    \&& block.last_part ==# keyboard
        call add(blocks, block)
        call add(blocks, last_part)
    endif
    return blocks
endfunction

" -----------------------------------------
function! s:vimim_keyboard_block_by_block()
" -----------------------------------------
    let key = "\<C-Y>"
    if s:chinese_input_mode > 1
        return key
    endif
    let s:smart_backspace = 0
    let key .= '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
    return key
endfunction

" -------------------------------
function! g:vimim_ctrl_x_ctrl_u()
" -------------------------------
    let key = ''
    let char_before = getline(".")[col(".")-2]
    if char_before =~# s:valid_key
        let key = '\<C-X>\<C-U>'
        if empty(s:vimim_sexy_input_style)
            let key .= '\<C-R>=g:vimim_menu_select()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" -----------------------------
function! g:vimim_menu_select()
" -----------------------------
    let select_not_insert = ''
    if pumvisible()
        let select_not_insert = '\<C-P>\<Down>'
        if s:insert_without_popup_flag > 0
            let s:insert_without_popup_flag = 0
            let select_not_insert = '\<C-Y>'
        endif
    endif
    sil!exe 'sil!return "' . select_not_insert . '"'
endfunction

" ================================ }}}
" ====  VimIM Datafile Update ==== {{{
" ====================================

" -------------------------------------------
function! s:vimim_chinese_before(row, column)
" -------------------------------------------
    let start_row_before = s:start_row_before
    let char_start = s:start_column_before
    let start_row = a:row
    let start_column = a:column
    let char_end = start_column-1
    let chinese = ''
    if start_row_before == start_row && char_end > char_start
        let current_line = getline(start_row)
        let chinese = current_line[char_start : char_end]
    elseif start_row - start_row_before == 1
        let previous_line = getline(start_row_before)
        let char_end = len(previous_line)
        let chinese = previous_line[char_start : char_end]
    endif
    let key = get(s:keyboards, 0)
    if len(key)>0 && key =~ '\l' && len(chinese) > 1
        let chinese = substitute(chinese,'\p\+','','g')
    endif
    return chinese
endfunction

" ----------------------------------------------
function! s:vimim_new_order_in_memory(keyboards)
" ----------------------------------------------
    let lines = s:vimim_load_datafile(0)
    let keyboard = get(a:keyboards,0)
    let chinese = get(a:keyboards,1)
    if empty(lines)
    \|| char2nr(chinese) < 127
    \|| keyboard !~ s:valid_key
        return []
    endif
    """ step 1/6: modify datafile in memory based on usage
    let patterns = '^' . keyboard . '\>'
    let matched = match(lines, patterns)
    if matched < 0
        return []
    endif
    let insert_index = matched
    """ step 2/6: save the first item which is to be set fixed
    let first_matched_line = get(lines, matched)
    let first_fixed_item = get(split(first_matched_line),1)
    """ step 3/6: remove all entries matching key from datafile
    let one_line_chinese_list = []
    while matched > 0
        let old_item = remove(lines, matched)
        let values = split(old_item)
        call extend(one_line_chinese_list, values[1:])
        let matched = match(lines, patterns, insert_index)
    endwhile
    """ step 4/6: make a new order list
    let results = []
    let used = match(one_line_chinese_list, chinese)
    if used > 0
        let head = remove(one_line_chinese_list, used)
        call insert(one_line_chinese_list, head)
    endif
    if empty(one_line_chinese_list)
        return []
    endif
    """ step 5/6: made the first candidate fixed
    if s:vimim_first_candidate_fix > 0
        let index = match(one_line_chinese_list, first_fixed_item)
        let first_fixed_item = remove(one_line_chinese_list, index)
        call insert(one_line_chinese_list, first_fixed_item)
    endif
    """ step 6/6: insert the new order list into memory
    let new_item = keyboard .' '. join(one_line_chinese_list)
    call insert(lines, new_item, insert_index)
    return lines
endfunction

" ------------------------------------------
function! s:vimim_load_datafile(reload_flag)
" ------------------------------------------
    if empty(s:lines_datafile) || a:reload_flag > 0
        if len(s:current_datafile) > 0
        \&& filereadable(s:current_datafile)
            let s:lines_datafile = readfile(s:current_datafile)
        endif
        if len(s:four_corner_datafile) > 0
            if empty(s:lines_4corner_datafile)
                let s:lines_4corner_datafile = s:vimim_load_4corner()
            endif
            if len(s:lines_4corner_datafile) > 1
            \&& len(s:lines_datafile) > 1
                call extend(s:lines_datafile, s:lines_4corner_datafile, 0)
                let s:diy_pinyin_4corner = 999
            endif
        endif
    endif
    return s:lines_datafile
endfunction

" -----------------------------------------
function! s:vimim_save_input_history(lines)
" -----------------------------------------
    let frequency = s:vimim_save_input_history_frequency
    if frequency > 1
        let frequency = (frequency<12) ? 12 : frequency
        if s:keyboard_counts>0 && empty(s:keyboard_counts % frequency)
            call s:vimim_save_datafile(a:lines)
        endif
    endif
endfunction

" ------------------------------------
function! s:vimim_save_datafile(lines)
" ------------------------------------
    if empty(a:lines)
    \|| empty(s:lines_datafile)
    \|| s:diy_pinyin_4corner == 999
        return
    endif
    if filewritable(s:current_datafile)
        call writefile(a:lines, s:current_datafile)
    endif
    if empty(s:localization)
    \&& s:vimim_save_input_history_frequency > 0
        let warning = 'performance hit if &encoding & datafile differs!'
    endif
endfunction

" --------------------------------------
function! s:vimim_update_datafile(lines)
" --------------------------------------
    if empty(a:lines) || empty(s:lines_datafile)
        return
    else
        let s:lines_datafile = a:lines
    endif
endfunction

" ------------------------------
function! <SID>vimim_save(entry)
" ------------------------------
    if empty(a:entry)
        return
    endif
    let entries = []
    let entry_split_list = split(a:entry,'\n')
    for entry in entry_split_list
        let has_space = match(entry, '\s')
        if has_space < 0
            continue
        endif
        let words = split(entry)
        if len(words) < 2
            continue
        endif
        let menu = remove(words, 0)
        if menu !~ s:valid_key
            continue
        endif
        if char2nr(get(words,0)) < 128
            continue
        endif
        let line = menu .' '. join(words, ' ')
        let line = s:vimim_i18n_write(line)
        call add(entries, line)
    endfor
    let lines = s:vimim_insert_entry(s:vimim_load_datafile(1), entries)
    call s:vimim_update_datafile(lines)
    call s:vimim_save_datafile(lines)
endfunction

" --------------------------------------------
function! s:vimim_insert_entry(lines, entries)
" --------------------------------------------
    let lines = a:lines
    let len_lines = len(a:lines)
    if empty(lines) || empty(a:entries)
        return []
    endif
    let sort_before_save = 0
    let position = -1
    for entry in a:entries
        let pattern = '^' . entry . '$'
        let matched = match(lines, pattern)
        if matched > -1
            continue
        endif
        let menu = get(split(entry),0)
        let length = len(menu)
        while length > 0
            let one_less = strpart(menu, 0, length)
            let length -= 1
            let matched = match(lines, '^'.one_less)
            if matched < 0
                if length < 1
                    let only_char = strpart(one_less, 0, 1)
                    let char = char2nr(only_char)
                    while (char >= char2nr('a') && char < char2nr('z'))
                        let patterns = '^' . nr2char(char)
                        let position = match(lines, patterns)
                        let char -= 1
                        if position > -1
                            let pattern = '^\('.nr2char(char+1).'\)\@!'
                            let matched = position
                            let position = match(lines, pattern, matched)
                            if position > -1
                                break
                            endif
                        endif
                    endwhile
                endif
                continue
            else
                if length+1 == len(menu)
                    let patterns = '^' . menu . '.\>'
                    let next = match(lines, patterns, matched)
                    if next > -1
                        for i in reverse(range(matched, next))
                            let position = i
                            if position<len_lines && entry<lines[position]
                                break
                            endif
                        endfor
                        if position > matched
                            break
                        endif
                    endif
                endif
                let patterns = '^\(' . one_less . '\)\@!'
                let position = match(lines, patterns, matched)
                if position > -1
                    break
                else
                    let position = matched+1
                    break
                endif
            endif
        endwhile
        if position < 0
        \|| (position-1<len_lines && lines[position-1]>entry)
        \|| (position-1<len_lines && entry>lines[position+1])
            let sort_before_save = 1
        endif
        call insert(lines, entry, position)
    endfor
    if len(lines) < len_lines
        return []
    endif
    if sort_before_save > 0
        call sort(lines)
    endif
    return lines
endfunction

" --------------------------------------------
function! s:vimim_build_reverse_cache(chinese)
" --------------------------------------------
    let lines = s:vimim_load_datafile(0)
    if empty(lines)
        return {}
    endif
    if empty(s:alphabet_lines)
        let first_line_index = 0
        let index = match(lines, '^a')
        if index > -1
            let first_line_index = index
        endif
        let last_line_index = len(lines) - 1
        let s:alphabet_lines = lines[first_line_index : last_line_index]
        if s:pinyin_flag > 0 |" one to many relationship
            let pinyin_with_tone = '^\a\+\d\s\+'
            call filter(s:alphabet_lines, 'v:val =~ pinyin_with_tone')
        endif
    endif
    if empty(s:alphabet_lines)
        return {}
    endif
    " ----------------------------------------
    let alphabet_lines = []
    if &encoding == "utf-8"
        let alphabet_lines = copy(s:alphabet_lines)
    else
        for line in s:alphabet_lines
            if line !~ '^v\d\s\+'
                let line = s:vimim_i18n_read(line)
            endif
            call add(alphabet_lines, line)
        endfor
    endif
    " ----------------------------------------
    let characters = split(a:chinese,'\zs')
    let character = join(characters,'\|')
    call filter(alphabet_lines, 'v:val =~ character')
    " ----------------------------------------
    let cache = {}
    for line in alphabet_lines
        if empty(line)
            continue
        endif
        let words = split(line)
        if len(words) < 2
            continue
        endif
        let menu = remove(words, 0)
        if s:pinyin_flag > 0
            let menu = substitute(menu,'\d','','g')
        endif
        for char in words
            if match(characters, char) < 0
                continue
            endif
            if has_key(cache,char) && menu!=cache[char]
                let cache[char] = menu .'|'. cache[char]
            else
                let cache[char] = menu
            endif
        endfor
    endfor
    return cache
endfunction

" ----------------------------------------------
function! s:vimim_make_one_entry(cache, chinese)
" ----------------------------------------------
    if empty(a:chinese) || empty(a:cache)
        return []
    endif
    let characters = split(a:chinese, '\zs')
    let items = []
    for char in characters
        if has_key(a:cache, char)
            let menu = a:cache[char]
            call add(items, menu)
        endif
    endfor
    return items
endfunction

" ---------------------------------------
function! s:vimim_reverse_lookup(chinese)
" ---------------------------------------
    let chinese = substitute(a:chinese,'\s\+\|\w\|\n','','g')
    let chinese_characters = split(chinese,'\zs')
    let chinese_char = join(chinese_characters, '   ')
    " ------------------------------------------------
    let result_unicode = ''
    let items = []
    if s:vimim_unicode_lookup > 0
        for char in chinese_characters
            let unicode = printf('%04x',char2nr(char))
            call add(items, unicode)
        endfor
        let unicode = join(items, ' ')
        let result_unicode = unicode. "\n" . chinese_char
    endif
    " ------------------------------------------------
    let result_4corner = ''
    if s:four_corner_flag > 0
        let cache_4corner = s:vimim_build_4corner_cache(chinese)
        let items = s:vimim_make_one_entry(cache_4corner, chinese)
        let result_4corner = join(items,' ')."\n".chinese_char
    endif
    " ------------------------------------------------
    let cache_pinyin = s:vimim_build_reverse_cache(chinese)
    let items = s:vimim_make_one_entry(cache_pinyin, chinese)
    let result_pinyin = join(items,'')." ".chinese
    " ------------------------------------------------
    let result = ''
    if len(result_unicode) > 0
        let result .= "\n" . result_unicode
    endif
    if len(result_4corner) > 0
        let result .= "\n" . result_4corner
    endif
    if result_pinyin =~ '\a'
        let result .= "\n" .result_pinyin
    endif
    return result
endfunction

" ================================ }}}
" ====  VimIM Private Data    ==== {{{
" ====================================

" ----------------------------------------------
function! s:vimim_initialize_datafile_privates()
" ----------------------------------------------
    let s:privates_datafile = 0
    let s:lines_privates_datafile = []
    let s:private_matches = []
    if s:privates_flag > 1
        return
    endif
    let datafile = s:path . "privates.txt"
    if !empty(s:vimim_privates_txt)
    \&& filereadable(s:vimim_privates_txt)
        let s:privates_datafile = s:vimim_privates_txt
    elseif filereadable(datafile)
        let s:privates_datafile = datafile
    endif
    if empty(s:privates_datafile)
        return
    else
        let s:privates_flag = 1
    endif
endfunction

" -----------------------------------------------
function! s:vimim_search_vimim_privates(keyboard)
" -----------------------------------------------
    let lines = s:vimim_load_privates(0)
    let len_privates_lines = len(lines)
    let keyboard = a:keyboard
    if empty(len_privates_lines) || len(keyboard) < 3
        return []
    endif
let g:ga=keyboard
    let pattern = "\\C" . "^" . keyboard  . '\>'
    let matched = match(lines, pattern)
    let matches = []
    if matched < 0
        let matches = s:vimim_fuzzy_match(lines, keyboard)
    else
        let matches = s:vimim_exact_match(lines, keyboard, matched)
    endif
    if len(lines) < len_privates_lines
        call s:vimim_load_privates(1)
    endif
    return matches
endfunction

" ------------------------------------------
function! s:vimim_load_privates(reload_flag)
" ------------------------------------------
    if empty(s:privates_flag)
        return []
    endif
    if empty(s:lines_privates_datafile) || a:reload_flag > 0
        let datafile = s:privates_datafile
        if filereadable(datafile)
            let s:lines_privates_datafile = readfile(datafile)
        endif
    endif
    return s:lines_privates_datafile
endfunction

" ================================ }}}
" ====  VimIM Four Corner     ==== {{{
" ====================================

" ---------------------------------------------
function! s:vimim_initialize_datafile_4corner()
" ---------------------------------------------
    let s:four_corner_datafile = 0
    let s:lines_4corner_datafile = []
    let s:four_corner_lines = []
    let s:four_corner_unicode_flag = 0
    let s:unicode_menu_display_flag = 0
    if s:vimim_debug_flag > 0 || empty(s:pinyin_flag)
        return
    endif
    let datafile = s:path . "vimim.4corner.txt"
    if filereadable(datafile)
        let msg = 'we want to play with four corner.'
    else
        let datafile = s:path . "vimim.12345.txt"
        if filereadable(datafile)
            let msg = 'we want to play with 5 strokes.'
        else
            return
        endif
    endif
    let s:four_corner_flag = 1
    let s:four_corner_datafile = datafile
endfunction

" ------------------------------
function! s:vimim_load_4corner()
" ------------------------------
    if s:vimim_debug_flag > 0 || empty(s:four_corner_flag)
        return []
    endif
    if empty(s:lines_4corner_datafile)
        let datafile = s:four_corner_datafile
        if !empty(datafile) && filereadable(datafile)
            let s:lines_4corner_datafile = readfile(datafile)
        endif
    endif
    return s:lines_4corner_datafile
endfunction

" ---------------------------------------------
function! s:vimim_4corner_whole_match(keyboard)
" ---------------------------------------------
    if s:chinese_input_mode > 1
    \|| a:keyboard !~ '\d'
    \|| s:four_corner_flag > 4
    \|| len(a:keyboard)%4 != 0
        return []
    endif
    " -------------------------------
    " sijiaohaoma == 6021272260021762
    " -------------------------------
    let keyboards = split(a:keyboard, '\(.\{4}\)\zs')
    return keyboards
endfunction

" ---------------------------------------------
function! s:vimim_diy_keyboard2number(keyboard)
" ---------------------------------------------
    let keyboard = a:keyboard
    if empty(s:diy_pinyin_4corner)
    \|| s:chinese_input_mode > 1
    \|| len(a:keyboard) < 5
    \|| len(a:keyboard) > 6
        return keyboard
    endif
    if keyboard =~ '^\l\+\d\+\l\+\d\+$'
        return keyboard
    elseif a:keyboard =~ '\d'
        return keyboard
    else
        let s:diy_pinyin_4corner = 4
    endif
    let alphabet_length = 0
    if len(keyboard) == 5
        let msg = 'asofo'
        let alphabet_length = 1
    elseif len(keyboard) == 6
        let msg = 'zaskso'
        let alphabet_length = 2
    else
        return keyboard
    endif
    let result = strpart(keyboard, 0, alphabet_length)
    if result !~ '\l'
        return keyboard
    endif
    let four_corner = strpart(keyboard, alphabet_length)
    if four_corner !~ '\D'
        return keyboard
    endif
    for char in split(four_corner, '\zs')
        if has_key(s:digit_keyboards, char)
            let digit = s:digit_keyboards[char]
            let result .= digit
        else
            return keyboard
        endif
    endfor
    return result
endfunction

" --------------------------------------------
function! s:vimim_build_4corner_cache(chinese)
" --------------------------------------------
    let lines = s:vimim_load_datafile(0)
    if empty(lines)
        return {}
    endif
    if empty(s:four_corner_lines)
        let first_non_digit_line = 0
        let index = match(lines, '^\D')
        if index > -1
            let first_non_digit_line = index
        endif
        let s:four_corner_lines = lines[0 : first_non_digit_line-1]
    endif
    if empty(s:four_corner_lines)
        return {}
    endif
    " --------------------------------------
    let lines = copy(s:four_corner_lines)
    let characters = split(a:chinese, '\zs')
    " --------------------------------------
    let cache = {}
    for line in lines
        let line = s:vimim_i18n_read(line)
        let words = split(line)
        let value = remove(words, 0)
        for key in words
            if match(characters, key) < 0
                continue
            endif
            let cache[key] = value
        endfor
    endfor
    return cache
endfunction

" ================================ }}}
" ====  VimIM Pinyin Special  ==== {{{
" ====================================

" --------------------------------------------
function! s:vimim_initialize_datafile_pinyin()
" --------------------------------------------
    if s:pinyin_flag > 0
        let s:vimim_fuzzy_search = 1
        let s:vimim_match_word_after_word = 1
        let s:vimim_save_input_history_frequency = 1
    endif
endfunction

" ------------------------------------
function! s:vimim_apostrophe(keyboard)
" ------------------------------------
    let keyboard = a:keyboard
    if s:pinyin_flag > 0
    \&& empty(s:vimim_apostrophe_in_pinyin)
        " if apostrophe is in the pinyin datafile
        " ---------------------------------------
        let keyboard = substitute(keyboard,"'",'','g')
    endif
    return keyboard
endfunction

" -------------------------------------------
function! s:vimim_auto_spell(lines, keyboard)
" -------------------------------------------
    if empty(s:pinyin_flag)
    \|| empty(s:vimim_auto_spell)
    \|| empty(a:lines)
    \|| empty(a:keyboard)
        return -1
    endif
    " ------------------------------------------
    " to guess user's intention using auto_spell
    " ------------------------------------------
    let key = s:vimim_auto_spell_rule(a:keyboard)
    let match_start = match(a:lines, '^'.key)
    return match_start
endfunction


" -----------------------------------------
function! s:vimim_auto_spell_rule(keyboard)
" -----------------------------------------
    " A demo rule for auto spelling
    "    tign => tign
    "     yve => yue
    " --------------------------------
    let rules = {}
    let rules['ign'] = 'ing'
    let rules['iou'] = 'iu'
    let rules['uei'] = 'ui'
    let rules['uen'] = 'un'
    let rules['mg']  = 'ng'
    let rules['ve']  = 'ue'
    " --------------------------------
    let pattern = a:keyboard
    for key in keys(rules)
        let new_key = rules[key]
        if pattern =~ key
            let pattern = substitute(pattern, key, new_key, '')
            break
        endif
    endfor
    return pattern
endfunction

" ================================ }}}
" ====  VimIM Shuang Pin      ==== {{{
" ====================================

" --------------------------------------
function! s:vimim_initialize_shuangpin()
" --------------------------------------
    if empty(s:pinyin_flag)
        return
    endif
    if empty(s:vimim_shuangpin_microsoft)
        \&& empty(s:vimim_shuangpin_purple)
        \&& empty(s:vimim_shuangpin_abc)
        \&& empty(s:vimim_shuangpin_nature)
        \&& empty(s:vimim_shuangpin_plusplus)
        return
    endif
    let s:pinyin_flag = 2
    let s:shuangpin_flag = 1
    let s:vimim_static_input_style = 1
    let rules = s:vimim_shuangpin_generic()
    if s:vimim_shuangpin_microsoft > 0
        let rules = s:vimim_shuangpin_microsoft(rules)
    elseif s:vimim_shuangpin_abc > 0
        let rules = s:vimim_shuangpin_abc(rules)
    elseif s:vimim_shuangpin_nature > 0
        let rules = s:vimim_shuangpin_nature(rules)
    elseif s:vimim_shuangpin_purple > 0
        let rules = s:vimim_shuangpin_purple(rules)
    elseif s:vimim_shuangpin_plusplus > 0
        let rules = s:vimim_shuangpin_plusplus(rules)
    endif
    let s:shuangpin_table = s:vimim_create_shuangpin_table(rules)
endfunction

" ----------------------------------
function! s:vimim_resume_shuangpin()
" ----------------------------------
    if s:pinyin_flag == 2 && empty(s:shuangpin_flag)
        let s:shuangpin_flag = 1
        let s:shuangpin_in_quanpin = 0
    endif
endfunction

" -----------------------------------------
function! s:vimim_shuangpin_transform(keyb)
" -----------------------------------------
    if empty(s:shuangpin_flag)
        return a:keyb
    endif
    let size = strlen(a:keyb)
    let ptr = 0
    let output = ""
    while ptr < size
        if a:keyb[ptr] !~ "[a-z;]"
            " bypass all non-characters, i.e. 0-9 and A-Z are bypassed
            let output .= a:keyb[ptr]
            let ptr += 1
        else
            if a:keyb[ptr+1] =~ "[a-z;]"
                let sp1 = a:keyb[ptr].a:keyb[ptr+1]
            else
                let sp1 = a:keyb[ptr]
            endif
            if has_key(s:shuangpin_table, sp1)
                " the last odd shuangpin code are output as only shengmu
                let output .= s:shuangpin_table[sp1] . "'"
            else
                " invalid shuangpin code are preserved
                let output .= sp1
            endif
            let ptr += strlen(sp1)
        endif
    endwhile
    return output
endfunction

" --------------------------------------------
function! s:vimim_create_shuangpin_table(rule)
" --------------------------------------------
    let rules = a:rule
    let sptable = {}
    let pinyin_list = [
    \'''a','''ai','''an','''ang','''ao','ba','bai','ban','bang','bao',
    \'bei','ben','beng','bi','bian','biao','bie','bin','bing','bo','bu',
    \'ca','cai','can','cang','cao','ce','cen','ceng','cha','chai','chan',
    \'chang','chao','che','chen','cheng','chi','chong','chou','chu',
    \'chua','chuai','chuan','chuang','chui','chun','chuo','ci','cong',
    \'cou','cu','cuan','cui','cun','cuo','da','dai','dan','dang','dao',
    \'de','dei','deng','di','dia','dian','diao','die','ding','diu',
    \'dong','dou','du','duan','dui','dun','duo','''e','''ei','''en',
    \'''er','fa','fan','fang','fe','fei','fen','feng','fiao','fo','fou',
    \'fu','ga','gai','gan','gang','gao','ge','gei','gen','geng','gong',
    \'gou','gu','gua','guai','guan','guang','gui','gun','guo','ha','hai',
    \'han','hang','hao','he','hei','hen','heng','hong','hou','hu','hua',
    \'huai','huan','huang','hui','hun','huo','''i','ji','jia','jian',
    \'jiang','jiao','jie','jin','jing','jiong','jiu','ju','juan','jue',
    \'jun','ka','kai','kan','kang','kao','ke','ken','keng','kong','kou',
    \'ku','kua','kuai','kuan','kuang','kui','kun','kuo','la','lai','lan',
    \'lang','lao','le','lei','leng','li','lia','lian','liang','liao',
    \'lie','lin','ling','liu','long','lou','lu','luan','lue','lun','luo',
    \'lv','ma','mai','man','mang','mao','me','mei','men','meng','mi',
    \'mian','miao','mie','min','ming','miu','mo','mou','mu','na','nai',
    \'nan','nang','nao','ne','nei','nen','neng','''ng','ni','nian',
    \'niang','niao','nie','nin','ning','niu','nong','nou','nu','nuan',
    \'nue','nuo','nv','''o','''ou','pa','pai','pan','pang','pao','pei',
    \'pen','peng','pi','pian','piao','pie','pin','ping','po','pou','pu',
    \'qi','qia','qian','qiang','qiao','qie','qin','qing','qiong','qiu',
    \'qu','quan','que','qun','ran','rang','rao','re','ren','reng','ri',
    \'rong','rou','ru','ruan','rui','run','ruo','sa','sai','san','sang',
    \'sao','se','sen','seng','sha','shai','shan','shang','shao','she',
    \'shei','shen','sheng','shi','shou','shu','shua','shuai','shuan',
    \'shuang','shui','shun','shuo','si','song','sou','su','suan','sui',
    \'sun','suo','ta','tai','tan','tang','tao','te','teng','ti','tian',
    \'tiao','tie','ting','tong','tou','tu','tuan','tui','tun','tuo',
    \'''u','''v','wa','wai','wan','wang','wei','wen','weng','wo','wu',
    \'xi','xia','xian','xiang','xiao','xie','xin','xing','xiong','xiu',
    \'xu','xuan','xue','xun','ya','yan','yang','yao','ye','yi','yin',
    \'ying','yo','yong','you','yu','yuan','yue','yun','za','zai','zan',
    \'zang','zao','ze','zei','zen','zeng','zha','zhai','zhan','zhang',
    \'zhao','zhe','zhen','zheng','zhi','zhong','zhou','zhu','zhua',
    \'zhuai','zhuan','zhuang','zhui','zhun','zhuo','zi','zong','zou','zu',
    \'zuan','zui','zun','zuo']
    " generate table for shengmu-yunmu pairs match
    for key in pinyin_list
        if key !~ "['a-z]*"
            continue
        endif
        if key[1] == "h"
            let shengmu = key[:1]
            let yunmu = key[2:]
        else
            let shengmu = key[0]
            let yunmu = key[1:]
        endif
        if has_key(rules[0], shengmu)
            let shuangpin_shengmu = rules[0][shengmu]
        else
            continue
        endif
        if has_key(rules[1], yunmu)
            let shuangpin_yunmu = rules[1][yunmu]
        else
            continue
        endif
        let sp1 = shuangpin_shengmu.shuangpin_yunmu
        if !has_key(sptable, sp1)
            if key[0] == "'"
                let key = key[1:]
            end
            let sptable[sp1] = key
        endif
    endfor
    " the jxqy+v special case handling
    if (s:vimim_shuangpin_abc>0) || (s:vimim_shuangpin_purple>0)
        call extend(sptable, {"jv":"ju","qv":"qu","xv":"xu","yv":"yu"})
    elseif s:vimim_shuangpin_microsoft > 0
        call extend(sptable, {"jv":"jue","qv":"que","xv":"xue","yv":"yue"} )
    endif
    " generate table for shengmu-only match
    for [key, value] in items(rules[0])
        if key[0] == "'"
            let sptable[value] = ""
        else
            let sptable[value] = key
        end
    endfor
    " free the list
    unlet pinyin_list
    " finished init sptable, will use in s:vimim_shuangpin_transform
    return sptable
endfunction

" -----------------------------------
function! s:vimim_shuangpin_generic()
" -----------------------------------
" generate the default value of shuangpin table
    let shengmu_list = {}
    for shengmu in ["b","p","m","f","d","t","l","n",
                \"g","k","h","j","q","x","r","z","c","s","y","w"]
        let shengmu_list[shengmu] = shengmu
    endfor
    let shengmu_list["'"] = "o"
    let yunmu_list = {}
    for yunmu in ["a","o","e","i","u","v"]
        let yunmu_list[yunmu] = yunmu
    endfor
    let s:shuangpin_rule = [shengmu_list, yunmu_list]
    return s:shuangpin_rule
endfunction

" -----------------------------------
function! s:vimim_shuangpin_abc(rule)
" -----------------------------------
    " vtpc         => shuang pin       => double pinyin
    " womfdbzlaeli => womendouzaizheli => we are all here
    " woybyigemg   => woyouyigemeng    => i have a dream
    " ---------------------------------------------------
    call extend(a:rule[0],{ "zh":"a","ch":"e","sh":"v" })
    call extend(a:rule[1],{
        \"an":"j","ao":"k","ai":"l","ang":"h",
        \"ong":"s","ou":"b",
        \"en":"f","er":"r","ei":"q","eng":"g","ng":"g",
        \"ia":"d","iu":"r","ie":"x","in":"c","ing":"y",
        \"iao":"z","ian":"w","iang":"t","iong":"s",
        \"un":"n","ua":"d","uo":"o","ue":"m","ui":"m",
        \"uai":"c","uan":"p","uang":"t" } )
    return a:rule
endfunction

" -----------------------------------------
function! s:vimim_shuangpin_microsoft(rule)
" -----------------------------------------
    " vi=>zhi ii=>chi ui=>shi keng=>keneng
    " ------------------------------------
    call extend(a:rule[0],{ "zh":"v","ch":"i","sh":"u" })
    call extend(a:rule[1],{
        \"an":"j","ao":"k","ai":"l","ang":"h",
        \"ong":"s","ou":"b",
        \"en":"f","er":"r","ei":"z","eng":"g","ng":"g",
        \"ia":"w","iu":"q","ie":"x","in":"n","ing":";",
        \"iao":"c","ian":"m","iang":"d","iong":"s",
        \"un":"p","ua":"w","uo":"o","ue":"t","ui":"v",
        \"uai":"y","uan":"r","uang":"d" ,
        \"v":"y"} )
    return a:rule
endfunction

" --------------------------------------
function! s:vimim_shuangpin_nature(rule)
" --------------------------------------
    " goal: 'woui' => wo shi => i am
    " -------------------------------
    call extend(a:rule[0],{ "zh":"v","ch":"i","sh":"u" })
    call extend(a:rule[1],{
        \"an":"j","ao":"k","ai":"l","ang":"h",
        \"ong":"s","ou":"b",
        \"en":"f","er":"r","ei":"z","eng":"g","ng":"g",
        \"ia":"w","iu":"q","ie":"x","in":"n","ing":"y",
        \"iao":"c","ian":"m","iang":"d","iong":"s",
        \"un":"p","ua":"w","uo":"o","ue":"t","ui":"v",
        \"uai":"y","uan":"r","uang":"d" } )
    return a:rule
endfunction

" ----------------------------------------
function! s:vimim_shuangpin_plusplus(rule)
" ----------------------------------------
    call extend(a:rule[0],{ "zh":"v","ch":"u","sh":"i" })
    call extend(a:rule[1],{
        \"an":"f","ao":"d","ai":"s","ang":"g",
        \"ong":"y","ou":"p",
        \"en":"r","er":"q","ei":"w","eng":"t","ng":"t",
        \"ia":"b","iu":"n","ie":"m","in":"l","ing":"q",
        \"iao":"k","ian":"j","iang":"h","iong":"y",
        \"un":"z","ua":"b","uo":"o","ue":"x","ui":"v",
        \"uai":"x","uan":"c","uang":"h" } )
    return a:rule
endfunction

" --------------------------------------
function! s:vimim_shuangpin_purple(rule)
" --------------------------------------
    call extend(a:rule[0],{ "zh":"u","ch":"a","sh":"i" })
    call extend(a:rule[1],{
        \"an":"r","ao":"q","ai":"p","ang":"s",
        \"ong":"h","ou":"z",
        \"en":"w","er":"j","ei":"k","eng":"t","ng":"t",
        \"ia":"x","iu":"j","ie":"d","in":"y","ing":";",
        \"iao":"b","ian":"f","iang":"g","iong":"h",
        \"un":"m","ua":"x","uo":"o","ue":"n","ui":"n",
        \"uai":"y","uan":"l","uang":"g"} )
    return a:rule
endfunction

" ================================ }}}
" ====  VimIM Erbi Special    ==== {{{
" ====================================

" ------------------------------------------
function! s:vimim_initialize_datafile_erbi()
" ------------------------------------------
    if s:erbi_flag > 0
        let s:vimim_punctuation_navigation = 0
        let s:search_key_slash = -1
        let s:wubi_flag = 1
    endif
endfunction

" ================================ }}}
" ====  VimIM Wubi Special    ==== {{{
" ====================================

" ------------------------------------------
function! s:vimim_initialize_datafile_wubi()
" ------------------------------------------
    if s:wubi_flag > 0
        if s:vimim_static_input_style > 0
            let s:vimim_wubi_non_stop = 0
        endif
    endif
endfunction

" ------------------------------
function! s:vimim_wubi(keyboard)
" ------------------------------
    let keyboard = a:keyboard
    let lines = s:vimim_datafile_range(keyboard)
    if empty(lines) || empty(keyboard)
        return []
    endif
    " ----------------------------
    " support wubi wildcard search
    " ----------------------------
    if s:chinese_input_mode < 2
        if match(keyboard,'z') > 0 && empty(s:erbi_flag)
            let fuzzies = keyboard
            if strpart(keyboard,0,2) != 'zz'
                let fuzzies = substitute(keyboard,'z','.','g')
            endif
            let fuzzy = '^' . fuzzies . '\>'
            call filter(lines, 'v:val =~ fuzzy')
            return lines
        endif
    endif
    " ----------------------------
    " support wubi non-stop typing
    " ----------------------------
    if s:wubi_flag > 0 && s:vimim_wubi_non_stop > 0
        if len(keyboard) > 4
            let start = 4*((len(keyboard)-1)/4)
            let keyboard = strpart(keyboard, start)
        endif
        let s:keyboard_wubi = keyboard
    endif
    let results = []
    let pattern = '^' . keyboard
    let match_start = match(lines, pattern)
    if  match_start > -1
        let results = s:vimim_exact_match(lines, keyboard, match_start)
    endif
    return results
endfunction

" ------------------------------------------
function! s:vimim_wubi_whole_match(keyboard)
" ------------------------------------------
    if s:chinese_input_mode > 1
    \|| a:keyboard !~# '\l'
    \|| !empty((a:keyboard)%4)
        return []
    endif
    " -------------------------------------
    " [wubi] trdeggwhssqu => i have a dream
    " -------------------------------------
    let keyboards = split(a:keyboard,'\(.\{4}\)\zs')
    return keyboards
endfunction

" ================================ }}}
" ====  VimIM Sogou Cloud IM  ==== {{{
" ====================================

" ---------------------------------------
function! s:vimim_plug_n_play_www_sogou()
" ---------------------------------------
    if s:vimim_www_sogou > 0
        return
    endif
    if empty(s:current_datafile)
    \|| s:privates_flag == 2
        if (executable('wget') || executable('curl'))
            let s:vimim_www_sogou = 1
        endif
    endif
    " support 'plug and play' (throw wget.exe to plugin directory)
    " for Windows user who does not know how to set PATH,
    if has("win32") || has("win32unix")
    \&& empty(s:vimim_www_sogou)
        let wget = s:path . "wget.exe"
        if executable(wget)
            let s:vimim_www_sogou = 1
            let s:www_executable = wget
        endif
    endif
endfunction

" --------------------------------------
function! s:vimim_initialize_www_sogou()
" --------------------------------------
    call s:vimim_plug_n_play_www_sogou()
    if empty(s:vimim_www_sogou) || !exists('*system')
        return
    endif
    " step 1: try to find wget
    " ------------------------
    let wget = 0
    if s:www_executable =~ "wget.exe"
        let wget = s:www_executable
    elseif executable('wget')
        let wget = "wget"
    endif
    if empty(wget)
        let msg = "wget is not available"
    else
        let wget_option = " -qO - --timeout 12 -t 4 "
        let s:www_executable = wget . wget_option
    endif
    " step 2: try to find curl if no wget
    " -----------------------------------
    if empty(s:www_executable)
        if executable('curl')
            let s:www_executable = "curl -s "
        endif
    endif
    if empty(s:www_executable)
        let s:vimim_www_sogou = 0
        return
    endif
    " step 3: make it ready for "cloud".
    " ----------------------------------
    if empty(s:pinyin_flag)
        let s:pinyin_flag = 1
    endif
endfunction

" --------------------------------------------
function! s:vimim_get_cloud_keyboard(keyboard)
" --------------------------------------------
    let keyboard = a:keyboard
    if empty(s:vimim_www_sogou)
    \|| keyboard =~ '\d\d\d\d'
        let msg = "We play 4 corner by ourselves without Cloud."
        return 0
    endif
    let dot = strpart(keyboard, len(keyboard)-2)
    if dot ==# '..'
        " always do cloud when keyboard ends with two dots
        let s:no_internet_connection = 0
        let keyboard = strpart(keyboard, 0, len(keyboard)-2)
        let s:keyboard_leading_zero = keyboard
    elseif keyboard =~ '[.]'
    \|| len(keyboard) < s:vimim_www_sogou
        return 0
    endif
    return keyboard
endfunction

" --------------------------------------------
function! s:vimim_get_sogou_cloud_im(keyboard)
" --------------------------------------------
    let keyboard = a:keyboard
    if empty(s:vimim_www_sogou)
    \|| empty(s:www_executable)
    \|| empty(s:pinyin_flag)
    \|| empty(keyboard)
        return []
    endif
    let sogou = 'http://web.pinyin.sogou.com/web_ime/get_ajax/'
    " support apostrophe as delimiter to remove ambiguity.
    " (1) examples: piao => pi'ao 皮袄  xian => xi'an 西安
    " (2) let s:pinyin_flag = "[0-9a-z'.]"
    " (3) add double quotes between keyboard
    " (4) QA: xi'anmeimeidepi'aosuifengpiaoyang 西安妹妹的皮袄随风飘扬
    let input = sogou . '"' . keyboard . '".key'
    let output = 0
    " --------------------------------------------------------------
    " http://web.pinyin.sogou.com/web_ime/get_ajax/woyouyigemeng.key
    " --------------------------------------------------------------
    try
        let output = system(s:www_executable . input)
    catch /.*/
        let msg = 'it looks like sogou has trouble with its cloud?'
        let output = 0
    endtry
    if empty(output)
        return []
    endif
    " --------------------------------------------------------
    " ime_query_res="%E6%88%91";ime_query_key="woyouyigemeng";
    " --------------------------------------------------------
    let first = match(output, '"', 0)
    let second = match(output, '"', 0, 2)
    if first > 0 && second > 0
        let output = strpart(output, first+1, second-first-1)
        let output = substitute(output, '%\(\x\x\)',
                    \ '\=eval(''"\x''.submatch(1).''"'')','g')
    endif
    if empty(output)
        return []
    endif
    " now, let's support Could for gb and big5
    " ----------------------------------------
    if empty(s:localization)
        let msg = "both vim and datafile are UTF-8 encoding"
    else
        let output = s:vimim_i18n_read(output)
    endif
    " ---------------------------
    " output='我有一个梦：13	+
    " ---------------------------
    let menu = []
    for item in split(output, '\t+')
        let item_list = split(item, '：')
        if len(item_list) > 1
            let chinese = item_list[0]
            let english = strpart(keyboard, 0, item_list[1])
            let new_item = english . " " . chinese
            call add(menu, new_item)
        endif
    endfor
    if empty(menu)
        return []
    else
        " ----------------------------
        " ['woyouyigemeng 我有一个梦']
        " ----------------------------
        return menu
    endif
endfunction

" ================================ }}}
" ====  VimIM Do It Youself   ==== {{{
" ====================================

" ----------------------------------
function! s:vimim_initialize_debug()
" ----------------------------------
    let s:vimim_debug_flag = 0
    let debug_datafile = s:path . "vimim.txt"
    let global_datafile = s:vimim_datafile
    " -------------------------------------------
    if !empty(global_datafile)
    \&& filereadable(global_datafile)
        let s:current_datafile = global_datafile
    elseif filereadable(debug_datafile)
        let s:current_datafile = debug_datafile
        let s:vimim_debug_flag = 1
    endif
    if empty(s:vimim_debug_flag)
        return
    endif
    " -------------------------------- debug
    let s:vimim_www_sogou = 13
    let s:vimim_custom_skin = 1
    let s:vimim_tab_for_one_key = 1
    let s:vimim_reverse_pageup_pagedown = 1
    let s:pinyin_flag = 1
    let s:english_flag = 1
    let s:four_corner_flag = 1
    let s:vimim_wildcard_search = 1
    " ---------------------------------------
    let s:vimim_shuangpin_abc = 0
    let s:vimim_unicode_lookup = 0
    let s:vimim_number_as_navigation = 0
    let s:vimim_dummy_shuangpin = 0
    let s:vimim_static_input_style = 0
    " ---------------------------------------
endfunction

" ---------------------------------------------
function! s:vimim_initialize_diy_pinyin_digit()
" ---------------------------------------------
    if s:pinyin_flag > 0 && s:four_corner_flag == 1
        let s:diy_pinyin_4corner = 1
    endif
    if s:pinyin_flag == 2
        return
    endif
    let s:digit_keyboards = {}
    let s:digit_keyboards['a']=1
    let s:digit_keyboards['s']=2
    let s:digit_keyboards['d']=3
    let s:digit_keyboards['f']=4
    let s:digit_keyboards['g']=5
    let s:digit_keyboards['h']=6
    let s:digit_keyboards['j']=7
    let s:digit_keyboards['k']=8
    let s:digit_keyboards['l']=9
    let s:digit_keyboards['o']=0
endfunction

" ----------------------------------------------
function! s:vimim_diy_lines_to_hash(fuzzy_lines)
" ----------------------------------------------
    if empty(a:fuzzy_lines)
        return {}
    endif
    let chinese_to_keyboard_hash = {}
    for line in a:fuzzy_lines
        let words = split(line)
        let menu = get(words,0)
        for word in words
            if word != menu
                let chinese_to_keyboard_hash[word] = menu
            endif
        endfor
    endfor
    return chinese_to_keyboard_hash
endfunction

" -------------------------------------------------------
function! s:vimim_diy_double_menu(hash_0, hash_1, hash_2)
" -------------------------------------------------------
    if empty(a:hash_0)  |" {'马力':'mali','名流':'mingliu'}
    \|| empty(a:hash_1) |" {'马':'7712'}
        return []       |" {'力':'4002'}
    endif
    let values = []
    for key in keys(a:hash_0)
        let char_first = key
        let char_last = key
        if len(key) > 1
            let char_first = strpart(key, 0, s:multibyte)
            let char_last = strpart(key, len(key)-s:multibyte)
        endif
        if empty(a:hash_2)
        \&& has_key(a:hash_1, char_first)           |" ml77
            let menu_vary = a:hash_0[key]           |" mali
            let menu_fix  = a:hash_1[char_first]    |" 7712
            let menu = menu_fix.'　'.menu_vary      |" 7712 mali
            call add(values, menu." ".key)
        elseif has_key(a:hash_1, char_first)
        \&& has_key(a:hash_2, char_last)
            let menu_vary = a:hash_0[key]           |" ml7740
            let menu_fix1 = a:hash_1[char_first]    |" 7712
            let menu_fix2 = a:hash_2[char_last]     |" 4002
            let menu_fix = menu_fix1.'　'.menu_fix2 |" 7712 4002
            let menu = menu_fix.'　'.menu_vary      |" 7712 4002 mali
            call add(values, menu." ".key)
        endif
    endfor
    return sort(values)
endfunction

" --------------------------------------------
function! s:vimim_quick_fuzzy_search(keyboard)
" --------------------------------------------
    let keyboard = a:keyboard
    let results = s:vimim_datafile_range(keyboard)
    if empty(results)
        return []
    endif
    let pattern = "^" .  keyboard
    let has_digit = match(keyboard, '^\d\+')
    if has_digit < 0
        let length = s:diy_pinyin_4corner
        if length == 1 || length == 2
            if length == 2
                let pattern = substitute(keyboard,' ','.*','')
            endif
            call filter(results, 'v:val =~ pattern')
            if s:english_flag > 0
                call filter(results, 'v:val !~ "#$"')
            endif
            let results = s:vimim_filter(results, keyboard, length)
        elseif s:vimim_fuzzy_search > 0
            let results = s:vimim_fuzzy_match(results, keyboard)
        endif
    else
        let msg = 'leave room to play with digits'
        if s:four_corner_flag == 1001
            let msg = 'another choice: top-left & bottom-right'
            let char_first = strpart(keyboard, 0, 1)
            let char_last  = strpart(keyboard, len(keyboard)-1)
            let pattern = '^' .  char_first . "\d\d" . char_last
        elseif s:four_corner_flag == 1289
            let msg = 'for 5 stokes: first two and last two'
            let char_first = strpart(keyboard, 0, 2)
            let char_last  = strpart(keyboard, len(keyboard)-2)
            let pattern = '^' .  char_first . "\d\d" . char_last
        endif
        call filter(results, 'v:val =~ pattern')
    endif
    return s:vimim_i18n_read_list(results)
endfunction

" ------------------------------------------------
function! s:vimim_wildcard_search(keyboard, lines)
" ------------------------------------------------
    if s:chinese_input_mode > 1
        return []
    endif
    let results = []
    let wildcard_pattern = "[*]"
    let wildcard = match(a:keyboard, wildcard_pattern)
    if wildcard > 0
        let star = substitute(a:keyboard,'[*]','.*','g')
        let fuzzy = '^' . star . '\>'
        let results = filter(a:lines, 'v:val =~ fuzzy')
    endif
    return results
endfunction

" ------------------------------------
function! <SID>vimim_vCTRL6(chinglish)
" ------------------------------------
    if empty(a:chinglish)
        return ''
    endif
    if a:chinglish !~ '\p'
        return s:vimim_reverse_lookup(a:chinglish)
    endif
    return s:vimim_translator(a:chinglish)
endfunction

" --------------------------------------
function! s:vimim_diy_keyboard(keyboard)
" --------------------------------------
    let keyboard = a:keyboard
    if empty(s:diy_pinyin_4corner)
    \|| s:chinese_input_mode > 1
    \|| len(keyboard) < 2
    \|| keyboard !~ '[0-9a-z]'
    \|| keyboard =~ '[.]'
        return []
    endif
    " --------------------------------------------
    " do diy couple input method for 2-char phrase
    " --------------------------------------------
    " let mali = "ma7712li4002"          |" [mali,7712,4002]
    " let keyboards = split(mali,'\d\+') |" ['ma', 'li']
    " let mali = "ma7712li4002"
    " let keyboards = split(mali,'\l\+') |" 7712', '4002']
    if keyboard =~ '^\l\+\d\+\l\+\d\+$'
        let keyboards = split(keyboard, '\d\+')
        let alpha_string = join(keyboards)
        let keyboards = split(keyboard, '\l\+')
        call insert(keyboards, alpha_string)
        let s:diy_pinyin_4corner = 2
        return keyboards
    endif
    " -------------------------------------------
    " do diy couple input method (pinyin+4corner)
    " -------------------------------------------
    let lines = s:vimim_load_datafile(0)
    let pattern = '^' . keyboard . '\>'
    let match_start = match(lines, pattern)
    if  match_start > -1
        return []
    endif
    " ----------------------------------
    let alpha = match(keyboard, '\a\+')
    let digit = match(keyboard, '\d\+')
    if digit < 0 || alpha < 0
        return []
    endif
    " ---------------------------------
    let break_into_three = '' |" mljjfo => ml7140 => ['ml','71','40']
    let alpha_string = strpart(keyboard, 0, digit)
    let digit_string = strpart(keyboard, digit)
    " ----------------------------------
    if s:diy_pinyin_4corner == 4
        if alpha > 0
            let alpha_string = strpart(keyboard, alpha)
            let digit_string = strpart(keyboard, 0, alpha)
        elseif len(alpha_string) == 2
            let digit_string = strpart(keyboard, digit, 2)
            let break_into_three = strpart(keyboard, digit+2)
        elseif len(alpha_string) > 1
            \&& len(split(digit_string,'\zs')) < 2
            \&& digit_string !~ '[1-4]' |" if ma3, pinyin tone 1,2,3,4
            return []
        endif
    endif
    let keyboards = [alpha_string, digit_string, break_into_three]
    return keyboards
endfunction

" --------------------------------------
function! s:vimim_diy_results(keyboards)
" --------------------------------------
    let keyboards = a:keyboards
    if empty(s:diy_pinyin_4corner)
    \|| empty(keyboards)
    \|| s:chinese_input_mode > 1
        return []
    endif
    let fuzzy_lines = s:vimim_quick_fuzzy_search(get(keyboards,0))
    let hash_0 = s:vimim_diy_lines_to_hash(fuzzy_lines)
    let fuzzy_lines = s:vimim_quick_fuzzy_search(get(keyboards,1))
    let hash_1 = s:vimim_diy_lines_to_hash(fuzzy_lines)
    let fuzzy_lines = s:vimim_quick_fuzzy_search(get(keyboards,2))
    let hash_2 = s:vimim_diy_lines_to_hash(fuzzy_lines)
    let results = s:vimim_diy_double_menu(hash_0, hash_1, hash_2)
    return results
endfunction

" ================================ }}}
" ====  VimIM Core Engine     ==== {{{
" ====================================

" ------------------------------
function! VimIM(start, keyboard)
" ------------------------------
if a:start

    let current_positions = getpos(".")
    let start_column = current_positions[2]-1
    let start_row = current_positions[1]
    let current_line = getline(start_row)
    let char_before = current_line[start_column-1]
    let char_before_before = current_line[start_column-2]

    if empty(s:chinese_input_mode)
    \&& char_before == '.'
    \&& char_before_before != '.'
        let match_start = match(current_line, '\w\+\s\+\p\+\.$')
        if match_start > -1
            let s:sentence_input = 1
            return match_start
        endif
    endif

    if s:vimim_seamless_english_input > 0
        let seamless_column = s:vimim_get_seamless(current_positions)
        if seamless_column < 0
            let msg = 'no need to set seamless'
        else
            return seamless_column
        endif
    endif

    while start_column > 0 && char_before =~# s:valid_key
        let start_column -= 1
        let char_before = current_line[start_column-1]
    endwhile

    " utf-8 datafile update: get user's previous selection
    " ----------------------------------------------------
    if s:vimim_save_input_history_frequency > 0
    \&& start_row >= s:start_row_before
        let chinese = s:vimim_chinese_before(start_row, start_column)
        if char2nr(chinese) > 127 && len(get(s:keyboards,0)) > 0
            let s:keyboards[1] = chinese
            let s:keyboard_counts += 1
        endif
    endif

    let s:start_row_before = start_row
    let s:start_column_before = start_column
    let s:current_positions = current_positions
    let len = current_positions[2]-1 - start_column
    let s:keyboard_leading_zero = strpart(current_line,start_column,len)

    return start_column

else

    " initialize omni completion function
    " -----------------------------------
    let &pumheight=9
    let s:diy_pinyin_4corner = 0
    let s:insert_without_popup_flag = 0
    let s:pattern_not_found = 1
    let keyboards = []

    " support one-key-correction
    "   OneKey: (d)elete in popup || ChineseMode: <BS>
    " ------------------------------------------------
    if s:trash_code_flag > 0
        let s:trash_code_flag = 0
        return [" "]
    endif

    if s:vimim_debug_flag > 0
        let g:keyboard_s=s:keyboard_leading_zero
        let g:keyboard_a=a:keyboard
    endif

    let keyboard = a:keyboard
    if empty(str2nr(keyboard))
        let msg = 'the input is alphabet only'
    else
        let keyboard = s:keyboard_leading_zero
    endif

    " reset if non-sense keyboard characters
    " --------------------------------------
    if empty(keyboard) || keyboard !~ '\w'
        return
    endif

    if empty(s:chinese_input_mode)
        let @0 = keyboard
    endif

    " hunt real easter egg ... vim<C-\>
    " ---------------------------------
    if keyboard =~# "vim"
        return s:vimim_easter_egg()
    endif

    " support direct internal code (unicode/gb/big5) input
    " ----------------------------------------------------
    if s:vimim_internal_code_input > 0
        let unicodes = s:vimim_internal_code(keyboard)
        if len(unicodes) > 0
            let s:unicode_menu_display_flag = 1
            return s:vimim_popupmenu_list(unicodes)
        endif
    endif

    " magic imode 'i': English number => Chinese number
    " -------------------------------------------------
    if a:keyboard =~# '^i'
        let itoday_inow = s:vimim_date_time(keyboard)
        if len(itoday_inow) > 0
            return itoday_inow
        endif
        let chinese_numbers = s:vimim_chinese_number(keyboard)
        if len(chinese_numbers) > 0
            call map(chinese_numbers, 'keyboard ." ". v:val')
            return s:vimim_popupmenu_list(chinese_numbers)
        endif
    endif

    " support 5 major ShuangPin with various rules
    " --------------------------------------------
    if s:pinyin_flag == 2
        if empty(s:shuangpin_in_quanpin)
            let msg = 'enter shuangpin for the first time'
        elseif match(s:shuangpin_in_quanpin, keyboard) < 0
            let s:shuangpin_flag = 1
        else
            let s:shuangpin_flag = 0
        endif
        if s:shuangpin_flag > 0
            let keyboard2 = s:vimim_shuangpin_transform(keyboard)
            if keyboard2 !=# keyboard
                let s:shuangpin_flag = 0
                let s:sentence_match = 1
                let keyboard = keyboard2
                let s:shuangpin_in_quanpin = keyboard
                let s:keyboard_leading_zero = keyboard
            endif
        endif
    endif

    " VimIM "modeless" whole sentence input: 【我有一個夢】
    " ----------------------------------------------------
    "   English Input Method: 　i have a dream.
    "   PinYin Input Method:  　wo you yige meng.
    "   Wubi Input Method:    　trde ggwh ssqu.
    "   Cangjie Input Method: 　hqi kb m ol ddni.
    " ----------------------------------------------------
    if empty(s:chinese_input_mode)
        if s:sentence_input > 0
        \&& keyboard =~ '\s'
        \&& len(keyboard) > 3
        \&& empty(s:current_datafile_has_dot)
            let s:sentence_input = 0
            let keyboard = substitute(keyboard,'\s','.','g')
        endif
    endif
    let s:sentence_input = 0

    " cloud-dependent whole sentence input:　woyouyigemeng
    " ----------------------------------------------------
    if s:chinese_input_mode < 2
        let keyboard2 = s:vimim_get_cloud_keyboard(keyboard)
        if empty(keyboard2)
            let msg = "who care about cloud?"
        elseif s:no_internet_connection > 0
            let msg = "oops, there is no internet connection."
        else
            let results = s:vimim_get_sogou_cloud_im(keyboard2)
            if empty(len(results))
                let s:sentence_match = 0
                let s:no_internet_connection = 1
            else
                let s:sentence_match = 1
                let s:no_internet_connection = 0
                return s:vimim_popupmenu_list(results)
            endif
        endif
    endif

    " [erbi] the first ,./;' is punctuation
    " -------------------------------------
    if s:erbi_flag > 0
    \&& len(keyboard) == 1
    \&& keyboard =~ "[,./;']"
    \&& has_key(s:punctuations_all, keyboard)
        let value = s:punctuations_all[keyboard]
        return [value]
    endif

    " support wubi non-stop input
    " ---------------------------
    if s:wubi_flag > 0
        let results = s:vimim_wubi(keyboard)
        if len(results) > 0
            let results = s:vimim_pair_list(results)
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " support apostrophe in pinyin datafile
    " -------------------------------------
    let keyboard = s:vimim_apostrophe(keyboard)
    let s:keyboard_leading_zero = keyboard

    " datafile update: modify data in memory based on past usage
    " ----------------------------------------------------------
    if s:vimim_save_input_history_frequency > 0
        let lines = s:vimim_new_order_in_memory(s:keyboards)
        if empty(lines)
            let lines = s:vimim_load_datafile(0)
        else
            call s:vimim_update_datafile(lines)
            call s:vimim_save_input_history(lines)
        endif
    endif

    " now only play with portion of datafile of interest
    " --------------------------------------------------
    let lines = s:vimim_datafile_range(keyboard)

    " first process private data, if existed
    " --------------------------------------
let g:gb=keyboard
    if s:privates_flag == 1
    \&& len(s:privates_datafile) > 0
    \&& keyboard !~ "['.?*]"
        let results = s:vimim_search_vimim_privates(keyboard)
        if len(results) > 0
            let s:private_matches = results
        endif
     endif

    " return nothing if no single datafile
    " ------------------------------------
    if empty(lines) && empty(s:private_matches)
        return
    endif

    " do wildcard search: explicit fuzzy search
    " -----------------------------------------
    if s:vimim_wildcard_search > 0
        let results = s:vimim_wildcard_search(keyboard, lines)
        if len(results) > 0
            let results = s:vimim_pair_list(results)
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " escape literal dot if Array/Phonetic/Erbi
    " -----------------------------------------
    if s:current_datafile_has_dot > 0
        let keyboard = substitute(keyboard,'\.','\\.','g')
    endif

    " now it is time to do regular expression matching
    " ------------------------------------------------
    let pattern = "\\C" . "^" . keyboard
    let match_start = match(lines, pattern)

    " to support auto_spell, if needed
    " --------------------------------
    if match_start < 0
        let match_start = s:vimim_auto_spell(lines, keyboard)
    endif

    " assume it is hex unicode if no match for 4 corner
    " -------------------------------------------------
    if match_start < 0
        let results = s:vimim_hex_unicode(keyboard)
        if len(results) > 0
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " word matching algorithm for Chinese word segmentation
    " -----------------------------------------------------
    if match_start < 0
        let keyboard2 = s:vimim_keyboard_analysis(lines, keyboard)
        if keyboard2 !=# keyboard
            let s:sentence_match = 1
            let keyboard = keyboard2
            let pattern = "\\C" . "^" . keyboard
            let match_start = match(lines, pattern)
        endif
    endif

    " try "do it yourself" couple input method: pinyin+4corner
    " --------------------------------------------------------
    if match_start < 0
        if s:pinyin_flag > 0 && s:four_corner_flag == 1
            let s:diy_pinyin_4corner = 1
            let keyboard2 = s:vimim_diy_keyboard2number(keyboard)
            let keyboards = s:vimim_diy_keyboard(keyboard2)
            let mixtures = s:vimim_diy_results(keyboards)
            if len(mixtures) > 0
                return s:vimim_popupmenu_list(mixtures)
            else
                let s:diy_pinyin_4corner = 0
            endif
        endif
    endif

    " do exact match search on sorted datafile
    " ----------------------------------------
    if match_start > -1
        let results = []
        let has_digit = match(keyboard, '\d\+')
        if has_digit > -1
        \&& s:four_corner_flag > 0
        \&& len(keyboards) > 1
            let results = s:vimim_quick_fuzzy_search(keyboard)
        else |" [normal] do fine tunning exact match
            let s:keyboards[0] = keyboard
            let results = s:vimim_exact_match(lines,keyboard,match_start)
        endif
        let results = s:vimim_pair_list(results)
        return s:vimim_popupmenu_list(results)
    endif

    " do fuzzy search: implicit wildcard search
    " -----------------------------------------
    if match_start < 0 && s:vimim_fuzzy_search > 0
        let results = s:vimim_fuzzy_match(lines, keyboard)
        if len(results) > 0
            let results = s:vimim_pair_list(results)
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " only return matches from private datafile
    " -----------------------------------------
    if match_start < 0 && len(s:private_matches) > 0
        let results = s:vimim_pair_list([])
        return s:vimim_popupmenu_list(results)
    endif

    " support seamless English input for static mode
    " ----------------------------------------------
    if match_start < 0
        if empty(s:chinese_input_mode)
            let msg = 'no seamless for OneKey'
        else
            call <SID>vimim_set_seamless()
        endif
call <SID>vimim_set_seamless()
        return []
    endif

endif
endfunction

" ================================ }}}
" ====  VimIM Core Drive      ==== {{{
" ====================================
" profile start /tmp/vimim.profile

" ------------------------------------
function! s:vimim_initialize_mapping()
" ------------------------------------
    inoremap<silent><expr><Plug>VimimOneKey <SID>vimim_onekey()
    inoremap<silent><expr><Plug>VimimChineseToggle <SID>vimim_toggle()
    " ----------------------------------------------------------
    call s:vimim_one_key_mapping_on()
    " ----------------------------------------------------------
    if !hasmapto('<C-^>', 'v')
        xnoremap<silent> <C-^> y:'>put=<SID>vimim_vCTRL6(@0)<CR>
    endif
    " ----------------------------------------------------------
    if s:vimim_save_new_entry > 0 && !hasmapto('<C-\>', 'v')
        xnoremap<silent> <C-\> :y<CR>:call <SID>vimim_save(@0)<CR>
    endif
    " ----------------------------------------------------------
    if s:vimim_smart_ctrl_h > 0 && !hasmapto('<C-H>', 'i')
        inoremap<silent><C-H> <C-R>=<SID>vimim_smart_ctrl_h()<CR>
    endif
    " ----------------------------------------------------------
    if s:vimim_chinese_input_mode > 0
        imap<silent> <C-^> <Plug>VimimChineseToggle
    endif
    " ----------------------------------------------------------
    if s:vimim_ctrl_space_as_ctrl_6 > 0 && has("gui_running")
        if s:vimim_chinese_input_mode > 0
            imap<silent> <C-Space> <Plug>VimimChineseToggle
        elseif s:vimim_one_key > 0
            imap<silent> <C-Space> <Plug>VimimOneKey
        endif
    endif
    " ----------------------------------------------------------
    if s:vimim_smart_backspace > 0 && s:vimim_tab_for_one_key > 0
        inoremap<silent><BS> <C-R>=<SID>vimim_backspace_trash_all()<CR>
        \<C-R>=<SID>vimim_ctrl_x_ctrl_u_bs()<CR>
    endif
    " ----------------------------------------------------------
endfunction

" ------------------------------------
function! s:vimim_one_key_mapping_on()
" ------------------------------------
    if empty(s:vimim_one_key)
        return
    endif
    if empty(s:vimim_tab_for_one_key)
        imap<silent> <C-\> <Plug>VimimOneKey
    else
        imap<silent> <Tab> <Plug>VimimOneKey
    endif
endfunction

" -------------------------------------
function! s:vimim_one_key_mapping_off()
" -------------------------------------
    if empty(s:vimim_one_key)
        return
    endif
    if empty(s:vimim_tab_for_one_key)
        sil!iunmap <C-\>
    else
        sil!iunmap <Tab>
    endif
endfunction

silent!call s:vimim_initialization()
silent!call s:vimim_initialize_mapping()
" ====================================== }}}
