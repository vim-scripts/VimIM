" ==================================================
"              " VimIM —— Vim 中文输入法 "
" --------------------------------------------------
"  VimIM -- Input Method by Vim, of Vim, for Vimmers
" ==================================================
let $VimIM = "$Date: 2010-01-04 01:18:27 -0800 (Mon, 04 Jan 2010) $"
let $VimIM = "$Revision: 2058 $"

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
"            * "Plug & Play": "Cloud Input at will" for all
"            * "Plug & Play": "Cloud Input" with five Shuangpin
"            * "Plug & Play": "Cloud" from Sogou or from MyCloud
"            * "Plug & Play": "Wubi and Pinyin" dynamic switch
"            * "Plug & Play": "Pinyin and 4Corner" in harmony
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
" The datafile format is both simple and flexible:
"
"             +------+--+-------+
"             |<key> |  |<value>|
"             |======|==|=======|
"             | mali |  |  馬力 |
"             +------+--+-------+

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

" -------------------------------------
function! s:vimim_initialization_once()
" -------------------------------------
    if empty(s:initialization_loaded)
        let s:initialization_loaded=1
    else
        return
    endif
    " -----------------------------------------
    call s:vimim_initialize_i_setting()
    call s:vimim_initialize_session()
    call s:vimim_dictionary_im()
    " -----------------------------------------
    call s:vimim_initialize_vimim_txt_debug()
    call s:vimim_initialize_datafile_in_vimrc()
    " -----------------------------------------
    call s:vimim_scan_plugin_to_invoke_im()
    call s:vimim_scan_plugin_for_more_im()
    " -----------------------------------------
    call s:vimim_initialize_erbi()
    call s:vimim_initialize_pinyin()
    call s:vimim_initialize_shuangpin()
    " -----------------------------------------
    call s:vimim_initialize_keycode()
    call s:vimim_initialize_punctuation()
    call s:vimim_initialize_quantifiers()
    " -----------------------------------------
    call s:vimim_initialize_encoding()
    call s:vimim_initialize_skin()
    " -----------------------------------------
    call s:vimim_initialize_datafile_privates()
    " -----------------------------------------
    call s:vimim_initialize_cloud()
    call s:vimim_initialize_mycloud_plugin()
    " -----------------------------------------
    call s:vimim_finalize_session()
    " -----------------------------------------
endfunction

" -----------------------------------
function! s:vimim_initialize_global()
" -----------------------------------
    let s:global_defaults = []
    let s:global_customized = []
    " -------------------------------
    let G = []
    call add(G, "g:vimim_ctrl_6_as_onekey")
    call add(G, "g:vimim_ctrl_space_as_ctrl_6")
    call add(G, "g:vimim_custom_skin")
    call add(G, "g:vimim_datafile")
    call add(G, "g:vimim_datafile_digital")
    call add(G, "g:vimim_datafile_private")
    call add(G, "g:vimim_datafile_has_4corner")
    call add(G, "g:vimim_datafile_has_apostrophe")
    call add(G, "g:vimim_datafile_has_english")
    call add(G, "g:vimim_datafile_has_pinyin")
    call add(G, "g:vimim_datafile_is_not_utf8")
    call add(G, "g:vimim_english_punctuation")
    call add(G, "g:vimim_frequency_first_fix")
    call add(G, "g:vimim_fuzzy_search")
    call add(G, "g:vimim_imode_comma")
    call add(G, "g:vimim_imode_pinyin")
    call add(G, "g:vimim_insert_without_popup")
    call add(G, "g:vimim_latex_suite")
    call add(G, "g:vimim_reverse_pageup_pagedown")
    call add(G, "g:vimim_sexy_input_style")
    call add(G, "g:vimim_sexy_onekey")
    call add(G, "g:vimim_shuangpin_abc")
    call add(G, "g:vimim_shuangpin_microsoft")
    call add(G, "g:vimim_shuangpin_nature")
    call add(G, "g:vimim_shuangpin_plusplus")
    call add(G, "g:vimim_shuangpin_purple")
    call add(G, "g:vimim_static_input_style")
    call add(G, "g:vimim_tab_as_onekey")
    call add(G, "g:vimim_smart_ctrl_p")
    call add(G, "g:vimim_smart_ctrl_h")
    call add(G, "g:vimim_unicode_lookup")
    call add(G, "g:vimim_wildcard_search")
    call add(G, "g:vimim_cloud_plugin")
    call add(G, "g:vimim_cloud_pim")
    call add(G, "g:vimim_cloud_sogou")
    call add(G, "g:vimimdebug")
    " -----------------------------------
    call s:vimim_set_global_default(G, 0)
    " -----------------------------------
    let G = []
    call add(G, "g:vimim_auto_copy_clipboard")
    call add(G, "g:vimim_smart_ctrl_n")
    call add(G, "g:vimim_smart_backspace")
    call add(G, "g:vimim_chinese_frequency")
    call add(G, "g:vimim_chinese_punctuation")
    call add(G, "g:vimim_custom_laststatus")
    call add(G, "g:vimim_custom_lcursor_color")
    call add(G, "g:vimim_custom_menu_label")
    call add(G, "g:vimim_internal_code_input")
    call add(G, "g:vimim_punctuation_navigation")
    call add(G, "g:vimim_quick_key")
    call add(G, "g:vimim_save_new_entry")
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

" --------------------------------------
function! s:vimim_initialize_i_setting()
" --------------------------------------
    let s:saved_cpo=&cpo
    let s:saved_iminsert=&iminsert
    let s:completefunc=&completefunc
    let s:completeopt=&completeopt
    let s:saved_lazyredraw=&lazyredraw
    let s:saved_hlsearch=&hlsearch
    let s:saved_pumheight=&pumheight
    let s:saved_statusline=&statusline
    let s:saved_laststatus=&laststatus
    let s:saved_ruler=&ruler
endfunction

" ------------------------------------
function! s:vimim_initialize_session()
" ------------------------------------
    sil!call s:vimim_start_omni()
    sil!call s:vimim_super_reset()
    " --------------------------------
    let s:chinese_frequency = 0
    let s:toggle_xiangma_pinyin = 0
    let s:xingma_sleep_with_pinyin = 0
    " --------------------------------
    let s:only_4corner_or_12345 = 0
    let s:pinyin_and_4corner = 0
    let s:four_corner_lines = []
    let s:unicode_menu_display_flag = 0
    " --------------------------------
    let s:im_primary = 0
    let s:im_secondary = 0
    let s:privates_flag = 0
    " --------------------------------
    let s:search_key_slash = 0
    let s:datafile_has_period = 0
    let s:sentence_with_space_input = 0
    let s:start_row_before = 0
    let s:start_column_before = 1
    let s:www_executable = 0
    " --------------------------------
    let s:im = {}
    let s:inputs = {}
    let s:inputs_all = {}
    let s:ecdict = {}
    let s:shuangpin_table = {}
    " --------------------------------
    let s:current_positions = [0,0,1,0]
    let s:alphabet_lines = []
    let s:debugs = []
    " --------------------------------
    let s:debug_count = 0
    let s:keyboard_count = 0
    let s:ctrl_6_count = 1
    " --------------------------------
    let s:datafile = 0
    let s:lines = []
    let s:lines_primary = []
    let s:lines_secondary = []
    " --------------------------------
    let g:vimim = ["",0,0,1,localtime()]
    " --------------------------------
endfunction

" ----------------------------------
function! s:vimim_finalize_session()
" ----------------------------------
    let s:chinese_frequency = s:vimim_chinese_frequency
    " ------------------------------
    if s:pinyin_and_4corner == 1
    \&& s:chinese_frequency > 1
        let s:chinese_frequency = 1
    endif
    " ------------------------------
    if empty(s:vimim_cloud_sogou)
        let s:vimim_cloud_sogou = 888
    elseif s:vimim_cloud_sogou == 1
        let s:chinese_frequency = -1
    endif
    " ----------------------------------------
    if empty(s:datafile)
        let s:datafile = copy(s:datafile_primary)
    endif
    " --------------------------------
    if s:datafile_primary =~# "chinese"
        let s:vimim_datafile_is_not_utf8 = 1
    endif
    " ------------------------------
    if s:datafile_primary =~# "quote"
    \|| s:datafile_secondary =~# "quote"
        let s:vimim_datafile_has_apostrophe = 1
    endif
    " ------------------------------
    if s:shuangpin_flag > 0
        let s:im_primary = 'pinyin'
        let s:im['pinyin'][0] = 1
    endif
    " ------------------------------
    if s:im_primary =~# '^\d\w\+'
    \&& empty(get(s:im['pinyin'],0))
        let s:only_4corner_or_12345 = 1
        let s:vimim_fuzzy_search = 0
        let s:vimim_static_input_style = 1
    endif
    " ------------------------------
    if s:vimim_static_input_style < 0
        let s:vimim_static_input_style = 0
    endif
    " ------------------------------
    if empty(get(s:im['wubi'],0))
        let s:vimim_wubi_non_stop = 0
    endif
    " ------------------------------
    if s:vimim_ctrl_6_as_onekey > 0
        let s:vimim_sexy_onekey = 1
    endif
    " ------------------------------
    if s:vimimdebug > 0
        call s:debugs('im_1st', s:im_primary)
        call s:debugs('im_2nd', s:im_secondary)
        call s:debugs('datafile_1st', s:datafile_primary)
        call s:debugs('datafile_2nd', s:datafile_secondary)
        call s:debugs('xingma_pinyin', s:xingma_sleep_with_pinyin)
        call s:debugs('pinyin_4corner', s:pinyin_and_4corner)
    endif
    " ------------------------------
endfunction

" -------------------------------
function! s:vimim_dictionary_im()
" -------------------------------
    let key = 'cloud'
    let loaded = 0
    let im = '云输入'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'mycloud'
    let loaded = 0
    let im = '自己的云'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'wubi'
    let im = '五笔'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = '4corner'
    let im = '四角号码'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = '12345'
    let im = '五笔划'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'ctc'
    let im = '中文电码'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'cns11643'
    let im = '交換碼'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'english'
    let im = '英文'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'hangul'
    let im = '韩文'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'xinhua'
    let im = '新华'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'pinyin'
    let im = '拼音'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'cangjie'
    let im = '仓颉'
    let keycode = "[a-z,.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'zhengma'
    let im = '郑码'
    let keycode = "[a-z,.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'erbi'
    let im = '二笔'
    let keycode = "[a-z'.,;/]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'yong'
    let im = '永码'
    let keycode = "[a-z',.;/]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'nature'
    let im = '自然'
    let keycode = "[a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'quick'
    let im = '速成'
    let keycode = "[0-9a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'wu'
    let im = '吴语'
    let keycode = "[a-z',.]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'array30'
    let im = '行列'
    let keycode = "[a-z.,;/]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
    let key = 'phonetic'
    let im = '注音'
    let keycode = "[0-9a-z.,;/]"
    let s:im[key]=[loaded, im, keycode]
" -------------------------------------
endfunction

" ======================================= }}}
let VimIM = " ====  Customization    ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" -----------------------------------------
function! s:vimim_add_im_if_empty(ims, key)
" -----------------------------------------
    let input_methods = a:ims
    let key = a:key
    if empty(get(s:im[key],0))
        call add(input_methods, key)
    endif
endfunction

" ------------------------------------------
function! s:vimim_scan_plugin_to_invoke_im()
" ------------------------------------------
    if s:vimimdebug > 0
    \|| s:pinyin_and_4corner > 1
        return 0
    endif
    " ----------------------------------------
    if len(s:datafile_primary) > 1
    \&& len(s:datafile_secondary) > 1
        return 0
    endif
    " ----------------------------------------
    let input_methods = []
    " ----------------------------------------
    call s:vimim_add_im_if_empty(input_methods, 'cangjie')
    call s:vimim_add_im_if_empty(input_methods, 'zhengma')
    call s:vimim_add_im_if_empty(input_methods, 'quick')
    call s:vimim_add_im_if_empty(input_methods, 'array30')
    call s:vimim_add_im_if_empty(input_methods, 'xinhua')
    call s:vimim_add_im_if_empty(input_methods, 'erbi')
    " ----------------------------------------
    if empty(get(s:im['wubi'],0))
        call add(input_methods, "wubi")
        call add(input_methods, "wubi98")
        call add(input_methods, "wubijd")
    endif
    " ----------------------------------------
    if empty(get(s:im['4corner'],0))
        call add(input_methods, "4corner")
        call add(input_methods, "12345")
    endif
    " ----------------------------------------
    if empty(get(s:im['pinyin'],0))
        call add(input_methods, "pinyin")
        call add(input_methods, "pinyin_quote_sogou")
        call add(input_methods, "pinyin_huge")
        call add(input_methods, "pinyin_fcitx")
        call add(input_methods, "pinyin_canton")
        call add(input_methods, "pinyin_hongkong")
    endif
    " ----------------------------------------
    call add(input_methods, "phonetic")
    call add(input_methods, "wu")
    call add(input_methods, "yong")
    call add(input_methods, "nature")
    call add(input_methods, "hangul")
    call add(input_methods, "cns11643")
    call add(input_methods, "ctc")
    call add(input_methods, "english")
    " ----------------------------------------
    for im in input_methods
        let file = "vimim." . im . ".txt"
        let datafile = s:path . file
        if filereadable(datafile)
            break
        else
            continue
        endif
    endfor
    " ----------------------------------------
    if filereadable(datafile)
        let msg = "plugin ciku was found"
    else
        return 0
    endif
    " ----------------------------------------
    let msg = " [setter] for im-loaded-flag "
    if im =~# '^wubi'
        let im = 'wubi'
    elseif im =~# '^pinyin'
        let im = 'pinyin'
    elseif im =~# '^\d'
        let im = '4corner'
    endif
    let s:im[im][0] = 1
    " ----------------------------------------
    if empty(s:datafile_primary)
        let s:datafile_primary = datafile
        let s:im_primary = im
    elseif empty(s:datafile_secondary)
        let s:datafile_secondary = datafile
        let s:im_secondary = im
    endif
    " ----------------------------------------
    return im
endfunction

" -----------------------------------------
function! s:vimim_scan_plugin_for_more_im()
" -----------------------------------------
    if empty(s:datafile_primary)
        return
    endif
    " -------------------------------------
    if empty(s:vimim_ctrl_6_as_onekey)
        let msg = "use CTRL-6 to toggle"
    elseif get(s:im['4corner'],0) > 0
        let msg = "pinyin and 4corner are in harmony"
    else
        return
    endif
    " -------------------------------------
    let im = 0
    if get(s:im['4corner'],0) > 0
    \|| get(s:im['cangjie'],0) > 0
    \|| get(s:im['erbi'],0) > 0
    \|| get(s:im['wubi'],0) > 0
    \|| get(s:im['quick'],0) > 0
    \|| get(s:im['array30'],0) > 0
    \|| get(s:im['xinhua'],0) > 0
    \|| get(s:im['zhengma'],0) > 0
        let msg = "plug and play <=> xingma and pinyin"
        let im = s:vimim_scan_plugin_to_invoke_im()
    endif
    " -------------------------------------
    if empty(im) || s:pinyin_and_4corner > 1
        let msg = "only play with one plugin datafile"
    elseif get(s:im['4corner'],0) > 0
        let s:pinyin_and_4corner = 1
    else
        let s:xingma_sleep_with_pinyin = 1
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

" ------------------------------------
function! s:vimim_initialize_keycode()
" ------------------------------------
    let keycode = s:vimim_get_keycode()
    " --------------------------------
    if empty(keycode)
        let keycode = "[0-9a-z',.]"
    endif
    " --------------------------------
    if s:shuangpin_flag > 0
        let keycode = s:im['shuangpin'][2]
    endif
    " --------------------------------
    let s:valid_key = copy(keycode)
    let keycode = s:vimim_expand_character_class(keycode)
    let s:valid_keys = split(keycode, '\zs')
endfunction

" -----------------------------
function! s:vimim_get_keycode()
" -----------------------------
    if empty(s:im_primary)
        return 0
    endif
    let keycode = get(s:im[s:im_primary],2)
    if s:vimim_wildcard_search > 0
    \&& empty(get(s:im['wubi'],0))
    \&& len(keycode) > 1
        let wildcard = '[*]'
        let key_valid = strpart(keycode, 1, len(keycode)-2)
        let key_wildcard = strpart(wildcard, 1, len(wildcard)-2)
        let keycode = '[' . key_valid . key_wildcard . ']'
    endif
    return keycode
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
    call add(eggs, "测试　vimimdebug")
    call add(eggs, "统计　vimimstat")
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

" -------------------------------
function! s:vimim_egg_vimimstat()
" -------------------------------
    let eggs = []
    let stone = get(g:vimim,1)
    let gold = get(g:vimim,2)
    " ------------------------
    let stat = "总计输入：". gold ." 个汉字"
    call add(eggs, stat)
    " ------------------------
    if gold > 0
        let stat = "平均码长：". string(stone*1.0/gold)
        call add(eggs, stat)
    endif
    " ------------------------
    let duration = get(g:vimim,3)
    let rate = gold*60/duration
    let stat = "打字速度：". string(rate) ." 汉字/分钟"
    call add(eggs, stat)
    " ------------------------
    let egg = '"stat  " . v:val . "　"'
    call map(eggs, egg)
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
" ----------------------------------
    let input = "输入："
    let ciku = "datafile 词库："
    let versions = "\t 版本："
    let encoding = "编码："
" ----------------------------------
    let option .= "_" . &term
    let option = "computer 电脑：" . option
    call add(eggs, option)
" ----------------------------------
    let option = v:progname . "　"
    let option = "Vim" . versions  . option . v:version
    call add(eggs, option)
" ----------------------------------
    let option = get(split($VimIM), 1)
    if empty(option)
        let msg = "not a SVN check out, revision number not available"
    else
        let option = "VimIM" . versions . "vimim.vim　" . option
        call add(eggs, option)
    endif
" ----------------------------------
    let option = "encoding " . encoding . &encoding
    call add(eggs, option)
" ----------------------------------
    let option = "fencs\t "  . encoding . &fencs
    call add(eggs, option)
" ----------------------------------
    let option = "lc_time\t " . encoding . v:lc_time
    call add(eggs, option)
" ----------------------------------
    let option = s:vimim_static_input_style
    if empty(option)
        let option = 'i_CTRL-^　经典动态'
    else
        let option = 'i_CTRL-^　经典静态'
    endif
    if s:vimim_ctrl_6_as_onekey > 0
        let option = 'i_CTRL-^　点石成金'
    endif
    let option = "mode\t 风格：" . option
    call add(eggs, option)
" ----------------------------------
    let im = s:vimim_statusline()
    if !empty(im)
        let option = "im\t " . input . im
        call add(eggs, option)
    endif
" ----------------------------------
    let option = s:shuangpin_flag
    if empty(option)
        let msg = "no shuangpin is used"
    else
        let option = "im\t " . input . get(s:im['shuangpin'],1)
        call add(eggs, option)
    endif
" ----------------------------------
    let option = s:datafile_primary
    if empty(option)
        let msg = "no primary datafile, might play cloud"
    else
        let option = ciku . option
        call add(eggs, option)
    endif
" ----------------------------------
    let option = s:datafile_secondary
    if empty(option)
        let msg = "no secondary pinyin to sleep with"
    else
        let option = ciku . s:datafile_secondary
        call add(eggs, option)
    endif
" ----------------------------------
    let option = s:privates_datafile
    if empty(option)
        let msg = "no private datafile found"
    else
        let option = ciku . option
        call add(eggs, option)
    endif
" ----------------------------------
    let option = "cloud\t 私云："
    if s:vimim_cloud_pim > 0
        let option .= "〖自己的云〗"
        call add(eggs, option)
    endif
" ----------------------------------
    let cloud = s:vimim_cloud_sogou
    let option = "cloud\t 搜狗："
    if cloud < 0
        let option .= "〖晴天无云〗"
    elseif cloud == 888
        let option .= "〖想云就云〗"
    elseif cloud == 1
        let option .= "〖全云输入〗"
    else
        let option .= "每超过" . cloud . "个字符就开始"
        let option .= get(s:im['cloud'],1)
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
    if egg =~# s:valid_key
        let msg = "hunt easter egg ... vim<C-\>"
    elseif egg ==# ",," && s:vimimdebug > 0
        let msg = 'quick dirty lazy debugging'
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
    elseif egg ==# "vimimstat"
        return s:vimim_egg_vimimstat()
    elseif egg ==# "vimimdefaults"
        return s:vimim_egg_vimimdefaults()
    elseif egg ==# "vimimdebug" || egg ==# ",,"
        return s:vimim_egg_vimimdebug()
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
    endif
    if s:localization > 0
        let warning = 'performance hit if &encoding & datafile differs!'
    endif
endfunction

" ------------------------------
function! s:vimim_localization()
" ------------------------------
    let localization = 0
    let datafile_fenc_chinese = 0
    if empty(s:vimim_datafile_is_not_utf8)
        let msg = 'current datafile is chinese encoding'
    else
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
function! s:vimim_i18n_iconv(line)
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
    if s:chinese_input_mode > 1
    \|| s:pinyin_and_4corner < 2
    \|| match(a:keyboard, '^\d\{4}$') != 0
        return []
    endif
    let dddd = str2nr(a:keyboard, 16)
    if dddd > s:max_ddddd
        return []
    endif
    let unicode = nr2char(dddd)
    let menu = 'u' . a:keyboard .'　'. dddd
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
    let unicode_prefix = 'u'
    let last_char = strpart(keyboard,len(keyboard)-1,1)
    " support internal-code popup menu, if ending with 'u'
    " ----------------------------------------------------
    if last_char == unicode_prefix
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
    else
    " -----------------------------------------------------
        if keyboard =~ '^\d\{5}$'     "| 32911
            let numbers = [str2nr(keyboard)]
        elseif keyboard =~ '\x\{4}$'  "| 808f
            let four_hex   = match(keyboard, '^\x\{4}$')
            let four_digit = match(keyboard, '^\d\{4}$')
            if empty(four_hex) && four_digit < 0
                let keyboard = unicode_prefix . keyboard
            endif
            if strpart(keyboard,0,1) == unicode_prefix
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

" --------------------------------
function! s:vimim_onekey_autocmd()
" --------------------------------
    if s:vimim_sexy_onekey > 0 && has("autocmd")
        augroup onekey_mode_autocmd
            autocmd!
            if hasmapto('<Space>', 'i')
                sil!autocmd InsertLeave * sil!call s:vimim_stop()
            endif
        augroup END
    endif
endfunction

" ---------------------------------
function! <SID>vimim_space_onekey()
" ---------------------------------
    let onekey = " "
    return s:vimim_onekey(onekey)
endfunction

" ---------------------------------
function! <SID>vimim_start_onekey()
" ---------------------------------
    let s:chinese_input_mode = 0
    " -----------------------------
    sil!call s:vimim_start()
    sil!call s:vimim_onekey_status_on()
    sil!call s:vimim_label_1234567890_filter_on()
    sil!call s:vimim_hjkl_navigation_on()
    sil!call s:vimim_punctuation_navigation_on()
    sil!call s:vimim_helper_mapping_on()
    sil!call s:vimim_onekey_autocmd()
    " ----------------------------------------------------------
    inoremap<silent><Space> <C-R>=<SID>vimim_space_onekey()<CR>
                           \<C-R>=g:vimim_reset_after_insert()<CR>
    " ----------------------------------------------------------
    let onekey = ""
    if s:vimim_tab_as_onekey > 0
        let onekey = "\t"
    endif
    " ---------------------------
    " <OneKey> double play
    "   (1) after English (valid keys) => trigger omni popup
    "   (2) after omni popup window    => same as <Space>
    " ----------------------------------------------------------
    let onekey = s:vimim_onekey(onekey)
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
        let space = s:vimim_ctrl_y_ctrl_x_ctrl_u()
        sil!exe 'sil!return "' . space . '"'
    endif
    if s:insert_without_popup > 0
        let s:insert_without_popup = 0
        let space = ""
    endif
    " ---------------------------------------------------
    let char_before = getline(".")[col(".")-2]
    let char_before_before = getline(".")[col(".")-3]
    " ---------------------------------------------------
    if char_before_before !~# "[0-9a-z]"
    \&& has_key(s:punctuations, char_before)
        let space = ""
        for char in keys(s:punctuations_all)
            if char_before_before ==# char
                let space = a:onekey
                break
            else
                continue
            endif
        endfor
        " -----------------------------------------------
        if empty(space)
            let replacement = s:punctuations[char_before]
            let space = "\<BS>" . replacement
        else
            let msg = "too smart is not smart"
        endif
        " -----------------------------------------------
        if s:vimimdebug > 0
        \&& char_before ==# ","
        \&& char_before ==# char_before_before
            let msg = 'make double comma ",," for debugging'
        else
            sil!exe 'sil!return "' . space . '"'
        endif
    endif
    " ---------------------------------------------------
    if char_before !~# s:valid_key
        if !has("autocmd")
        \|| a:onekey ==# "\t"
        \|| empty(s:vimim_ctrl_6_as_onekey)
            call s:vimim_stop()
        endif
        return a:onekey
    endif
    " ---------------------------------------------------
    if s:pattern_not_found < 1
        let space = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        sil!exe 'sil!return "' . space . '"'
    else
        let s:pattern_not_found = 0
    endif
    " ---------------------------------------------------
    return a:onekey
endfunction

" --------------------------
function! s:vimim_label_on()
" --------------------------
    if s:vimim_custom_menu_label < 1
        return
    endif
    let labels = range(0,9)
    if empty(s:chinese_input_mode)
        let _abcdefghi = split("`abcdefghiz", '\zs')
        call extend(labels, _abcdefghi)
    endif
    for _ in labels
        sil!exe'inoremap<silent> '._.'
        \  <C-R>=<SID>vimim_label("'._.'")<CR>'
        \.'<C-R>=g:vimim_reset_after_insert()<CR>'
    endfor
endfunction

" ---------------------------
function! <SID>vimim_label(n)
" ---------------------------
    let label = a:n
    let n = a:n
    if a:n !~ '\d'
        let n = char2nr(n) - char2nr('a') + 2
    endif
    if pumvisible()
        if a:n ==# 'z'
            let label = '\<C-E>\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        else
            if n < 1
                let n = 10
            endif
            let counts = repeat("\<Down>", n-1)
            let yes = s:vimim_ctrl_y_ctrl_x_ctrl_u()
            let label = counts . yes
        endif
    endif
    sil!exe 'sil!return "' . label . '"'
endfunction

" --------------------------------------------
function! s:vimim_label_1234567890_filter_on()
" --------------------------------------------
    if s:vimim_custom_menu_label < 1
    \|| empty(s:pinyin_and_4corner)
        return
    endif
    let labels = range(0,9)
    if get(s:im['12345'],0) > 0
        let labels = range(1,5)
    endif
    for _ in labels
        sil!exe'inoremap<silent> '._.'
        \  <C-R>=<SID>vimim_label_1234567890_filter("'._.'")<CR>'
    endfor
endfunction

" ---------------------------------------------
function! <SID>vimim_label_1234567890_filter(n)
" ---------------------------------------------
    let label = a:n
    if pumvisible()
        if s:pinyin_and_4corner > 0
            let msg = "give 1234567890 label new meaning"
            let s:menu_4corner_filter = a:n
            let label = '\<C-E>\<C-X>\<C-U>\<C-P>\<Down>'
        endif
    endif
    sil!exe 'sil!return "' . label . '"'
endfunction

" ------------------------------------
function! s:vimim_hjkl_navigation_on()
" ------------------------------------
    let hjkl_list = split('qsxujklp', '\zs')
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
        if a:key == 'x'
            let hjkl  = '\<C-E>'
        elseif a:key == 'y'
            let hjkl  = '\<C-R>=g:vimim_pumvisible_y_yes()\<CR>'
        elseif a:key == 'u'
            let hjkl  = '\<PageUp>'
        elseif a:key == 'j'
            let hjkl  = '\<Down>'
        elseif a:key == 'k'
            let hjkl  = '\<Up>'
        elseif a:key == 'l'
            let hjkl  = '\<PageDown>'
        elseif a:key == 's'
            let hjkl  = '\<C-R>=g:vimim_pumvisible_y_yes()\<CR>'
            let hjkl .= '\<C-R>=g:vimim_pumvisible_putclip()\<CR>'
        elseif a:key == 'p'
            let hjkl  = '\<C-R>=g:vimim_pumvisible_ctrl_e()\<CR>'
            let hjkl .= '\<C-R>=g:vimim_pumvisible_p_paste()\<CR>'
        elseif a:key == 'q'
            let hjkl  = '\<C-R>=g:vimim_pumvisible_ctrl_e()\<CR>'
            let hjkl .= '\<C-R>=g:vimim_one_key_correction()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . hjkl . '"'
endfunction

" ------------------------------------
function! g:vimim_one_key_correction()
" ------------------------------------
    let key = '\<Esc>'
    call s:reset_matched_list()
    " --------------------------------
    if empty(s:chinese_input_mode)
    \&& empty(s:vimim_sexy_onekey)
        call s:vimim_stop()
    else
        let char_before = getline(".")[col(".")-2]
        if char_before =~# s:valid_key
            let s:one_key_correction = 1
            let key = '\<C-X>\<C-U>\<BS>'
        endif
    endif
    " --------------------------------
    sil!exe 'sil!return "' . key . '"'
endfunction

" ------------------------------------
function! g:vimim_pumvisible_p_paste()
" ------------------------------------
    let matched_list = copy(s:popupmenu_matched_list)
    if empty(matched_list)
        return "\<Esc>"
    endif
    let pastes = []
    let words = []
    let show_me_not_pattern = ',,,'
    for item in matched_list
        let pairs = split(item)
        let yin = get(pairs, 0)
        let yang = get(pairs, 1)
        if yang =~ '#'
            continue
        endif
        call add(words, item)
        if yin =~ show_me_not_pattern
            call add(pastes, yang)
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
endfunction

" ----------------------------------
function! g:vimim_pumvisible_y_yes()
" ----------------------------------
    let key = ''
    if pumvisible()
        let key = s:vimim_ctrl_y_ctrl_x_ctrl_u()
    else
        let key = ' '
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ------------------------------------
function! g:vimim_pumvisible_putclip()
" ------------------------------------
    let chinese = s:vimim_popup_word()
    return s:vimim_clipboard_register(chinese)
endfunction

" ----------------------------
function! s:vimim_popup_word()
" ----------------------------
    if pumvisible()
        return ""
    endif
    let column_start = s:start_column_before
    let column_end = col('.') - 1
    let range = column_end - column_start
    let current_line = getline(".")
    let word = strpart(current_line, column_start, range)
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
    sil!call g:vimim_reset_after_insert()
    sil!call s:vimim_stop()
    return "\<Esc>"
endfunction

" ======================================= }}}
let VimIM = " ====  Chinese_Mode     ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ----------------------------------
function! <SID>vimim_toggle_ctrl_6()
" ----------------------------------
    if s:chinese_mode_toggle_flag < 1
        sil!call s:vimim_start_chinese_mode()
    else
        sil!call s:vimim_stop_chinese_mode()
    endif
    sil!return "\<C-O>:redraw\<CR>"
endfunction

" ------------------------------------
function! s:vimim_start_chinese_mode()
" ------------------------------------
    sil!call s:vimim_onekey_mapping_off()
    sil!call s:vimim_start()
    sil!call s:vimim_i_chinese_mode_on()
    sil!call s:vimim_i_chinese_mode_autocmd_on()
    " --------------------------------
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
    " ---------------------------------
    sil!call s:vimim_i_lcursor_color(1)
    sil!call s:vimim_helper_mapping_on()
    " ---------------------------------------------------------
    inoremap<silent><expr><C-\> <SID>vimim_toggle_punctuation()
                         return <SID>vimim_toggle_punctuation()
    " ---------------------------------------------------------
endfunction

" -----------------------------------
function! s:vimim_stop_chinese_mode()
" -----------------------------------
    if s:vimim_auto_copy_clipboard>0 && has("gui_running")
        sil!exe ':%y +'
    endif
    " ------------------------------
    if exists('*Fixcp')
        sil!call FixAcp()
    endif
    " ------------------------------
    sil!call s:vimim_stop()
    sil!call s:vimim_i_lcursor_color(0)
    sil!call s:vimim_onekey_mapping_on()
endfunction

" -------------------------------
function! g:vimim_space_dynamic()
" -------------------------------
    let space = ' '
    if pumvisible()
        let space = "\<C-Y>"
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
            if s:pattern_not_found < 1
                let space = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
            else
                let s:pattern_not_found = 0
            endif
        endif
    endif
    sil!exe 'sil!return "' . space . '"'
endfunction

" ---------------------------------------------
function! s:vimim_static_alphabet_auto_select()
" ---------------------------------------------
    if s:chinese_input_mode != 1
    \|| if s:only_4corner_or_12345 > 0
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
        \ . '<C-R>=g:reset_after_auto_insert()<CR>'
    endfor
endfunction

" ------------------------------------------
function! s:vimim_dynamic_alphabet_trigger()
" ------------------------------------------
    if s:chinese_input_mode < 2
        return
    endif
    " --------------------------------------
    for char in s:valid_keys
        if char !~# "[0-9,.']"
            sil!exe 'inoremap<silent> ' . char . '
            \ <C-R>=g:vimim_pumvisible_ctrl_e()<CR>'. char .
            \'<C-R>=g:vimim_ctrl_x_ctrl_u()<CR>'
        endif
    endfor
endfunction

" ======================================= }}}
let VimIM = " ====  Skin             ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ---------------------------------
function! s:vimim_initialize_skin()
" ---------------------------------
    if s:vimim_custom_skin < 1
        return
    endif
    " --------------------------
    highlight! link PmenuSel   Title
    highlight! link StatusLine Title
    highlight!      Pmenu      NONE
    highlight!      PmenuSbar  NONE
    highlight!      PmenuThumb NONE
    " --------------------------
    if s:vimim_custom_skin > 1
        let msg = "no extra_text on menu"
    endif
endfunction

" ----------------------------------
function! s:vimim_onekey_status_on()
" ----------------------------------
    if s:vimim_sexy_onekey > 0
    \&& s:vimim_custom_laststatus < 2
        set noruler
    endif
    if s:vimim_custom_laststatus > 1
        set laststatus=2
    endif
endfunction

" -----------------------------------
function! s:vimim_i_chinese_mode_on()
" -----------------------------------
    set imdisable
    set iminsert=1
    let s:chinese_mode_toggle_flag = 1
    let s:ctrl_6_count += 1
    if s:vimim_cloud_sogou == 1 && s:vimimdebug > 0
        if empty(s:ctrl_6_count%2)
            let s:vimim_static_input_style = 0
        else
            let s:vimim_static_input_style = 1
        endif
    endif
    let s:toggle_xiangma_pinyin = s:ctrl_6_count%2
    let b:keymap_name = s:vimim_statusline()
    sil!call s:vimim_i_laststatus_on()
endfunction

" -------------------------------------------
function! s:vimim_i_chinese_mode_autocmd_on()
" -------------------------------------------
    if has("autocmd")
        augroup chinese_mode_autocmd
            autocmd!
            autocmd BufEnter * let &statusline=s:vimim_statusline()
        augroup END
    endif
endfunction

" ---------------------------------
function! s:vimim_i_laststatus_on()
" ---------------------------------
    if s:vimim_custom_laststatus < 1
        let msg = "never touch the laststatus"
    else
        set laststatus=2
    endif
endfunction

" ---------------------------------------
function! s:vimim_i_lcursor_color(switch)
" ---------------------------------------
    if s:vimim_custom_lcursor_color < 1
        return
    endif
    if empty(a:switch)
        highlight! lCursor NONE
    else
        highlight! lCursor guifg=bg guibg=green
    endif
endfunction

" ----------------------------
function! s:vimim_statusline()
" ----------------------------
    let im = ''
    let plus = ['〖' ,'〗', '＋']
    let plus2 = plus[1] . plus[2] . plus[0]
  " --------------------------
    let key  = s:im_primary
    if has_key(s:im, key)
        let im = get(s:im[key],1)
    endif
  " --------------------------
    if key =~# 'wubi'
        if s:datafile_primary =~# 'wubi98'
            let im .= '98'
        elseif s:datafile_primary =~# 'wubijd'
            let im = '极点' . im
        endif
    endif
  " --------------------------
    let pinyin = get(s:im['pinyin'],1)
    if s:shuangpin_flag > 0
        let pinyin = get(s:im['shuangpin'],0)
        let im = pinyin
    endif
  " --------------------------
    if s:pinyin_and_4corner > 0
        let im_digit = get(s:im['4corner'],1)
        if s:datafile_primary =~ '12345'
            let im_digit = get(s:im['12345'],1)
            let s:im['12345'][0] = 1
        endif
        let im = pinyin . plus2 . im_digit
    endif
  " --------------------------
    if s:xingma_sleep_with_pinyin > 0
        let im_1 = get(s:im[s:im_primary],1)
        let im_2 = get(s:im[s:im_secondary],1)
        if empty(s:toggle_xiangma_pinyin)
            let im = im_1 . plus2 . im_2
        else
            let im = im_2 . plus2 . im_1
        endif
    endif
  " --------------------------
    if empty(im) && s:vimim_cloud_sogou > 0
        let im = get(s:im['cloud'],1)
        if s:vimim_cloud_sogou == 1
            let im = "全" . im . "★经典"
            if s:vimim_static_input_style < 1
                let im .= "动态"
            else
                let im .= "静态"
            endif
        endif
    endif
  " --------------------------
    if len(s:vimim_cloud_plugin) > 1
        let im = get(s:im['mycloud'],1) ."：". get(s:im['mycloud'],0)
    endif
  " --------------------------
    let im  = plus[0] . im . plus[1]
  " --------------------------
    return im
endfunction

" ======================================= }}}
let VimIM = " ====  Seamless         ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" -----------------------------------------------
function! s:vimim_get_seamless(current_positions)
" -----------------------------------------------
    if empty(s:seamless_positions)
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
    let s:start_row_before = seamless_lnum
    let s:smart_enter = 0
    return seamless_column
endfunction

" ---------------------------------
function! <SID>vimim_set_seamless()
" ---------------------------------
    let s:seamless_positions = getpos(".")
    let s:keyboard_leading_zero = 0
    return ""
endfunction

" ======================================= }}}
let VimIM = " ====  Punctuations     ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ----------------------------------------
function! s:vimim_initialize_punctuation()
" ----------------------------------------
    let s:punctuations = {}
    let s:punctuations['#']='＃'
    let s:punctuations['&']='※'
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
        let s:punctuations['\']='、'
        let s:punctuations["'"]='‘’'
        let s:punctuations['"']='“”'
    endif
    let s:punctuations_all = copy(s:punctuations)
    for char in s:valid_keys
        if has_key(s:punctuations, char) && char !~# "[*,.']"
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
    if s:chinese_input_mode > 0
        unlet s:punctuations['\']
        unlet s:punctuations["'"]
        unlet s:punctuations['"']
    endif
    " ----------------------------
    if s:chinese_punctuation > 0
        inoremap <Bslash> 、
        inoremap ' ‘’<Left>
        inoremap " “”<Left>
    else
        iunmap <Bslash>
        iunmap '
        iunmap "
    endif
    " ----------------------------
    let punctuations = s:punctuations
    if get(s:im['erbi'],0) > 0
        unlet punctuations[',']
        unlet punctuations['.']
        unlet punctuations['/']
        unlet punctuations[';']
        unlet punctuations["'"]
    endif
    " ----------------------------
    for _ in keys(punctuations)
        sil!exe 'inoremap <silent> '._.'
        \    <C-R>=<SID>vimim_punctuation_mapping("'._.'")<CR>'
        \ . '<C-R>=g:reset_after_auto_insert()<CR>'
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
    let hjkl_list = split('.,=-;[]','\zs')
    if s:vimim_punctuation_navigation < 1
        let hjkl_list = split('=-;[]','\zs')
    endif
    if s:search_key_slash < 0
        let msg = "search keys are reserved"
    else
        call add(hjkl_list, '/')
        if empty(s:chinese_input_mode)
            call add(hjkl_list, '?')
        endif
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
            let hjkl  = '\<Down>\<C-Y>'
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
            let hjkl = '\<C-E>\<C-X>\<C-U>\<C-P>\<Down>'
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
    let s:quantifiers['b'] = '百佰步把包杯本笔部班'
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
    if s:vimimdebug < 1
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
        let s:insert_without_popup = 1
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
        let s:insert_without_popup = 1
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
        if empty(s:ecdict)
            return ''
        endif
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
    if empty(s:vimim_datafile_has_english)
    \|| len(s:ecdict) > 1
        return ''
    endif
    let lines = s:vimim_reload_datafile(0)
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

" ---------------------------------------
function! s:vimim_reverse_lookup(chinese)
" ---------------------------------------
    let chinese = substitute(a:chinese,'\s\+\|\w\|\n','','g')
    let chinese_characters = split(chinese,'\zs')
    let glyph = join(chinese_characters, '   ')
    let items = []
    " ------------------------------------------------
    let results_unicode = []
    if s:vimim_unicode_lookup > 0
        for char in chinese_characters
            let unicode = printf('%04x',char2nr(char))
            call add(items, unicode)
        endfor
        call add(results_unicode, join(items, ' '))
        call add(results_unicode, glyph)
    endif
    " ------------------------------------------------
    let results_4corner = []
    if get(s:im['4corner'],0) > 0
        let cache_4corner = s:vimim_build_reverse_4corner_cache(chinese)
        let items = s:vimim_make_one_entry(cache_4corner, chinese)
        call add(results_4corner, join(items,' '))
        call add(results_4corner, glyph)
    endif
    " ------------------------------------------------
    let cache_pinyin = s:vimim_build_reverse_pinyin_cache(chinese, 0)
    let items = s:vimim_make_one_entry(cache_pinyin, chinese)
    let result_pinyin = join(items,'')." ".chinese
    " ------------------------------------------------
    let results = []
    if len(results_unicode) > 0
        call extend(results, results_unicode)
    endif
    if len(results_4corner) > 0
        call extend(results, results_4corner)
    endif
    if result_pinyin =~ '\a'
        call add(results, result_pinyin)
    endif
    return results
endfunction

" ------------------------------------------------------------
function! s:vimim_build_reverse_pinyin_cache(chinese, one2one)
" ------------------------------------------------------------
    call s:vimim_reload_datafile(0)
    if empty(s:lines)
        return {}
    endif
    if empty(s:alphabet_lines)
        let first_line_index = 0
        let index = match(s:lines, '^a')
        if index > -1
            let first_line_index = index
        endif
        let last_line_index = len(s:lines) - 1
        let s:alphabet_lines = s:lines[first_line_index : last_line_index]
        if get(s:im['pinyin'],0) > 0 |" one to many relationship
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
        if get(s:im['pinyin'],0) > 0
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
        let slash  = '\<C-R>=g:vimim_pumvisible_y_yes()\<CR>'
        let slash .= '\<C-R>=g:vimim_slash_search()\<CR>'
        let slash .= a:key . '\<CR>'
    endif
    sil!exe 'sil!return "' . slash . '"'
endfunction

" ------------------------------
function! g:vimim_slash_search()
" ------------------------------
    let msg = "search from popup menu"
    let word = s:vimim_popup_word()
    if empty(word)
        let @/ = @_
    else
        let @/ = word
    endif
    let repeat_times = len(word)/s:multibyte
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
        let yes = '\<C-R>=g:vimim_pumvisible_y_yes()\<CR>'
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
    let char_before = getline(".")[col(".")-2]
    " -----------------------------------------------
    " <Enter> double play in Chinese Mode:
    "   (1) after English (valid keys)    => Seamless
    "   (2) after Chinese or double Enter => Enter
    " -----------------------------------------------
    if char_before =~# "[*,.']"
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
        if char_before =~ '\s' || empty(char_before)
            let key = "\<CR>"
        endif
    endif
    " -----------------------------------------------
    if s:smart_enter == 1
        let msg = "do seamless for the first time <Enter>"
        let s:seamless_positions = getpos(".")
        let s:keyboard_leading_zero = 0
    else
        let s:smart_enter = 0
        let key = "\<CR>"
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ---------------------------------
function! <SID>vimim_smart_ctrl_n()
" ---------------------------------
    let s:smart_ctrl_n += 1
    let key = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
    sil!exe 'sil!return "' . key . '"'
endfunction

" ----------------------------------------------------
function! s:vimim_get_list_from_smart_ctrl_n(keyboard)
" ----------------------------------------------------
    let keyboard = a:keyboard
    if s:smart_ctrl_n < 1
        return []
    endif
    let s:smart_ctrl_n = 0
    if keyboard =~# s:valid_key && len(keyboard) == 1
        let msg = 'try to find from previous valid inputs'
    else
        return []
    endif
    let matched_list = []
    if has_key(s:inputs, keyboard)
        let matched_list = s:inputs[keyboard]
    endif
    return matched_list
endfunction

" ---------------------------------
function! <SID>vimim_smart_ctrl_p()
" ---------------------------------
    let s:smart_ctrl_p += 1
    let key = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
    sil!exe 'sil!return "' . key . '"'
endfunction

" ----------------------------------------------------
function! s:vimim_get_list_from_smart_ctrl_p(keyboard)
" ----------------------------------------------------
    let keyboard = a:keyboard
    if s:smart_ctrl_p < 1
        return []
    endif
    let s:smart_ctrl_p = 0
    if keyboard =~# s:valid_key
        let msg = 'try to find from all previous valid inputs'
    else
        return []
    endif
    let pattern = s:vimim_free_fuzzy_pattern(keyboard)
    let matched = match(keys(s:inputs_all), pattern)
    if matched < 0
        let msg = "nothing matched previous user input"
        return []
    else
        let keyboard = get(keys(s:inputs_all), matched)
        let matched_list = s:inputs_all[keyboard]
        return matched_list
    endif
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

" -----------------------------------
function! g:vimim_pumvisible_ctrl_e()
" -----------------------------------
    let key = ""
    if pumvisible()
        let key = "\<C-E>"
        if s:vimim_wubi_non_stop > 0
        \&& empty(get(s:im['pinyin'],0))
        \&& empty(len(s:keyboard_wubi)%4)
            let key = "\<C-Y>"
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" -------------------------------------
function! <SID>vimim_ctrl_x_ctrl_u_bs()
" -------------------------------------
    call s:reset_matched_list()
    " ---------------------------------
    if s:chinese_input_mode > 1
        let key = '\<BS>\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        sil!exe 'sil!return "' . key . '"'
    endif
    " ---------------------------------
    if empty(s:vimim_sexy_onekey)
    \&& empty(s:chinese_input_mode)
        call s:vimim_stop()
    endif
    " ---------------------------------
    let key = '\<BS>'
    if empty(s:vimim_smart_backspace)
        sil!exe 'sil!return "' . key . '"'
    endif
    " ---------------------------------
    let char_before = getline(".")[col(".")-2]
    let char_before_before = getline(".")[col(".")-3]
    " ---------------------------------
    if char_before =~ '\w'
    \&& char_before_before !~ '\w'
        let s:smart_backspace = 1
    endif
    if char_before =~ '\s'
        let s:smart_backspace = 0
    endif
    " ---------------------------------
    if s:smart_backspace > 0
    \&& char_before !~ '\w'
        let key = ''
        let s:smart_backspace = 0
        sleep
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
    let s:matched_list = copy(a:matched_list)
    let matched_list = a:matched_list
    if len(s:private_matches) > 0
        call extend(matched_list, s:private_matches, 0)
        let s:private_matches = []
    endif
    if empty(matched_list)
        return []
    endif
    let pair_matched_list = []
    let maximum_list = 200
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

" -------------------------------------------------
function! s:vimim_menu_4corner_filter(matched_list)
" -------------------------------------------------
    if empty(s:chinese_input_mode)
    \&& s:pinyin_and_4corner > 0
    \&& s:menu_4corner_filter > -1
        let msg = "make 4corner as a filter to omni menu"
    else
        return a:matched_list
    endif
    let keyboard = get(split(get(a:matched_list,0)),0)
    let keyboard = strpart(keyboard, match(keyboard,'\l'))
    let keyboards = [keyboard, s:menu_4corner_filter]
    let results = s:vimim_diy_results(keyboards, a:matched_list)
    return results
endfunction

" ---------------------------------------------
function! s:vimim_pageup_pagedown(matched_list)
" ---------------------------------------------
    let matched_list = a:matched_list
    let page = &pumheight
    if empty(s:pageup_pagedown) || len(matched_list) < page+1
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
    "-----------------------------------------
    let first_candidate = get(split(get(matched_list,0)),0)
    if s:vimim_smart_ctrl_n > 0
        let key = strpart(first_candidate,0,1)
        let s:inputs[key] = matched_list
    endif
    if s:vimim_smart_ctrl_p > 0
        let s:inputs_all[first_candidate] = matched_list
    endif
    "-----------------------------------------
    let s:popupmenu_matched_list = copy(matched_list)
    let matched_list = s:vimim_menu_4corner_filter(matched_list)
    let matched_list = s:vimim_pageup_pagedown(matched_list)
    "-----------------------------------------
    let keyboard = s:keyboard_leading_zero
    let matched = match(keyboard, first_candidate)
    "-----------------------------------------
    if matched > 0
        let msg = "............zuorichongxian"
        let keyboard = strpart(keyboard, matched)
    endif
    " ----------------------
    let menu = 0
    let label = 1
    let popupmenu_list = []
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
            if s:pinyin_and_4corner > 1
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
        if s:vimim_custom_menu_label > 0
            let labeling = label
            if label == 10
                let labeling = 0
            endif
            if empty(s:chinese_input_mode) && label < 11
                if s:pinyin_and_4corner > 0
                    let s:vimim_custom_menu_label = 3
                endif
                let _abcdefghi = char2nr('a')-1+(label-1)%26
                let label2 = nr2char(_abcdefghi)
                if label < 2
                    let label2 = "_"
                endif
                if s:vimim_custom_menu_label > 2
                    let labeling = label2
                else
                    let labeling .= label2
                endif
            endif
            let abbr = printf('%2s',labeling)."\t".chinese
            if len(matched_list) > 1
                let complete_items["abbr"] = abbr
            endif
        endif
        " -------------------------------------------------
        let tail = ''
        if keyboard =~? 'vim'
            let tail = ''
        elseif keyboard =~ '[.]'
            let dot = match(keyboard, '[.]')
            let tail = strpart(keyboard, dot+1)
        else
            let candidate = menu
            if empty(s:menu_from_cloud_flag)
                let candidate = first_candidate
            endif
            let tail = strpart(keyboard, len(candidate))
        endif
        " -------------------------------------------------
        if tail =~ '\w'
            let chinese .=  tail
        endif
        " -------------------------------------------------
        if s:vimimdebug > 3
            call s:debugs('tail', tail)
        endif
        " -------------------------------------------------
        let complete_items["word"] = chinese
        let complete_items["dup"] = 1
        let label += 1
        call add(popupmenu_list, complete_items)
        " -------------------------------------------------
    endfor
    return popupmenu_list
endfunction

" ----------------------------------------
function! s:vimim_datafile_range(keyboard)
" ----------------------------------------
    call s:vimim_reload_datafile(0)
    if empty(s:lines) || empty(a:keyboard)
        return []
    endif
    let ranges = s:vimim_search_boundary(s:lines, a:keyboard)
    if empty(ranges)
        return []
    elseif len(ranges) == 1
        let ranges = s:vimim_search_boundary(sort(s:lines), a:keyboard)
        if empty(ranges)
            return
        else
            call s:vimim_save_to_disk(s:lines)
        endif
    endif
    return s:lines[get(ranges,0) : get(ranges,1)]
endfunction

" ------------------------------------------------
function! s:vimim_search_boundary(lines, keyboard)
" ------------------------------------------------
    if empty(a:lines) || empty(a:keyboard)
        return []
    endif
    let first_char_typed = strpart(a:keyboard,0,1)
    if s:datafile_has_period > 0 && first_char_typed == "."
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
        let ranges = ['datafile_is_not_sorted']
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
    let pattern = '^\(' . keyboard. '\)\@!'
    let result = match(a:lines, pattern, match_start)-1
    let words_limit = 128
    if result - match_start < 1
        return a:lines[match_start : match_end]
    endif
    if s:vimim_quick_key > 0
        let list_length = result - match_start
        let do_search_on_word = 0
        let quick_limit = 3
        if get(s:im['pinyin'],0) > 0
            let quick_limit = 2
        endif
        if len(keyboard) < quick_limit
        \|| list_length > words_limit*2
            let do_search_on_word = 1
        elseif get(s:im['pinyin'],0) > 0
            let chinese = join(a:lines[match_start : result],'')
            let chinese = substitute(chinese,'\p\+','','g')
            if len(chinese) > words_limit*4
                let do_search_on_word = 1
            endif
        endif
        if do_search_on_word > 0
            let pattern = '^\(' . keyboard . '\>\)\@!'
            let result = match(a:lines, pattern, match_start)-1
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
    let pattern = s:vimim_free_fuzzy_pattern(keyboard)
    let results = filter(a:lines, 'v:val =~ pattern')
    if s:vimim_datafile_has_english > 0
        call filter(results, 'v:val !~ "#$"')
    endif
    if s:chinese_input_mode < 2
        let results = s:vimim_filter(results, keyboard, 0)
    endif
    return results
endfunction

" --------------------------------------------
function! s:vimim_free_fuzzy_pattern(keyboard)
" --------------------------------------------
    let fuzzy = '.*'
    let fuzzies = join(split(a:keyboard,'\ze'), fuzzy)
    let pattern = '^' . fuzzies
    return pattern
endfunction

" -------------------------------------------------
function! s:vimim_filter(results, keyboard, length)
" -------------------------------------------------
    let results = a:results
    let filter_length = a:length
    if filter_length < 0
        return results
    endif
    " ---------------------------------------------
    let length = len((substitute(a:keyboard,'\A','','')))
    if empty(length) || &encoding != "utf-8"
        return results
    endif
    " ---------------------------------------------
    if empty(filter_length)
        if length < 5
            let filter_length = length
        endif
    endif
    " ---------------------------------------------
    if filter_length > 0
        let pattern = '\s\+.\{'. filter_length .'}$'
        call filter(results, 'v:val =~ pattern')
    endif
    return results
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
    \|| s:datafile_has_period > 0
    \|| len(s:private_matches) > 0
    \|| len(a:keyboard) < 2
        return 0
    endif
    " --------------------------------------------------
    if keyboard =~ '^\l\+\d\+'
        let msg = "[diy] ma7712li4002 => [mali,7712,4002]"
        return 0
    endif
    " --------------------------------------------------
    let keyboards = s:vimim_diy_keyboard2number(keyboard)
    if empty(keyboards)
        let msg = " mjads.xdhao.jdaaa "
    else
        return 0
    endif
    " --------------------------------------------------
    let blocks = []
    if get(s:im['wubi'],0) > 0
        let blocks = s:vimim_wubi_whole_match(keyboard)
    elseif get(s:im['4corner'],0) > 0
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
    " --------------------------------------------------
    return keyboard
endfunction

" -----------------------------------------------------
function! s:vimim_sentence_whole_match(lines, keyboard)
" -----------------------------------------------------
    let keyboard = a:keyboard
    if empty(a:lines)
    \|| keyboard =~ '\d'
    \|| len(keyboard) < 4
        return []
    endif
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
    return key
endfunction

" -------------------------------
function! g:vimim_ctrl_x_ctrl_u()
" -------------------------------
    let key = ''
    call s:reset_popupmenu_matched_list()
    let char_before = getline(".")[col(".")-2]
    if char_before =~# s:valid_key
        let key = '\<C-X>\<C-U>'
        if s:chinese_input_mode > 1
            call g:reset_after_auto_insert()
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
        \&& s:insert_without_popup > 0
            let s:insert_without_popup = 0
            let select_not_insert = '\<C-Y>'
        endif
    endif
    sil!exe 'sil!return "' . select_not_insert . '"'
endfunction

" ======================================= }}}
let VimIM = " ====  Datafile_Update  ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ----------------------------------------------
function! s:vimim_initialize_datafile_in_vimrc()
" ----------------------------------------------
    let datafile = s:vimim_datafile
    if !empty(datafile) && filereadable(datafile)
        let s:datafile_primary = copy(datafile)
    endif
    " ------------------------------------------
    let datafile = s:vimim_datafile_digital
    if !empty(datafile) && filereadable(datafile)
        if s:datafile_primary =~# 'pinyin'
            let s:datafile_secondary = copy(s:datafile_primary)
            let s:datafile_primary = copy(datafile)
            let s:pinyin_and_4corner = 1
        else
            let s:datafile_secondary = copy(datafile)
        endif
    endif
    " ------------------------------------------
    if s:vimim_datafile_has_pinyin > 0
    \&& s:vimim_datafile_has_4corner > 0
        let s:pinyin_and_4corner = 2
        let s:im['4corner'][0] = 1
        let s:im['pinyin'][0] = 1
    endif
    " ------------------------------------------
endfunction

" -------------------------------------------
function! s:vimim_get_new_order_list(chinese)
" -------------------------------------------
    if empty(s:matched_list)
        return []
    endif
    " --------------------------------
    let chinese = a:chinese
    let one_line_list = split(get(s:matched_list,0))
    let keyboard = get(one_line_list,0)
    let first_fix_candidate = get(one_line_list,1)
    " --------------------------------
    if keyboard !~# s:valid_key
    \|| char2nr(chinese) < 127
    \|| char2nr(first_fix_candidate) < 127
        return []
    endif
    " --------------------------------
    if first_fix_candidate ==# chinese
        return []
    endif
    let new_order_list = []
    let new_match_list = []
    for item in s:matched_list
        let one_line_list = split(item)
        let tail = get(one_line_list,-1)
        if tail == "#"
            continue
        endif
        let menu = get(one_line_list,0)
        if keyboard ==# menu
            let new_match_candidate = get(one_line_list,1)
            call add(new_match_list, new_match_candidate)
            call extend(new_order_list, one_line_list[1:])
        endif
    endfor
    if len(new_order_list) < 2
        let msg = "too short for new order list based on input"
        return []
    endif
    " --------------------------------
    let insert_index = 0
    if s:vimim_frequency_first_fix > 0
        let insert_index = 1
    endif
    " --------------------------------
    let used = match(new_order_list, chinese)
    if used < 0
        return []
    else
        let head = remove(new_order_list, used)
        call insert(new_order_list, head, insert_index)
    endif
    " -----------------------------------
    call insert(new_order_list, keyboard)
    " -----------------------------------
    return [new_order_list, new_match_list]
endfunction

" ---------------------------------------------------------
function! s:vimim_update_chinese_frequency_usage(both_list)
" ---------------------------------------------------------
    let new_list = get(a:both_list,0)
    if empty(new_list)
        let s:matched_list = []
        return
    endif
    " update data in memory based on past usage
    " (1/4) locate new order line based on user input
    " -----------------------------------------------
    let match_list = get(a:both_list,1)
    if empty(match_list) || empty(s:lines)
        return
    endif
    let keyboard = get(new_list,0)
    let pattern = '^' . keyboard . '\>'
    let insert_index = match(s:lines, pattern)
    if insert_index < 0
        return
    endif
    " (2/4) delete all but one matching lines
    " ---------------------------------------
    if len(match_list) < 2
        let msg = "only one matching line"
    else
        for item in match_list
            let pattern = '^' . keyboard . '\s\+' . item
            let remove_index = match(s:lines, pattern)
            if remove_index<0 || remove_index==insert_index
                let msg = "nothing to remove"
            else
                call remove(s:lines, remove_index)
            endif
        endfor
    endif
    " (3/4) insert new order list by replacement
    " ------------------------------------------
    let new_order_line = join(new_list)
    let s:lines[insert_index] = new_order_line
    " (4/4) sync datafile in memory to datafile on disk
    " -------------------------------------------------
    if s:chinese_frequency < 2
        return
    endif
    let auto_save = s:keyboard_count % s:chinese_frequency
    if auto_save > 0
        call s:vimim_save_to_disk(s:lines)
    endif
endfunction

" --------------------------------------------
function! s:vimim_reload_datafile(reload_flag)
" --------------------------------------------
    if empty(s:lines) || a:reload_flag > 0
        " ---------------------------------------------
        let s:lines = s:vimim_load_datafile(s:datafile)
        " ---------------------------------------------
        if s:pinyin_and_4corner == 1
            let pinyin = s:datafile_secondary
            let lines = s:vimim_load_datafile(pinyin)
            if empty(lines)
                let msg = "single digital ciku was used"
            else
                call extend(s:lines, lines, 0)
            endif
        endif
        " ---------------------------------------------
    endif
    return s:lines
endfunction

" ---------------------------------------
function! s:vimim_load_datafile(datafile)
" ---------------------------------------
    let lines = []
    if len(a:datafile) > 0
    \&& filereadable(a:datafile)
        let lines = readfile(a:datafile)
    endif
    return lines
endfunction

" -----------------------------------
function! s:vimim_save_to_disk(lines)
" -----------------------------------
    if empty(a:lines)
        return
    endif
    let s:lines = a:lines
    " -------------------------------
    if s:xingma_sleep_with_pinyin > 0
        if empty(s:toggle_xiangma_pinyin)
            let s:lines_primary = a:lines
        else
            let s:lines_secondary = a:lines
        endif
    endif
    " -------------------------------
    if filewritable(s:datafile)
        call writefile(a:lines, s:datafile)
    endif
endfunction

" ----------------------------------------
function! <SID>vimim_save_new_entry(entry)
" ----------------------------------------
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
        if menu !~# "[0-9a-z]"
            continue
        endif
        if char2nr(get(words,0)) < 128
            continue
        endif
        let line = menu .' '. join(words, ' ')
        let line = s:vimim_i18n_iconv(line)
        call add(entries, line)
    endfor
    if empty(entries)
        return
    endif
    call s:vimim_save_to_disk(s:vimim_insert_entry(entries))
endfunction

" -------------------------------------
function! s:vimim_insert_entry(entries)
" -------------------------------------
    if empty(a:entries)
        return []
    endif
    " --------------------------------
    call s:vimim_initialization_once()
    let lines = s:vimim_reload_datafile(0)
    " --------------------------------
    if empty(lines)
        return []
    endif
    let len_lines = len(lines)
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
    let s:lines_privates = []
    let s:private_matches = []
    if s:vimimdebug > 1
        let msg = "hide privacy during debug"
        return
    endif
    let datafile = s:path . "privates.txt"
    if !empty(s:vimim_datafile_private)
    \&& filereadable(s:vimim_datafile_private)
        let s:privates_datafile = s:vimim_datafile_private
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
    if empty(s:lines_privates) || a:reload_flag > 0
        let datafile = s:privates_datafile
        if filereadable(datafile)
            let s:lines_privates = readfile(datafile)
        endif
    endif
    return s:lines_privates
endfunction

" ======================================= }}}
let VimIM = " ====  VimIM_4Corner    ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ---------------------------------------------
function! s:vimim_4corner_whole_match(keyboard)
" ---------------------------------------------
    if s:chinese_input_mode > 1
    \|| a:keyboard !~ '\d'
    \|| len(a:keyboard)%4 != 0
        return []
    endif
    " -------------------------------
    " sijiaohaoma == 6021272260021762
    " -------------------------------
    let keyboards = split(a:keyboard, '\(.\{4}\)\zs')
    return keyboards
endfunction

" ----------------------------------------------------
function! s:vimim_build_reverse_4corner_cache(chinese)
" ----------------------------------------------------
    if s:only_4corner_or_12345 > 0
    \|| s:pinyin_and_4corner == 1
        let datafile = copy(s:datafile_primary)
        let s:four_corner_lines = s:vimim_load_datafile(datafile)
    elseif s:pinyin_and_4corner == 2
        let lines = s:vimim_reload_datafile(0)
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
    endif
    if empty(s:four_corner_lines)
        return {}
    endif
    " ------------------------------------------------
    let cache = {}
    let characters = split(a:chinese, '\zs')
    for line in s:four_corner_lines
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

" -----------------------------------
function! s:vimim_initialize_pinyin()
" -----------------------------------
    if empty(get(s:im['pinyin'],0))
        if s:vimim_datafile_has_pinyin > 0
            let s:im['pinyin'][0] = 1
        else
            return
        endif
    endif
    " -------------------------------
    let s:vimim_fuzzy_search = 1
    if empty(s:vimim_imode_pinyin)
        let s:vimim_imode_pinyin = 1
    endif
endfunction

" ------------------------------------
function! s:vimim_apostrophe(keyboard)
" ------------------------------------
    let keyboard = a:keyboard
    if empty(s:vimim_datafile_has_apostrophe)
        let keyboard = substitute(keyboard,"'",'','g')
    else
        let msg = "apostrophe is in the datafile"
    endif
    return keyboard
endfunction

" ======================================= }}}
let VimIM = " ====  VimIM_Shuangpin  ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" --------------------------------------
function! s:vimim_dictionary_shuangpin()
" --------------------------------------
    let s:shuangpin_flag = 1
    let key = 'shuangpin'
    let loaded = '双拼'
    let im = loaded . '：'
    let keycode = "[0-9a-z',.]"
    if s:vimim_shuangpin_abc > 0
        let im .= '智能ABC'
    elseif s:vimim_shuangpin_microsoft > 0
        let im .= '微软'
        let keycode = "[0-9a-z',.;]"
    elseif s:vimim_shuangpin_nature > 0
        let im .= "自然码"
    elseif s:vimim_shuangpin_plusplus > 0
        let im .= "拼音加加"
    elseif s:vimim_shuangpin_purple > 0
        let im .= "紫光"
        let keycode = "[0-9a-z',.;]"
    else
        let s:shuangpin_flag = 0
    endif
    let s:im[key]=[loaded, im, keycode]
endfunction

" --------------------------------------
function! s:vimim_initialize_shuangpin()
" --------------------------------------
    call s:vimim_dictionary_shuangpin()
    " ----------------------------------
    if empty(s:shuangpin_flag)
        return
    endif
    " ----------------------------------
    let s:vimim_fuzzy_search = 0
    let s:vimim_imode_pinyin = -1
    let rules = s:vimim_shuangpin_generic()
    " ----------------------------------
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

" ----------------------------------------------------
function! s:vimim_get_quanpin_from_shuangpin(keyboard)
" ----------------------------------------------------
    let keyboard = a:keyboard
    if empty(s:shuangpin_flag)
        return keyboard
    endif
    if empty(s:keyboard_shuangpin)
        let msg = "it is here to resume shuangpin"
    else
        return keyboard
    endif
    let keyboard2 = s:vimim_shuangpin_transform(keyboard)
    if s:vimimdebug > 0
        call s:debugs('shuangpin_in', keyboard)
        call s:debugs('shuangpin_out', keyboard2)
    endif
    if keyboard2 ==# keyboard
        let msg = "no point to do transform"
    else
        let s:keyboard_shuangpin = keyboard
        let s:keyboard_leading_zero = keyboard2
        let keyboard = keyboard2
    endif
    return keyboard
endfunction

" ---------------------------------------------
function! s:vimim_shuangpin_transform(keyboard)
" ---------------------------------------------
    let keyboard = a:keyboard
    if empty(s:keyboard_shuangpin)
        let msg = "start the magic shuangpin transform"
    else
        return keyboard
    endif
    let size = strlen(keyboard)
    let ptr = 0
    let output = ""
    while ptr < size
        if keyboard[ptr] !~ "[a-z;]"
            " bypass all non-characters, i.e. 0-9 and A-Z are bypassed
            let output .= keyboard[ptr]
            let ptr += 1
        else
            if keyboard[ptr+1] =~ "[a-z;]"
                let sp1 = keyboard[ptr].keyboard[ptr+1]
            else
                let sp1 = keyboard[ptr]
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

" ---------------------------------
function! s:vimim_initialize_erbi()
" ---------------------------------
    if empty(get(s:im['erbi'],0))
        return
    endif
    let s:im['wubi'][0] = 1
    let s:vimim_punctuation_navigation = -1
    let s:search_key_slash = -1
    let s:vimim_wildcard_search = -1
endfunction

" ------------------------------------------------
function! s:vimim_first_punctuation_erbi(keyboard)
" ------------------------------------------------
    let keyboard = a:keyboard
    if empty(get(s:im['erbi'],0))
        return 0
    endif
    " [erbi] the first .,/;' is punctuation
    " -------------------------------------
    let chinese_punctuatoin = 0
    if len(keyboard) == 1
    \&& keyboard =~ "[.,/;']"
    \&& has_key(s:punctuations_all, keyboard)
        let chinese_punctuatoin = s:punctuations_all[keyboard]
    endif
    return chinese_punctuatoin
endfunction

" ======================================= }}}
let VimIM = " ====  VimIM_Wubi       ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" --------------------------------------------
function! s:vimim_wubi_z_as_wildcard(keyboard)
" --------------------------------------------
    let keyboard = a:keyboard
    if s:vimim_wildcard_search < 1
    \|| s:chinese_input_mode > 1
        return 0
    endif
    let fuzzy_search_pattern = 0
    if match(keyboard,'z') > 0
        let fuzzies = keyboard
        if strpart(keyboard,0,2) != 'zz'
            let fuzzies = substitute(keyboard,'z','.','g')
        endif
        let fuzzy_search_pattern = '^' . fuzzies . '\>'
    endif
    return fuzzy_search_pattern
endfunction

" ------------------------------------
function! s:vimim_toggle_wubi_pinyin()
" ------------------------------------
    if empty(s:toggle_xiangma_pinyin)
        let s:im['wubi'][0] = 1
        let s:im['pinyin'][0] = 0
        let s:datafile = copy(s:datafile_primary)
        if empty(s:lines_primary)
            let s:lines_primary = s:vimim_reload_datafile(1)
        endif
        let s:lines = s:lines_primary
    " --------------------------------
    else
    " --------------------------------
        let s:im['pinyin'][0] = 1
        let s:im['wubi'][0] = 0
        let s:datafile = copy(s:datafile_secondary)
        if empty(s:lines_secondary)
            let s:lines_secondary = s:vimim_reload_datafile(1)
        endif
        let s:lines = s:lines_secondary
    endif
endfunction

" ------------------------------
function! s:vimim_wubi(keyboard)
" ------------------------------
    let keyboard = a:keyboard
    if empty(keyboard)
    \|| get(s:im['wubi'],0) < 1
    \|| get(s:im['pinyin'],0) > 0
        return []
    endif
    " ----------------------------
    let lines = s:vimim_datafile_range(keyboard)
    if empty(lines)
        return []
    endif
    " ----------------------------
    let pattern = s:vimim_wubi_z_as_wildcard(keyboard)
    if !empty(pattern)
        call filter(lines, 'v:val =~ pattern')
        return lines
    endif
    " ----------------------------
    " support wubi non-stop typing
    " ----------------------------
    if s:vimim_wubi_non_stop > 0
    \&& empty(get(s:im['pinyin'],0))
    \&& s:chinese_input_mode > 1
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
    \|| len(a:keyboard)%4 != 0
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
    if empty(s:datafile_primary)
        if (executable('wget') || executable('curl'))
            if empty(s:vimim_cloud_sogou)
                let s:vimim_cloud_sogou = 1
                return
            endif
        endif
    endif
    " Windows 'plug and play' (throw wget.exe to plugin directory)
    if has("win32") || has("win32unix")
        let wget = s:path . "wget.exe"
        if executable(wget)
            if empty(s:vimim_cloud_sogou)
                let s:vimim_cloud_sogou = 1
            endif
            let s:www_executable = wget
        endif
    endif
endfunction

" ----------------------------------
function! s:vimim_initialize_cloud()
" ----------------------------------
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
    " -------------------------------------
    if empty(s:www_executable)
        let s:vimim_cloud_sogou = 0
        let s:vimim_cloud_pim = 0
    endif
endfunction

" ------------------------------------
function! s:vimim_magic_tail(keyboard)
" ------------------------------------
    let keyboard = a:keyboard
    if s:chinese_input_mode > 0
        return 0
    endif
    if len(keyboard) < 3
        return 0
    endif
    if keyboard =~ '\d\d\d\d'
        let msg = "We play 4 corner by ourselves without Cloud."
        return 0
    endif
    let magic_tail = strpart(keyboard, len(keyboard)-1)
    let magic_tail_last_but_one = strpart(keyboard,len(keyboard)-2,1)
    let magic_tail_last_but_two = strpart(keyboard,len(keyboard)-3,1)
    if magic_tail_last_but_one ==# ','
    \&& magic_tail_last_but_two =~# '\l'
    \&& magic_tail =~# '\l'
        let keyboard = strpart(keyboard, 0, len(keyboard)-2)
        let keyboard = substitute(keyboard,'.',"&'",'g')
        let keyboard .= magic_tail . ','
        let magic_tail = ','
    endif
        " -----------------------------------------------
    if magic_tail ==# ','
        " -----------------------------------------------
        " <comma> double play in OneKey Mode:
        "   (1) after English (valid keys) => cloud at will
        "   (2) right before last English  => cloud and all-jianpin
        "   (3) before number              => magic imode
        " -----------------------------------------------
        let s:no_internet_connection = -1
    elseif magic_tail ==# '.'
        " -----------------------------------------------
        " <dot> double play in OneKey Mode:
        "   (1) after English (valid keys) => non-cloud at will
        "   (2) vimim_keyboard_dot_by_dot  => sentence match
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

" ------------------------------------------------
function! s:vimim_to_cloud_or_not(keyboard, cloud)
" ------------------------------------------------
    if a:cloud < 1
        return 0
    endif
    " --------------------------------------------
    if s:no_internet_connection > 1
        let msg = "oops, there is no internet connection."
        return 0
    elseif s:no_internet_connection < 0
        return 1
    endif
    " --------------------------------------------
    let keyboard = a:keyboard
    if empty(s:chinese_input_mode) && keyboard =~ '[.]'
        return 0
    endif
    if keyboard =~# "[^a-z']"
        let msg = "cloud limits to valid cloud keycodes only"
        return 0
    endif
    " --------------------------------------------
    let cloud_length = len(keyboard)
    if s:shuangpin_flag > 0
        let cloud_length = len(s:keyboard_shuangpin)
    endif
    let do_cloud = 1
    if cloud_length < a:cloud
        let do_cloud = 0
    endif
    return do_cloud
endfunction

" -----------------------------------------
function! s:vimim_get_cloud_sogou(keyboard)
" -----------------------------------------
    let keyboard = a:keyboard
    if s:vimim_cloud_sogou < 1
    \|| empty(s:www_executable)
    \|| empty(keyboard)
        return []
    endif
    let cloud = 'http://web.pinyin.sogou.com/web_ime/get_ajax/'
    " support apostrophe as delimiter to remove ambiguity
    " (1) examples: piao => pi'ao 皮袄  xian => xi'an 西安
    " (2) add double quotes between keyboard
    " (3) test: xi'anmeimeidepi'aosuifengpiaoyang
    let input = cloud . '"' . keyboard . '".key'
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
        let output = s:vimim_url_xx_to_chinese(output)
    endif
    if empty(output)
        return []
    endif
    " now, let's support Cloud for gb and big5
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
            let chinese = get(item_list,0)
            let english = strpart(keyboard, 0, get(item_list,1))
            let new_item = english . " " . chinese
            call add(menu, new_item)
        endif
    endfor
    " ----------------------------
    " ['woyouyigemeng 我有一个梦']
    " ----------------------------
    return menu
endfunction

" ======================================= }}}
let VimIM = " ====  VimIM_My_Cloud   ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" -------------------------------------------
function! s:vimim_initialize_mycloud_plugin()
" -------------------------------------------
    if empty(s:vimim_cloud_plugin)
        " -----------------------------------
        if has("unix") && !has("win32unix")
            let mes = "on linux, we do plug-n-play"
        else
            return
        endif
        " -----------------------------------
        let cloud = s:path . "mycloud/mycloud"
        if !executable(cloud)
            if !executable("python")
                return
            endif
            let cloud = "python " . cloud
        endif
        " -----------------------------------
        let ret = system(cloud . " __isvalid")
        if split(ret, "\t")[0] == "True"
            let s:vimim_cloud_plugin = cloud
        else
            return
        endif
    else
        " we do set-and-play on all systems
        let ret = system(s:vimim_cloud_plugin . " __isvalid")
        if split(ret, "\t")[0] == "True"
            let s:vimim_cloud_plugin = cloud
        else
            let s:vimim_cloud_plugin = 0
            return
        endif
    endif
    let ret = system(s:vimim_cloud_plugin . " __getname")
    let loaded = split(ret, "\t")[0]
    let ret = system(s:vimim_cloud_plugin . " __getkeychars")
    let keycode = split(ret, "\t")[0]
    if empty(keycode)
        let s:vimim_cloud_plugin = 0
    else
        let s:im['mycloud'][0] = loaded
        let s:im['mycloud'][2] = keycode
    endif
endfunction

" --------------------------------------------
function! s:vimim_get_mycloud_plugin(keyboard)
" --------------------------------------------
    if empty(s:vimim_cloud_plugin)
        return []
    endif
    let cloud = s:vimim_cloud_plugin
    let input = shellescape(a:keyboard)
    let output = 0
    " ---------------------------------------
    try
        let output = system(cloud . ' ' . input)
    catch /.*/
        let output = 0
    endtry
    if empty(output)
        return []
    endif
    return s:vimim_process_mycloud_output(a:keyboard, output)
endfunction

" -----------------------------------------
function! s:vimim_get_mycloud_www(keyboard)
" -----------------------------------------
    let keyboard = a:keyboard
    if s:vimim_cloud_pim < 1
    \|| empty(s:www_executable)
    \|| empty(keyboard)
        return []
    endif
    let cloud = "http://pim-cloud.appspot.com/abc/"
    let cloud = "http://pim-cloud.appspot.com/qp/"
    let input = keyboard
    let input = s:vimim_rot13(input)
    let input = cloud . input
    let output = 0
    " ----------------------------------------
    " http://pim-cloud.appspot.com/qp/chunmeng
    " ----------------------------------------
    try
        let output = system(s:www_executable . input)
    catch /.*/
        let output = 0
    endtry
    if empty(output)
        return []
    endif
    return s:vimim_process_mycloud_output(keyboard, output)
endfunction

" --------------------------------------------------------
function! s:vimim_process_mycloud_output(keyboard, output)
" --------------------------------------------------------
    let output = a:output
    if empty(output) || empty(a:keyboard)
        return []
    endif
    " ---------------------------------------
    " %E6%98%A5%E6%A2%A6	8	50_44
    " ---------------------------------------
    let menu = []
    for item in split(output, '\n')
        let item_list = split(item, '\t')
        let chinese = get(item_list,0)
        if s:vimim_cloud_pim > 0
            let chinese = s:vimim_rot13(chinese)
            let chinese = s:vimim_url_xx_to_chinese(chinese)
        endif
        if s:localization > 0
            let chinese = s:vimim_i18n_read(chinese)
        endif
        if empty(chinese)
            continue
        endif
        let extra_text = get(item_list,2)
        let english = strpart(a:keyboard, 0, get(item_list,1))
        let english .= '_' . extra_text
        let new_item = english . " " . chinese
        call add(menu, new_item)
    endfor
    return menu
endfunction

" -------------------------------------
function! s:vimim_url_xx_to_chinese(xx)
" -------------------------------------
    let input = a:xx
    let output = substitute(input, '%\(\x\x\)',
                \ '\=eval(''"\x''.submatch(1).''"'')','g')
    return output
endfunction

" -------------------------------
function! s:vimim_rot13(keyboard)
" -------------------------------
    let rot13 = a:keyboard
    let a = "12345abcdefghijklmABCDEFGHIJKLM"
    let z = "98760nopqrstuvwxyzNOPQRSTUVWXYZ"
    let rot13 = tr(rot13, a.z, z.a)
    return rot13
endfunction

" ======================================= }}}
let VimIM = " ====  VimIM_DIY        ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ----------------------------------------------
function! s:vimim_diy_lines_to_hash(fuzzy_lines)
" ----------------------------------------------
    if empty(a:fuzzy_lines)
        return {}
    endif
    let chinese_to_keyboard_hash = {}
    for line in a:fuzzy_lines
        let words = split(line)  |" shishi 事实 诗史
        let menu = get(words,0)  |" shishi
        for word in words
            if word != menu
                let chinese_to_keyboard_hash[word] = menu
            endif
        endfor
    endfor
    return chinese_to_keyboard_hash
endfunction

" ---------------------------------------------------------
function! s:vimim_diy_double_menu(h_0, h_1, h_2, keyboards)
" ---------------------------------------------------------
    if empty(a:h_0)  |" {'马力':'mali','名流':'mingliu'}
    \|| empty(a:h_1) |" {'马':'7712'}
        return []    |" {'力':'4002'}
    endif
    let values = []
    for key in keys(a:h_0)
        let char_first = key
        let char_last = key
        if len(key) > 1
            let char_first = strpart(key, 0, s:multibyte)
            let char_last = strpart(key, len(key)-s:multibyte)
        endif
        " --------------------------------------------
        if empty(a:h_2)
        \&& len(a:keyboards) == 2
        \&& has_key(a:h_1, char_last)               |" mali4002
            let menu_vary = a:h_0[key]              |" mali
            let menu_fix  = a:h_1[char_last]        |" 4002
            let menu = menu_fix.'　'.menu_vary      |" 4002 mali
            call add(values, menu." ".key)
        " --------------------------------------------
        elseif empty(a:h_2)
        \&& len(a:keyboards) == 3
        \&& has_key(a:h_1, char_first)              |" ma7712li
            let menu_vary = a:h_0[key]              |" mali
            let menu_fix  = a:h_1[char_first]       |" 7712
            let menu = menu_fix.'　'.menu_vary      |" 7712 mali
            call add(values, menu." ".key)
        " --------------------------------------------
        elseif has_key(a:h_1, char_first)
        \&& len(a:h_2) > 0
        \&& has_key(a:h_2, char_last)
            let menu_vary = a:h_0[key]              |" ml7740
            let menu_fix1 = a:h_1[char_first]       |" 7712
            let menu_fix2 = a:h_2[char_last]        |" 4002
            let menu_fix = menu_fix1.'　'.menu_fix2 |" 7712 4002
            let menu = menu_fix.'　'.menu_vary      |" 7712 4002 mali
            call add(values, menu." ".key)
        endif
    endfor
    return sort(values)
endfunction

" ----------------------------------------------------
function! s:vimim_quick_fuzzy_search(keyboard, filter)
" ----------------------------------------------------
    let keyboard = a:keyboard
    let filter = a:filter
    let results = s:vimim_datafile_range(keyboard)
    if empty(results)
        return []
    endif
    let pattern = '^' .  keyboard
    " ------------------------------------------------
    let has_digit = match(keyboard, '^\d\+')
    if has_digit < 0
        " --------------------------------------------
        if s:vimim_datafile_has_apostrophe > 0
            let pattern = '^' . keyboard . '\> '
            let whole_match = match(results, pattern)
            if  whole_match > 0
                let results = results[whole_match : whole_match]
                if len(results) > 0
                    return s:vimim_pair_list(results)
                endif
            endif
        endif
        " --------------------------------------------
        if filter == 1
            if len(keyboard) > 1
                let pattern .= '\>'
                let filter = -1
            endif
        elseif len(keyboard) == 2 && filter == 2
            let pattern .= '\>'
            let pattern = s:vimim_free_fuzzy_pattern(keyboard)
        endif
        if s:vimim_datafile_has_english > 0
            call filter(results, 'v:val !~ "#$"')
        endif
    else |" ------------------------------------------
        let msg = "leave room to play with digits"
        let filter = -1
        if get(s:im['4corner'],0) == 1001
            let msg = "another choice: top-left & bottom-right"
            let char_first = strpart(keyboard, 0, 1)
            let char_last  = strpart(keyboard, len(keyboard)-1)
            let pattern = '^' .  char_first . "\d\d" . char_last
        elseif get(s:im['4corner'],0) == 1289
            let msg = "for 5 stokes: first two and last two"
            let char_first = strpart(keyboard, 0, 2)
            let char_last  = strpart(keyboard, len(keyboard)-2)
            let pattern = '^' .  char_first . "\d\d" . char_last
        endif
    endif
    " -----------------------------------------------------------
    let results_pattern = filter(copy(results), 'v:val =~ pattern')
    if empty(results_pattern)
        let msg = "use 4corner as a filter for super jianpin"
        let pattern = s:vimim_free_fuzzy_pattern(keyboard)
        let results_pattern = filter(results, 'v:val =~ pattern')
    endif
    " -----------------------------------------------------------
    let results_length = s:vimim_filter(results_pattern, keyboard, filter)
    " -----------------------------------------------------------
    return s:vimim_i18n_read_list(results_length)
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

" ------------------------------------------
function! <SID>vimim_visual_ctrl_6(keyboard)
" ------------------------------------------
    let keyboard = a:keyboard
    if empty(keyboard)
        return
    endif
    " --------------------------------
    call s:vimim_initialization_once()
    " --------------------------------
    if s:vimim_ctrl_6_as_onekey > 0
        if keyboard =~ '\S'
            let msg = 'kill two birds with one stone'
        else
            let current_line = getline("'<")
            call <SID>vimim_save_new_entry(current_line)
            return
        endif
    endif
    " --------------------------------
    let results = []
    if keyboard !~ '\p'
        let results = s:vimim_reverse_lookup(keyboard)
    else
        call add(results, s:vimim_translator(keyboard))
    endif
    " --------------------------------
    let line = line(".")
    call setline(line, results)
    let new_positions = getpos(".")
    let new_positions[1] = line + len(results) - 1
    let new_positions[2] = len(get(split(get(results,-1)),0))+1
    call setpos(".", new_positions)
endfunction

" --------------------------------------
function! s:vimim_diy_keyboard(keyboard)
" --------------------------------------
    let keyboard = a:keyboard
    if empty(s:pinyin_and_4corner)
    \|| s:chinese_input_mode > 1
    \|| len(keyboard) < 2
    \|| keyboard !~# s:valid_key
    \|| keyboard =~# '^\d'
        return []
    endif
    let keyboards = []
    " ---------------------------------------
    " free style pinyin+4corner for zi and ci
    " ---------------------------------------
    let zi = "ma7712"
    let ci = "ma7712li4002 ma7712li"
    " --------------------------------------------------------------
    let alpha_keyboards = split(keyboard, '\d\+') |" => ['ma', 'li']
    let digit_keyboards = split(keyboard, '\D\+') |" => ['77', '40']
    " --------------------------------------------------------------
    let apostrophe = ""
    if s:vimim_datafile_has_apostrophe > 0
    \&& empty(s:shuangpin_flag)
        let apostrophe = "'"
    endif
    let alpha_string = join(alpha_keyboards, apostrophe)
    " --------------------------------------------------------------
    let keyboards = copy(digit_keyboards)
    call insert(keyboards, alpha_string) |" ma77li40=>['mali',77,40]
    if len(alpha_keyboards) > 1 && len(digit_keyboards) < 2
        call add(keyboards, "") |" ma7712li => ['mali', '7712', '']
    endif
    " --------------------------------------------------------------
    if len(keyboards) < 2
        let keyboards = []
    endif
    return keyboards
endfunction

" ---------------------------------------------
function! s:vimim_diy_keyboard2number(keyboard)
" ---------------------------------------------
    let keyboard = a:keyboard
    if empty(s:vimimdebug)
    \|| s:chinese_input_mode > 1
    \|| s:shuangpin_flag > 0
    \|| len(a:keyboard) < 5
    \|| len(a:keyboard) > 6
        return []
    endif
    " -----------------------------------------
    if a:keyboard =~ '\d' || a:keyboard !~ '\l'
        return []
    endif
    " -----------------------------------------
    let alphabet_length = 1
    if len(keyboard) == 5
        let zi = "mljjfo => ml7140 => ['ml', 71, 40]"
    elseif len(keyboard) == 6
        let ci = "mjjas  => m7712  => ['m', 7712]"
        let alphabet_length = 2
    else
        return []
    endif
    " -----------------------------------------
    let keyboards = []
    let tail = ''
    let head = strpart(keyboard, 0, alphabet_length)
    call add(keyboards, head)
    " ------------------------------------
    let diy_keyboard_asdfghjklo = {}
    let diy_keyboard_asdfghjklo['a'] = 1
    let diy_keyboard_asdfghjklo['s'] = 2
    let diy_keyboard_asdfghjklo['d'] = 3
    let diy_keyboard_asdfghjklo['f'] = 4
    let diy_keyboard_asdfghjklo['g'] = 5
    let diy_keyboard_asdfghjklo['h'] = 6
    let diy_keyboard_asdfghjklo['j'] = 7
    let diy_keyboard_asdfghjklo['k'] = 8
    let diy_keyboard_asdfghjklo['l'] = 9
    let diy_keyboard_asdfghjklo['o'] = 0
    " -----------------------------------------
    let four_corner = strpart(keyboard, alphabet_length)
    for char in split(four_corner, '\zs')
        if has_key(diy_keyboard_asdfghjklo, char)
            let digit = diy_keyboard_asdfghjklo[char]
            let tail .= digit
        else
            return []
        endif
    endfor
    if len(tail) != 4
        return []
    endif
    " -----------------------------------------
    if alphabet_length == 1
        call add(keyboards, tail)
    elseif alphabet_length == 2
        call add(keyboards, strpart(tail,0,2))
        call add(keyboards, strpart(tail,2,2))
    endif
    " -----------------------------------------
    return keyboards
endfunction

" -------------------------------------------
function! s:vimim_pinyin_and_4corer(keyboard)
" -------------------------------------------
    if empty(s:pinyin_and_4corner)
        return []
    endif
    let keyboard = a:keyboard
    let keyboards = s:vimim_diy_keyboard2number(keyboard)
    if empty(keyboards)
        let keyboards = s:vimim_diy_keyboard(keyboard)
        if s:vimimdebug > 0
            call s:debugs('diy_keyboard', keyboard)
            call s:debugs('diy_keyboards', s:debug_list(keyboards))
        endif
    else
        if s:vimimdebug > 0
            call s:debugs('diy_keyboard', keyboard)
            call s:debugs('diy_keyboard2number', s:debug_list(keyboards))
        endif
    endif
    let results = s:vimim_diy_results(keyboards, [])
    return results
endfunction

" --------------------------------------------------
function! s:vimim_diy_results(keyboards, cache_list)
" --------------------------------------------------
    let keyboards = a:keyboards
    if empty(s:pinyin_and_4corner)
    \|| s:chinese_input_mode > 1
    \|| len(keyboards) < 2
    \|| len(keyboards) > 3
        return []
    endif
    " --------------------------------------------------------
    let a = get(keyboards, 0) |"   ma mali   ma_li  ma_li  ml
    let b = get(keyboards, 1) |" 7712 7712   7712   7712   77
    let c = get(keyboards, 2) |"              ""    4002   40
    " --------------------------------------------------------
    let fuzzy_lines = []      |" ['mali 馬力']
    if len(keyboards) == 2    |" ['mali', '40']
        let fuzzy_lines = a:cache_list
        if empty(fuzzy_lines)
            let fuzzy_lines = s:vimim_quick_fuzzy_search(a, 1)
        endif
    elseif len(keyboards) == 3
        let fuzzy_lines = s:vimim_quick_fuzzy_search(a, 2)
    endif
    let h_0 = s:vimim_diy_lines_to_hash(fuzzy_lines)
    " ----------------------------------
    let fuzzy_lines = s:vimim_quick_fuzzy_search(b, 1)
    let h_1 = s:vimim_diy_lines_to_hash(fuzzy_lines)
    " ----------------------------------
    let h_2 = {}
    if len(keyboards) > 2
        let fuzzy_lines = s:vimim_quick_fuzzy_search(c, 1)
        let h_2 = s:vimim_diy_lines_to_hash(fuzzy_lines)
    endif
    " ----------------------------------
    let results = s:vimim_diy_double_menu(h_0, h_1, h_2, keyboards)
    return results
endfunction

" ======================================= }}}
let VimIM = " ====  Debug_Framework  ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" -------------------------------------
function! s:vimim_initialize_backdoor()
" -------------------------------------
    let s:datafile_primary = 0
    let s:datafile_secondary = 0
    let s:initialization_loaded = 0
    let s:chinese_mode_toggle_flag = 0
    let datafile_backdoor = s:path . "vimim.txt"
    " ------------------------------
    if filereadable(datafile_backdoor)
        let s:datafile_primary = datafile_backdoor
        let s:vimimdebug=1
        let s:vimim_ctrl_6_as_onekey=3
    endif
endfunction

" --------------------------------------------
function! s:vimim_initialize_vimim_txt_debug()
" --------------------------------------------
    if s:vimimdebug == 1
        let msg = "open backdoor for debugging"
        let s:vimim_custom_skin=1
        let s:vimim_datafile_has_english=1
        let s:vimim_datafile_has_pinyin=1
        let s:vimim_datafile_has_4corner=1
    else
        return
    endif
    " ------------------------------ debug
    let s:vimim_cloud_sogou=12
    let s:vimim_chinese_frequency=12
    " ------------------------------
    let s:vimim_cloud_pim=0
    let s:vimim_wildcard_search=1
    let s:vimim_imode_comma=1
    let s:vimim_imode_pinyin=-1
    let s:vimim_smart_ctrl_p=1
    let s:vimim_smart_ctrl_h=1
    let s:vimim_english_punctuation=0
    let s:vimim_chinese_punctuation=1
    let s:vimim_reverse_pageup_pagedown=1
    let s:vimim_unicode_lookup=0
    " ------------------------------
endfunction

" --------------------------------
function! s:vimim_egg_vimimdebug()
" --------------------------------
    let eggs = []
    for item in s:debugs
        let egg = ",,, "
        let egg .= item
        let egg .= "　"
        call add(eggs, egg)
    endfor
    if empty(eggs)
        let eggs = s:vimim_egg_vimimdefaults()
    endif
    return eggs
endfunction

" ----------------------------
function! s:debugs(key, value)
" ----------------------------
    let item = '['
    let item .= s:debug_count
    let item .= ']'
    let item .= a:key
    let item .= '='
    let item .= a:value
    call add(s:debugs, item)
endfunction

" -----------------------------
function! s:debug_list(results)
" -----------------------------
    let string_in = string(a:results)
    let length = 5
    let delimiter = ":"
    let string_out = join(split(string_in)[0 : length], delimiter)
    return string_out
endfunction

" -----------------------------
function! s:vimim_debug_reset()
" -----------------------------
    if s:vimimdebug > 0
        let max = 512
        if s:debug_count > max
            let s:debugs = s:debugs[0 : max]
        endif
    endif
endfunction

" ======================================= }}}
let VimIM = " ====  Core_Workflow    ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ------------------------------
function! s:vimim_i_setting_on()
" ------------------------------
    set completefunc=VimIM
    set completeopt=menuone
    set nolazyredraw
    set hlsearch
    set pumheight=10
endfunction

" -------------------------------
function! s:vimim_i_setting_off()
" -------------------------------
    let &cpo=s:saved_cpo
    let &iminsert=s:saved_iminsert
    let &completefunc=s:completefunc
    let &completeopt=s:completeopt
    let &lazyredraw=s:saved_lazyredraw
    let &hlsearch=s:saved_hlsearch
    let &pumheight=s:saved_pumheight
    let &statusline=s:saved_statusline
    let &laststatus=s:saved_laststatus
    let &ruler=s:saved_ruler
endfunction

" ----------------------------
function! s:vimim_start_omni()
" ----------------------------
    let s:menu_from_cloud_flag = 0
    let s:insert_without_popup = 0
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
    sil!call s:vimim_initialization_once()
    sil!call s:vimim_i_setting_on()
    sil!call s:vimim_super_reset()
    sil!call s:vimim_label_on()
    sil!call s:vimim_reload_datafile(1)
    let g:vimim[4] = localtime()
endfunction

" ----------------------
function! s:vimim_stop()
" ----------------------
    if empty(s:chinese_input_mode)
        sil!autocmd! onekey_mode_autocmd
    else
        sil!autocmd! chinese_mode_autocmd
    endif
    sil!call s:vimim_i_setting_off()
    sil!call s:vimim_super_reset()
    sil!call s:vimim_debug_reset()
    sil!call s:vimim_i_map_off()
    let duration = localtime() - get(g:vimim,4)
    let g:vimim[3] += duration
endfunction

" ---------------------------------
function! s:reset_before_anything()
" ---------------------------------
    call s:reset_matched_list()
    let s:chinese_input_mode = 0
    let s:no_internet_connection = 0
    let s:chinese_mode_toggle_flag = 0
    let s:pattern_not_found = 0
    let s:keyboard_count += 1
    let s:chinese_punctuation = (s:vimim_chinese_punctuation+1)%2
endfunction

" ----------------------------------------
function! s:reset_popupmenu_matched_list()
" ----------------------------------------
    let s:menu_4corner_filter = -1
    let s:pageup_pagedown = 0
    let s:popupmenu_matched_list = []
endfunction

" ------------------------------
function! s:reset_matched_list()
" ------------------------------
    call s:reset_popupmenu_matched_list()
    let s:matched_list = []
endfunction

" ------------------------------
function! s:reset_after_insert()
" ------------------------------
    let s:seamless_positions = []
    call g:reset_after_auto_insert()
endfunction

" -----------------------------------
function! g:reset_after_auto_insert()
" -----------------------------------
    let s:keyboard_leading_zero = 0
    let s:keyboard_shuangpin = 0
    let s:keyboard_wubi = ''
    let s:smart_ctrl_n = 0
    let s:smart_ctrl_p = 0
    let s:smart_enter = 0
    let s:smart_backspace = 0
    let s:one_key_correction = 0
    return ""
endfunction

" ------------------------------------
function! g:vimim_reset_after_insert()
" ------------------------------------
    if pumvisible()
        return ""
    endif
    " --------------------------------
    let chinese = s:vimim_popup_word()
    let g:vimim[2] += (len(chinese)/s:multibyte)
    if s:chinese_frequency > 0
        let both_list = s:vimim_get_new_order_list(chinese)
        call s:vimim_update_chinese_frequency_usage(both_list)
    endif
    " --------------------------------
    call s:reset_matched_list()
    call g:reset_after_auto_insert()
    " --------------------------------
    if empty(s:vimim_sexy_onekey)
    \&& empty(s:chinese_input_mode)
        call s:vimim_stop()
    endif
    " --------------------------------
    return ""
endfunction

" ---------------------------
function! s:vimim_i_map_off()
" ---------------------------
    let unmap_list = range(0,9)
    call extend(unmap_list, s:valid_keys)
    call extend(unmap_list, keys(s:punctuations))
    call extend(unmap_list, ['<CR>', '<BS>', '<Esc>', '<Space>'])
    call extend(unmap_list, ['<C-N>', '<C-P>', '<C-H>'])
    " -----------------------
    for _ in unmap_list
        sil!exe 'iunmap '. _
    endfor
    " -----------------------
endfunction

" -----------------------------------
function! s:vimim_helper_mapping_on()
" -----------------------------------
    if s:chinese_input_mode < 2
        if s:vimim_smart_ctrl_h > 0
            inoremap<silent><C-H> <C-R>=<SID>vimim_smart_ctrl_h()<CR>
        endif
        if s:vimim_smart_ctrl_n > 0
            inoremap<silent><C-N> <C-R>=<SID>vimim_smart_ctrl_n()<CR>
        endif
        if s:vimim_smart_ctrl_p > 0
            inoremap<silent><C-P> <C-R>=<SID>vimim_smart_ctrl_p()<CR>
        endif
    endif
    " ----------------------------------------------------------
    if s:chinese_input_mode > 0 || s:vimim_sexy_onekey > 0
        inoremap<silent><CR>  <C-R>=g:vimim_pumvisible_ctrl_e()<CR>
                              \<C-R>=<SID>vimim_smart_enter()<CR>
    endif
    " ----------------------------------------------------------
    if empty(s:vimim_ctrl_6_as_onekey)
        inoremap<silent><Esc>  <C-R>=g:vimim_pumvisible_ctrl_e()<CR>
                              \<C-R>=g:vimim_one_key_correction()<CR>
    endif
    " ----------------------------------------------------------
    inoremap<silent><BS>  <C-R>=g:vimim_pumvisible_ctrl_e()<CR>
                         \<C-R>=<SID>vimim_ctrl_x_ctrl_u_bs()<CR>
    " ----------------------------------------------------------
endfunction

" ======================================= }}}
let VimIM = " ====  Core_Engine      ==== {{{"
" ===========================================
call add(s:vimims, VimIM)

" ------------------------------
function! VimIM(start, keyboard)
" ------------------------------
if a:start

    call s:vimim_start_omni()
    let current_positions = getpos(".")
    let start_column = current_positions[2]-1
    let start_column_save = start_column
    let start_row = current_positions[1]
    let current_line = getline(start_row)
    let char_before = current_line[start_column-1]
    let char_before_before = current_line[start_column-2]

    " get one char when input-memory is used
    " --------------------------------------
    if s:smart_ctrl_n > 0
        if start_column > 0
            let start_column -= 1
            let s:start_column_before = start_column
            return start_column
        endif
    endif

    " support natural sentence input with space
    " -----------------------------------------
    if empty(s:chinese_input_mode)
    \&& char_before ==# "."
    \&& char_before_before =~# "[0-9a-z]"
        let match_start = match(current_line, '\w\+\s\+\p\+\.$')
        if match_start > -1
            let s:sentence_with_space_input = 1
            return match_start
        endif
    endif

    " take care of seamless english/chinese input
    " -------------------------------------------
    let seamless_column = s:vimim_get_seamless(current_positions)
    if seamless_column < 0
        let msg = "no need to set seamless"
    else
        let s:start_column_before = seamless_column
        return seamless_column
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
    elseif s:only_4corner_or_12345 > 0
        let msg = "need to build the best digial input method"
    else
        let start_column = last_seen_nonsense_column
    endif

    let s:start_row_before = start_row
    let s:current_positions = current_positions
    let len = current_positions[2]-1 - start_column
    let s:keyboard_leading_zero = strpart(current_line,start_column,len)

    let s:start_column_before = start_column
    return start_column

else

    if s:vimimdebug > 0
        let s:debug_count += 1
        call s:debugs('keyboard', s:keyboard_leading_zero)
        if s:vimimdebug > 2
            call s:debugs('keyboard_a', a:keyboard)
        endif
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
        if len(keyboard) == 1
        \&& keyboard !~# '\w'
            return
        endif
    endif

    " use cached list when input-memory is used
    " -----------------------------------------
    if s:smart_ctrl_n > 0
        let results = s:vimim_get_list_from_smart_ctrl_n(keyboard)
        if !empty(results)
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " use all cached list when input-memory is used
    " ---------------------------------------------
    if s:smart_ctrl_p > 0
        let results = s:vimim_get_list_from_smart_ctrl_p(keyboard)
        if !empty(results)
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " [record] keep track of all valid inputs
    " ---------------------------------------
    if keyboard !~ '\s'
        let g:vimim[0] .=  keyboard . "."
        let g:vimim[1] +=  len(keyboard)
    endif

    " [eggs] hunt classic easter egg ... vim<C-\>
    " -------------------------------------------
    if keyboard =~# "^vim" || keyboard ==# ",,"
        let results = s:vimim_easter_chicken(keyboard)
        if len(results) > 0
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " use cached list when pageup/pagedown or 4corner is used
    " -------------------------------------------------------
    if s:vimim_punctuation_navigation > -1
        if empty(s:popupmenu_matched_list)
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

    " [mycloud] get chunmeng from mycloud local
    " -----------------------------------------
    if empty(s:vimim_cloud_plugin)
        let msg = "keep local mycloud code for the future."
    else
        let results = s:vimim_get_mycloud_plugin(keyboard)
        if empty(len(results))
            let s:vimim_cloud_plugin = 0
        else
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " [mycloud] get chunmeng from mycloud www
    " ---------------------------------------
    let cloud = s:vimim_cloud_pim
    let cloud = s:vimim_to_cloud_or_not(keyboard, cloud)
    if cloud > 0
        let results = s:vimim_get_mycloud_www(keyboard)
        if len(results) > 0
            return s:vimim_popupmenu_list(results)
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

    " [imode] magic comma: English number => Chinese number
    " -----------------------------------------------------
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

    " process magic english comma and dot at the end
    " (1) english comma for always cloud
    " (2) english period for always non-cloud
    " ----------------------------------------------
    let keyboard2 = s:vimim_magic_tail(keyboard)
    if empty(keyboard2)
        let msg = "who cares about such a magic?"
    else
        let keyboard = keyboard2
    endif

    " [wubi][erbi] plays with pinyin in harmony
    " -----------------------------------------
    if s:xingma_sleep_with_pinyin > 0
        call s:vimim_toggle_wubi_pinyin()
    endif

    " [shuangpin] support 5 major shuangpin with various rules
    " --------------------------------------------------------
    let keyboard = s:vimim_get_quanpin_from_shuangpin(keyboard)

    " [cloud] to make cloud come true for woyouyigemeng
    " -------------------------------------------------
    let cloud = s:vimim_cloud_sogou
    let cloud = s:vimim_to_cloud_or_not(keyboard, cloud)
    if cloud > 0
        let results = s:vimim_get_cloud_sogou(keyboard)
        if s:vimimdebug > 0
            call s:debugs('cloud_stone', keyboard)
            call s:debugs('cloud_gold', s:debug_list(results))
        endif
        if empty(len(results))
            if s:vimim_cloud_sogou > 2
                let s:no_internet_connection += 1
            endif
        else
            let s:no_internet_connection = 0
            let s:menu_from_cloud_flag = 1
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " [erbi] special meaning of the first punctuation
    " -----------------------------------------------
    if s:im['erbi'][0] > 0
        let punctuation = s:vimim_first_punctuation_erbi(keyboard)
        if !empty(punctuation)
            return [punctuation]
        endif
    endif

    " [wubi] support wubi non-stop input
    " ----------------------------------
    if get(s:im['wubi'],0) > 0
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
    if s:privates_flag > 0
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

    " [wildcard search] explicit fuzzy search
    " ----------------------------------------
    if s:vimim_wildcard_search > 0
        let results = s:vimim_wildcard_search(keyboard, lines)
        if len(results) > 0
            let results = s:vimim_pair_list(results)
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " escape literal dot if [array][phonetic][erbi]
    " ---------------------------------------------
    if s:datafile_has_period > 0
        let keyboard = substitute(keyboard,'\.','\\.','g')
    endif

    " [modeless] english sentence input =>  i have a dream.
    " -----------------------------------------------------
    if empty(s:chinese_input_mode)
        if s:sentence_with_space_input > 0
            if keyboard =~ '\s'
            \&& empty(s:datafile_has_period)
            \&& len(keyboard) > 3
                let keyboard = substitute(keyboard, '\s\+', '.', 'g')
            endif
            let s:sentence_with_space_input = 0
        endif
    endif

    " [apostrophe] in pinyin datafile
    " -------------------------------
    let keyboard = s:vimim_apostrophe(keyboard)
    let s:keyboard_leading_zero = keyboard

    " break up dot-separated sentence
    " -------------------------------
    if keyboard =~# '[.]'
        let keyboards = split(keyboard, '[.]')
        if len(keyboards) > 0
            let msg = "enjoy.1010.2523.4498.7429.girl"
            let keyboard = get(keyboards, 0)
        endif
    endif

    " now it is time to do regular expression matching
    " ------------------------------------------------
    let pattern = "\\C" . "^" . keyboard
    let match_start = match(lines, pattern)

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
        if empty(keyboard2)
            let msg = 'sell keyboard as is'
        else
            if s:vimimdebug > 0
                call s:debugs('keyboard_in', keyboard)
                call s:debugs('keyboard_out', keyboard2)
            endif
            let keyboard = keyboard2
            let pattern = "\\C" . "^" . keyboard
            let match_start = match(lines, pattern)
        endif
    endif

    " [DIY] "Do It Yourself" couple IM: pinyin+4corner
    " ------------------------------------------------
    if match_start < 0
        let results = s:vimim_pinyin_and_4corer(keyboard)
        if len(results) > 0
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " [pinyin_quote_sogou] try exact one-line match
    " ---------------------------------------------
    if match_start > -1
    \&& get(s:im['pinyin'],0) > 0
    \&& s:vimim_datafile_has_apostrophe > 0
        let pattern = '^' . keyboard . '\> '
        let whole_match = match(lines, pattern)
        if  whole_match > 0
            let results = lines[whole_match : whole_match]
            if len(results) > 0
                let results = s:vimim_pair_list(results)
                return s:vimim_popupmenu_list(results)
            endif
        endif
    endif

    " do exact match search on sorted datafile
    " ----------------------------------------
    if match_start > -1
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

    " [cloud] never give up trying whole cloud
    " ----------------------------------------
    if s:vimim_cloud_sogou == 1
        let results = s:vimim_get_cloud_sogou(keyboard)
        if len(results) > 0
            return s:vimim_popupmenu_list(results)
        endif
    endif

    " [seamless] support seamless English input
    " -----------------------------------------
    if match_start < 0
        call <SID>vimim_set_seamless()
        let s:pattern_not_found += 1
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
    sil!call s:vimim_visual_mapping_on()
    " ----------------------------------
    if empty(s:vimim_ctrl_6_as_onekey)
        sil!call s:vimim_chinese_mode_mapping_on()
    elseif s:vimim_ctrl_6_as_onekey > 1
        let s:vimim_tab_as_onekey = 1
    endif
    " ----------------------------------
    sil!call s:vimim_onekey_mapping_on()
    " ----------------------------------
endfunction

" -----------------------------------
function! s:vimim_visual_mapping_on()
" -----------------------------------
    if !hasmapto('<C-^>', 'v')
        xnoremap<silent><C-^> y:call <SID>vimim_visual_ctrl_6(@0)<CR>
    endif
    " ---------------------------
    if s:vimim_save_new_entry > 0
    \&& !hasmapto('<C-\>', 'v')
    \&& empty(s:vimim_ctrl_6_as_onekey)
        xnoremap<silent><C-\> :y<CR>:call <SID>vimim_save_new_entry(@0)<CR>
    endif
endfunction

" -----------------------------------------
function! s:vimim_chinese_mode_mapping_on()
" -----------------------------------------
    inoremap<silent><expr><Plug>VimimChineseToggle <SID>vimim_toggle_ctrl_6()
    " -----------------------------------------------------------------------
    imap <silent><C-^> <Plug>VimimChineseToggle
    if s:vimim_ctrl_space_as_ctrl_6 > 0 && has("gui_running")
        imap<silent> <C-Space> <Plug>VimimChineseToggle
    endif
endfunction

" -----------------------------------
function! s:vimim_onekey_mapping_on()
" -----------------------------------
    inoremap<silent><expr><Plug>VimimOneKey <SID>vimim_start_onekey()
    " ---------------------------------------------------------------
    if empty(s:vimim_ctrl_6_as_onekey)
        if empty(s:vimim_tab_as_onekey)
            imap<silent> <C-\> <Plug>VimimOneKey
        else
            imap<silent> <Tab> <Plug>VimimOneKey
            inoremap<silent> <C-\> <Tab>
        endif
    " --------------------------------------
    else
    " --------------------------------------
        imap<silent><C-^> <Plug>VimimOneKey
        if s:vimim_tab_as_onekey > 0
            imap<silent> <Tab> <C-^>
        endif
        if s:vimim_ctrl_6_as_onekey > 2
            nmap<silent><C-^> bEa<C-^>
        endif
    " --------------------------------------
    endif
endfunction

" ------------------------------------
function! s:vimim_onekey_mapping_off()
" ------------------------------------
    if empty(s:vimim_tab_as_onekey)
        iunmap <C-\>
    else
        iunmap <Tab>
    endif
endfunction

silent!call s:vimim_initialize_global()
silent!call s:vimim_initialize_backdoor()
silent!call s:vimim_initialize_mapping()
" ====================================== }}}
