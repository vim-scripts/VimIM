" =================================================
"             "VimIM —— Vim 中文输入法"
" -------------------------------------------------
" VimIM -- Input Method by Vim, of Vim, for Vimmers
" =================================================

" == "The VimIM Introduction" == {{{
" ==================================
"      File: vimim.vim
"    Author: Sean Ma <vimim@googlegroups.com>
"   License: GNU Lesser General Public License
"    Latest: 20090401T211354
"       URL: http://vim.sourceforge.net/scripts/script.php?script_id=2506
" -----------------------------------------------------------
"    Readme: The VimIM is a Vim plugin designed as an independent
"            IM (Input Method) to support the input of any language.
"            It can be used as yet another way to input non-ascii
"            using CTRL-^ in addition to builtin CTRL-V and CTRL-K.
"            The VimIM aims to complete the Vim as an editor.
" -----------------------------------------------------------
"  Features: # "Plug & Play"
"            # CJK can be input as long as it can be read using Vim.
"            # It is independent of Operating System.
"            # It is independent of Vim mbyte-XIM/mbyte-IME API.
"            # The Input Methods can be freely defined without limit.
"            # The "VimIM One Key" speeds up ad hoc Chinese input.
"            # The "VimIM Chinese Input Mode" makes CJK input pleasure.
"            # "Dynamically adjust menu order" on past usage frequency.
"            # Support "all input methods": PinYin, Wubi, Cangjie, etc
"            # Support all-power "fuzzy search" and "wildcards search"
"            # Support "Direct Unicode Input" using number or hex
"            # Support "pinyin fuzzy phonetic" with a demo rule
"            # Support intuitive and effective "Quick English Input"
"            # Support input of traditional Chinese (Big5 or GBK set)
"            # Intelligent error correction for commonly misspelled words
"            # The format of datafile is open, simple and flexible.
" -----------------------------------------------------------
" EasterEgg: (1) (Neither data file nor configuration needed)
"            (2) (in Vim Command-line Mode, type:)  :source %<CR>
"            (3) (in Vim Insert Mode, type 4 char)  vim<C-^>
" -----------------------------------------------------------
"   Install: (1) download any data file you like from the link below
"            (2) drop this file and the datafile to the plugin directory
" -----------------------------------------------------------
" Usage (1): [in Insert Mode] "to insert Chinese ad hoc":
"            # type key code and hit <CTRL-^> to insert Chinese
" -----------------------------------------------------------
" Usage (2): [in Insert Mode] "to input Chinese continuously":
"            # hit <CTRL-\> to toggle the VimIM Chinese Input Mode
"            (2.1) [static mode]  <Space> => Chinese  <Tab> => English
"            (2.2) [dynamic mode] any valid key code => Chinese
" -----------------------------------------------------------
" The VimIM Sample Data File downloading:
" (1) goto http://groups.google.com/group/vimim/files
" (2) right-click on the title of the desired file
" (3) select *save link as* (in Firefox)
"       or *save target as* (in Internet Explorer)
" ---------------------------  "phonetic-code" oriented
" vimim.pinyin.txt         =>  input method for Pinyin
" vimim.double_pinyin.txt  =>  input method for Double Pinyin
" vimim.phonetic.txt       =>  input method for Phonetic
" vimim.english.txt        =>  input method for English
" ---------------------------  "shape-code" oriented
" vimim.wubi.txt           =>  input method for Wu Bi
" vimim.cangjie.txt        =>  input method for Cang Jie
" vimim.quick.txt          =>  input method for Quick
" vimim.array30.txt        =>  input method for Array 30
" vimim.4corner.txt        =>  input method for Four Corner
" ----------------------------- }}}

" == "The VimIM Instruction" == {{{
" =================================

" -----------------------
" "The VimIM Design Goal"
" -----------------------
" # Chinese can be input using Vim regardless of encoding
" # Without negative impact to Vim if VimIM is not used
" # No compromise for high speed and low memory usage
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

"   "The VimIM OneKey Input"
"   - use OneKey to insert default candidates
"   - use OneKey again to perform cycle navigation
"   - use OneKey to directly insert unicode, integer or hex
"   - use OneKey in Visual Mode to translate English to Chinese
"   The default key is <CTRL-^> (Vim Insert Mode & Visual Mode)
" # To disable :let g:vimim_disable_one_key=1

"   "The VimIM Chinese Input Mode"
"   - [static mode] <Space> => Chinese  <Tab> => English
"   - [dynamic mode] show dynamic menu as you type
"   - trigger the popup menu using Smart <Space>
"   - toggle English and Chinese punctuation using <CTRL-A>
"   - <Esc> key is in consistent with Vim
"   The default key is <CTRL-\> (Vim Insert Mode)
" # To disable :let g:vimim_disable_chinese_input_mode=1

" # To enable VimIM "Default Off" Options
"   -------------------------------------
"   let g:vimim_enable_label_navigation=1
"   let g:vimim_enable_...

" # To disable VimIM "Default On" Options
"   -------------------------------------
"   let g:vimim_menu_order_update_frequency=999
"   let g:vimim_disable_fuzzy_search=1
"   let g:vimim_disable_wildcard_search=1
"   let g:vimim_disable_...

" # XingMa input methods are automatically configured
"   -------------------------------------------------

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
" ============================= }}}

" == "The VimIM Core Engine" == {{{
" =================================

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
    if char_before !~ s:char_valid
        return
    endif

    " note: use =~# for case sensitive match
    " --------------------------------------
    while start_column > 0 && current_line[start_column-1] =~ s:char_valid
        let start_column -= 1
    endwhile

    " get user's previous selection
    " -----------------------------
    if s:vimim_menu_order_update_frequency < 999
        if start_row >= s:start_row_before && s:usage_update > 0
            let row = start_row
            let col = start_column
            let row2 = s:start_row_before
            let col2 = s:start_column_before
            let chinese = s:VimIM_usage(row,col,row2,col2,s:keyboard_key)
            if len(chinese)>0 && chinese !~ '\w'
                let s:keyboard_chinese = chinese
                let s:keyboard_counts += 1
            endif
        endif
        let s:start_row_before = start_row
        let s:start_column_before = start_column
    endif

    if s:vimim_disable_no_space_english_input < 1
    \&& s:vimim_enable_dynamic_menu < 1
        if current_line[start_column-1] == " "
        \&& current_line[start_column-2] =~ '\a'
            let s:vimim_disable_no_space_english_input=-1
            let start_column -= 1
        endif
    endif

    return start_column

else

    let keyboard = a:keyboard

    if s:vimim_disable_no_space_english_input < 0
        let s:vimim_disable_no_space_english_input=0
        if strpart(keyboard,0,1) == " "
            let keyboard = strpart(keyboard,1)
        endif
    endif
 
    " support direct Unicode input:
    " (1) 5 whole digits: eg 39340 as &#39340; in HTML
    " (2) 4 hex   digits: eg 99ac  as &#x99ac; in HTML
    " -----------------------------------------------------------------
    if s:vimim_disable_direct_unicode_input < 1 && &encoding == "utf-8"
        let unicode = []
        if keyboard =~ '\d\{5}'
            let unicode = s:VimIM_unicode(keyboard, 10)
        elseif keyboard =~ '\x\{4}'
            let unicode = s:VimIM_unicode(keyboard, 16)
        endif
        if len(unicode) > 0
            return unicode
        endif
    endif

    " do quick english input and hunt for easter eggs
    " -----------------------------------------------
    sil!let english = s:VimIM_quick_English_input(keyboard)
    if len(english) > 0
        return english
    endif

    " Now, build again valid keyboard characters
    " ------------------------------------------
    if strlen(keyboard) < 1
    \||  keyboard !~ s:char_valid
    \||  keyboard =~ '\'
    \|| (keyboard =~ '[' && keyboard =~ ']')
    \||  keyboard =~ '^[*?]\+'
    \|| (keyboard !~# "vim" && s:vimim_easter_eggs>0)
        return
    endif

    " hunt real VimIM easter eggs ... vim<C-^>
    " ----------------------------------------
    if keyboard =~# "vim"
        return VimIM_popupmenu_list(s:easter_eggs, 3)
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
    let lines = s:datafile_lines

    " initialize and re-order the data file
    " -------------------------------------
    " modify the datafile in memory based on past usage
    if s:vimim_menu_order_update_frequency < 999
        let chinese = s:keyboard_chinese
        let lines_new = s:VimIM_order_new(s:keyboard_key, chinese, lines)
        if len(lines_new) > 0
            let lines = lines_new
            let frequency = s:vimim_menu_order_update_frequency
            let frequency = (frequency < 1) ? 24 : frequency
            if s:keyboard_counts%frequency==0
                sil!call s:VimIM_save_datafile(lines)
            endif
        endif
    endif

    " add boundary to datafile search by one letter only
    " --------------------------------------------------
    let ranges = s:VimIM_search_boundary(keyboard, lines)
    if len(ranges) < 1
        return
    elseif ranges[0] > ranges[1]
        let lines = sort(lines)
        sil!call s:VimIM_save_datafile(lines)
        let ranges = s:VimIM_search_boundary(keyboard, lines)
    endif

    " now only play with portion of datafile of interest
    " --------------------------------------------------
    let lines = lines[ranges[0] : ranges[1]]

    " -------------------------------------------
    " do wildcard search: explicitly fuzzy search
    " -------------------------------------------
    if s:vimim_disable_wildcard_search < 1
        let wildcard_pattern = '[.*]'
        if s:current_datafile_has_dot_key > 0
            let wildcard_pattern = '[?*]'
        endif
        let wildcard = match(keyboard, wildcard_pattern)
        if wildcard > 0
            let s:usage_update = -1
            let fuzzies = substitute(keyboard,'[*]','.*','g')
            if s:current_datafile_has_dot_key > 0
                let fuzzies = substitute(keyboard,'?','.','g')
            endif
            let fuzzy = '^' .  fuzzies . '\>'
            call filter(lines, 'v:val =~ fuzzy')
            return VimIM_popupmenu_list(lines, localization)
        endif
    endif

    " For '4corner', replace the first 0 with o for simplicity
    " For 'Array/Phonetic Input Method', escape literal dot
    " ------------------------------------------------------
    if s:current_datafile_has_dot_key > 0
        let keyboard = substitute(keyboard,'\.','\\.','g')
    endif
    let match_start = -1
    let match_start = match(lines, '^'.keyboard)
    " ------------------------------------------
    " to guess user's intention using auto_spell
    " ------------------------------------------
    if s:vimim_enable_auto_spell > 0
    \ && match_start < 0
        let key = s:VimIM_auto_spell(keyboard)
        let match_start = match(lines, '^'.key)
    endif

    " --------------------------------------------
    " to guess user's intention using fuzzy_pinyin
    " --------------------------------------------
    if s:vimim_enable_fuzzy_pinyin > 0
    \ && match_start < 0
        let key = s:VimIM_fuzzy_pinyin(keyboard)
        let match_start = match(lines, '^'.key)
    endif

    " ----------------------------------------
    " do exact match search on sorted datafile
    " ----------------------------------------
    if match_start > -1
        let s:usage_update = 0
        let s:keyboard_key = keyboard
        let match_end = VimIM_exact_match(match_start, keyboard, lines)
        let matched_list = lines[match_start : match_end]
        return VimIM_popupmenu_list(matched_list, localization)
    endif

    " -------------------------------------------
    " do fuzzy search: implicitly wildcard search
    " -------------------------------------------
    if s:vimim_disable_fuzzy_search < 1
    \ && match_start < 0
    \ && strlen(keyboard) > 2
        let s:usage_update = -1
        let fuzzies = join(split(keyboard,'\ze'),'.*')
        let fuzzy = '^' .  fuzzies . '.*'
        let lines = filter(lines, 'v:val =~ fuzzy')
        return VimIM_popupmenu_list(lines, localization)
    endif

endif
endfunction

" --------------------------------------------------------
function! VimIM_popupmenu_list(matched_list, localization)
" --------------------------------------------------------
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
        let pairs = split(words)
        let word = get(pairs, 1)
        let complete_items = {}
        if len(word) > 1
            let complete_items["word"] = word
        endif
        if s:vimim_disable_popup_label < 1
            let abbr = printf('%2s',label) . "\t" . word
            let complete_items["abbr"] = abbr
        endif
        if s:vimim_disable_popup_extra_text < 1
            let menu = get(pairs, 0)
            let complete_items["menu"] = menu
        endif
        let complete_items["dup"] = 1
        let label = label + 1
        call add(popupmenu_list, complete_items)
    endfor
    if len(popupmenu_list) < 2
        let s:usage_update = -1
        let s:keyboard_key = ''
    elseif popupmenu_list[0].menu == menu
        let s:usage_update = 1
        let s:keyboard_key = menu
    endif
    return popupmenu_list
endfunction

" --------------------------------------------
function! VimIM_exact_match(start, key, lines)
" --------------------------------------------
    let match_start = a:start
    let keyboard = a:key
    let lines = a:lines
    let patterns = '^\(' . keyboard . '\)\@!'
    let result = match(lines, patterns, match_start)-1
    if result - match_start < 1
        return match_start
    endif
    if s:vimim_disable_quick_key < 1
        if result > match_start
            let results = []
            for line in lines[match_start : result]
                call extend(results, split(line))
            endfor
            let total_chinese = len(results)-(result-match_start)-1
            if total_chinese > 88 || strlen(keyboard) < 2
                let patterns = '^\(' . keyboard . '\>\)\@!'
                let result = match(lines, patterns, match_start)-1
            endif
        endif
    endif
    let match_end = match_start
    if result > 0 && result > match_start
        let match_end = result
    endif
    return match_end
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
    """ step 4/4: insert the new order list into the datafile
    if len(one_line_chinese_list) > 0
        let new_item = keyboard .' '. join(one_line_chinese_list)
        call insert(lines, new_item, insert_index)
    endif
    return lines
endfunction

" ------------------------------------------------------
function! s:VimIM_usage(row, column, row2, column2, key)
" ------------------------------------------------------
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
    "  zhengguoren  => zhongguoren
    "  chengfengqia => chongfengqia
    " ----------------------------------
    let rules = {}
    let rules['eng'] = 'ong'
    let rules['ian'] = 'iang'
    let rules['uan'] = 'uang'
    let rules['an']  = 'ang'
    let rules['in']  = 'ing'
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
            elseif keyboard =~ '*\{2}sign' && len(s:vimim_signature) > 1
                let sign = s:vimim_signature
                let result = sign
            elseif keyboard =~ '*\{2}\d\+'
                let number = join(split(strpart(keyboard,2),'\ze'),' ')
                let number = chinese.translate(number)
                let number = join(split(number),'')
                let result = number
            elseif keyboard =~ '*\{2}credits'
                let a='VimIM would never have become what it is now,'
                let a.=' without the help of these people!'
                let a.=' (1) Yue Wu on newsmth.net for all smart_space'
                let a.=' (2) Tony Mechelynck on vim_use for char_class'
                let a.=' (3) freeai.blogspot.com for shuang_pin'
                let a.=' (4) many people on vim_use for inspiration'
                let a.=' (5) many people on newsmth.net for discussion'
                let a.=' (6) many users for feedback and encouragement'
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
    if !filereadable(datafile)
        let files = ["vimim.pinyin"]
        call add(files, "vimim.wubi")
        call add(files, "vimim.cangjie")
        call add(files, "vimim.quick")
        call add(files, "vimim.4corner")
        call add(files, "vimim.array30")
        call add(files, "vimim.phonetic")
        call add(files, "vimim.key31")
        call add(files, "vimim.double_pinyin")
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
    if !filereadable(datafile)
        let s:vimim_easter_eggs = 1
        let datafile = ''
    endif
    return datafile
endfunction
" =============================== }}}

" == "The VimIM Core FrontEnd" == {{{
" ===================================
" ----------------------------
function! s:VimIM_initialize()
" ----------------------------
    let G = []
    call add(G, "g:vimim_datafile")
    call add(G, "g:vimim_signature")
    call add(G, "g:vimim_menu_order_update_frequency")
    call add(G, "g:vimim_disable_quick_key")
    " ------------------------------------------------
    call add(G, "g:vimim_disable_direct_unicode_input")
    call add(G, "g:vimim_disable_wildcard_search")
    call add(G, "g:vimim_disable_fuzzy_search")
    call add(G, "g:vimim_disable_one_key")
    call add(G, "g:vimim_disable_chinese_input_mode")
    call add(G, "g:vimim_disable_smart_space_autocmd")
    call add(G, "g:vimim_disable_chinese_punctuation")
    call add(G, "g:vimim_disable_popup_extra_text")
    call add(G, "g:vimim_disable_popup_label")
    call add(G, "g:vimim_disable_english_input_by_enter_key")
    " ------------------------------------------------
    call add(G, "g:vimim_disable_no_space_english_input")
    call add(G, "g:vimim_enable_dynamic_menu")
    call add(G, "g:vimim_enable_xingma_preference")
    call add(G, "g:vimim_enable_label_navigation")
    call add(G, "g:vimim_enable_auto_spell")
    call add(G, "g:vimim_enable_fuzzy_pinyin")
    call add(G, "g:vimim_enable_zero_based_label")
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
    " ------------------------------------------------
    let s:vimim_easter_eggs = 0
    let s:current_datafile_has_dot_key = 0
    let datafile = s:VimIM_get_datafile_name()
    let s:current_datafile = datafile
    if s:current_datafile =~ 'array'
       \|| s:current_datafile =~ 'phonetic'
       \|| s:current_datafile =~ 'key31'
        let s:current_datafile_has_dot_key = 1
    endif
    if len(datafile) > 0
        if s:vimim_enable_xingma_preference > 0
        \|| s:current_datafile_has_dot_key > 0
        \|| datafile =~? 'wubi'
        \|| datafile =~? 'cangjie'
        \|| datafile =~? 'quick'
        \|| datafile =~? 'corner'
            let s:vimim_disable_fuzzy_search = 1
            let s:vimim_disable_quick_key = 1
            let s:vimim_menu_order_update_frequency = 999
        endif
    endif
    " ------------------------------------------
    " define valid characters for input key code
    if s:vimim_disable_wildcard_search < 1
        let s:char_valid = "[.*0-9A-Za-z]"
        if s:current_datafile =~ 'double_pinyin'
            let s:char_valid = "[.*a-z;]"
        elseif s:current_datafile =~ 'array'
            let s:char_valid = "[?*a-z.,;/]"
        elseif s:current_datafile =~ 'phonetic'
            let s:char_valid = "[?*0-9a-z.,;/\-]"
        elseif s:current_datafile =~ 'key31'
            let s:char_valid = "[?*a-z.,';/]"
        endif
    else
        let s:char_valid = "[0-9A-Za-z]"
        if s:current_datafile =~ 'double_pinyin'
            let s:char_valid = "[a-z;]"
        elseif s:current_datafile =~ 'array'
            let s:char_valid = "[a-z.,;/]"
        elseif s:current_datafile =~ 'phonetic'
            let s:char_valid = "[0-9a-z.,;/\-]"
        elseif s:current_datafile =~ 'key31'
            let s:char_valid = "[a-z.,';/]"
        endif
    endif
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
    " ----------------------------------------------------
    let key = s:VimIM_expand_character_class(s:char_valid)
    let keys = split(key, '\zs')
    let keys_ext = ["<BS>", "<C-H>"]
    let s:vimim_keys = extend(keys, keys_ext)
    " ------------------------------------------------
    let s:datafile_lines = []
    let s:vimim_insert = 0
    let s:vimim_labels_on_loaded = 0
    let s:vimim_seed_data_loaded = 0
    let s:vimim_datafile_loaded = 0
    let s:vimim_punctuation = 0
    let s:punctuations = {}
    " ------------------------------------------------
    let s:start_row_before = 0
    let s:start_column_before = 0
    let s:keyboard_key = ''
    let s:keyboard_chinese = ''
    let s:keyboard_counts = 0
    let s:usage_update = -1
    " ------------------------------------------------
    let s:vimim_dummy_dictionary_loaded = 0
    let s:current_dictionary=''
    let dictionary = s:path . "vimim.english.txt"
    if filereadable(dictionary)
        let s:current_dictionary = dictionary
    endif
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
    let punctuations = {}
    let punctuations["#"]="＃"
    let punctuations["%"]="％"
    let punctuations["$"]="￥"
    let punctuations["&"]="※"
    let punctuations["{"]="『"
    let punctuations["}"]="』"
    let punctuations["["]="【"
    let punctuations["]"]="】"
    let punctuations["<"]="《"
    let punctuations[">"]="》"
    let punctuations["'"]="“"
    let punctuations['"']="”"
    let punctuations["!"]="！"
    let punctuations["@"]="・"
    let punctuations["~"]="～"
    let punctuations["("]="（"
    let punctuations[")"]="）"
    let punctuations["\\"]="。"
    let punctuations["^"]="……"
    let punctuations["_"]="——"
    let punctuations["+"]="＋"
    if s:current_datafile_has_dot_key < 1
        let punctuations[","]="，"
        let punctuations["-"]="－"
        let punctuations["?"]="？"
        if s:current_datafile !~ 'double_pinyin'
            let punctuations[";"]="；"
        endif
    endif
    if s:current_datafile_has_dot_key < 1
    \&& s:vimim_disable_wildcard_search > 0
        let punctuations["."]="。"
        let punctuations["*"]="﹡"
    endif
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

" --------------------------------
function! s:VimIM_labels_on(label)
" --------------------------------
    for n in range(a:label,9)
        sil!exe 'inoremap <silent> <expr> '.n.' VimIM_label('.n.')'
    endfor
    " ----------------------
    function! VimIM_label(n)
    " ----------------------
        if pumvisible()
            let label = 1 - s:vimim_enable_zero_based_label
            let counts = repeat("\<C-N>",a:n-label)
            let end = ''
            if s:vimim_enable_label_navigation<1 || &l:iminsert==1
                let end = '\<C-Y>'
                if s:usage_update == 0
                    let s:usage_update = 1
                endif
            endif
            sil!exe 'return "' . counts . end . '"'
        else
            return a:n
        endif
    endfunction
endfunction

" ----------------------------
function! s:VimIM_labels_off()
" ----------------------------
    let s:vimim_labels_on_loaded = 0
    for n in range(1,9)
        exe 'sil! iunmap '.n
    endfor
endfunction

" ----------------------------
function! s:VimIM_setting_on()
" ----------------------------
    let s:saved_completeopt=&completeopt
    let s:saved_lazyredraw=&lazyredraw
    let s:saved_iminsert=&l:iminsert
    let s:saved_cpo=&cpo
    set cpo&vim
    set completeopt=menuone
    set nolazyredraw
    let &l:iminsert=1
    highlight lCursor guifg=bg guibg=green
endfunction

" -----------------------------
function! s:VimIM_setting_off()
" -----------------------------
    let &cpo=s:saved_cpo
    let &completeopt=s:saved_completeopt
    let &lazyredraw=s:saved_lazyredraw
    let &l:iminsert=s:saved_iminsert
    highlight ICursor guifg=bg guibg=fg
endfunction

" ---------------------------
function! s:VimIM_insert_on()
" ---------------------------
    let s:vimim_insert = 1
    sil!call s:VimIM_setting_on()
    " ==== static menu ====
    if s:vimim_enable_dynamic_menu < 1
        if s:vimim_disable_english_input_by_enter_key < 1
            inoremap <silent><Tab> <Esc>a<Space>
        endif
        inoremap <silent><Space> <C-X><C-U><C-R>=VimIM_SpaceKey()<CR>
        " ------------------------
        function! VimIM_SpaceKey()
        " ------------------------
            if pumvisible()
                if s:usage_update == 0
                    let s:usage_update = 1
                endif
                return "\<C-N>\<C-P>"
            else
                return " "
            endif
        endfunction
    endif
    " ==== dynamic menu ====
    if s:vimim_enable_dynamic_menu > 0
        " -----------------------------
        function! <SID>VimIM_check(map)
        " -----------------------------
            if getline(".")[col(".")-2] !~# s:char_valid
                sil! return ""
            else
                sil! return a:map
            endif
        endfunction
        " -------------------------
        function! <SID>VimIMSpace()
        " -------------------------
            if pumvisible()
                if s:usage_update == 0
                    let s:usage_update = 1
                endif
                sil! return "\<C-Y>"
            else
                sil! return " "
            endif
        endfunction
        " -----------------------------------------
        for char in s:vimim_keys
            sil!exe 'inoremap <silent> ' . char . '
            \  <C-R>=pumvisible()?"\<lt>C-E>":""<CR>'. char .
            \ '<C-R>=<SID>VimIM_check("\<lt>C-X>\<lt>C-U>")<CR>'
        endfor
        inoremap <silent> <Space> <C-R>=<SID>VimIM_check
        \("\<lt>C-X>\<lt>C-U>")<CR><C-R>=<SID>VimIMSpace()<CR>
    endif
    if s:vimim_disable_popup_label < 1
        sil!call s:VimIM_labels_on(1)
    endif
    if s:vimim_disable_chinese_punctuation < 1
        sil!call s:VimIM_punctuation_on()
        inoremap <silent><C-A>
        \ <C-O>:sil!call <SID>VimIM_punctuation_toggle()<CR>
    endif
endfunction

" ----------------------------
function! s:VimIM_insert_off()
" ----------------------------
    let s:vimim_insert = 0
    sil!call s:VimIM_setting_off()
    sil!call s:VimIM_labels_off()
    sil!call s:VimIM_punctuation_off()
    sil!iunmap <C-A>
    sil!iunmap <Space>
    sil!iunmap <Tab>
    if s:vimim_enable_dynamic_menu > 0
        for char in s:vimim_keys
            exe 'sil!iunmap ' . char
        endfor
    endif
endfunction

" --------------------------------
function! s:VimIM_punctuation_on()
" --------------------------------
    let s:vimim_punctuation = 1
    for key in keys(s:punctuations)
        let value = s:punctuations[key]
        sil!exe 'inoremap <silent> '. key .' '. value
    endfor
endfunction

" ---------------------------------
function! s:VimIM_punctuation_off()
" ---------------------------------
    let s:vimim_punctuation = 0
    for key in keys(s:punctuations)
        sil!exe 'silent! iunmap <silent> '. key
    endfor
endfunction

" ---------------------------------------
function! <SID>VimIM_punctuation_toggle()
" ---------------------------------------
    if s:vimim_punctuation < 1
        sil!call s:VimIM_punctuation_on()
    else
        sil!call s:VimIM_punctuation_off()
    endif
endfunction

" ----------------------------------
function! <SID>VimIM_insert_toggle()
" ----------------------------------
    if s:vimim_disable_smart_space_autocmd < 1 && has("autocmd")
        sil!au InsertEnter sil!call s:vimim_insert_on()
        sil!au InsertLeave sil!call s:VimIM_insert_off()
        sil!au BufUnload   autocmd! InsertEnter,InsertLeave
    endif
    if s:vimim_insert < 1
        sil!call s:VimIM_insert_on()
    else
        sil!call s:VimIM_insert_off()
    endif
    return "\<C-\>\<C-O>:redraw\<CR>"
endfunction

" ---------------------------
function! <SID>VimIM_OneKey()
" ---------------------------
    if s:vimim_labels_on_loaded < 1
        sil!call s:VimIM_labels_on(1)
        let s:vimim_labels_on_loaded = 1
    endif
    if pumvisible()
        if s:vimim_enable_label_navigation<1 || &l:iminsert==1
            if s:usage_update == 0
                let s:usage_update = 1
            endif
            sil!return "\<C-Y>"
        else
            sil!return "\<C-N>"
        endif
    else
        set completeopt=menu
        sil!return "\<C-X>\<C-U>\<C-U>\<C-P>"
    endif
endfunction

" --------------------------------------------
function! <SID>VimIM_dummy_translator(english)
" --------------------------------------------
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
" ============================== }}}

" == "The VimIM Core Mapping" == {{{
" ==================================
" profile start /tmp/vimim.profile
scriptencoding utf-8
let s:path=expand("<sfile>:p:h")."/"
sil!call s:VimIM_initialize()
sil!call s:VimIM_seed_data()

if s:vimim_disable_one_key < 1
    if len(s:current_dictionary) > 0
        xnoremap<silent><C-^> y:put!=<SID>VimIM_dummy_translator(@0)<CR>
    endif
    inoremap <silent> <expr> <C-^> <SID>VimIM_OneKey()
endif

if s:vimim_disable_chinese_input_mode < 1
    inoremap <silent> <expr> <C-\> <SID>VimIM_insert_toggle()
endif
" ========== }}}

" ----------
" References
" ----------
" http://vim.sourceforge.net/scripts/script.php?script_id=2506
" http://groups.google.com/group/vimim
" http://vimim.googlegroups.com/web/vimim.html
