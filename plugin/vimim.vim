" =================================================
"             "VimIM —— Vim 中文输入法"
" -------------------------------------------------
" VimIM -- Input Method by Vim, of Vim, for Vimmers
" =================================================

" URL:   http://vim.sourceforge.net/scripts/script.php?script_id=2506
" Group: http://groups.google.com/group/vimim
" Demo:  http://maxiangjiang.googlepages.com/vimim.html

" ====  "The VimIM Introduction"   ==== {{{
" =========================================
"      File: vimim.vim
"    Author: Sean Ma <vimim@googlegroups.com>
"   License: GNU Lesser General Public License
"    Latest: 20090421T114138
" -----------------------------------------------------------
"    Readme: The VimIM is a Vim plugin designed as an independent
"            IM (Input Method) to support the input of any language.
"            It can be used as yet another way to input non-ascii
"            using OneKey in addition to builtin i_<C-V> and i_<C-K>.
"            The VimIM aims to complete the Vim as an editor.
" -----------------------------------------------------------
"  Features: * "Plug & Play"
"            * It can be used as yet another way to input non-ascii.
"            * It is independent of Operating System.
"            * It is independent of Vim mbyte-XIM/mbyte-IME API.
"            * The "Onekey" does ad hoc Chinese input without mode change.
"            * The "static" Chinese Input Mode smooths mixture input.
"            * The "dynamic" Chinese Input Mode has sexy input style.
"            * Support popup menu navigation using "vi key" (hjkl)
"            * Support dynamical adjust menu order on past usage frequency
"            * Support "popular input methods": Pinyin, Wubi, Cangjie, etc
"            * Support user-defined Input Methods without limitation
"            * Support "DIY mixture input methods", with great flexibility
"            * Support all-power "fuzzy search" and "wildcard search"
"            * Support "direct unicode input" using integer or hex
"            * Support input of traditional Chinese (Big5 or GBK set)
"            * Support open, simple and flexible datafile format
" -----------------------------------------------------------
" EasterEgg: (1) (Neither data file nor configuration needed)
"            (2) (in Vim Command-line Mode, type:)  :source %<CR>
"            (3) (in Vim Insert Mode, type 4 char)  vim<C-\>
" -----------------------------------------------------------
"   Install: (1) download any data file you like from the link below
"            (2) drop this file and datafile to the plugin directory
" -----------------------------------------------------------
" Usage (1): [in Insert Mode] "to insert Chinese ad hoc":
"            # type key code and hit <C-\> to insert Chinese
" -----------------------------------------------------------
" Usage (2): [in Insert Mode] "to input Chinese continuously":
"            # hit <C-^> to toggle to VimIM Chinese Input Mode:
"            (2.1) [static]  mode: Space=>Chinese  Enter=>English
"            (2.2) [dynamic] mode: any valid key code => Chinese
" -----------------------------------------------------------
" The VimIM Sample Data File for downloading:
" -------------------------------------------
" http://maxiangjiang.googlepages.com/vimim.pinyin.txt
" http://maxiangjiang.googlepages.com/vimim.double_pinyin.txt
" http://maxiangjiang.googlepages.com/vimim.phonetic.txt
" http://maxiangjiang.googlepages.com/vimim.english.txt
" http://maxiangjiang.googlepages.com/vimim.4corner.txt
" http://maxiangjiang.googlepages.com/vimim.cangjie.txt
" http://maxiangjiang.googlepages.com/vimim.wubi.txt
" http://maxiangjiang.googlepages.com/vimim.wubi98.txt
" http://maxiangjiang.googlepages.com/vimim.array30.txt
" http://maxiangjiang.googlepages.com/vimim.quick.txt
" http://maxiangjiang.googlepages.com/vimim.erbi.txt
" ===================================== }}}

" ====  "The VimIM Instruction"    ==== {{{
" =========================================

" -----------------------
" "The VimIM Design Goal"
" -----------------------
" # Chinese can be input using Vim regardless of encoding
" # Without negative impact to Vim if VimIM is not used
" # No compromise for high speed and low memory usage
" # Making the best use of Vim for Input Methods
" # Most VimIM options are activated by default
" # All  VimIM options can be explicitly disabled at will

" ---------------------------------
" "Sample vimrc to display Chinese"
" ---------------------------------
" set gfn=Courier_New:h12:w7,Arial_Unicode_MS
" set gfw=NSimSun-18030,NSimSun ambiwidth=double
" set enc=utf8 fencs=ucs-bom,utf8,chinese,taiwan,ansi

" -------------------
" "The VimIM Options"
" -------------------
" Detailed usages of all options can be found from references

"   The VimIM "OneKey", without mode change
"   - use OneKey to insert default candidates
"   - use OneKey to directly insert unicode, integer or hex
"   - use OneKey in Visual Mode to translate English to Chinese
"   The default key is <C-\> (Vim Insert Mode & Visual Mode)
" # To disable :let g:vimim_disable_one_key=1

"   The VimIM "Chinese Input Mode"
"   - [static mode] <Space> => Chinese  <Tab> => English
"   - [dynamic mode] show dynamic menu as you type
"   - <Esc> key is in consistent with Vim
"   The default key is <C-^> (Vim Insert Mode)
" # To disable :let g:vimim_disable_chinese_input_mode=1

" # To enable VimIM "Default Off" Options
"   -------------------------------------
"   let g:vimim_enable_static_menu=1
"   let g:vimim_enable_tab_for_one_key=1
"   let g:vimim_enable_wildcard_search=1
"   let g:vimim_enable_...

" # To disable VimIM "Default On" Options
"   -------------------------------------
"   let g:vimim_disable_past_usage_frequency=1
"   let g:vimim_disable_fuzzy_search=1
"   let g:vimim_disable_...

" ---------------------
" "The VimIM Data File"
" ---------------------
" Non UTF-8 datafile is also supported: when the datafile name
" includes 'chinese', it is assumed to be encoded in 'chinese'.

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
" The <value>, separated by spaces, is what will be input.
" The 2nd and the 3rd column can be repeated without restriction.
" ===================================== }}}

" ====  "The VimIM Core Engine"    ==== {{{
" =========================================

if exists("b:loaded_vimim") || &cp || v:version < 700
    finish
endif
let b:loaded_vimim = 1

set completefunc=b:VimIM
" --------------------------------
function! b:VimIM(start, keyboard)
" --------------------------------
if a:start

    let start_row = line('.')
    let start_column = col('.')-1
    let current_line = getline(start_row)
    let char_before = current_line[start_column-1]

    " avoid hanging on triggering nothing
    " -----------------------------------
    if start_column < 1
        return
    endif

    " avoid hanging on triggering non-word char
    " -----------------------------------------
    if char_before !~ s:valid_key
        return
    endif

    " note: use =~# for case sensitive match
    " --------------------------------------
    while start_column > 0 && current_line[start_column-1] =~ s:valid_key
        let start_column -= 1
    endwhile

    " get user's previous selection
    " -----------------------------
    if start_row >= s:start_row_before
        let row = start_row
        let col = start_column
        let row2 = s:start_row_before
        let col2 = s:start_column_before
        let key = s:keyboard_key
        let chinese = s:VimIM_chinese_before(row,col,row2,col2,key)
        if s:vimim_disable_past_usage_frequency < 1
        \&& s:menu_order_update_flag > 0
        \&& len(chinese)>0 && chinese !~ '\w'
            let s:keyboard_chinese = chinese
            let s:keyboard_counts += 1
        endif
    endif
    let s:start_row_before = start_row
    let s:start_column_before = start_column

    if s:vimim_disable_seamless_english_input < 1
        if start_row == s:enter_row
        \&& s:enter_column > start_column
            let start_column = s:enter_column
        endif
    endif

    return start_column

else

    let keyboard = a:keyboard

    if s:vimim_wubi_non_stop > 0
        if len(keyboard) > 4
            let keyboard = strpart(keyboard,4)
        endif
    endif
    let s:keyboard = keyboard

    " support direct Unicode input:
    " (1) 5 whole digits: eg 39340 as &#39340; in HTML
    " (2) 4 hex   digits: eg x99ac as &#x99ac; in HTML
    " -----------------------------------------------------------------
    if s:vimim_disable_direct_unicode_input < 1 && &encoding == "utf-8"
        let unicode = []
        if keyboard =~ '\d\{5}'
            let unicode = s:VimIM_unicode(keyboard, 10)
        elseif keyboard =~ 'x' . '\x\{4}' && s:vimim_chinese_mode < 2
            let keyboard = strpart(keyboard,1)
            let unicode = s:VimIM_unicode(keyboard, 16)
        endif
        if len(unicode) > 0
            return unicode
        endif
    endif

    " do quick english input and hunt for easter eggs
    " -----------------------------------------------
    let english = s:VimIM_quick_English_input(keyboard)
    if len(english) > 0
        return english
    endif

    " Now, build again valid keyboard characters
    " ------------------------------------------
    if strlen(keyboard) < 1
    \||  keyboard !~ s:valid_key
    \||  keyboard =~ '\'
    \|| (keyboard =~ '[' && keyboard =~ ']')
    \|| (keyboard =~ '^[.*?]\+' && s:current_datafile_has_dot_key<1)
    \|| (keyboard !~# "vim" && s:vimim_easter_eggs>0)
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
        let results = [value]
        return results
    endif

    " The data file is loaded once and only once
    " ------------------------------------------
    if s:vimim_datafile_loaded < 1
        let s:vimim_datafile_loaded = 1
        if len(s:current_datafile)>0 && filereadable(s:current_datafile)
            let s:datafile_lines = readfile(s:current_datafile)
        endif
    endif
    let localization = s:VimIM_localization()
    let s:menu_order_update_flag = 0
    let lines = s:datafile_lines

    " initialize and re-order the data file
    " -------------------------------------
    " modify the datafile in memory based on past usage
    if s:vimim_disable_past_usage_frequency < 1
        let chinese = s:keyboard_chinese
        let key = s:keyboard_key
        let new_lines = s:VimIM_order_new(key, chinese, lines)
        if len(new_lines) > 0
            let lines = new_lines
        endif
        let frequency = s:vimim_past_usage_frequency
        if len(new_lines) > 0 && frequency > 0
            let frequency = (frequency<12) ? 12 : frequency
            if s:keyboard_counts>0 && s:keyboard_counts % frequency==0
                sil!call s:VimIM_save_datafile(lines)
            endif
        endif
    endif

    " add boundary to datafile search by one letter only
    " --------------------------------------------------
    let ranges = s:VimIM_search_boundary(keyboard, lines)
    if len(ranges) < 2
        return
    elseif ranges[0] > ranges[1]
        let lines = sort(lines)
        let ranges = s:VimIM_search_boundary(keyboard, lines)
        if len(ranges) < 2 || ranges[0] > ranges[1]
            return
        else
            sil!call s:VimIM_save_datafile(lines)
        endif
    endif

    " --------------------------------------------------
    " do double search for DIY VimIM double input method
    " --------------------------------------------------
    let keyboards = s:VimIM_diy_keyboard(keyboard)
    let s:keyboards = []
    if len(keyboards) > 1
        let s:keyboards = keyboards
        let fuzzy_lines = s:VimIM_quick_fuzzy_search(keyboards[0], lines)
        let hash_menu_0 = s:VimIM_lines_to_hash(fuzzy_lines)
        let fuzzy_lines = s:VimIM_quick_fuzzy_search(keyboards[1], lines)
        let hash_menu_1 = s:VimIM_lines_to_hash(fuzzy_lines)
        let mixtures = s:VimIM_double_menu(hash_menu_0, hash_menu_1)
        if len(mixtures) > 0
            return s:VimIM_popupmenu_list(mixtures, localization)
        endif
    endif

    " now only play with portion of datafile of interest
    " --------------------------------------------------
    let lines = s:datafile_lines[ranges[0] : ranges[1]]

    " -------------------------------------------
    " do wildcard search: explicitly fuzzy search
    " -------------------------------------------
    if s:vimim_enable_wildcard_search > 0
        let wildcard_pattern = '[.*?]'
        if s:current_datafile =~? 'wubi'
            let wildcard_pattern = '[z]'
        elseif s:current_datafile_has_dot_key > 0
            let wildcard_pattern = '[*?]'
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

    " For 4corner, replace initial 0 with o for simplicity
    " For Array/Phonetic input method, escape literal dot
    " ------------------------------------------------------
    if s:current_datafile_has_dot_key > 0
        let keyboard = substitute(keyboard,'\.','\\.','g')
    endif
    let match_start = -1
    let match_start = match(lines, '^'.keyboard)

    " ------------------------------------------
    " to guess user's intention using auto_spell
    " ------------------------------------------
    if s:vimim_enable_auto_spell > 0 && match_start < 0
        let key = s:VimIM_auto_spell(keyboard)
        let match_start = match(lines, '^'.key)
    endif

    " --------------------------------------------
    " to guess user's intention using fuzzy_pinyin
    " --------------------------------------------
    if s:vimim_enable_fuzzy_pinyin > 0 && match_start < 0
        let key = s:VimIM_fuzzy_pinyin(keyboard)
        let match_start = match(lines, '^'.key)
    endif

    " ----------------------------------------
    " do exact match search on sorted datafile
    " ----------------------------------------
    let results = []
    if match_start > -1
        let s:keyboard_key = keyboard
        let digital = -1
        if s:vimim_enable_diy_mixture_im == 4
            let digital_4corner_pattern = '^o\=\d\+'
            let digital = match(keyboard, digital_4corner_pattern)
        endif
        if digital < 0 |" [normal] do fine tunning exact match
            let s:menu_order_update_flag = 1
            let results = s:VimIM_exact_match(match_start, keyboard, lines)
        else           |" [single] do quick fuzzy search if 4corner
            let results = s:VimIM_quick_fuzzy_search(keyboard, lines)
        endif
        return s:VimIM_popupmenu_list(results, localization)
    endif

    " -------------------------------------------
    " do fuzzy search: implicitly wildcard search
    " -------------------------------------------
    if s:vimim_disable_fuzzy_search < 1
    \&& match_start < 0 && strlen(keyboard) > 1
        let fuzzies = join(split(keyboard,'\ze'),'.*')
        let fuzzy = '^' .  fuzzies . '.*'
        let results = filter(lines, 'v:val =~ fuzzy')
        if s:vimim_chinese_mode < 2
            if strlen(keyboard) == 2
                let fuzzy = '\s\+.\{2}$'
            elseif strlen(keyboard) == 3
                let fuzzy = '\s\+.\{3}$'
            endif
            let results = filter(results, 'v:val =~ fuzzy')
        endif
        return s:VimIM_popupmenu_list(results, localization)
    endif

endif
endfunction

" --------------------------------------
function! s:VimIM_diy_keyboard(keyboard)
" --------------------------------------
    let keyboard = a:keyboard
    if len(keyboard) < 3
    \|| s:vimim_chinese_mode > 1
    \|| s:vimim_enable_diy_mixture_im < 1
        return []
    endif
    " -------------------------------------
    let keyboards = []
    let delimiter = "." |" du.o2 => 'du' 'o2' => 端
    let char_first = strpart(keyboard,0,1)
    let char_last  = strpart(keyboard,len(keyboard)-1,1)
    let stridx_1 = stridx(keyboard, delimiter)
    let stridx_2 = stridx(keyboard, delimiter, stridx_1+1)
    if char_first != delimiter && char_last != delimiter
    \&& stridx_1 > -1 && stridx_2 < 0
        let part_1 = strpart(keyboard, 0, stridx_1)
        let part_2 = strpart(keyboard, stridx_1+1)
        if s:vimim_enable_diy_mixture_im == 4
            let digital_4corner_pattern = '^o\=\d\+'
            let digital = match(part_2, digital_4corner_pattern)
            if digital < 0
                return []
            endif
        endif
        let keyboards = [part_1, part_2]
        return keyboards
    endif
    " -------------------------------------
    if s:vimim_enable_diy_mixture_im == 4
        let digital = match(keyboard, '\d\+')
        if digital < 0
            return []
        endif
        let alphabet_string = strpart(keyboard, 0, digital)
        let digit_string = strpart(keyboard, digital)
        if len(alphabet_string) < 1
        \|| len(digit_string) < 1
        \|| (len(digit_string)<2 && str2nr(digit_string)<5)
            return []
        endif
        let keyboards = [alphabet_string, digit_string]
        return keyboards
    endif
endfunction

" ---------------------------------------------------
function! s:VimIM_quick_fuzzy_search(keyboard, lines)
" ---------------------------------------------------
    let keyboard = a:keyboard
    let lines = a:lines
    let results = []
    let ranges = s:VimIM_search_boundary(keyboard, lines)
    if len(ranges) < 2 || ranges[0] > ranges[1]
        return results
    endif
    let results = lines[ranges[0] : ranges[1]]
    let patterns = keyboard
    let digital = -1
    let digital_4corner_pattern = '^o\=\d\+'
    let digital = match(keyboard, digital_4corner_pattern)
    if digital < 0
        " ------------------- for alphabet_string
        let fuzzies = join(split(keyboard,'\ze'),'.*')
        let patterns = '^' .  fuzzies . '.*'
        call filter(results, 'v:val =~ patterns')
        if strlen(keyboard) == 2        |" 2_key => 1_chinese
            let patterns = '\s\+.\{1}$' |" stomach 肚子 胃
        elseif strlen(keyboard) == 3    |" 3_key => 2_chinese
            let patterns = '\s\+.\{2}$'
        endif
    else
        " ------------------- for digit_string
        let patterns = "^" .  keyboard
        if s:vimim_enable_diy_mixture_im > 4
            " top-left & bottom-right
            let char_first = strpart(keyboard,0,1)
            let char_last  = strpart(keyboard,len(keyboard)-1,1)
            let patterns = '^' .  char_first . "\d\d" . char_last
        endif
    endif
    call filter(results, 'v:val =~ patterns')
    return results
endfunction

" ------------------------------------
function! s:VimIM_lines_to_hash(lines)
" ------------------------------------
    let lines = a:lines
    let hash_menu = {}
    for line in lines
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

" -----------------------------------------------------
function! s:VimIM_double_menu(hash_menu_0, hash_menu_1)
" -----------------------------------------------------
    let hash_menu_0 = a:hash_menu_0 |" {'马力':'mali','马':'ma'}
    let hash_menu_1 = a:hash_menu_1 |" {'马':'1712'}
    let values = []
    if empty(hash_menu_0) || empty(hash_menu_1)
        return values
    endif
    let chinese = 2
    if &encoding == "utf-8"
        let chinese = 3
    endif
    for key in keys(hash_menu_0)
        let one_char = key
        if len(key) > 1
            let one_char = strpart(key, 0, chinese)
        endif
        if  has_key(hash_menu_1, one_char)
            let menu_vary = hash_menu_0[key]      |" ma
            let menu_fix  = hash_menu_1[one_char] |" 1712
            let menu = menu_fix . "　" . menu_vary|" 1712 ma
            let pair = menu . " " . key           |" 1712 ma 马
            call add(values, pair)
        endif
    endfor
    return values
endfunction

" ----------------------------------------------------------
function! s:VimIM_popupmenu_list(matched_list, localization)
" ----------------------------------------------------------
    let matched_list = a:matched_list
    if len(matched_list) < 1
        return []
    endif
    let pair_matched_list = []
    " ----------------------
    for line in matched_list
    " ----------------------
        if len(line) < 1
            continue
        endif
        if a:localization == 1
            let line = iconv(line, "chinese", "utf-8")
        elseif a:localization == 2
            let line = iconv(line, "utf-8", &enc)
        endif
        let oneline_list = split(line, '\s\+')
        let menu = remove(oneline_list, 0)
        for word in oneline_list
            call add(pair_matched_list, menu .' '. word)
        endfor
    endfor
    let label = 1 - s:vimim_enable_zero_based_label
    let popupmenu_list = []
    " ----------------------------
    for words in pair_matched_list
    " ----------------------------
        let complete_items = {}
        let pairs = split(words)
        let word = get(pairs, 1)
        if len(word) < 2
            continue
        endif
        if len(s:keyboards) > 1 && s:vimim_enable_diy_mixture_im > 1
            let menu = s:keyboards[0]
            if strlen(menu) == 2
            " ---------------------- ma17  (ma)  2_key => 1_chinese
                if (len(word) != 3 && &encoding == "utf-8")
                \|| (len(word) != 2 && &encoding != "utf-8")
                    continue
                endif
            elseif strlen(menu) == 3
            " ---------------------- mas17 (mas) 3_key => 2_chinese
                if (len(word) != 6 && &encoding == "utf-8")
                \|| (len(word) != 4 && &encoding != "utf-8")
                    continue
                endif
            endif
        endif
        " ----------------------
        let complete_items["word"] = word
        if s:vimim_disable_menu_label < 1
            let abbr = printf('%2s',label) . "\t" . word
            let complete_items["abbr"] = abbr
        endif
        let menu = get(pairs, 0)
        if s:vimim_enable_menu_extra_text > 0
            let sexy_menu = menu
            if s:vimim_enable_diy_mixture_im == 4
                let digital_4corner_pattern = '^o\=\d\{3}\>'
                let digital = match(menu, digital_4corner_pattern)
                if digital > -1
                    let sexy_menu = substitute(menu,'o','0','')
                endif
            endif
            let complete_items["menu"] = sexy_menu
        endif
        let complete_items["dup"] = 1
        let label = label + 1
        call add(popupmenu_list, complete_items)
    endfor

    let s:keyboard_key = menu
    if len(popupmenu_list) < 2
        let s:menu_order_update_flag = 0
    endif
    if s:menu_order_update_flag < 1
        let s:keyboard_key = ''
    endif

    let s:vimim_only_choice_non_stop = 0
    if len(popupmenu_list) == 1
        let s:vimim_only_choice_non_stop = 1
    endif
    return popupmenu_list
endfunction

" ---------------------------------------------------
function! s:VimIM_exact_match(start, keyboard, lines)
" ---------------------------------------------------
    let match_start = a:start
    let match_end = match_start
    let keyboard = a:keyboard
    let lines = a:lines
    let matched_lines = []
    let patterns = '^\(' . keyboard . '\)\@!'
    let result = match(lines, patterns, match_start)-1
    if result - match_start < 1
        let matched_lines = lines[match_start : match_end]
        return matched_lines
    endif
    if s:vimim_disable_quick_key < 1
        if result > match_start
            let words = []
            for line in lines[match_start : result]
                call extend(words, split(line)[1:])
            endfor
            let total_chinese = len(words)
            if total_chinese > 88 || strlen(keyboard) < 2
                let patterns = '^\(' . keyboard . '\>\)\@!'
                let result = match(lines, patterns, match_start)-1
            endif
        endif
    endif
    if result > 0 && result > match_start
        let match_end = result
    endif
    if match_end - match_start > 88
        let match_end = match_start + 87
    endif
    let matched_lines = lines[match_start : match_end]
    return matched_lines
endfunction

" ------------------------------------------------
function! s:VimIM_search_boundary(keyboard, lines)
" ------------------------------------------------
    let lines = a:lines
    let keyboard = a:keyboard
    let first_char_typed = strpart(keyboard,0,1)
    if s:current_datafile_has_dot_key > 0 && first_char_typed == "."
        let first_char_typed = '\.'
    endif
    let patterns = '^' . first_char_typed
    let match_start = match(lines, patterns)
    let ranges = []
    if match_start < 0 || len(lines) < 1
        return []
    endif
    call add(ranges, match_start)
    let match_next = match_start
    let last_line_in_datafile = lines[-1]
    let first_char_last_line = strpart(last_line_in_datafile,0,1)
    if first_char_typed == first_char_last_line
        let match_next = len(lines)-1
    else
        let pattern_next = '^[^' . first_char_typed . ']'
        let result = match(lines, pattern_next, match_start)
        if  result > 0
            let match_next = result
        endif
    endif
    call add(ranges, match_next)
    return ranges
endfunction

" ---------------------------------------------------
function! s:VimIM_order_new(keyboard, chinese, lines)
" ---------------------------------------------------
    let keyboard = a:keyboard
    if len(keyboard) < 1 || keyboard !~ '\a'
        return []
    endif
    let chinese = a:chinese
    if len(chinese) < 1 || chinese =~ '\w'
        return []
    endif
    let lines = a:lines
    """ step 1/4: modify datafile in memory based on usage
    let one_line_chinese_list = []
    let patterns = '^' . keyboard . '\s\+'
    let matched = match(lines, patterns)
    if matched < 0
        return []
    endif
    let insert_index = matched
    """ step 2/4: remove all entries matching key from datafile
    while matched > 0
        let old_item = remove(lines, matched)
        let values = split(old_item)
        call extend(one_line_chinese_list, values[1:])
        let matched = match(lines, patterns, insert_index)
    endwhile
    """ step 3/4: make a new order list
    let used = match(one_line_chinese_list, chinese)
    if used > 0
        let head = remove(one_line_chinese_list, used)
        call insert(one_line_chinese_list, head)
    endif
    """ step 4/4: insert the new order list into the datafile list
    if len(one_line_chinese_list) > 0
        let new_item = keyboard .' '. join(one_line_chinese_list)
        call insert(lines, new_item, insert_index)
    endif
    return lines
endfunction

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
    if chinese =~ '\A' && len(a:key)>0  && a:key =~ '\a'
        let chinese = substitute(chinese,'\p\+','','g')
    endif
    return chinese
endfunction

" ------------------------------------
function! s:VimIM_auto_spell(keyboard)
" ------------------------------------
    " A demo rule for auto spelling:
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
    " A demo rule for fuzzy pinyin:
    "  si   => si & shi
    "  wang => wang & huang
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

" ---------------------------------------------
function! s:VimIM_quick_English_input(keyboard)
" ---------------------------------------------
    let keyboard = a:keyboard
    let results = []
    let result = ''
    """ all capitals remain the same
    if keyboard !~ '\A' && keyboard ==# toupper(keyboard)
        let result = keyboard
    endif
    """ intial single star or double star
    if keyboard =~ '^*' && keyboard !~ '^\d\+\s\+'
        if keyboard =~ '^*\{1}\w'
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
                    let now = strftime("%A %p %I hour %M minute %S second")
                    let now = chinese.translate(now)
                    let result = now
                endif
            elseif keyboard =~ '*\{2}\d\+'
                let number = join(split(strpart(keyboard,2),'\ze'),' ')
                let number = chinese.translate(number)
                let number = join(split(number),'')
                let result = number
            elseif keyboard =~ '*\{2}credits'
                let a='VimIM would never have become what it is now,'
                let a.=' without the help of these people!'
                let a.=' (1) those on vim_use for inspiration'
                let a.=' (2) those on newsmth.net for discussion'
                let a.=' (3) all users for feedback and encouragement'
                let a.=' (4) Yue Wu on newsmth.net for dynamic mode etc'
                let a.=' (5) Tony Mechelynck on vim_use for char_class'
                let a.=' (6) freeai.blogspot.com for Double Pinyin'
                let a.=' (7) dots on groups.google.com for WuBi feedback'
                let result = a
            endif
        endif
    endif
    " --------------------------------------------
    if len(result)>0
            let result .= ' '
        let results = [result]
    endif
    return results
endfunction

" ------------------------------------
function! s:VimIM_unicode(keyboard, n)
" ------------------------------------
    let digit = str2nr(a:keyboard, a:n)
    let results = []
    let start = 19968
    let end = 40870
    if digit > start && digit < end
        let unicode = nr2char(digit)
        let results = [unicode]
    endif
    return results
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
    elseif  &enc == "chinese"
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

" ------------------------------------
function! s:VimIM_save_datafile(lines)
" ------------------------------------
    let datafile = s:current_datafile
    let lines = a:lines
    if len(datafile) < 1 || len(lines) < 1
        return
    endif
    if filewritable(datafile)
        sil!let s:datafile_lines = lines
        sil!call writefile(lines, datafile)
    endif
endfunction

" -----------------------------------
function! s:VimIM_get_datafile_name()
" -----------------------------------
    let datafile = s:vimim_datafile
    if filereadable(datafile)
        return datafile
    endif
    let input_methods = []
    let datafiles = []
    call add(input_methods, "pinyin")
    call add(input_methods, "wubi")
    call add(input_methods, "cangjie")
    call add(input_methods, "quick")
    call add(input_methods, "4corner")
    call add(input_methods, "array30")
    call add(input_methods, "phonetic")
    call add(input_methods, "double_pinyin")
    call add(input_methods, "erbi")
    for method in input_methods
        let datafile = "vimim." . method . ".txt"
        call add(datafiles, datafile)
    endfor
    let default = "vimim.txt"
    call insert(datafiles, default)
    for file in datafiles
        let datafile = s:path . file
        if filereadable(datafile)
            break
        else
            continue
        endif
    endfor
    if !filereadable(datafile)
        let s:vimim_easter_eggs = 1
        let datafile = ''
    endif
    return datafile
endfunction
" ===================================== }}}

" ====  "The VimIM Core FrontEnd"  ==== {{{
" =========================================

" -----------------------------------
function! s:VimIM_initialize_global()
" -----------------------------------
    let G = []
    call add(G, "g:vimim_datafile")
    call add(G, "g:vimim_past_usage_frequency")
    " ------------------------------------------------
    call add(G, "g:vimim_enable_tab_for_one_key")
    call add(G, "g:vimim_enable_static_menu")
    call add(G, "g:vimim_enable_diy_mixture_im")
    call add(G, "g:vimim_enable_wildcard_search")
    call add(G, "g:vimim_enable_menu_extra_text")
    call add(G, "g:vimim_enable_sexy_input_style")
    call add(G, "g:vimim_enable_menu_color")
    call add(G, "g:vimim_enable_fuzzy_pinyin")
    call add(G, "g:vimim_enable_auto_spell")
    call add(G, "g:vimim_enable_menu_hjkl_navigation")
    " ------------------------------------------------
    call add(G, "g:vimim_disable_menu_label")
    call add(G, "g:vimim_disable_quick_key")
    call add(G, "g:vimim_disable_past_usage_frequency")
    call add(G, "g:vimim_disable_one_key")
    call add(G, "g:vimim_disable_square_bracket")
    call add(G, "g:vimim_disable_direct_unicode_input")
    call add(G, "g:vimim_disable_fuzzy_search")
    call add(G, "g:vimim_disable_chinese_input_mode")
    call add(G, "g:vimim_disable_dynamic_mode_autocmd")
    call add(G, "g:vimim_disable_chinese_punctuation")
    call add(G, "g:vimim_disable_english_input_on_enter")
    call add(G, "g:vimim_disable_seamless_english_input")
    call add(G, "g:vimim_disable_wubi_non_stop")
    call add(G, "g:vimim_enable_only_choice_non_stop")
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

" -------------------------------------------------
function! s:VimIM_valid_key(input_method, wildcard)
" -------------------------------------------------
    let s:current_datafile_has_dot_key = 0
    let s:vimim_wubi_non_stop = 0
    let s:vimim_only_choice_non_stop = 0
    let input_method = a:input_method
    let                 key = "[0-9a-z]"
    let key_plus_wildcard = "[?*0-9a-z]"
    if input_method =~ 'wubi'
        let key = "[a-z]"
        let key_plus_wildcard = key
    elseif input_method =~# 'vimim.txt'
        let                 key = "[0-9a-z]"
        let key_plus_wildcard = "[.*0-9a-z]"
    elseif input_method =~ 'double_pinyin'
        let                 key = "[a-z;]"
        let key_plus_wildcard = "[?*a-z;]"
    elseif input_method =~ 'phonetic'
        let s:current_datafile_has_dot_key = 1
        let                 key = "[0-9a-z.,;/\-]"
        let key_plus_wildcard = "[?*0-9a-z.,;/\-]"
    elseif input_method =~ 'array'
        let s:current_datafile_has_dot_key = 1
        let                 key = "[a-z.,;/]"
        let key_plus_wildcard = "[?*a-z.,;/]"
    elseif input_method =~ 'erbi'
        let s:current_datafile_has_dot_key = 1
        let                 key = "[a-z;,./']"
        let key_plus_wildcard = "[?*a-z;,./']"
    endif
    if s:current_datafile_has_dot_key > 0
    \|| input_method =~? 'wubi'
    \|| input_method =~? 'cangjie'
    \|| input_method =~? 'quick'
    \|| input_method =~? 'corner'
        let s:vimim_disable_fuzzy_search = 1
        let s:vimim_disable_square_bracket = 1
        let s:vimim_disable_past_usage_frequency = 1
    endif
    if s:vimim_enable_static_menu < 1
        if input_method =~? 'wubi'
        \&& s:vimim_disable_wubi_non_stop < 1
            let s:vimim_wubi_non_stop = 1
        else
            if s:vimim_enable_only_choice_non_stop > 0
                let s:vimim_only_choice_non_stop = 1
            endif
        endif
    endif
    if a:wildcard > 0
        let key = key_plus_wildcard
    endif
    return key
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

" ----------------------------
function! s:VimIM_initialize()
" ----------------------------
    sil!call s:VimIM_initialize_global()
    " ------------------------------------------------
    let s:current_datafile = s:VimIM_get_datafile_name()
    " ------------------------------------------------
    let msg = "-- User defined completion (^U^N^P) Pattern not found"
    let wildcard = s:vimim_enable_wildcard_search
    let s:valid_key = s:VimIM_valid_key(s:current_datafile, wildcard)
    let key = s:VimIM_expand_character_class(s:valid_key)
    let keys = split(key, '\zs')
    let keys_ext = ["<BS>", "<C-H>"]
    let s:vimim_valid_keys = extend(keys, keys_ext)
    " ----------------------------------------------------
    let s:menu_label = range(1,9)
    let s:menu_hjkl = []
    " ------------------------------------------------
    let s:keyboards = []
    let s:datafile_lines = []
    let s:vimim_chinese_mode = 0
    let s:vimim_easter_eggs = 0
    let s:vimim_chinese_input_mode = 0
    let s:vimim_labels_on_loaded = 0
    let s:vimim_seed_data_loaded = 0
    let s:vimim_datafile_loaded = 0
    let s:vimim_punctuation = 0
    let s:vimim_enable_zero_based_label = 0
    let s:enter_row = 0
    let s:enter_column = 0
    " ------------------------------------------------
    let s:start_row_before = 0
    let s:start_column_before = 0
    let s:keyboard = ''
    let s:keyboard_key = ''
    let s:keyboard_chinese = ''
    let s:keyboard_counts = 0
    let s:menu_order_update_flag = 0
    " ------------------------------------------------
    let s:vimim_dummy_dictionary_loaded = 0
    let s:current_dictionary=''
    let dictionary = s:path . "vimim.english.txt"
    if filereadable(dictionary)
        let s:current_dictionary = dictionary
    endif
    " ------------------------------------------------
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
    " ------------------------------------------------
endfunction

" ---------------------------
function! s:VimIM_seed_data()
" ---------------------------
    if s:vimim_seed_data_loaded
        return
    else
        let s:vimim_seed_data_loaded = 1
    endif
    " --------------------------------
    let s:punctuations = {}
    let punctuations = {}
    let punctuations["#"]="＃"
    let punctuations["%"]="％"
    let punctuations["$"]="￥"
    let punctuations["&"]="※"
    let punctuations["{"]="『"
    let punctuations["}"]="』"
    let punctuations["("]="（"
    let punctuations["!"]="！"
    let punctuations["@"]="・"
    let punctuations["~"]="～"
    let punctuations[")"]="）"
    let punctuations[":"]="："
    let punctuations["+"]="＋"
    let punctuations["-"]="－"
    let punctuations[","]="，"
    let punctuations[";"]="；"
    let punctuations["<"]="《"
    let punctuations[">"]="》"
    let punctuations['"']="“”"
    let punctuations["'"]="‘’"
    let punctuations["."]="。"
    let punctuations["*"]="﹡"
    let punctuations["?"]="？"
    let punctuations["^"]="……"
    let punctuations["_"]="——"
    let punctuations["\\"]="、"
    let s:punctuations_all = copy(punctuations)
    if s:vimim_disable_square_bracket > 0
        let punctuations["["]="【"
        let punctuations["]"]="】"
    endif
    for char in s:vimim_valid_keys
        if has_key(punctuations, char)
            unlet punctuations[char]
        endif
    endfor
    let s:punctuations = punctuations
    " --------------------------------
    let ecdict = {}
    let ecdict['casino']='中奖啦！'
    let ecdict['grass']='天涯何处无芳草！'
    let ecdict['january']='一月'
    let ecdict['february']='二月'
    let ecdict['march']='三月'
    let ecdict['april']='四月'
    let ecdict['may']='五月'
    let ecdict['june']='六月'
    let ecdict['july']='七月'
    let ecdict['august']='八月'
    let ecdict['september']='九月'
    let ecdict['october']='十月'
    let ecdict['november']='十一月'
    let ecdict['december']='十二月'
    let ecdict['am']='上午'
    let ecdict['pm']='下午'
    let ecdict['year']='年'
    let ecdict['day']='号'
    let ecdict['hour']='时'
    let ecdict['minute']='分'
    let ecdict['second']='秒'
    let ecdict['monday']='星期一'
    let ecdict['tuesday']='星期二'
    let ecdict['wednesday']='星期三'
    let ecdict['thursday']='星期四'
    let ecdict['friday']='星期五'
    let ecdict['saturday']='星期六'
    let ecdict['sunday']='星期日'
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
    let s:ecdict = ecdict
    " --------------------------------
    let s:dummy=copy(s:translators)
    let s:dummy.dict=copy(s:ecdict)
    " --------------------------------
    let s:easter_eggs = ["vi 文本编辑器"]
    call add(s:easter_eggs, "vim 最牛文本编辑器")
    call add(s:easter_eggs, "vim 精力 生氣")
    call add(s:easter_eggs, "vimim 中文输入法")
    " --------------------------------
endfunction

" -------------------------------
function! <SID>VimIM_e2c(english)
" -------------------------------
    if s:vimim_dummy_dictionary_loaded < 1
        let s:vimim_dummy_dictionary_loaded = 1
        let dictionary_lines = readfile(s:current_dictionary)
        if len(dictionary_lines) > 1
            let localization = s:VimIM_localization()
            for line in dictionary_lines
                if len(line) < 1
                    continue
                endif
                if localization == 1
                    let line = iconv(line, "chinese", "utf-8")
                elseif localization == 2
                    let line = iconv(line, "utf-8", &enc)
                endif
                let items = split(line)
                let s:dummy.dict[items[0]] = items[1]
            endfor
        else
            return
        endif
    endif
    let english = substitute(a:english,'\A',' & ','g')
    let chinese = s:dummy.translate(english)
    let chinese = substitute(chinese,"[ ']",'','g')
    let chinese = substitute(chinese,'\a\+',' & ','g')
    let chinese = substitute(chinese,nr2char(12290),'&\n','g')
    return chinese
endfunction

let s:translators = {}
" ------------------------------------------
function! s:translators.translate(line) dict
" ------------------------------------------
    return join(map(split(a:line),'get(self.dict,tolower(v:val),v:val)'))
endfunction

" --------------------------
function! s:VimIM_label_on()
" --------------------------
    if s:vimim_disable_menu_label < 1
        for n in s:menu_label
            sil!exe'inoremap<silent><expr> '.n.' <SID>VimIM_label("'.n.'")'
        endfor
    endif
    " ---------------------------
    function! <SID>VimIM_label(n)
    " ---------------------------
        if pumvisible()
            let label = 1
            let label -= s:vimim_enable_zero_based_label
            let repeat_times = a:n - label
            let counts = repeat("\<C-N>", repeat_times)
            let end = '\<C-Y>'
            sil!exe 'sil!return "' . counts . end . '"'
        else
            return a:n
        endif
    endfunction
endfunction

" --------------------------
function! <SID>Smart_Space()
" --------------------------
    if pumvisible()
        if s:vimim_wubi_non_stop > 0
            let s:keyboard = ''
        endif
        let key = "\<C-Y>"
        sil!exe 'sil!return "' . key . '"'
    else
        return " "
    endif
endfunction

" ---------------------------
function! <SID>Space_static()
" ---------------------------
    if pumvisible()
        return "\<C-N>\<C-P>"
    else
        let space = " "
        if s:vimim_enable_menu_hjkl_navigation > 0
            let space = ""
        endif
        return space
    endif
endfunction

" -------------------------
function! s:VimIM_hjkl_on()
" -------------------------
    if s:vimim_enable_menu_hjkl_navigation > 0
       if s:vimim_chinese_mode < 2 && len(s:menu_hjkl) > 0
           for n in s:menu_hjkl
               sil!exe 'inoremap<silent><expr> '.n.' <SID>VimIM_hjkl("'.n.'")'
           endfor
       endif
    endif
    " --------------------------
    function! <SID>VimIM_hjkl(n)
    " --------------------------
        if pumvisible()
            if a:n == 'e'
                let hjkl = '\<C-E>'
            elseif a:n == 'h'
                let hjkl = '\<PageUp>'
            elseif a:n == 'j'
                let hjkl = '\<C-N>'
            elseif a:n == 'k'
                let hjkl = '\<C-P>'
            elseif a:n == 'l'
                let hjkl = '\<PageDown>'
            elseif a:n == 'y'
                let hjkl = '\<C-Y>'
            endif
            sil!exe 'sil!return "' . hjkl . '"'
        else
            return a:n
        endif
    endfunction
endfunction

" ----------------------------------
function! <SID>:VimIM_left_bracket()
" ----------------------------------
    if pumvisible()
        let bracket = '\<C-Y>\<C-R>=b:VimIM_bracket_left()\<CR>'
        sil!exe 'sil!return "' . bracket . '"'
    else
        return "["
    endif
endfunction
" ----------------------------------
function! <SID>:VimIM_right_bracket()
" ----------------------------------
    if pumvisible()
        let bracket = '\<C-Y>\<C-R>=b:VimIM_bracket_right()\<CR>'
        sil!exe 'sil!return "' . bracket . '"'
    else
        return "]"
    endif
endfunction
" ------------------------------
function! b:VimIM_bracket_left()
" ------------------------------
    let delete_chars = s:VimIM_bracket_square()
    sil!exe 'sil!return "' . delete_chars . '"'
endfunction
" -------------------------------
function! b:VimIM_bracket_right()
" -------------------------------
    let delete_chars = s:VimIM_bracket_square()
    let left =  "\<Left>"
    let right = "\<Right>"
    sil!exe 'sil!return "' . left . delete_chars . right . '"'
endfunction
" --------------------------------
function! s:VimIM_bracket_square()
" --------------------------------
    let delete_chars = ""
    let chinese = 2
    if &encoding == "utf-8"
        let chinese = 3
    endif
    let column_start = s:start_column_before
    let column_end = col('.')-1
    let row_start = s:start_row_before
    let row_end = line('.')
    let repeat_times = (column_end-column_start)/chinese
    if repeat_times > 1 && row_end == row_start
        let delete_chars = repeat("\<BS>", repeat_times-1)
    endif
    return delete_chars
endfunction

" ----------------------------
function! s:VimIM_setting_on()
" ----------------------------
    let s:saved_lazyredraw=&lazyredraw
    let s:saved_iminsert=&l:iminsert
    let s:saved_pumheight=&l:pumheight
    let s:saved_cpo=&cpo
    set cpo&vim
    set nolazyredraw
    let &l:iminsert=1
    let &l:pumheight=9
    highlight! lCursor guifg=bg guibg=green
endfunction

" -----------------------------
function! s:VimIM_setting_off()
" -----------------------------
    let s:vimim_chinese_mode = 0
    let &cpo=s:saved_cpo
    let &lazyredraw=s:saved_lazyredraw
    let &l:iminsert=s:saved_iminsert
    let &l:iminsert=0
    let &l:pumheight=s:saved_pumheight
    highlight! ICursor NONE
endfunction

" ---------------------------
function! s:VimIM_insert_on()
" ---------------------------
    let s:vimim_chinese_input_mode = 1
    sil!call s:VimIM_setting_on()
    sil!iunmap <Tab>
    " =============== static_menu
    if s:vimim_enable_static_menu > 0
        set completeopt=menu
        let s:vimim_chinese_mode = 1
        if s:vimim_enable_menu_hjkl_navigation > 0
            let s:menu_hjkl = split('hjkley', '\zs')
        endif
        inoremap<silent><Space> <C-X><C-U><C-R>=<SID>Space_static()<CR>
        sil!call s:VimIM_hjkl_on()
    endif
    " ============== dynamic_menu (default on)
    if s:vimim_enable_static_menu < 1
        set completeopt=menuone
        let s:vimim_chinese_mode = 2
        let s:menu_hjkl = []
        " --------------------------------
        inoremap<silent> <Space>
        \ <C-R>=<SID>VimIM_dynamic_key()<CR>
        \<C-R>=<SID>Smart_Space()<CR>
        " --------------------------------
        for char in s:vimim_valid_keys
            sil!exe 'inoremap<silent> ' . char . '
            \ <C-R>=<SID>VimIM_dynamic_End()<CR>'. char .
            \'<C-R>=<SID>VimIM_dynamic_key()<CR>'
        endfor
    endif
    " --------------------------------------
    sil!call s:VimIM_label_on()
    if s:vimim_disable_chinese_punctuation < 1
        sil!call s:VimIM_punctuation_on()
        inoremap<silent><expr> <C-\> <SID>VimIM_punctuation_toggle()
    endif
    if s:vimim_disable_english_input_on_enter < 1
        inoremap<silent><expr> <CR> <SID>Smart_Enter()
    endif
endfunction

" --------------------------
function! <SID>Smart_Enter()
" --------------------------
    if s:vimim_wubi_non_stop > 0
        let s:keyboard = ''
    endif
    let s:enter_row = line('.')
    let s:enter_column = col('.')-1
    if pumvisible()
        if s:vimim_disable_seamless_english_input > 0
            let key = "\<C-E>" . " "
        else
            let key = "\<C-E>"
        endif
    else
        let key = "\<CR>"
    endif
    sil!exe 'sil!return "' . key . '"'
endfunction

" --------------------------------
function! <SID>VimIM_dynamic_End()
" --------------------------------
    if pumvisible()
        if s:vimim_wubi_non_stop > 0
            if len(s:keyboard) % 4 == 0
                let key = "\<C-Y>"
                sil!return key
            endif
        endif
        if s:vimim_only_choice_non_stop > 0
            let key = "\<C-Y>"
        endif
        sil!return "\<C-E>"
    else
        sil!return ""
    endif
endfunction

" --------------------------------
function! <SID>VimIM_dynamic_key()
" --------------------------------
    let char_before = getline(".")[col(".")-2]
    if char_before !~ s:valid_key
        sil!return ""
    else
        let key = "\<C-X>\<C-U>"
        if s:vimim_enable_sexy_input_style < 1
        \&& s:vimim_wubi_non_stop < 1
            let key .= '\<C-R>=b:VimIM_menu_select()\<CR>'
        endif
        sil!exe 'sil!return "' . key . '"'
    endif
endfunction

" ----------------------------
function! s:VimIM_insert_off()
" ----------------------------
    let s:vimim_chinese_input_mode = 0
    let s:enter_row = 0
    let s:enter_column = 0
    sil!call s:VimIM_setting_off()
    sil!call s:VimIM_punctuation_off()
    sil!call s:VimIM_label_off()
    sil!call <SID>VimIM_hjkl_off()
    sil!iunmap <CR>
    sil!iunmap <Space>
    for char in s:vimim_valid_keys
        exe 'sil!iunmap ' . char
    endfor
    if s:vimim_wubi_non_stop > 0
        let s:keyboard = ''
    endif
    if s:vimim_enable_tab_for_one_key > 0
        imap<silent> <Tab> <Plug>VimimOneKey
        sil!iunmap   <C-\>
    else
        imap<silent> <C-\> <Plug>VimimOneKey
    endif
endfunction

" ---------------------------
function! s:VimIM_label_off()
" ---------------------------
    let s:vimim_labels_on_loaded = 0
    for key in s:menu_label
        exe 'sil!iunmap '. key
    endfor
endfunction

" -----------------------------
function! <SID>VimIM_hjkl_off()
" -----------------------------
    for key in s:menu_hjkl
        exe 'sil!iunmap '. key
    endfor
    let s:menu_hjkl = []
endfunction

" --------------------------------
function! s:VimIM_punctuation_on()
" --------------------------------
    let s:vimim_punctuation = 1
    for key in keys(s:punctuations)
        let value = s:punctuations[key]
        sil!exe 'inoremap<silent> '. key .' '. value
    endfor
    return ""
endfunction

" ---------------------------------
function! s:VimIM_punctuation_off()
" ---------------------------------
    let s:vimim_punctuation = 0
    for key in keys(s:punctuations)
        sil!exe 'silent! iunmap <silent> '. key
    endfor
    return ""
endfunction

" ---------------------------------------
function! <SID>VimIM_punctuation_toggle()
" ---------------------------------------
    if s:vimim_punctuation < 1
        sil!return s:VimIM_punctuation_on()
    else
        sil!return s:VimIM_punctuation_off()
    endif
endfunction

" ---------------------------
function! <SID>VimIM_toggle()
" ---------------------------
    if s:vimim_chinese_input_mode < 1
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

" ----------------------------
function! <SID>VimIM_one_key()
" ----------------------------
    set completeopt=menu
    set pumheight=9
    let onekey = ""
    let s:vimim_chinese_mode = 0
    let punctuations = s:punctuations
    if s:vimim_labels_on_loaded < 1
        let s:vimim_labels_on_loaded = 1
        if s:vimim_enable_menu_hjkl_navigation > 0
            let s:menu_hjkl = split('hjkley', '\zs')
        endif
        sil!call s:VimIM_label_on()
        sil!call s:VimIM_hjkl_on()
    endif
    if s:vimim_enable_tab_for_one_key > 0
    \|| s:vimim_disable_chinese_input_mode > 0
        let punctuations["."]="。"
        let punctuations["'"]="“"
        let punctuations['"']="”"
        let punctuations[" "]=" \t\t"
        let punctuations["\t"]="\t\t\t"
        inoremap<silent><Space> <C-R>=<SID>Smart_Space()<CR>
    endif
    if pumvisible()
        let onekey = "\<C-Y>"
    else
        let key_before = getline(".")[col(".")-2]
        let key_before_before = getline(".")[col(".")-3]
        if has_key(punctuations, key_before)
        \&& ((key_before_before =~ '\W' && &encoding == "utf-8")
        \|| &encoding != "utf-8")
            let replace = punctuations[key_before]
            let onekey = "\<BS>" . replace
        elseif s:vimim_enable_tab_for_one_key > 0
        \&& ((key_before !~ s:valid_key && &encoding == "utf-8")
        \|| len(key_before) < 1)
            let onekey = "\t"
        else
            let onekey = '\<C-X>\<C-U>\<C-R>=b:VimIM_menu_select()\<CR>'
        endif
    endif
    sil!exe 'sil!return "' . onekey . '"'
endfunction

" -----------------------------
function! b:VimIM_menu_select()
" -----------------------------
    let select_not_insert = ""
    if pumvisible()
        if s:vimim_enable_sexy_input_style < 1
            let select_not_insert = "\<C-P>\<Down>"
        endif
    endif
    return select_not_insert
endfunction

" -------------------------
function! s:VimIM_mapping()
" -------------------------
    xnoremap<silent>      <Plug>VimimOneKey y:put=<SID>VimIM_e2c(@0)<CR>
    inoremap<silent><expr><Plug>VimimOneKey       <SID>VimIM_one_key()
    inoremap<silent><expr><Plug>VimimChineseMode  <SID>VimIM_toggle()
    if s:vimim_disable_one_key < 1
        if s:vimim_enable_tab_for_one_key > 0
            if len(s:current_dictionary) > 0
                xmap<silent> <C-^> <Plug>VimimOneKey
            endif
            imap<silent> <Tab> <Plug>VimimOneKey
        else
            imap<silent> <C-\> <Plug>VimimOneKey
        endif
    endif
    if s:vimim_disable_chinese_input_mode < 1
        imap<silent> <C-^> <Plug>VimimChineseMode
    elseif s:vimim_disable_one_key < 1
        imap<silent> <C-^> <Plug>VimimOneKey
    endif
    if s:vimim_disable_square_bracket < 1
        inoremap<silent><expr> [ <SID>:VimIM_left_bracket()
        inoremap<silent><expr> ] <SID>:VimIM_right_bracket()
    endif
endfunction
" ===================================== }}}

" ====  "The VimIM Core Driver"    ==== {{{
" =========================================
" profile start /tmp/vimim.profile
scriptencoding utf-8
let s:path=expand("<sfile>:p:h")."/"
silent!call s:VimIM_initialize()
silent!call s:VimIM_seed_data()
silent!call s:VimIM_mapping()
" ===================================== }}}
