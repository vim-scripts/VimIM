" ==================================================
"              " VimIM —— Vim 中文输入法 "
" --------------------------------------------------
"  VimIM -- Input Method by Vim, of Vim, for Vimmers
" ==================================================
let $VimIM = "$Date: 2009-12-11 15:40:04 -0800 (Fri, 11 Dec 2009) $"
let $VimIM = "$Revision: 1368 $"

let egg  = ["http://code.google.com/p/vimim/issues/entry           "]
let egg += ["http://code.google.com/p/vimim/downloads/list         "]
let egg += ["http://vimim.googlecode.com/svn/vimim/vimim.html      "]
let egg += ["http://vimim.googlecode.com/svn/vimim/vimim.vim.html  "]
let egg += ["http://vimim.googlecode.com/svn/trunk/plugin/vimim.vim"]
let egg += ["http://vim.sf.net/scripts/script.php?script_id=2506   "]
let egg += ["http://groups.google.com/group/vimim                  "]

let VimIM = " ====  Introduction     ==== {{{"
" ===========================================
"       File: vimim.vim
"     Author: vimim <vimim@googlegroups.com>
"    License: GNU Lesser General Public License
" -----------------------------------------------------------
"    Readme: VimIM is a Vim plugin designed as an independent IM
"            (Input Method) to support the input of multi-byte.
"            VimIM aims to complete the Vim as the greatest editor.
" -----------------------------------------------------------
"  Features: * "Plug & Play"
"            * "Plug & Play": "Cloud Input" without any datafile
"            * "Plug & Play": "Cloud Input" with five ShuangPin
"            * "Plug & Play": "Cloud Input" with WuBi
"            * "Plug & Play": "Pinyin and four_corner" together
"            * "Plug & Play": "Pinyin and five_stroke" together
"            * Support "Cloud Input at will", independent of IM used
"            * Support direct "UNICODE input" using integer or hex
"            * Support direct "GBK input" and "Big5 input"
"            * Support "Pin Yin", "Wu Bi", "Cang Jie", "4Corner", etc
"            * Support "modeless" whole sentence input
"            * Support "Chinese search" using search key '/' or '?'.
"            * Support "fuzzy search" and "wildcard search"
"            * Support popup menu navigation using "vi key" (hjkl)
"            * Support "non-stop-typing" for Wubi, 4Corner & Telegraph
"            * Support "Do It Yourself" input method defined by users
"            * The "OneKey" can input Chinese without mode change.
"            * The "static"  Chinese Input Mode smooths mixture input.
"            * The "dynamic" Chinese Input Mode uses sexy input style.
"            * It is independent of the Operating System.
"            * It is independent of Vim mbyte-XIM/mbyte-IME API.
" -----------------------------------------------------------
"   Install: (1) [optional] download a datafile from code.google.com
"            (2) drop vimim.vim and the datafile to the plugin directory
" -----------------------------------------------------------
" EasterEgg: (in Vim Insert Mode, type 4 chars:) vim<C-\>
" -----------------------------------------------------------
" Usage (1): [in Insert Mode] "to insert/search Chinese ad hoc":
"            # to insert: type keycode and hit <C-\> to trigger
"            # to search: hit '/' or '?' from popup menu
" -----------------------------------------------------------
" Usage (2): [in Insert Mode] "to type Chinese continuously":
"            # hit <C-6> to toggle to Chinese Input Mode:
"            # type any valid keycode and enjoy
" -----------------------------------------------------------

let s:vimims = [VimIM]
" ======================================= }}}
let VimIM = " ====  Instruction      ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" -------------
" "Design Goal"
" -------------
" # Chinese can be input using Vim regardless of encoding
" # Chinese can be input using Vim without local datafile
" # Without negative impact to Vim when VimIM is not used
" # No compromise for high speed and low memory usage
" # Making the best use of Vim for popular input methods
" # Most VimIM options are activated based on input methods
" # All  VimIM options can be explicitly disabled at will

" ---------------
" "VimIM Options"
" ---------------
" Comprehensive usages of all options are from vimim.html

"   VimIM "OneKey", without mode change
"    - use OneKey to insert multi-byte candidates
"    - use OneKey to search multi-byte using "/" or "?"
"    - use OneKey to insert Unicode/GBK/Big5, integer or hex
"    - use OneKey to input Chinese sentence as we do for English
"   The default key is <C-\> (Vim Insert Mode)

"   VimIM "Chinese Input Mode"
"   - [dynamic_mode] show omni popup menu as one types
"   - [static_mode]  <Space> => Chinese  <Enter> => English
"   The default key is <C-6> (Vim Insert Mode)

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

" ======================================= }}}
let VimIM = " ====  Initialization   ==== {{{"
" ===========================================
call add(s:vimims, VimIM)
if exists("b:loaded_vimim") || &cp || v:version<700
    finish
endif
let b:loaded_vimim=1
let s:vimimhelp = egg
let s:path=expand("<sfile>:p:h")."/"
scriptencoding utf-8
" --------------------------------

" --------------------------------
function! s:vimim_initialization()
" --------------------------------
    call s:vimim_initialize_global()
    call s:vimim_initialize_i_setting()
    call s:vimim_initialize_session()
    call s:vimim_initialize_debug()
    " -----------------------------------------
    call s:vimim_initialize_datafile_primary()
    call s:vimim_initialize_datafile_privates()
    " -----------------------------------------
    call s:vimim_initialize_datafile_erbi()
    call s:vimim_initialize_datafile_wubi()
    call s:vimim_initialize_www_sogou()
    " -----------------------------------------
    call s:vimim_initialize_datafile_4corner()
    call s:vimim_initialize_shuangpin()
    call s:vimim_initialize_datafile_pinyin()
    call s:vimim_initialize_diy_pinyin_digit()
    " -----------------------------------------
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
    let   G = []
    call add(G, "g:vimim_apostrophe_in_pinyin")
    call add(G, "g:vimim_auto_spell")
    call add(G, "g:vimim_ctrl_space_as_ctrl_6")
    call add(G, "g:vimim_custom_skin")
    call add(G, "g:vimim_datafile")
    call add(G, "g:vimim_diy_asdfghjklo")
    call add(G, "g:vimim_english_in_datafile")
    call add(G, "g:vimim_english_punctuation")
    call add(G, "g:vimim_fuzzy_search")
    call add(G, "g:vimim_imode_pinyin")
    call add(G, "g:vimim_imode_comma")
    call add(G, "g:vimim_latex_suite")
    call add(G, "g:vimim_privates_txt")
    call add(G, "g:vimim_reverse_pageup_pagedown")
    call add(G, "g:vimim_sexy_input_style")
    call add(G, "g:vimim_shuangpin_dummy")
    call add(G, "g:vimim_shuangpin_abc")
    call add(G, "g:vimim_shuangpin_microsoft")
    call add(G, "g:vimim_shuangpin_nature")
    call add(G, "g:vimim_shuangpin_plusplus")
    call add(G, "g:vimim_shuangpin_purple")
    call add(G, "g:vimim_smart_ctrl_h")
    call add(G, "g:vimim_static_input_style")
    call add(G, "g:vimim_tab_for_one_key")
    call add(G, "g:vimim_unicode_lookup")
    call add(G, "g:vimim_wildcard_search")
    call add(G, "g:vimim_www_sogou")
    call add(G, "g:vimim_insert_without_popup")
    call add(G, "g:vimim_sexy_onekey")
    " -----------------------------------
    let s:global_defaults = []
    let s:global_customized = []
    call s:vimim_set_global_default(G, 0)
    " -----------------------------------
    let G = []
    call add(G, "g:vimim_auto_copy_clipboard")
    call add(G, "g:vimim_chinese_frequency")
    call add(G, "g:vimim_chinese_input_mode")
    call add(G, "g:vimim_chinese_punctuation")
    call add(G, "g:vimim_custom_lcursor_color")
    call add(G, "g:vimim_dynamic_mode_autocmd")
    call add(G, "g:vimim_first_candidate_fix")
    call add(G, "g:vimim_internal_code_input")
    call add(G, "g:vimim_match_dot_after_dot")
    call add(G, "g:vimim_match_word_after_word")
    call add(G, "g:vimim_menu_label")
    call add(G, "g:vimim_one_key")
    call add(G, "g:vimim_punctuation_navigation")
    call add(G, "g:vimim_quick_key")
    call add(G, "g:vimim_save_new_entry")
    call add(G, "g:vimim_seamless_english_input")
    call add(G, "g:vimim_smart_backspace")
    call add(G, "g:vimim_wubi_non_stop")
    " -----------------------------------
    call s:vimim_set_global_default(G, 1)
    " -----------------------------------
endfunction

" ----------------------------------------------------
function! s:vimim_set_global_default(options, default)
" ----------------------------------------------------
    for variable in a:options
        call add(s:global_defaults, variable .'='. a:default)
        let s_variable = substitute(variable,"g:","s:",'')
        if exists(variable)
            call add(s:global_customized, variable .'='. eval(variable))
            exe 'let '. s_variable .'='. variable
            exe 'unlet! ' . variable
        else
            exe 'let '. s_variable . '=' . a:default
        endif
    endfor
endfunction

" ----------------------------------
function! s:vimim_finalize_session()
" ----------------------------------
    if s:vimim_english_in_datafile > 0
        let s:english_flag = 1
    endif
    if s:four_corner_flag > 1
        let s:vimim_fuzzy_search = 0
        let s:vimim_static_input_style = 1
    endif
    if s:vimim_static_input_style < 0
        let s:vimim_static_input_style = 0
    endif
    if empty(s:vimim_www_sogou)
        let s:vimim_www_sogou = 888
    endif
    if s:current_datafile =~# "quote"
        let s:vimim_apostrophe_in_pinyin = 1
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
        let msg = "no user-specified datafile"
    else
        return
    endif
    " --------------------------------------
    let input_methods = []
    call add(input_methods, "pinyin")
    call add(input_methods, "pinyin_quote_sogou")
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
    call add(input_methods, "wubi2pinyin")
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
        elseif datafile =~# 'wubi2pinyin'
            let s:wubi_flag = -1
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

" -------------------------------------------------------
function! s:vimim_expand_character_class(character_class)
" -------------------------------------------------------
    let character_string = ""
    let i = 0
    while i < 256
        let char = nr2char(i)
        if char =~# a:character_class
            let character_string .= char
        endif
        let i += 1
    endwhile
    return character_string
endfunction

" ---------------------------------------
function! s:vimim_initialize_valid_keys()
" ---------------------------------------
    let key = "[0-9a-z',.]"
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
        let key = "[a-z',.;/]"
    elseif input_method =~ 'wu'
        let key = "[a-z',.]"
    elseif input_method =~ 'nature'
        let key = "[a-z',.]"
    elseif input_method =~ 'zhengma'
        let key = "[a-z,.]"
    elseif input_method =~ 'cangjie'
        let key = "[a-z,.]"
    endif
    " -----------------------------------
    if s:four_corner_flag > 1 && empty(s:privates_flag)
        let key = "[0-9]"
    elseif s:erbi_flag > 0
        let s:current_datafile_has_dot = 1
        let key = "[a-z'.,;/]"
    elseif s:wubi_flag > 0
        let key = "[a-z,.]"
    elseif s:pinyin_flag > 0
        let key = "[0-9a-z',.]"
        if s:vimim_shuangpin_microsoft > 0
        \|| s:vimim_shuangpin_purple > 0
            let key = "[0-9a-z',.;]"
        endif
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

" ======================================= }}}
let VimIM = " ====  Easter_Egg       ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ----------------------------
function! s:vimim_egg_vimegg()
" ----------------------------
    let eggs = []
    call add(eggs, "经典　vim")
    call add(eggs, "环境　vimim")
    call add(eggs, "程式　vimimvim")
    call add(eggs, "帮助　vimimhelp")
    call add(eggs, "设置　vimimdefaults")
    return map(eggs,  '"VimIM 彩蛋：" . v:val . "　"')
endfunction

" -------------------------
function! s:vimim_egg_vim()
" -------------------------
    let eggs  = ["vi　  文本編輯器"]
    let eggs += ["vim   最牛文本編輯器"]
    let eggs += ["vim   精力"]
    let eggs += ["vim   生氣"]
    let eggs += ["vimim 中文輸入法"]
    return eggs
endfunction

" ------------------------------
function! s:vimim_egg_vimimvim()
" ------------------------------
    let eggs = s:vimims
    let egg = "strpart(" . 'v:val' . ", 0, 28)"
    call map(eggs, egg)
    return eggs
endfunction

" -----------------------------------
function! s:vimim_egg_vimimdefaults()
" -----------------------------------
    let eggs = s:global_defaults
    let egg = '"VimIM  " . v:val . "　"'
    call map(eggs, egg)
    return eggs
endfunction

" -------------------------------
function! s:vimim_egg_vimimhelp()
" -------------------------------
    let eggs = []
    call add(eggs, "错误报告：" . get(s:vimimhelp,0))
    call add(eggs, "词库下载：" . get(s:vimimhelp,1))
    call add(eggs, "最新主页：" . get(s:vimimhelp,2))
    call add(eggs, "最新程式：" . get(s:vimimhelp,3))
    call add(eggs, "试用版本：" . get(s:vimimhelp,4))
    call add(eggs, "官方网址：" . get(s:vimimhelp,5))
    call add(eggs, "新闻论坛：" . get(s:vimimhelp,6))
" -------------------------------------
    return map(eggs, '"VimIM " .v:val . "　"')
endfunction

" ---------------------------
function! s:vimim_egg_vimim()
" ---------------------------
    let eggs = []
    if has("win32unix")
        let option = "cygwin"
    elseif has("win32")
        let option = "Windows32"
    elseif has("win64")
        let option = "Windows64"
    elseif has("unix")
        let option = "unix"
    elseif has("macunix")
        let option = "macunix"
    endif
    let option .= "_" . &term
    let option = "computer 电脑：" . option
    call add(eggs, option)
" ----------------------------------
    let option = "Vim\t 版本：" . v:version
    call add(eggs, option)
" ----------------------------------
    let option = get(split($VimIM), 1)
    if empty(option)
        let msg = "not a SVN check out, revision number not available"
    else
        let option = "VimIM\t 版本：" . option
        call add(eggs, option)
    endif
" ----------------------------------
    let option = "encoding 编码：" . &encoding
    call add(eggs, option)
" ----------------------------------
    let option = "fencs\t 编码：" . &fencs
    call add(eggs, option)
" ----------------------------------
    let option = s:vimim_static_input_style
    if empty(option)
        let option = 'CTRL-6　经典动态'
    else
        let option = 'CTRL-6　经典静态'
    endif
    let option = "mode\t 风格：" . option
    call add(eggs, option)
" ----------------------------------
    if s:wubi_flag > 0
        let option = "五笔: trdeggwhssqu"
        let option = "im\t 输入：" . option
        call add(eggs, option)
    endif
" ----------------------------------
    if s:pinyin_flag > 0
        let option = "拼音: woyouyigemeng"
        let option = "im\t 输入：" . option
        call add(eggs, option)
        if s:pinyin_flag == 2
            let option = "pinyin\t 双拼："
            if s:vimim_shuangpin_abc > 0
                let option .= "智能ABC: woybyigemg"
            elseif s:vimim_shuangpin_microsoft > 0
                let option .= "微软: hkfgp;jxlisswouhq;yp"
            elseif s:vimim_shuangpin_nature > 0
                let option .= "自然码: hkfgpyjxlisswouhqyyp"
            elseif s:vimim_shuangpin_plusplus > 0
                let option .= "拼音加加: hdftpqjmlisywoigqqyz"
            elseif s:vimim_shuangpin_purple > 0
                let option .= "紫光: hqftp;jdlishwoisq;ym"
            endif
            call add(eggs, option)
        endif
    endif
" ----------------------------------
    let option = s:current_datafile
    if empty(option)
        let msg = "no primary datafile, might play cloud"
    else
        let option = strpart(option, len(s:path))
        let option = "datafile 词库：" . option
        call add(eggs, option)
    endif
" ----------------------------------
    let option = s:privates_flag
    if empty(option)
        let msg = "no private datafile found"
    elseif s:current_datafile !~# "privates"
        let option = "privates.txt"
        let option = "datafile 词库：" . option
        call add(eggs, option)
    endif
" ----------------------------------
    if s:four_corner_flag > 0
        let option = "四角号码: 6021272260021762"
        let option = "datafile 词库：" . option
        call add(eggs, option)
    endif
" ----------------------------------
    let option = "cloud\t 搜狗："
    if s:vimim_www_sogou < 0
        let option .= "晴天无云"
    elseif s:vimim_www_sogou == 888
        let option .= "想云就云"
    elseif option == 1
        let option .= "全云输入"
    else
        let number = s:vimim_www_sogou
        if len(s:quantifiers) > 10
            let numbers = split(number,'\zs')
            if len(numbers) == 2
                let numbers = insert(numbers, 's', 1)
            endif
            let number = s:vimim_get_chinese_number(numbers, 'i')
        endif
        let option .= number . "朵云输入"
    endif
    call add(eggs, option)
" ----------------------------------
    if empty(s:global_customized)
        let msg = "no global variable is set"
    else
        for item in s:global_customized
            let option = "VimIM\t 设置：" . item
            call add(eggs, option)
        endfor
    endif
" ----------------------------------
    call map(eggs, 'v:val . "　"')
    return eggs
endfunction

" ----------------------------------------
function! s:vimim_easter_chicken(keyboard)
" ----------------------------------------
    let egg = a:keyboard
    if egg =~# '\l' && len(egg) < 24
        let msg = "hunt easter egg ... vim<C-\>"
    else
        return []
    endif
    if egg ==# "vim"
        return s:vimim_egg_vim()
    elseif egg ==# "vimim"
        return s:vimim_egg_vimim()
    elseif egg ==# "vimegg"
        return s:vimim_egg_vimegg()
    elseif egg ==# "vimimvim"
        return s:vimim_egg_vimimvim()
    elseif egg ==# "vimimhelp"
        return s:vimim_egg_vimimhelp()
    elseif egg ==# "vimimdefaults"
        return s:vimim_egg_vimimdefaults()
    endif
endfunction

" ======================================= }}}
let VimIM = " ====  Encoding_Unicode ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" -------------------------------------
function! s:vimim_initialize_encoding()
" -------------------------------------
    let s:localization = s:vimim_localization()
    let s:multibyte = 2
    let s:max_ddddd = 64928
    if &encoding == "utf-8"
        let s:multibyte = 3
        let s:max_ddddd = 40869
        if s:chinese_input_mode < 2
        \&& s:four_corner_flag > 0
            let s:four_corner_unicode_flag = 1
        endif
    endif
    if s:localization > 0
        let s:vimim_chinese_frequency = -1
        let warning = 'performance hit if &encoding & datafile differs!'
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

" ======================================= }}}
let VimIM = " ====  Encoding_GBK     ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

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
    let s:unicode_menu_display_flag = 0
    let numbers = []
    let keyboard = a:keyboard
    let last_char = strpart(keyboard,len(keyboard)-1,1)
    " support internal-code popup menu, if ending with 'u'
    " ----------------------------------------------------
    if last_char == s:unicode_prefix
        let &pumheight=16
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

" ======================================= }}}
let VimIM = " ====  Encoding_BIG5    ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

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

" ======================================= }}}
let VimIM = " ====  OneKey           ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ----------------------------
function! s:vimim_tab_onekey()
" ----------------------------
    let onekey = "\t"
    return s:vimim_onekey(onekey)
endfunction

" ----------------------------------
function! <SID>:vimim_space_onekey()
" ----------------------------------
    let onekey = " "
    return s:vimim_onekey(onekey)
endfunction

" ---------------------------------
function! <SID>vimim_start_onekey()
" ---------------------------------
    let s:chinese_input_mode = 0
    sil!call s:vimim_start()
    sil!call s:vimim_hjkl_navigation_on()
    sil!call s:vimim_punctuation_navigation_on()
    " ----------------------------------------------------------
    inoremap<silent><Space> <C-R>=<SID>:vimim_space_onekey()<CR>
                         \<C-R>=g:vimim_reset_after_insert()<CR>
    " ----------------------------------------------------------
    let onekey = "\t"
    " -----------------------------------------------
    " <OneKey> double play
    "   (1) after English (valid keys)    => trigger omni popup
    "   (2) after omni popup window       => disable itself
    " -----------------------------------------------
    if pumvisible()
        call s:vimim_stop()
        let onekey = ""
    else
        let onekey = s:vimim_tab_onekey()
    endif
    sil!exe 'sil!return "' . onekey . '"'
endfunction

" ------------------------------
function! s:vimim_onekey(onekey)
" ------------------------------
    let space = ''
    " -----------------------------------------------
    " <Space> multiple-play in OneKey Mode:
    "   (1) after English (valid keys) => trigger menu
    "   (2) after omni popup menu      => insert Chinese
    "   (3) after English punctuation  => Chinese punctuation
    "   (4) after Chinese              => reset
    "   (5) after Pattern Not Found    => reset
    "   (6) after Space                => reset
    " -----------------------------------------------
    if pumvisible()
        let s:smart_space = 0
        let space = s:vimim_ctrl_y_ctrl_x_ctrl_u()
        sil!exe 'sil!return "' . space . '"'
    endif
    if s:insert_without_popup_flag > 0
        let s:insert_without_popup_flag = 0
        let space = ""
    endif
    " ---------------------------------------------------
    let char_before = getline(".")[col(".")-2]
    let char_before_before = getline(".")[col(".")-3]
    " ---------------------------------------------------
    if (char_before_before !~# '\w' || empty(char_before_before))
    \&& has_key(s:punctuations, char_before)
    \&& s:vimim_sexy_onekey > 0
        let replacement = s:punctuations[char_before]
        let space = "\<BS>" . replacement
        sil!exe 'sil!return "' . space . '"'
    endif
    " ---------------------------------------------------
    if char_before !~# s:valid_key
        call s:vimim_stop()
        return a:onekey
    endif
    " ---------------------------------------------------
    if s:smart_space < 1
        let s:smart_space += 1
        let space = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        sil!exe 'sil!return "' . space . '"'
    endif
    " ---------------------------------------------------
    call s:vimim_stop()
    return a:onekey
    " ---------------------------------------------------
endfunction

" --------------------------
function! s:vimim_label_on()
" --------------------------
    if s:vimim_menu_label < 1
        return
    endif
    for _ in range(0,9)
        sil!exe'inoremap<silent> '._.'
        \  <C-R>=<SID>vimim_label("'._.'")<CR>'
        \.'<C-R>=g:vimim_reset_after_insert()<CR>'
    endfor
endfunction

" ---------------------------
function! <SID>vimim_label(n)
" ---------------------------
    let n = a:n
    let label = a:n
    if pumvisible()
        if n < 1
            let label = '\<C-E>\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        else
            let counts = ""
            if n > 1
                let n -= 1
                let counts = repeat("\<Down>", n)
            endif
            let yes = s:vimim_ctrl_y_ctrl_x_ctrl_u()
            let label = counts . yes
        endif
    else
        let s:seamless_positions = []
    endif
    sil!exe 'sil!return "' . label . '"'
endfunction

" ------------------------------------
function! s:vimim_hjkl_navigation_on()
" ------------------------------------
    if s:chinese_input_mode > 0
        return
    endif
    " hjkl navigation for onekey, always
    let hjkl_list = split('hjklcpedxy', '\zs')
    for _ in hjkl_list
        sil!exe 'inoremap<silent><expr> '._.'
        \ <SID>vimim_hjkl("'._.'")'
    endfor
endfunction

" ----------------------------
function! <SID>vimim_hjkl(key)
" ----------------------------
    let hjkl = a:key
    if pumvisible()
        if a:key == 'e'
            let hjkl  = '\<C-E>'
        elseif a:key == 'x'
            let hjkl  = '\<C-E>'
            let hjkl .= '\<C-R>=g:vimim_reset_after_insert()\<CR>'
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
        elseif a:key == 'p'
            let hjkl  = '\<C-R>=g:vimim_p_paste()\<CR>'
            let hjkl .= '\<C-R>=g:vimim_p_paste()\<CR>'
        elseif a:key == 'd'
            let hjkl  = '\<C-R>=g:vimim_d_one_key_correction()\<CR>'
            let hjkl .= '\<C-R>=g:vimim_d_one_key_correction()\<CR>'
            let hjkl .= '\<C-R>=g:vimim_reset_after_insert()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . hjkl . '"'
endfunction

" --------------------------------------
function! g:vimim_d_one_key_correction()
" --------------------------------------
    let d  = 'd'
    if pumvisible()
        let s:one_key_correction = 1
        let d = '\<C-E>'
    else
        let d = '\<C-X>\<C-U>\<BS>'
    endif
    sil!exe 'sil!return "' . d . '"'
endfunction

" -------------------------
function! g:vimim_p_paste()
" -------------------------
    if pumvisible()
        let p = '\<C-E>'
        sil!exe 'sil!return "' . p . '"'
    else
        let words = copy(s:popupmenu_matched_list)
        let pastes = []
        for item in words
            let pairs = split(item)
            let yin = get(pairs, 0)
            if yin =~ ',,,'
                let yang = get(pairs, 1)
                call add(pastes, yang)
            else
                break
            endif
        endfor
        if len(pastes) == len(words)
            let words = copy(pastes)
        endif
        let line = line(".")
        let current_positions = getpos(".")
        let current_positions[2] = 1
        call setpos(".", current_positions)
        let current_positions[1] = line + len(words) - 1
        call setline(line, words)
        if s:vimim_auto_copy_clipboard>0 && has("gui_running")
            let string_words = ''
            for line in words
                let string_words .= line
                let string_words .= "\n"
            endfor
            let @+ = string_words
        endif
        sil!call s:vimim_stop()
        return "\<Esc>"
    endif
endfunction

" -----------------------------------
function! g:vimim_space_key_for_yes()
" -----------------------------------
    let space = ''
    if pumvisible()
        let space = s:vimim_ctrl_y_ctrl_x_ctrl_u()
    else
        let space = ' '
    endif
    sil!exe 'sil!return "' . space . '"'
endfunction

" ---------------------------------
function! g:vimim_copy_popup_word()
" ---------------------------------
    let word = s:vimim_popup_word(s:start_column_before)
    return s:vimim_clipboard_register(word)
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

" ----------------------------------------
function! s:vimim_clipboard_register(word)
" ----------------------------------------
    if len(a:word) > 0
        if s:vimim_auto_copy_clipboard>0 && has("gui_running")
            let @+ = a:word
        endif
    endif
    sil!call s:vimim_stop()
    return "\<Esc>"
endfunction

" ======================================= }}}
let VimIM = " ====  Chinese_Mode     ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ---------------------------
function! <SID>vimim_toggle()
" ---------------------------
    set nopaste
    if s:chinese_mode_toggle_flag < 1
        sil!call s:vimim_start_chinese_mode()
    else
        sil!call s:vimim_stop_chinese_mode()
    endif
    if s:vimim_dynamic_mode_autocmd > 0 && has("autocmd")
        if !exists("s:dynamic_mode_autocmd_loaded")
            let s:dynamic_mode_autocmd_loaded = 1
            sil!au InsertEnter sil!call s:vimim_start_chinese_mode()
            sil!au InsertLeave sil!call s:vimim_stop_chinese_mode()
            sil!au BufUnload   autocmd! InsertEnter,InsertLeave
        endif
    endif
    sil!return "\<C-O>:redraw\<CR>"
endfunction

" ------------------------------------
function! s:vimim_start_chinese_mode()
" ------------------------------------
    sil!call s:vimim_one_key_mapping_off()
    sil!call s:vimim_start()
    if empty(s:vimim_static_input_style)
        let msg = " ### chinese mode dynamic ### "
        let s:chinese_input_mode = 2
        call <SID>vimim_set_seamless()
        call s:vimim_dynamic_alphabet_trigger()
        " ------------------------------------------------------------
        inoremap<silent><Space> <C-R>=g:vimim_space_dynamic()<CR>
                               \<C-R>=g:vimim_reset_after_insert()<CR>
        " ------------------------------------------------------------
    else
        let msg = " ### chinese mode static ### "
        let s:chinese_input_mode = 1
        sil!call s:vimim_static_alphabet_auto_select()
        " ------------------------------------------------------------
        inoremap<silent><Space> <C-R>=g:vimim_space_static()<CR>
                               \<C-R>=g:vimim_reset_after_insert()<CR>
        " ------------------------------------------------------------
    endif
    " ---------------------------------------------------------
    set cpo&vim
    let &l:iminsert=1
    let s:chinese_mode_toggle_flag = 1
    " ---------------------------------------------------------
    if s:vimim_custom_lcursor_color > 0
        highlight! lCursor guifg=bg guibg=green
    endif
    " ---------------------------------------------------------
    inoremap<silent><expr><C-\> <SID>vimim_toggle_punctuation()
                         return <SID>vimim_toggle_punctuation()
    " ---------------------------------------------------------
endfunction

" -----------------------------------
function! s:vimim_stop_chinese_mode()
" -----------------------------------
    let &cpo=s:saved_cpo
    let &l:iminsert=0
    if s:vimim_custom_lcursor_color > 0
        highlight lCursor NONE
    endif
    " ------------------------------
    if s:vimim_auto_copy_clipboard>0 && has("gui_running")
        sil!exe ':%y +'
    endif
    " ------------------------------
    if exists('*Fixcp')
        sil!call FixAcp()
    endif
    " ------------------------------
    sil!call s:vimim_stop()
    sil!call s:vimim_one_key_mapping_on()
endfunction

" --------------------------------------
function! <SID>vimim_pumvisible_ctrl_e()
" --------------------------------------
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

" -------------------------------
function! g:vimim_space_dynamic()
" -------------------------------
    let space = ' '
    if pumvisible()
        let space = "\<C-Y>"
    else
        if s:wubi_flag < 0
            let s:vimim_www_sogou = 1
            let space = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . space . '"'
endfunction

" ------------------------------
function! g:vimim_space_static()
" ------------------------------
    let space = ' '
    if pumvisible()
        let space = s:vimim_ctrl_y_ctrl_x_ctrl_u()
    else
        let char_before = getline(".")[col(".")-2]
        if char_before =~# s:valid_key
            let space = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . space . '"'
endfunction

" ---------------------------------------------
function! s:vimim_static_alphabet_auto_select()
" ---------------------------------------------
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
    " -----------------------------------------
    for _ in az_char_list
        sil!exe 'inoremap <silent> ' ._. '
        \ <C-R>=pumvisible()?"\<lt>C-Y>":""<CR>'. _
        \ . '<C-R>=<SID>alphabet_reset_after_insert()<CR>'
    endfor
endfunction

" ------------------------------------------
function! s:vimim_dynamic_alphabet_trigger()
" ------------------------------------------
    if s:chinese_input_mode != 2
        return
    endif
    " --------------------------------------
    for char in s:valid_keys
        if char !~# "[0-9,.']"
            sil!exe 'inoremap<silent> ' . char . '
            \ <C-R>=<SID>vimim_pumvisible_ctrl_e()<CR>'. char .
            \'<C-R>=g:vimim_ctrl_x_ctrl_u()<CR>'
        endif
    endfor
endfunction

" -----------------------------------
function! g:vimim_pattern_not_found()
" -----------------------------------
    let space = ''
    if pumvisible()
        let msg = "click twice, space is space"
    else
        if s:pattern_not_found > 0
            let s:pattern_not_found = 0
            let space = ' '
        endif
    endif
    sil!exe 'sil!return "' . space . '"'
endfunction

" ======================================= }}}
let VimIM = " ====  Seamless         ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

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

" ---------------------------------
function! <SID>vimim_set_seamless()
" ---------------------------------
    if s:vimim_seamless_english_input > 0
        let s:seamless_positions = getpos(".")
    endif
    let s:smart_space = 0
    let s:keyboard_leading_zero = 0
    return ""
endfunction

" ======================================= }}}
let VimIM = " ====  Punctuations     ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

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
        let s:punctuations['`']='“”'
    endif
    let s:punctuations_all = copy(s:punctuations)
    for char in s:valid_keys
        if has_key(s:punctuations, char) && char !~# "[,.']"
            unlet s:punctuations[char]
        endif
    endfor
endfunction

" ---------------------------------------
function! <SID>vimim_toggle_punctuation()
" ---------------------------------------
    if s:vimim_chinese_punctuation < 0
        return ""
    endif
    let s:chinese_punctuation = (s:chinese_punctuation+1)%2
    sil!call s:vimim_punctuation_on()
    return ""
endfunction

" --------------------------------
function! s:vimim_punctuation_on()
" --------------------------------
    let punctuations = s:punctuations
    if s:chinese_input_mode > 0
        unlet punctuations['\']
        unlet punctuations['"']
        unlet punctuations["'"]
    endif
    if s:erbi_flag > 0
	unlet punctuations[',']
	unlet punctuations['.']
	unlet punctuations['/']
	unlet punctuations[';']
	unlet punctuations["'"]
    endif
    for _ in keys(punctuations)
        sil!exe 'inoremap <silent> '._.'
        \    <C-R>=<SID>vimim_punctuation_mapping("'._.'")<CR>'
        \ . '<C-R>=<SID>alphabet_reset_after_insert()<CR>'
    endfor
    " --------------------------------------
    call s:vimim_punctuation_navigation_on()
    " --------------------------------------
endfunction

" -------------------------------------------
function! <SID>vimim_punctuation_mapping(key)
" -------------------------------------------
    let value = s:vimim_get_chinese_punctuation(a:key)
    if pumvisible()
        let value = "\<C-Y>" . value
    endif
    sil!exe 'sil!return "' . value . '"'
endfunction

" -------------------------------------------
function! s:vimim_punctuation_navigation_on()
" -------------------------------------------
    if s:vimim_punctuation_navigation < 0
        return
    endif
    let hjkl_list = split('.,=-;[]','\zs')
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
            let hjkl .= '\<C-R>=g:vimim_reset_after_insert()\<CR>'
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
        let char_before = getline(".")[col(".")-2]
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

" ======================================= }}}
let VimIM = " ====  Chinese_Number   ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ----------------------------------------
function! s:vimim_initialize_quantifiers()
" ----------------------------------------
    let s:quantifiers = {}
    if s:vimim_imode_comma < 1
    \&& s:vimim_imode_pinyin < 1
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
    if a:keyboard ==# ',today'
        " 2009 year February 11 day Wednesday
        let time = strftime("%Y year %B %d day %A")
    elseif a:keyboard ==# ',now'
        " Sunday AM 8 hour 8 minute 8 second
        let time=strftime("%A %p %I hour %M minute %S second")
    endif
    if empty(time)
        return []
    endif
    let time = s:vimim_translator(time)
    let keyboards = split(time, '\ze')
    let time = s:vimim_get_chinese_number(keyboards, 'i')
    if len(time) > 0
        let s:insert_without_popup_flag = 1
    endif
    return [time]
endfunction

" ----------------------------------------------
function! s:vimim_imode_number(keyboard, prefix)
" ----------------------------------------------
    if s:chinese_input_mode > 1
        return []
    endif
    let keyboard = a:keyboard
    if a:prefix ==# ','
        let keyboard = substitute(keyboard,',','i','g')
    endif
    " ------------------------------------
    let ii = strpart(keyboard,0,2)
    if ii ==# 'ii'
        let keyboard = 'I' . strpart(keyboard,2)
    endif
    let ii_keyboard = keyboard
    let keyboard = strpart(keyboard,1)
    " ------------------------------------
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
    if len(numbers) > 0
        call map(numbers, 'a:keyboard ." ". v:val')
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

" ======================================= }}}
let VimIM = " ====  English2Chinese  ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

let s:translators = {}
" ------------------------------------------
function! s:translators.translate(line) dict
" ------------------------------------------
    return join(map(split(a:line),'get(self.dict,tolower(v:val),v:val)'))
endfunction

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

" ======================================= }}}
let VimIM = " ====  Chinese2Pinyin   ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" --------------------------------
function! g:vimim_chinese2pinyin()
" --------------------------------
    " convert chinese to pinyin using pinyin datafile
    " :call g:vimim_chinese2pinyin()
    " --------------------------------------
    " horse 马 馬儿 马馬儿   <= garbage in
    " horse ma maer mamaer   => garbage out
    " --------------------------------------
    let line = 0
    let space = ' '
    while line < line("$")
        let line += 1
        let current_line = getline(line)
        let current_line_list = split(current_line)
        let new_line = get(current_line_list, 0)
        for item in current_line_list
            let chinese = substitute(item,'\s\+\|\w\|\n','','g')
            let chinese_characters = split(chinese,'\zs')
            let glyph = join(chinese_characters, ' ')
            let cache_pinyin = s:vimim_build_reverse_cache(glyph, 1)
            let items = s:vimim_make_one_entry(cache_pinyin, chinese)
            let result = join(items,'')
            let new_line .= space . result
        endfor
        call setline(line, new_line)
    endwhile
endfunction

" ---------------------------------------
function! s:vimim_reverse_lookup(chinese)
" ---------------------------------------
    let chinese = substitute(a:chinese,'\s\+\|\w\|\n','','g')
    let chinese_characters = split(chinese,'\zs')
    let glyph = join(chinese_characters, '   ')
    " ------------------------------------------------
    let result_unicode = ''
    let items = []
    if s:vimim_unicode_lookup > 0
        for char in chinese_characters
            let unicode = printf('%04x',char2nr(char))
            call add(items, unicode)
        endfor
        let unicode = join(items, ' ')
        let result_unicode = unicode. "\n" . glyph
    endif
    " ------------------------------------------------
    let result_4corner = ''
    if s:four_corner_flag > 0
        let cache_4corner = s:vimim_build_4corner_cache(chinese)
        let items = s:vimim_make_one_entry(cache_4corner, chinese)
        let result_4corner = join(items,' ') . "\n" . glyph
    endif
    " ------------------------------------------------
    let cache_pinyin = s:vimim_build_reverse_cache(chinese, 0)
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

" -----------------------------------------------------
function! s:vimim_build_reverse_cache(chinese, one2one)
" -----------------------------------------------------
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
                if empty(a:one2one)
                    let cache[char] = menu .'|'. cache[char]
                endif
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

" ======================================= }}}
let VimIM = " ====  Smart_Keys       ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

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
        sil!call s:vimim_stop()
        let slash = "\<End>\<C-U>\<Esc>"
    endif
    sil!exe 'sil!return "' . slash . '"'
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
    sil!call s:vimim_stop()
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
        " -----------------------------------------------
        " <Enter> double play in Chinese Mode:
        "   (1) after English (valid keys)    => Seamless
        "   (2) after Chinese or double Enter => Enter
        " -----------------------------------------------
        if char_before =~# "[,.']"
            let s:smart_enter = 0
        elseif char_before =~# s:valid_key
            let s:smart_enter += 1
        endif
        " -----------------------------------------------
        " <Enter> triple play in OneKey Mode:
        "   (1) after English (valid keys)    => Seamless
        "   (2) after Chinese or double Enter => Enter
        "   (3) after English punctuation     => Space
        " -----------------------------------------------
        if empty(s:chinese_input_mode)
            if has_key(s:punctuations, char_before)
                let s:smart_enter += 1
                let key = ' '
            endif
            if char_before =~ ' '
                let key = "\<CR>"
            endif
        endif
        " -----------------------------------------------
        if s:smart_enter == 1
            let msg = "do seamless for the first time <Enter>"
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
    " support intelligent sentence match for wozuixihuandeliulanqi.
    " if not found from maximum-match, do <C-H>, try minimum match
    let key = '\<BS>'
    call s:reset_after_insert()
    if pumvisible()
        let key = '\<C-E>\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        let s:vimim_smart_ctrl_h += 1
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" -------------------------------------
function! <SID>vimim_ctrl_x_ctrl_u_bs()
" -------------------------------------
    let key = '\<BS>'
    call s:reset_after_insert()
    if empty(s:vimim_smart_backspace)
        let msg = "this is dummy backspace"
    elseif s:vimim_smart_backspace == 1
        if empty(s:chinese_input_mode)
            call s:vimim_stop()
        endif
        if s:chinese_input_mode > 1
            let key .= '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        endif
    elseif s:vimim_smart_backspace == 2
        let char_before = getline(".")[col(".")-2]
        if char_before =~# s:valid_key
            let s:one_key_correction = 1
            let key = '\<C-X>\<C-U>\<BS>'
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ======================================= }}}
let VimIM = " ====  Omni_Popup_Menu  ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

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
    let maximum_list = 100
    if len(matched_list) > maximum_list
        let matched_list = matched_list[0 : maximum_list]
    endif
    " ----------------------
    for line in matched_list
    " ----------------------
        if len(line) < 2
            continue
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

" ---------------------------------------------
function! s:vimim_pageup_pagedown(matched_list)
" ---------------------------------------------
    let matched_list = a:matched_list
    let page = &pumheight-1
    if page < 1
        let page = 8
    endif
    if empty(s:pageup_pagedown) || len(matched_list) < page+2
        return matched_list
    endif
    let shift = s:pageup_pagedown * page
    let length = len(matched_list)
    if length > page
        if shift >= length || shift*(-1) >= length
            let s:pageup_pagedown = ''
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
    let s:popupmenu_matched_list = matched_list
    if s:menu_reverse > 0
        let matched_list = reverse(matched_list)
    endif
    let menu = 0
    let label = 1
    let matched_list = s:vimim_pageup_pagedown(matched_list)
    let popupmenu_list = []
    let keyboard = s:keyboard_leading_zero
    let first_candidate = get(split(get(matched_list,0)),0)
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
        if chinese =~ '#'
            continue
        endif
        " -------------------------------------------------
        if s:vimim_custom_skin < 2
            let extra_text = menu
            if s:four_corner_unicode_flag > 0
            \&& empty(match(extra_text, '^\d\{4}$'))
                let unicode = printf('u%04x', char2nr(chinese))
                let extra_text = menu.'　'.unicode
            endif
            if extra_text =~# '[.,]'
                let extra_text = ''
            endif
            let complete_items["menu"] = extra_text
        endif
        " -------------------------------------------------
        if s:vimim_menu_label > 0
            let abbr = printf('%2s',label) . "\t" . chinese
            let complete_items["abbr"] = abbr
        endif
        " -------------------------------------------------
        let tail = ''
        let tail_default = strpart(keyboard, len(menu))
        if empty(s:menu_from_cloud_flag)
            let tail_default = strpart(keyboard, len(first_candidate))
        endif
        " -------------------------------------------------
        if keyboard =~ '[.]'
            let dot = stridx(keyboard, '.')
            let tail = strpart(keyboard, dot+1)
        " -------------------------------------------------
        else
            let tail = tail_default
        endif
        " -------------------------------------------------
        if keyboard =~? 'vim'
            let tail = ''
        endif
        " -------------------------------------------------
        if tail =~ '\w'
            let chinese .=  tail
        endif
        let complete_items["word"] = chinese
        let complete_items["dup"] = 1
        let label += 1
        call add(popupmenu_list, complete_items)
    endfor
    " ------------------------------------------------------
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
    let match_start = a:start
    let match_end = match_start
    let patterns = '^\(' . keyboard. '\)\@!'
    let result = match(a:lines, patterns, match_start)-1
    let words_limit = 128
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
    if s:vimim_shuangpin_dummy(keyboard) > 0
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
        if s:vimim_shuangpin_dummy(a:keyboard) > 0
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

" -----------------------------------------
function! s:vimim_shuangpin_dummy(keyboard)
" -----------------------------------------
    if empty(s:vimim_shuangpin_dummy)
    \|| s:pinyin_flag != 1
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

" ======================================= }}}
let VimIM = " ====  Sentence_Match   ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" --------------------------------------------------
function! s:vimim_keyboard_analysis(lines, keyboard)
" --------------------------------------------------
    let keyboard = a:keyboard
    if empty(a:lines)
    \|| s:chinese_input_mode > 1
    \|| s:current_datafile_has_dot > 0
    \|| s:privates_flag > 1
    \|| len(s:private_matches) > 0
    \|| len(a:keyboard) < 2
        return keyboard
    endif
    if keyboard =~ '^\l\+\d\+\l\+\d\+$'
        let msg = "[diy] ma7712li4002 => [mali,7712,4002]"
        return keyboard
    endif
    let keyboard2 = s:vimim_diy_keyboard2number(keyboard)
        if keyboard2 !=# keyboard
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
    \|| len(a:keyboard) < 4
        return []
    endif
    let keyboard = a:keyboard
    let pattern = '^' . keyboard . '\>'
    let match_start = match(a:lines, pattern)
    if match_start < 0
        let msg = "now try backward maximum match"
    else
        return []
    endif
    " --------------------------------------------
    let min = 1
    let max = len(keyboard)
    let block = ''
    let last_part = ''
    " --------------------------------------------
    while max > 2 && min < len(keyboard)
        let msg = "jiandaolaoshiwenshenghao.<OneKey><Space>..."
        let max -= 1
        let position = max
        if s:vimim_smart_ctrl_h > 1
            let msg = "wozuixihuandeliulanqi.<OneKey><Space>...<Ctrl-H>"
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
    " --------------------------------------------
    if s:vimim_smart_ctrl_h > 1
        let s:vimim_smart_ctrl_h = 1
    endif
    let blocks = []
    if !empty(block)
    \&& !empty(last_part)
    \&& block.last_part ==# keyboard
        call add(blocks, block)
        call add(blocks, last_part)
    endif
    return blocks
endfunction

" --------------------------------------
function! s:vimim_ctrl_y_ctrl_x_ctrl_u()
" --------------------------------------
    let key = "\<C-Y>"
    if s:chinese_input_mode > 1
        return key
    endif
    let key .= '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
    if empty(s:vimim_sexy_onekey)
    \&& empty(s:chinese_input_mode)
        let key = "\<C-Y>"
        call s:vimim_stop()
    endif
    return key
endfunction

" -------------------------------
function! g:vimim_ctrl_x_ctrl_u()
" -------------------------------
    let key = ''
    let char_before = getline(".")[col(".")-2]
    if char_before =~# s:valid_key
        let key = '\<C-X>\<C-U>'
        if s:chinese_input_mode > 1
            call s:alphabet_reset_after_insert()
        endif
        if empty(s:vimim_sexy_input_style)
            let key .= '\<C-R>=g:vimim_menu_select()\<CR>'
        endif
    else
        call s:reset_after_insert()
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" -----------------------------
function! g:vimim_menu_select()
" -----------------------------
    let select_not_insert = ''
    if pumvisible()
        let select_not_insert = '\<C-P>\<Down>'
        if s:vimim_insert_without_popup > 0
        \&& s:insert_without_popup_flag > 0
            let s:insert_without_popup_flag = 0
            let select_not_insert = '\<C-Y>'
        endif
    endif
    sil!exe 'sil!return "' . select_not_insert . '"'
endfunction

" ======================================= }}}
let VimIM = " ====  Datafile_Update  ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

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
    let frequency = s:vimim_chinese_frequency
    if frequency > 1
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

" ======================================= }}}
let VimIM = " ====  Private_Data     ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

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

" ======================================= }}}
let VimIM = " ====  VimIM_4Corner    ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

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
        let msg = "we want to play with four corner"
    else
        let datafile = s:path . "vimim.12345.txt"
        if filereadable(datafile)
            let msg = "we want to play with 5 strokes"
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
    if empty(s:vimim_diy_asdfghjklo)
    \|| empty(s:digit_keyboards)
    \|| s:chinese_input_mode > 1
    \|| len(a:keyboard) < 5
    \|| len(a:keyboard) > 6
        return keyboard
    endif
    if a:keyboard =~ '\d'
        return keyboard
    else
        let s:diy_pinyin_4corner = 4
    endif
    let alphabet_length = 0
    if len(keyboard) == 5
        let msg = "asofo"
        let alphabet_length = 1
    elseif len(keyboard) == 6
        let msg = "zaskso"
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
        let first_digit = 0
        let line_index = match(lines, '^\d')
        if line_index > -1
            let first_digit = line_index
        endif
        let first_alpha = len(lines)-1
        let first_alpha = 0
        let line_index = match(lines, '^\D', first_digit)
        if line_index > -1
            let first_alpha = line_index
        endif
        if first_digit < first_alpha
            let s:four_corner_lines = lines[first_digit : first_alpha-1]
        else
            return {}
        endif
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

" ======================================= }}}
let VimIM = " ====  VimIM_Pinyin     ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" --------------------------------------------
function! s:vimim_initialize_datafile_pinyin()
" --------------------------------------------
    if empty(s:pinyin_flag)
        return
    endif
    " -----------------------------------
    if s:pinyin_flag != 2
        let s:vimim_fuzzy_search = 1
    endif
    " -----------------------------------
    if empty(s:vimim_imode_pinyin)
        let s:vimim_imode_pinyin = 1
    endif
endfunction

" ------------------------------------
function! s:vimim_apostrophe(keyboard)
" ------------------------------------
    let keyboard = a:keyboard
    if s:vimim_apostrophe_in_pinyin < 1
        let keyboard = substitute(keyboard,"'",'','g')
    else
        let msg = "apostrophe is in the datafile"
    endif
    return keyboard
endfunction

" -------------------------------------------
function! s:vimim_auto_spell(lines, keyboard)
" -------------------------------------------
    if empty(s:vimim_auto_spell)
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
    "    tign => ting
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

" ======================================= }}}
let VimIM = " ====  VimIM_Shuangpin  ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" --------------------------------------
function! s:vimim_initialize_shuangpin()
" --------------------------------------
    if empty(s:vimim_shuangpin_abc)
      \&& empty(s:vimim_shuangpin_microsoft)
      \&& empty(s:vimim_shuangpin_nature)
      \&& empty(s:vimim_shuangpin_plusplus)
      \&& empty(s:vimim_shuangpin_purple)
        return
    endif
    let s:pinyin_flag = 2
    let s:vimim_imode_pinyin = -1
    let rules = s:vimim_shuangpin_generic()
    if s:vimim_shuangpin_abc > 0
        let rules = s:vimim_shuangpin_abc(rules)
        let s:vimim_imode_pinyin = 1
    elseif s:vimim_shuangpin_microsoft > 0
        let rules = s:vimim_shuangpin_microsoft(rules)
    elseif s:vimim_shuangpin_nature > 0
        let rules = s:vimim_shuangpin_nature(rules)
    elseif s:vimim_shuangpin_plusplus > 0
        let rules = s:vimim_shuangpin_plusplus(rules)
    elseif s:vimim_shuangpin_purple > 0
        let rules = s:vimim_shuangpin_purple(rules)
    endif
    let s:shuangpin_table = s:vimim_create_shuangpin_table(rules)
endfunction

" ------------------------------------------------
function! s:vimim_quanpin_from_shuangpin(keyboard)
" ------------------------------------------------
    let keyboard = a:keyboard
    if s:pinyin_flag != 2
        return keyboard
    endif
    if empty(s:keyboard_shuangpin)
        let msg = "it is here to resume shuangpin"
    else
        return keyboard
    endif
    let keyboard2 = s:vimim_shuangpin_transform(keyboard)
    if keyboard2 ==# keyboard
        let msg = "no point to do transform"
    else
        let s:keyboard_shuangpin = keyboard
        let s:keyboard_leading_zero = keyboard2
        let keyboard = keyboard2
    endif
    return keyboard
endfunction

" -----------------------------------------
function! s:vimim_shuangpin_transform(keyb)
" -----------------------------------------
    if empty(s:keyboard_shuangpin)
        let msg = "start the magic shuangpin transform"
    else
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
                let output .= "'" . s:shuangpin_table[sp1]
            else
                " invalid shuangpin code are preserved
                let output .= sp1
            endif
            let ptr += strlen(sp1)
        endif
    endwhile
    if output[0] == "'"
        return output[1:]
    else
        return output
    endif
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
    " vtpc => shuang pin => double pinyin
    " -----------------------------------
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

" ======================================= }}}
let VimIM = " ====  VimIM_Erbi       ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ------------------------------------------
function! s:vimim_initialize_datafile_erbi()
" ------------------------------------------
    if s:erbi_flag > 0
        let s:vimim_punctuation_navigation = -1
        let s:search_key_slash = -1
        let s:wubi_flag = 1
    endif
endfunction

" ======================================= }}}
let VimIM = " ====  VimIM_Wubi       ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ------------------------------------------
function! s:vimim_initialize_datafile_wubi()
" ------------------------------------------
    if s:wubi_flag > 0
        if s:vimim_static_input_style > 0
            let s:vimim_wubi_non_stop = 0
        endif
    elseif s:wubi_flag < 0
        let s:vimim_english_punctuation = 1
        let s:vimim_chinese_punctuation = -1
        let s:vimim_static_input_style = -1
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
    let keyboards = split(a:keyboard,'\(.\{4}\)\zs')
    return keyboards
endfunction

" ======================================= }}}
let VimIM = " ====  VimIM_Cloud      ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ---------------------------------------
function! s:vimim_plug_n_play_www_sogou()
" ---------------------------------------
    if empty(s:current_datafile) || s:privates_flag == 2
        if (executable('wget') || executable('curl'))
            if empty(s:vimim_www_sogou)
                let s:vimim_www_sogou = 1
                return
            endif
        endif
    endif
    " Windows 'plug and play' (throw wget.exe to plugin directory)
    if has("win32") || has("win32unix")
        let wget = s:path . "wget.exe"
        if executable(wget)
            if empty(s:vimim_www_sogou)
                let s:vimim_www_sogou = 1
            endif
            let s:www_executable = wget
        endif
    endif
endfunction

" --------------------------------------
function! s:vimim_initialize_www_sogou()
" --------------------------------------
    call s:vimim_plug_n_play_www_sogou()
    if !exists('*system')
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
    " step 3: test if native Windows dll can be used
    " ----------------------------------------------
    if has("win32")
        let wget = "rundll32.exe url.dll,FileProtocolHandler "
        let www_executable = wget
        let vimim_www_sogou = 1
    endif
    " -------------------------------------
    if empty(s:www_executable)
        let s:vimim_www_sogou = 0
    endif
endfunction

" ------------------------------------
function! s:vimim_magic_tail(keyboard)
" ------------------------------------
    let keyboard = a:keyboard
    if s:chinese_input_mode > 0
        return 0
    endif
    if len(keyboard) < 2
        return 0
    endif
    if keyboard =~ '\d\d\d\d'
        let msg = "We play 4 corner by ourselves without Cloud."
        return 0
    endif
    let magic_tail = strpart(keyboard, len(keyboard)-1)
    if magic_tail ==# ','
        " -----------------------------------------------
        " <comma> double play in OneKey Mode:
        "   (1) after English (valid keys)    => all-cloud at will
        "   (2) before number                 => magic imode
        " -----------------------------------------------
        let s:no_internet_connection = -1
    elseif magic_tail ==# '.'
        " -----------------------------------------------
        " <dot> double play in OneKey Mode:
        "   (1) after English (valid keys)    => non-cloud at will
        "   (2) vimim_keyboard_dot_by_dot     => sentence match
        " -----------------------------------------------
        let s:no_internet_connection = 2
    else
        return 0
    endif
    let keyboard = strpart(keyboard, 0, len(keyboard)-1)
    let magic_tail = strpart(keyboard, len(keyboard)-1)
    if magic_tail !~# "[0-9a-z]"
        return 0
    endif
    let s:keyboard_leading_zero = keyboard
    return keyboard
endfunction

" --------------------------------------------------
function! s:vimim_to_cloud_or_not_to_cloud(keyboard)
" --------------------------------------------------
    let do_cloud = 1
    if s:no_internet_connection > 1
        let msg = "oops, there is no internet connection."
        return 0
    elseif s:no_internet_connection < 0
        return 1
    endif
    if empty(s:chinese_input_mode)
    \&& a:keyboard =~ '[.]'
        return 0
    endif
    if s:vimim_www_sogou < 1
        return 0
    endif
    let cloud_length = len(a:keyboard)
    if s:pinyin_flag == 2
        let cloud_length = len(s:keyboard_shuangpin)
    endif
    if cloud_length < s:vimim_www_sogou
        let do_cloud = 0
    endif
    return do_cloud
endfunction

" --------------------------------------------
function! s:vimim_get_sogou_cloud_im(keyboard)
" --------------------------------------------
    let keyboard = a:keyboard
    if s:vimim_www_sogou < 1
    \|| empty(s:www_executable)
    \|| empty(keyboard)
        return []
    endif
    let sogou = 'http://web.pinyin.sogou.com/web_ime/get_ajax/'
    " support apostrophe as delimiter to remove ambiguity
    " (1) examples: piao => pi'ao 皮袄  xian => xi'an 西安
    " (2) let s:pinyin_flag = "[0-9a-z'.]"
    " (3) add double quotes between keyboard
    " (4) test: xi'anmeimeidepi'aosuifengpiaoyang
    let input = sogou . '"' . keyboard . '".key'
    let output = 0
    " --------------------------------------------------------------
    " http://web.pinyin.sogou.com/web_ime/get_ajax/woyouyigemeng.key
    " --------------------------------------------------------------
    try
        let output = system(s:www_executable . input)
    catch /.*/
        let msg = "it looks like sogou has trouble with its cloud?"
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
    " ----------------------------
    " ['woyouyigemeng 我有一个梦']
    " ----------------------------
    if s:vimim_debug_flag > 0
        let g:cloud_results=menu
    endif
    return menu
endfunction

" ======================================= }}}
let VimIM = " ====  VimIM_DIY        ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

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
    let s:vimim_shuangpin_abc=0
    let s:vimim_static_input_style=-1
    let s:vimim_www_sogou=1
    " --------------------------------
    let s:vimim_sexy_onekey=1
    let s:vimim_imode_comma=1
    let s:vimim_imode_pinyin=-1
    let s:vimim_custom_skin=1
    let s:vimim_tab_for_one_key=1
    let s:pinyin_flag=1
    let s:vimim_english_in_datafile=1
    let s:four_corner_flag=1
    let s:vimim_diy_asdfghjklo=1
    let s:vimim_wildcard_search=1
    let s:vimim_reverse_pageup_pagedown=1
    " --------------------------------
    let s:vimim_smart_backspace=1
    let s:vimim_smart_ctrl_h=1
    " ---------------------------------------
    let s:vimim_english_punctuation=0
    let s:vimim_chinese_punctuation=1
    let s:vimim_unicode_lookup=0
    let s:vimim_shuangpin_dummy=0
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
        let msg = "leave room to play with digits"
        if s:four_corner_flag == 1001
            let msg = "another choice: top-left & bottom-right"
            let char_first = strpart(keyboard, 0, 1)
            let char_last  = strpart(keyboard, len(keyboard)-1)
            let pattern = '^' .  char_first . "\d\d" . char_last
        elseif s:four_corner_flag == 1289
            let msg = "for 5 stokes: first two and last two"
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
    \|| keyboard !~ "[0-9a-z]"
    \|| keyboard =~ "[.]"
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

" ======================================= }}}
let VimIM = " ====  Core_Workflow    ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" --------------------------------------
function! s:vimim_initialize_i_setting()
" --------------------------------------
    let s:saved_cpo=&cpo
    let s:saved_lazyredraw=&lazyredraw
    let s:saved_hlsearch=&hlsearch
    let s:saved_pumheight=&pumheight
    let s:completeopt=&completeopt
    let s:completefunc=&completefunc
endfunction

" ------------------------------
function! s:vimim_i_setting_on()
" ------------------------------
    let &l:completefunc='VimIM'
    let &l:completeopt='menuone'
    let &pumheight=9
    set nolazyredraw
    set hlsearch
endfunction

" -------------------------------
function! s:vimim_i_setting_off()
" -------------------------------
    let &lazyredraw=s:saved_lazyredraw
    let &hlsearch=s:saved_hlsearch
    let &pumheight=s:saved_pumheight
    let &completeopt=s:completeopt
    let &completefunc=s:completefunc
endfunction

" ------------------------------------
function! s:vimim_initialize_session()
" ------------------------------------
    sil!call s:vimim_start_omni()
    sil!call s:vimim_super_reset()
    " --------------------------------
    let s:wubi_flag = 0
    let s:erbi_flag = 0
    let s:privates_flag = 0
    let s:english_flag = 0
    let s:four_corner_flag = 0
    let s:pinyin_flag = 0
    let s:digit_keyboards = {}
    let s:current_datafile = 0
    let s:current_datafile_has_dot = 0
    let s:ecdict = {}
    let s:search_key_slash = 0
    let s:unicode_prefix = 'u'
    let s:sentence_with_space_input = 0
    let s:lines_datafile = []
    let s:alphabet_lines = []
    let s:shuangpin_table = {}
    let s:www_executable = 0
    let s:start_row_before = 0
    let s:start_column_before = 1
    let s:current_positions = [0,0,1,0]
    let s:keyboards = ['','']
    let s:keyboard_counts = 0
    " --------------------------------
endfunction

" ----------------------------
function! s:vimim_start_omni()
" ----------------------------
    let s:diy_pinyin_4corner = 0
    let s:menu_from_cloud_flag = 0
    let s:insert_without_popup_flag = 0
    let s:pattern_not_found = 1
endfunction

" -----------------------------
function! s:vimim_super_reset()
" -----------------------------
    sil!call s:reset_before_anything()
    sil!call s:reset_after_insert()
endfunction

" -----------------------
function! s:vimim_start()
" -----------------------
    sil!call s:vimim_i_setting_on()
    sil!call s:vimim_super_reset()
    sil!call s:vimim_label_on()
    sil!call s:vimim_helper_mapping_on()
endfunction

" ----------------------
function! s:vimim_stop()
" ----------------------
    sil!call s:vimim_i_setting_off()
    sil!call s:vimim_super_reset()
    sil!call s:vimim_i_unmap()
endfunction

" ---------------------------------
function! s:reset_before_anything()
" ---------------------------------
    let s:no_internet_connection = 0
    let s:chinese_input_mode = 0
    let s:chinese_mode_toggle_flag = 0
    let s:chinese_punctuation = (s:vimim_chinese_punctuation+1)%2
    let s:pageup_pagedown = ''
endfunction

" ------------------------------
function! s:reset_after_insert()
" ------------------------------
    let s:seamless_positions = []
    call s:reset_after_auto_insert()
endfunction

" -----------------------------------
function! s:reset_after_auto_insert()
" -----------------------------------
    let s:popupmenu_matched_list = []
    let s:keyboard_wubi = ''
    let s:keyboard_shuangpin = 0
    let s:keyboard_leading_zero = 0
    let s:one_key_correction = 0
    let s:menu_reverse = 0
    let s:smart_enter = 0
    let s:smart_space = 0
"---------------------------------------
endfunction

" ------------------------------------------
function! <SID>alphabet_reset_after_insert()
" ------------------------------------------
    let char_before = getline(".")[col(".")-2]
    if char_before =~# s:valid_key
        call s:reset_after_auto_insert()
    endif
    return ''
endfunction

" ------------------------------------
function! g:vimim_reset_after_insert()
" ------------------------------------
    let s:pageup_pagedown = ''
    " --------------------------------
    if empty(s:vimim_sexy_onekey)
    \&& empty(s:chinese_input_mode)
        call s:vimim_stop()
    endif
    if s:wubi_flag < 0
        let s:vimim_www_sogou = 0
    endif
    return ""
endfunction

" -------------------------
function! s:vimim_i_unmap()
" -------------------------
    let unmap_list = range(0,9)
    call extend(unmap_list, s:valid_keys)
    call extend(unmap_list, keys(s:punctuations))
    call extend(unmap_list, ['<CR>', '<BS>', '<C-H>', '<Space>'])
    " ------------------------------
    for _ in unmap_list
        sil!exe 'iunmap '. _
    endfor
    " ------------------------------
endfunction

" ======================================= }}}
let VimIM = " ====  Core_Engine      ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ------------------------------
function! VimIM(start, keyboard)
" ------------------------------
if a:start

    " -----------------------
    call s:vimim_start_omni()
    " -----------------------

    let current_positions = getpos(".")
    let start_column = current_positions[2]-1
    let start_column_save = start_column
    let start_row = current_positions[1]
    let current_line = getline(start_row)
    let char_before = current_line[start_column-1]
    let char_before_before = current_line[start_column-2]

    if empty(s:chinese_input_mode)
    \&& char_before ==# "[.]"
    \&& char_before_before !~# "[0-9a-z]"
        let match_start = match(current_line, '\w\+\s\+\p\+\.$')
        if match_start > -1
            let s:sentence_with_space_input = 1
            return match_start
        endif
    endif

    if s:vimim_seamless_english_input > 0
        let seamless_column = s:vimim_get_seamless(current_positions)
        if seamless_column < 0
            let msg = "no need to set seamless"
        else
            return seamless_column
        endif
    endif

    let last_seen_nonsense_column = start_column
    while start_column > 0 && char_before =~# s:valid_key
        let start_column -= 1
        if char_before !~# "[0-9,.]"
            let last_seen_nonsense_column = start_column
        endif
        let char_before = current_line[start_column-1]
    endwhile

    if empty(s:chinese_input_mode)
        let msg = "OneKey needs play with digits, comma and dot"
    else
        let start_column = last_seen_nonsense_column
    endif

    " utf-8 datafile update: get user's previous selection
    " ----------------------------------------------------
    if s:vimim_chinese_frequency > 0 && start_row >= s:start_row_before
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

    if s:vimim_debug_flag > 0
        let g:keyboard_s=s:keyboard_leading_zero
        let g:keyboard_a=a:keyboard
    endif

    if s:one_key_correction > 0
        let d = 'delete in omni popup menu'
        let BS = 'delete in Chinese Mode'
        let s:one_key_correction = 0
        return [" "]
    endif

    let keyboard = a:keyboard
    if empty(str2nr(keyboard))
        let msg = "the input is alphabet only"
    else
        let keyboard = s:keyboard_leading_zero
    endif

    " ignore non-sense keyboard inputs
    " --------------------------------
    if empty(keyboard)
    \|| keyboard !~# s:valid_key
        return
    endif
    " --------------------------------
    if empty(s:vimim_sexy_onekey)
    \&& len(keyboard) == 1
    \&& keyboard !~# '\w'
        return
    endif
    " --------------------------------
    if empty(s:chinese_input_mode)
        let @0 = keyboard
    endif

    " [eggs] hunt classic easter egg ... vim<C-\>
    " -------------------------------------------
    if keyboard =~# "^vim"
        let results = s:vimim_easter_chicken(keyboard)
        if len(results) > 0
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " use cached list when pageup/pagedown is used
    " --------------------------------------------
    if s:vimim_punctuation_navigation > 0
        if empty(len(s:pageup_pagedown))
            let msg = "no pageup or pagedown is used"
        elseif empty(s:popupmenu_matched_list)
            let msg = "no popup matched list; let us build it"
        else
            return s:vimim_popupmenu_list(s:popupmenu_matched_list)
        endif
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

    " [imode] magic 'i': English number => Chinese number
    " ---------------------------------------------------
    if s:vimim_imode_pinyin > 0
    \&& keyboard =~# '^i'
        let chinese_numbers = s:vimim_imode_number(keyboard, 'i')
        if len(chinese_numbers) > 0
            return s:vimim_popupmenu_list(chinese_numbers)
        endif
    endif

    " [imode] magic ',': English number => Chinese number
    " ---------------------------------------------------
    if s:vimim_imode_comma > 0
    \&& empty(s:chinese_input_mode)
    \&& keyboard =~# '^,'
        let itoday_inow = s:vimim_date_time(keyboard)
        if len(itoday_inow) > 0
            return itoday_inow
        endif
        let chinese_numbers = s:vimim_imode_number(keyboard, ',')
        if len(chinese_numbers) > 0
            return s:vimim_popupmenu_list(chinese_numbers)
        endif
    endif

    " [modeless] whole sentence input: 【我有一個夢】
    " ----------------------------------------------------
    "   English Input Method: 　i have a dream.
    "   PinYin Input Method:  　wo you yige meng.
    "   Wubi Input Method:    　trde ggwh ssqu.
    "   Cangjie Input Method: 　hqi kb m ol ddni.
    " ----------------------------------------------------
    if empty(s:chinese_input_mode)
        if s:sentence_with_space_input > 0
        \&& keyboard =~ '\s'
        \&& len(keyboard) > 3
        \&& empty(s:current_datafile_has_dot)
            let s:sentence_with_space_input = 0
            let dot = '.'
            let keyboard = substitute(keyboard, '\s', dot, 'g')
        endif
    endif
    let s:sentence_with_space_input = 0

    " process magic english comma and dot at the end
    " (1) english comma for always cloud
    " (2) english period for always non-cloud
    " ----------------------------------------------------
    let keyboard2 = s:vimim_magic_tail(keyboard)
    if empty(keyboard2)
        let msg = "Who cares about such a magic?"
    else
        let keyboard = keyboard2
    endif

    " [shuangpin] support 5 major shuangpin with various rules
    " ----------------------------------------------------
    let keyboard = s:vimim_quanpin_from_shuangpin(keyboard)
    if s:vimim_debug_flag > 0
        let g:shuangpin_in=keyboard
        let g:shuangpin_out=keyboard2
    endif

    " [cloud] to make cloud come true for woyouyigemeng
    " -------------------------------------------------
    let cloud = s:vimim_to_cloud_or_not_to_cloud(keyboard)
    if empty(cloud)
        let msg = "Who cares about cloud?"
    elseif keyboard =~# "[^a-z']"
        let msg = "Cloud limits valid cloud keycodes only"
    else
        let results = s:vimim_get_sogou_cloud_im(keyboard)
        if s:vimim_debug_flag > 0
            let g:cloud_in_keyboard=keyboard
            let g:cloud_out_results=results
        endif
        if empty(len(results))
            if s:vimim_www_sogou > 2
                let s:no_internet_connection += 1
            endif
        else
            let s:no_internet_connection = 0
            let s:menu_from_cloud_flag = 1
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " [erbi] the first .,/;' is punctuation
    " -------------------------------------
    if s:erbi_flag > 0
    \&& len(keyboard) == 1
    \&& keyboard =~ "[.,/;']"
    \&& has_key(s:punctuations_all, keyboard)
        let value = s:punctuations_all[keyboard]
        return [value]
    endif

    " [pinyin_quote_sogou] try exact one-line match
    " ---------------------------------------------
    let lines = s:vimim_load_datafile(0)
    if s:current_datafile =~# "pinyin_quote_sogou"
        let pattern = '^' . keyboard . '\> '
        let match_start = match(lines, pattern)
        if  match_start > 0
            let results = lines[match_start : match_start]
            if len(results) > 0
                let results = s:vimim_pair_list(results)
                return s:vimim_popupmenu_list(results)
            endif
        endif
    endif

    " [datafile update] modify data in memory based on past usage
    " -----------------------------------------------------------
    if s:vimim_chinese_frequency < 0
        let msg = "no chance to modify memory and disk"
    else
        let lines = s:vimim_new_order_in_memory(s:keyboards)
        if empty(lines)
            let lines = s:vimim_load_datafile(0)
        else
            call s:vimim_update_datafile(lines)
            call s:vimim_save_input_history(lines)
        endif
    endif

    " [wubi] support wubi non-stop input
    " ----------------------------------
    if s:wubi_flag > 0
        let results = s:vimim_wubi(keyboard)
        if len(results) > 0
            let results = s:vimim_pair_list(results)
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " now only play with portion of datafile of interest
    " --------------------------------------------------
    let lines = s:vimim_datafile_range(keyboard)

    " first process private data, if existed
    " --------------------------------------
    if s:privates_flag == 1
    \&& len(s:privates_datafile) > 0
    \&& keyboard !~ "['.?*]"
        let results = s:vimim_search_vimim_privates(keyboard)
        if len(results) > 0
            let s:private_matches = results
        endif
     endif

    " return nothing if no single datafile nor cloud
    " ----------------------------------------------
    if empty(lines)
    \&& empty(s:private_matches)
    \&& empty(s:www_executable)
        return
    endif

    " [apostrophe] in pinyin datafile
    " -------------------------------
    let keyboard = s:vimim_apostrophe(keyboard)
    let s:keyboard_leading_zero = keyboard

    " [wildcard search] explicit fuzzy search
    " ----------------------------------------
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

    " to support auto spell, if needed
    " --------------------------------
    if match_start < 0
        let match_start = s:vimim_auto_spell(lines, keyboard)
    endif

    " [unicode] assume hex unicode if no match for 4 corner
    " -----------------------------------------------------
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
        if s:vimim_debug_flag > 0
            let g:no_cloud_in=keyboard
            let g:no_cloud_out=keyboard2
        endif
        if keyboard2 !=# keyboard
            let keyboard = keyboard2
            let pattern = "\\C" . "^" . keyboard
            let match_start = match(lines, pattern)
        endif
    endif

    " [DIY] "Do It Yourself" couple IM: pinyin+4corner
    " ------------------------------------------------
    let keyboards = []
    if match_start < 0
        if s:pinyin_flag > 0 && s:four_corner_flag == 1
            let s:diy_pinyin_4corner = 1
            let keyboard2 = s:vimim_diy_keyboard2number(keyboard)
            if s:vimim_debug_flag > 0
                let g:pinyin_4corner_in=keyboard
                let g:pinyin_4corner_out=keyboard2
            endif
            let keyboards = s:vimim_diy_keyboard(keyboard2)
            let mixtures = s:vimim_diy_results(keyboards)
            if len(mixtures) > 0
                return s:vimim_popupmenu_list(mixtures)
            else
                let s:diy_pinyin_4corner = 0
            endif
        endif
    endif

    " do fuzzy search for 4 corner
    " ----------------------------
    if match_start > -1
        let has_digit = match(keyboard, '\d\+')
        let results = []
        if has_digit > -1
        \&& len(keyboards) > 1
        \&& s:four_corner_flag > 0
            let results = s:vimim_quick_fuzzy_search(keyboard)
        endif
        if len(results) > 0
            let results = s:vimim_pair_list(results)
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " do exact match search on sorted datafile
    " ----------------------------------------
    if match_start > -1
        let s:keyboards[0] = keyboard
        let results = s:vimim_exact_match(lines,keyboard,match_start)
        if len(results) > 0
            let results = s:vimim_pair_list(results)
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " [fuzzy search] implicit wildcard search
    " ---------------------------------------
    if match_start < 0 && s:vimim_fuzzy_search > 0
        let results = s:vimim_fuzzy_match(lines, keyboard)
        if len(results) > 0
            let results = s:vimim_pair_list(results)
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " [private] only return matches from private datafile
    " ---------------------------------------------------
    if match_start < 0 && len(s:private_matches) > 0
        let results = s:vimim_pair_list([])
        return s:vimim_popupmenu_list(results)
    endif

    " [seamless] support seamless English input
    " -----------------------------------------
    if match_start < 0
        if empty(s:chinese_input_mode)
            let msg = "no auto seamless for OneKey"
        else
            call <SID>vimim_set_seamless()
        endif
        return []
    endif

endif
endfunction

" ======================================= }}}
let VimIM = " ====  Core_Drive       ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ------------------------------------
function! s:vimim_initialize_mapping()
" ------------------------------------
    inoremap<silent><expr><Plug>VimimOneKey <SID>vimim_start_onekey()
    inoremap<silent><expr><Plug>VimimChineseToggle <SID>vimim_toggle()
    " ----------------------------------------------------------------
    sil!call s:vimim_one_key_mapping_on()
    " -------------------------------
    sil!call s:vimim_visual_mapping_on()
    " -------------------------------
    if s:vimim_chinese_input_mode > 0
        imap<silent> <C-^> <Plug>VimimChineseToggle
    endif
    " -------------------------------
    if s:vimim_ctrl_space_as_ctrl_6 > 0 && has("gui_running")
        if s:vimim_chinese_input_mode > 0
            imap<silent> <C-Space> <Plug>VimimChineseToggle
        elseif s:vimim_one_key > 0
            imap<silent> <C-Space> <Plug>VimimOneKey
        endif
    endif
    " ------------------------------
endfunction

" -----------------------------------
function! s:vimim_visual_mapping_on()
" -----------------------------------
    if !hasmapto('<C-^>', 'v')
        xnoremap<silent><C-^> y:'>put=<SID>vimim_vCTRL6(@0)<CR>
    endif
    " ----------------------------------------------------------
    if s:vimim_save_new_entry > 0 && !hasmapto('<C-\>', 'v')
        xnoremap<silent><C-\> :y<CR>:call <SID>vimim_save(@0)<CR>
    endif
endfunction

" -----------------------------------
function! s:vimim_helper_mapping_on()
" -----------------------------------
    if s:vimim_smart_ctrl_h > 0 && s:chinese_input_mode < 2
        inoremap<silent><C-H> <C-R>=<SID>vimim_smart_ctrl_h()<CR>
    endif
    " ----------------------------------------------------------
    if s:vimim_sexy_onekey > 0 || s:chinese_input_mode > 0
        inoremap<silent><CR> <C-R>=<SID>vimim_smart_enter()<CR>
                           \<C-R>=<SID>vimim_set_seamless()<CR>
    endif
    " ----------------------------------------------------------
    if s:vimim_smart_backspace > 0
        inoremap<silent><BS> \<C-R>=pumvisible()?"\<lt>C-E>":"\<lt>BS>"<CR>
                             \<C-R>=<SID>vimim_ctrl_x_ctrl_u_bs()<CR>
                             \<C-R>=g:vimim_reset_after_insert()<CR>
    endif
    " ----------------------------------------------------------
endfunction

" ------------------------------------
function! s:vimim_one_key_mapping_on()
" ------------------------------------
    if empty(s:vimim_one_key)
        return
    endif
    " --------------------------------
    if empty(s:vimim_tab_for_one_key)
        imap<silent>     <C-\> <Plug>VimimOneKey
    else
        imap<silent>     <Tab> <Plug>VimimOneKey
        inoremap<silent> <C-\> <Tab>
    endif
endfunction

" -------------------------------------
function! s:vimim_one_key_mapping_off()
" -------------------------------------
    if empty(s:vimim_one_key)
        return
    endif
    iunmap <C-\>
    if s:vimim_tab_for_one_key > 0
        iunmap <Tab>
    endif
endfunction

silent!call s:vimim_initialization()
silent!call s:vimim_initialize_mapping()
" ====================================== }}}
