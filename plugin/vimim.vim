" =================================================
"              VimIM —— Vim 中文输入法
" -------------------------------------------------
" VimIM -- Input Method by Vim, of Vim, for Vimmers
" =================================================

" == The VimIM Introduction == {{{
" ================================
"        File: vimim.vim
"      Author: Sean Ma <maxiangjiang_at_cornell_dot_edu>
" Last Change: 20090211T194617
"         URL: http://vim.sourceforge.net/scripts/script.php?script_id=2506
" -----------------------------------------------------------
" Description: The VimIM is a Vim plugin designed as an independent
"              IM (Input Method) to support the input of any language.
"              It can be used as yet another way to input non-ascii
"              using CTRL-^ in addition to builtin CTRL-V and CTRL-K.
" -----------------------------------------------------------
"    Features: * CJK can be input if it can be read within vim.
"              * It is independent of the Operating System.
"              * It is independent of Vim 'mbyte-XIM/mbyte-IME' API.
"              * The input methods can be freely defined.
"              * The datafile format is open, simple and flexible.
"              * The One Key speeds up ad hoc Chinese input.
"              * The Smart CJK Input Mode makes CJK input comfortable
"              * Support 'fuzzy search' and 'wildcards search'
"              * Support 'auto spell' and 'fuzzy pinyin'
" -----------------------------------------------------------
" Easter Eggs: (0) (no datafile; no configuration)
"              (1) (source this script:)    :so%<CR>
"              (2) (in Insert mode, type:)  vim<C-X><C-U>
" -----------------------------------------------------------
" Installation (1) download any data file you like from the link below
"              (2) drop this file and the datafile to the plugin directory
" -----------------------------------------------------------
"   Data File: http://maxiangjiang.googlepages.com/vimim.pinyin
"              http://maxiangjiang.googlepages.com/vimim.wubi
"              http://maxiangjiang.googlepages.com/vimim.cangjie
"              http://maxiangjiang.googlepages.com/vimim.english
"              http://maxiangjiang.googlepages.com/vimim.quick
"              http://maxiangjiang.googlepages.com/vimim.4corner
" -----------------------------------------------------------
"    Usage(1): In Insert Mode, in normal English environement:
"              # type <C-^> to input Chinese, using VimIM One Key
"    Usage(2): In Insert Mode, to input Chinese continously
"              # type <C-\> to toggle to VimIM Chinese Input Mode
"              # Chinese will be shown as long as you type
" -----------------------------------------------------------
" Screen Shot: http://maxiangjiang.googlepages.com/vimim.gif
" Latest Code: http://maxiangjiang.googlepages.com/vimim.vim
"   HTML Code: http://maxiangjiang.googlepages.com/vimim.vim.html
" Chinese URL: http://maxiangjiang.googlepages.com/vimim.html
"  News Group: http://groups.google.com/group/vimim
" ----------------------------------------------------------- }}}

" == The VimIM Instruction == {{{
" ===============================

" The VimIM Design Goals:
" -----------------------
" + Chinese can be input using Vim regardless of encoding
" + Without negative impact to Vim if VimIM is not used
" + No comprise for high speed and low memory usage
" + Most VimIM options are enabled by default
" + All VimIM options can be explicitly disabled at will

" To get started: sample .vimrc for displaying Chinese:
" -----------------------------------------------------
" set gfn=Courier_New:h12:w7,Arial_Unicode_MS
" set gfw=NSimSun-18030,NSimSun ambiwidth=double
" set enc=utf8 fencs=ucs-bom,utf8,chinese,taiwan,ansi

" The available VimIM Options:
" ----------------------------
" The VimIM OneKey Input
"   - use OneKey to pick up the default
"   - use OneKey again to perform cycle navigation
"   - use OneKey again to search Vim Dictionary
"   - The default key is i_<C-^>
" # :let g:vimim_disable_one_key=1 to disable
"
" The VimIM Smart Chinese Input Mode
"   - show dynamic menu as you type
"   - trigger the popup menu using Smart <Space>
"   - toggle VimIM Insert Mode automatically
"   - toggle English and Chinese punctuation
"   The default key is i_<C-\>
" # :let g:vimim_disable_smart_space=1 to disable.
"
" The VimIM Quick English Input
"   - quick English input within Chinese input mode
"     (1) EGNLISH  ==> ENGLISH
"     (2) Vitamin  ==> vitamin
"     (3) JJanuary ==> January
" # :let g:vimim_disable_quick_english_input=1 to disable.
"
" To disable VimIM "Default On" Options:
" # let g:vimim_disable_auto_spell=1
" # let g:vimim_disable_fuzzy_search=1
" # let g:vimim_disable_fuzzy_pinyin=1
" # let g:vimim_disable_wildcard_search=1
" # let g:vimim_disable_punctuation_toggle=1
" # let g:vimim_disable_popup_label=1
" # let g:vimim_disable_popup_extra_text=1
" # let g:vimim_disable_number_in_key=1
" # let g:vimim_disable_chinese_punctuation=1
" # let g:vimim_disable_direct_unicode_input=1
"
" To enable VimIM "Default Off" Options:
" # let g:vimim_enable_pinyin_tone_input=1
" # let g:vimim_enable_label_navigation=1
" # let g:vimim_datafile2="filename"
" # let g:vimim_enable_signature="signature"

" The VimIM Data File:
" --------------------
" The data file has to be sorted (:sort) before it can be used.
" The basic format of the data file is simple and flexible:
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
"
" Following sample data files are provided:
" -------------- -------------------------
"   vimim.vim         VimIM data file
" -------------- -------------------------
"  vimim.pinyin   input method for PinYin
"  vimim.wubi     input method for WuBi
"  vimim.cangjie  input method for CangJie
"  vimim.english  input method for English
"  vimim.quick    input method for Quick
"  vimim.4corner  input method for 4Corner
" -------------- -------------------------
"
" Non UTF-8 datafile is also supported: when the datafile filename
" includes 'chinese', it is assumed to be encoded in 'chinese'.
" ============================================================= }}}

" == The VimIM Core Engine == {{{
" ===============================

if exists("b:loaded_vimim")||&cp||v:version<701
    finish
endif
let b:loaded_vimim=1

scriptencoding utf-8
set completefunc=b:VimIM
" --------------------------------
function! b:VimIM(start, keyboard)
" --------------------------------
sil!call s:VimIM_Load_Datafile()

if a:start

    let current_line = getline('.')
    let start_col = col('.')-1
    let char_before = current_line[start_col-1]

    " define valid characters for <key> in datafile
    " ---------------------------------------------
    let char_valid = "[*.0-9A-Za-z]"
    if g:vimim_disable_number_in_key
        let char_valid = "[A-Za-z]"
    endif

    " avoid hanging on triggering nothing
    " -----------------------------------
    if start_col < 1
        return
    endif

    " avoid hanging on triggering non-word char
    " -----------------------------------------
    if char_before !~ char_valid
        return
    endif

    " can use =~# for case sensitive match
    " ------------------------------------
    while start_col > 0 && current_line[start_col-1] =~ char_valid
        let start_col -= 1
    endwhile
    return start_col

else

    let keyboard = a:keyboard

    " more easter eggs
    " -----------------------------------------------
    " *today  -> 2009 year February 22 day Wednesday
    " *now    -> Sunday AM 8 hour 8 minute 8 second
    " *casino -> congratulations! US$88000
    " -----------------------------------------------
    if keyboard =~ '^*' && keyboard !~ '^\d\+\s\+'
        let chinese=copy(s:translators)
        let chinese.dict=s:ecdict
        if keyboard ==# '*casino'
            let casino = matchstr(localtime(),'..$')*1000
            let casino = 'casino US$'.casino
            let casino = chinese.translate(casino)
            return [casino]
        elseif keyboard ==# '*girls'
            return [chinese.translate('grass')]
        elseif keyboard ==# '*today' || keyboard ==# '*now'
            if keyboard ==# '*today'
                let today = strftime("%Y year %B %d day %A")
                let today = chinese.translate(today)
                return [today]
            elseif keyboard ==# '*now'
                let now = strftime("%A %p %I hour %M minute %S second")
                let now = chinese.translate(now)
                return [now]
            endif
        elseif keyboard ==# '*author' && &encoding == "utf-8"
            let mxj = nr2char(39340).nr2char(28248).nr2char(27743)
            let mxj = chinese.translate(mxj)
            let url = "http://maxiangjiang.googlepages.com/index.html"
            let author = mxj . " " . url
            return [author]
        elseif keyboard =~ '*\d\+'
            let number = join(split(strpart(keyboard,1),'\ze'),' ')
            let number = chinese.translate(number)
            let number = join(split(number),'')
            return [number]
        elseif keyboard =~ '*help'
            let help = "http://maxiangjiang.googlepages.com/vimim.html"
            return [help]
        elseif keyboard =~ '*sign' && len(g:vimim_enable_signature)>1
            let sign = g:vimim_enable_signature
            return [sign]
        elseif keyboard =~ '*todo' && len(g:vimim_enable_todo_list)>1
            let todo = string(g:vimim_enable_todo_list)
            return [todo]
        else
            return
        endif
    endif

    " support direct unicode input: 39340  as in HTML &#39340;
    " --------------------------------------------------------
    if g:vimim_disable_direct_unicode_input==0
        if keyboard =~ '\d\d\d\d\d' && &encoding == "utf-8"
            if keyboard > 19968 && keyboard < 40870
                let unicode = nr2char(keyboard)
                return [unicode]
            endif
        endif
    endif

    " hunt VimIM easter eggs ... vim<C-^>
    " -----------------------------------
    if s:vimim_easter_eggs
        if keyboard !~# "vim"
            return
        endif
    endif

    " avoid error on empty datafile
    " -----------------------------------
    if len(b:lines) < 1
        return
    endif

    " avoid hanging on empty or non-word
    " ----------------------------------
    if strlen(keyboard) < 1
        return
    endif

    " avoid hanging on pattern with backslash
    " ---------------------------------------
    if keyboard =~ '\'
        return
    endif

    " avoid hanging on square bracket
    " -------------------------------
    if keyboard =~ '[' && keyboard =~ ']'
        return
    endif

    " avoid hanging on leading multiple wildcards
    " -------------------------------------------
    if keyboard =~ '^[.*]\+'
        return
    endif

    " inventive quick English input
    " ---------------------------------
    if g:vimim_disable_quick_english_input==0
        if keyboard =~ '^\D'
            if keyboard ==# toupper(keyboard)
                return
            endif
            if keyboard =~# '^\L'
                let english = tolower(keyboard)
                if strpart(keyboard,0,1) =~? strpart(keyboard,1,1)
                    let english  = strpart(keyboard,0,1)
                    let english .= tolower(strpart(keyboard,2))
                endif
                if s:enable_dynamic_menu
                    let english .= " "
                endif
                return [english]
            endif
        endif
    endif

    let wildcard = -1
    let do_wildcard_search = 0
    if g:vimim_disable_wildcard_search==0
        " wildcard search is explicit fuzzy search
        " ----------------------------------------
        let wildcard = match(keyboard, '[.*]')
        if wildcard > 0 && len(keyboard) > 2
            let do_wildcard_search = 1
            let keyboard_head = strpart(keyboard, 0, wildcard)
        endif
    endif

    " Note: limitation for 4 corner data file:
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
            let space_match = match(b:lines, pattern_word)
            if  space_match > 0
                let do_quick_key_search = 1
            else
                let do_fuzzy_search = 1
            endif
        else
            if strlen(a:keyboard) < s:fuzzy_search_key_length_max
            \ && g:vimim_disable_fuzzy_search==0
                let do_fuzzy_search = 1
            endif
            if g:vimim_disable_fuzzy_pinyin==0
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
        let match_start = match(b:lines, patterns)
    endif

    " ------------------------------------------
    " to guess user's intention using auto_spell
    " ------------------------------------------
    let auto_spell_success = 0
    if match_start < 0
    \ && wildcard < 0
    \ && g:vimim_disable_auto_spell==0
        " samples of auto spelling rule ...
        let rules = {}
        let rules['ign'] = 'ing'
        let rules['iou'] = 'iu'
        let rules['uei'] = 'ui'
        let rules['uen'] = 'un'
        let rules['mg']  = 'ng'
        let rules['ve']  = 'ue'
        for key in keys(rules)
            let new_key = rules[key]
            if patterns =~ key
                let patterns = substitute(patterns, key, new_key, '')
                break
            endif
        endfor
        " ----------------------------------------
        let match_start = match(b:lines, patterns)
        " ----------------------------------------
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

    " put a limit to the search
    " -----------------------------
    let match_max_end = match_start
    let match_first_char = strpart(keyboard,0,1)
    let match_next_char = nr2char(char2nr(match_first_char)+1)
    if match_first_char == '9'
        let match_next_char = 'a'
    endif
    let pattern_next = '^' . match_next_char
    let match_max_end = match(b:lines, pattern_next)
    if match_first_char == 'z' || s:vimim_easter_eggs
        let match_max_end = len(b:lines)-1
    endif
    if match_max_end < 0
        return
    endif

    " --------------------------------------------
    " to guess user's intention using fuzzy_pinyin
    " --------------------------------------------
    let fuzzy_pinyin_success = 0
    if g:vimim_disable_fuzzy_pinyin==0
    \ && do_fuzzy_pinyin > 0
    \ && match_start < 0
    \ && wildcard < 0
        " samples of fuzzy pinyin rule ...
        " .. zhengguoren  => zhongguoren
        " .. chengfengqia => chongfengqia
        let rules = {}
        let rules['eng'] = 'ong'
        let rules['ian'] = 'iang'
        let rules['uan'] = 'uang'
        let rules['an']  = 'ang'
        let rules['in']  = 'ing'
        for key in keys(rules)
            let new_key = rules[key]
            if keyboard =~ key
                let pattern = substitute(keyboard, key, new_key, '')
                break
            endif
        endfor
        let patterns = '^' . pattern
        " ----------------------------------------
        let match_start = match(b:lines, patterns)
        " ----------------------------------------
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
        let fuzzy_start = match(b:lines, fuzzy)
        " ----------------------------------------------
        if fuzzy_start < 0
            return
        endif
    endif

    let matched_list = []
    if fuzzy_start > 0
    " ------------------------------------------------ fuzzy_match
        let fuzzy_range = match_max_end - fuzzy_start
        if fuzzy_range < 1
            let fuzzy_range = 1
        elseif fuzzy_range > s:fuzzy_search_max
            let fuzzy_range = s:fuzzy_search_max
        endif
        for counts in range(1, fuzzy_range)
            let fuzzy_matched = match(b:lines, fuzzy, fuzzy_start, counts)
            if fuzzy_matched > 0
                sil!call add(matched_list, b:lines[fuzzy_matched])
            endif
        endfor
    " ------------------------------------------------ exact_match
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
            let next_matched = match(b:lines,patterns,match_start,counts)
        endwhile
        let match_end = match_start + counts - 2
        if match_end < match_start
            let match_end = match_start+1
        endif
        let matched_list = b:lines[match_start : match_end]
        if s:vimim_easter_eggs
            let matched_list = b:lines
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

    let label = s:menu_label_start_number
    let menu = keyboard
    let word = keyboard
    let popupmenu_list = []

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
            let complete_items = {}
            let complete_items["word"] = word
            if g:vimim_disable_popup_label==0
                if g:vimim_enable_pinyin_tone_input
                    if label < s:pinyin_tone+1
                        let label = "0" . label
                    endif
                endif
                let abbr = printf('%2s',label) . "\t" . word
                let complete_items["abbr"] = abbr
            endif
            if g:vimim_disable_popup_extra_text==0
                let complete_items["menu"] = menu
            endif
            let complete_items["dup"] = 1
            let label = label + 1
            sil!call add(popupmenu_list, complete_items)
        endfor

    endfor

    if len(g:keyboards) < 24
        let g:keyboards[menu] = word
    endif

    return popupmenu_list
endif
endfunction
" ====================== }}}

" == The VimIM Core FrontEnd == {{{
" =================================

" ----------------------------
function! s:VimIM_Initialize()
" ----------------------------
    let globals = []
    call add(globals, "g:vimim_datafile")
    call add(globals, "g:vimim_datafile2")
    " ------------------------------------------------------
    call add(globals, "g:vimim_enable_label_navigation")
    call add(globals, "g:vimim_enable_menu_order_by_usage")
    call add(globals, "g:vimim_enable_pumheight")
    call add(globals, "g:vimim_enable_pinyin_tone_input")
    call add(globals, "g:vimim_enable_signature")
    call add(globals, "g:vimim_enable_todo_list")
    " ------------------------------------------------------
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
    call add(globals, "g:vimim_disable_number_in_key")
    call add(globals, "g:vimim_disable_dynamic_menu")
    call add(globals, "g:vimim_disable_quick_english_input")
    call add(globals, "g:vimim_disable_quick_key")
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
    let s:vimim_keys=split(s:keys,'\zs')
    let s:vimim_extkeys=["<BS>","<C-H>"]
    let s:vimim="vimim vimim___input_method_by_vim_of_vim_for_vimmers"
    let s:exact_search_max=100
    let s:fuzzy_search_max=50
    let s:fuzzy_search_key_length_max=12
    let s:enable_dynamic_menu=0
    let s:menu_label_start_number=0
    let s:datafile_fenc_chinese=0
    let s:vimim_datafile_loaded=0
    let s:vimim_raw_data_loaded=0
    let s:vimim_easter_eggs=0
    let s:punctuation_key = []
    let s:punctuation_value = []
    let g:keyboards = {}
    let msg='User defined completion (^U^N^P) pattern not found'
    " ------------------------------------------------------
endfunction

" -------------------------------
function! s:VimIM_Load_Datafile()
" -------------------------------
    if s:vimim_datafile_loaded
        if !exists("b:DataFileToggle") || b:DataFileToggle==0
            let b:lines = s:lines
        else
            let b:lines = s:lines2
        endif
        return
    else
        let s:vimim_datafile_loaded=1
    endif
    " ------------------------------
    let s:lines  = []
    let s:lines2 = []
    let datafile = g:vimim_datafile
    " ------------------------------
    if filereadable(datafile)
        let s:lines = readfile(datafile)
    else
        let files =    ["vimim.txt"]
        call add(files, "vimim.pinyin")
        call add(files, "vimim.wubi")
        call add(files, "vimim.cangjie")
        call add(files, "vimim.english")
        call add(files, "vimim.quick")
        call add(files, "vimim.4corner")
            for file in files
                let datafile = s:path . file
                if filereadable(datafile)
                    let s:lines = readfile(datafile)
                    break
                else
                    continue
                endif
            endfor
        endif
    " --------------------------------------
    " support 2nd-datafile-switch on the fly
    " --------------------------------------
    let datafile2 = g:vimim_datafile2
    if len(datafile2)>1
        if filereadable(datafile2)
            let s:lines2 = readfile(datafile2)
        elseif filereadable(s:path.datafile2)
            let s:lines2 = readfile(s:path.datafile2)
        endif
    endif
    " -------------------------------
    " parse filename for fileencoding
    " -------------------------------
    if datafile =~? "chinese"
        let s:datafile_fenc_chinese=1
    endif
    if datafile =~? "utf"
        let s:datafile_fenc_chinese=0
    endif
    " --------------------------------
    " show 'easter egg' if no datafile
    " --------------------------------
    if len(s:lines) < 1
        let g:vimim_disable_quick_key=1
        let s:lines=s:easter_eggs
        let s:vimim_easter_eggs=1
    endif
endfunction

" --------------------------------
function! s:VimIM_Labels_On(start)
" --------------------------------
    if g:vimim_disable_popup_label==0 && g:vimim_disable_one_key
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
        let counts = repeat("\<C-N>",a:n-s:menu_label_start_number)
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
        let s:menu_label_start_number=0
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
    let s:menu_label_start_number=1
    if g:vimim_enable_pumheight==0
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
    let s:menu_label_start_number=0
    let &completeopt=b:saved_completeopt
    let &lazyredraw=b:saved_lazyredraw
    let &pumheight=b:saved_pumheight
    let &l:iminsert=b:saved_iminsert
    let &cpo = s:_cpo
endfunction

" ---------------------------------
function! b:VimIM_Datafile_Toggle()
" ---------------------------------
    if !exists("b:DataFileToggle") || b:DataFileToggle==0
        let b:DataFileToggle=1
        let b:lines = s:lines2
    else
        let b:DataFileToggle=0
        let b:lines = s:lines
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
    if g:vimim_disable_punctuation_toggle==0
        inoremap <silent> <buffer> <S-F11>
        \ <C-O>:sil!call b:VimIM_Punctuation_Toggle()<CR>
    endif
    if g:vimim_disable_chinese_punctuation==0
        sil!call s:VimIM_Punctuation_On()
    endif
    if g:vimim_disable_popup_label==0 && g:vimim_disable_one_key
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
    if g:vimim_disable_punctuation_toggle==0
        silent! iunmap <silent><buffer> <S-F11>
    endif
    if g:vimim_disable_chinese_punctuation==0
        sil!call s:VimIM_Punctuation_Off()
    endif
    if g:vimim_disable_popup_label==0 && g:vimim_disable_one_key
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
    if g:vimim_disable_smart_space_autocmd==0
    \ && !exists("b:smart_space_autocmd")
    \ && has("autocmd")
        let b:smart_space_autocmd = 1
        sil!au InsertEnter <buffer>
        \ if b:lang|sil!call b:VimIM_Insert_On()|endif
        sil!au InsertLeave <buffer>
        \ if b:lang|sil!call b:VimIM_Insert_Off()|let b:lang=1|endif
        sil!au BufUnload   <buffer> autocmd! InsertEnter,InsertLeave
    endif
    if !exists("b:lang") || b:lang==0
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
        \ "[", "]", "<", ">", "+", "-", ",", ".",
        \ ":", ";", "?", "!", "~", "#", "%", "$",
        \ "&", "@", "^", "_", '"', "'", '\']
    " --------------------------------
    let s:punctuation_value = [ "（", "）", "『", "』",
        \ "【", "】", "《", "》", "＋", "－", "，", "。",
        \ "：", "；", "？", "！", "～", "＃", "％", "￥",
        \ "※", "◎", "……", "——", "“”", "‘’", "、"]
    " --------------------------------
    let ecdict = {}
    let ecdict['casino']='中奖啦！'
    let ecdict['grass']='天涯何处无芳草！'
    let ecdict['January']='一月'
    let ecdict['February']='二月'
    let ecdict['March']='三月'
    let ecdict['April']='四月'
    let ecdict['May']='五月'
    let ecdict['June']='六月'
    let ecdict['July']='七月'
    let ecdict['August']='八月'
    let ecdict['September']='九月'
    let ecdict['October']='十月'
    let ecdict['November']='十一月'
    let ecdict['December']='十二月'
    let ecdict['AM']='上午'
    let ecdict['PM']='下午'
    let ecdict['year']='年'
    let ecdict['day']='号'
    let ecdict['hour']='时'
    let ecdict['minute']='分'
    let ecdict['second']='秒'
    let ecdict['Monday']='星期一'
    let ecdict['Tuesday']='星期二'
    let ecdict['Wednesday']='星期三'
    let ecdict['Thursday']='星期四'
    let ecdict['Friday']='星期五'
    let ecdict['Saturday']='星期六'
    let ecdict['Sunday']='星期日'
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
    let s:easter_eggs = ["vi 文本编辑器"]
    call add(s:easter_eggs, "vim 最牛文本编辑器")
    call add(s:easter_eggs, "vim 精力 生氣")
    call add(s:easter_eggs, "vimim 中文输入法")
    " --------------------------------
endfunction

let s:translators = {}
" -----------------------------------------
function! s:translators.translate(key) dict
" -----------------------------------------
    return join(map(split(a:key), 'get(self.dict,v:val,v:val)'))
endfunction

" ======================= }}}

" == The VimIM Core Mapping == {{{
" ================================

if !exists("s:vimim_initialize")
" ------------------------------
    let s:vimim_initialize = 1
    let s:path = expand("<sfile>:p:h")."/"
    sil!call s:VimIM_Initialize()
    sil!call s:VimIM_Load_Raw_Data()
endif

if g:vimim_disable_one_key==0
" ---------------------------
    sil!call s:VimIM_Labels_On(1)
    inoremap <silent> <expr> <C-^> b:VimIM_OneKey()
endif

if g:vimim_disable_smart_space==0
" -------------------------------
    if g:vimim_disable_dynamic_menu==0
        let s:enable_dynamic_menu=1
    endif
    inoremap <silent> <expr> <C-\> b:VimIM_Insert_Toggle()
endif
" ========== }}}

" References
" ----------
" http://groups.google.com/group/vim_use/topics
" http://www.newsmth.net/bbsdoc.php?board=VIM
" http://maxiangjiang.googlepages.com/vimim.html
