"{{{1 Начало
scriptencoding utf-8
if (exists("s:g.pluginloaded") && s:g.pluginloaded) ||
            \exists("g:stufOptions.DoNotLoad")
    finish
"{{{1 Первая загрузка
elseif !exists("s:g.pluginloaded")
    "{{{2 Объявление переменных
    "{{{3 Словари с функциями
    " Функции для внутреннего использования
    let s:F={
                \"stuf": {},
                \"plug": {},
                \ "cmd": {},
                \"file": {},
                \ "str": {},
                \ "lst": {},
                \ "num": {},
                \ "dct": {},
                \"main": {},
                \ "mng": {},
                \"comp": {},
            \}
    lockvar 1 s:F
    "{{{3 Глобальная переменная
    let s:g={}
    let s:g.load={}
    let s:g.pluginloaded=0
    let s:g.load.scriptfile=expand("<sfile>")
    let s:g.srccmd="source ".(s:g.load.scriptfile)
    let s:g.reg={}
    let s:g.reg.oprefix='^[[:alnum:]_]\+$'
    let s:g.reg.intname='^\([[:alnum:]_]\+.\)*[[:alnum:]_]\+$'
    "{{{4 s:g.cmd
    let s:g.cmd={}
    let s:g.cmd.inputs={}
    "{{{4 Функции
    let s:g.c={}
    let s:g.c.sid=["nums", [1]]
    " XXX cinput - 18
    let s:g.c.functions=[
                \["let", "lst.let", {}],
                \["or", "num.or",
                \       {   "model": "simple",
                \        "required": [["num", [0]],
                \                     ["num", [0]]]}],
                \["and", "num.and",
                \       {   "model": "simple",
                \        "required": [["num", [0]],
                \                     ["num", [0]]]}],
                \["recursivefilter", "dct.recursivefilter",
                \       {   "model": "simple",
                \        "required": [["type", type({})]]}],
                \["base64decode",   "str.base64decode",
                \       {   "model": "optional",
                \        "required": [["type", type("")]],
                \        "optional": [[["bool", ""], {}, 0]]}],
                \["regescape",   "str.escapefor.regex",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["globescape",   "str.escapefor.glob",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["mapprepare",  "str.escapefor.map",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["squote",      "str.escapefor.quote",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["iscombining", "str.iscombining",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["strlen",      "str.strlen",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["nextchar",    "str.nextchar",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["nextchar_nr", "str.nextchar_nr",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["printl",      "str.printl",
                \       {   "model": "simple",
                \        "required": [["type", type(0)],
                \                     ["type", type("")]]}],
                \["printtable",  "str.printtable",
                \       {   "model": "simple",
                \        "required": [["alllst", ["type", type("")]],
                \                     ["alllst", ["alllst", ["type", type("")]]]
                \                    ]}],
                \["string",      "str.string", {}],
                \["iswriteable", "file.checkwr",
                \       {   "model": "simple",
                \        "required": [["type", type("")]]}],
                \["readfile",    "file.readfile",
                \       {   "model": "simple",
                \        "required": [["file", "r"]]}],
                \["cinput", "cmd.geninput",
                \       {   "model": "optional",
                \        "required": [["and", [["regex", '^[a-z][a-z_]*$'],
                \                              ["not",
                \                               ["keyof", s:g.cmd.inputs]]]]],
                \        "optional": [[["type", type("")], {}, ""],
                \                     [["or", [["isfunc", 0],
                \                              ["in", ['augroup', 'buffer',
                \                                      'command', 'dir',
                \                                      'environment', 'event',
                \                                      'expression', 'file',
                \                                      'filetype', 'function',
                \                                      'help', 'highlight',
                \                                      'mapping', 'menu',
                \                                      'option', 'shellcmd',
                \                                      'syntax', 'tag', '',
                \                                      'tag_listfiles', 'var']],
                \                              ["regex",
                \                               '^custom,\([sS]:\)\@!']]],
                \                      {}, ""]]}],
            \]
    "{{{4 Команды
    let s:g.load.commands={
                \"E": {
                \       "bang": '',
                \      "nargs": '+',
                \       "func": "mng.main",
                \   "complete": "customlist,s:_completeE",
                \},
            \}
    "{{{4 sid
    function s:SID()
        return matchstr(expand('<sfile>'), '\d\+\ze_SID$')
    endfun
    let s:g.scriptid=s:SID()
    delfunction s:SID
    "{{{2 Регистрация плагина
    let s:F.plug.load=load#LoadFuncdict()
    let s:g.reginfo=s:F.plug.load.registerplugin({
                \     "funcdict": s:F,
                \     "globdict": s:g,
                \     "commands": s:g.load.commands,
                \      "cprefix": "S",
                \      "oprefix": "stuf",
                \          "sid": s:g.scriptid,
                \   "scriptfile": s:g.load.scriptfile,
                \"dictfunctions": s:g.c.functions,
                \   "apiversion": "0.4",
                \     "requires": [["load", '0.0'],
                \                  ["chk",  '0.3'],
                \                  ["comp", '0.2']],
            \})
    let s:F.main.eerror=s:g.reginfo.functions.eerror
    "}}}2
    finish
endif
"{{{1 Вторая загрузка
let s:g.pluginloaded=1
"{{{2 Чистка
unlet s:g.load
"{{{2 Выводимые сообщения
let s:g.p={
            \"emsg": {
            \   "iexists": "Input with such name already exists",
            \}
        \}
call add(s:g.c.functions[18][2].required[0][1][1], s:g.p.emsg.iexists)
"{{{1 Вторая загрузка — функции
"{{{2 plug
let s:F.plug.comp=s:F.plug.load.lazygetfunctions("comp")
let s:F.plug.chk =s:F.plug.load.getfunctions("chk")
"{{{2 stuf
"{{{3 stuf.writevar: записать в переменную
", возможно, являющуюся частью несуществующего словаря, или имеющую другой тип 
"по сравнению с тем, что мы собираемся туда записать
function s:F.stuf.writevar(varname, what)
    let selfname="stuf.writevar"
    if a:varname=~#'\.'
        if !exists(a:varname)
            let dct=matchstr(a:varname, '^.*\.\@=')
            if !exists(dct) || type(eval(dct))!=type({})
                let lastret=s:F.stuf.writevar(dct, {})
                if !lastret
                    return 0
                endif
            endif
        endif
    elseif exists(a:varname) && !islocked(a:varname)
        execute "unlet ".a:varname
    endif
    if exists(a:varname) && islocked(a:varname)
        return s:F.main.eerror(selfname, "perm", ["vlock"], a:varname)
    endif
    execute "let ".a:varname."=a:what"
    return 1
endfunction
"{{{2 str
let s:g.str={}
"{{{3 str.escapefor
let s:F.str.escapefor={}
let s:g.str.escapefor={
            \"regex": 'escape(a:str, ''^$*~[].\'')',
            \"map": 'escape('.
            \        'substitute('.
            \         'substitute('.
            \          'substitute('.
            \           'substitute(a:str, "<", "<LT>", "g"), '.
            \          '" ", "<SPACE>", "g"), '.
            \         '''\t'', "<Tab>", "g"), '.
            \        '''\n'', "<CR>", "g"), "|")',
            \"quote": "\"'\".substitute(".
            \                "substitute(a:str, \"'\", '&&', 'g'), ".
            \               '''\n'', ''''''."\\n".'''''', "g")."''"',
            \"glob": 'escape(a:str, ''[]*?`\'')',
        \}
for s:key in keys(s:g.str.escapefor)
    execute      "function s:F.str.escapefor.".s:key."(str)\n".
                \"    return ".s:g.str.escapefor[s:key]."\n".
                \"endfunction"
endfor
unlet s:key
"{{{3 str.string: failsafe string() replacement
function s:F.str.string(obj)
    if type(a:obj)==type("")
        return a:obj
    endif
    try
        let r=string(a:obj)
    catch
        redir => r
        silent echo a:obj
        redir END
        let r=r[1:]
    endtry
    return r
endfunction
"{{{3 str.strlen: получение длины строки
function s:F.str.strlen(str)
    return len(split(a:str, '\zs'))
endfunction
"{{{3 str.iscombining: проверить, является ли символ диакритикой
" Если да, то вернуть его длину в байтах
" Unicode: combining diacritical marks: определение
" Wikipedia: http://en.wikipedia.org/wiki/Combining_character:
"   Combining Diacritical Marks (0300–036F)
"   Combining Diacritical Marks Supplement (1DC0–1DFF)
"   Combining Diacritical Marks for Symbols (20D0–20FF)
"   Combining Half Marks (FE20–FE2F)
function s:F.str.iscombining(char)
    let chnr=char2nr(a:char)
    if           (0x0300<=chnr && chnr<=0x036F) ||
                \(0x1DC0<=chnr && chnr<=0x1DFF) ||
                \(0x20D0<=chnr && chnr<=0x20FF) ||
                \(0xFE20<=chnr && chnr<=0xFE2F)
        return len(nr2char(chnr))
    endif
    return 0
endfunction
"{{{3 str.nextchar: получить следующий символ (reg('.'))
" Получить следующий символ. Если дан второй аргумент, то получить следующий за 
" позицией, данной во втором аргументе, символ.
function s:F.str.nextchar(str, ...)
    return matchstr(a:str, '.', ((len(a:000))?(a:000[0]):(0)))
endfunction
"{{{3 str.nextchar_nr получить следующий символ (nr2char(char2nr))
" То же, что и предыдущая функция, но получение следующего символа выполняется 
" с помощью nr2char(char2nr)
function s:F.str.nextchar_nr(str, ...)
    return nr2char(char2nr(a:str[((len(a:000))?(a:000[0]):(0)):]))
endfunction
"{{{3 str.printl: printf{'%-*s', ...}
" Напечатать {str}, шириной {len}, выровненное по левому краю, оставшееся 
" пространство заполнив пробелами (вместо printf('%-*s', len, str)).
function s:F.str.printl(len, str)
    return a:str . repeat(" ", a:len-s:F.str.strlen(a:str))
endfunction
"{{{3 str.printtline: печать строки таблицы
" Напечатать одну линию таблицы
"   {line} — список строк таблицы,
" {lenlst} — список длин
function s:F.str.printtline(line, lenlst)
    let result=""
    let i=0
    while i<len(a:line)
        let result.=s:F.str.printl(a:lenlst[i], a:line[i])
        let i+=1
        if i<len(a:line)
            let result.="  "
        endif
    endwhile
    return result
endfunction
"{{{3 str.printtable: напечатать таблицу
" Напечатать таблицу с заголовками рядов {headers} и линиями {lines}.
" {headers}: список строк
"   {lines}: список списков строк
function s:F.str.printtable(header, lines)
    let lineswh=a:lines+[a:header]
    let columns=max(map(copy(lineswh), 'len(v:val)'))
    let lenlst=[]
    let i=0
    while i<columns
        call add(lenlst, max(map(copy(lineswh),
                    \'(i<len(v:val))?s:F.str.strlen(v:val[i]):0')))
        let i+=1
    endwhile
    if !empty(a:header)
        echohl PreProc
        echo s:F.str.printtline(a:header, lenlst)
        echohl None
    endif
    echo join(map(copy(a:lines), 's:F.str.printtline(v:val, lenlst)'), "\n")
    return 1
endfunction
"{{{3 str.base64decode
let s:g.str.cd64=map(split("|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\\]^_`abcdefghijklmnopq",
            \              '\zs'),
            \        'char2nr(v:val)')
function s:F.str.base64decode(str, bytearray)
    let str=map(split(substitute(a:str, '[^a-zA-Z0-9+/]', '', 'g'), '\zs'),
                \'char2nr(v:val)')+[-1]
    let in=repeat([0], 4)
    let v=0
    let len=0
    let i=0
    if a:bytearray
        let r=[]
    else
        let r=""
    endif
    while !empty(str)
        let i=0
        let len=0
        while i<4 && !empty(str)
            let v=0
            while !empty(str) && v==0
                let v=remove(str, 0)
                let v=(((v<43)||(v>122))?(0):(s:g.str.cd64[v-43]))
                if v
                    let v=((v==36)?(0):(v-61))
                endif
            endwhile
            if !empty(str)
                let len+=1
                if v
                    let in[i]=v-1
                endif
            else
                let in[i]=0
            endif
            let i+=1
        endwhile
        if len
            let out=[    s:F.num.or(            in[0]*4,         in[1]/16),
                        \s:F.num.or(            in[1]*16,        in[2]/4),
                        \s:F.num.or(s:F.num.and(in[2]*64, 0xC0), in[3])]
            call map(out, 's:F.num.and(v:val, 0xFF)')
            if a:bytearray
                let r+=out[:(len-2)]
            else
                let r.=join(map(out[:(len-2)],
                            \   'eval(printf(''"\x%02x"'', v:val))'),
                            \"")
            endif
        endif
    endwhile
    return r
endfunction
"{{{2 num
"{{{3 num.and
function s:F.num.and(v1, v2)
    let [v1, v2]=[a:v1, a:v2]
    let list=[]
    while v1 || v2
        let [nv1, nv2]=[v1/2, v2/2]
        call add(list, ((nv1*2!=v1)&&(nv2*2!=v2)))
        let [v1, v2]=[nv1, nv2]
    endwhile
    let r=0
    while !empty(list)
        let r=(r*2) + remove(list, -1)
    endwhile
    return r
endfunction
"{{{3 num.or
function s:F.num.or(v1, v2)
    let [v1, v2]=[a:v1, a:v2]
    let list=[]
    while v1 || v2
        let [nv1, nv2]=[v1/2, v2/2]
        call add(list, ((nv1*2!=v1)||(nv2*2!=v2)))
        let [v1, v2]=[nv1, nv2]
    endwhile
    let r=0
    while !empty(list)
        let r=(r*2) + remove(list, -1)
    endwhile
    return r
endfunction
"{{{2 file
"{{{3 file.checkwr
function s:F.file.checkwr(fname)
    let fwr=filewritable(a:fname)
    return (fwr==1 || (fwr!=2 && !filereadable(a:fname) &&
                \filewritable(fnamemodify(a:fname, ":p:h"))==2))
endfunction
"{{{3 file.readfile: прочитать файл
" vim-7.0 не имеет функции shellescape
if executable("cat") && exists('*shellescape')
    function s:F.file.readfile(fname)
        " Как ни странно, такой вариант работает быстрее, чем все придуманные 
        " мною альтернативы на чистом Vim
        let result=""
        let result=system("cat ".shellescape(a:fname))
        if v:shell_error
            let result=join(readfile(a:fname, 'b'), "\n")
        endif
        return result
        " Если в аргументах readfile не указывать 'b', то файл, не содержащий 
        " переводов строки, прочитается как будто он пустой.
        " return join(readfile(fname, 'b'), "\n")
        " Есть ещё варианты через открытие буфера, но они всё равно медленнее 
        " данного. Тем не менее, даже они могут быть быстрее join(readfile).
    endfunction
else
    function s:F.file.readfile(fname)
        return join(readfile(a:fname, 'b'), "\n")
    endfunction
endif
"{{{2 lst
"{{{3 lst.let
function s:F.lst.let(list, index, element, ...)
    if type(a:list)==type([]) && type(a:index)==type(0)
        let ll=len(a:list)
        if a:index<ll
            let a:list[a:index]=a:element
        elseif a:index==ll
            call add(a:list, a:element)
        elseif !empty(a:000)
            call extend(a:list, repeat([a:000[0]], a:index-ll)+[a:element])
        endif
    elseif type(a:list)==type({}) && type(a:index)==type("")
        let a:list[a:index]=a:element
    endif
    return a:list
endfunction
"{{{2 dct
"{{{3 dct.recursivefilter
function s:F.dct.recursivefilter(dict, expr)
    let r={}
    for [l:Key, l:Val] in items(a:dict)
        if type(l:Val)==type({})
            let r[l:Key]=s:F.dct.recursivefilter(l:Val, a:expr)
        elseif eval(a:expr)
            let r[l:Key]=l:Val
        endif
        unlet l:Val
    endfor
    return r
endfunction
"{{{2 cmd
"{{{3 cmd.savehist
function s:F.cmd.savehist()
    if &viminfo=~'!'
        for [key, value] in items(s:g.cmd.inputs)
            let g:STUF_HISTORY_{toupper(key)}=join(value.history, "\n")
        endfor
    endif
endfunction
augroup StufStoreHistory
    autocmd!
    autocmd VimLeavePre * call s:F.cmd.savehist()
augroup END
"{{{3 cmd.histget
function s:F.cmd.histget(history)
    let r=[]
    while 1
        let histentry=histget(a:history, -1)
        if histdel(a:history, -1)
            call insert(r, histentry)
        else
            return r
        endif
    endwhile
endfunction
"{{{3 cmd.histextend
function s:F.cmd.histextend(history, histlst)
    while !empty(a:histlst)
        call histadd(a:history, remove(a:histlst, 0))
    endwhile
    return a:histlst
endfunction
"{{{3 cmd.input
function s:F.cmd.input(inputdict, ...)
    let prompt=get(a:000, 0, a:inputdict.prompt)
    if type(prompt)!=type("")
        let prompt=a:inputdict.prompt
    endif
    let text=get(a:000, 1, "")
    let completion=get(a:000, 2, a:inputdict.completion)
    let histlock=islocked('a:inputdict.history')
    if !histlock
        call extend(a:inputdict.inputhistory, s:F.cmd.histget("input"))
        call s:F.cmd.histextend("input", a:inputdict.history)
        lockvar a:inputdict.history
    endif
    call inputsave()
    try
        let r=call("input", [prompt, text]+
                    \((empty(completion))?([]):([completion])))
        return r
    catch /^Vim:Interrupt/
        throw "Interrupted"
    catch
        throw "Input failed: ".v:exception
    finally
        call inputrestore()
        if !histlock
            unlockvar a:inputdict.history
            call extend(a:inputdict.history, s:F.cmd.histget("input"))
            call s:F.cmd.histextend("input", a:inputdict.inputhistory)
        endif
    endtry
endfunction
"{{{3 cmd.geninput
function s:F.cmd.geninput(name, prompt, Completion)
    let entry={
                \"name": a:name,
                \"prompt": a:prompt,
                \"history": [],
                \"inputhistory": [],
            \}
    if exists('g:STUF_HISTORY_'.toupper(a:name))
        call extend(entry.history, split(g:STUF_HISTORY_{toupper(a:name)},"\n"))
    endif
    let s:g.cmd.inputs[a:name]=entry
    if type(a:Completion)==2
        let entry.compfunc='g:__complete_input_'.a:name
        execute      "function ".(entry.compfunc)."(...)\n".
                    \"    return call(s:g.cmd.inputs.".a:name.".compF, ".
                    \                "a:000, {})\n".
                    \"endfunction"
        let entry.completion="customlist,".(entry.compfunc)
        let entry.compF=a:Completion
    else
        let entry.completion=a:Completion
    endif
    let r={}
    execute      "function r.f(...)\n".
                \"    return call(s:F.cmd.input, ".
                \           "[s:g.cmd.inputs.".a:name."]+a:000, {})\n".
                \"endfunction"
    execute      "function r.d()\n".
                \"    return s:F.cmd.delinput(".string(a:name).")\n".
                \"endfunction"
    return [r.f, r.d]
endfunction
"{{{3 cmd.delinput
function s:F.cmd.delinput(name)
    if has_key(s:g.cmd.inputs[a:name], 'compfunc')
        execute "delfunction ".s:g.cmd.inputs[a:name].compfunc
    endif
    unlet s:g.cmd.inputs[a:name]
    return 1
endfunction
"{{{2 main: destruct
"{{{3 main.destruct: выгрузить плагин
function s:F.main.destruct()
    if has_key(s:F.plug.comp, "delcomp")
        call s:F.plug.comp.delcomp(s:g.comp._cnameE)
    endif
    unlet s:g
    unlet s:F
    return 1
endfunction
"{{{2 mng: main
"{{{3 mng.main
function s:F.mng.main(bang, ...)
    let options=filter(copy(a:000), 'v:val[0:1]==#"++"')
    let files=filter(copy(a:000), 'v:val[0:1]!=#"++"')
    let nfiles=[]
    for file in files
        execute "e".a:bang." ".join(options)." ".join(map(files, 'fnameescape(v:val)'))
    endfor
endfunction
"{{{2 comp: _completeE
"{{{3 comp._completeE
"{{{4 s:g.comp
let s:g.comp={}
let s:g.comp.ppopt=["ff", "fileformat", "enc", "encoding", "bin", "binary",
            \       "nobin", "nobinary", "bad", "edit"]
let s:g.comp.fileformats=['dos', 'unix', 'mac']
let s:g.comp.encodings=['latin1', 'koi8-r', 'koi8-u', 'macroman',
            \'cp437', 'cp737', 'cp775', 'cp850', 'cp852', 'cp855', 'cp857',
            \'cp860', 'cp861', 'cp862', 'cp863', 'cp865', 'cp866', 'cp869',
            \'cp874', 'cp1250', 'cp1251', 'cp1253', 'cp1254', 'cp1255',
            \'cp1256', 'cp1257', 'cp1258']
call extend(s:g.comp.encodings, map(range(2, 15), "'iso-8859-'.v:val"))
call extend(s:g.comp.encodings, map(copy(s:g.comp.encodings), "'8bit-'.v:val"))
let s:g.comp.dbencodings=['cp932', 'euc-jp', 'sjis', 'cp949',
            \'euc-kr', 'cp936', 'euc-cn', 'cp950', 'big5', 'euc-tw',
            \'japan', 'korea', 'prc', 'chinese', 'taiwan']
call extend(s:g.comp.encodings, s:g.comp.dbencodings)
call extend(s:g.comp.encodings, map(copy(s:g.comp.dbencodings),
            \'"2byte-".v:val'))
call extend(s:g.comp.encodings, ['utf-8', 'ucs-2', 'ucs-2le', 'utf-16',
            \'utf-16le', 'ucs-4', 'ucs-4le', 'utf8', 'unicode', 'uncs2be',
            \'ucs-2be', 'ucs-4be', 'utf-32', 'utf-32le', 'default'])
let s:g.comp._cnameE="stuf/E"
let s:g.comp.toarglead=[
            \'v:val=~#"^".es',
            \'v:val=~?"^".es',
            \'v:val=~#es',
            \'v:val=~?es',
        \]
"}}}4
function s:F.comp._completeEopt(arglead)
    let start=a:arglead
    if start[0:1]==#'++'
        let start=start[2:]
        if start!~#'='
            return map(copy(s:g.comp.ppopt), '"++".v:val')
        else
            let end=matchstr(start, '=\@<=.*$')
            let s=matchstr(start, '^.\{-}=\@=')
            let es=s:F.str.escapefor.regex(s)
            if start=~#'^\%(ff\|fileformat\)='
                return map(copy(s:g.comp.fileformats), '"++".s."=".v:val')
            elseif start=~#'^\%(enc\|encoding\)='
                return map(copy(s:g.comp.encodings), '"++".s."=".v:val')
            else
                let starts=[]
                for expr in s:g.comp.toarglead
                    let starts=filter(copy(s:g.comp.ppopt), expr)
                    if !empty(starts)
                        break
                    endif
                endfor
                let r=[]
                for start in starts
                    let r+=s:F.comp._completeEopt("++".start."=".end)
                endfor
                return r
            endif
        endif
    endif
    return []
endfunction
let s:g.comp.Emodel=
            \{"model": "words",
            \ "words": ["first", [["func", s:F.comp._completeEopt],
            \                     ["file", ""]]]}
function s:F.comp._completeE(...)
    if !has_key(s:F.comp, "__completeE")
        unlockvar! s:F.comp
        let s:F.comp.__completeE=
                    \s:F.plug.load.run(s:F.plug.comp, "ccomp",
                    \                  s:g.comp._cnameE, s:g.comp.Emodel)
        lockvar! s:F.comp
    endif
    return call(s:F.comp.__completeE, a:000, {})
endfunction
"{{{1
lockvar! s:g
unlockvar! s:g.cmd.inputs
lockvar! s:F
" vim: ft=vim:ts=8:fdm=marker:fenc=utf-8
