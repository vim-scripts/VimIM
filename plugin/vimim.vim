" ==================================================
"              " VimIM —— Vim 中文输入法 "
" --------------------------------------------------
"  VimIM -- Input Method by Vim, of Vim, for Vimmers
" ==================================================

" URL:   http://vim.sourceforge.net/scripts/script.php?script_id=2506
" Group: http://groups.google.com/group/vimim
" Data:  http://code.google.com/p/vimim/downloads/list
" Demo:  http://maxiangjiang.googlepages.com/vimim.html
" Code:  http://maxiangjiang.googlepages.com/vimim.vim.html

" ====  VimIM Introduction    ==== {{{
" ====================================
"      File: vimim.vim
"    Author: Sean Ma <vimim@googlegroups.com>
"   License: GNU Lesser General Public License
"    Latest: 20090828T234820
" -----------------------------------------------------------
"    Readme: VimIM is a Vim plugin designed as an independent IM
"            (Input Method) to support the input of multi-byte.
"            It can be used as yet another way to input non-ascii
"            using OneKey in addition to built-in i_<C-V> and i_<C-K>.
"            VimIM aims to complete the Vim as the greatest editor.
" -----------------------------------------------------------
"  Features: * "Plug & Play"
"            * It can be used as yet another way to input non-ascii.
"            * It is independent of Operating System.
"            * It is independent of Vim mbyte-XIM/mbyte-IME API.
"            * The "OneKey" can input Chinese without mode change.
"            * The "static"  Chinese Input Mode smooths mixture input.
"            * The "dynamic" Chinese Input Mode uses sexy input style.
"            * Support "Pin Yin", "Wu Bi", "Cang Jie", "Four Corner" ...
"            * Support 5 different ways of doing "Double Pinyin"
"            * Support word matching on "word segmentation"
"            * Support "multi-byte search" using search key '/' or '?'.
"            * Support "fuzzy search" and "wildcard search"
"            * Support popup menu navigation using "vi key" (hjkl)
"            * Support dynamical lookup of keycode and unicode
"            * Support direct "unicode input" using integer or hex
"            * Support direct "GBK input" and "Big5 input"
"            * Support "non-stop-typing" for Wubi as well as 4Corner
"            * Support dynamical creation and update of new entries
"            * Support dynamical adjust menu order over usage frequency
"            * Support auto processing a private datafile, if existed
"            * Support intelligent editing keys (CTRL-H, BS, Enter)
"            * Support "do it yourself" input method defined by users
"            * Support Plug & Play "couple IM" using Pinyin and 4Corner
"            * Support open, simple and flexible data file format
" -----------------------------------------------------------
" EasterEgg: (1) (Neither data file nor configuration needed)
"            (2) (in Vim Command-line Mode, type:)   :source %<CR>
"            (3) (in Vim Insert Mode, type 4 chars:) vim<C-\>
" -----------------------------------------------------------
"   Install: (1) download a data file of your choice from Data link above
"            (2) drop vimim.vim and the data file to the plugin directory
" -----------------------------------------------------------
" Usage (1): [in Insert Mode] "to insert/search Chinese ad hoc":
"            # to insert: type keycode and hit <C-\> to trigger
"            # to search: hit '/' or '?' from popup menu
" Usage (2): [in Insert Mode] "to type Chinese continuously":
"            # hit <C-^> to toggle to Chinese Input Mode:
"              (2.1) [dynamic] mode: any valid key code => Chinese
"              (2.2) [static]  mode: Space=>Chinese  Enter=>English
" -----------------------------------------------------------

" ================================ }}}
" ====  VimIM Instruction     ==== {{{
" ====================================

" -------------
" "Design Goal"
" -------------
" # Chinese can be input using Vim regardless of encoding
" # Without negative impact to Vim if VimIM is not used
" # No compromise for high speed and low memory usage
" # Making the best use of Vim for popular input methods
" # Most VimIM options are activated based on input methods
" # All  VimIM options can be explicitly disabled at will

" ---------------
" "VimIM Options"
" ---------------
" Detailed usages of all options can be found from Demo URL above

"   VimIM "OneKey", without mode change
"   - use OneKey to insert multi-byte candidates
"   - use OneKey to search multi-byte using "/" or "?"
"   - use OneKey to insert Unicode/GBK/Big5, integer or hex
"   - use OneKey to input Chinese sentence as we do for English
"   The default key is <C-\> (Vim Insert Mode)

"   VimIM "Chinese Input Mode"
"   - [dynamic mode] show dynamic menu as one types
"   - [static mode] <Space> => Chinese  <Enter> => English
"   - <Esc> key is in consistent with Vim
"   The default key is <C-^> (Vim Insert Mode)

" # To enable VimIM "Default Off" Options, for example
"   --------------------------------------------------
"   let g:vimim_fuzzy_search=1
"   let g:vimim_static_input_style=1
"
" # To disable VimIM "Default On" Options, for example
"   --------------------------------------------------
"   let g:vimim_internal_code_input=0
"   let g:vimim_match_dot_after_dot=0

" -----------------
" "VimIM Data File"
" -----------------
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
if exists("b:loaded_vimim") || &cp || v:version < 700
    finish
endif
let b:loaded_vimim=1
let s:path=expand("<sfile>:p:h")."/"
scriptencoding utf-8

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
    " -----------------------------------------
    call s:vimim_initialize_datafile_4corner()
    call s:vimim_initialize_datafile_pinyin()
    call s:vimim_initialize_diy_pinyin_4corner()
    " -----------------------------------------
    call s:vimim_initialize_double_pinyin()
    call s:vimim_initialize_datafile_wubi()
    call s:vimim_initialize_valid_keys()
    " -----------------------------------------
    call s:vimim_initialize_color()
    call s:vimim_initialize_encoding()
    call s:vimim_initialize_punctuations()
    call s:vimim_initialize_quantifiers()
    " -----------------------------------------
endfunction

" -----------------------------------
function! s:vimim_initialize_global()
" -----------------------------------
    let G = []
    call add(G, "g:vimim_auto_spell")
    call add(G, "g:vimim_datafile")
    call add(G, "g:vimim_diy_pinyin_4corner")
    call add(G, "g:vimim_double_pinyin_abc")
    call add(G, "g:vimim_double_pinyin_microsoft")
    call add(G, "g:vimim_double_pinyin_nature")
    call add(G, "g:vimim_double_pinyin_plusplus")
    call add(G, "g:vimim_double_pinyin_purple")
    call add(G, "g:vimim_fuzzy_search")
    call add(G, "g:vimim_fuzzy_double_pinyin")
    call add(G, "g:vimim_match_word_after_word")
    call add(G, "g:vimim_menu_color")
    call add(G, "g:vimim_menu_extra_text")
    call add(G, "g:vimim_number_as_navigation")
    call add(G, "g:vimim_punctuation_navigation")
    call add(G, "g:vimim_reverse_pageup_pagedown")
    call add(G, "g:vimim_save_input_history_frequency")
    call add(G, "g:vimim_sexy_input_style")
    call add(G, "g:vimim_smart_punctuation")
    call add(G, "g:vimim_static_input_style")
    call add(G, "g:vimim_tab_for_one_key")
    call add(G, "g:vimim_unicode_lookup")
    call add(G, "g:vimim_wildcard_search")
    " -----------------------------------
    call s:vimim_set_global_default(G, 0)
    " -----------------------------------
    let G = []
    call add(G, "g:vimim_auto_copy_clipboard")
    call add(G, "g:vimim_chinese_input_mode")
    call add(G, "g:vimim_chinese_punctuation")
    call add(G, "g:vimim_dynamic_mode_autocmd")
    call add(G, "g:vimim_english_input_on_enter")
    call add(G, "g:vimim_first_candidate_fix")
    call add(G, "g:vimim_match_dot_after_dot")
    call add(G, "g:vimim_hjkl_navigation")
    call add(G, "g:vimim_menu_label")
    call add(G, "g:vimim_one_key")
    call add(G, "g:vimim_quick_key")
    call add(G, "g:vimim_save_new_entry")
    call add(G, "g:vimim_seamless_english_input")
    call add(G, "g:vimim_do_search")
    call add(G, "g:vimim_smart_delete_keys")
    call add(G, "g:vimim_internal_code_input")
    call add(G, "g:vimim_wubi_non_stop")
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
    let s:saved_ignorecase=&ignorecase
    let s:saved_pumheight=&pumheight
endfunction

" ------------------------------------
function! s:vimim_initialize_session()
" ------------------------------------
    let s:wubi_flag = 0
    let s:pinyin_flag = 0
    let s:privates_flag = 0
    let s:four_corner_flag = 0
    let s:english_flag = 0
    " --------------------------------
    let s:current_datafile = 0
    let s:current_datafile_has_dot_key = 0
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
    " --------------------------------
    let s:insert_without_popup_flag = 0
    let s:trash_code_flag = 0
    let s:onekey_loaded_flag = 0
    let s:number_typed_flag = 0
    " --------------------------------
    let s:backspace = 0
    let s:keyboard_sentences = []
    let s:keyboard_sentences_flag = 0
    " --------------------------------
    let s:keyboard_leading_zero = ''
    let s:keyboard_counts = 0
    let s:keyboards = ['', '']
    " --------------------------------
    let s:start_positions   = [0,0,1,0]
    let s:current_positions = [0,0,1,0]
    let s:lines_datafile = []
    let s:alphabet_lines = []
    " --------------------------------
    call g:vimim_set_seamless()
    " --------------------------------
endfunction

" ----------------------------------
function! s:vimim_initialize_color()
" ----------------------------------
    if empty(s:vimim_menu_color)
        highlight! link PmenuSel  Title
        highlight! Pmenu          NONE
        highlight! PmenuSbar	  NONE
        highlight! PmenuThumb	  NONE
        if s:vimim_menu_color < 0
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
    if !empty(datafile)
        return
    endif
    " --------------------------------------
    let input_methods = []
    call add(input_methods, "pinyin_fcitx")
    call add(input_methods, "pinyin_huge")
    call add(input_methods, "pinyin")
    call add(input_methods, "phonetic")
    call add(input_methods, "erbi")
    call add(input_methods, "nature")
    call add(input_methods, "cangjie")
    call add(input_methods, "quick")
    call add(input_methods, "array30")
    call add(input_methods, "wubi")
    call add(input_methods, "wubi98")
    call add(input_methods, "wubijd")
    call add(input_methods, "english")
    call add(input_methods, "4corner")
    call add(input_methods, "privates")
    call map(input_methods, '"vimim." . v:val . ".txt"')
    call add(input_methods, debug)
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
        if datafile =~? 'wubi'
            let s:wubi_flag = 1
        elseif datafile =~? 'pinyin'
            let s:pinyin_flag = 1
        elseif datafile =~? 'english'
            let s:english_flag = 1
        elseif datafile =~? '4corner'
            let s:four_corner_flag = 2
        elseif datafile =~? 'privates'
            let s:privates_flag = 2
        endif
        let s:current_datafile = datafile
    endif
endfunction

" ------------------------------
function! g:vimim_set_seamless()
" ------------------------------
    let s:seamless_positions = []
    if s:vimim_seamless_english_input > 0
        let s:seamless_positions = getpos(".")
    endif
    return ""
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
    let key = "[0-9a-z]"
    let input_method = s:current_datafile
    " -----------------------------------
    if input_method =~ 'phonetic'
        let s:current_datafile_has_dot_key = 1
        let key = "[0-9a-z.,;/\-]"
    elseif input_method =~ 'array'
        let s:current_datafile_has_dot_key = 1
        let key = "[a-z.,;/]"
    elseif input_method =~ 'erbi'
        let s:current_datafile_has_dot_key = 1
        let key = "[a-z;,./']"
    elseif input_method =~ 'nature'
        let key = "[a-z']"
    endif
    " -----------------------------------
    if s:four_corner_flag > 1 && empty(s:privates_flag)
        let key = "[0-9']"
    elseif s:pinyin_flag == 1
        let key = '[0-9a-z.]'
    elseif s:pinyin_flag == 2
        let key = '[a-z;']'
    elseif s:wubi_flag > 0
        let key = '[a-z]'
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
    let easter_eggs += ["vim   最牛文字編輯器"]
    let easter_eggs += ["vim   精力 生氣"]
    let easter_eggs += ["vimim 中文輸入法"]
    let results = s:vimim_pair_list(easter_eggs)
    return s:vimim_popupmenu_list(results)
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
    " ----------------- example:
    " dictionary 字典 #
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

" ----------------------------------------
function! s:vimim_initialize_quantifiers()
" ----------------------------------------
    let s:quantifiers = {}
    if empty(s:pinyin_flag)
        return
    endif
    let s:quantifiers['1'] = '一壹㈠①⒈⑴Ⅰ甲'
    let s:quantifiers['2'] = '二贰㈡②⒉⑵Ⅱ乙'
    let s:quantifiers['3'] = '三叁㈢③⒊⑶Ⅲ丙'
    let s:quantifiers['4'] = '四肆㈣④⒋⑷Ⅳ丁'
    let s:quantifiers['5'] = '五伍㈤⑤⒌⑸Ⅴ戊'
    let s:quantifiers['6'] = '六陆㈥⑥⒍⑹Ⅵ己'
    let s:quantifiers['7'] = '七柒㈦⑦⒎⑺Ⅶ庚'
    let s:quantifiers['8'] = '八捌㈧⑧⒏⑻Ⅷ辛'
    let s:quantifiers['9'] = '九玖㈨⑨⒐⑼Ⅸ壬'
    let s:quantifiers['0'] = '〇零㈩⑩⒑⑽Ⅹ癸'
    let s:quantifiers['a'] = '秒'
    let s:quantifiers['b'] = '百佰把班包杯本笔部'
    let s:quantifiers['c'] = '厘餐场串次处'
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
    let s:quantifiers['y'] = '月叶亿'
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
    let keyboard = strpart(a:keyboard,1)
    if keyboard !~ '^\d\+'
    \&& len(substitute(keyboard,'\d','','')) > 1
        return []
    endif
    " ------------------------------------
    let digit_alpha = keyboard
    if keyboard =~# '^\d*\l\{1}$'
        let digit_alpha = strpart(keyboard,0,len(keyboard)-1)
    elseif keyboard =~# '^\d*$'
        let digit_alpha = strpart(keyboard,0)
    endif
    " ------------------------------------
    let keyboards = split(digit_alpha, '\ze')
    let i = strpart(a:keyboard,0,1)
    let chinese_number = s:vimim_get_chinese_number(keyboards, i)
    if empty(chinese_number)
        return []
    endif
    let chinese = [chinese_number]
    let last_char = strpart(keyboard,len(keyboard)-1,1)
    if !empty(last_char) && has_key(s:quantifiers, last_char)
        let quantifier = s:quantifiers[last_char]
        let quantifiers = split(quantifier, '\zs')
        if keyboard =~# '^\d*\l\{1}$'
            let chinese = map(copy(quantifiers), 'chinese_number . v:val')
            if last_char == 'd'  |" i2d => 二第 => 第二
                let chinese[0] = join(reverse(split(chinese[0],'\zs')),'')
            endif
        elseif keyboard =~# '^\d*$' && len(keyboards)<2 && i==#'i'
            let chinese = quantifiers
        endif
    endif
    if len(chinese) == 1
        let s:insert_without_popup_flag = 1
    endif
    return chinese
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
    if s:current_datafile =~? "chinese"
        let datafile_fenc_chinese = 1
    endif
    " ------------ ----------------- ----
    " vim encoding datafile encoding code
    " ------------ ----------------- ----
    "   utf-8          utf-8          0
    "   utf-8          chinese        1
    "   chinese        utf-8          2
    "   chinese        chinese        8
    " ------------ ----------------- ----
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
    elseif len(a:lines) > 0
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
    else |" support direct unicode insert by 22221 or u808f
    " -----------------------------------------------------
        if keyboard =~ '^\d\{5}$'     "| 32911
            let numbers = [str2nr(keyboard)]
        elseif keyboard =~ '\x\{4}$'  "| 808f
            let four_hex   = match(keyboard, '^\x\{4}$')
            let four_digit = match(keyboard, '^\d\{4}$')
            if four_hex == 0 && four_digit < 0
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
endfunction

" ================================ }}}
" ====  VimIM OneKey          ==== {{{
" ====================================

" ---------------------------
function! s:vimim_onekey_on()
" ---------------------------
    set noignorecase
    set nolazyredraw
    set hlsearch
    let &pumheight=9
endfunction

" ----------------------------
function! s:vimim_onekey_off()
" ----------------------------
    let &lazyredraw=s:saved_lazyredraw
    let &hlsearch=s:saved_hlsearch
    let &ignorecase=s:saved_ignorecase
    let &pumheight=s:saved_pumheight
endfunction

" ---------------------------
function! <SID>vimim_onekey()
" ---------------------------
    let s:chinese_input_mode = 0
    let s:keyboard_sentences = []
    let s:keyboard_sentences_flag = 0
    call s:vimim_onekey_on()
    if empty(s:onekey_loaded_flag)
        let s:onekey_loaded_flag = 1
        call s:vimim_label_on()
        call s:vimim_punctuation_navigation_on()
        call s:vimim_hjkl_navigation_on()
        inoremap<silent><Space> <C-R>=g:vimim_space_key_onekey()<CR>
    endif
    let onekey = ""
    if pumvisible()
        let onekey = s:vimim_keyboard_block_by_block()
    else
        let onekey = s:vimim_smart_punctuation(s:punctuations, "\t")
        if empty(onekey)
            let onekey = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . onekey . '"'
endfunction

" -----------------------------------
function! g:vimim_space_key_for_yes()
" -----------------------------------
    let space = ''
    if pumvisible()
        let space = s:vimim_keyboard_block_by_block()
        if empty(s:chinese_input_mode)
            sil!call s:vimim_onekey_off()
        endif
        sil!call g:vimim_reset_after_insert()
    else
        let space = ' '
    endif
    sil!exe 'sil!return "' . space . '"'
endfunction

" ----------------------------------
function! g:vimim_space_key_onekey()
" ----------------------------------
    let space = ' '
    if pumvisible()
        let space = s:vimim_keyboard_block_by_block()
        sil!call s:vimim_onekey_off()
        sil!call g:vimim_reset_after_insert()
        sil!exe 'sil!return "' . space . '"'
    else
        let s:backspace = 0
        if s:insert_without_popup_flag > 0
            let s:insert_without_popup_flag = 0
            let space = ""
        endif
    endif
    return space
endfunction

" -----------------------------------
function! g:vimim_space_key_dynamic()
" -----------------------------------
    let space = ' '
    if pumvisible()
        let space = s:vimim_keyboard_block_by_block()
        sil!call g:vimim_reset_after_insert()
        sil!exe 'sil!return "' . space . '"'
    else
        let space = s:vimim_smart_punctuation(s:punctuations, space)
        if empty(space)
            let space = ' '
        endif
    endif
    return space
endfunction

" ----------------------------------
function! g:vimim_space_key_static()
" ----------------------------------
    let space = " "
    if pumvisible()
        let space = s:vimim_keyboard_block_by_block()
        call g:vimim_reset_after_insert()
    else
        let s:backspace = 0
        let space = s:vimim_smart_punctuation(s:punctuations, space)
        if empty(space)
            let space = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        endif
        if s:pattern_not_found > 0
            let s:pattern_not_found = 0
            let space = " "
        endif
    endif
    sil!exe 'sil!return "' . space . '"'
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
    if pumvisible()
        if n == 0
        \&& empty(s:keyboard_sentences)
        \&& empty(s:keyboard_sentences_flag)
            call g:vimim_reset_after_insert()
            let zero = '\<C-E>\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
            sil!exe 'sil!return "' . zero . '"'
        else
            let start = ""
            let end = ""
            if empty(s:vimim_number_as_navigation)
                if empty(s:chinese_input_mode)
                    call s:vimim_onekey_off()
                endif
                let start = ''
                if empty(s:keyboard_sentences)
                \&& empty(s:keyboard_sentences_flag)
                    let start = '\<C-E>\<C-X>\<C-U>'
                endif
                let end = s:vimim_keyboard_block_by_block()
                let n -= 1
            endif
            let counts = repeat("\<Down>", n)
            sil!exe 'sil!return "' . start . counts . end . '"'
        endif
    else
        let s:number_typed_flag = 1
        let s:seamless_positions = []
        let s:backspace = 0
        return a:n
    endif
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
        elseif a:key =~ "[,.=\-]"
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

" ------------------------------------
function! g:vimim_copy_popup_chinese()
" ------------------------------------
    let chinese = s:vimim_popup_chinese(s:start_column_before)
    return s:vimim_clipboard_register(chinese)
endfunction

" -----------------------------------
function! g:vimim_cut_popup_chinese()
" -----------------------------------
    let chinese = s:vimim_popup_chinese(s:start_column_before)
    call s:vimim_clipboard_register(chinese)
    return s:vimim_remove_popup_chinese(chinese)
endfunction

" -------------------------------------------
function! s:vimim_clipboard_register(chinese)
" -------------------------------------------
    if len(a:chinese) > 0
        if s:vimim_auto_copy_clipboard>0 && has("gui_running")
            let @+ = a:chinese
        else
            let @0 = a:chinese
        endif
    endif
    return "\<Esc>"
endfunction

" -------------------------------------------
function! s:vimim_popup_chinese(column_start)
" -------------------------------------------
    let column_end = col('.') - 1
    let range = column_end - a:column_start
    let current_line = getline(".")
    let chinese = strpart(current_line, a:column_start, range)
    if chinese =~ '\w'
        let chinese = ''
    endif
    return chinese
endfunction

" ================================ }}}
" ====  VimIM Chinese Mode    ==== {{{
" ====================================

" ---------------------------
function! <SID>vimim_toggle()
" ---------------------------
    set nopaste
    if s:chinese_insert_flag < 1
        sil!call s:vimim_insert_on()
    else
        sil!call s:vimim_insert_off()
    endif
    if s:vimim_dynamic_mode_autocmd > 0 && has("autocmd")
        if !exists("s:dynamic_mode_autocmd_loaded")
            let s:dynamic_mode_autocmd_loaded = 1
            sil!autocmd InsertEnter sil!call s:vimim_insert_on()
            sil!autocmd InsertLeave sil!call s:vimim_insert_off()
            sil!autocmd BufUnload   autocmd! InsertEnter,InsertLeave
        endif
    endif
    sil!return "\<C-O>:redraw\<CR>"
endfunction

" ------------------------------------
function! s:vimim_hjkl_navigation_on()
" ------------------------------------
    if s:vimim_hjkl_navigation < 1 || s:chinese_input_mode > 1
        return
    endif
    " hjkl navigation for onekey and static
    let hjkl_list = split('hjklegGycx', '\zs')
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
            let hjkl .= '\<C-R>=g:vimim_copy_popup_chinese()\<CR>'
        elseif a:key == 'x'
            let hjkl  = '\<C-R>=g:vimim_space_key_for_yes()\<CR>'
            let hjkl .= '\<C-R>=g:vimim_cut_popup_chinese()\<CR>'
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

" ---------------------------
function! s:vimim_insert_on()
" ---------------------------
    if s:vimim_static_input_style > 0
        let s:chinese_input_mode = 1 |" static_input (default off)
        " ============================
        inoremap<silent> <Space> <C-R>=g:vimim_space_key_static()<CR>
        sil!call s:vimim_hjkl_navigation_on()
    else
        let s:chinese_input_mode = 2 |" dynamic_input (default on)
        " ============================
        inoremap<silent> <Space>
        \ <C-R>=g:vimim_space_key_dynamic()<CR>
        \<C-R>=g:vimim_ctrl_x_ctrl_u()<CR>
        " ----------------------------
        let valid_keys = copy(s:valid_keys)
        call remove(valid_keys, match(valid_keys,"[.]"))
        for char in valid_keys
            sil!exe 'inoremap<silent> ' . char . '
            \ <C-R>=<SID>vimim_dynamic_End()<CR>'. char .
            \'<C-R>=g:vimim_ctrl_x_ctrl_u()<CR>'
        endfor
        " ----------------------------
    endif
    sil!call s:vimim_insert_for_both_static_dynamic()
    sil!call s:vimim_one_key_mapping_off()
endfunction

" ----------------------------
function! s:vimim_insert_off()
" ----------------------------
    let s:onekey_loaded_flag = 0
    let s:chinese_insert_flag = 0
    let s:chinese_input_mode = 0
    " ------------------------
    call g:vimim_reset_after_insert()
    call s:vimim_chinese_mode_setting_off()
    call s:vimim_iunmap()
    call s:vimim_one_key_mapping_on()
    " ------------------------
    if s:vimim_auto_copy_clipboard>0 && has("gui_running")
        sil!exe ':%y +'
    endif
    " ------------------------
endfunction

" ------------------------------------------------
function! s:vimim_insert_for_both_static_dynamic()
" ------------------------------------------------
    let s:chinese_insert_flag = 1
    sil!call g:vimim_set_seamless()
    sil!call s:vimim_chinese_mode_setting_on()
    sil!call s:vimim_label_on()
    " --------------------------------------
    if s:vimim_smart_delete_keys > 0
        sil!call s:vimim_smart_delete_key_mapping()
    endif
    " --------------------------------------
    if s:vimim_english_input_on_enter > 0
        inoremap<silent><expr> <CR> <SID>smart_enter()
    endif
    " --------------------------------------
    sil!inoremap<silent><expr><C-\> <SID>vimim_toggle_punctuation()
    sil!return <SID>vimim_toggle_punctuation()
    " --------------------------------------
endfunction

" --------------------------------
function! <SID>vimim_dynamic_End()
" --------------------------------
    let end = ""
    if pumvisible()
        let end = "\<C-E>"
        if s:wubi_flag > 0
        \&& s:vimim_wubi_non_stop > 0
        \&& len(s:keyboard_wubi)%4 == 0
            let end = "\<C-Y>"
        endif
    endif
    sil!exe 'sil!return "' . end . '"'
endfunction

" ------------------------
function! s:vimim_iunmap()
" ------------------------
    for _ in range(0,9)
        sil!exe 'iunmap '. _
    endfor
    " ----------------------------
    for _ in s:valid_keys
        sil!exe 'iunmap ' . _
    endfor
    " ----------------------------
    for _ in keys(s:punctuations)
        sil!exe 'iunmap '. _
    endfor
    " ----------------------------
    if !hasmapto('<C-W>', 'i')
        iunmap <C-W>
    endif
    if !hasmapto('<C-U>', 'i')
        iunmap <C-U>
    endif
    if !hasmapto('<C-H>', 'i')
        iunmap <C-H>
    endif
    " ----------------------------
    iunmap <CR>
    iunmap <BS>
    iunmap <Space>
endfunction

" -----------------------------------------
function! s:vimim_chinese_mode_setting_on()
" -----------------------------------------
    call s:vimim_onekey_on()
    set cpo&vim
    let &l:iminsert=1
    highlight! lCursor guifg=bg guibg=green
endfunction

" ------------------------------------------
function! s:vimim_chinese_mode_setting_off()
" ------------------------------------------
    call s:vimim_onekey_off()
    let &cpo=s:saved_cpo
    let &l:iminsert=0
    highlight lCursor NONE
endfunction

" ================================ }}}
" ====  VimIM Punctuations    ==== {{{
" ====================================

" -----------------------------------------
function! s:vimim_initialize_punctuations()
" -----------------------------------------
    let s:punctuations = {}
    let s:punctuations['#']='＃'
    let s:punctuations['%']='％'
    let s:punctuations['$']='￥'
    let s:punctuations['&']='※'
    let s:punctuations['!']='！'
    let s:punctuations['~']='～'
    let s:punctuations['+']='＋'
    let s:punctuations['*']='﹡'
    let s:punctuations['\']='、'
    let s:punctuations['@']='・'
    let s:punctuations[':']='：'
    let s:punctuations['(']='（'
    let s:punctuations[')']='）'
    let s:punctuations['{']='『'
    let s:punctuations['}']='』'
    let s:punctuations['[']='【'
    let s:punctuations[']']='】'
    let s:punctuations["'"]="“"
    let s:punctuations['"']="”"
    let s:punctuations['^']='……'
    let s:punctuations['_']='——'
    let s:punctuations['<']='《'
    let s:punctuations['>']='》'
    let s:punctuations['-']='－'
    let s:punctuations['=']='＝'
    let s:punctuations[';']='；'
    let s:punctuations['.']='。'
    let s:punctuations[',']='，'
    if empty(s:vimim_do_search)
        let s:punctuations['?']='？'
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
    for _ in keys(s:punctuations)
        sil!exe 'inoremap<silent><expr> '._.'
        \ <SID>vimim_punctuation_mapping("'._.'")'
    endfor
endfunction

" -------------------------------------------
function! s:vimim_punctuation_navigation_on()
" -------------------------------------------
    if empty(s:vimim_punctuation_navigation)
        return
    endif
    let hjkl_list = split(',.=-;?/[]','\zs')
    for _ in hjkl_list
        sil!exe 'inoremap<silent><expr> '._.'
        \ <SID>vimim_punctuations_navigation("'._.'")'
    endfor
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
        if char_before !~ '\d'
            let value = s:punctuations[value]
        endif
    endif
    return value
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

" ----------------------------------------------------
function! s:vimim_smart_punctuation(punctuations, key)
" ----------------------------------------------------
    if empty(s:vimim_smart_punctuation)
    \&& s:chinese_input_mode > 0
        return 0
    endif
    let key = ""
    let current_positions = getpos(".")
    let start_column = current_positions[2]-1
    let current_line = getline(current_positions[1])
    let char_before = current_line[start_column-1]
    let char_before_before = current_line[start_column-2]
    if (char_before_before =~ '\W' || char_before_before == '')
    \&& has_key(a:punctuations, char_before)
        let replacement = a:punctuations[char_before]
        let key = "\<BS>" . replacement
    elseif char_before !~ s:valid_key
        let key = a:key
    endif
    return key
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
    if empty(s:vimim_do_search)
        return ""
    endif
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

" --------------------------
function! <SID>smart_enter()
" --------------------------
    let first_slash = s:vimim_first_char_current_line()
    " --------------------------------------------
    " first do search if line starting with / or ?
    " --------------------------------------------
    if len(first_slash) > 0
        let slash = '\<C-R>=g:vimim_slash_search()\<CR>'
        let slash .= first_slash . '\<CR>'
        sil!exe 'sil!return "' . slash . '"'
    endif
    " -------------------------------------
    " otherwise, try seamless Chinese input
    " -------------------------------------
    sil!call g:vimim_set_seamless()
    let key = "\<CR>"
    if pumvisible()
        let key = "\<C-E>"
        if s:vimim_seamless_english_input < 1
            let key .= " "
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
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

" ---------------------------------------------
function! s:vimim_remove_popup_chinese(chinese)
" ---------------------------------------------
    if empty(a:chinese) || char2nr(a:chinese) < 127
        return ""
    endif
    let repeat_times = len(a:chinese)/s:multibyte
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
        " -----------------------------------------
        " case 1: search from popup menu, all modes
        " -----------------------------------------
        let chinese = s:vimim_popup_chinese(s:start_column_before)
        call s:vimim_slash_register(chinese)
        return s:vimim_remove_popup_chinese(chinese)
    else
        " -------------------------------------------
        " case 2: search by Enter with leading / or ?
        " -------------------------------------------
        let current_line = getline(".")
        let column_start = match(current_line,'[/?]') + 1
        let chinese = s:vimim_popup_chinese(column_start)
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
        if a:offset == 0
            let delete_char = "\<Right>\<BS>【".chinese."】\<Left>"
        endif
    endif
    return delete_char
endfunction

" ------------------------------------
function! <SID>vimim_smart_backspace()
" ------------------------------------
    let key = '\<BS>'
    if pumvisible()
        if s:chinese_input_mode < 2
        \&& len(s:keyboard_sentences) > 0
            let s:keyboard_sentences = []
            let s:keyboard_sentences_flag = 0
            let s:backspace += 1
            if s:backspace == 1
                let key = '\<C-E>\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
            elseif s:backspace == 2
                let s:backspace = 0
                let key = "\<C-E>"
            endif
            sil!exe 'sil!return "' . key . '"'
        elseif s:chinese_input_mode > 0
            let key .= '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
            let s:keyboard_wubi = ''
            let s:seamless_positions = []
        endif
    elseif s:pattern_not_found > 0
        let s:pattern_not_found = 0
    elseif s:chinese_input_mode > 0
        let key .= '\<C-R>=g:vimim_set_seamless()\<CR>'
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ---------------------------------
function! <SID>vimim_smart_ctrl_u()
" ---------------------------------
    let key = "\<C-U>"
    if !pumvisible()
        let key .= '\<C-R>=g:vimim_set_seamless()\<CR>'
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ---------------------------------
function! <SID>vimim_smart_ctrl_w()
" ---------------------------------
    let key = "\<C-W>"
    let key .= '\<C-R>=g:vimim_set_seamless()\<CR>'
    sil!exe 'sil!return "' . key . '"'
endfunction

" ---------------------------------
function! <SID>vimim_smart_ctrl_h()
" ---------------------------------
    let key = "\<BS>"
    if pumvisible()
        let key .= '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        let s:keyboard_wubi = ''
        let s:seamless_positions = []
    else
        let key = s:vimim_bs_for_trash()
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ------------------------------
function! s:vimim_bs_for_trash()
" ------------------------------
    let key = "\<BS>"
    let char_before = getline(".")[col(".")-2]
    if char_before =~ s:valid_key
        if s:pattern_not_found > 0
            let s:pattern_not_found = 0
            if  s:chinese_input_mode > 1
                let s:keyboard_wubi = ''
                let s:seamless_positions = []
                let s:trash_code_flag = 1
                let key = "\<C-X>\<C-U>\<BS>"
            endif
        endif
    endif
    return key
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
    let s:pageup_pagedown = 0
    let s:menu_reverse = 0
    let s:keyboard_wubi = ''
    let s:seamless_positions = []
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
        if abs(shift) >= length
            let s:pageup_pagedown = 0
            return matched_list
        endif
        let partition = shift
        if shift < 0
            let partition = length-abs(shift)
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
    " ----------------------
    for pair in matched_list
    " ----------------------
        let complete_items = {}
        let pairs = split(pair)
        if len(pairs) < 2
            continue
        endif
        let menu = get(pairs, 0)
        let chinese = get(pairs, 1)
        if s:vimim_menu_extra_text > 0
            let display = menu
            if s:four_corner_unicode_flag > 0
            \&& empty(match(display,'^\d\{4}$'))
                let unicode = printf('u%04x', char2nr(chinese))
                let display = menu.'　'.unicode
            endif
            let complete_items["menu"] = display
        endif
        if s:unicode_menu_display_flag > 0
            let complete_items["menu"] = menu
        endif
        let complete_items["word"] = chinese
        if s:vimim_menu_label > 0
            let abbr = printf('%2s',label) . "\t" . chinese
            let complete_items["abbr"] = abbr
        endif
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
    if s:current_datafile_has_dot_key > 0
    \&& first_char_typed == "."
        let first_char_typed = '\.'
    endif
    let patterns = '^' . first_char_typed
    let match_start = match(a:lines, patterns)
    if match_start < 0
        return []
    endif
    " add boundary to datafile search by one letter only
    " --------------------------------------------------
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
    if empty(a:keyboard) || empty(a:lines)
        return []
    endif
    let words_limit = 128
    let match_start = a:start
    let match_end = match_start
    let patterns = '^\(' . a:keyboard . '\)\@!'
    let result = match(a:lines, patterns, match_start)-1
    if result - match_start < 1
        return a:lines[match_start : match_end]
    endif
    if s:vimim_quick_key > 0
        let list_length = result - match_start
        let do_search_on_word = 0
        let quick_limit = 2
        if len(a:keyboard) < quick_limit
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
            let patterns = '^\(' . a:keyboard . '\>\)\@!'
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
    if empty(a:keyboard) || empty(a:lines)
        return []
    endif
    let patterns = s:vimim_fuzzy_pattern(a:keyboard)
    let results = filter(a:lines, 'v:val =~ patterns')
    if s:english_flag > 0
        call filter(results, 'v:val !~ "#$"')
    endif
    if s:chinese_input_mode < 2
        let results = s:vimim_filter(results, a:keyboard)
    endif
    return results
endfunction

" ---------------------------------------
function! s:vimim_fuzzy_pattern(keyboard)
" ---------------------------------------
    let keyboard = a:keyboard
    let fuzzy = '\l\+'
    if s:vimim_fuzzy_double_pinyin(keyboard) > 0
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

" -----------------------------------------
function! s:vimim_filter(results, keyboard)
" -----------------------------------------
    let results = a:results
    let length = len((substitute(a:keyboard,'\A','','')))
    if empty(length) || &encoding != "utf-8"
        return a:results
    endif
    let filter_length = 0
    if s:vimim_fuzzy_double_pinyin(a:keyboard) > 0
        let filter_length = length/2 |" 4_char => 2_chinese
    elseif length < 5                |" 4_char => 4_chinese
        let filter_length = length
    endif
    if filter_length > 0
        let patterns = '\s\+.\{'. filter_length .'}$'
        call filter(results, 'v:val =~ patterns')
    endif
    return results
endfunction

" ---------------------------------------------
function! s:vimim_fuzzy_double_pinyin(keyboard)
" ---------------------------------------------
    if empty(s:vimim_fuzzy_double_pinyin)
    \|| empty(s:pinyin_flag)
    \|| len(a:keyboard) < 4
        return 0
    endif
    let sheng_mu = "[aeiouv]"
    let fuzzy_double_pinyin = 0
    let keyboards = split(a:keyboard, '\(..\)\zs')
    for key in keyboards
        if len(key) < 2
            continue
        endif
        let char = get(split(key,'\zs'),0)
        if char =~ sheng_mu
            let fuzzy_double_pinyin = 0
            break
        endif
        let char = get(split(key,'\zs'),1)
        if char !~ sheng_mu
            let fuzzy_double_pinyin = 0
            break
        endif
        let fuzzy_double_pinyin = 1
    endfor
    return fuzzy_double_pinyin
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
    \|| s:current_datafile_has_dot_key > 0
    \|| s:privates_flag > 1
    \|| len(s:private_matches) > 0
    \|| len(a:keyboard) < 4
        return keyboard
    endif
    let blocks = []
    let keyboard_lastpart = "."
    if keyboard =~ '[.]'
        " step 1: try to break up dot-separated sentence
        " ----------------------------------------------
        let blocks = s:vimim_keyboard_dot_by_dot(keyboard)
        if len(blocks) > 1
            let keyboard = remove(blocks, 0)
            let keyboard_lastpart .= join(blocks, '.')
        endif
    endif
    let match_start = match(a:lines, '^'.keyboard)
    if match_start < 0 && keyboard !~ '[.]'
        " step 2: try to match DIY 4corner || pinyin+4corner
        " --------------------------------------------------
        if s:wubi_flag > 0
            let blocks = s:vimim_wubi_whole_match(keyboard)
        elseif s:four_corner_flag > 0
            let blocks = s:vimim_4corner_whole_match(keyboard)
        endif
        " --------------------------------------------------
        if empty(blocks)
            let blocks = s:vimim_diy_whole_match(keyboard)
        endif
        " --------------------------------------------------
        if empty(blocks)
            " step 3: try to break up long whole sentence
            let blocks = s:vimim_sentence_whole_match(a:lines, keyboard)
            if len(blocks) > 0
                let s:keyboard_sentences_flag = 0
            endif
        endif
        " --------------------------------------------------
        if len(blocks) == 1
            return get(blocks, 0)
        elseif len(blocks) > 1
            let keyboard = join(blocks, '.')
        endif
        " --------------------------------------------------
    endif
    if a:keyboard =~ '[.]'
        let keyboard .= keyboard_lastpart
    endif
    if keyboard =~ '[.]'
        " step 4: now break up dot-separated sentence again
        " -------------------------------------------------
        let blocks = s:vimim_keyboard_dot_by_dot(keyboard)
    endif
    " initialize session variable, if it is the first time
    if empty(s:keyboard_sentences)
    \&& empty(s:keyboard_sentences_flag)
        let s:keyboard_sentences = blocks
    endif
    " support demo combination: enjoy.1010252344987429.girl
    if s:keyboard_sentences_flag > 0 && len(blocks) > 0
        call extend(s:keyboard_sentences, blocks, 0)
        let s:keyboard_sentences_flag = 0
    endif
    if empty(s:keyboard_sentences)
        let s:keyboard_sentences_flag = 0
    else
        let s:keyboard_sentences_flag += 1
        " take out keyboard only if it is the first time
        if s:keyboard_sentences_flag == 1
            let keyboard = remove(s:keyboard_sentences, 0)
        endif
    endif
    return keyboard
endfunction

" ---------------------------------------------
function! s:vimim_keyboard_dot_by_dot(keyboard)
" ---------------------------------------------
    if empty(s:vimim_match_dot_after_dot)
    \|| len(a:keyboard) < 3
    \|| a:keyboard =~ '^[.]'
    \|| a:keyboard =~ '[.]$'
        return []
    endif
    " --------------------------------------------------------
    " demo meet.teacher.say.hello.sssjj.zdolo.hhyy.sloso.nfofo
    " --------------------------------------------------------
    let keyboards = split(a:keyboard, '[.]')
    if len(keyboards) < 2
        let keyboards = []
    endif
    return keyboards
endfunction

" -----------------------------------------------------
function! s:vimim_sentence_whole_match(lines, keyboard)
" -----------------------------------------------------
    if empty(s:vimim_match_word_after_word)
    \|| empty(a:lines)
    \|| s:wubi_flag > 0
    \|| a:keyboard =~ '\d'
    \|| len(a:keyboard) < 5
        return []
    endif
    " ---------------------------------------------------
    " demo jiandaolaoshiwenshenghao wozuixihuandeliulanqi
    " ---------------------------------------------------
    let keyboard = a:keyboard
    let pattern = '^' . keyboard . '\>'
    let match_start = match(a:lines, pattern)
    if match_start > -1
        return []
    endif
    " -------------------------------------------
    let min = 1
    let max = len(keyboard)
    let block = ''
    let last_part = ''
    " -------------------------------------------
    while max > 2 && min < len(keyboard)
        let max -= 1
        let position = max
        if s:backspace > 0
            let min += 1
            let position = min
        endif
        let block = strpart(keyboard, 0, position)
        let pattern = '^' . block . '\>'
        let match_start = match(a:lines, pattern)
        if  match_start > -1
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
    if s:chinese_input_mode < 2
    \&& len(s:keyboard_sentences) > 0
        let s:backspace = 0
        let space = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        let keyboard = get(s:keyboard_sentences, 0)
        if empty(keyboard)
            let key .= space
        else
            let key .= keyboard . space
        endif
    endif
    return key
endfunction

" -------------------------------
function! g:vimim_ctrl_x_ctrl_u()
" -------------------------------
    let key = ''
    let char_before = getline(".")[col(".")-2]
    if char_before =~ s:valid_key
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
    \|| len(s:keyboard_sentences) > 0
    \|| s:keyboard_sentences_flag > 0
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
                let s:vimim_diy_pinyin_4corner = 999
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
    \|| s:vimim_diy_pinyin_4corner == 999
        return
    endif
    if filewritable(s:current_datafile)
        call writefile(a:lines, s:current_datafile)
    endif
    if empty(s:localization) && s:vimim_save_input_history_frequency > 0
        let warning = 'performance hit if &encoding and datafile differs!'
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
    if empty(lines) || empty(a:entries)
        return []
    endif
    let sort_before_save = 0
    let position = -1
    for entry in a:entries
        let pattern = '^'.entry.'$'
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
                    while char >= char2nr('a')
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
                            let one_more_up = lines[position]
                            if entry < one_more_up
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
        let line_before = lines[position-1]
        let line_after = lines[position+1]
        if position < 0
        \|| line_before > entry
        \|| entry > line_after
            let sort_before_save = 1
        endif
        call insert(lines, entry, position)
    endfor
    if len(lines) < len(a:lines)
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
        let s:vimim_punctuation_navigation = 1
        return
    endif
    let datafile = s:path . "vimim.privates.txt"
    if filereadable(datafile)
        let s:privates_flag = 1
        let s:privates_datafile = datafile
    else
        return
    endif
endfunction

" -----------------------------------------------
function! s:vimim_search_vimim_privates(keyboard)
" -----------------------------------------------
    let lines = s:vimim_load_privates(0)
    let len_privates_lines = len(lines)
    if empty(len_privates_lines) || len(a:keyboard) < 3
        return []
    endif
    let pattern = '^' . a:keyboard
    let matched = match(lines, pattern)
    let matches = []
    if matched < 0
        let matches = s:vimim_fuzzy_match(lines, a:keyboard)
    else
        let matches = s:vimim_exact_match(lines, a:keyboard, matched)
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
    if s:vimim_debug_flag > 0 || s:wubi_flag > 0
        return
    endif
    if s:four_corner_flag > 1
        let s:vimim_fuzzy_search = 0
        let s:vimim_static_input_style = 1
        let s:vimim_punctuation_navigation = 1
        return
    endif
    let datafile = s:path . "vimim.4corner.txt"
    if filereadable(datafile)
        let s:four_corner_flag = 1
        let s:four_corner_datafile = datafile
    else
        return
    endif
endfunction

" ------------------------------
function! s:vimim_load_4corner()
" ------------------------------
    if empty(s:four_corner_flag) || s:vimim_debug_flag > 0
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
    \|| len(a:keyboard)%4 != 0
        return []
    endif
    " ------------------------------------
    " demo sijiaohaoma == 6021272260021762
    " ------------------------------------
    let keyboards = split(a:keyboard, '\(.\{4}\)\zs')
    return keyboards
endfunction

" ---------------------------------------------
function! s:vimim_diy_keyboard2number(keyboard)
" ---------------------------------------------
    let keyboard = a:keyboard
    if empty(s:vimim_diy_pinyin_4corner)
    \|| s:chinese_input_mode > 1
    \|| len(a:keyboard) < 5
    \|| len(a:keyboard) > 6
        return keyboard
    endif
    let alphabet_length = 0
    if len(keyboard) == 5 && strpart(keyboard,0,1) !~ '\d'
        let alphabet_length = 1
    elseif len(keyboard) == 6 && strpart(keyboard,0,2) !~ '\d'
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
    let characters = split(a:chinese,'\zs')
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
        let s:vimim_punctuation_navigation = 1
    endif
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
" ====  VimIM Double Pinyin   ==== {{{
" ====================================

" ------------------------------------------
function! s:vimim_initialize_double_pinyin()
" ------------------------------------------
    if empty(s:pinyin_flag)
        return
    endif
    if empty(s:vimim_double_pinyin_microsoft)
    \&& empty(s:vimim_double_pinyin_purple)
    \&& empty(s:vimim_double_pinyin_abc)
    \&& empty(s:vimim_double_pinyin_nature)
    \&& empty(s:vimim_double_pinyin_plusplus)
        return
    else
        let s:pinyin_flag = 2
    endif
    let s:vimim_static_input_style = 1
    let s:vimim_fuzzy_search = 0
    let s:vimim_match_word_after_word = 0
    " -----------------------------
    let s:shengmu = {}
    let s:yunmu = {}
    let keys=map(range(char2nr('a'),char2nr('z')),'nr2char(v:val)')
    for key in keys
        let s:shengmu[key] = key
        let s:yunmu[key] = [key]
    endfor
    let s:shengmu["o"] = "'"
    let s:yunmu["o"] = ["uo", "o"]
endfunction

" ---------------------------------------
function! s:vimim_double_pinyin(keyboard)
" ---------------------------------------
    let lines = s:vimim_load_datafile(0)
    if empty(lines) || len(a:keyboard) < 2
        return []
    endif
    let rules = []
    if s:vimim_double_pinyin_microsoft > 0
        let rules = s:vimim_double_pinyin_microsoft()
    elseif s:vimim_double_pinyin_abc > 0
        let rules = s:vimim_double_pinyin_abc()
    elseif s:vimim_double_pinyin_nature > 0
        let rules = s:vimim_double_pinyin_nature()
    elseif s:vimim_double_pinyin_purple > 0
        let rules = s:vimim_double_pinyin_purple()
    elseif s:vimim_double_pinyin_plusplus > 0
        let rules = s:vimim_double_pinyin_plusplus()
    endif
    let keyboards = s:vimim_double_pinyin_translate(rules, a:keyboard)
    if empty(keyboards)
        return []
    endif
    let results = []
    for keyboard in keyboards
        let pattern = '^' . keyboard . '\>'
        let start = match(lines, pattern)
        if start > -1
            let item_results = s:vimim_exact_match(lines, pattern, start)
            call extend(results, item_results)
        endif
    endfor
    return results
endfunction

" --------------------------------------------------------
function! s:vimim_double_pinyin_translate(rules, keyboard)
" --------------------------------------------------------
    let lines = s:vimim_load_datafile(0)
    let keyboard = a:keyboard
    if empty(lines) || len(keyboard) < 2
        return []
    endif
    let keyboard_max = 10
    if len(keyboard) > keyboard_max
        let keyboard = strpart(keyboard,0,keyboard_max)
    endif
    let shengmu_hash = get(a:rules,0)
    let yunmu_hash = get(a:rules,1)
    let keyboards = split(keyboard, '\(..\)\zs')
    let pairs_list = []
    " --------------------------
    " 'abcde' => ['ab','cd','e']
    " --------------------------
    for keyboard in keyboards
        if len(keyboard) < 2
            continue
        endif
        let pairs = []
        let pattern = '^' . keyboard . '\>'
        let match_start = match(lines, pattern)
        if  match_start > -1
            call add(pairs, keyboard)
            call add(pairs_list, pairs)
            continue
        endif
        let shengmu = ""
        let char = get(split(keyboard,'\zs'),0)
        if has_key(shengmu_hash, char)
            let shengmu = shengmu_hash[char]
            if shengmu == "'"
                let shengmu = ""
            endif
        endif
        let char = get(split(keyboard,'\zs'),1)
        if has_key(yunmu_hash, char)
            for yunmu in yunmu_hash[char]
                call add(pairs, shengmu.yunmu)
            endfor
        endif
        call add(pairs_list, pairs)
    endfor
    if empty(pairs_list)
        return []
    endif
    let keyboards = []
    " -------------------------------------------------
    " woxnihdj => [['wo'], ['xin'], ['chang'], ['dan']]
    " -------------------------------------------------
    for A in get(pairs_list, 0, [""])
        for B in get(pairs_list, 1, [""])
            for C in get(pairs_list, 2, [""])
                for D in get(pairs_list, 3, [""])
                    for E in get(pairs_list, 4, [""])
                        call add(keyboards, A.B.C.D.E)
                    endfor
                endfor
            endfor
        endfor
    endfor
    return keyboards
endfunction

" -----------------------------------------
function! s:vimim_double_pinyin_microsoft()
" -----------------------------------------
    " vi=>zhi ii=>chi ui=>shi keng=>keneng
    " ------------------------------------
    let shengmu = copy(s:shengmu)
    let yunmu = copy(s:yunmu)
    unlet shengmu["a"]
    unlet shengmu["e"]
    let shengmu["i"] = "ch"
    let shengmu["u"] = "sh"
    let shengmu["v"] = "zh"
    let yunmu["b"] = ["ou"]
    let yunmu["c"] = ["iao"]
    let yunmu["d"] = ["uang", "iang"]
    let yunmu["f"] = ["en"]
    let yunmu["g"] = ["eng", "ng"]
    let yunmu["h"] = ["ang"]
    let yunmu["j"] = ["an"]
    let yunmu["k"] = ["ao"]
    let yunmu["l"] = ["ai"]
    let yunmu["m"] = ["ian"]
    let yunmu["n"] = ["in"]
    let yunmu["p"] = ["un"]
    let yunmu["q"] = ["iu"]
    let yunmu["r"] = ["uan", "er"]
    let yunmu["s"] = ["ong", "iong"]
    let yunmu["t"] = ["ue"]
    let yunmu["v"] = ["ui", "ue"]
    let yunmu["w"] = ["ia", "ua"]
    let yunmu["x"] = ["ie"]
    let yunmu["y"] = ["uai", "v"]
    let yunmu["z"] = ["ei"]
    let yunmu[";"] = ["ing"]
    return [shengmu, yunmu]
endfunction

" --------------------------------------
function! s:vimim_double_pinyin_nature()
" --------------------------------------
    " goal: 'woui' => wo shi => i am
    " -----------------------------------
    let shengmu = copy(s:shengmu)
    let yunmu = copy(s:yunmu)
    unlet shengmu["a"]
    unlet shengmu["e"]
    let shengmu["i"] = "ch"
    let shengmu["u"] = "sh"
    let shengmu["v"] = "zh"
    unlet yunmu["u"]
    let yunmu["b"] = ["ou"]
    let yunmu["c"] = ["iao"]
    let yunmu["d"] = ["uang", "iang"]
    let yunmu["f"] = ["en"]
    let yunmu["g"] = ["eng", "ng"]
    let yunmu["h"] = ["ang"]
    let yunmu["j"] = ["an"]
    let yunmu["k"] = ["ao"]
    let yunmu["l"] = ["ai"]
    let yunmu["m"] = ["ian"]
    let yunmu["n"] = ["in"]
    let yunmu["p"] = ["un"]
    let yunmu["q"] = ["iu"]
    let yunmu["r"] = ["uan", "er"]
    let yunmu["s"] = ["ong", "iong"]
    let yunmu["t"] = ["ue"]
    let yunmu["v"] = ["ui", "v"]
    let yunmu["w"] = ["ia", "ua"]
    let yunmu["x"] = ["ie"]
    let yunmu["y"] = ["uai", "ing"]
    let yunmu["z"] = ["ei"]
    return [shengmu, yunmu]
endfunction

" -----------------------------------
function! s:vimim_double_pinyin_abc()
" -----------------------------------
    " 'vtpc' => shuang pin
    " ['vt','pc'] => [['shiang','shuang'],['pin','puai']]
    " ['shiangpin','shiangpuai','shuangpin','shuangpuai']
    " ---------------------------------------------------
    let shengmu = copy(s:shengmu)
    let yunmu = copy(s:yunmu)
    unlet shengmu["i"]
    unlet shengmu["u"]
    let shengmu["a"] = "zh"
    let shengmu["e"] = "ch"
    let shengmu["v"] = "sh"
    let yunmu["b"] = ["ou"]
    let yunmu["c"] = ["in", "uai"]
    let yunmu["d"] = ["ia", "ua"]
    let yunmu["f"] = ["en"]
    let yunmu["g"] = ["eng", "ng"]
    let yunmu["h"] = ["ang"]
    let yunmu["j"] = ["an"]
    let yunmu["k"] = ["ao"]
    let yunmu["l"] = ["ai"]
    let yunmu["m"] = ["ue", "ui"]
    let yunmu["n"] = ["un"]
    let yunmu["p"] = ["uan"]
    let yunmu["q"] = ["ei"]
    let yunmu["r"] = ["er", "iu"]
    let yunmu["s"] = ["ong", "iong"]
    let yunmu["t"] = ["iang", "uang"]
    let yunmu["v"] = ["v", "ue"]
    let yunmu["w"] = ["ian"]
    let yunmu["x"] = ["ie"]
    let yunmu["y"] = ["ing"]
    let yunmu["z"] = ["iao"]
    return [shengmu, yunmu]
endfunction

" --------------------------------------
function! s:vimim_double_pinyin_purple()
" --------------------------------------
    let shengmu = copy(s:shengmu)
    let yunmu = copy(s:yunmu)
    unlet shengmu["v"]
    unlet shengmu["e"]
    let shengmu["a"] = "ch"
    let shengmu["i"] = "sh"
    let shengmu["u"] = "zh"
    unlet yunmu["c"]
    let yunmu["b"] = ["iao"]
    let yunmu["d"] = ["ie"]
    let yunmu["f"] = ["ian"]
    let yunmu["g"] = ["iang", "uang"]
    let yunmu["h"] = ["ong", "iong"]
    let yunmu["j"] = ["er", "iu"]
    let yunmu["k"] = ["ei"]
    let yunmu["l"] = ["uan"]
    let yunmu["m"] = ["un"]
    let yunmu["n"] = ["ue", "ui"]
    let yunmu["p"] = ["ai"]
    let yunmu["q"] = ["ao"]
    let yunmu["r"] = ["an"]
    let yunmu["s"] = ["ang"]
    let yunmu["t"] = ["eng", "ng"]
    let yunmu["w"] = ["en"]
    let yunmu["x"] = ["ia", "ua"]
    let yunmu["y"] = ["in", "uai"]
    let yunmu["z"] = ["ou"]
    let yunmu[";"] = ["ing"]
    return [shengmu, yunmu]
endfunction

" ----------------------------------------
function! s:vimim_double_pinyin_plusplus()
" ----------------------------------------
    let shengmu = copy(s:shengmu)
    let yunmu = copy(s:yunmu)
    unlet shengmu["e"]
    let shengmu["i"] = "sh"
    let shengmu["u"] = "ch"
    let shengmu["v"] = "zh"
    let shengmu["a"] = "'"
    let yunmu["b"] = ["ia", "ua"]
    let yunmu["c"] = ["uan"]
    let yunmu["d"] = ["ao"]
    let yunmu["f"] = ["an"]
    let yunmu["g"] = ["ang"]
    let yunmu["h"] = ["iang", "uang"]
    let yunmu["j"] = ["ian"]
    let yunmu["k"] = ["iao"]
    let yunmu["l"] = ["in"]
    let yunmu["m"] = ["ie"]
    let yunmu["n"] = ["iu"]
    let yunmu["p"] = ["ou"]
    let yunmu["q"] = ["er", "ing"]
    let yunmu["r"] = ["en"]
    let yunmu["s"] = ["ai"]
    let yunmu["t"] = ["eng", "ng"]
    let yunmu["v"] = ["v", "ui"]
    let yunmu["w"] = ["ei"]
    let yunmu["x"] = ["uai", "ue"]
    let yunmu["y"] = ["ong", "iong"]
    let yunmu["z"] = ["un"]
    return [shengmu, yunmu]
endfunction

" ================================ }}}
" ====  VimIM Wubi Special    ==== {{{
" ====================================

" ------------------------------------------
function! s:vimim_initialize_datafile_wubi()
" ------------------------------------------
    if s:wubi_flag > 0
        let s:keyboard_wubi = ''
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
        if match(keyboard, 'z') > 0
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
    if s:wubi_flag > 0
    \&& s:vimim_wubi_non_stop > 0
        if len(keyboard) > 4
            let start = 4*((len(keyboard)-1)/4)
            let keyboard = strpart(keyboard, start)
        endif
        let s:keyboard_wubi = keyboard
    endif
    let results = []
    let pattern = '^'.keyboard
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
    " ------------------------------------------
    " demo [wubi] trdeggwhssqu => i have a dream
    " ------------------------------------------
    let keyboards = split(a:keyboard, '\(.\{4}\)\zs')
    return keyboards
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
    if s:vimim_debug_flag > 0
        " -------------------------------- debug
        let s:pinyin_flag = 1
        let s:four_corner_flag = 1
        let s:english_flag = 1
        let s:vimim_diy_pinyin_4corner = 1
        let s:vimim_tab_for_one_key = 1
        let s:vimim_menu_extra_text = 1
        let s:vimim_reverse_pageup_pagedown = 1
        let s:vimim_fuzzy_double_pinyin = 1
        let s:vimim_wildcard_search = 1
        let s:vimim_unicode_lookup = 0
        let s:vimim_double_pinyin_microsoft = 0
        let s:vimim_number_as_navigation = 0
        let s:vimim_static_input_style = 0
        let s:vimim_menu_color = 0
        " --------------------------------------
    endif
endfunction

" -----------------------------------------------
function! s:vimim_initialize_diy_pinyin_4corner()
" -----------------------------------------------
    if s:pinyin_flag == 1 && s:four_corner_flag == 1
        let s:vimim_diy_pinyin_4corner = 1
    endif
    if empty(s:vimim_diy_pinyin_4corner)
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
    let results = s:vimim_datafile_range(a:keyboard)
    if empty(results)
        return []
    endif
    let has_digit = match(a:keyboard, '^\d\+')
    if has_digit > -1
        let patterns = "^" .  a:keyboard
        if s:four_corner_flag == 1001
            " another choice: top-left & bottom-right
            let char_first = strpart(a:keyboard, 0, 1)
            let char_last  = strpart(a:keyboard, len(a:keyboard)-1,1)
            let patterns = '^' .  char_first . "\d\d" . char_last
        endif
        call filter(results, 'v:val =~ patterns')
    elseif s:vimim_fuzzy_search > 0
        let results = s:vimim_fuzzy_match(results, a:keyboard)
    endif
    let results = s:vimim_i18n_read_list(results)
    return results
endfunction

" ------------------------------------------------
function! s:vimim_wildcard_search(keyboard, lines)
" ------------------------------------------------
    if s:chinese_input_mode > 1
    \|| len(s:keyboard_sentences) > 1
    \|| len(s:keyboard_sentences_flag) > 1
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

" -----------------------------------------
function! s:vimim_diy_whole_match(keyboard)
" -----------------------------------------
    let keyboard = a:keyboard
    if empty(s:vimim_diy_pinyin_4corner)
    \|| s:chinese_input_mode > 1
    \|| s:wubi_flag > 0
    \|| len(keyboard) < 4
        return []
    endif
    let keyboards = []
    if len(keyboard)%5 == 0 && strpart(keyboard,0,1) !~ '\d'
        " ------------------------------------
        " demo sssjjzdoloslosonfofo z5000w0040
        " ------------------------------------
        let keyboards = split(keyboard, '\(.\{5}\)\zs')
    elseif len(keyboard)%6 == 0 && strpart(keyboard,0,2) !~ '\d'
        " ------------------------------------
        " demo zw5000md0051 zwgooomdooga
        " ------------------------------------
        let keyboards = split(keyboard, '\(.\{6}\)\zs')
    endif
    if empty(keyboards)
        return []
    endif
    let results = []
    for keyboard in keyboards
        let keyboard2 = s:vimim_diy_keyboard2number(keyboard)
        if keyboard2 ==# keyboard
        \&& strpart(keyboard, 1+len(keyboard)/6) =~# '\l'
            return []
        else
            call add(results, keyboard2)
        endif
    endfor
    return results
endfunction

" --------------------------------------
function! s:vimim_diy_keyboard(keyboard)
" --------------------------------------
    let keyboard = a:keyboard
    if empty(s:vimim_diy_pinyin_4corner)
    \|| s:chinese_input_mode > 1
    \|| len(keyboard) < 2
    \|| keyboard !~ '[0-9a-z]'
    \|| keyboard =~ '[.]'
        return []
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
    " ----------------------------------
    let break_into_three = '' |"  ml7140 => ['ml', '71', '40']
    let alpha_string = strpart(keyboard, 0, digit)
    let digit_string = strpart(keyboard, digit)
    if alpha > 0
        let alpha_string = strpart(keyboard, alpha)
        let digit_string = strpart(keyboard, 0, alpha)
    elseif len(alpha_string)==2
        let digit_string = strpart(keyboard, digit, 2)
        let break_into_three = strpart(keyboard, digit+2)
    elseif len(alpha_string) > 1
        \&& len(split(digit_string,'\zs')) < 2
        \&& digit_string !~ '[1-4]' |" if ma3, pinyin tone 1,2,3,4
        return []
    endif
    let keyboards = [alpha_string, digit_string, break_into_three]
    return keyboards
endfunction

" --------------------------------------
function! s:vimim_diy_results(keyboards)
" --------------------------------------
    let keyboards = a:keyboards
    if empty(s:vimim_diy_pinyin_4corner)
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

set completeopt=menuone
set completefunc=VimIM
" ------------------------------
function! VimIM(start, keyboard)
" ------------------------------
if a:start

    let current_positions = getpos(".")
    let start_column = current_positions[2]-1
    let start_row = current_positions[1]
    let current_line = getline(start_row)
    let char_before = current_line[start_column-1]

    if empty(s:chinese_input_mode)
        if char_before ==# '.'
            let match_start = match(current_line, '\w\+\s\+\p\+\.$')
            if match_start > -1
                return match_start
            endif
        endif
        if len(s:keyboard_sentences) > 0
            let keyboard = remove(s:keyboard_sentences, 0)
            if keyboard !~ '\d'
                let seamless_column = start_column - len(keyboard)
                return seamless_column
            endif
        endif
    endif

    if s:chinese_input_mode > 0
    \&& s:vimim_seamless_english_input > 0
    \&& s:number_typed_flag < 1
    \&& len(s:seamless_positions) > 0
        let seamless_bufnum = s:seamless_positions[0]
        let seamless_lnum = s:seamless_positions[1]
        let seamless_off = s:seamless_positions[3]
        if seamless_bufnum == current_positions[0]
        \&& seamless_lnum == current_positions[1]
        \&& seamless_off == current_positions[3]
            let seamless_column = s:seamless_positions[2]-1
            let len = start_column - seamless_column
            let snip = strpart(current_line, seamless_column, len)
            if snip !~ '\W' && len(snip) > 0
                let s:start_column_before = seamless_column
                let s:start_row_before = seamless_lnum
                return seamless_column
            endif
        endif
    endif
    let s:number_typed_flag = 0

    if s:chinese_input_mode > 1 && char_before =~ '\d'
        return start_column
    endif

    while start_column > 0 && char_before =~? s:valid_key
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

    if s:vimim_debug_flag > 0
        let g:keyboard_s=s:keyboard_leading_zero
        let g:keyboard_a=a:keyboard
    endif

    let keyboard = a:keyboard

    if s:four_corner_flag > 0 && str2nr(keyboard) != 0
        let keyboard = s:keyboard_leading_zero
    endif

    if a:keyboard !~ '\p'
        let keyboard = ''
    endif

    if str2nr(keyboard) < 1
    \&& s:chinese_input_mode > 0
    \&& keyboard !=# toupper(keyboard)
    \&& keyboard !=# tolower(keyboard)
        let s:seamless_positions = []
    endif

    " support one-key (Enter/<C-H>) to remove trash code
    " --------------------------------------------------
    if s:chinese_input_mode > 1 && s:trash_code_flag > 0
        let s:trash_code_flag = 0
        return [" "]
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

    " magic i: English number => Chinese number
    " -----------------------------------------
    if s:chinese_input_mode < 2 && a:keyboard =~? '^i'
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

    " play with Chinese the same way as English: i have a dream.
    " ----------------------------------------------------------
    if empty(s:chinese_input_mode)
        if keyboard =~ '\w\+\s\+\p\+\.$'
            let keyboard = substitute(keyboard,'\s','.','g')
            let keyboard = strpart(keyboard,0,len(keyboard)-1)
        elseif keyboard =~# '[A-Z_]'
            return [keyboard]
        endif
    endif

    " initialize omni completion function
    " -----------------------------------
    let &pumheight=9
    let s:pattern_not_found = 1
    let s:insert_without_popup_flag = 0
    let keyboards = []

    " [erbi] the first ,./;' is punctuation
    " -------------------------------------
    if s:current_datafile =~ 'erbi'
    \&& len(keyboard) == 1 && keyboard =~ "[,./;']"
    \&& has_key(s:punctuations_all, keyboard)
        let value = s:punctuations_all[keyboard]
        return [value]
    endif

    " Now, reset and build valid keyboard characters
    " ----------------------------------------------
    if empty(keyboard)
    \|| keyboard !~ s:valid_key
    \|| strpart(keyboard,0,1) ==# "[A-Z]"
    \|| (len(keyboard)<2 && keyboard =~ "[.*]")
        return
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

    " support major double pinyin with various rules
    " ----------------------------------------------
    if s:pinyin_flag == 2
        let results = s:vimim_double_pinyin(keyboard)
        if len(results) > 0
            let results = s:vimim_pair_list(results)
            return s:vimim_popupmenu_list(results)
        endif
    endif

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
    if s:privates_flag == 1
    \&& len(s:privates_datafile) > 0
    \&& keyboard !~ '[.?*]'
        let results = s:vimim_search_vimim_privates(keyboard)
        if len(results) > 0
            let s:private_matches = results
        endif
     endif

    " return nothing if no single data file
    " --------------------------------------
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

    " escape literal dot if Array/Phonetic input method
    " -------------------------------------------------
    if s:current_datafile_has_dot_key > 0
        let keyboard = substitute(keyboard,'\.','\\.','g')
    endif

    " now it is time to do regular expression matching
    " ------------------------------------------------
    let match_start = match(lines, '^'.keyboard)

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
            let keyboard = keyboard2
            let match_start = match(lines, '^'.keyboard)
        endif
    endif

    " try "do it yourself" couple input method: pinyin+4corner
    " --------------------------------------------------------
    if match_start < 0 && s:vimim_diy_pinyin_4corner > 0
        let keyboard2 = s:vimim_diy_keyboard2number(keyboard)
        let keyboards = s:vimim_diy_keyboard(keyboard2)
        let mixtures = s:vimim_diy_results(keyboards)
        if len(mixtures) > 0
            return s:vimim_popupmenu_list(mixtures)
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

    " support seamless English input for OneKey
    " -----------------------------------------
    if match_start < 0
    \&& empty(s:chinese_input_mode)
    \&& len(s:keyboard_sentences) > 0
        return [keyboard]
    endif

endif
endfunction

" ================================ }}}
" ====  VimIM Core Drive      ==== {{{
" ====================================
" profile start /tmp/vimim.profile

" ------------------------------------------
function! s:vimim_smart_delete_key_mapping()
" ------------------------------------------
    if !hasmapto('<C-W>', 'i')
        inoremap<silent><C-W> <C-R>=<SID>vimim_smart_ctrl_w()<CR>
    endif
    if !hasmapto('<C-U>', 'i')
        inoremap<silent><C-U> <C-R>=<SID>vimim_smart_ctrl_u()<CR>
    endif
    if !hasmapto('<C-H>', 'i')
        inoremap<silent><C-H> <C-R>=<SID>vimim_smart_ctrl_h()<CR>
    endif
endfunction

" -----------------------------
function! s:vimim_key_mapping()
" -----------------------------
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
    if s:vimim_chinese_input_mode > 0
        imap<silent> <C-^> <Plug>VimimChineseToggle
    elseif s:vimim_one_key > 0
        imap<silent> <C-^> <Plug>VimimOneKey
    endif
    " ----------------------------------------------------------
    if s:vimim_smart_delete_keys > 0
        inoremap<silent><BS> <C-R>=<SID>vimim_smart_backspace()<CR>
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
        iunmap <C-\>
    else
        iunmap <Tab>
    endif
endfunction

silent!call s:vimim_initialization()
silent!call s:vimim_key_mapping()
" ====================================== }}}

