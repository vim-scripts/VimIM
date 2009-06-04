" ==================================================
"             "VimIM —— Vim 中文输入法"
" --------------------------------------------------
"  VimIM -- Input Method by Vim, of Vim, for Vimmers
" ==================================================

" URL:   http://vim.sourceforge.net/scripts/script.php?script_id=2506
" Group: http://groups.google.com/group/vimim
" Code:  http://maxiangjiang.googlepages.com/vimim.vim.html
" Demo:  http://maxiangjiang.googlepages.com/vimim.html

" ====  VimIM Introduction    ==== {{{
" ====================================
"      File: vimim.vim
"    Author: Sean Ma <vimim@googlegroups.com>
"   License: GNU Lesser General Public License
"    Latest: 20090604T000000
" -----------------------------------------------------------
"    Readme: VimIM is a Vim plugin designed as an independent
"            IM (Input Method) to support the input of any language.
"            It can be used as yet another way to input non-ascii
"            using OneKey in addition to builtin i_<C-V> and i_<C-K>.
"            VimIM aims to complete the Vim as an editor.
" -----------------------------------------------------------
"  Features: * "Plug & Play"
"            * It can be used as yet another way to input non-ascii.
"            * It is independent of Operating System.
"            * It is independent of Vim mbyte-XIM/mbyte-IME API.
"            * The "OneKey" can input Chinese without mode change.
"            * The "static"  Chinese Input Mode smooths mixture input.
"            * The "dynamic" Chinese Input Mode uses sexy input style.
"            * Support "many input methods": Pinyin, Wubi, Cangjie, etc
"            * Support word matching on word segmentation
"            * Support "multi-byte search" using search key '/' or '?'.
"            * Support "fuzzy search" and "wildcard search"
"            * Support popup menu navigation using "vi key" (hjkl)
"            * Support dynamically lookup keycode and unicode.
"            * Support direct "unicode input" using integer or hex
"            * Support dynamically create and save new entries.
"            * Support dynamical adjust menu order over usage frequency
"            * Support mixture "DIY input method" defined by users
"            * Support intelligent editing keys (CTRL-H, BS, Enter)
"            * Support "non-stop-typing" for Wubi
"            * Support open, simple and flexible data file format
" -----------------------------------------------------------
" EasterEgg: (1) (Neither data file nor configuration needed)
"            (2) (in Vim Command-line Mode, type:)  :source %<CR>
"            (3) (in Vim Insert Mode, type 4 char)  vim<C-\>
" -----------------------------------------------------------
"   Install: (1) download any data file you like from the link below
"            (2) drop this file and datafile to the plugin directory
" -----------------------------------------------------------
" Usage (1): [in Insert Mode] "to insert/search Chinese ad hoc":
"            # to insert: type keycode and hit <C-\> to trigger
"            # to search: hit '/' or '?' from popup menu
" Usage (2): [in Insert Mode] "to type Chinese continuously":
"            # hit <C-^> to toggle to VimIM Chinese Input Mode:
"              (2.1) [dynamic] mode: any valid key code => Chinese
"              (2.2) [static]  mode: Space=>Chinese  Enter=>English
" -----------------------------------------------------------
" VimIM Sample Data Files:
" ------------------------
" http://maxiangjiang.googlepages.com/vimim.pinyin.txt
" http://maxiangjiang.googlepages.com/vimim.phonetic.txt
" http://maxiangjiang.googlepages.com/vimim.english.txt
" http://maxiangjiang.googlepages.com/vimim.4corner.txt
" http://maxiangjiang.googlepages.com/vimim.array30.txt
" http://maxiangjiang.googlepages.com/vimim.quick.txt
" http://maxiangjiang.googlepages.com/vimim.erbi.txt
" http://maxiangjiang.googlepages.com/vimim.cangjie.txt
" http://maxiangjiang.googlepages.com/vimim.wubi.txt
" http://maxiangjiang.googlepages.com/vimim.wubi98.txt
" http://maxiangjiang.googlepages.com/vimim.wubijd.txt

" ================================ }}}
" ====  VimIM Instruction     ==== {{{
" ====================================

" -------------
" "Design Goal"
" -------------
" # Chinese can be input using Vim regardless of encoding
" # Without negative impact to Vim if VimIM is not used
" # No compromise for high speed and low memory usage
" # Making the best use of Vim for Input Methods
" # Most VimIM options are activated by default
" # All  VimIM options can be explicitly disabled at will

" ----------------------------------
" "Example vimrc to display Chinese"
" ----------------------------------
" set gfn=Courier_New:h12:w7,Arial_Unicode_MS
" set gfw=NSimSun-18030,NSimSun ambiwidth=double
" set enc=utf8 fencs=ucs-bom,utf8,chinese,taiwan,ansi

" ---------------
" "VimIM Options"
" ---------------
" Detailed usages of all options can be found from references

"   VimIM "OneKey", without mode change
"   - use OneKey to insert multi-byte candidates
"   - use OneKey to search multi-byte using "/" or "?"
"   - use OneKey to directly insert Unicode, integer or hex
"   The default key is <C-\> (Vim Insert Mode)
" # To disable :let g:vimim_disable_one_key=1

"   VimIM "Chinese Input Mode"
"   - [static mode] <Space> => Chinese  <Enter> => English
"   - [dynamic mode] show dynamic menu as you type
"   - <Esc> key is in consistent with Vim
"   The default key is <C-^> (Vim Insert Mode)
" # To disable :let g:vimim_disable_chinese_input_mode=1

" # To enable VimIM "Default Off" Options
"   -------------------------------------
"   let g:vimim_enable_fuzzy_search=1
"   let g:vimim_enable_wildcard_search=1
"   let g:vimim_enable_...=1

" # To disable VimIM "Default On" Options
"   -------------------------------------
"   let g:vimim_disable_unicode_input=1
"   let g:vimim_disable_one_key=1
"   let g:vimim_disable_...=1

" -----------------
" "VimIM Data File"
" -----------------
" The datafile is assumed to be in order, otherwise, it is auto sorted.
" The basic "datafile format" is simple and flexible:
"
"    +------+--+-------+
"    |<key> |  |<value>|
"    |======|==|=======|
"    | mali |  |  馬力 |
"    +------+--+-------+
"
" The <key> is what is typed in alphabet, ready to be replaced.
" The <value>, separated by spaces, is what will be inserted.
" The 2nd and the 3rd column can be repeated without restriction.
"
" Non UTF-8 datafile is also supported: when the datafile name
" includes 'chinese', it is assumed to be encoded in 'chinese'.

" ================================ }}}
" ====  VimIM Initialization  ==== {{{
" ====================================
if exists("b:loaded_vimim") || &cp || v:version < 700
    finish
endif
let b:loaded_vimim = 1
let s:path=expand("<sfile>:p:h")."/"
let s:saved_paste=&paste
set nopaste

scriptencoding utf-8
" -----------------------------------
function! s:VimIM_initialize_global()
" -----------------------------------
    let G = []
    call add(G, "g:vimim_debug")
    call add(G, "g:vimim_datafile")
    call add(G, "g:vimim_save_input_history_frequency")
    " ------------------------------------------------
    call add(G, "g:vimim_enable_auto_spell")
    call add(G, "g:vimim_enable_diy_mixture_im")
    call add(G, "g:vimim_enable_double_pinyin_abc")
    call add(G, "g:vimim_enable_double_pinyin_microsoft")
    call add(G, "g:vimim_enable_double_pinyin_nature")
    call add(G, "g:vimim_enable_double_pinyin_plusplus")
    call add(G, "g:vimim_enable_double_pinyin_purple")
    call add(G, "g:vimim_enable_easter_egg")
    call add(G, "g:vimim_enable_english_to_chinese")
    call add(G, "g:vimim_enable_four_corner")
    call add(G, "g:vimim_enable_fuzzy_pinyin")
    call add(G, "g:vimim_enable_fuzzy_search")
    call add(G, "g:vimim_enable_menu_color")
    call add(G, "g:vimim_enable_menu_ctrl_jk")
    call add(G, "g:vimim_enable_menu_extra_text")
    call add(G, "g:vimim_enable_sexy_input_style")
    call add(G, "g:vimim_enable_smart_punctuation")
    call add(G, "g:vimim_enable_static_input_style")
    call add(G, "g:vimim_enable_tab_for_one_key")
    call add(G, "g:vimim_enable_unicode_lookup")
    call add(G, "g:vimim_enable_wildcard_search")
    " ------------------------------------------------
    call add(G, "g:vimim_disable_chinese_input_mode")
    call add(G, "g:vimim_disable_chinese_punctuation")
    call add(G, "g:vimim_disable_dynamic_mode_autocmd")
    call add(G, "g:vimim_disable_english_input_on_enter")
    call add(G, "g:vimim_disable_menu_hjkl")
    call add(G, "g:vimim_disable_menu_label")
    call add(G, "g:vimim_disable_one_key")
    call add(G, "g:vimim_disable_part_by_part_match")
    call add(G, "g:vimim_disable_quick_key")
    call add(G, "g:vimim_disable_reverse_lookup")
    call add(G, "g:vimim_disable_save_new_entry")
    call add(G, "g:vimim_disable_seamless_english_input")
    call add(G, "g:vimim_disable_search")
    call add(G, "g:vimim_disable_smart_backspace")
    call add(G, "g:vimim_disable_square_bracket")
    call add(G, "g:vimim_disable_unicode_input")
    call add(G, "g:vimim_disable_word_by_word_match")
    call add(G, "g:vimim_disable_wubi_non_stop")
    " ------------------------------------------------
    for variable in G
        let s_variable = substitute(variable,"g:","s:",'')
        if !exists(variable)
            exe 'let '. s_variable . '=0'
        else
            exe 'let '. s_variable .'='. variable
            exe 'unlet! ' . variable
        endif
    endfor
endfunction

" ----------------------------
function! s:VimIM_initialize()
" ----------------------------
    sil!call s:VimIM_initialize_global()
    let s:current_datafile = s:VimIM_get_datafile_name()
    " --------------------------------------------------
    if s:vimim_debug > 0
        let s:vimim_enable_static_input_style=0
        let s:vimim_enable_tab_for_one_key=1
        let s:vimim_enable_wildcard_search=1
        let s:vimim_enable_diy_mixture_im=1
        let s:vimim_enable_four_corner=1
        let s:vimim_enable_english_to_chinese=1
        let s:vimim_enable_menu_extra_text=1
        let s:vimim_enable_easter_egg=1
        let s:vimim_save_input_history_frequency=0
    endif
    " ----------------------------------- pinyin
    let s:input_method = ""
    if s:current_datafile =~? 'pinyin'
    \|| s:current_datafile =~# 'vimim.txt'
        let s:input_method = 'pinyin'
    endif
    if s:input_method == 'pinyin'
        let s:vimim_enable_fuzzy_search=1
        let s:shengmu = {}
        let s:yunmu = {}
        let keys = map(range(char2nr('a'),char2nr('z')),'nr2char(v:val)')
        for key in keys
            let s:shengmu[key] = key
            let s:yunmu[key] = [key]
        endfor
        let s:shengmu["o"] = "'"
        let s:yunmu["o"] = ["uo", "o"]
    endif
    " -----------------------------------
    let wildcard = s:vimim_enable_wildcard_search
    let s:valid_key = s:VimIM_valid_key(s:current_datafile, wildcard)
    let key = s:VimIM_expand_character_class(s:valid_key)
    let s:vimim_valid_keys = split(key, '\zs')
    " -----------------------------------
    let s:diy_double_input_delimiter = 0
    let s:vimim_insert_without_popup = 0
    let s:vimim_chinese_mode = 0
    let s:vimim_easter_eggs = 0
    let s:vimim_chinese_insert_on = 0
    let s:vimim_punctuation = 0
    let s:vimim_enable_zero_based_label = 0
    " -----------------------------------
    let s:start_row_before = 0
    let s:start_column_before = 1
    let s:start_search_forward = 0
    let s:start_search_backward = 0
    let s:vimim_pattern_not_found = 0
    " -----------------------------------
    let s:trash_code_flag = 0
    let s:menu_order_update_flag = 0
    let s:number_typed_flag = 0
    " -----------------------------------
    let s:vimim_seed_data_loaded = 0
    let s:vimim_onekey_loaded = 0
    let s:vimim_datafile_loaded = 0
    let s:vimim_dictionary_loaded = 0
    let s:vimim_four_corner_loaded = 0
    let s:vimim_pinyin_loaded = 0
    " -----------------------------------
    let s:keyboard_wubi = ''
    let s:keyboard_sentence = ''
    let s:keyboard_leading_zero = ''
    let s:keyboard_chinese = ''
    let s:keyboard_menu = ''
    let s:keyboard_counts = 0
    " -----------------------------------
    let s:valid_minimum_key = "[a-z]"
    let s:current_positions = [0,0,1,0]
    let s:start_positions   = [0,0,1,0]
    let s:keyboards = []
    let s:datafile_lines = []
    let s:alphabet_lines = []
    let s:dictionary_lines = []
    let s:four_corner_lines = []
    let s:seamless_positions = []
    if s:vimim_disable_seamless_english_input < 1
        let s:seamless_positions = getpos(".")
    endif
    " -----------------------------------
    let s:unicode_start = str2nr('2600',16) "|  9728
    let s:unicode_end   = str2nr('9fa5',16) "| 40869
    let s:saved_pumheight=&pumheight
    " -----------------------------------
    let s:multibyte = 2
    if &encoding == "utf-8"
        let s:multibyte = 3
    endif
    " -----------------------------------
    if s:vimim_enable_menu_color < 1
        highlight! link PmenuSel  Title
        highlight! Pmenu          NONE
        highlight! PmenuSbar	  NONE
        highlight! PmenuThumb	  NONE
        if s:vimim_enable_menu_color < 0
            highlight! clear
            highlight! PmenuSbar  NONE
            highlight! PmenuThumb NONE
        endif
    endif
    " -----------------------------------
endfunction

" -------------------------------------------------------
function! s:VimIM_expand_character_class(character_class)
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

" -------------------------------------------------
function! s:VimIM_valid_key(input_method, wildcard)
" -------------------------------------------------
    let s:current_datafile_has_dot_key = 0
    let s:vimim_wubi_non_stop = 0
    let input_method = a:input_method
    let key = "[a-z]"
    let key_wildcard = ""
    if input_method =~ 'wubi'
        let key = "[a-z]"
    elseif input_method =~ 'phonetic'
        let s:current_datafile_has_dot_key = 1
        let key = "[0-9a-z.,;/\-]"
        let key_wildcard = "[?*0-9a-z.,;/\-]"
    elseif input_method =~ 'array'
        let s:current_datafile_has_dot_key = 1
        let key = "[a-z.,;/]"
        let key_wildcard = "[?*a-z.,;/]"
    elseif input_method =~ 'erbi'
        let s:current_datafile_has_dot_key = 1
        let key = "[a-z;,./']"
        let key_wildcard = "[?*a-z;,./']"
    elseif input_method =~ 'corner'
        let s:vimim_enable_four_corner = 1
        let key = "[0-9]"
        let key_wildcard = "[?*0-9]"
    endif
    if input_method =~ 'pinyin'
    \|| input_method =~# 'vimim.txt'
        let key = "[.0-9a-z]"
        let key_wildcard = "[.*?0-9a-z]"
        if s:vimim_enable_double_pinyin_microsoft > 0
        \|| s:vimim_enable_double_pinyin_purple > 0
            let key = "[a-z;]"
            let key_wildcard = "[*a-z;]"
        elseif s:vimim_enable_double_pinyin_abc > 0
        \|| s:vimim_enable_double_pinyin_nature > 0
        \|| s:vimim_enable_double_pinyin_plusplus > 0
            let key = "[a-z]"
            let key_wildcard = "[*a-z]"
        endif
    endif
    if s:current_datafile_has_dot_key > 0
    \|| input_method =~? 'wubi'
    \|| input_method =~? 'cangjie'
    \|| input_method =~? 'quick'
    \|| input_method =~? 'corner'
        let s:vimim_save_input_history_frequency=-1
    endif
    if s:vimim_enable_static_input_style < 1
        if input_method =~? 'wubi'
        \&& s:vimim_disable_wubi_non_stop < 1
            let s:vimim_wubi_non_stop = 1
        endif
    endif
    if a:wildcard > 0 && len(key_wildcard) > 0
        let key = key_wildcard
    endif
    let s:valid_minimum_key = key
    return key
endfunction

" -----------------------------------
function! s:VimIM_get_datafile_name()
" -----------------------------------
    let datafile = s:vimim_datafile
    if datafile != '0' && filereadable(datafile)
        return datafile
    endif
    let input_methods = []
    call add(input_methods, "pinyin")
    call add(input_methods, "phonetic")
    call add(input_methods, "erbi")
    call add(input_methods, "4corner")
    call add(input_methods, "cangjie")
    call add(input_methods, "quick")
    call add(input_methods, "array30")
    call add(input_methods, "wubi")
    call add(input_methods, "wubi98")
    call add(input_methods, "wubijd")
    call map(input_methods, '"vimim." . v:val . ".txt"')
    let default = "vimim.txt"
    call insert(input_methods, default)
    for file in input_methods
        let datafile = s:path . file
        if filereadable(datafile)
            break
        endif
    endfor
    if !filereadable(datafile)
        let s:vimim_easter_eggs = 1
        let datafile = ''
    endif
    return datafile
endfunction

" -------------------------------
function! s:VimIM_load_datafile()
" -------------------------------
    if s:vimim_datafile_loaded < 1 || len(s:datafile_lines) < 1
        let s:vimim_datafile_loaded = 1
        let s:datafile_lines = []
        if len(s:current_datafile)>0 && filereadable(s:current_datafile)
            let s:datafile_lines = readfile(s:current_datafile)
        endif
    endif
    return s:datafile_lines
endfunction

" ------------------------------------
function! s:VimIM_save_datafile(lines)
" ------------------------------------
    let datafile = s:current_datafile
    if len(datafile) < 1 || len(a:lines) < 1
        return
    endif
    if filewritable(datafile)
        sil!let s:datafile_lines = a:lines
        sil!call writefile(a:lines, datafile)
    endif
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
    let char_before_before = current_line[start_column-2]

    if s:vimim_disable_seamless_english_input < 1
    \&& s:number_typed_flag < 1
    \&& len(s:seamless_positions) > 0
    \&& s:vimim_chinese_mode > 0
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
    let char_one_before = current_line[start_column-1]
    while start_column > 0
    \&& (char_one_before =~# s:valid_key || char_one_before =~# '\u')
    \&& ((s:vimim_chinese_mode==2 && char_one_before !~ '\d')
          \|| s:vimim_chinese_mode<2)
        let start_column -= 1
        let char_one_before = current_line[start_column-1]
    endwhile

    " get user's previous selection
    " -----------------------------
    if start_row >= s:start_row_before
        let row = start_row
        let col = start_column
        let row2 = s:start_row_before
        let col2 = s:start_column_before
        let key = s:keyboard_menu
        let chinese = s:VimIM_chinese_before(row,col,row2,col2,key)
        if s:vimim_save_input_history_frequency > -1
        \&& s:menu_order_update_flag > 0
        \&& len(chinese)>0 && char2nr(chinese) > 126
            let s:keyboard_chinese = chinese
            let s:keyboard_counts += 1
        endif
    endif

    let slash_char = current_line[start_column-1]
    let slash_slash_char = current_line[start_column-2]
    if slash_char == "/" && slash_slash_char != "/"
        let s:start_search_forward = start_column
        let s:start_search_backward = 0
    elseif slash_char == "?"
        let s:start_search_backward = start_column
        let s:start_search_forward = 0
    endif

    let s:start_row_before = start_row
    let s:start_column_before = start_column
    let s:current_positions = current_positions
    let len = current_positions[2]-1 - start_column
    let s:keyboard_leading_zero = strpart(current_line, start_column, len)

    return start_column

else

    if s:vimim_debug > 0
        let g:keyboard_s=s:keyboard_leading_zero
        let g:keyboard_a=a:keyboard
    endif

    let keyboard = a:keyboard
    if s:vimim_enable_four_corner > 0
        if str2nr(keyboard) > 0 && str2nr(s:keyboard_leading_zero) > 0
            let keyboard = s:keyboard_leading_zero
        endif
    endif
    if a:keyboard !~ '\p'
        let keyboard = ''
    endif

    if str2nr(keyboard) < 1
    \&& keyboard !=# toupper(keyboard)
    \&& keyboard !=# tolower(keyboard)
        let s:seamless_positions = []
    endif

    " support one-key (Enter/<C-H>) to remove trash code
    " -----------------------------------------------
    if s:vimim_chinese_mode > 1
    \&& s:trash_code_flag > 0
        let s:trash_code_flag = 0
        return [" "]
    endif

    " support WuBi non-stop typing
    " -----------------------------------------------
    if s:vimim_wubi_non_stop > 0
        if len(keyboard) > 4
            let start = 4*((len(keyboard)-1)/4)
            let keyboard = strpart(keyboard, start)
        endif
        let s:keyboard_wubi = keyboard
    endif

    " support direct Unicode input:
    " -----------------------------------------------
    if s:vimim_disable_unicode_input < 1
    \&& &encoding == "utf-8"
        let unicodes = s:VimIM_unicode(keyboard)
        if len(unicodes) > 0
            let &pumheight=0
            return s:VimIM_popupmenu_list(unicodes, 3)
        endif
    endif
    let &pumheight=s:saved_pumheight

    " hunt for easter egg only if enabled
    " -----------------------------------------------
    if s:vimim_enable_easter_egg > 0
        let egg = s:VimIM_easter_egg(keyboard)
        if len(egg) > 0
            return egg
        endif
    endif

    " Now, build again valid keyboard characters
    " ------------------------------------------
    if strlen(keyboard) < 1
    \|| keyboard !~ s:valid_key
    \|| strpart(keyboard,0,1) ==# "[A-Z]"
    \|| (len(keyboard)<2 && keyboard =~ '[.?*]')
    \|| (keyboard !~# "vim" && s:vimim_easter_eggs>0)
        let s:vimim_pattern_not_found = 1
        return
    endif

    " hunt real VimIM easter eggs ... vim<C-\>
    " ----------------------------------------
    if keyboard =~# "vim"
        return s:VimIM_popupmenu_list(s:easter_eggs, 3)
    endif

    " [erbi] the first ,./;' is punctuation
    " ----------------------------------------
    if s:current_datafile =~ 'erbi' && len(keyboard) == 1
    \&& has_key(s:punctuations_all, keyboard)
        let value = s:punctuations_all[keyboard]
        return [value]
    endif

    " The data file is loaded once and only once
    " ------------------------------------------
    let lines = s:VimIM_load_datafile()
    if len(lines) < 1
        return
    endif
    let localization = s:VimIM_localization()
    let s:menu_order_update_flag = 0

    " add boundary to datafile search by one letter only
    " --------------------------------------------------
    let ranges = s:VimIM_search_boundary(keyboard, lines)
    if len(ranges) < 2
        return
    elseif ranges[0] > ranges[1]
        let lines = sort(lines) |" re-order if disorder
        let ranges = s:VimIM_search_boundary(keyboard, lines)
        if len(ranges) < 2 || ranges[0] > ranges[1]
            return
        else
            sil!call s:VimIM_save_datafile(lines)
        endif
    endif

    let keyboards = []
    if s:vimim_enable_double_pinyin_microsoft > 0
        let keyboards = s:VimIM_double_pinyin_microsoft(keyboard)
    elseif s:vimim_enable_double_pinyin_abc > 0
        let keyboards = s:VimIM_double_pinyin_abc(keyboard)
    elseif s:vimim_enable_double_pinyin_nature > 0
        let keyboards = s:VimIM_double_pinyin_nature(keyboard)
    elseif s:vimim_enable_double_pinyin_purple > 0
        let keyboards = s:VimIM_double_pinyin_purple(keyboard)
    elseif s:vimim_enable_double_pinyin_plusplus > 0
        let keyboards = s:VimIM_double_pinyin_plusplus(keyboard)
    endif
    " ----------------------------------------------
    " support major Double Pinyin with various rules
    " ----------------------------------------------
    if len(keyboards) > 0
        let s:vimim_enable_static_input_style=1
        let total_results = []
        for key in keyboards
            let match_start = match(lines, '^'.key)
            if  match_start > -1
                let results = s:VimIM_exact_match(match_start, key, lines)
                call extend(total_results, results)
            endif
        endfor
        if len(total_results) > 0
            return s:VimIM_popupmenu_list(total_results, localization)
        else
            return
        endif
    endif

    " modify the datafile in memory based on past usage
    " -------------------------------------------------
    if s:vimim_save_input_history_frequency > -1
        let chinese = s:keyboard_chinese
        let key = s:keyboard_menu
        let new_lines = s:VimIM_order_new(key, chinese, lines)
        if len(new_lines) > 0
            let lines = new_lines
            let frequency = s:vimim_save_input_history_frequency
            if frequency > 0
                let frequency = (frequency<12) ? 12 : frequency
                if s:keyboard_counts>0 && s:keyboard_counts % frequency==0
                    sil!call s:VimIM_save_datafile(lines)
                endif
            endif
        endif
    endif

    " --------------------------------------------------
    " do double search for DIY VimIM double input method
    " --------------------------------------------------
    let s:keyboards = []
    let s:diy_double_input_delimiter = 0
    let keyboards = s:VimIM_diy_keyboard(keyboard)
    if len(keyboards) > 1
        let s:keyboards = keyboards
        let fuzzy_lines = s:VimIM_quick_fuzzy_search(keyboards[0], lines)
        let hash_menu_0 = s:VimIM_diy_lines_to_hash(fuzzy_lines)
        let fuzzy_lines = s:VimIM_quick_fuzzy_search(keyboards[1], lines)
        let hash_menu_1 = s:VimIM_diy_lines_to_hash(fuzzy_lines)
        let mixtures = s:VimIM_diy_double_menu(hash_menu_0, hash_menu_1)
        if len(mixtures) > 0
            return s:VimIM_popupmenu_list(sort(mixtures), localization)
        endif
    endif

    " now only play with portion of datafile of interest
    " --------------------------------------------------
    if len(s:datafile_lines) < 1
        let lines = s:VimIM_load_datafile()
    endif
    let lines = s:datafile_lines[ranges[0] : ranges[1]]
    if s:vimim_debug > 0
        let g:lines=len(lines)
    endif

    " -------------------------------------------
    " do wildcard search: explicitly fuzzy search
    " -------------------------------------------
    if s:vimim_enable_wildcard_search > 0
    \&& s:vimim_chinese_mode < 2
        let wildcard_pattern = '[*?]'
        if s:current_datafile =~? 'wubi'
            let wildcard_pattern = '[z]'
        endif
        let wildcard = match(keyboard, wildcard_pattern)
        if wildcard > 0
            let fuzzies = keyboard
            if s:current_datafile =~? 'wubi'
                if strpart(keyboard,0,2) != 'zz'
                    let fuzzies = substitute(keyboard,'[z]','.','g')
                endif
            else
                let fuzzies_star = substitute(keyboard,'[*]','.*','g')
                let fuzzies = substitute(fuzzies_star,'?','.','g')
            endif
            let fuzzy = '^' . fuzzies . '\>'
            call filter(lines, 'v:val =~ fuzzy')
            return s:VimIM_popupmenu_list(lines, localization)
        endif
    endif

    " For Array/Phonetic input method, escape literal dot
    " ------------------------------------------------------
    if s:current_datafile_has_dot_key > 0
        let keyboard = substitute(keyboard,'\.','\\.','g')
    endif
    let match_start = match(lines, '^'.keyboard)

    " ------------------------------------------
    " to guess user's intention using auto_spell
    " ------------------------------------------
    if match_start < 0
    \&& s:vimim_enable_auto_spell > 0
        let key = s:VimIM_auto_spell(keyboard)
        let match_start = match(lines, '^'.key)
    endif

    " --------------------------------------------
    " to guess user's intention using fuzzy_pinyin
    " --------------------------------------------
    if match_start < 0
    \&& s:vimim_enable_fuzzy_pinyin > 0
        let key = s:VimIM_fuzzy_pinyin(keyboard)
        let match_start = match(lines, '^'.key)
    endif

    " ----------------------------------------
    " do exact match search on sorted datafile
    " ----------------------------------------
    let delimiter = "."
    let stridx = stridx(keyboard, delimiter)
    if stridx > -1 && s:vimim_disable_word_by_word_match < 1
        let match_start = -1
    endif
    let s:vimim_pattern_not_found = 0
    if match_start > -1
        let s:keyboard_menu = keyboard
        let digital = -1
        let results = []
        if s:vimim_enable_four_corner > 0
            let digital = match(keyboard, '\d\+')
            if  digital > -1
                let results = s:VimIM_quick_fuzzy_search(keyboard,lines)
            endif
        endif
        if digital < 0 |" [normal] do fine tunning exact match
            let s:menu_order_update_flag = 1
            let s:keyboard_sentence = ''
            let results = s:VimIM_exact_match(match_start,keyboard,lines)
        endif
        return s:VimIM_popupmenu_list(results, localization)
    else
        let s:vimim_pattern_not_found = 1
    endif

    " -------------------------------------------------
    " assume it is hex unicode if no match for 4 corner
    " -------------------------------------------------
    let s:vimim_insert_without_popup = 0
    if match_start < 0
    \&& &encoding == "utf-8"
    \&& s:vimim_chinese_mode < 2
    \&& s:vimim_enable_four_corner > 0
    \&& strlen(keyboard) == 4
        let four_digit = match(keyboard, '^\d\{4}')
        if  four_digit == 0
            let s:vimim_insert_without_popup = 1
            let digit = str2nr(keyboard, 16)
            let unicode_prefix = 'u'
            let unicode = nr2char(digit)
            let menu = unicode_prefix.keyboard.'　'.digit
            let results = [menu.' '.unicode]
            return s:VimIM_popupmenu_list(results, 3)
        endif
    endif

    " -----------------------------------------------------
    " word matching algorithm for chinese word segmentation
    " -----------------------------------------------------
    if match_start < 0
        let stridx = stridx(keyboard, delimiter)
        let char_last = strpart(keyboard, len(keyboard)-1, 1)
        let results = []
        if stridx < 0
            let results = s:VimIM_sentence_match(keyboard, lines)
        elseif stridx > 0 && char_last != delimiter
            let results = s:VimIM_part_by_part_match(keyboard, lines)
        endif
        if len(results) > 0
            return s:VimIM_popupmenu_list(results, localization)
        else
            let s:keyboard_sentence = ''
        endif
    endif

    " -------------------------------------------
    " do fuzzy search: implicitly wildcard search
    " -------------------------------------------
    if match_start < 0
        let results = s:VimIM_fuzzy_match(keyboard, lines)
        if len(results) > 0
            return s:VimIM_popupmenu_list(results, localization)
        endif
    endif

endif
endfunction

" ================================ }}}
" ====  VimIM Helper          ==== {{{
" ====================================

" ----------------------------------------------------------
function! s:VimIM_popupmenu_list(matched_list, localization)
" ----------------------------------------------------------
    if len(a:matched_list) < 1
        return []
    endif
    let i = 0
    let pair_matched_list = []
    " ------------------------
    for line in a:matched_list
    " ------------------------
        if len(line) < 2
            continue
        endif
        let line = substitute(line,'\s\+#$','','')
        if a:localization == 1
            let line = iconv(line, "chinese", "utf-8")
        elseif a:localization == 2
            let line = iconv(line, "utf-8", &enc)
        endif
        let oneline_list = split(line, '\s\+')
        let menu = remove(oneline_list, 0)
        for chinese in oneline_list
            call add(pair_matched_list, menu .' '. chinese)
        endfor
    endfor
    let label = 1 - s:vimim_enable_zero_based_label
    let popupmenu_list = []
    " ---------------------------
    for pair in pair_matched_list
    " ---------------------------
        let complete_items = {}
        let pairs = split(pair)
        let menu = get(pairs, 0)
        let chinese = get(pairs, 1)
        if len(chinese) < s:multibyte
            continue
        endif
        if s:vimim_enable_menu_extra_text > 0
            let menu_display = menu
            if s:vimim_enable_four_corner > 0
            \&& &encoding == "utf-8"
            \&& s:vimim_chinese_mode < 2
                let four_corner = '^\d\{4}$'
                if match(menu,four_corner)==0 && len(s:keyboards)<1
                    let unicode = printf('u%04x', char2nr(chinese))
                    let menu_display = menu.'　'.unicode
                endif
            endif
            let complete_items["menu"] = menu_display
        endif
        let complete_items["word"] = chinese
        if s:vimim_disable_menu_label < 1
            let abbr = printf('%2s',label) . "\t" . chinese
            let complete_items["abbr"] = abbr
        endif
        let complete_items["dup"] = 1
        let label += 1
        call add(popupmenu_list, complete_items)
    endfor
    let s:keyboard_menu = menu
    if label == 2 && s:vimim_chinese_mode < 2
        let s:menu_order_update_flag = 0
        if s:vimim_enable_tab_for_one_key > 0
            let s:vimim_insert_without_popup = 1
        endif
    endif
    if s:menu_order_update_flag < 1
        let s:keyboard_menu = ''
    endif
    return popupmenu_list
endfunction

" ------------------------------------------------
function! s:VimIM_search_boundary(keyboard, lines)
" ------------------------------------------------
    let keyboard = a:keyboard
    let first_char_typed = strpart(keyboard,0,1)
    if s:current_datafile_has_dot_key > 0 && first_char_typed == "."
        let first_char_typed = '\.'
    endif
    let patterns = '^' . first_char_typed
    let match_start = match(a:lines, patterns)
    let ranges = []
    if match_start < 0 || len(a:lines) < 1
        return []
    endif
    call add(ranges, match_start)
    let match_next = match_start
    let last_line_in_datafile = a:lines[-1]
    let first_char_last_line = strpart(last_line_in_datafile,0,1)
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
    return ranges
endfunction

" ---------------------------------------------------
function! s:VimIM_exact_match(start, keyboard, lines)
" ---------------------------------------------------
    if len(a:keyboard) < 1 || len(a:lines) < 1
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
    if s:vimim_disable_quick_key < 1
        let list_length = result - match_start
        let do_search_on_word = 0
        let quick_limit = 2
        if strlen(a:keyboard) < quick_limit || list_length > words_limit*2
            let do_search_on_word = 1
        else
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
    if result == 0
        let match_end = match_start
    elseif result > 0 && result > match_start
        let match_end = result
    elseif match_end - match_start > words_limit
        let match_end = match_start + words_limit -1
    endif
    return a:lines[match_start : match_end]
endfunction

" --------------------------------------------
function! s:VimIM_fuzzy_match(keyboard, lines)
" --------------------------------------------
    if len(a:keyboard) < 1
    \|| len(a:lines) < 1
    \|| s:vimim_enable_fuzzy_search < 1
        return []
    endif
    let fuzzies = join(split(a:keyboard,'\ze'),'.*')
    let fuzzy = '^' .  fuzzies . '.*'
    let results = filter(a:lines, 'v:val =~ fuzzy')
    call filter(results, 'v:val !~ "#$"')
    if s:vimim_chinese_mode < 2
        if strlen(a:keyboard) == 2
            let fuzzy = '\s\+.\{2}$'
        elseif strlen(a:keyboard) == 3
            let fuzzy = '\s\+.\{3}$'
        endif
        call filter(results, 'v:val =~ fuzzy')
    endif
    return results
endfunction

" -----------------------------------------------
function! s:VimIM_sentence_match(keyboard, lines)
" -----------------------------------------------
    let demo = 'jiandaolaoshiwenshenghao'
    if s:vimim_disable_word_by_word_match > 0
    \|| s:vimim_chinese_mode > 1
    \|| strlen(a:keyboard) < 5
        return []
    endif
    let results = []
    let match_start = 0
    let part = ""
    let len = len(a:keyboard)
    while len > 2
        let len -= 1
        let part = strpart(a:keyboard, 0, len)
        let pattern = '^' . part . '\>'
        let match_start = match(a:lines, pattern)
        if  match_start > -1
            let s:keyboard_sentence = strpart(a:keyboard, len)
            break
        endif
    endwhile
    if len(part) > 1
        let results = s:VimIM_exact_match(match_start, part, a:lines)
    endif
    return results
endfunction

" ---------------------------------------------------
function! s:VimIM_part_by_part_match(keyboard, lines)
" ---------------------------------------------------
    let demo = 'meet.teacher.say.hello'
    if s:vimim_disable_part_by_part_match > 0
    \|| s:vimim_chinese_mode > 1
    \|| strlen(a:keyboard) < 4
        return []
    endif
    let results = []
    let stridx = stridx(a:keyboard, ".")
    if stridx < 0
        let s:keyboard_sentence = a:keyboard
    else
        let s:keyboard_sentence = strpart(a:keyboard, stridx+1)
    endif
    let part = strpart(a:keyboard, 0, stridx)
    let pattern = '^' . part . '\>'
    let match_start = match(a:lines, pattern)
    if match_start < 0
        let results = s:VimIM_fuzzy_match(part, a:lines)
    else
        let results = s:VimIM_exact_match(match_start, part, a:lines)
    endif
    return results
endfunction

" ------------------------------------
function! s:VimIM_auto_spell(keyboard)
" ------------------------------------
    " A demo rule for auto spelling
    "    tign => tign
    "    yve  => yue
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

" --------------------------------------
function! s:VimIM_fuzzy_pinyin(keyboard)
" --------------------------------------
    " A demo rule for fuzzy pinyin
    "    si   => si & shi
    "    wang => wang & huang
    " ----------------------------------
    let rules = {}
    let rules['s'] = 'sh'
    let rules['z'] = 'zh'
    let rules['c'] = 'ch'
    let rules['an'] = 'ang'
    let rules['in'] = 'ing'
    let rules['en'] = 'eng'
    let rules['ang'] = 'uang'
    " ----------------------------------
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
" ====  VimIM OneKey          ==== {{{
" ====================================

" ---------------------------
function! <SID>VimIM_OneKey()
" ---------------------------
    let s:vimim_chinese_mode = 0
    if s:vimim_onekey_loaded < 1
        let s:vimim_onekey_loaded = 1
        sil!call s:VimIM_label_on()
        sil!call s:VimIM_hjkl_on()
    endif
    let punctuations = s:punctuations
    if s:vimim_enable_tab_for_one_key > 0
    \|| s:vimim_disable_chinese_input_mode > 0
        let punctuations["["]="【"
        let punctuations["]"]="】"
        let punctuations["'"]="“"
        let punctuations['"']="”"
        inoremap<silent><Space> <C-R>=<SID>VimIM_smart_space()<CR>
    endif
    let onekey = ""
    if pumvisible()
        let onekey = s:VimIM_keyboard_by_word()
    else
        let onekey = s:VimIM_smart_punctuation(punctuations, "\t")
        if len(onekey) < 1
            let onekey = '\<C-R>=VimIM_CTRL_X_CTRL_U()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . onekey . '"'
endfunction

" --------------------------------
function! <SID>VimIM_smart_space()
" --------------------------------
    let space = " "
    if pumvisible()
        let s:keyboard_wubi = ''
        let s:seamless_positions = []
        let space = s:VimIM_keyboard_by_word()
    else
        if s:vimim_chinese_mode == 2
            let space = s:VimIM_smart_punctuation(s:punctuations, space)
        endif
        if len(space) < 1
            let space = " "
        endif
        if s:vimim_insert_without_popup > 0
            let s:vimim_insert_without_popup = 0
            let space = ""
        endif
    endif
    sil!exe 'sil!return "' . space . '"'
endfunction

" ----------------------------------
function! s:VimIM_keyboard_by_word()
" ----------------------------------
    let key = "\<C-Y>"
    if len(s:keyboard_sentence) > 0
    \&& (s:vimim_disable_word_by_word_match < 1
    \|| s:vimim_disable_part_by_part_match < 1)
        let space = '\<C-R>=VimIM_CTRL_X_CTRL_U()\<CR>'
        let key .= s:keyboard_sentence . space
    endif
    return key
endfunction

" -------------------------
function! s:VimIM_hjkl_on()
" -------------------------
    if s:vimim_disable_menu_hjkl > 0
    \|| s:vimim_chinese_mode > 1
        return
    endif
    for n in split('hjkley', '\zs')
        sil!exe 'inoremap<silent><expr> '.n.' <SID>VimIM_hjkl("'.n.'")'
    endfor
endfunction

" ----------------------------
function! <SID>VimIM_hjkl(key)
" ----------------------------
    let key = a:key
    let hjkl = key
    if pumvisible()
        if key == 'e'
            let hjkl = "\<C-E>"
        elseif key == 'y'
            let hjkl = "\<C-Y>"
        elseif key == 'h'
            let hjkl = "\<PageUp>"
        elseif key == 'j'
            let hjkl = "\<C-N>"
        elseif key == 'k'
            let hjkl = "\<C-P>"
        elseif key == 'l'
            let hjkl = "\<PageDown>"
        endif
    endif
    sil!exe 'sil!return "' . hjkl . '"'
endfunction

" ------------------------------
function! <SID>VimIM_search(key)
" ------------------------------
    let key = a:key
    let slash = key
    if pumvisible()
        let slash = "\<C-Y>"
        if s:start_search_backward > 0
            if key == "?"
                let key = "/"
            elseif key == "/"
                let key = "?"
            endif
        endif
        let slash .= '\<C-R>=VimIM_slash_search()\<CR>'
        let slash .= key . '\<CR>'
    endif
    sil!exe 'sil!return "' . slash . '"'
endfunction

" ----------------------------
function! VimIM_slash_search()
" ----------------------------
    let slash_offset = 0
    let column_start = s:start_column_before
    if s:start_search_forward > 0
        let slash_offset = 1
        let column_start = s:start_search_forward
    elseif s:start_search_backward > 0
        let slash_offset = 1
        let column_start = s:start_search_backward
    endif
    let s:start_search_forward = 0
    let s:start_search_backward = 0
    let column_end = col('.') - 1
    let range =  column_end - column_start
    let current_line = getline(".")
    let chinese = strpart(current_line, column_start, range)
    if range < 0 || chinese =~ '\w'
        let @/ = @_
        return "\<Esc>"
    else
        let @/ = chinese
    endif
    let repeat_times = range/s:multibyte
    let repeat_times += slash_offset
    let delete_chars = ""
    let row_start = s:start_row_before
    let row_end = line('.')
    if repeat_times > 0 && row_end == row_start
        let delete_chars = repeat("\<BS>", repeat_times)
    endif
    let delete = delete_chars . "\<Esc>"
    sil!exe 'sil!return "' . delete . '"'
endfunction

" --------------------------------------
function! <SID>VimIM_square_bracket(key)
" --------------------------------------
    let bracket = a:key
    if pumvisible()
        let i = -1
        let left = ""
        let right = ""
        if a:key == "]"
            let i = 0
            let left = "\<Left>"
            let right = "\<Right>"
        endif
        let backspace = '\<C-R>=VimIM_bracket_backspace('.i.')\<CR>'
        let yes = "\<C-Y>"
        let bracket = yes . left . backspace . right
    endif
    sil!exe 'sil!return "' . bracket . '"'
endfunction

" ---------------------------------------
function! VimIM_bracket_backspace(offset)
" ---------------------------------------
    let column_end = col('.')-1
    let column_start = s:start_column_before
    let range =  column_end - column_start
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

" ================================ }}}
" ====  VimIM Chinese Mode    ==== {{{
" ====================================

" ---------------------------
function! <SID>VimIM_toggle()
" ---------------------------
    if s:vimim_chinese_insert_on < 1
        sil!call s:VimIM_insert_on()
    else
        sil!call s:VimIM_insert_off()
    endif
    if s:vimim_disable_dynamic_mode_autocmd < 1 && has("autocmd")
        if !exists("s:dynamic_mode_autocmd_loaded")
            let s:dynamic_mode_autocmd_loaded = 1
            sil!autocmd InsertEnter sil!call s:VimIM_insert_on()
            sil!autocmd InsertLeave sil!call s:VimIM_insert_off()
            sil!autocmd BufUnload   autocmd! InsertEnter,InsertLeave
        endif
    endif
    sil!return "\<C-O>:redraw\<CR>"
endfunction

" ---------------------------
function! s:VimIM_insert_on()
" ---------------------------
    let s:vimim_chinese_insert_on = 1
    sil!call s:VimIM_setting_on()
    if s:vimim_enable_static_input_style > 0
        let s:vimim_chinese_mode = 1 |" static_input (default off)
        " ----------------------------
        inoremap<silent> <Space>
        \ <C-R>=<SID>VimIM_static_space()<CR>
    else
        let s:vimim_chinese_mode = 2 |" dynamic_input (default on)
        " ----------------------------
        inoremap<silent> <Space>
        \ <C-R>=<SID>VimIM_smart_space()<CR>
        \<C-R>=VimIM_CTRL_X_CTRL_U()<CR>
        " --------------------------------
        for char in s:vimim_valid_keys
            sil!exe 'inoremap<silent> ' . char . '
            \ <C-R>=<SID>VimIM_dynamic_End()<CR>'. char .
            \'<C-R>=VimIM_CTRL_X_CTRL_U()<CR>'
        endfor
        " --------------------------------
        if s:vimim_disable_smart_backspace < 1
            sil!call s:VimIM_smart_keys()
        endif
        " --------------------------------
        sil!call s:VimIM_label_on()
        " --------------------------------
    endif
    " --------------------------------------
    if s:vimim_disable_english_input_on_enter < 1
        inoremap<silent><expr> <CR> <SID>Smart_Enter()
    endif
    " --------------------------------------
    if s:vimim_disable_chinese_punctuation < 1
    \&& s:vimim_chinese_mode > 1
        sil!call s:VimIM_punctuation_toggle(1)
    else
        sil!call s:VimIM_punctuation_toggle(0)
    endif
    sil!inoremap<silent><expr><C-\> <SID>VimIM_Punctuation_Toggle()
    " --------------------------------------
    if s:vimim_enable_menu_ctrl_jk > 0
        if !hasmapto('<C-K>', 'i')
            inoremap<silent><expr> <C-K> <SID>VimIM_ctrl_jk('<C-K>')
        endif
        if !hasmapto('<C-J>', 'i')
            inoremap<silent><expr> <C-J> <SID>VimIM_ctrl_jk('<C-J>')
        endif
    endif
    " --------------------------------------
    sil!call VimIM_set_seamless_position()
    " --------------------------------------
endfunction

" -------------------------------
function! <SID>VimIM_ctrl_jk(key)
" -------------------------------
    if s:vimim_chinese_mode < 1
        return a:key
    endif
    let ctrl_jk = a:key
    if pumvisible()
        if a:key == nr2char(11)
            let ctrl_jk = '\<PageUp>'
        elseif a:key == nr2char(10)
            let ctrl_jk = '\<PageDown>'
        endif
    endif
    sil!exe 'sil!return "' . ctrl_jk . '"'
endfunction

" --------------------------------
function! <SID>VimIM_dynamic_End()
" --------------------------------
    let end = ""
    if pumvisible()
        let end = "\<C-E>"
        if s:vimim_wubi_non_stop > 0
        \&& len(s:keyboard_wubi) % 4 == 0
            let end = "\<C-Y>"
        endif
    endif
    sil!exe 'sil!return "' . end . '"'
endfunction

" -----------------------------
function! VimIM_CTRL_X_CTRL_U()
" -----------------------------
    let key = ""
    let char_before = getline(".")[col(".")-2]
    if char_before =~ s:valid_key
        let key = "\<C-X>\<C-U>"
        if s:vimim_enable_sexy_input_style < 1
            let key .= '\<C-R>=VimIM_menu_select()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ---------------------------
function! VimIM_menu_select()
" ---------------------------
    let select_not_insert = ""
    if pumvisible()
        if s:vimim_enable_sexy_input_style < 1
            let select_not_insert = "\<C-P>\<Down>"
        endif
        if s:vimim_insert_without_popup > 0
            let s:vimim_insert_without_popup = 0
            if len(s:keyboard_sentence) < 1
                let select_not_insert = "\<C-Y>"
            endif
        endif
    endif
    sil!exe 'sil!return "' . select_not_insert . '"'
endfunction

" ----------------------------
function! s:VimIM_insert_off()
" ----------------------------
    let s:vimim_chinese_insert_on = 0
    let s:vimim_chinese_mode = 0
    let s:vimim_onekey_loaded = 0
    let s:start_search_forward = 0
    let s:start_search_backward = 0
    let s:seamless_positions = []
    let s:keyboard_wubi = ''
    " -------------------------------------
    sil!iunmap <C-W>
    sil!iunmap <C-U>
    sil!iunmap <C-H>
    sil!iunmap <BS>
    sil!iunmap <CR>
    sil!iunmap <Space>
    " -------------------------------------
    sil!call s:VimIM_setting_off()
    " -------------------------------------
    sil!call s:VimIM_punctuation_toggle(-1)
    " -------------------------------------
    for n in range(1,9)
        exe 'sil!iunmap '. n
    endfor
    " -------------------------------------
    for char in s:vimim_valid_keys
        exe 'sil!iunmap ' . char
    endfor
    " -------------------------------------
    if s:vimim_disable_one_key < 1
        if s:vimim_enable_tab_for_one_key > 0
            imap<silent> <Tab> <Plug>VimimOneKey
        else
            imap<silent> <C-\> <Plug>VimimOneKey
        endif
    endif
endfunction

" ----------------------------
function! s:VimIM_setting_on()
" ----------------------------
    let s:saved_cpo=&cpo
    let s:saved_lazyredraw=&lazyredraw
    let s:saved_pumheight=&pumheight
    let s:saved_paste=&paste
    let s:saved_ignorecase=&ignorecase
    let s:saved_hlsearch=&hlsearch
    set cpo&vim
    set nopaste
    set nolazyredraw
    set noignorecase
    set hlsearch
    let &l:iminsert=1
    let &pumheight=9
    highlight! lCursor guifg=bg guibg=green
endfunction

" -----------------------------
function! s:VimIM_setting_off()
" -----------------------------
    let &cpo=s:saved_cpo
    let &lazyredraw=s:saved_lazyredraw
    let &hlsearch=s:saved_hlsearch
    let &pumheight=s:saved_pumheight
    let &paste=s:saved_paste
    let &ignorecase=s:saved_ignorecase
    let &l:iminsert=0
    highlight! ICursor NONE
endfunction

" --------------------------
function! s:VimIM_label_on()
" --------------------------
    if s:vimim_disable_menu_label > 0
        return
    endif
    for n in range(1,9)
        sil!exe'inoremap<silent><expr> '.n.' <SID>VimIM_label("'.n.'")'
    endfor
endfunction

" ---------------------------
function! <SID>VimIM_label(n)
" ---------------------------
    if pumvisible()
        let label = 1 - s:vimim_enable_zero_based_label
        let repeat_times = a:n - label
        let counts = repeat("\<C-N>", repeat_times)
        let end = s:VimIM_keyboard_by_word()
        sil!exe 'sil!return "' . counts . end . '"'
    else
        let s:number_typed_flag = 1
        let s:seamless_positions = []
        return a:n
    endif
endfunction

" ================================ }}}
" ====  VimIM Smart Keys      ==== {{{
" ====================================

" ------------------------------------
function! <SID>VimIM_smart_backspace()
" ------------------------------------
    let key = "\<BS>"
    if pumvisible()
        let key .= '\<C-R>=VimIM_CTRL_X_CTRL_U()\<CR>'
        let s:keyboard_wubi = ''
        let s:seamless_positions = []
    elseif s:vimim_pattern_not_found > 0
        let s:vimim_pattern_not_found = 0
        let key .= '\<C-R>=VimIM_CTRL_X_CTRL_U()\<CR>'
    else
        let key .= '\<C-R>=VimIM_set_seamless_position()\<CR>'
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ---------------------------------
function! <SID>VimIM_smart_ctrl_u()
" ---------------------------------
    let key = "\<C-U>"
    if !pumvisible()
        let key .= '\<C-R>=VimIM_set_seamless_position()\<CR>'
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ---------------------------------
function! <SID>VimIM_smart_ctrl_w()
" ---------------------------------
    let key = "\<C-W>"
    let key .= '\<C-R>=VimIM_set_seamless_position()\<CR>'
    sil!exe 'sil!return "' . key . '"'
endfunction

" ---------------------------------
function! <SID>VimIM_smart_ctrl_h()
" ---------------------------------
    let key = "\<BS>"
    if pumvisible()
        let key .= '\<C-R>=VimIM_CTRL_X_CTRL_U()\<CR>'
        let s:keyboard_wubi = ''
        let s:seamless_positions = []
    else
        let key = s:Vimim_bs_for_trash()
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ------------------------------
function! s:Vimim_bs_for_trash()
" ------------------------------
    let key = "\<BS>"
    let char_before = getline(".")[col(".")-2]
    if char_before =~ s:valid_key
        if s:vimim_pattern_not_found > 0
            let s:vimim_pattern_not_found = 0
            if  s:vimim_chinese_mode > 1
                let s:keyboard_wubi = ""
                let s:seamless_positions = []
                let s:trash_code_flag = 1
                let key = "\<C-X>\<C-U>\<BS>"
            endif
        endif
    endif
    return key
endfunction

" -------------------------------------
function! VimIM_set_seamless_position()
" -------------------------------------
    let s:seamless_positions = []
    if s:vimim_disable_seamless_english_input < 1
    \&& s:start_search_forward < 1
    \&& s:start_search_backward < 1
        let s:seamless_positions = getpos(".")
    endif
    return ""
endfunction

" --------------------------
function! <SID>Smart_Enter()
" --------------------------
    sil!call VimIM_set_seamless_position()
    let key = "\<CR>"
    let wubi_enter_as_remove_trash = 0
    if pumvisible()
        let key = "\<C-E>"
        if s:vimim_disable_seamless_english_input > 0
            let key .= " "
        endif
        if wubi_enter_as_remove_trash > 0
            let key = "\<C-Y>"
        endif
    else
        if wubi_enter_as_remove_trash > 0
            let key = s:Vimim_bs_for_trash()
        endif
        let char_before = getline(".")[col(".")-2]
        if (char_before =~ s:valid_key || char_before ==# "[A-Z]")
        \&& wubi_enter_as_remove_trash < 1
            let key = ""
        endif
        if s:start_search_forward > 0 || s:start_search_backward > 0
            let key = '\<C-R>=VimIM_slash_search()\<CR>'
            if s:start_search_forward > 0
                let key .= '/'
            elseif s:start_search_backward > 0
                let key .= '?'
            endif
            let key .= '\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" ---------------------------------
function! <SID>VimIM_static_space()
" ---------------------------------
    sil!call s:VimIM_label_on()
    sil!call s:VimIM_hjkl_on()
    let space = " "
    if pumvisible()
        let s:seamless_positions = []
        let space = s:VimIM_keyboard_by_word()
    else
        let space = s:VimIM_smart_punctuation(s:punctuations, space)
        if len(space) < 1
            let space = '\<C-R>=VimIM_CTRL_X_CTRL_U()\<CR>'
        endif
        if s:vimim_pattern_not_found > 0
           let s:vimim_pattern_not_found = 0
           let space = " "
        endif
    endif
    sil!exe 'sil!return "' . space . '"'
endfunction

" ================================ }}}
" ====  VimIM Punctuations    ==== {{{
" ====================================

" ---------------------------------------
function! <SID>VimIM_Punctuation_Toggle()
" ---------------------------------------
    if s:vimim_disable_chinese_punctuation < 1
        let s:vimim_disable_chinese_punctuation = 1
    else
        let s:vimim_disable_chinese_punctuation = 0
    endif
    if s:vimim_punctuation < 1
        sil!return s:VimIM_punctuation_toggle(1)
    else
        sil!return s:VimIM_punctuation_toggle(0)
    endif
endfunction

" ------------------------------------------
function! s:VimIM_punctuation_toggle(switch)
" ------------------------------------------
    let s:keyboard_wubi = ''
    let s:vimim_punctuation = a:switch
    for key in keys(s:punctuations)
        if a:switch == -1
            sil!exe 'silent! iunmap <silent> '. key
        else
            let value = key
            if a:switch == 1
                let value = s:punctuations[key]
            endif
            sil!exe 'inoremap<silent> ' . key . '
            \ <C-R>=<SID>VimIM_punctuation_Yes()<CR>'. value
        endif
    endfor
    return ""
endfunction

" ----------------------------------------------------
function! s:VimIM_smart_punctuation(punctuations, key)
" ----------------------------------------------------
    let space = ""
    let current_positions = getpos(".")
    let start_column = current_positions[2]-1
    let current_line = getline(current_positions[1])
    let char_before = current_line[start_column-1]
    let char_before_before = current_line[start_column-2]
    if (char_before_before =~ '\W' || char_before_before == '')
    \&& char_before_before =~ '\D'
    \&& has_key(a:punctuations, char_before)
        let replace = a:punctuations[char_before]
        if s:vimim_chinese_mode == 0
        \|| s:vimim_enable_smart_punctuation > 0
            let space = "\<BS>" . replace
        endif
    elseif char_before !~ s:valid_key
        let space = a:key
    endif
    return space
endfunction

" ------------------------------------
function! <SID>VimIM_punctuation_Yes()
" ------------------------------------
    let s:keyboard_wubi = ''
    let s:seamless_positions = []
    let end = ""
    if pumvisible()
        let end = "\<C-Y>"
    endif
    sil!exe 'sil!return "' . end . '"'
endfunction

" ---------------------------
function! s:VimIM_seed_data()
" ---------------------------
    if s:vimim_seed_data_loaded
        return
    else
        let s:vimim_seed_data_loaded = 1
    endif
    " ------------------------
    let s:punctuations = {}
    let punctuations = {}
    let punctuations['#']='＃'
    let punctuations['%']='％'
    let punctuations['$']='￥'
    let punctuations['&']='※'
    let punctuations['!']='！'
    let punctuations['~']='～'
    let punctuations['+']='＋'
    let punctuations['-']='－'
    let punctuations[',']='，'
    let punctuations[';']='；'
    let punctuations['*']='﹡'
    let punctuations['\']='、'
    let punctuations['?']='？'
    let punctuations['@']='・'
    let punctuations[':']='：'
    let punctuations['<']='《'
    let punctuations['>']='》'
    let punctuations['(']='（'
    let punctuations[')']='）'
    let punctuations['{']='『'
    let punctuations['}']='』'
    let punctuations['[']='【'
    let punctuations[']']='】'
    let punctuations['=']='＝'
    let punctuations["'"]="‘’<Left>"
    let punctuations['"']="“”<Left>"
    let punctuations['^']='……'
    let punctuations['_']='——'
    if s:vimim_disable_square_bracket < 1
        unlet punctuations['[']
        unlet punctuations[']']
    endif
    let s:punctuations_all = copy(punctuations)
    for char in s:vimim_valid_keys
        if has_key(punctuations, char)
            unlet punctuations[char]
        endif
    endfor
    let punctuations['.']='。'
    let s:punctuations = punctuations
    " --------------------------------------------
    let s:easter_eggs =         ["vi 文本编辑器"]
    call add(s:easter_eggs, "vim 最牛文本编辑器")
    call add(s:easter_eggs, "vim 精力 生氣")
    call add(s:easter_eggs, "vimim 中文输入法")
    " --------------------------------------------
endfunction

" ================================ }}}
" ====  VimIM Datafile Update ==== {{{
" ====================================

" ---------------------------------------------------------------
function! s:VimIM_chinese_before(row, column, row2, column2, key)
" ---------------------------------------------------------------
    let start_row = a:row
    let start_column = a:column
    let start_row_before = a:row2
    let char_start = a:column2
    let char_end = start_column-1
    let chinese = ''
    " update dynamic menu order based on past usage frequency
    if start_row_before == start_row && char_end > char_start
        let current_line = getline(start_row)
        let chinese = current_line[char_start : char_end]
    elseif start_row - start_row_before == 1
        let previous_line = getline(start_row_before)
        let char_end = len(previous_line)
        let chinese = previous_line[char_start : char_end]
    endif
    if char2nr(chinese) > 128 && len(a:key)>0 && a:key =~ '\a'
        let chinese = substitute(chinese,'\p\+','','g')
    endif
    return chinese
endfunction

" ---------------------------------------------------
function! s:VimIM_order_new(keyboard, chinese, lines)
" ---------------------------------------------------
    if len(a:keyboard) < 1 || a:keyboard !~ s:valid_minimum_key
        return []
    endif
    if len(a:chinese) < 1 || char2nr(a:chinese) < 128
        return []
    endif
    """ step 1/4: modify datafile in memory based on usage
    let one_line_chinese_list = []
    let patterns = '^' . a:keyboard . '\s\+'
    let matched = match(a:lines, patterns)
    if matched < 0
        return []
    endif
    let insert_index = matched
    """ step 2/4: remove all entries matching key from datafile
    while matched > 0
        let old_item = remove(a:lines, matched)
        let values = split(old_item)
        call extend(one_line_chinese_list, values[1:])
        let matched = match(a:lines, patterns, insert_index)
    endwhile
    """ step 3/4: make a new order list
    let used = match(one_line_chinese_list, a:chinese)
    if used > 0
        let head = remove(one_line_chinese_list, used)
        call insert(one_line_chinese_list, head)
    endif
    """ step 4/4: insert the new order list into the datafile list
    if len(one_line_chinese_list) > 0
        let new_item = a:keyboard .' '. join(one_line_chinese_list)
        call insert(a:lines, new_item, insert_index)
    endif
    return a:lines
endfunction

" ------------------------------
function! <SID>VimIM_save(entry)
" ------------------------------
    let entries = split(a:entry,'\n')
    let valid_entries = []
    let localization = s:VimIM_localization()
    for entry in entries
        let has_space = match(entry, '\s')
        if has_space < 0
            continue
        endif
        let words = split(entry)
        if len(words) < 2
            continue
        endif
        let menu = remove(words, 0)
        if menu !~ s:valid_minimum_key
            continue
        endif
        if char2nr(words[0]) < 128
            continue
        endif
        let line = menu .' '. join(words, ' ')
        if localization == 1
            let line = iconv(line, "utf-8", "chinese")
        elseif localization == 2
            let line = iconv(line, &enc, "utf-8")
        endif
        call add(valid_entries, line)
    endfor
    if len(valid_entries) < 1
        return
    endif
    let lines = s:VimIM_load_datafile()
    let lines = s:VimIM_insert_entry(valid_entries, lines)
    if len(lines) < 1
        return
    endif
    sil!call s:VimIM_save_datafile(lines)
endfunction

" --------------------------------------------
function! s:VimIM_insert_entry(entries, lines)
" --------------------------------------------
    if len(a:lines) < 1 || len(a:entries) < 1
        return []
    endif
    let sort_before_save = 0
    let position = -1
    let inserted = 0
    for entry in a:entries
        let menu = split(entry)[0]
        let length = len(menu)
        while length > 0
            let one_less = strpart(menu, 0, length)
            let length -= 1
            let matched = match(a:lines, '^'.one_less)
            if matched < 0
                if length < 1
                    let only_char = strpart(one_less, 0, 1)
                    let char = char2nr(only_char)
                    while char >= char2nr('a')
                        let patterns = '^' . nr2char(char)
                        let position = match(a:lines, patterns)
                        let char -= 1
                        if position > -1
                            let pat = '^\(' . nr2char(char+1) . '\)\@!'
                            let matched = position
                            let position = match(a:lines, pat, matched)
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
                    let next = match(a:lines, patterns, matched)
                    if next > -1
                        for i in reverse(range(matched, next))
                            let position = i
                            let one_more_up = a:lines[position]
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
                let position = match(a:lines, patterns, matched)
                if position > -1
                    break
                else
                    let position = matched+1
                    break
                endif
            endif
        endwhile
        let line_before = a:lines[position-1]
        let line_after = a:lines[position+1]
        let line_position = a:lines[position]
        " avoid insert the same line
        if entry ==? line_before
        \|| entry ==? line_after
        \|| entry ==? line_position
            continue
        endif
        if position < 0
        \|| line_before > entry
        \|| entry > line_after
            let sort_before_save = 1
        endif
        let inserted = 1
        call insert(a:lines, entry, position)
    endfor
    if inserted < 1
        return []
    endif
    if sort_before_save > 0
        sil!call sort(a:lines)
    endif
    return a:lines
endfunction

" --------------------------------------------
function! s:VimIM_build_reverse_cache(chinese)
" --------------------------------------------
    let lines = s:VimIM_load_datafile()
    if len(lines) < 1
        return {}
    endif
    if s:vimim_pinyin_loaded < 1
        let s:vimim_pinyin_loaded = 1
        let first_line_index = 0
        let index = match(lines, '^a')
        if index > -1
            let first_line_index = index
        endif
        let last_line_index = len(lines) - 1
        let index = match(lines, '^zz')
        if index > -1
            let last_line_index = index - 1
        endif
        let s:alphabet_lines = lines[first_line_index : last_line_index]
        if s:input_method == 'pinyin' |" one to many relationship
            let pinyin_with_tone = '^\a\+\d\s\+'
            call filter(s:alphabet_lines, 'v:val =~ pinyin_with_tone')
        endif
        if &encoding == "utf-8"
            let more_than_one_char = '\s\+.*\S\S\+'
            call filter(s:alphabet_lines, 'v:val !~ more_than_one_char')
        endif
    endif
    if len(s:alphabet_lines) < 1
        return {}
    endif
    " --------------------------------------
    let alphabet_lines = copy(s:alphabet_lines)
    let characters = split(a:chinese,'\zs')
    let character = join(characters,'\|')
    call filter(alphabet_lines, 'v:val =~ character')
    " --------------------------------------
    let cache = {}
    for line in alphabet_lines
        if len(line) < 1
            continue
        endif
        let words = split(line)
        if len(words) < 2
            continue
        endif
        let menu = remove(words, 0)
        if s:input_method == 'pinyin'
            let menu = substitute(menu,'\d','','g')
        endif
        for char in words
            if match(characters, char) < 0
                continue
            endif
            if has_key(cache, char) && menu!=cache[char]
                let cache[char] = menu .'|'. cache[char]
            else
                let cache[char] = menu
            endif
        endfor
    endfor
    return cache
endfunction

" ----------------------------------------------
function! s:VimIM_make_one_entry(chinese, cache)
" ----------------------------------------------
    if len(a:chinese) < 1 || len(a:cache) < 1
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
function! s:VimIM_reverse_lookup(chinese)
" ---------------------------------------
    let chinese = a:chinese
    if &encoding != "utf-8"
        return chinese
    else
        let chinese = substitute(chinese,'\s\+\|\w\|\n','','g')
    endif
    let items = []
    let chinese_characters = split(chinese,'\zs')
    let chinese_char = join(chinese_characters, '   ')
    " ------------------------------------------------
    let result_unicode = ''
    if s:vimim_enable_unicode_lookup > 0
        for char in chinese_characters
            let unicode = printf('%04x',char2nr(char))
            call add(items, unicode)
        endfor
        let unicode = join(items, ' ')
        let result_unicode = unicode. "\n" . chinese_char
    endif
    " ------------------------------------------------
    let result_4corner = ''
    if s:vimim_enable_four_corner > 0
        let cache_4corner = s:VimIM_build_4corner_cache(chinese)
        let items = s:VimIM_make_one_entry(chinese, cache_4corner)
        let result_4corner = join(items,' ')."\n".chinese_char
    endif
    " ------------------------------------------------
    let cache_pinyin = s:VimIM_build_reverse_cache(chinese)
    let items = s:VimIM_make_one_entry(chinese, cache_pinyin)
    let result_pinyin = join(items,'')." ".chinese
    " ------------------------------------------------
    let result = ''
    if len(result_unicode) > 0
        let result .= "\n" . result_unicode
    endif
    if len(result_4corner) > 0
        let result .= "\n\n" . result_4corner
    endif
    if len(result_pinyin) > 0
        let result .= "\n\n" .result_pinyin
    endif
    return result
endfunction

" ================================ }}}
" ====  VimIM Double Pinyin   ==== {{{
" ====================================

" -------------------------------------------------------
function! s:VimIM_double_pinyin(shengmu, yunmu, keyboard)
" -------------------------------------------------------
    let rule = "~/vim/keymap/double_pinyin.py"
    let keyboard = a:keyboard
    if len(keyboard) < 1
        return []
    elseif len(keyboard)%2 > 0
        let keyboard = strpart(keyboard, 0, len(keyboard)-1)
    endif
    let pairs = []
    let pairs_list = []
    let i = 1
    let shengmu = ""
    let keyboards = split(keyboard, '\zs')
    for key in keyboards
        if i%2 == 1
            let pairs = []
            if has_key(a:shengmu, key)
                let shengmu = a:shengmu[key]
                if shengmu == "'"
                    let shengmu = ""
                endif
            endif
        elseif i%2 == 0
            if has_key(a:yunmu, key)
                for yunmu in a:yunmu[key]
                    call add(pairs, shengmu.yunmu)
                endfor
            endif
            call add(pairs_list, pairs)
        endif
        let i += 1
    endfor
    if len(pairs_list) < 1
        return []
    endif
    let pairs = []
    for A in get(pairs_list, 0, [""])
        for B in get(pairs_list, 1, [""])
            for C in get(pairs_list, 2, [""])
                for D in get(pairs_list, 3, [""])
                    call add(pairs, A.B.C.D)
                endfor
            endfor
        endfor
    endfor
    return pairs
endfunction

" -------------------------------------------------
function! s:VimIM_double_pinyin_microsoft(keyboard)
" -------------------------------------------------
    if len(a:keyboard) < 2
        return []
    endif
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
    let yunmu["v"] = ["ui","ue"]
    let yunmu["w"] = ["ia","ua"]
    let yunmu["x"] = ["ie"]
    let yunmu["y"] = ["uai", "v"]
    let yunmu["z"] = ["ei"]
    let yunmu[";"] = ["ing"]
    return s:VimIM_double_pinyin(shengmu, yunmu, a:keyboard)
endfunction

" -------------------------------------------
function! s:VimIM_double_pinyin_abc(keyboard)
" -------------------------------------------
    if len(a:keyboard) < 2
        return []
    endif
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
    return s:VimIM_double_pinyin(shengmu, yunmu, a:keyboard)
endfunction

" ----------------------------------------------
function! s:VimIM_double_pinyin_nature(keyboard)
" ----------------------------------------------
    if len(a:keyboard) < 2
        return []
    endif
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
    return s:VimIM_double_pinyin(shengmu, yunmu, a:keyboard)
endfunction

" ----------------------------------------------
function! s:VimIM_double_pinyin_purple(keyboard)
" ----------------------------------------------
    if len(a:keyboard) < 2
        return []
    endif
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
    return s:VimIM_double_pinyin(shengmu, yunmu, a:keyboard)
endfunction

" ------------------------------------------------
function! s:VimIM_double_pinyin_plusplus(keyboard)
" ------------------------------------------------
    if len(a:keyboard) < 2
        return []
    endif
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
    let yunmu["q"] = ["er","ing"]
    let yunmu["r"] = ["en"]
    let yunmu["s"] = ["ai"]
    let yunmu["t"] = ["eng", "ng"]
    let yunmu["v"] = ["v", "ui"]
    let yunmu["w"] = ["ei"]
    let yunmu["x"] = ["uai", "ue"]
    let yunmu["y"] = ["ong", "iong"]
    let yunmu["z"] = ["un"]
    return s:VimIM_double_pinyin(shengmu, yunmu, a:keyboard)
endfunction

" ================================ }}}
" ====  VimIM Unicode         ==== {{{
" ====================================

" ---------------------------------
function! s:VimIM_unicode(keyboard)
" ---------------------------------
    let digits = []
    let unicode_prefix = 'u'
    let keyboard = a:keyboard
    let keyboard_number = str2nr(keyboard)
    let s:vimim_insert_without_popup = 0
    " 5 whole digits: eg 39340 as &#39340; in HTML
    if keyboard =~ '\d\{5}'
    \&& s:vimim_chinese_mode < 2
        let digits = [keyboard_number]
        let s:vimim_insert_without_popup = 1
    elseif keyboard =~ '\d\{4}'
    \&& keyboard_number < 5000
    \&& s:vimim_enable_four_corner < 1
        let digit_ranges = range(10)
        for i in digit_ranges
            let last_unicode = keyboard . i
            let digit = str2nr(last_unicode)
            call add(digits, digit)
        endfor
    elseif s:vimim_chinese_mode < 2
        let four_hex  = match(keyboard, '^\x\{4}')
        let four_digit = match(keyboard, '^\d\{4}')
        if four_hex == 0 && four_digit < 0
            let keyboard = unicode_prefix . keyboard
        endif
        "  4 hex digits: eg x99ac as &#x99ac; in HTML
        let x_hex = match(keyboard, unicode_prefix.'\x\x\x\x\=')
        if x_hex < 0
            return []
        else
            let keyboard = strpart(keyboard,1)
        endif
        if keyboard =~ '\x\{4}'
        \&& s:vimim_chinese_mode < 2
            let digits = [str2nr(keyboard, 16)]
            let s:vimim_insert_without_popup = 1
        elseif keyboard =~ '\x\{3}'
            let hex_ranges = extend(range(10),['a','b','c','d','e','f'])
            for i in hex_ranges
                let last_unicode = keyboard . i
                let digit = str2nr(last_unicode, 16)
                call add(digits, digit)
            endfor
        endif
    else
        return []
    endif
    let unicodes = []
    for digit in digits
        if digit > s:unicode_start && digit < s:unicode_end
            let hex = printf('%04x', digit)
            let menu = unicode_prefix . hex .'　'. digit
            let unicode = menu.' '.nr2char(digit)
            call add(unicodes, unicode)
        endif
    endfor
    if len(unicodes) < 1
        let s:vimim_insert_without_popup = 0
    endif
    return unicodes
endfunction

" ------------------------------
function! s:VimIM_localization()
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
    "   chinese        chinese        3
    " ------------ ----------------- ----
    if &encoding == "utf-8"
        if datafile_fenc_chinese
            let localization = 1
        endif
    elseif &enc == "chinese"
        \|| &enc == "gb2312"
        \|| &enc == "gbk"
        \|| &enc == "cp936"
        \|| &enc == "euc-cn"
        if datafile_fenc_chinese < 1
            let localization = 2
        endif
    endif
    return localization
endfunction

" ================================ }}}
" ====  VimIM Easter Egg      ==== {{{
" ====================================

" ------------------------------------
function! s:VimIM_easter_egg(keyboard)
" ------------------------------------
    let keyboard = a:keyboard
    if keyboard !~ '^*'
        return []
    endif
    " --------------------------------
    let ecdict = {}
    let ecdict['casino']='中奖啦！'
    let ecdict['grass']='天涯何处无芳草！'
    let ecdict['am']='上午'
    let ecdict['pm']='下午'
    let ecdict['year']='年'
    let ecdict['day']='号'
    let ecdict['hour']='时'
    let ecdict['minute']='分'
    let ecdict['second']='秒'
    let ecdict['january']=   '一月'
    let ecdict['february']=  '二月'
    let ecdict['march']=     '三月'
    let ecdict['april']=     '四月'
    let ecdict['may']=       '五月'
    let ecdict['june']=      '六月'
    let ecdict['july']=      '七月'
    let ecdict['august']=    '八月'
    let ecdict['september']= '九月'
    let ecdict['october']=   '十月'
    let ecdict['november']='十一月'
    let ecdict['december']='十二月'
    let ecdict['monday']=   '星期一'
    let ecdict['tuesday']=  '星期二'
    let ecdict['wednesday']='星期三'
    let ecdict['thursday']= '星期四'
    let ecdict['friday']=   '星期五'
    let ecdict['saturday']= '星期六'
    let ecdict['sunday']=   '星期日'
    let ecdict['0']='○'
    let ecdict['1']='一'
    let ecdict['2']='二'
    let ecdict['3']='三'
    let ecdict['4']='四'
    let ecdict['5']='五'
    let ecdict['6']='六'
    let ecdict['7']='七'
    let ecdict['8']='八'
    let ecdict['9']='九'
    let ecdict[',']='，'
    let ecdict['.']='。'
    let s:ecdict = ecdict
    " --------------------------------
    let s:dummy=copy(s:translators)
    let s:dummy.dict=copy(s:ecdict)
    " --------------------------------
    let result = ''
    " play with intial single star or double stars
    if keyboard =~ '^*\{1}\w' && s:vimim_chinese_mode < 2
        let result = strpart(keyboard,1)
    elseif keyboard =~ '^*\{2}\w'
        let chinese=copy(s:translators)
        let chinese.dict=s:ecdict
        if keyboard =~ '*\{2}casino'
            " **casino -> congratulations! US$88000
            let casino = matchstr(localtime(),'..$')*1000
            let casino = 'casino US$'.casino
            let casino = chinese.translate(casino)
            let result = casino
        elseif keyboard =~ '*\{2}girls'
            let result = chinese.translate('grass')
        elseif keyboard =~ '*\{2}today' || keyboard =~ '*\{2}now'
            " **today  -> 2009 year February 22 day Wednesday
            if keyboard =~ '*\{2}today'
                let today = strftime("%Y year %B %d day %A")
                let today = chinese.translate(today)
                let result = today
            " **now -> Sunday AM 8 hour 8 minute 8 second
            elseif keyboard =~ '*\{2}now'
                let now=strftime("%A %p %I hour %M minute %S second")
                let now=chinese.translate(now)
                let result = now
            endif
        elseif keyboard =~ '*\{2}\d\+'
            let number = join(split(strpart(keyboard,2),'\ze'),' ')
            let number = chinese.translate(number)
            let number = join(split(number),'')
            let result = number
        endif
    endif
    let results = []
    if len(result) > 0
        let result .= ' '
        let results = [result]
        let s:vimim_insert_without_popup = 1
    endif
    return results
endfunction

let s:translators = {}
" ------------------------------------------
function! s:translators.translate(line) dict
" ------------------------------------------
    return join(map(split(a:line),'get(self.dict,tolower(v:val),v:val)'))
endfunction

" ================================ }}}
" ====  VimIM DIY             ==== {{{
" ====================================

" --------------------------------------
function! s:VimIM_diy_keyboard(keyboard)
" --------------------------------------
    let keyboard = a:keyboard
    if len(keyboard) < 2
    \|| s:vimim_chinese_mode > 1
    \|| s:vimim_enable_diy_mixture_im < 1
        return []
    endif
    " -------------------------------------
    let delimiter = "."
    let stridx_1 = stridx(keyboard, delimiter)
    let stridx_2 = stridx(keyboard, delimiter, stridx_1+1)
    let char_first = strpart(keyboard,0,1)
    let char_last  = strpart(keyboard,len(keyboard)-1,1)
    if stridx_1 > -1
        if char_first == delimiter
        \|| char_last == delimiter
        \|| stridx_2 > -1
        \|| len(s:keyboard_sentence) > 0
            return []
        endif
        let alpha_string = strpart(keyboard, 0, stridx_1)
        let digit_string = strpart(keyboard, stridx_1+1)
        if s:vimim_enable_four_corner > 0
            let digit = match(digit_string, '\d\+')
            if digit < 0
                let tmp = alpha_string
                let alpha_string = digit_string
                let digit_string = tmp
            endif
            let digit = match(digit_string, '\d\+')
            if digit < 0
                return []
            endif
        endif
        let s:diy_double_input_delimiter = 0 |" using_delimiter_flag
        return [alpha_string, digit_string]
    endif
    " -------------------------------------
    if s:vimim_enable_four_corner > 0
        let digit = match(keyboard, '\d\+')
        let alpha = match(keyboard, '\a\+')
        if digit < 0 || alpha < 0
            return []
        endif
        let s:diy_double_input_delimiter = 1 |" using_4corner_flag
        let alpha_string = strpart(keyboard, 0, digit)
        let digit_string = strpart(keyboard, digit)
        if alpha > 0
            let s:diy_double_input_delimiter = 2 |" 17ma  1_char
            let alpha_string = strpart(keyboard, alpha)
            let digit_string = strpart(keyboard, 0, alpha)
        endif
        if len(alpha_string) < 1 || len(digit_string) < 1
            let s:diy_double_input_delimiter = 0
            return []
        endif
        if len(alpha_string) > 1
        \&& str2nr(digit_string) < 5
        \&& s:diy_double_input_delimiter < 2
            return [] |" keep pinyin tone 1,2,3,4 except char
        endif
        return [alpha_string, digit_string]
    endif
endfunction

" ----------------------------------------
function! s:VimIM_diy_lines_to_hash(lines)
" ----------------------------------------
    if len(a:lines) < 1
        return {}
    endif
    let hash_menu = {}
    for line in a:lines
        let words = split(line)
        let menu = words[0]
        for word in words
            if word != menu
                let hash_menu[word] = menu
            endif
        endfor
    endfor
    return hash_menu
endfunction

" ---------------------------------------------------------
function! s:VimIM_diy_double_menu(hash_menu_0, hash_menu_1)
" ---------------------------------------------------------
    let hash_menu_0 = a:hash_menu_0 |" {'马力':'mali','马':'ma'}
    let hash_menu_1 = a:hash_menu_1 |" {'马':'7712'}
    let values = []
    if empty(hash_menu_0) || empty(hash_menu_1)
        return []
    endif
    for key in keys(hash_menu_0)
        let one_char = key
        if len(key) > 1
            let one_char = strpart(key, 0, s:multibyte)
        endif
        if has_key(hash_menu_1, one_char)
            let space = "　"
            let menu_vary = hash_menu_0[key]        |" ma
            let menu_fix  = hash_menu_1[one_char]   |" 7712
            let menu = menu_fix . space . menu_vary |" 7712 ma
            let pair = menu . " " . key             |" 7712 ma 马
            call add(values, pair)
        endif
    endfor
    return values
endfunction

" --------------------------------------------
function! s:VimIM_build_4corner_cache(chinese)
" --------------------------------------------
    let lines = s:VimIM_load_datafile()
    if len(lines) < 1
        return {}
    endif
    if s:vimim_four_corner_loaded < 1
        let s:vimim_four_corner_loaded = 1
        let first_line_index = 0
        let index = match(lines, '^a')
        if index > -1
            let first_line_index = index
        endif
        let s:four_corner_lines = lines[0 : first_line_index-1]
    endif
    if len(s:four_corner_lines) < 1
        return {}
    endif
    " ------------------------------------------------
    let lines = copy(s:four_corner_lines)
    let characters = split(a:chinese,'\zs')
    let character = join(characters,'\|')
    call filter(lines, 'v:val =~ character')
    " --------------------------------------
    let cache = {}
    for line in lines
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

" ---------------------------------------------------
function! s:VimIM_quick_fuzzy_search(keyboard, lines)
" ---------------------------------------------------
    let ranges = s:VimIM_search_boundary(a:keyboard, a:lines)
    if len(ranges) < 2 || ranges[0] > ranges[1]
        return []
    endif
    let results = a:lines[ranges[0] : ranges[1]]
    let patterns = a:keyboard
    let digital = match(a:keyboard, '^\d\+')
    if digital < 0
        " ------------------- for alpha_string
        let fuzzies = join(split(a:keyboard,'\ze'),'.*')
        let patterns = '^' .  fuzzies . '.*'
        call filter(results, 'v:val =~ patterns')
        if s:diy_double_input_delimiter > 0
            let patterns = '\s\+\F\{1}$'         |" 1_char => 1_chinese
            if s:diy_double_input_delimiter == 1 |" ma17
                if strlen(a:keyboard) == 2       |" ma
                    let patterns = '\s\+\F\{2}$' |" 2_char => 2_chinese
                endif
            endif
        endif
        call filter(results, 'v:val !~ "#$"')
    else
        " ------------------- for digit_string
        let patterns = "^" .  a:keyboard
        if s:vimim_enable_four_corner == 1001
            " another choice: top-left & bottom-right
            let char_first = strpart(a:keyboard,0,1)
            let char_last  = strpart(a:keyboard,len(a:keyboard)-1,1)
            let patterns = '^' .  char_first . "\d\d" . char_last
        endif
    endif
    call filter(results, 'v:val =~ patterns')
    return results
endfunction

" ------------------------------------
function! <SID>VimIM_vCTRL6(chinglish)
" ------------------------------------
    if len(a:chinglish)<1
        return ""
    endif
    let input = 'english'
    if a:chinglish !~ '\p'
        let input = 'chinese'
    endif
    if input == 'english'
        return s:VimIM_e2c(a:chinglish)
    elseif input == 'chinese'
        return s:VimIM_reverse_lookup(a:chinglish)
    endif
endfunction

" ----------------------------
function! s:VimIM_e2c(english)
" ----------------------------
    if s:vimim_enable_english_to_chinese < 1
        return a:english
    endif
    let lines = s:VimIM_load_datafile()
    if len(lines) < 1 || a:english !~ '\p'
        return ""
    endif
    if s:vimim_dictionary_loaded < 1
        let s:vimim_dictionary_loaded = 1
        let s:dictionary_lines = filter(copy(lines), 'v:val =~ "#$"')
    endif
    if len(s:dictionary_lines) < 1
        return ""
    endif
    let localization = s:VimIM_localization()
    for line in s:dictionary_lines
        if len(line) < 1
            continue
        endif
        if localization == 1
            let line = iconv(line, "chinese", "utf-8")
        elseif localization == 2
            let line = iconv(line, "utf-8", &enc)
        endif
        let words = split(line)
        if len(words) < 2
            continue
        endif
        let s:dummy.dict[words[0]] = words[1]
    endfor
    let english = substitute(a:english, '\A', ' & ', 'g')
    let chinese = substitute(english, '.', '&\n', 'g')
    let chinese = s:dummy.translate(english)
    let chinese = substitute(chinese, "[ ']", '', 'g')
    let chinese = substitute(chinese, '\a\+', ' & ', 'g')
    return chinese
endfunction

" ================================ }}}
" ====  VimIM Core Drive      ==== {{{
" ====================================
" profile start /tmp/vimim.profile

" ----------------------------
function! s:VimIM_smart_keys()
" ----------------------------
    inoremap<silent><C-W> <C-R>=<SID>VimIM_smart_ctrl_w()<CR>
    inoremap<silent><C-U> <C-R>=<SID>VimIM_smart_ctrl_u()<CR>
    inoremap<silent><C-H> <C-R>=<SID>VimIM_smart_ctrl_h()<CR>
    inoremap<silent><BS>  <C-R>=<SID>VimIM_smart_backspace()<CR>
endfunction

" -------------------------
function! s:VimIM_mapping()
" -------------------------
    inoremap<silent><expr><Plug>VimimOneKey <SID>VimIM_OneKey()
    inoremap<silent><expr><Plug>VimimChineseToggle <SID>VimIM_toggle()
    " ----------------------------------------------------------
    if s:vimim_disable_reverse_lookup < 1 && &encoding == "utf-8"
        if !hasmapto('<C-^>', 'v')
            xnoremap<silent> <C-^> y:'>put=<SID>VimIM_vCTRL6(@0)<CR>
        endif
    endif
    " ----------------------------------------------------------
    if s:vimim_disable_save_new_entry < 1
        if !hasmapto('<C-\>', 'i')
            xnoremap<silent> <C-\> :y<CR>:call <SID>VimIM_save(@0)<CR>
        endif
    endif
    " ----------------------------------------------------------
    if s:vimim_disable_chinese_input_mode < 1
        if !hasmapto('<C-^>', 'i')
            imap<silent> <C-^> <Plug>VimimChineseToggle
        endif
        if !hasmapto('<C-L>', 'i')
          " imap<silent> <C-L> <Plug>VimimChineseToggle
        endif
    elseif s:vimim_disable_one_key < 1
        if !hasmapto('<C-^>', 'i')
            imap<silent> <C-^> <Plug>VimimOneKey
        endif
    endif
    " ----------------------------------------------------------
    if s:vimim_disable_one_key < 1
        if s:vimim_enable_tab_for_one_key > 0
            if !hasmapto('<Tab>', 'i')
                imap<silent> <Tab> <Plug>VimimOneKey
            endif
        else
            if !hasmapto('<C-\>', 'i')
                imap<silent> <C-\> <Plug>VimimOneKey
            endif
        endif
    endif
    " ----------------------------------------------------------
    if s:vimim_disable_search < 1
        inoremap<silent><expr> / <SID>VimIM_search('/')
        inoremap<silent><expr> ? <SID>VimIM_search('?')
    endif
    " ----------------------------------------------------------
    if s:vimim_disable_square_bracket < 1
        inoremap<silent><expr> [ <SID>VimIM_square_bracket('[')
        inoremap<silent><expr> ] <SID>VimIM_square_bracket(']')
    endif
    " ----------------------------------------------------------
    let &paste=s:saved_paste
endfunction

silent!call s:VimIM_initialize()
silent!call s:VimIM_seed_data()
silent!call s:VimIM_mapping()
" ====================================== }}}

