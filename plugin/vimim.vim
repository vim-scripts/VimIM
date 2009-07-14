" ==================================================
"             "VimIM —— Vim 中文输入法"
" --------------------------------------------------
"  VimIM -- Input Method by Vim, of Vim, for Vimmers
" ==================================================

" URL:   http://vim.sourceforge.net/scripts/script.php?script_id=2506
" Group: http://groups.google.com/group/vimim
" Code:  http://code.google.com/p/vimim/downloads/list
" Demo:  http://maxiangjiang.googlepages.com/vimim.html

" ====  VimIM Introduction    ==== {{{
" ====================================
"      File: vimim.vim
"    Author: Sean Ma <vimim@googlegroups.com>
"   License: GNU Lesser General Public License
"    Latest: 20090714T000000
" -----------------------------------------------------------
"    Readme: VimIM is a Vim plugin designed as an independent IM
"            (Input Method) to support the input of multibyte.
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
"            * Support 5 different kind of "Double Pinyin"
"            * Support word matching on word segmentation
"            * Support "multi-byte search" using search key '/' or '?'.
"            * Support "fuzzy search" and "wildcard search"
"            * Support popup menu navigation using "vi key" (hjkl)
"            * Support dynamically lookup keycode and unicode.
"            * Support direct "unicode input" using integer or hex
"            * Support dynamically create and save new entries.
"            * Support dynamical adjust menu order over usage frequency
"            * Support diy input method defined by users
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
"            # hit <C-^> to toggle to Chinese Input Mode:
"              (2.1) [dynamic] mode: any valid key code => Chinese
"              (2.2) [static]  mode: Space=>Chinese  Enter=>English
" -----------------------------------------------------------
" VimIM Sample Data Files:
" http://code.google.com/p/vimim/downloads/list
" ---------------------------------------------
" http://vimim.googlecode.com/files/vimim.pinyin.txt
" http://vimim.googlecode.com/files/vimim.pinyin_huge.txt
" http://vimim.googlecode.com/files/vimim.phonetic.txt
" http://vimim.googlecode.com/files/vimim.english.txt
" http://vimim.googlecode.com/files/vimim.4corner.txt
" http://vimim.googlecode.com/files/vimim.array30.txt
" http://vimim.googlecode.com/files/vimim.quick.txt
" http://vimim.googlecode.com/files/vimim.erbi.txt
" http://vimim.googlecode.com/files/vimim.nature.txt
" http://vimim.googlecode.com/files/vimim.cangjie.txt
" http://vimim.googlecode.com/files/vimim.wubi.txt
" http://vimim.googlecode.com/files/vimim.wubi98.txt
" http://vimim.googlecode.com/files/vimim.wubijd.txt
" http://vimim.googlecode.com/files/fcitx.phrase.pinyin.txt
" http://vimim.googlecode.com/files/fcitx.idiom.pinyin.txt
" http://vimim.googlecode.com/files/fcitx.poem.pinyin.txt

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

" ---------------
" "VimIM Options"
" ---------------
" Detailed usages of all options can be found from references

"   VimIM "OneKey", without mode change
"   - use OneKey to insert multi-byte candidates
"   - use OneKey to search multi-byte using "/" or "?"
"   - use OneKey to directly insert Unicode, integer or hex
"   The default key is <C-\> (Vim Insert Mode)

"   VimIM "Chinese Input Mode"
"   - [static mode] <Space> => Chinese  <Enter> => English
"   - [dynamic mode] show dynamic menu as you type
"   - <Esc> key is in consistent with Vim
"   The default key is <C-^> (Vim Insert Mode)

" # To enable VimIM "Default Off" Options, for example
"   --------------------------------------------------
"   let g:vimim_fuzzy_search=1
"   let g:vimim_static_input_style=1
"
" # To disable VimIM "Default On" Options, for example
"   --------------------------------------------------
"   let g:vimim_unicode_input=0
"   let g:vimim_match_dot_after_dot=0

" -----------------
" "VimIM Data File"
" -----------------
" The datafile is assumed to be in order, otherwise, it is auto sorted.
" The basic vimim datafile format is simple and flexible:
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
    call s:vimim_initialize_datafile_name()
    " -----------------------------------
    call s:vimim_debug()
    " -----------------------------------
    call s:vimim_initialize_pinyin()
    call s:vimim_initialize_double_pinyin()
    " -----------------------------------
    call s:vimim_initialize_wubi()
    " -----------------------------------
    call s:vimim_initialize_other_valid_key()
    " ---------------------------------
    call s:vimim_initialize_color()
    call s:vimim_initialize_encoding()
    call s:vimim_initialize_punctuations()
    " --------------------------------
    call g:vimim_set_seamless()
    " -----------------------------------
endfunction

" -----------------------------------
function! s:vimim_initialize_global()
" -----------------------------------
    let G = []
    call add(G, "g:vimim_auto_spell")
    call add(G, "g:vimim_datafile")
    call add(G, "g:vimim_diy_mixture_im")
    call add(G, "g:vimim_double_pinyin_abc")
    call add(G, "g:vimim_double_pinyin_microsoft")
    call add(G, "g:vimim_double_pinyin_nature")
    call add(G, "g:vimim_double_pinyin_plusplus")
    call add(G, "g:vimim_double_pinyin_purple")
    call add(G, "g:vimim_easter_egg")
    call add(G, "g:vimim_english2chinese")
    call add(G, "g:vimim_four_corner")
    call add(G, "g:vimim_fuzzy_search")
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
    call add(G, "g:vimim_reverse_look_up")
    call add(G, "g:vimim_save_new_entry")
    call add(G, "g:vimim_seamless_english_input")
    call add(G, "g:vimim_do_search")
    call add(G, "g:vimim_smart_delete_keys")
    call add(G, "g:vimim_unicode_input")
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
    let s:saved_paste=&paste
endfunction

" ------------------------------------
function! s:vimim_initialize_session()
" ------------------------------------
    let s:vimim_debug_flag = 0
    let s:wubi_flag = 0
    let s:pinyin_flag = 0
    let s:double_pinyin_flag = 0
    let s:current_datafile_has_dot_key = 0
    " --------------------------------
    let s:start_row_before = 0
    let s:start_column_before = 1
    let s:pattern_not_found = 0
    " --------------------------------
    let s:diy_double_input_state = 0
    let s:chinese_input_mode = 0
    " --------------------------------
    let s:pageup_pagedown = 0
    let s:menu_reverse = 0
    let s:bs = 0
    " --------------------------------
    let s:chinese_insert_flag = 0
    let s:chinese_punctuation = (s:vimim_chinese_punctuation+1)%2
    " --------------------------------
    let s:insert_without_popup_flag = 0
    let s:extreme_fuzzy_flag = 0
    let s:trash_code_flag = 0
    let s:onekey_loaded_flag = 0
    let s:number_typed_flag = 0
    " --------------------------------
    let s:keyboard_sentence = ''
    let s:keyboard_leading_zero = ''
    let s:keyboard_counts = 0
    let s:keyboards = ['','']
    " --------------------------------
    let s:start_positions   = [0,0,1,0]
    let s:current_positions = [0,0,1,0]
    let s:datafile_lines = []
    let s:alphabet_lines = []
    let s:four_corner_lines = []
    " --------------------------------
    let s:ecdict = {}
    let s:four_corner_unicode_flag = 0
    let s:unicode_menu_display_flag = 0
    " --------------------------------
endfunction

" ----------------------------------
function! s:vimim_initialize_color()
" ----------------------------------
    if s:vimim_menu_color < 1
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

" ------------------------------------------
function! s:vimim_initialize_datafile_name()
" ------------------------------------------
    let debug = "vimim.txt"
    let datafile = s:path . debug
    if filereadable(datafile)
        let s:vimim_debug_flag = 1
    endif
    " -------------------------------
    let datafile = s:vimim_datafile
    if datafile != '0' && filereadable(datafile)
        let s:current_datafile = datafile
        return
    endif
    " -------------------------------
    let input_methods = []
    call add(input_methods, "pinyin")
    call add(input_methods, "pinyin_huge")
    call add(input_methods, "phonetic")
    call add(input_methods, "erbi")
    call add(input_methods, "nature")
    call add(input_methods, "4corner")
    call add(input_methods, "cangjie")
    call add(input_methods, "quick")
    call add(input_methods, "array30")
    call add(input_methods, "wubi")
    call add(input_methods, "wubi98")
    call add(input_methods, "wubijd")
    call map(input_methods, '"vimim." . v:val . ".txt"')
    call add(input_methods, debug)
    for file in input_methods
        let datafile = s:path . file
        if filereadable(datafile)
            break
        endif
    endfor
    " -----------------------
    if datafile =~? 'wubi'
        let s:wubi_flag = 1
    elseif datafile =~? 'pinyin'
        let s:pinyin_flag = 1
    endif
    " -----------------------
    let s:current_datafile = datafile
    return
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

" ----------------------------------
function! s:vimim_set_valid_key(key)
" ----------------------------------
    let key = a:key
    if s:vimim_wildcard_search > 0
        let wildcard = '[*]'
        if s:vimim_static_input_style > 0
            let wildcard = '[*?]'
        endif
        let key_valid = strpart(key, 1, len(key)-2)
        let key_wildcard = strpart(wildcard, 1, len(wildcard)-2)
        let key = '[' . key_valid . key_wildcard . ']'
    endif
    let s:valid_key = key
    let key = s:vimim_expand_character_class(key)
    let s:valid_keys = split(key, '\zs')
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

" --------------------------------------------
function! s:vimim_initialize_other_valid_key()
" --------------------------------------------
    if s:wubi_flag > 0 || s:pinyin_flag > 0
        return
    endif
    let key = "[0-9a-z.]"
    let input_method = s:current_datafile
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
    elseif input_method =~ 'corner'
        let s:vimim_four_corner = 1
        let key = "[0-9]"
    endif
    " -----------------------------------
    call s:vimim_set_valid_key(key)
    " -----------------------------------
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

    if s:vimim_seamless_english_input > 0
    \&& s:number_typed_flag < 1
    \&& len(s:seamless_positions) > 0
    \&& s:chinese_input_mode > 0
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
    while start_column > 0
    \&& (char_before =~# s:valid_key || char_before =~# '\u')
    \&& ((s:chinese_input_mode==2 && char_before !~ '\d')
          \|| s:chinese_input_mode<2)
        let start_column -= 1
        let char_before = current_line[start_column-1]
    endwhile

    " datafile update: get user's previous selection
    " ----------------------------------------------
    if start_row >= s:start_row_before
        let chinese = s:vimim_chinese_before(start_row,start_column)
        if s:vimim_save_input_history_frequency > 0
        \&& len(chinese)>0
        \&& char2nr(chinese)>127
        \&& len(get(s:keyboards,0)) > 0
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
    if s:vimim_four_corner > 0
    \&& str2nr(keyboard) > 0
    \&& str2nr(s:keyboard_leading_zero) > 0
        let keyboard = s:keyboard_leading_zero
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
    " --------------------------------------------------
    if s:chinese_input_mode > 1 && s:trash_code_flag > 0
        let s:trash_code_flag = 0
        return [" "]
    endif

    " support direct Unicode input
    " ----------------------------
    if s:vimim_unicode_input > 0
        let unicodes = s:vimim_unicode(keyboard)
        if len(unicodes) > 0
            let s:unicode_menu_display_flag = 1
            return s:vimim_popupmenu_list(unicodes, 3)
        endif
    endif

    " hunt real easter eggs ... vim<C-\>
    " ----------------------------------
    if keyboard =~# "vim"
        return s:vimim_easter_eggs()
    endif

    " hunt for easter egg only if enabled
    " -----------------------------------
    if s:vimim_easter_egg > 0
        let egg = s:vimim_easter_egg(keyboard)
        if len(egg) > 0
            return egg
        endif
    endif

    " -----------------------------------
    " initialize omni completion function
    " -----------------------------------
    let &pumheight=9
    let s:insert_without_popup_flag = 0
    let s:pattern_not_found = 1
    let localization = s:vimim_localization()
    let delimiter = "."

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
    if len(keyboard) < 1
    \|| keyboard !~ s:valid_key
    \|| strpart(keyboard,0,1) ==# "[A-Z]"
    \|| (len(keyboard)<2 && keyboard =~ "[.?*]")
        return
    endif

    " support major double pinyin with various rules
    " ----------------------------------------------
    if s:double_pinyin_flag > 0
        let results = s:vimim_double_pinyin(keyboard)
        if len(results) > 0
            return s:vimim_popupmenu_list(results, localization)
        endif
    endif

    " --------------------------------------------
    " do double search for diy double input method
    " --------------------------------------------
    if s:vimim_diy_mixture_im > 0
        let keyboards = s:vimim_diy_keyboard(keyboard)
        let mixtures = s:vimim_diy_results(keyboards)
        if len(mixtures) > 0
            return s:vimim_popupmenu_list(sort(mixtures), localization)
        endif
    endif

    " support wubi non-stop input
    " ---------------------------
    if s:wubi_flag > 0
        let results = s:vimim_wubi(keyboard)
        if len(results) > 0
            return s:vimim_popupmenu_list(results, localization)
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
    if empty(lines)
        return
    endif

    " -------------------------------------------
    " do wildcard search: explicitly fuzzy search
    " -------------------------------------------
    if s:vimim_wildcard_search > 0
    \&& s:chinese_input_mode < 2
        let wildcard_pattern = "[*?]"
        let wildcard = match(keyboard, wildcard_pattern)
        if wildcard > 0
            let fuzzies_star = substitute(keyboard,'[*]','.*','g')
            let fuzzies = substitute(fuzzies_star,'?','.','g')
            let fuzzy = '^' . fuzzies . '\>'
            call filter(lines, 'v:val =~ fuzzy')
            return s:vimim_popupmenu_list(lines, localization)
        endif
    endif

    " escape literal dot if Array/Phonetic input method
    " -------------------------------------------------
    if s:current_datafile_has_dot_key > 0
        let keyboard = substitute(keyboard,'\.','\\.','g')
    endif
    let match_start = match(lines, '^'.keyboard)

    " to support auto_spell, if needed
    " --------------------------------
    if match_start < 0
        let match_start = s:vimim_auto_spell(lines, keyboard)
    endif

    " ----------------------------------------
    " do exact match search on sorted datafile
    " ----------------------------------------
    if !empty(s:vimim_match_word_after_word)
    \&& stridx(keyboard, delimiter) > -1
        let match_start = -1
    endif
    if match_start > -1
        let results = []
        let has_digit = match(keyboard, '\d\+')
        if s:vimim_four_corner > 0
        \&& has_digit > -1
        \&& len(keyboards) > 1
            let results = s:vimim_quick_fuzzy_search(keyboard)
        else |" [normal] do fine tunning exact match
            let s:keyboards[0] = keyboard
            let s:keyboard_sentence = ''
            let results = s:vimim_exact_match(lines,keyboard,match_start)
        endif
        return s:vimim_popupmenu_list(results, localization)
    endif

    " assume it is hex unicode if no match for 4 corner
    " -------------------------------------------------
    if match_start < 0
        let results = s:vimim_hex_unicode(keyboard)
        if len(results) > 0
            return s:vimim_popupmenu_list(results, 3)
        endif
    endif

    " -----------------------------------------------------
    " word matching algorithm for chinese word segmentation
    " -----------------------------------------------------
    if match_start < 0
        let has_delimiter = match(a:keyboard, '[.]')
        let has_digit = match(keyboard, '\d\+')
        let char_last = strpart(keyboard, len(keyboard)-1, 1)
        let results = []
        if has_delimiter < 0 && has_digit < 0
            let results = s:vimim_sentence_match(lines, keyboard)
        elseif has_delimiter > 0 && char_last != delimiter
            let results = s:vimim_dot_after_dot_match(lines, keyboard)
        endif
        if empty(results)
            let s:keyboard_sentence = ''
        else
            return s:vimim_popupmenu_list(results, localization)
        endif
    endif

    " -------------------------------------------
    " do fuzzy search: implicitly wildcard search
    " -------------------------------------------
    if match_start < 0
        let results = s:vimim_fuzzy_match(lines, keyboard)
        return s:vimim_popupmenu_list(results, localization)
    endif

endif
endfunction

" ================================ }}}
" ====  VimIM Popup Menu      ==== {{{
" ====================================

" -----------------------------------------------------
function! s:vimim_pair_list(matched_list, localization)
" -----------------------------------------------------
    let matched_list = a:matched_list
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
        let line = substitute(line,'#',' ','g')
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
    if empty(matched_list)
        return []
    endif
    let page = &pumheight-1
    if page < 1
        let page = 8
    endif
    if empty(s:pageup_pagedown)
    \|| len(matched_list) < page + 2
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

" ----------------------------------------------------------
function! s:vimim_popupmenu_list(matched_list, localization)
" ----------------------------------------------------------
    let matched_list = a:matched_list
    if empty(matched_list)
        return []
    endif
    let matched_list = s:vimim_pair_list(matched_list, a:localization)
    if s:menu_reverse > 0
        let matched_list = reverse(matched_list)
    endif
    let matched_list = s:vimim_pageup_pagedown(matched_list)
    let label = 0
    if empty(s:vimim_number_as_navigation)
        let label = 1
    endif
    let popupmenu_list = []
    " ----------------------
    for pair in matched_list
    " ----------------------
        let complete_items = {}
        let pairs = split(pair)
        let menu = get(pairs, 0)
        let chinese = get(pairs, 1)
        if s:vimim_menu_extra_text > 0
            let display = menu
            if s:four_corner_unicode_flag > 0
            \&& match(display, '^\d\{4}$') == 0
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
    return lines[get(ranges,0) : get(ranges,1)]
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
    let last_line = a:lines[-1]
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
        let ranges = ['The_datafile_is_not_sorted_well']
    endif
    return ranges
endfunction

" ---------------------------------------------------
function! s:vimim_exact_match(lines, keyboard, start)
" ---------------------------------------------------
    if empty(a:lines) || empty(a:keyboard)
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
    if result == 0
        let match_end = match_start
    elseif result > 0 && result > match_start
        let match_end = result
    elseif match_end - match_start > words_limit
        let match_end = match_start + words_limit -1
    endif
    let results = a:lines[match_start : match_end]
    if s:double_pinyin_flag > 0 && s:vimim_diy_mixture_im > 0
        call filter(results, 'v:val !~ "#$"')
    endif
    return results
endfunction

" ---------------------------------------
function! s:vimim_fuzzy_pattern(keyboard)
" ---------------------------------------
    let fuzzy = '.*'
    if s:extreme_fuzzy_flag < 1
        let fuzzy = '.\+'
    endif
    let start = '^'
    let fuzzies = join(split(a:keyboard,'\ze'), fuzzy)
    let end = fuzzy
    let patterns = start . fuzzies . end
    return patterns
endfunction

" --------------------------------------------
function! s:vimim_fuzzy_match(lines, keyboard)
" --------------------------------------------
    if s:vimim_fuzzy_search < 1
    \|| empty(a:lines)
    \|| empty(a:keyboard)
        return []
    endif
    let patterns = s:vimim_fuzzy_pattern(a:keyboard)
    let results = filter(a:lines, 'v:val =~ patterns')
    call filter(results, 'v:val !~ "#$"')
    return s:vimim_filter(results, len(a:keyboard))
endfunction

" ---------------------------------------
function! s:vimim_filter(results, length)
" ---------------------------------------
    let results = a:results
    if s:chinese_input_mode < 2
        if s:extreme_fuzzy_flag < 1
        \&& a:length > 0
        \&& a:length < 5  |" 4_char => 4_chinese
            let patterns = '\s\+.\{'. a:length .'}$'
            call filter(results, 'v:val =~ patterns')
        endif
    endif
    return results
endfunction

" ================================ }}}
" ====  VimIM OneKey          ==== {{{
" ====================================

" ---------------------------
function! s:vimim_onekey_on()
" ---------------------------
    set nolazyredraw
    set hlsearch
    set noignorecase
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
    let s:keyboard_sentence = ''
    call s:vimim_onekey_on()
    if s:onekey_loaded_flag < 1
        let s:onekey_loaded_flag = 1
        call s:vimim_label_on()
        call s:vimim_punctuation_navigation_on()
        call s:vimim_hjkl_navigation_on()
        inoremap<silent><Space> <C-R>=g:vimim_space_key_onekey()<CR>
    endif
    let onekey = ""
    if pumvisible()
        let onekey = s:vimim_keyboard_by_word()
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
        let space = s:vimim_keyboard_by_word()
        if s:chinese_input_mode < 1
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
        let space = s:vimim_keyboard_by_word()
        sil!call s:vimim_onekey_off()
        sil!call g:vimim_reset_after_insert()
        sil!exe 'sil!return "' . space . '"'
    else
        let s:bs = 0
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
        let space = s:vimim_keyboard_by_word()
        sil!call g:vimim_reset_after_insert()
        sil!exe 'sil!return "' . space . '"'
    else
        if s:vimim_smart_punctuation > 0
            let space = s:vimim_smart_punctuation(s:punctuations, space)
            if empty(space)
                let space = ' '
            endif
        endif
    endif
    return space
endfunction

" ----------------------------------
function! g:vimim_space_key_static()
" ----------------------------------
    let space = " "
    if pumvisible()
        let space = s:vimim_keyboard_by_word()
        call g:vimim_reset_after_insert()
    else
        let s:bs = 0
        if s:vimim_smart_punctuation > 0
            let space = s:vimim_smart_punctuation(s:punctuations, space)
            if empty(space)
                let space = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
            endif
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
    " ----------------------
    for _ in range(0,9)
        sil!exe'inoremap<silent> '._.'
        \ <C-R>=<SID>vimim_label("'._.'")<CR>'.
        \'<C-R>=g:vimim_reset_after_insert()<CR>'
    endfor
    " ----------------------
endfunction

" ---------------------------
function! <SID>vimim_label(n)
" ---------------------------
    let n = a:n
    if pumvisible()
        if n == 0
            call g:vimim_reset_after_insert()
            let zero = '\<C-E>\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
            sil!exe 'sil!return "' . zero . '"'
        endif
        let start = ""
        let end = ""
        if empty(s:vimim_number_as_navigation)
            if s:chinese_input_mode < 1
                sil!call s:vimim_onekey_off()
            endif
            let start = '\<C-E>\<C-X>\<C-U>'
            let end = s:vimim_keyboard_by_word()
            let n -= 1
        endif
        let counts = repeat("\<Down>", n)
        sil!exe 'sil!return "' . start . counts . end . '"'
    else
        let s:number_typed_flag = 1
        let s:seamless_positions = []
        let s:bs = 0
        return a:n
    endif
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
" ====  VimIM Sentence Match  ==== {{{
" ====================================

" -----------------------------------------------
function! s:vimim_sentence_match(lines, keyboard)
" -----------------------------------------------
    let demo = 'jiandaolaoshiwenshenghao wozuixihuandeliulanqi'
    if empty(s:vimim_match_word_after_word)
    \|| empty(a:lines)
    \|| empty(a:keyboard)
    \|| len(a:keyboard) < 5
    \|| s:chinese_input_mode > 1
        return []
    endif
    let match_start = 0
    let block = ''
    let max = len(a:keyboard)
    let min = 1
    " -----------------------------------------------------
    while max > 2 && min < len(a:keyboard)
        let max -= 1
        let position = max
        if s:bs > 0
            let min += 1
            let position = min
        endif
        let block = strpart(a:keyboard, 0, position)
        let pattern = '^' . block . '\>'
        let match_start = match(a:lines, pattern)
        if  match_start > -1
            let s:keyboard_sentence = strpart(a:keyboard, position)
            break
        endif
    endwhile
    " -----------------------------------------------------
    let results = []
    if len(block) > 1
        let results = s:vimim_exact_match(a:lines, block, match_start)
    endif
    return results
endfunction

" ----------------------------------------------------
function! s:vimim_dot_after_dot_match(lines, keyboard)
" ----------------------------------------------------
    let demo = 'meet.teacher.say.hello'
    let len = len(a:keyboard)
    if empty(s:vimim_match_dot_after_dot)
    \|| empty(a:lines)
    \|| empty(a:keyboard)
    \|| s:chinese_input_mode > 1
    \|| len < 5
        return []
    endif
    let results = []
    let has_delimiter = match(a:keyboard, '[.]')
    if has_delimiter < 0
        let s:keyboard_sentence = a:keyboard
    else
        let s:keyboard_sentence = strpart(a:keyboard, has_delimiter+1)
    endif
    let key = strpart(a:keyboard, 0, has_delimiter)
    let pattern = '^' . key . '\>'
    let match_start = match(a:lines, pattern)
    if match_start < 0
        let results = s:vimim_fuzzy_match(a:lines, key)
    else
        let results = s:vimim_exact_match(a:lines, key, match_start)
    endif
    return results
endfunction

" ----------------------------------
function! s:vimim_keyboard_by_word()
" ----------------------------------
    let key = "\<C-Y>"
    if len(s:keyboard_sentence) > 0
    \&& s:chinese_input_mode < 2
        let space = '\<C-R>=g:vimim_ctrl_x_ctrl_u()\<CR>'
        let key .= s:keyboard_sentence . space
    endif
    return key
endfunction

" -------------------------------
function! g:vimim_ctrl_x_ctrl_u()
" -------------------------------
    let key = ""
    let char_before = getline(".")[col(".")-2]
    if char_before =~ s:valid_key
        let key = "\<C-X>\<C-U>"
        if empty(s:vimim_sexy_input_style)
            let key .= '\<C-R>=g:vimim_menu_select()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" -----------------------------
function! g:vimim_menu_select()
" -----------------------------
    let select_not_insert = ""
    if pumvisible()
        let select_not_insert = "\<C-P>\<Down>"
        if s:insert_without_popup_flag > 0
            let s:insert_without_popup_flag = 0
            if empty(s:keyboard_sentence)
                let select_not_insert = "\<C-Y>"
            endif
        endif
    endif
    sil!exe 'sil!return "' . select_not_insert . '"'
endfunction

" ================================ }}}
" ====  VimIM Chinese Mode    ==== {{{
" ====================================

" ---------------------------
function! <SID>vimim_toggle()
" ---------------------------
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
    if s:vimim_hjkl_navigation < 1
    \|| s:chinese_input_mode > 1
        return
    endif
    " -------------------------------------
    " hjkl navigation for onekey and static
    " -------------------------------------
    let hjkl_list = split('hjklerycx', '\zs')
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
        elseif a:key == 'r'
            let s:menu_reverse = (s:menu_reverse+1)%2
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
        inoremap<silent> <Space>
        \ <C-R>=g:vimim_space_key_static()<CR>
        " ----------------------------
        sil!call s:vimim_hjkl_navigation_on()
        " ----------------------------
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
endfunction

" ------------------------------------------------
function! s:vimim_insert_for_both_static_dynamic()
" ------------------------------------------------
    let s:chinese_insert_flag = 1
    " --------------------------------------
    sil!call g:vimim_set_seamless()
    " --------------------------------------
    sil!call s:vimim_chinese_mode_setting_on()
    " --------------------------------------
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
    call s:vimim_one_key_mapping()
    " ------------------------
    if s:vimim_auto_copy_clipboard>0 && has("gui_running")
        sil!exe ':%y +'
    endif
    " ------------------------
endfunction

" ------------------------
function! s:vimim_iunmap()
" ------------------------
    for _ in range(0,9)
        sil!exe 'sil!iunmap '. _
    endfor
    " --------------------
    for _ in s:valid_keys
        sil!exe 'sil!iunmap ' . _
    endfor
    " --------------------
    for _ in keys(s:punctuations)
        sil!exe 'sil!iunmap '. _
    endfor
    " --------------------
    sil!iunmap <C-W>
    sil!iunmap <C-U>
    sil!iunmap <C-H>
    sil!iunmap <BS>
    sil!iunmap <CR>
    sil!iunmap <Space>
endfunction

" -----------------------------------------
function! s:vimim_chinese_mode_setting_on()
" -----------------------------------------
    call s:vimim_onekey_on()
    set cpo&vim
    set nopaste
    let &l:iminsert=1
    highlight! lCursor guifg=bg guibg=green
endfunction

" ------------------------------------------
function! s:vimim_chinese_mode_setting_off()
" ------------------------------------------
    call s:vimim_onekey_off()
    let &cpo=s:saved_cpo
    let &paste=s:saved_paste
    let &l:iminsert=0
    highlight lCursor NONE
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
    " otherwise, try seamless chinese input
    " -------------------------------------
    sil!call g:vimim_set_seamless()
    let wubi_enter_as_remove_trash = 0
    let key = "\<CR>"
    if pumvisible()
        let key = "\<C-E>"
        if s:vimim_seamless_english_input < 1
            let key .= " "
        endif
        if wubi_enter_as_remove_trash > 0
            let key = "\<C-Y>"
        endif
    else
        if wubi_enter_as_remove_trash > 0
            let key = s:vimim_bs_for_trash()
        endif
        let char_before = getline(".")[col(".")-2]
        if (char_before =~ s:valid_key || char_before ==# "[A-Z]")
        \&& wubi_enter_as_remove_trash < 1
            let key = ""
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
    if len(a:chinese) < 1 || char2nr(a:chinese) < 127
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
        if len(s:keyboard_sentence) > 0
        \&& s:chinese_input_mode < 2
            let s:bs += 1
            if s:bs == 1
                let key = "\<C-E>\<C-X>\<C-U>"
            elseif s:bs == 2
                let s:bs = 0
                let s:keyboard_sentence = ''
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
    let s:punctuations[';']='；'
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
    " -------------------------------
    sil!call s:vimim_punctuation_on()
    " -------------------------------
    sil!call s:vimim_punctuation_navigation_on()
    " -------------------------------
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
    " -------------------------------
    let value = s:vimim_get_chinese_punctuation(a:key)
    " -------------------------------
    if pumvisible()
        let value = "\<C-Y>" . value
    endif
    " -------------------------------
    sil!exe 'sil!return "' . value . '"'
    " -------------------------------
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
    if len(key)>0 && key =~ '\a' && char2nr(chinese) > 127
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
    \|| empty(keyboard)
    \|| empty(chinese)
    \|| char2nr(chinese) < 127
    \|| keyboard !~ s:valid_key
        return []
    endif
    """ step 1/6: modify datafile in memory based on usage
    let one_line_chinese_list = []
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
    while matched > 0
        let old_item = remove(lines, matched)
        let values = split(old_item)
        call extend(one_line_chinese_list, values[1:])
        let matched = match(lines, patterns, insert_index)
    endwhile
    """ step 4/6: make a new order list
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

" -----------------------------------------
function! s:vimim_save_input_history(lines)
" -----------------------------------------
    let frequency = s:vimim_save_input_history_frequency
    if frequency > 1
        let frequency = (frequency<12) ? 12 : frequency
        if s:keyboard_counts>0 && s:keyboard_counts % frequency==0
            call s:vimim_save_datafile(a:lines)
        endif
    endif
endfunction

" ------------------------------------------
function! s:vimim_load_datafile(reload_flag)
" ------------------------------------------
    if empty(s:datafile_lines) || a:reload_flag > 0
        if filereadable(s:current_datafile)
            let s:datafile_lines = readfile(s:current_datafile)
        endif
    endif
    return s:datafile_lines
endfunction

" --------------------------------------
function! s:vimim_update_datafile(lines)
" --------------------------------------
    if empty(a:lines) || empty(s:datafile_lines)
        return
    else
        let s:datafile_lines = a:lines
    endif
endfunction

" ------------------------------------
function! s:vimim_save_datafile(lines)
" ------------------------------------
    if empty(a:lines) || empty(s:datafile_lines)
        return
    elseif filewritable(s:current_datafile)
        call writefile(a:lines, s:current_datafile)
    endif
endfunction

" ------------------------------
function! <SID>vimim_save(entry)
" ------------------------------
    if empty(a:entry)
        return
    endif
    let entry_split_list = split(a:entry,'\n')
    let entries = []
    let localization = s:vimim_localization()
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
        if localization == 1
            let line = iconv(line, "utf-8", "chinese")
        elseif localization == 2
            let line = iconv(line, &enc, "utf-8")
        endif
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
        let index = match(lines, '^zz')
        if index > -1
            let last_line_index = index - 1
        endif
        let s:alphabet_lines = lines[first_line_index : last_line_index]
        if s:pinyin_flag > 0 |" one to many relationship
            let pinyin_plus_tone = '^\a\+\d\s\+'
            call filter(s:alphabet_lines, 'v:val =~ pinyin_plus_tone')
        endif
        if &encoding == "utf-8"
            let more_than_one_char = '\s\+.*\S\S\+'
            call filter(s:alphabet_lines, 'v:val !~ more_than_one_char')
        endif
    endif
    if empty(s:alphabet_lines)
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
    if s:vimim_four_corner > 0
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
    if len(result_pinyin) > 0
        let result .= "\n" .result_pinyin
    endif
    return result
endfunction

" ================================ }}}
" ====  VimIM Wubi Special    ==== {{{
" ====================================

" ---------------------------------
function! s:vimim_initialize_wubi()
" ---------------------------------
    if empty(s:wubi_flag)
        return
    endif
    " -----------------------------
    let s:valid_key = "[a-z]"
    let key = s:vimim_expand_character_class(s:valid_key)
    let s:valid_keys = split(key, '\zs')
    " -----------------------------
    let s:keyboard_wubi = ''
    if s:vimim_static_input_style > 0
        let s:vimim_wubi_non_stop = 0
    endif
    " -----------------------------
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

" ================================ }}}
" ====  VimIM Pinyin Special  ==== {{{
" ====================================

" -----------------------------------
function! s:vimim_initialize_pinyin()
" -----------------------------------
    if empty(s:pinyin_flag)
        return
    endif
    " -----------------------------
    let key = '[.0-9a-z]'
    call s:vimim_set_valid_key(key)
    " -----------------------------
    if empty(s:wubi_flag)
        let s:vimim_fuzzy_search=1
        let s:vimim_match_word_after_word=1
        let s:vimim_save_input_history_frequency=1
        let s:vimim_punctuation_navigation=1
    endif
    " -----------------------------
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
    endif
    let s:double_pinyin_flag = 1
    let s:vimim_static_input_style = 1
    let s:vimim_fuzzy_search = 0
    let s:vimim_match_word_after_word = 0
    let s:vimim_match_dot_after_dot = 0
    " -----------------------------
    let key = "[a-z;']"
    call s:vimim_set_valid_key(key)
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
    for key in keyboards
        let pattern = '^'.key.'\>'
        let start = match(lines, pattern)
        if start > -1
            let item_results = s:vimim_exact_match(lines, pattern, start)
            call extend(results,item_results)
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
    for key in keyboards
        if len(key) < 2
            continue
        endif
        let pairs = []
        let match_start = match(lines, '^'.key.'\>')
        if  match_start > -1
            call add(pairs, key)
            call add(pairs_list, pairs)
            continue
        endif
        let shengmu = ""
        let char = get(split(key,'\zs'),0)
        if has_key(shengmu_hash, char)
            let shengmu = shengmu_hash[char]
            if shengmu == "'"
                let shengmu = ""
            endif
        endif
        let char = get(split(key,'\zs'),1)
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
" ====  VimIM Unicode         ==== {{{
" ====================================

" -------------------------------------
function! s:vimim_initialize_encoding()
" -------------------------------------
    let s:multibyte = 2
    if &encoding == "utf-8"
        let s:multibyte = 3
        " -----------------------------
        if s:chinese_input_mode < 2
        \&& s:vimim_four_corner > 0
            let s:four_corner_unicode_flag = 1
        endif
        " -----------------------------
    else
        let s:vimim_reverse_look_up = 0
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

" -----------------
function! Unicode()
" -----------------
" This function outputs unicode as:
" ---------------------------------
"   decimal   hex   CJK
"   19968    4e00    #
" ---------------------------------
    if &encoding != "utf-8"
        $put='Your Vim encoding has to be set as utf-8.'
        $put='Unicode() Usage:'
        $put='(in .vimrc):      :set encoding=utf-8'
        $put='(in Vim Command): :call Unicode()<CR>'
    else
        let unicode_start = str2nr('4e00',16)
        let unicode_end   = str2nr('9fa5',16)
        for i in range(unicode_start, unicode_end)
            $put=printf('%d %x ',i,i).nr2char(i)
        endfor
    endif
endfunction

" -------------------
function! Unihan(...)
" -------------------
" This function outputs unicode block by block as:
" ----------------------------------------------------
"      0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
" 4E00 #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #
" ----------------------------------------------------
    if &encoding != "utf-8"
        $put='Your Vim encoding has to be set as utf-8.'
        $put='Unihan() Usage:'
        $put='(in .vimrc):      :set encoding=utf-8'
        $put='(in Vim Command): :call Unihan()<CR>'
        $put='(in Vim Command): :call Unihan(0x8000,16)<CR>'
    else
        let a = 0x4E00| let n = 112-24| let block = 0x00F0
        if (a:0>=1)| let a = a:1| let n = 1| endif
        if (a:0==2)| let n = a:2| endif
        let z = a + n*block - 128
        while a <= z
          if (a%(16*16)==0)
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

" ---------------------------------
function! s:vimim_unicode(keyboard)
" ---------------------------------
    if &encoding != "utf-8"
    \|| s:chinese_input_mode > 1
    \|| strlen(a:keyboard) > 5
    \|| strlen(a:keyboard) < 4
        return []
    endif
    let &pumheight=0
    let s:unicode_menu_display_flag = 0
    let unicode_prefix = 'u'
    let numbers = []
    let keyboard = a:keyboard
    " support unicode popup menu, if ending with dot
    " ----------------------------------------------
    if strpart(keyboard,len(keyboard)-1,1) == "."
        if keyboard =~ '^\d\{4}'     "| 2222.
            let digit_ranges = range(10)
            for i in digit_ranges
                let keyboard = strpart(keyboard,0,4) . i
                let digit = str2nr(keyboard)
                call add(numbers, digit)
            endfor
        elseif keyboard =~ '^\d\x\{2}'  "| 808.
            let hex_ranges = extend(range(10),['a','b','c','d','e','f'])
            for i in hex_ranges
                let keyboard = strpart(keyboard,0,3) . i
                let digit = str2nr(keyboard, 16)
                call add(numbers, digit)
            endfor
        endif
    else
    " support direct unicode insert by 22221 or u808f
    " -----------------------------------------------
        let s:insert_without_popup_flag = 1
        if keyboard =~ '^\d\{5}$'       "| 32911
            let numbers = [str2nr(keyboard)]
        elseif keyboard =~ '\d\x\{3}$'  "| 808f
            let four_hex   = match(keyboard, '^\x\{4}$')
            let four_digit = match(keyboard, '^\d\{4}$')
            if four_hex == 0 && four_digit < 0
                let keyboard = unicode_prefix . keyboard
            endif
            if strpart(keyboard,0,1) == unicode_prefix
                let keyboard = strpart(keyboard,1)
            else
                return []
            endif
            let numbers = [str2nr(keyboard, 16)]
        else
            return []
        endif
    endif
    let unicodes = []
    let unicode_start = str2nr('ff',16)   "| 255
    let unicode_end   = str2nr('ffff',16) "| 65535
    if get(numbers,0) > unicode_end
        return
    endif
    for digit in numbers
        if digit >= unicode_start && digit <= unicode_end
            let hex = printf('%04x', digit)
            let menu = unicode_prefix . hex .'　'. digit
            let unicode = menu.' '.nr2char(digit)
            call add(unicodes, unicode)
        endif
    endfor
    if empty(unicodes)
        let s:insert_without_popup_flag = 0
    endif
    return unicodes
endfunction

" -------------------------------------
function! s:vimim_hex_unicode(keyboard)
" -------------------------------------
    if s:four_corner_unicode_flag < 1
    \|| match(a:keyboard, '^\d\{4}') != 0
        return []
    endif
    let s:insert_without_popup_flag = 1
    let digit = str2nr(a:keyboard, 16)
    let unicode_prefix = 'u'
    let unicode = nr2char(digit)
    let menu = unicode_prefix . a:keyboard .'　'. digit
    return [menu.' '.unicode]
endfunction

" ================================ }}}
" ====  VimIM Easter Egg      ==== {{{
" ====================================

" -----------------------------
function! s:vimim_easter_eggs()
" -----------------------------
    let easter_eggs = []
    call add(easter_eggs, "vi 文本编辑器")
    call add(easter_eggs, "vim 最牛文本编辑器")
    call add(easter_eggs, "vim 精力 生氣")
    call add(easter_eggs, "vimim 中文输入法")
    return s:vimim_popupmenu_list(easter_eggs, 3)
endfunction

" ------------------------------------
function! s:vimim_easter_egg(keyboard)
" ------------------------------------
    let keyboard = a:keyboard
    if keyboard !~ '^*'
        return []
    endif
    let result = ''
    " play with intial single star or double stars
    " --------------------------------------------
    if keyboard =~ '^*\{1}\w' && s:chinese_input_mode < 2
        let result = strpart(keyboard,1)
    elseif keyboard =~ '^*\{2}\w'
        if keyboard =~ '*\{2}casino'
            " **casino -> congratulations! US$88000
            let casino = matchstr(localtime(),'..$')*1000
            let casino = 'casino US$'.casino
            let casino = s:vimim_translator(casino)
            let result = casino
        elseif keyboard =~ '*\{2}girls'
            let result = s:vimim_translator('girls')
        elseif keyboard =~ '*\{2}today' || keyboard =~ '*\{2}now'
            " **today  -> 2009 year February 22 day Wednesday
            if keyboard =~ '*\{2}today'
                let today = strftime("%Y year %B %d day %A")
                let today = s:vimim_translator(today)
                let result = today
            " **now -> Sunday AM 8 hour 8 minute 8 second
            elseif keyboard =~ '*\{2}now'
                let now=strftime("%A %p %I hour %M minute %S second")
                let now=s:vimim_translator(now)
                let result = now
            endif
        elseif keyboard =~ '*\{2}\d\+'
                let digit = strpart(keyboard,2)
                let result = s:vimim_number_translator(digit)
        endif
    endif
    let results = []
    if len(result) > 0
        let result .= ' '
        let results = [result]
        let s:insert_without_popup_flag = 1
    endif
    return results
endfunction

" -------------------------------------------
function! s:vimim_number_translator(keyboard)
" -------------------------------------------
    if a:keyboard !~ '\d\+'
        return ''
    endif
    let numbers = {}
    let numbers['0'] = 'zero'
    let numbers['1'] = 'one'
    let numbers['2'] = 'two'
    let numbers['3'] = 'three'
    let numbers['4'] = 'four'
    let numbers['5'] = 'five'
    let numbers['6'] = 'six'
    let numbers['7'] = 'seven'
    let numbers['8'] = 'eight'
    let numbers['9'] = 'nine'
    let chinese = ''
    let digit_list = split(a:keyboard,'\ze')
    for digit in digit_list
        let english_number = numbers[digit]
        let chinese .= s:vimim_translator(english_number)
        if empty(chinese)
            let chinese .= english_number . ' '
        endif
    endfor
    return chinese
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
    if empty(s:vimim_english2chinese)
    \|| len(s:ecdict) > 1
        return ''
    endif
    let lines = s:vimim_load_datafile(0)
    if empty(lines)
        return ''
    endif
    " --------------------------------------------------
    " VimIM rule for entry of english chinese dictionary
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
    let localization = s:vimim_localization()
    let s:ecdict = copy(s:translators)
    let s:ecdict.dict = {}
    for line in dictionary_lines
        if empty(line)
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
        let s:ecdict.dict[words[0]] = words[1]
    endfor
endfunction

" ================================ }}}
" ====  VimIM DIY             ==== {{{
" ====================================

" -----------------------
function! s:vimim_debug()
" -----------------------
    if empty(s:vimim_debug_flag)
        return
    endif
    let s:vimim_static_input_style=0
    let s:vimim_number_as_navigation=0
    let s:vimim_double_pinyin_microsoft=0
    let s:vimim_tab_for_one_key=1
    let s:vimim_wildcard_search=1
    let s:vimim_diy_mixture_im=1
    let s:vimim_menu_color=0
    let s:vimim_four_corner=1
    let s:vimim_english2chinese=1
    let s:vimim_menu_extra_text=1
    let s:vimim_easter_egg=1
    let s:vimim_reverse_pageup_pagedown=1
    let s:pinyin_flag=1
    " ------------------------------
endfunction

" --------------------------------------
function! s:vimim_diy_keyboard(keyboard)
" --------------------------------------
    let keyboard = a:keyboard
    if len(keyboard) < 2
    \|| s:chinese_input_mode > 1
    \|| s:vimim_diy_mixture_im < 1
        return []
    endif
    let lines = s:vimim_load_datafile(0)
    let match_start = match(lines, '^'.keyboard.'\>')
    if  match_start > -1
        return []
    endif
    let s:diy_double_input_state = 0 |" using_delimiter_flag
    " --------------------------------
    let delimiter = "."
    let stridx_1 = stridx(keyboard, delimiter)
    let stridx_2 = stridx(keyboard, delimiter, stridx_1+1)
    let char_first = strpart(keyboard,0,1)
    let char_last  = strpart(keyboard,len(keyboard)-1,1)
    if char_last == delimiter && s:chinese_input_mode < 2
        let s:extreme_fuzzy_flag = 1
    else
        let s:extreme_fuzzy_flag = 0
    endif
    let keyboards = []
    if stridx_1 > -1
        if char_first == delimiter
        \|| stridx_2 > -1
        \|| len(s:keyboard_sentence) > 0
            return []
        endif
        let alpha_string = strpart(keyboard, 0, stridx_1)
        let digit_string = strpart(keyboard, stridx_1+1)
        if s:vimim_four_corner > 0
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
        let keyboards = [alpha_string, digit_string]
    endif
    " -------------------------------------
    let break_into_three = 0
    if s:vimim_four_corner > 0
        let digit = match(keyboard, '\d\+')
        let alpha = match(keyboard, '\a\+')
        if digit < 0 || alpha < 0
            return []
        endif
        let s:diy_double_input_state = 1 |" using_4corner_flag
        let alpha_string = strpart(keyboard, 0, digit)
        let digit_string = strpart(keyboard, digit)
        if alpha > 0
            let s:diy_double_input_state = 2 |" 17ma  1_char
            let alpha_string = strpart(keyboard, alpha)
            let digit_string = strpart(keyboard, 0, alpha)
        elseif len(alpha_string)==2 && len(digit_string)>2
            let digit_string = strpart(keyboard, digit, 2)
            let break_into_three = strpart(keyboard, digit+2)
        endif
        if empty(alpha_string) || empty(digit_string)
            let s:diy_double_input_state = 0
            return []
        endif
    endif
    "  ml7140 => ['ml', '71', '40'] => 馬力 7132 4002
    let keyboards = [alpha_string, digit_string, break_into_three]
    let shengmu = "[aeiouv]" |" ma3 => 1 char;  pd2 => 2 chars
    if s:diy_double_input_state < 2
    \&& str2nr(digit_string) < 5
    \&& len(alpha_string) > 1
    \&& strpart(alpha_string, len(alpha_string)-1) =~ shengmu
        return [] |" do nothing if meaningful pinyin tone 1,2,3,4
    endif
    return keyboards
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

" --------------------------------------
function! s:vimim_diy_results(keyboards)
" --------------------------------------
    if empty(a:keyboards)
        return []
    endif
    let fuzzy_lines = s:vimim_quick_fuzzy_search(get(a:keyboards,0))
    let hash_0 = s:vimim_diy_lines_to_hash(fuzzy_lines)
    let fuzzy_lines = s:vimim_quick_fuzzy_search(get(a:keyboards,1))
    let hash_1 = s:vimim_diy_lines_to_hash(fuzzy_lines)
    let fuzzy_lines = s:vimim_quick_fuzzy_search(get(a:keyboards,2))
    let hash_2 = s:vimim_diy_lines_to_hash(fuzzy_lines)
    let mixtures = s:vimim_diy_double_menu(hash_0, hash_1, hash_2)
    return mixtures
endfunction

" -------------------------------------------------------
function! s:vimim_diy_double_menu(hash_0, hash_1, hash_2)
" -------------------------------------------------------
    if empty(a:hash_0)   |" {'马力':'mali','名流':'mingliu'}
    \|| empty(a:hash_1)  |" {'马':'7712'}
        return []        |" {'力':'4002'}
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
    return values
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

" --------------------------------------------
function! s:vimim_quick_fuzzy_search(keyboard)
" --------------------------------------------
    let results = s:vimim_datafile_range(a:keyboard)
    if empty(results)
        return []
    endif
    let s:keyboard_sentence = ''
    let has_digit = match(a:keyboard, '^\d\+')
    if has_digit > -1
        let patterns = "^" .  a:keyboard
        if s:vimim_four_corner == 1001
            " another choice: top-left & bottom-right
            let char_first = strpart(a:keyboard, 0, 1)
            let char_last  = strpart(a:keyboard, len(a:keyboard)-1,1)
            let patterns = '^' .  char_first . "\d\d" . char_last
        endif
        call filter(results, 'v:val =~ patterns')
    else
        let results = s:vimim_fuzzy_match(results, a:keyboard)
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

" ================================ }}}
" ====  VimIM Core Drive      ==== {{{
" ====================================
" profile start /tmp/vimim.profile

" ------------------------------------------
function! s:vimim_smart_delete_key_mapping()
" ------------------------------------------
    inoremap<silent><C-W> <C-R>=<SID>vimim_smart_ctrl_w()<CR>
    inoremap<silent><C-U> <C-R>=<SID>vimim_smart_ctrl_u()<CR>
    inoremap<silent><C-H> <C-R>=<SID>vimim_smart_ctrl_h()<CR>
endfunction

" -----------------------------
function! s:vimim_key_mapping()
" -----------------------------
    inoremap<silent><expr><Plug>VimimOneKey <SID>vimim_onekey()
    inoremap<silent><expr><Plug>VimimChineseToggle <SID>vimim_toggle()
    " ----------------------------------------------------------
    call s:vimim_one_key_mapping()
    " ----------------------------------------------------------
    if s:vimim_reverse_look_up > 0 && !hasmapto('<C-^>', 'v')
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

" ---------------------------------
function! s:vimim_one_key_mapping()
" ---------------------------------
    if empty(s:vimim_one_key)
        return
    endif
    if empty(s:vimim_tab_for_one_key)
        imap<silent> <C-\> <Plug>VimimOneKey
    else
        imap<silent> <Tab> <Plug>VimimOneKey
    endif
endfunction

silent!call s:vimim_initialization()
silent!call s:vimim_key_mapping()
" ====================================== }}}

