" =================================================
"             "VimIM —— Vim 中文输入法"
" -------------------------------------------------
" VimIM -- Input Method by Vim, of Vim, for Vimmers
" =================================================

" == "The VimIM Introduction" == {{{
" ==================================
"      File: vimim.vim
"    Author: Sean Ma
"   License: GNU Lesser General Public License
"    Latest: 20090216T133605
"       URL: http://vim.sourceforge.net/scripts/script.php?script_id=2506
" -----------------------------------------------------------
"  Describe: The VimIM is a Vim plugin designed as an independent
"            IM (Input Method) to support the input of any language.
"            It can be used as yet another way to input non-ascii
"            using CTRL-^ in addition to builtin CTRL-V and CTRL-K.
"            The VimIM aims to push the Vim to a higher level.
" -----------------------------------------------------------
"  Features: * "Plug & Play"
"            * CJK can be input as long as it can be read using Vim.
"            * It is independent of the Operating System.
"            * It is independent of Vim mbyte-XIM/mbyte-IME API.
"            * The Input Methods can be freely defined without limit.
"            * The "VimIM One Key" speeds up ad hoc Chinese input.
"            * The "VimIM Chinese Input Mode" makes CJK input pleasure.
"            * Support "all input methods": PinYin, Wubi, Cangjie, etc
"            * Support all-power "fuzzy search" and "wildcards search"
"            * Support pinyin acronym and "fuzzy phonetic"
"            * Support "Quick English Input"
"            * Support "Direct Unicode Input"
"            * Support input of traditional Chinese (Big5 or GBK set)
"            * "Dynamically adjust menu order" on past usage frequency
"            * Intelligent error correction for commonly misspelled words
"            * Embedded with a dummy "English to Chinese translator"
"            * The datafile format is open, simple and flexible.
" -----------------------------------------------------------
" EasterEgg: (1) (No data file & No configuration)
"            (2) (in command-line mode, type:)  :source %<CR>
"            (3) (in insert       mode, type:)  vim<C-X><C-U>
" -----------------------------------------------------------
"   Install: (1) download any data file you like from the link below
"            (2) drop this file and the datafile to the plugin directory
" -----------------------------------------------------------
" Data File: http://maxiangjiang.googlepages.com/vimim.pinyin.txt
"            http://maxiangjiang.googlepages.com/vimim.wubi.txt
"            http://maxiangjiang.googlepages.com/vimim.cangjie.txt
"            http://maxiangjiang.googlepages.com/vimim.quick.txt
"            http://maxiangjiang.googlepages.com/vimim.4corner.txt
"            http://maxiangjiang.googlepages.com/vimim.english.txt
" -----------------------------------------------------------
"   Usage A: in Insert Mode, "to insert Chinese ad hoc":
"            # type key code and hit CTRL-^ to insert Chinese
"   Usage B: in Insert Mode, "to input Chinese continously":
"            # hit CTRL-\ to toggle to VimIM Chinese Input Mode
"            # type any key code defined in input method, and hit Space
" -----------------------------------------------------------
" Screen Shot: http://maxiangjiang.googlepages.com/vimim.gif
" Latest Code: http://maxiangjiang.googlepages.com/vimim.vim
"   HTML Code: http://maxiangjiang.googlepages.com/vimim.vim.html
" Chinese URL: http://maxiangjiang.googlepages.com/vimim.html
"  News Group: http://groups.google.com/group/vimim
" ----------------------------- }}}

" == "The VimIM Instruction" == {{{
" =================================

" ------------------------
" "The VimIM Design Goals"
" ------------------------

" + Chinese can be input using Vim regardless of encoding
" + Without negative impact to Vim if VimIM is not used
" + No comprise for high speed and low memory usage
" + Most VimIM options are activated by default
" + All  VimIM options can be explicitly disabled at will

" "To get started: sample vimrc for displaying Chinese"
" -----------------------------------------------------
" set gfn=Courier_New:h12:w7,Arial_Unicode_MS
" set gfw=NSimSun-18030,NSimSun ambiwidth=double
" set enc=utf8 fencs=ucs-bom,utf8,chinese,taiwan,ansi

" -------------------
" "The VimIM Options"
" -------------------

" "The VimIM OneKey Input"
"   - use OneKey to pick up the default
"   - use OneKey again to perform cycle navigation
"   - use OneKey again to search Vim Dictionary
"   - The default key is i_CTRL-^
" # :let g:vimim_disable_one_key=1 to disable

" "The VimIM Smart Chinese Input Mode"
"   - show dynamic menu as you type
"   - trigger the popup menu using Smart <Space>
"   - toggle VimIM Insert Mode automatically
"   - toggle English and Chinese punctuation
"   The default key is i_CTRL-\
" # :let g:vimim_disable_smart_space=1 to disable

" The VimIM Quick English Input
"   - Quick English input within "VimIM Chinese Input Mode"
"     (1)        EGNLISH  ==> ENGLISH
"     (2)        Vitamin  ==> vitamin
"     (3)        JJanuary ==> January
"     (4) URL:   *http://www.vim.org     ==> http://www.vim.org
"     (5) Email: *vimim@googlegroups.com ==> vimim@googlegroups.com
" # :let g:vimim_disable_quick_english_input=1 to disable

" To disable VimIM "Default On" Options
" -------------------------------------
" # let g:vimim_disable_dynamic_order_by_usage=1
" # let g:vimim_disable_dummy_dictionary=1
" # let g:vimim_disable_auto_spell=1
" # let g:vimim_disable_fuzzy_search=1
" # let g:vimim_disable_fuzzy_pinyin=1
" # let g:vimim_disable_punctuation_toggle=1
" # let g:vimim_disable_popup_label=1
" # let g:vimim_disable_popup_extra_text=1
" # let g:vimim_disable_chinese_punctuation=1
" # let g:vimim_disable_direct_unicode_input=1
" # let g:vimim_disable_non_alphabet_in_key=1
" # let g:vimim_disable_wildcard_search=1

" To enable VimIM "Default Off" Options
" -------------------------------------
" # let g:vimim_enable_non_zero_based_label=0
" # let g:vimim_enable_label_navigation=1
" # let g:vimim_enable_pinyin_tone_input=1
" # let g:vimim_enable_signature="signature"
" # let g:vimim_datafile2="your_2nd_data_file_name"

" ---------------------
" "The VimIM Data File"
" ---------------------

" The data file has to be sorted (:sort) before it can be used.
" The basic format of the data file is simple and flexible:

"    +------+--+-------+
"    |<key> |  |<value>|
"    |======|==|=======|
"    | mali |  |  馬力 |
"    +------+--+-------+

" The <key> is what is typed in alphabet, ready to be replaced.
" The <value>, separated by spaces, is what will be input.
" The 2nd and the 3rd column can be repeated without restriction.

" Following sample data files are provided:
" ------------------ -------------------------
"   vimim.vim         VimIM data file
" ------------------ -------------------------
"  vimim.pinyin.txt   input method for PinYin
"  vimim.wubi.txt     input method for WuBi
"  vimim.cangjie.txt  input method for CangJie
"  vimim.quick.txt    input method for Quick
"  vimim.4corner.txt  input method for 4Corner
"  vimim.english.txt  input method for English
" ------------------ -------------------------

" Non UTF-8 datafile is also supported: when the datafile filename
" includes 'chinese', it is assumed to be encoded in 'chinese'.

" ============================= }}}

" == "The VimIM Core Engine" == {{{
" =================================

if exists("b:loaded_vimim")||&cp||v:version<701
    finish
endif
let b:loaded_vimim=1

scriptencoding utf-8
set completefunc=b:VimIM
" --------------------------------
function! b:VimIM(start, keyboard)
" --------------------------------

if a:start

    let start_row = line('.')
    let start_column = col('.')-1
    let current_line = getline('.')
    let char_before = current_line[start_column-1]

    " define valid characters for input key code
    " ------------------------------------------
    let char_valid = "[*.0-9A-Za-z]"
    if g:vimim_disable_quick_english_input<1
        let char_valid = "[*.0-9A-Za-z:/@]"
    endif
    if g:vimim_disable_non_alphabet_in_key
        let char_valid = "[A-Za-z]"
        let g:vimim_disable_wildcard_search=1
    endif

    " avoid hanging on triggering nothing
    " -----------------------------------
    if start_column < 1
        return
    endif

    " avoid hanging on triggering non-word char
    " -----------------------------------------
    if char_before !~ char_valid
        return
    endif

    " can use =~# for case sensitive match
    " ------------------------------------
    while start_column > 0 && current_line[start_column-1] =~ char_valid
        let start_column -= 1
    endwhile

    " build dynamic menu order based on past usage frequency
    " # the hash key is an alphabet string
    " # the hash value is a list of multibytes
    " ----------------------------------------
    if g:vimim_disable_dynamic_order_by_usage<1
        let char_start = s:start_column_before
        let char_end = start_column-1
        if s:start_row_before <= start_row
            let cjk = ''
            if s:start_row_before == start_row && char_end > char_start
                let cjk = current_line[char_start : char_end]
            elseif start_row - s:start_row_before == 1
                let previous_line = getline(s:start_row_before)
                let char_end = len(previous_line)
                let cjk = previous_line[char_start : char_end]
            endif
            if len(g:keyboards) < s:keyboards_max
                if cjk =~ '\A' && len(s:keyboard_key)>0
                    let cjk = substitute(cjk,'\p\+','','g')
                    if has_key(g:keyboards, s:keyboard_key)
                        let values = g:keyboards[s:keyboard_key]
                        let distinct = match(values, cjk)
                        if distinct < 0
                            call add(values, cjk)
                        else
                            let tail = remove(values, distinct)
                            call add(values, tail)
                        endif
                        let s:keyboard_values = values
                    else
                        let s:keyboard_values = [cjk]
                    endif
                    let g:keyboards[s:keyboard_key] = s:keyboard_values
                endif
            endif
        endif
        let s:start_column_before = start_column
        let s:start_row_before = start_row
    endif

    return start_column

else

    let keyboard = a:keyboard
    let s:keyboard_key = a:keyboard

    let eggs = s:VimIM_More_Easter_Eggs(keyboard)
    if len(eggs) > 0
        return eggs
    endif

    if g:vimim_disable_quick_english_input<1
        let eggs = s:VimIM_Quick_English_Input(keyboard)
        if len(eggs) > 0
            return eggs
        endif
    else
        if keyboard =~ '[:/@]'
            return
        endif
    endif

    " support direct unicode input: 39340 as in HTML &#39340;
    " -------------------------------------------------------
    if g:vimim_disable_direct_unicode_input<1
        if keyboard =~ '\d\d\d\d\d' && &encoding == "utf-8"
            if keyboard > 19968 && keyboard < 40870
                let unicode = nr2char(keyboard)
                return [unicode]
            endif
        endif
    endif

    " The data file is loaded once and only once
    " ------------------------------------------
    sil!call s:VimIM_Load_Datafile()

    " hunt VimIM easter eggs ... vim<C-^>
    " -----------------------------------
    if s:vimim_easter_eggs
        if keyboard !~# "vim"
            return
        endif
        let g:vimim_disable_quick_key=1
        let g:vimim_disable_wildcard_search=1
        let lines=s:easter_eggs
    else
        if !exists("b:datafile_lines")
            let b:datafile_lines = s:datafile_lines
        endif
        let lines = b:datafile_lines
    endif

    " avoid hanging for whatever reasons
    " ----------------------------------
    if strlen(keyboard) < 1
    \|| (keyboard =~ '\')
    \|| (keyboard =~ '[' && keyboard =~ ']')
    \|| (keyboard =~ '^[.*]\+')
        return
    endif

    " wildcard search is explicit fuzzy search
    " ----------------------------------------
    let wildcard = -1
    let do_wildcard_search = 0
    if g:vimim_disable_wildcard_search<1
        let wildcard = match(keyboard, '[.*]')
        if wildcard > 0 && len(keyboard) > 2
            let do_wildcard_search = 1
            let keyboard_head = strpart(keyboard, 0, wildcard)
        endif
    endif

    " Note: limitation for 4 corner data file
    " (1) assuming exact 4 digits as the key
    " (2) no wildcard allowed for key with leading zero
    " -------------------------------------------------
    let pattern = keyboard
    let four_corner = 0
    if wildcard < 0
        if pattern =~ '^\d\+\s\+'
            let four_corner = 1
            let pattern = printf('%04o', pattern)
        else
            let pattern = printf('%s', pattern)
        endif
    endif

    " to enable fast short key search
    " limit search for one-char if only one-char
    " limit search for two-char word if only two-char
    " -----------------------------------------------
    let do_fuzzy_search = 0
    let do_fuzzy_pinyin = 0
    let do_quick_key_search = 0
    let pattern_word = '^' . pattern . '\> '
    let vimim_quick_key_max = 3
    if g:vimim_disable_quick_key
        let vimim_quick_key_max = 0
    endif
    if wildcard < 0
        if strlen(a:keyboard)<vimim_quick_key_max
            let do_quick_key_search = 1
        elseif strlen(a:keyboard) == vimim_quick_key_max
            let space_match = match(lines, pattern_word)
            if  space_match > 0
                let do_quick_key_search = 1
            else
                let do_fuzzy_search = 1
            endif
        else
            if strlen(a:keyboard) < s:fuzzy_search_key_length_max
            \ && g:vimim_disable_fuzzy_search<1
                let do_fuzzy_search = 1
            endif
            if g:vimim_disable_fuzzy_pinyin<1
                let do_fuzzy_pinyin = 1
            endif
        endif
    endif

    " no extra processing for 4 corner
    " --------------------------------
    if pattern =~ '^\d\+'
        let do_fuzzy_search = 0
        let do_fuzzy_pinyin = 0
        let do_quick_key_search = 0
        if strlen(a:keyboard) < 1
            return
        endif
    endif

    " no more cache, no more full table scan
    " find out the exact range on the sorted data file
    " ------------------------------------------------
    let patterns = '^' . pattern
    if do_quick_key_search
        let patterns = pattern_word
    endif
    let match_start = -1
    if wildcard < 0
        let match_start = match(lines, patterns)
    endif

    " ------------------------------------------
    " to guess user's intention using auto_spell
    " ------------------------------------------
    let auto_spell_success = 0
    if match_start < 0
    \ && wildcard < 0
    \ && g:vimim_disable_auto_spell<1
        let pattern = s:VimIM_auto_spell(keyboard)
        let patterns = '^' . pattern
        " --------------------------------------
        let match_start = match(lines, patterns)
        " --------------------------------------
        if match_start > 0
            let auto_spell_success = 1
        endif
    endif

    " no more processing if no match
    " ------------------------------
    if match_start < 0
    \ && do_fuzzy_search < 1
    \ && do_fuzzy_pinyin < 1
    \ && do_quick_key_search < 1
    \ && wildcard < 0
        return
    endif

    " put a limit to the search by one letter only
    " --------------------------------------------
    let match_max_end = match_start
    let match_first_char = strpart(keyboard,0,1)
    let pattern_next = '^[^' . match_first_char . ']'
    let match_max_end = match(lines, pattern_next, match_start)
    if match_first_char == 'z' || s:vimim_easter_eggs
        let match_max_end = len(lines)-1
    endif
    if match_max_end < 0
        return
    endif

    " --------------------------------------------
    " to guess user's intention using fuzzy_pinyin
    " --------------------------------------------
    let fuzzy_pinyin_success = 0
    if g:vimim_disable_fuzzy_pinyin<1
    \ && do_fuzzy_pinyin > 0
    \ && match_start < 0
    \ && wildcard < 0
        let pattern = s:VimIM_fuzzy_pinyin(keyboard)
        let patterns = '^' . pattern
        " --------------------------------------
        let match_start = match(lines, patterns)
        " --------------------------------------
        if match_start > 0
            let fuzzy_pinyin_success = 1
        endif
    endif

    " do fuzzy search using implicit wildcard
    " do explicit wildcard search
    " ---------------------------------------- fuzzy_match
    let fuzzy = '^' . keyboard
    let fuzzy_start = 0
    if (match_start<0 && do_fuzzy_search>0) || do_wildcard_search>0
        let fuzzy_split = keyboard
        let fuzzy_match_start = '^'
        let fuzzy_match_end = '.*'
        let capital = match(keyboard,'\L')
        " "cjHui" -> chunjiewanhui ("H" marks word end)
        " ----------------------------------------------
        if capital > 0
            let keyboard_first_part = strpart(keyboard, 0, capital)
            let keyboard_last_part = strpart(keyboard, capital)
            let fuzzy_split = keyboard_first_part
            let keyboard_last_part = tolower(keyboard_last_part)
            let fuzzy_match_end .= keyboard_last_part . '\s\+'
        endif
        " ----------------------------------------------
        let fuzzies = keyboard
        if wildcard > 0
            let fuzzies = substitute(keyboard,'[*]','.*','g')
            let fuzzy_match_end = '\>'
        else
            let fuzzies = join(split(fuzzy_split,'\ze'),'.*')
        endif
        " ----------------------------------------------
        let fuzzy = fuzzy_match_start .  fuzzies . fuzzy_match_end
        let fuzzy_start = match(lines, fuzzy)
        " ----------------------------------------------
        if fuzzy_start < 0
            return
        endif
    endif

    let matched_list = []
    if fuzzy_start > 0
    " --------------------------------------- fuzzy_match
        let fuzzy_range = match_max_end - fuzzy_start
        if fuzzy_range < 1
            let fuzzy_range = 1
        elseif fuzzy_range > s:fuzzy_search_max
            let fuzzy_range = s:fuzzy_search_max
        endif
        for counts in range(1, fuzzy_range)
            let fuzzy_matched = match(lines, fuzzy, fuzzy_start, counts)
            if fuzzy_matched > 0
                sil!call add(matched_list, lines[fuzzy_matched])
            endif
        endfor
    " --------------------------------------- exact_match
    else
        if do_quick_key_search
            let patterns = pattern_word
        else
            let patterns = '^' . pattern
        endif
        " search one more until not available
        " -----------------------------------
        let counts = 0
        let next_matched = 1
        let match_range = match_max_end - match_start
        if match_range < 1
            let match_range = 1
        elseif match_range > s:exact_search_max
            let match_range = s:exact_search_max
        endif
        while next_matched > 0 && counts < match_range
            let counts += 1
            let next_matched = match(lines,patterns,match_start,counts)
        endwhile
        let match_end = match_start + counts - 2
        if match_end < match_start
            let match_end = match_start+1
        endif
        let matched_list = lines[match_start : match_end]
        if s:vimim_easter_eggs
            let matched_list = lines
        endif
    endif

    let localization = 0
    " ---------------------
    if &encoding == "utf-8"
        if s:datafile_fenc_chinese
            let localization = 1
        endif
    elseif  &enc == "chinese"
        \|| &enc == "gb2312"
        \|| &enc == "gbk"
        \|| &enc == "cp936"
        \|| &enc == "euc-cn"
        if s:vimim_easter_eggs
            let localization = 3
        elseif s:datafile_fenc_chinese < 1
            let localization = 2
        endif
    endif

    " ============ ================= ====
    " vim encoding datafile encoding code
    " ============ ================= ====
    "   utf-8           utf-8          0
    "   utf-8           chinese        1
    "   chinese         utf-8          2
    "   chinese         chinese        3
    " ============ ================= ====

    let single_matched_list = []
    let menu = keyboard
    let word = keyboard
    for line in matched_list
        if len(line) < 1
            continue
        endif
        if localization == 1
            let line = iconv(line, "chinese", "utf-8")
        elseif  localization == 2
            let line = iconv(line, "utf-8", &enc)
        endif
        let oneline_list = split(line, '\s\+')
        let menu = remove(oneline_list, 0)
        for word in oneline_list
            let non_ordered_item = menu .' '. word
            call add(single_matched_list, non_ordered_item)
        endfor
    endfor

    if g:vimim_disable_dynamic_order_by_usage<1
        if has_key(g:keyboards, menu)
            let values = g:keyboards[menu]
            for value in values
                let pattern =  menu .' '. value
                let used = match(single_matched_list, pattern)
                if used > 0
                    let head = remove(single_matched_list, used)
                    call insert(single_matched_list, head)
                endif
            endfor
        endif
    endif

    let label = g:vimim_enable_non_zero_based_label
    let popupmenu_list = []
    for words in single_matched_list
        let pairs = split(words)
        let menu = get(pairs, 0)
        let word = get(pairs, 1)
        let complete_items = {}
        if len(word)>1
            let complete_items["word"] = word
        endif
        if g:vimim_disable_popup_label<1
            if g:vimim_enable_pinyin_tone_input
                if label < s:pinyin_tone+1
                    let label = "0" . label
                endif
            endif
            let abbr = printf('%2s',label) . "\t" . word
            let complete_items["abbr"] = abbr
        endif
        if g:vimim_disable_popup_extra_text<1
            let complete_items["menu"] = menu
        endif
        let complete_items["dup"] = 1
        let label = label + 1
        sil!call add(popupmenu_list, complete_items)
    endfor

    return popupmenu_list
endif
endfunction

" =============================== }}}

" == "The VimIM Core FrontEnd" == {{{
" ===================================

" ------------------------------------
function! s:VimIM_auto_spell(keyboard)
" ------------------------------------
    " samples of auto spelling rule ...
    " .. tign  => tign
    " .. yve   => yue
    " --------------------------------
    let rules = {}
    let rules['ign'] = 'ing'
    let rules['iou'] = 'iu'
    let rules['uei'] = 'ui'
    let rules['uen'] = 'un'
    let rules['mg']  = 'ng'
    let rules['ve']  = 'ue'
    " --------------------------------
    let keyboard = a:keyboard
    let pattern = keyboard
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
    " samples of fuzzy pinyin rule ...
    " .. zhengguoren  => zhongguoren
    " .. chengfengqia => chongfengqia
    " --------------------------------
    let rules = {}
    let rules['eng'] = 'ong'
    let rules['ian'] = 'iang'
    let rules['uan'] = 'uang'
    let rules['an']  = 'ang'
    let rules['in']  = 'ing'
    " --------------------------------
    let keyboard = a:keyboard
    let pattern = keyboard
    for key in keys(rules)
        let new_key = rules[key]
        if keyboard =~ key
            let pattern = substitute(keyboard, key, new_key, '')
            break
        endif
    endfor
    return pattern
endfunction

" ------------------------------------------
function! s:VimIM_More_Easter_Eggs(keyboard)
" ------------------------------------------
    let keyboard = a:keyboard
    let results = []
    if keyboard =~ '^*' && keyboard !~ '^\d\+\s\+'
    " --------------------------------------------
        let result = ''
        let append_space = 1
        let chinese=copy(s:translators)
        let chinese.dict=s:ecdict
        " *casino -> congratulations! US$88000
        " ------------------------------------
        if keyboard ==# '*casino'
            let casino = matchstr(localtime(),'..$')*1000
            let casino = 'casino US$'.casino
            let casino = chinese.translate(casino)
            let result = casino
        elseif keyboard ==# '*girls'
            let result = chinese.translate('grass')
        elseif keyboard ==# '*today' || keyboard ==# '*now'
            " *today  -> 2009 year February 22 day Wednesday
            if keyboard ==# '*today'
                let today = strftime("%Y year %B %d day %A")
                let today = chinese.translate(today)
                let result = today
            " *now    -> Sunday AM 8 hour 8 minute 8 second
            elseif keyboard ==# '*now'
                let now = strftime("%A %p %I hour %M minute %S second")
                let now = chinese.translate(now)
                let result = now
            endif
        elseif keyboard ==# '*author' && &encoding == "utf-8"
            let mxj = nr2char(39340).nr2char(28248).nr2char(27743)
            let mxj = chinese.translate(mxj)
            let url = "http://maxiangjiang.googlepages.com/index.html"
            let result = url
        elseif keyboard =~ '*\d\+'
            let number = join(split(strpart(keyboard,1),'\ze'),' ')
            let number = chinese.translate(number)
            let number = join(split(number),'')
            let result = number
        elseif keyboard =~ '*help'
            let help = "http://maxiangjiang.googlepages.com/vimim.html"
            let result = help
        elseif keyboard =~ '*sign' && len(g:vimim_enable_signature)>1
            let sign = g:vimim_enable_signature
            let result = sign
        elseif keyboard =~ '*todo' && len(g:vimim_enable_todo_list)>1
            let to_be_done = string(g:vimim_enable_todo_list)
            let result = to_be_done
        else
            if g:vimim_disable_quick_english_input<1
                let append_space = 0
            endif
        endif
        " ----------------------------------
        if append_space > 0
            let result = result . ' '
        else
            let result = strpart(keyboard,1)
        endif
        " ----------------------------------
        if len(result)>0
            let results = [result]
        endif
    endif
    return results
endfunction

" ---------------------------------------------
function! s:VimIM_Quick_English_Input(keyboard)
" ---------------------------------------------
    let keyboard = a:keyboard
    let results = []
    " More VimIM way of quick English input
    " -------------------------------------
    if keyboard =~ '^\D'
        let english = ''
        if keyboard ==# toupper(keyboard)
            let english = keyboard." "
        elseif keyboard =~# '^\L'
            let english = tolower(keyboard)
            if strpart(keyboard,0,1) =~? strpart(keyboard,1,1)
                let english  = strpart(keyboard,0,1)
                let english .= tolower(strpart(keyboard,2))
            endif
            if s:enable_dynamic_menu
                let english .= " "
            endif
        endif
        if len(english)>0
            let results = [english]
        endif
    endif
    return results
endfunction

" ----------------------------
function! s:VimIM_Initialize()
" ----------------------------
    let globals = []
    call add(globals, "g:vimim_datafile")
    call add(globals, "g:vimim_datafile2")
    call add(globals, "g:vimim_dictionary")
    " ------------------------------------------------------
    call add(globals, "g:vimim_enable_label_navigation")
    call add(globals, "g:vimim_enable_non_zero_based_label")
    call add(globals, "g:vimim_enable_pumheight")
    call add(globals, "g:vimim_enable_pinyin_tone_input")
    call add(globals, "g:vimim_enable_signature")
    call add(globals, "g:vimim_enable_todo_list")
    " ------------------------------------------------------
    call add(globals, "g:vimim_disable_dynamic_order_by_usage")
    call add(globals, "g:vimim_disable_direct_unicode_input")
    call add(globals, "g:vimim_disable_fuzzy_pinyin")
    call add(globals, "g:vimim_disable_wildcard_search")
    call add(globals, "g:vimim_disable_fuzzy_search")
    call add(globals, "g:vimim_disable_auto_spell")
    call add(globals, "g:vimim_disable_smart_space")
    call add(globals, "g:vimim_disable_smart_space_autocmd")
    call add(globals, "g:vimim_disable_one_key")
    call add(globals, "g:vimim_disable_punctuation_toggle")
    call add(globals, "g:vimim_disable_chinese_punctuation")
    call add(globals, "g:vimim_disable_popup_extra_text")
    call add(globals, "g:vimim_disable_popup_label")
    call add(globals, "g:vimim_disable_non_alphabet_in_key")
    call add(globals, "g:vimim_disable_dynamic_menu")
    call add(globals, "g:vimim_disable_quick_key")
    call add(globals, "g:vimim_disable_quick_english_input")
    call add(globals, "g:vimim_disable_dummy_dictionary")
    " ------------------------------------------------------
    for variable in globals
        if !exists(variable)
            exe 'let '. variable . '=0'
        endif
    endfor
    " ------------------------------------------------------
    let s:keys="abcdefghijklmnopqrstuvwxyz"
    let s:pinyin_tone=0
    if g:vimim_enable_pinyin_tone_input > 0
        let g:vimim_disable_dynamic_menu=0
        let g:vimim_disable_one_key=1
        if g:vimim_enable_pinyin_tone_input < 5
        \|| g:vimim_enable_pinyin_tone_input > 9
            let s:pinyin_tone = 4
            let s:keys .= "1234"
        else
            let s:pinyin_tone = g:vimim_enable_pinyin_tone_input
            let s:keys .= "123456789"
        endif
    endif
    " ------------------------------------------------------
    let msg='User defined completion (^U^N^P) pattern not found'
    let s:vimim="vimim___input_method_by_vim_of_vim_for_vimmers"
    let s:vimim_keys=split(s:keys,'\zs')
    let s:vimim_extkeys=["<BS>","<C-H>"]
    let s:vimim_datafile_loaded=0
    let s:vimim_raw_data_loaded=0
    let s:vimim_raw_dictionary_loaded=0
    let s:vimim_easter_eggs=0
    let s:exact_search_max=100
    let s:fuzzy_search_max=100
    let s:fuzzy_search_key_length_max=12
    let s:enable_dynamic_menu=0
    let s:punctuation_key = []
    let s:punctuation_value = []
    let s:datafile_lines = []
    let s:datafile2_lines = []
    let s:datafile_fenc_chinese=0
    " ---------------------------
    let s:start_row_before = 0
    let s:start_column_before = 0
    let s:keyboard_key = ''
    let s:keyboard_values = []
    let s:keyboards_max = 1992
    let g:keyboards = {}
endfunction

" -------------------------------
function! s:VimIM_Load_Datafile()
" -------------------------------
    if s:vimim_datafile_loaded
        return
    else
        let s:vimim_datafile_loaded=1
    endif
    " ------------------------------
    " load the default data file
    " ------------------------------
    let datafile = g:vimim_datafile
    if !filereadable(datafile)
        let files = ["vimim.pinyin"]
        call add(files, "vimim.wubi")
        call add(files, "vimim.cangjie")
        call add(files, "vimim.quick")
        call add(files, "vimim.4corner")
        for file in files
            call insert(files, file.".txt")
        endfor
        call insert(files, "vimim.txt")
        for file in files
            let datafile = s:path . file
            if filereadable(datafile)
                break
            else
                continue
            endif
        endfor
    endif
    let s:datafile_lines = readfile(datafile)
    " -------------------------------
    " parse filename for fileencoding
    " -------------------------------
    if datafile =~? "chinese"
        let s:datafile_fenc_chinese=1
    elseif datafile =~? "utf"
        let s:datafile_fenc_chinese=0
    endif
    " --------------------------------------
    " support 2nd-datafile-switch on the fly
    " --------------------------------------
    let datafile = g:vimim_datafile2
    if len(datafile)>1
        if filereadable(datafile)
            let s:datafile2_lines = readfile(datafile)
        elseif filereadable(s:path.datafile)
            let s:datafile2_lines = readfile(s:path.datafile)
        endif
    endif
    " --------------------------------
    " show "Easter Egg" if no datafile
    " --------------------------------
    if len(s:datafile_lines)<1 && len(s:datafile2_lines)<1
        let s:vimim_easter_eggs=1
    endif
    " --------------------------------
    if !exists("b:DataFileToggle") || b:DataFileToggle<1
        let b:datafile_lines = s:datafile_lines
    else
        let b:datafile_lines = s:datafile2_lines
    endif
endfunction

" --------------------------------
function! s:VimIM_Labels_On(start)
" --------------------------------
    if g:vimim_disable_popup_label<1 && g:vimim_disable_one_key
        let lbuf = "<buffer>"
    else
        let lbuf = ""
    endif
    if a:start < 6
        for n in range(a:start,9)
            sil!exe 'inoremap '.lbuf.' <silent> <expr> ' . n .
            \' b:VimIM_Label('.n.')'
        endfor
    endif
endfunction

" ----------------------------
function! s:VimIM_Labels_Off()
" ----------------------------
    for n in range(1,9)
        exe 'silent! iunmap <buffer> '.n
    endfor
endfunction

" ------------------------
function! b:VimIM_Label(n)
" ------------------------
    if pumvisible()
        let label = g:vimim_enable_non_zero_based_label
        let counts = repeat("\<C-N>",a:n-label)
        let end = '\<C-Y>"'
        if g:vimim_enable_label_navigation
            let end = '"'
        endif
        sil!exe 'return "' . counts . end
    else
        return a:n
    endif
endfunction

" ------------------------
function! b:VimIM_OneKey()
" ------------------------
    if pumvisible()
        sil!return "\<C-N>"
    else
        set completeopt=menu,preview
        sil!return "\<C-X>\<C-U>\<C-U>\<C-P>"
    endif
endfunction

" --------------------------------
function! s:VimIM_Punctuation_On()
" --------------------------------
    let b:vimim_punctuation=1
    let i = 0
    while i < len(s:punctuation_key)
        let key = s:punctuation_key[i]
        let value = s:punctuation_value[i]
        sil!exe 'inoremap <silent> <buffer> '. key .' '. value
        let i = i+1
    endwhile
endfunction

" ---------------------------------
function! s:VimIM_Punctuation_Off()
" ---------------------------------
    let b:vimim_punctuation=0
    let i = 0
    while i < len(s:punctuation_key)
        let key = s:punctuation_key[i]
        exe 'silent! iunmap <buffer> '. key
        let i = i+1
    endwhile
endfunction

" -----------------------------
function! b:VimIM_Punc_Toggle()
" -----------------------------
    if !exists("b:vimim_punctuation") || b:vimim_punctuation == 0
        sil!call s:VimIM_Punctuation_On()
    else
        sil!call s:VimIM_Punctuation_Off()
    endif
endfunction

" ----------------------------
function! s:VimIM_Setting_On()
" ----------------------------
    let b:saved_completeopt=&completeopt
    let b:saved_lazyredraw=&lazyredraw
    let b:saved_iminsert=&iminsert
    let b:saved_pumheight=&pumheight
    let s:_cpo = &cpo
    if g:vimim_enable_pumheight<1
        let g:vimim_enable_pumheight=10
    endif
    let &pumheight=g:vimim_enable_pumheight
    let &l:iminsert=1
    set completeopt=menuone,preview
    set nolazyredraw
    set cpo&vim
endfunction

" -----------------------------
function! s:VimIM_Setting_Off()
" -----------------------------
    let &completeopt=b:saved_completeopt
    let &lazyredraw=b:saved_lazyredraw
    let &pumheight=b:saved_pumheight
    let &l:iminsert=b:saved_iminsert
    let &cpo = s:_cpo
endfunction

" ---------------------------------
function! b:VimIM_Datafile_Toggle()
" ---------------------------------
    if !exists("b:DataFileToggle") || b:DataFileToggle<1
        let b:DataFileToggle=1
        let b:datafile_lines = s:datafile2_lines
    else
        let b:DataFileToggle=0
        let b:datafile_lines = s:datafile_lines
    endif
endfunction

" -------------------------
function! b:VimIMCheck(map)
" -------------------------
    sil!exe 'sil! if getline(".")[col(".")-2] !~# "[' . s:keys . ']"'
        sil! return ""
    else
        sil! return a:map
    endif
endfunction

" ----------------------
function! b:VimIMSpace()
" ----------------------
    if pumvisible()
        if s:enable_dynamic_menu
            sil! return "\<C-Y>"
        else
            sil! return ""
        endif
    else
        sil! return " "
    endif
endfunction

" ---------------------------
function! b:VimIM_Insert_On()
" ---------------------------
    let b:lang=1
    sil!call s:VimIM_Setting_On()
    inoremap <silent> <buffer> <Space> <C-R>=b:VimIMCheck
    \("\<lt>C-X>\<lt>C-U>")<CR><C-R>=b:VimIMSpace()<CR>
    if len(g:vimim_datafile2)>1
        inoremap <silent> <buffer> <F11>
        \ <C-O>:sil!call b:VimIM_Datafile_Toggle()<CR>
    endif
    if g:vimim_disable_punctuation_toggle<1
        inoremap <silent> <buffer> <S-F11>
        \ <C-O>:sil!call b:VimIM_Punctuation_Toggle()<CR>
    endif
    if g:vimim_disable_chinese_punctuation<1
        sil!call s:VimIM_Punctuation_On()
    endif
    if g:vimim_disable_popup_label<1 && g:vimim_disable_one_key
        let start = 1
        if g:vimim_enable_pinyin_tone_input > 0
            let start = s:pinyin_tone+1
        endif
        sil!call s:VimIM_Labels_On(start)
    endif
    if s:enable_dynamic_menu
        let keys = s:vimim_keys + s:vimim_extkeys
        for char in keys
            sil!exe 'inoremap <silent> <buffer> ' . char . '
            \  <C-R>=pumvisible()?"\<lt>C-E>":""<CR>'. char .
            \ '<C-R>=b:VimIMCheck("\<lt>C-X>\<lt>C-U>")<CR>'
        endfor
    endif
endfunction

" ----------------------------
function! b:VimIM_Insert_Off()
" ----------------------------
    let b:lang=0
    sil!call s:VimIM_Setting_Off()
    silent! iunmap <silent><buffer> <Space>
    if len(g:vimim_datafile2)>1
        silent! iunmap <silent><buffer> <F11>
    endif
    if g:vimim_disable_punctuation_toggle<1
        silent! iunmap <silent><buffer> <S-F11>
    endif
    if g:vimim_disable_chinese_punctuation<1
        sil!call s:VimIM_Punctuation_Off()
    endif
    if g:vimim_disable_popup_label<1 && g:vimim_disable_one_key
        sil!call s:VimIM_Labels_Off()
    endif
    if s:enable_dynamic_menu
        for char in extend(s:vimim_keys,s:vimim_extkeys)
            sil!exe 'silent! iunmap <silent><buffer> ' . char
        endfor
    endif
endfunction

" -------------------------------
function! b:VimIM_Insert_Toggle()
" -------------------------------
    if g:vimim_disable_smart_space_autocmd<1
    \ && !exists("b:smart_space_autocmd")
    \ && has("autocmd")
        let b:smart_space_autocmd = 1
        sil!au InsertEnter <buffer>
        \ if b:lang|sil!call b:VimIM_Insert_On()|endif
        sil!au InsertLeave <buffer>
        \ if b:lang|sil!call b:VimIM_Insert_Off()|let b:lang=1|endif
        sil!au BufUnload   <buffer> autocmd! InsertEnter,InsertLeave
    endif
    if !exists("b:lang") || b:lang<1
        sil!call b:VimIM_Insert_On()
    else
        sil!call b:VimIM_Insert_Off()
    endif
    return "\<C-\>\<C-O>:redraw\<CR>"
endfunction

" -------------------------------
function! s:VimIM_Load_Raw_Data()
" -------------------------------
    if s:vimim_raw_data_loaded
        return
    else
        let s:vimim_raw_data_loaded=1
    endif
    " --------------------------------
    let s:punctuation_key = [ "(", ")", "{", "}",
        \ "[", "]", "<", ">", "+", "-", ",",
        \  ";", "?", "!", "~", "#", "%", "$",
        \ "&", "^", "_", '"', "'", '\']
    " --------------------------------
    let s:punctuation_value = [ "（", "）", "『", "』",
        \ "【", "】", "《", "》", "＋", "－", "，",
        \  "；", "？", "！", "～", "＃", "％", "￥",
        \ "※", "……", "——", "“”", "‘’", "。"]
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
    let ecdict[',']='，'
    let ecdict['.']='。'
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

" -----------------------------------
function! b:VimIM_Translator(english)
" -----------------------------------
    if &encoding != "utf-8"
        return
    endif
    if s:vimim_raw_dictionary_loaded<1
        let s:vimim_raw_dictionary_loaded=1
        let dictionary=g:vimim_dictionary
        if dictionary==0
            let dictionary="vimim.english.txt"
        endif
        let dictionary_lines = []
        if filereadable(dictionary)
            let dictionary_lines = readfile(dictionary)
        elseif filereadable(s:path.dictionary)
            let dictionary_lines = readfile(s:path.dictionary)
        endif
        if len(dictionary_lines)>1
            for line in dictionary_lines
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

" ============================== }}}

" == "The VimIM Core Mapping" == {{{
" ==================================

if !exists("s:vimim_initialize")
" ------------------------------
    let s:vimim_initialize = 1
    let s:path = expand("<sfile>:p:h")."/"
    sil!call s:VimIM_Initialize()
    sil!call s:VimIM_Load_Raw_Data()
endif

if g:vimim_disable_one_key<1
" --------------------------
    sil!call s:VimIM_Labels_On(1)
    inoremap <silent> <expr> <C-^> b:VimIM_OneKey()
    if g:vimim_disable_dummy_dictionary<1
        xnoremap <silent> <C-^> y']:put_<CR>:put=b:VimIM_Translator(@0)<CR>
    endif
endif

if g:vimim_disable_smart_space<1
" ------------------------------
    if g:vimim_disable_dynamic_menu<1
        let s:enable_dynamic_menu=1
    endif
    inoremap <silent> <expr> <C-\> b:VimIM_Insert_Toggle()
endif
" ========== }}}

" ----------
" References
" ----------
" http://groups.google.com/group/vim_use/topics
" http://www.newsmth.net/bbsdoc.php?board=VIM
" http://maxiangjiang.googlepages.com/vimim.html
