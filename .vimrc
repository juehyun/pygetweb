"********************************************************************************
"-- COPYRIGHT (C) 2019, Joohyun Lee, ALL RIGHT RESERVED
"--------------------------------------------------------------------------------
"-- .vimrc by Joo-Hyun Lee (juehyun@etri.re.kr)
"--------------------------------------------------------------------------------
"vim normally installed at /usr/share/vim
"vim init with ~/.vimrc and then ~/.gvimrc
"********************************************************************************

"================================================================================
" VIM script 
" references : 
" 	https://tot0rokr.github.io/kat/vim/vim-script-kat-3-1/
" 	https://developer.ibm.com/articles/l-vim-script-1/
" 	https://devhints.io/vimscript-functions
"--------------------------------------------------------------------------------
" variable scope
"--------------------------------------------------------------------------------
" g:varname : global
" s:varname : local to the current script file
" w:varname : local to the current editor window
" t:varname : local to the current editor tab
" b:varname : local to the current editor buffer
" l:varname : local to the current function
" a:varname : a parameter of the current function
" v:varname : one that Vim predefines
"--------------------------------------------------------------------------------
" pseudo-variable
"--------------------------------------------------------------------------------
" &varname  : A Vim option(local option if defined, otherwise global)
" &l:varname: A local Vim option
" &g:varname: A global Vim option
" @varname  : A Vim register
" $varname  : An environment variable
"--------------------------------------------------------------------------------
" comment-style
"--------------------------------------------------------------------------------
" use " at the begining of line, for whole line comment
" use |" for in-line comment, some cases, the <space> in-front-of |" is matter
"--------------------------------------------------------------------------------
" vi-register : help registers
"--------------------------------------------------------------------------------
" "" "0~9 "- ": ". "% "# "= "* "+ "~ "_ "/
" "0~9 : numbered register : yank or deleted 0, deleted 1 -> 9 (history)
" "a~z : named    register : replace user specified register a~z
" "A~Z : named    register : append  user specified register a~z
" e.g.
"      :registers            display register contents
"      :g/pattern/d A        append deleted lines to register a
"      :let @/ = "pattern"   set pattern to register "= 
"      :qaq                  tips, clear register "a by override recording
"
"--------------------------------------------------------------------------------

"================================================================================
" Runtime path for Windows OS
"--------------------------------------------------------------------------------
" Vim path on Windows '$VIMRUNTIME/../vimfiles' is under 'Program Files' path and 
" it is protected by Windows OS, use (~/.vim) for plugins and etc.,
" Use same folder (~/.vim) for same configuration b/w Linux and Windows
if has ('win32')| "help feature-list
set rtp+=~/.vim 
endif

"================================================================================
" Encoding (encoding, fileencoding, fileencodings, fileformat)
"--------------------------------------------------------------------------------
set encoding=utf-8|                          "char encoding used inside vim (default from LOCALE, cp949@windows, utf-8@linux)
set fileencodings=utf-8,cp949|               "char encoding candidate to open EXISTING FILE (check one by one, if no error, set to 'fileencoding')
"set fileencodings=utf-8,cp949,euc-kr,johab| "char encoding candidate to open EXISTING FILE (check one by one, if no error, set to 'fileencoding')
set fileformat=unix|                         "<EOL> used for reading/writing buffer from/to file ( dos <CR><LF> = ^M, unix <LF>, mac <CR> )

"================================================================================
" Language
"--------------------------------------------------------------------------------
set langmenu=en_US.UTF-8|      "Menu language
language message en_US.UTF-8|  "Status output language

"================================================================================
" Indentation (Tab)
"--------------------------------------------------------------------------------
"set list listchars=tab:\|\ ,space:⋅|  "indent guide line, dont forget space at the end 
set list listchars=tab:\|\ |           "indent guide line, dont forget space at the end
set smarttab
set autoindent
set smartindent
set noexpandtab tabstop=2 shiftwidth=2
"autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4| "Style Guide for Python Code, PEP8

"================================================================================
" Misc. Editor Settings
"--------------------------------------------------------------------------------
syntax on
set nobackup
set nowritebackup
set noswapfile
set visualbell
set hlsearch
set ignorecase
set nowrap|            "do not automatically wrap
set formatoptions-=c|  "do not automatically wrap when typing (:help fo-table)
set textwidth=0|       "max width of text that is being inserted (default:0, disable line break)
set mouse+=a|          "mouse click & cursor move in vim (non-gui)
"set mousefocus|       "focus follow mouse hovering (b/w split windows) (only for gvim) (annoying with sidebar)

"================================================================================
" Cursor Line
"--------------------------------------------------------------------------------
set cursorline
"set cursorcolumn
"set cursorlineopt=both|              "line, number, screenline, both=line+number
"autocmd BufEnter * set cursorline|   "only display cursorline to focused window,pane
"autocmd BufLeave * set nocursorline| "only display cursorline to focused window,pane

"================================================================================
" Help window on vertical split window
"--------------------------------------------------------------------------------
"cmap help vertical help
autocmd FileType help wincmd L
"command -nargs=* -complete=help Help vertical belowright help <args>
"command -nargs=* -complete=help Help vertical help <args>

"================================================================================
" Remember previous window position and size
"--------------------------------------------------------------------------------
function! SavePosGeom()
	let l:pos_x = getwinposx()
	let l:pos_y = getwinposy()
	let l:pos_c = &columns
	let l:pos_r = &lines
	"let l:pos_c = winwidth(0)  " columns
	"let l:pos_r = winheight(0) " rows
	let l:mouse_x = l:pos_x + 500
	let l:mouse_y = l:pos_y + 500
	let l:txt = ['winpos '.l:pos_x.' '.l:pos_y , 'set columns='.l:pos_c.' lines='.l:pos_r , 'silent execute "!mouse_ctrl.exe moveTo ' . l:mouse_x . 'x' . l:mouse_y . '"']
	let l:fname = '.vimpos'
	lcd ~
	call writefile(l:txt, l:fname)
endfunction

function! LoadPosGeom()
	if !g:session_loaded
		source ~/.vimpos
	endif
	let g:session_loaded=0
endfunction
"getwinposx(), getwinposy()

if has('gui_running')
	"winpos 800 40|            "window position in pixel
	"set columns=256 lines=60| "window size
	let g:session_loaded=0
	autocmd SessionLoadPost * let g:session_loaded=1
	autocmd GUIEnter        * call LoadPosGeom()
	autocmd VIMLeave        * call SavePosGeom()
endif

"================================================================================
" GUIoptions
"--------------------------------------------------------------------------------
if has('gui_running')
	set guioptions+=l|         "Left Scrollbar always present
	set guioptions-=m|         "Remove Menubar 
	set guioptions-=T|         "Remove Toolbar
endif

"================================================================================
" copy & paste / block selection using mouse / clipboard
"--------------------------------------------------------------------------------
" "*y : primary clipboard, 
" "+y : application clipboard
set guioptions+=a "only gvim, +a:Autoselect (visual select -> primary clipboard * )

"if has ('win32')
"source $VIMRUNTIME/mswin.vim| " to use CTRL-X, CTRL-C and CTRL-V
"behave mswin
"endif

set clipboard=unnamed " MacOS

"================================================================================
" working directory
"--------------------------------------------------------------------------------
" :cd  %:p:h (% current file name, %:p full path, %:p:h head of full path (i.e. the file's directory only)
" :lcd %:p:h (change directory only for current window)
" :pwd
"set audochdir| "automatically change working directory to current file ( cause some plugins error )
"autocmd BufEnter * silent! lcd %:p:h| "same autochdir but better some cases. refer https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file

"================================================================================
" Restore last editing (last file and edit position)
"--------------------------------------------------------------------------------
autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal! g`\"" |
		\ endif

"================================================================================
" Status Line (statusline, status-line) - see also airline plugin
"--------------------------------------------------------------------------------
" %f(relative path from current dir)
" %F(Full file path)
" %t(file name only)
" %m(Shows + if modified - if not modifiable)
" %r(Shows RO if readonly)
" %y(file type)
" %<(Truncate here if necessary)
" \ (Separator)
" %=(Separation position b/w left and right aligned items)
" %l(Line number)
" %c(Column number)
" %v(virtual column number)
" %L(Total number of lines)
" %p(How far in file we are percentage wise)
" %%(Percent sign)

set statusline=%<%F\ %h%m%r%=[%t]\ [%{&ff}]\ %{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %l,%c\ [%L]\ %p%%

set laststatus=2| "Make sure it always shows
set ruler|        "cursor position on status line


"================================================================================
" Save session properties (:help  sessionoptions or ssop, to compatible with windows gvim)
"--------------------------------------------------------------------------------
set ssop-=help
set ssop-=options
set ssop-=blank
set ssop-=buffers
set ssop-=terminal
set ssop+=resize
set ssop+=winpos
set ssop+=winsize
set ssop+=unix
set ssop+=slash
set ssop+=folds
set foldmethod=marker| "def=manual, default marker is tripole '{ { {' and '} } }'
set ssop-=curdir
set ssop+=sesdir|      "the dir in which session file become cwd, exclusive with 'curdir' option

" save session file with relative path from current dir
function! SaveSession()
	" save session file
	if has("unix")
		let l:fname = "vimsession.lnx." . strftime('%Y%m%d-%H%M%S')
		let l:cwdabs = getcwd()
		let l:homeabs = $HOME
	elseif has("gui_win32")
		let l:fname = "vimsession.win." . strftime('%Y%m%d-%H%M%S')
		"session file always use '/' for path delimter because of ssop+=slash option
		let l:cwdabs = substitute(getcwd(), '\\', '\/', 'g')
		let l:homeabs = substitute($HOME, '\\', '\/', 'g')
	endif
		silent exe "mksession! " . l:fname

	let fl = readfile(l:fname, "b")
	let i=0
	for ln in fl
		"change ~/ to absolute path
		let ln    = substitute(ln, '\~\/', escape(l:homeabs.'/',' /'), 'g')
		"remove cwd, not change to '.' it cause error related ':buffer ./path/to/file'
		let ln    = substitute(ln, escape(l:cwdabs.'/',' /'), ''  , 'g')
		let fl[i] = substitute(ln, escape(l:cwdabs    ,' /'), '.' , 'g')
		let i=i+1
	endfor
	call writefile(fl, l:fname, "b")
	echo "session saved to (".l:fname.")"
endfunction

map <Leader>mks :call<space>SaveSession()<CR>

"================================================================================
" Font, Ligature
"--------------------------------------------------------------------------------
if has('gui_running')
	if has('unix')
		set guifont=D2Coding\ Ligature\ 14| "linux vim needs patch to enable Ligature font
		"set guifont=Consolas\ 14
		"set guifont=Monospace\ 10
		"set guifont=Courier\ 10\ Pitch
		"set guifont=Lucida\ Console
		"set guifont=Lucida_Sans_Typewriter:h10
		"set guifont=Luxi\ Mono\ Regular\ 10
		"set guifont=MiscFixed\ 12
	elseif has("gui_macvim")| "Apple Mac
		set guifont=Menlo\ Regular:h12
	elseif has("gui_win32")
		set guifont=D2Coding\ Ligature:h14
		set renderoptions=type:directx| "windows gvim need additional setting to enable Ligature fonts
	else
		set guifont=Consolas:h14
	endif "has('unix')
endif "has('gui_runnig')

"================================================================================
" Conceal (mimic Ligature font)
"--------------------------------------------------------------------------------
" use Conceal to mimic Ligature font
"syntax match arrow  "->" conceal cchar=→
"syntax match rpipe  "|>" conceal cchar=⊳
"syntax match lpipe  "<|"conceal cchar=⊲
"syntax match rcomp  ">>" conceal cchar=»
"syntax match lcom   "<<" conceal cchar=«
"syntax match lambda "\\" conceal cchar=λ
"syntax match cons   "::" conceal cchar=∷
"syntax match parse1 "|=" conceal cchar=⊧
"syntax match parse2 "|." conceal cchar=⊦
"syntax match neq    "/=" conceal cchar=≠
"syntax match div    "//" conceal cchar=÷
"syntax match mul    "*"  conceal cchar=×
"syntax match eq     "==" conceal cchar=≣

"syntax match neq    "!=" conceal cchar=≠
"syntax match gteq   ">=" conceal cchar=≥
"syntax match lteq   "<=" conceal cchar=≤
"set conceallevel=1
"set concealcursor=nvic
"highlight clear Conceal

"================================================================================
" diff
"--------------------------------------------------------------------------------
"set diffexpr=MyDiff()| "it should not be set, if not set, Vim will assume you have a standard diff program in your PATH, and use it (install MinGW/msys/1.0/bin/diff.exe , or , GnuWin32 diff etc)
"use command gvim -Od file1 file2
"use tkdiff, winmerge, etc.,

"================================================================================
" Tag (:help tags-option, :help file-searching)
"--------------------------------------------------------------------------------
":tag      CTRL-]    : jump to the 1st matched
":tselect  g]        : list tags matched
":stselect           : split
":tjump    g CTRL-]  : if only one matched, jump to tag directly. otherwise list tags
":stjump             : split

set tags=./tags;|       "search 'tags' file from 'directory of current file' and parent directory recursively until the root (';' is matter)
"set tags=./tags,tags|  "search 'tags' file from 'directory of current file', and then search 'current directory'
"set tags=tags,./tags|  "search 'tags' file from 'current directory', and then search 'directory of current file'

map <C-]>     g<C-]>zz
map <Leader>gf <Leader>=<C-W>v:tag<space><C-R>=expand('<cfile>')<CR><CR>| "go to file (jump to tag using tag information), it needs tag file which is generated from 'ctags -R --extra=+f '
map <Leader>]  <Leader>=<C-W>vg<C-]>zz| " highlight and jumpt to tag

"================================================================================
" split-window
"--------------------------------------------------------------------------------
"set noea|       "equalalways : when closing split window, do not resize other windows
set equalalways| "when closing split window, do not resize other windows

"let g:netrw_altv=1|       "Normally, the v key splits the window vertically with the new window and cursor at the left. To change behavior after splitting vertically, cursor located at the right window
"let g:netrw_winsize=100|  "specify initial size of new windows made with netrw-o, netrw-v, Hexplore Vexplore.

set splitright
set splitbelow

"if has('gui_running')|                                 "only for gvim, vim cannot distinguish <C-S-key> and <C-key> input)
"nmap <C-S-e> <C-W>v|                                   "split vertical
"nmap <C-S-e> :vertical<space>botright<space>split<CR>| "split vertical full height, right most side
"nmap <C-S-e> :vertical<space>topleft<space>split<CR>|  "split vertical full height, left most side
"nmap <C-S-o> <C-W>s|                                   "split horizontal
"nmap <C-S-h> <C-W>h|                                   "move focus to left pane
"nmap <C-S-j> <C-W>j|                                   "move focus to down pane
"nmap <C-S-k> <C-W>k|                                   "move focus to up pane
"nmap <C-S-l> <C-W>l|                                   "move focus to right pane
"endif

if has('gui_running') && has('linux')
"set fillchars=vert:\|,fold:-| "the default (:help fillchars)
set fillchars+=vert:\│
else
set fillchars+=vert:\|
endif

"================================================================================
" tab-window related
"--------------------------------------------------------------------------------
"see tab lists      ( :tabs
"goto next/prev tab ( :tabn = gt, :tabp = gT
"goto n-th tab      ( :tabn x
"move tab           ( :tabmove x, :+tabmove, :-tabmove, :tabmove +1, :tabmove 0

"map <Leader>t :tabnew<CR>|  "new tab
map <C-w>t :tabnew<CR>|      "new tab
"if has('gui_running') 
"nmap <C-S-t> :tabnew<CR>|   "new tab, only for gvim, vim cannot distinguish <C-S-key> and <C-key> input)
"endif

map <C-w>w 300<C-w>\|

"================================================================================
" set equal size for all window, all tabs, and return to current window
"--------------------------------------------------------------------------------
" see also bufnr("%"), :tabs , :buf{nr}
function! SetEqSizeAll()
	let l:win_id = winnr() 
	let l:tab_id = tabpagenr()
	" for all tabs, <C-w>=
	tabdo wincmd =
	" go to specific tab, normal mode command is '{nr}gt'
	execute "tabnext " . l:tab_id
	" go to specific window in current tab, normal mode command is '{nr}<C-w>w'
	execute l:win_id . "wincmd w"
endfunction
map <Leader>w= :call<space>SetEqSizeAll()<CR>|  "set equal size for all windows, all tabs

"================================================================================
" Blockwise Utility 
"--------------------------------------------------------------------------------
" counter, generate num,alpha sequence
set nrformats=alpha,octal,hex,bin
" C-A : incr number under cursor or selected block (dec:123, hex:0x1FE, oct:0177, bin:0b101) 
" C-X : decr number under cursor or selected block
"unmap <C-x>
" select block over multiple line, incr 2 for all line : 2<C-A>
" select block over multiple line, generate seq step=2 : 2g<C-A>

" usage for conversion functions (visual selection and use following function)
vmap <Leader>h2d :call Hex2dec()<CR>
vmap <Leader>h2b :call Hex2bin()<CR>
vmap <Leader>d2h :call Dec2hex()<CR>
vmap <Leader>d2b :call Dec2bin()<CR>
vmap <Leader>b2h :call Bin2hex()<CR>
vmap <Leader>b2d :call Bin2dec()<CR>
vmap <Leader>cmp :call Compare()<CR>

function! Bin2hex()
	let row_s = line("'<")|    "first line of selected block
	let row_e = line("'>")|    "last line of selected block
	let col_s = col("'<")|     "left column of selected block
	let col_e = col("'>")|     "right column of selected block
	let ln = line("v")|        "current processing line
	let in_str = getline(ln)[col_s-1:col_e-1]
	let in_num = str2nr(in_str, 2)
	let @z = printf('%x',in_num)
	s/\%V.*\%V./\=@z/|         "substitue only inside of visual area
endfunction

function! Bin2dec()
	let row_s = line("'<")|    "first line of selected block
	let row_e = line("'>")|    "last line of selected block
	let col_s = col("'<")|     "left column of selected block
	let col_e = col("'>")|     "right column of selected block
	let ln = line("v")|        "current processing line
	let in_str = getline(ln)[col_s-1:col_e-1]
	let in_num = str2nr(in_str, 2)
	let @z = printf('%d',in_num)
	s/\%V.*\%V./\=@z/|         "substitue only inside of visual area
endfunction

function! Hex2dec()
	let row_s = line("'<")|    "first line of selected block
	let row_e = line("'>")|    "last line of selected block
	let col_s = col("'<")|     "left column of selected block
	let col_e = col("'>")|     "right column of selected block
	let ln = line("v")|        "current processing line
	let in_str = getline(ln)[col_s-1:col_e-1]
	let in_num = str2nr(in_str, 16)
	let @z = printf('%d',in_num)
	s/\%V.*\%V./\=@z/|         "substitue only inside of visual area
endfunction

function! Hex2bin()
	let row_s = line("'<")|    "first line of selected block
	let row_e = line("'>")|    "last line of selected block
	let col_s = col("'<")|     "left column of selected block
	let col_e = col("'>")|     "right column of selected block
	let ln = line("v")|        "current processing line
	let in_str = getline(ln)[col_s-1:col_e-1]
	let in_num = str2nr(in_str, 16)
	let @z = printf('%b',in_num)
	s/\%V.*\%V./\=@z/|         "substitue only inside of visual area
endfunction

function! Dec2hex()
	let row_s = line("'<")|    "first line of selected block
	let row_e = line("'>")|    "last line of selected block
	let col_s = col("'<")|     "left column of selected block
	let col_e = col("'>")|     "right column of selected block
	let ln = line("v")|        "current processing line
	let in_str = getline(ln)[col_s-1:col_e-1]
	let in_num = str2nr(in_str, 10)
	let @z = printf('%x',in_num)
	s/\%V.*\%V./\=@z/|         "substitue only inside of visual area
endfunction

function! Dec2bin()
	let row_s = line("'<")|    "first line of selected block
	let row_e = line("'>")|    "last line of selected block
	let col_s = col("'<")|     "left column of selected block
	let col_e = col("'>")|     "right column of selected block
	let ln = line("v")|        "current processing line
	let in_str = getline(ln)[col_s-1:col_e-1]
	let in_num = str2nr(in_str, 10)
	let @z = printf('%b',in_num)
	s/\%V.*\%V./\=@z/|         "substitue only inside of visual area
endfunction

function! Compare()
	let row_s = line("'<")|    "first line of selected block
	let row_e = line("'>")|    "last line of selected block
	let col_s = col("'<")|     "left column of selected block
	let col_e = col("'>")|     "right column of selected block
	let ln = line("v")|        "current processing line
	let in_str = getline(ln)[col_s-1:col_e-1]
	let in_lst = split(in_str,'\s\+')
	if in_lst[1]!=in_lst[0]
		echo "line " . ln . " not matched (" . in_lst[1] . ") vs (" . in_lst[0] . ")"
	endif
endfunction

"================================================================================
" cscope (vim should be compiled with +cscope, (cscope is not a vim plugin)
"--------------------------------------------------------------------------------
function! LoadCscopeDB()
	if filereadable("./cscope.out")
		"echo getcwd()
		silent cscope kill 0
		cscope add cscope.out
		"echo ''
		"cs show
	endif
endfunction

set csqf=a-,c-,d-,e-,f-,g-,i-,s-,t-| "cscopequickfix: cscope use quickfix window or not. + append, - clearance-renewal, 0 not use quickfix
"set csprg=/usr/bin/cscope
"set csto=0|                         "cscopetagorder : 0,search cscope db and then search tag file / 1,vice versa
"set cst|                            "cscopetag      : if set, you will always search cscope database as well as tag files

"set nocsverb
"call LoadCscopeDB()
"set csverb

"================================================================================
" Code Browser ( cscope / vimgrep / vim-ripgrep )
"--------------------------------------------------------------------------------
function! CodeBrowser()
	echom('--- code browser menu by juehyun@etri.re.kr ---')
	echom('(0) generate database (tags,cscope.out)')
	echom('(r) find string with rg (ripgrep)')
	echom('(t) find text')                 
	echom('(g) find definition')
	echom('(s) find C symbol')
	echom('(a) find assignment to this symbol')
	echom('(c) find func calling   this func')
	echom('(d) find func called by this func')

	echom('(e) find egrep pattern')
	echom('(f) find this file')
	echom('(i) find files including this file')
	echom('(x) clear quickfix window')                 

	if !filereadable("./cscope.out")
		echom('*** cscope db file (./cscope.out) not found, generate it first by press (0) and Enter ***')
	else
		call LoadCscopeDB()
	endif

	call inputsave()
	let l:msg = input(':')
	call inputrestore()

	if len(l:msg)==0 | return | endif

	let l:tmp = split(l:msg,' ')
	let l:cmd = l:tmp[0]
	let l:str = join(l:tmp[1:-1],' ')
	let l:str = substitute( l:str, '^\s\+' , '', '')
	let l:str = substitute( l:str, '\s\+$' , '', '')
	" l:cmd is one of {0, r, t, g, s,...}
	" l:str is "text  search" of input ":r text  search"

	if len(l:str)==0 | let l:str = expand('<cword>') | endif

	"let l:xxx = input('----cmd:'.l:cmd.'----'.'str:'.l:str.'----')

	if l:cmd==?'0' 
		call system('rm tags cscope.files cscope.out')

		"if has ('win32')
		"    call system('C:\msys64\usr\bin\find.exe . -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" -o -name "*.S" -o -name "*.s" > cscope.files')
		"else
		"    call system('find . -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" -o -name "*.S" -o -name "*.s" > cscope.files')
		"endif
		
		":silent exec '!fzf +s -f .cpp$ >  cscope.files'
		":silent exec '!fzf +s -f .c$   >> cscope.files'
		":silent exec '!fzf +s -f .cc$  >> cscope.files'
		":silent exec '!fzf +s -f .h$   >> cscope.files'
		":silent exec '!fzf +s -f .hpp$ >> cscope.files'
		":silent exec '!fzf +s -f .s$   >> cscope.files'
		":silent exec '!fd -I -e cpp -e c -e cc -e h -e hpp -e s -e cl -e opencl -e def >  cscope.files'| "fd , rg can share .ignore file
		if has("win32")
		":silent exec '!fd    -I -H  -e cpp -e c -e cc -e h -e hpp -e s -e cl -e opencl -e def >  cscope.files'| "fd , rg can share .ignore file, respect .ignore
		:silent exec '!fd        -H  -e cpp -e c -e cc -e h -e hpp -e s -e cl -e opencl -e def >  cscope.files'| "fd , rg can share .ignore file
		else
		":silent exec '!fdfind -I -H  -e cpp -e c -e cc -e h -e hpp -e s -e cl -e opencl -e def >  cscope.files'| "fd , rg can share .ignore file, respect .ignore
		:silent exec '!fdfind     -H  -e cpp -e c -e cc -e h -e hpp -e s -e cl -e opencl -e def >  cscope.files'| "fd , rg can share .ignore file
		endif

		call system('cscope -i cscope.files -b -R ')
		"call system('ctags -L cscope.files ')
		call system('ctags -L cscope.files --extra=+f')
		call LoadCscopeDB()
		return
	elseif l:cmd=='r' | cgetexpr [] | silent exe 'Rg '.l:str

	elseif l:cmd=='t' | cgetexpr [] | silent exe 'cs find t '.l:str
	elseif l:cmd=='s' | cgetexpr [] | silent exe 'cs find s '.l:str
	elseif l:cmd=='a' | cgetexpr [] | silent exe 'cs find a '.l:str
	elseif l:cmd=='c' | cgetexpr [] | silent exe 'cs find c '.l:str
	elseif l:cmd=='d' | cgetexpr [] | silent exe 'cs find d '.l:str

	elseif l:cmd=='e' | cgetexpr [] | silent exe 'cs find e '.l:str
	elseif l:cmd=='f' | cgetexpr [] | silent exe 'cs find f '.l:str
	elseif l:cmd=='g' | cgetexpr [] | silent exe 'cs find g '.l:str
	elseif l:cmd=='i' | cgetexpr [] | silent exe 'cs find i '.l:str
	elseif l:cmd=='x' | cgetexpr []
	endif

	let l:nitems = len(getqflist())
	if nitems==0 | close | endif

	botright cwindow 
	"echo 'total '.l:nitems.' items found'
	return nitems
endfunction

map <Leader>cb :call CodeBrowser()<CR>

"================================================================================
" execute app with file name (vim > 7.4 already has :gx command but not work for file name with space
"--------------------------------------------------------------------------------
function! OpenFile()
	"assume file name surrouned by quote ("file name.ext")
	let l:file = matchstr(getline("."), '".*"')
	echom l:file
	if (has('win32') || has('win64'))
		silent exec '!start '.l:file
	else
		silent exec '!open  '.l:file
	endif
endfunction
nnoremap <leader>gx :call OpenFile()<CR>

function! OpenURL()
	let l:url = matchstr(getline("."), "[a-z]*:\/\/[^ >,;()'`]*")
	if l:url != ""
		let l:exe = 'c:\program files\Google\Chrome\Application\chrome.exe'
		let l:url = shellescape(l:url, 1)
		let l:exe = shellescape(l:exe, 1)
		let l:cmd = '!start '.l:exe.' '.l:url
		silent exec l:cmd
		echom l:cmd
		":redraw!
	else
		echo "No URL found in the line."
	endif
endfunction
nnoremap <leader>url :call OpenURL()<CR>

function! SearchGoogle()
	let l:keyword = expand("<cword>")
	let l:url = 'http://www.google.com/search?q=' . l:keyword
	let l:url = shellescape(l:url, 1)
	let l:exe = 'c:\program files\Google\Chrome\Application\chrome.exe'
	let l:exe = shellescape(l:exe, 1)
	let l:cmd = '!start ' . l:exe . ' ' . l:url
	silent exec l:cmd
	echom l:cmd
endfun
nnoremap <leader>ggl :call SearchGoogle()<CR>

"================================================================================
" gvim open files with single instance (actually not in .vimrc config, command-line input
"--------------------------------------------------------------------------------
"gvim --remote-tab-silent "filename"
"gvim --remote-send       "<Esc>:tablast | tabe filename<CR>"
"gvim --remote-send       "<Esc>:vsplit  filename<CR>"
"gvim --remote-send       "<Esc>:split   filename<CR>"

"see .alias file
"alias vt        'gvim --remote-tab-silent \!*'
"alias vs        'gvim --remote-send "<Esc>:split  \!*<CR>"'
"alias vv        'gvim --remote-send "<Esc>:vsplit \!*<CR>"'

"================================================================================
" synatx highlight mapping
"--------------------------------------------------------------------------------
autocmd BufRead,BufNewFile *.sv     set filetype=verilog_systemverilog
autocmd BufRead,BufNewFile *.cl     set filetype=cpp           
autocmd BufRead,BufNewFile *.opencl set filetype=cpp           

"================================================================================
" OmniCppComplete (intellisense for cpp files, instead of it, use clang_complete)
""--------------------------------------------------------------------------------
"{{{
""set omnifunc?
"au BufNewFile,BufRead,BufEnter *.cpp,*.hpp,*.c,*.h set omnifunc=omni#cpp#complete#Main
"set nocompatible
"filetype plugin on
"
"" configure tags - add additional tags here or comment out not-used ones
"set tags+=~/.vim/tags/cpp
"set tags+=~/.vim/tags/gl
"set tags+=~/.vim/tags/sdl
"set tags+=~/.vim/tags/qt4
"" build tags of your own project with Ctrl-F12
"map <C-F12> :!ctags -R --sort=yes --c++-kinds=+pl --fields=+iaS --extra=+q -I .<CR>
""map <C-F12> :!ctags -R --sort=yes --c++-kinds=+pl --fields=+iaS --extra=+q -I .<CR>
""map <C-F12> :!ctags -R --sort=yes --c++-kinds=+pl --fields=+iaS --extra=+q -I --language-force=c++ .<CR>
"
"" OmniCppComplete
"let OmniCpp_NamespaceSearch = 1
"let OmniCpp_GlobalScopeSearch = 1
"let OmniCpp_ShowAccess = 1
"let OmniCpp_ShowPrototypeInAbbr = 1| "show function parameters
"let OmniCpp_MayCompleteDot = 1|      "autocomplete after .
"let OmniCpp_MayCompleteArrow = 1|    "autocomplete after ->
"let OmniCpp_MayCompleteScope = 1|    "autocomplete after ::
"let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
"let OmniCpp_SelectFirstItem = 2
"
"" automatically open and close the popup menu / preview window
"au CursorMovedI,InsertLeave * if pumvisible() == 0 | silent! pclose | endif
"set completeopt=menuone,menu,longest,preview
"
"" juehyun (internal variable not functional)
"imap .   .<C-X><C-O>
"imap -> -><C-X><C-O>
"imap :: ::<C-X><C-O>
"imap (   (<C-X><C-O>
"}}}
"
"================================================================================
" Intellisense (only support MS-windows)
"--------------------------------------------------------------------------------
"{{{
" install intellisense to $VIM_INTELLISNESE 
" copy 'intellisense.vim' should go to $VIM\vimfiles\plugin\
" The vim files which are specific to file-types should go to the directory $VIM\vimfiles\ftplugin. (copy java_vis.vim and xml_vis.vim to $VIM\vimfiles\ftplugin)
"if has ('win32')
"let $VIM_INTELLISNESE="C:\Program Files (x86)\Vim\Intellisense"
"endif
"}}}

"================================================================================
" vimgrep (search pattern recursively for code debugging) --> instead of this, use (cscope and vim-ripgrep)
"--------------------------------------------------------------------------------
"{{{
"nnoremap <C-\> :silent vimgrep! /<c-r><c-w>/j **/*.{cpp,h,hpp,c} <bar> botright cwindow<CR>|                                           "** , starstar-wildcard is not working. I have no idea
"nnoremap <C-\> :silent vimgrep! /<c-r><c-w>/j */*.{cpp,h,hpp,c} */*/*.{cpp,h,hpp,c} */*/*/*.{cpp,h,hpp,c} <bar> botright cwindow<CR>|  "working but not good  -> use vim-ripgrep
"                                                                                                                                                                      ^^^^^^^^^^^
"" :silent     : do not prompt if warning/error message
"" :vimgrep!   : ! will abandon current buffer
"" **          : is not working, I don't know why. maybe gvim bug ? ( :help starstar-wildcard ) <-- ISSUE
""               max recursive dir depth < 100 (default is 30. use as like /usr/**30/*.c)
"" /pattern/j  : do not jump to first match
"" /pattern/g  : output multiple occurance for same line
"" /pattern\c/ : ignore case (default)
"" /pattern\C/ : do not ignore case
"" :botright cwindow : open quickfix window as bottom side full width
"}}}


"================================================================================
" Vim-Plug (Plugin-Manager)
"--------------------------------------------------------------------------------
" Install
"   install linux  : $ curl -fLo             ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   install windows: > curl -fLo %USERPROFILE%/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Vim-Plug Commands
"    :PlugInstall   [name...] [#threads]
"    :PlugUpdate    [name...] [#threads]
"    :PlugClean[!]   1.comment-out Plug line, 2.:source ~/_vimrc or restart vim, 3.PlugClean
"    :PlugUpgrade
"    :PlugStatus
"    :PlugDiff
"    :PlugSnapshot[!] [output_path]
call plug#begin('~/.vim/plugged')|                            "Specify a directory for plugins ( do not $VIMRUNTIME/plugin ), make sure you use single quotes
Plug 'xavierd/clang_complete'
Plug 'vim-scripts/AutoComplPop'
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf'
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/vim-easy-align'
Plug 'juehyun/multi_hl'
Plug 'juehyun/vim-find-everything'
Plug 'kien/ctrlp.vim'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'preservim/tagbar'
Plug 'preservim/nerdtree'
Plug 'juehyun/sidebar'
Plug 'preservim/nerdcommenter'
Plug 'tomasiser/vim-code-dark'
Plug 'bfrg/vim-cpp-modern'
Plug 'bfrg/vim-cpp-modern'
Plug 'salsifis/vim-transpose'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'terryma/vim-smooth-scroll'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}| "needs vim >= 8.1 or neovim, node.js, yarn
Plug 'sk1418/HowMuch'|                                        "visual selection and calculate
"Plug 'shushcat/vim-minimd'|                                  "markdown folding and showing outlines / not what I want
"Plug 'PhilRunninger/nerdtree-buffer-ops'|                    "no difference
"Plug 'vim-airline/vim-airline'|                              "disable vim-airline, too slow and too heavy, whenever open big file (~4Mbytes, C header file), it cause halt
"Plug 'vim-airline/vim-airline-themes'
"Plug 'tpope/vim-fugitive'|                                   "vim-airline needs fugitive to display git branch
"Plug 'vim-scripts/taglist-plus'
"Plug 'juehyun/bufexplorer'|                                  "Use ctrlp instead (CtrlPBuffer), bufexplorer is too slow
"Plug 'neoclide/coc.nvim', {'branch': 'release'}|             "conquer of completion
"Plug 'ycm-core/YouCompleteMe'
"Plug 'chrisbra/Colorizer'|                                   "too slow
"Plug 'voldikss/vim-find-everything'
"Plug 'skywind3000/quickmenu.vim'
"Plug 'jlanzarotta/bufexplorer'
"Plug 'MattesGroeger/vim-bookmarks' 
"Plug 'neoclide/coc.nvim', {'branch': 'release'}|             "conquer of completion
"Plug 'valloric/youcompleteme', { 'do': 'python3 ./install.py --clang-completer --go-completer --rust-completer --js-completer'}
"Plug 'https://github.com/junegunn/vim-github-dashboard.git'| "Any valid git URL is allowed
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'|         "Multiple Plug commands can be written in a single line using | separators
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }|        "Using a non-master branch
"Plug 'fatih/vim-go', { 'tag': '*' }|                         "Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
"Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }|    "Plugin options
"Plug '~/my-prototype-plugin'|                                "Unmanaged plugin (manually installed and updated)
call plug#end()

"================================================================================
" Vundle (Plugin-Manager)
"--------------------------------------------------------------------------------
"{{{
"Vundle ( the vim Plug-in Manager )
"  install linux  : $ git clone https://github.com/VundleVim/Vundle.vim.git      ~/.vim/bundle/Vundle.vim
"  install windows: > git clone https://github.com/VundleVim/Vundle.vim.git %HOME%/.vim/bundle/Vundle.vim
"Brief help
"  :PluginList       - lists configured plugins
"  :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
"  :PluginSearch foo - searches for foo; append `!` to refresh local cache
"  :PluginClean      - 1.comment-out Plugin line, 2.:source ~/_vimrc or restart vim, 3.PlugClean
"  :PluginUpdate     - simple delete the line (Plugin 'xxx/xxxx') and :PluginUpdate
"see :h vundle for more details or wiki for FAQ
"
"filetype off|                      "required
"set nocompatible|                  "required, be iMproved
"set rtp+=~/.vim/bundle/Vundle.vim| "set the runtime path to include Vundle and initialize
"call vundle#begin()
"Plugin 'VundleVim/Vundle.vim'
"
"Plugin 'scrooloose/nerdcommenter'
"
"call vundle#end()|                 "required
"filetype plugin indent on|         "required
"filetype plugin on|                "to ignore plugin indent changes, instead use this
"}}}


"================================================================================
" Vim plug-in configuration and command
"--------------------------------------------------------------------------------

" --------------------------------------------------------------------------------
" HowMuch ( https://github.com/sk1418/HowMuch )
" --------------------------------------------------------------------------------
" vis-selection, <Leader>?=         : append      ='answer'
" vis-selection, <Leader><Leader>?  : replace      'answer'
" vis-selection, <Leader>?s         : append       'answer', 'sum'
" vis-selection, <Leader><Leader>?s : append-below 'sum'
map  <Leader>cal          <Leader>?=<CR>
map  <Leader>sum          <Leader>?s<CR>
"map <Leader><Leader>cal  <Leader><Leader>?<CR>
"map <Leader><Leader>sum  <Leader><Leader>?s<CR>
"map <Leader>ca  yt=f=a<C-r>=<C-r>"<CR><Esc>| "calculate arithmetic expression

" --------------------------------------------------------------------------------
" ctrlp.vim (http://kien.github.io/ctrlp.vim/#installation)
" --------------------------------------------------------------------------------
":help ctrlp
":CtrlP <dir> or :CtrlP, :CtrlPBuffer, :CtrlPMixed
"let g:ctrlp_map = '<c-p>'
map <C-p> :CtrlP<CR>| "open file with CtrlP
"let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'|  "starting directory
let g:ctrlp_root_markers=['vimsession.lnx','vimsession.win','.vimsession','.vs','README.md','tags']| "root folder ancher
set wildignore+=*.o,*.a,*.so,*.swp,*.zip,*.exe,*.lib,.git
map <M-o> :CtrlPBuffer<CR>| "open buffer

"--------------------------------------------------------------------------------
" FZF (FuzzFinder)
"--------------------------------------------------------------------------------
map <C-o> :FZF<CR>| "map <expr> ; ':FZF ' . input(':FZF ') . '<CR>'
if has("win32")
let $FZF_DEFAULT_COMMAND='fd -H'| "respect .gitignore, .ignore
else
let $FZF_DEFAULT_COMMAND='fdfind -H'| "respect .gitignore, .ignore
endif

" tab    : mark multiple files
" enter  : open selected files in current window
" ctrl-t : open selected files in new tab
" ctrl-x : open selected files in horizontal splits
" ctrl-v : open selected files in vertical   splits
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
let g:fzf_action = {
	\ 'ctrl-q': function('s:build_quickfix_list'),
	\ 'ctrl-t': 'tab split',
	\ 'ctrl-s': 'split',
	\ 'ctrl-v': 'vsplit' }

" Color (refer: https://github.com/junegunn/fzf/blob/master/README-VIM.md , :help cterm-color)
let g:fzf_colors = {
	\ 'hl' : ['fg', 'FZFsearch'],
	\ 'hl+': ['fg', 'FZFsearch'],
	\ 'fg+': ['fg', 'FZFcursor'],
	\ 'bg+': ['bg', 'FZFcursor']
	\ }
" fzf popup color is from terminal setting 
" check 'ctermfg', 'ctermbg' of the highlight group )
" in windows, check ( colortool -c , colortool -s cmd-legacy , colortool -d cmd-legacy.ini )
" in linux  , check terminal color

" FZF on popup window (default)
"let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.6 } }

" FZF on quick-fix window
"let g:fzf_layout = { 'down': '30%' }
"autocmd! FileType fzf
"autocmd  FileType fzf set laststatus=0 noshowmode noruler
"  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

"------------
"ISSUE: fzf faild with 'Can not open /tmp/Vskjviw/1' message (I dont know what is this ?)
"------------
"set shell=/bin/tcsh shellredir=>&
"set shellredir=>%s\ 2>&1
"let $TMPDIR = $HOME."/tmp"

if has('linux')| "help feature-list
set shell=/bin/bash
endif

"--------------------------------------------------------------------------------
" bufexplorer
"--------------------------------------------------------------------------------
let g:bufExplorerSortBy='name'  | "number, name, fullpath, mru, extension
let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerFindActive=1
let g:bufExplorerShowRelativePath=1
map <Leader>be :ToggleBufExplorer<CR>

" --------------------------------------------------------------------------------
" vim-find-everything
" --------------------------------------------------------------------------------
let g:fe_es_exe          = get(g:, 'fe_es_exe', 'c:\Everything\es.exe')|                          "Define es.exe executable path
let g:fe_result_filter   = get(g:, 'fe_result_filter', {'vim':1, 'txt':1, 'c':1, 'h':1, 'py':1})| "Define only show these file types when everything return results.
let g:fe_es_options      = get(g:, 'fe_es_options', '')|                                          "Define es.exe option.
let g:fe_window_width    = get(g:, 'fe_window_width', 120)|                                       "Define result window width
let g:fe_window_height   = get(g:, 'fe_window_height', 50)|                                       "Define result window height
let g:fe_window_type     = get(g:, 'fe_window_type', 'popup')|                                    "Define result window type, either 'split' or 'popup'
let g:fe_default_loc     = get(g:, 'fe_default_loc', '.')

map <Leader>fe :FE<space>| "FE [pattern] : search pattern
map <Leader>ff :FE <C-R>=expand('<cword>')<CR><CR>| "FE [pattern] : search pattern
"map <Leader>ev :FET<CR>|  "FET          : show-up last search results in pop-up

"--------------------------------------------------------------------------------
" multi_hl (multiple highlight plugin)
"--------------------------------------------------------------------------------
" <Leader>hl       : enable, disable plugin
" <Leader>0 ... \9 : set a highlight
" <Leader>=        : set a hilight (use color circularly)
" <Leader>-        : clr a highligh 
" <Leader><C-l>    : clr all highligh 

map * :let @/='\<<C-R><C-W>\>'<CR>:set<space>hls<CR>|    "not jump to next,          caution, <bar> in front of comment when statement and comment are confused
"map <C-l> :let<space>@/=""<CR>|                         "<bar> means new statement, caution, <space> in front of <bar>
map <C-l> :noh<CR>|                                      "clear screen (clear highlight)

"--------------------------------------------------------------------------------
" quickmenu.vim
"--------------------------------------------------------------------------------
"map <F12>  :call quickmenu#toggle(0)<CR>
"let  g:quickmenu_options = "HL"|          "enable cursorline(L) and cmdline help(H)
"call g:quickmenu#reset()|                 "clear all the items
"call g:quickmenu#append('# Develop', '')| "text starting with '#' represents a section (see the screen capture below)
"call g:quickmenu#append('item 1.1', 'call GetSelection()'   , 'select item 1.1')
"call g:quickmenu#append('# Misc', '')
"call g:quickmenu#append('item 2.1', 'echo "2.1 is selected"', 'select item 2.1')

"--------------------------------------------------------------------------------
" vim-easy-align (use with 'vip' )
"--------------------------------------------------------------------------------
"..............................
" Interactive mode usage
"..............................
xmap <Leader>al <Plug>(EasyAlign)|     "start interactive mode, input <C-X> for regular expression
xmap <Leader>la <Plug>(LiveEasyAlign)| "start interactive mode, input <C-X> for regular expression
"xmap ga <Plug>(EasyAlign)
"nmap ga <Plug>(EasyAlign)
"
" pre-defined rule                       | regular expression
"--------------------------------------- | --------------------
" <Space> : 1st white space              | <C-X> : input reg. expr (e.g. /[;:]\+/ )
" =       : Operators (= == != += &&=)   |
" :       : JSON or YAML                 |
" .       : multi-line method chaining   |
" ,       : multi-line method arguments  |
" &       : LaTeX table (& \\)           |
" #       : Ruby, Python comments        |
" "       : Vim comments '"'             |
" |       : Table markdown               |
" see default rules : https://github.com/junegunn/vim-easy-align/blob/2.9.6/autoload/easy_align.vim#L32-L46
"
"..............................
" Command interface usage
"..............................
":EasyAlign[!] [N-th] DELIMITER_KEY [OPTIONS]|   "Using predefined rules
":EasyAlign[!] [N-th] /REGEXP/ [OPTIONS]|        "Using regular expression
"xmap <Leader>a/      :EasyAlign /// {'right_margin':0}<CR>| "C/C++ comments
"xmap <Leader>a<tab>  :EasyAlign * /	/ {'right_margin':0}<CR>| "C/C++ comments
xmap <Leader>a\|      :EasyAlign * /\|/ {'right_margin':1}<CR>
map  <Leader>a\|      mzvip:EasyAlign * /\|/ {'right_margin':1}<CR>'z| "save line position, select visual-inner-paragraph, markdown table alignment, restore line position
map  <Leader>a,       mzvip:EasyAlign * /,/ {'right_margin':1}<CR>'z
xmap <Leader>a<space> :s/ \( *\)/ /g<CR>| "remove multiple spaces

"..............................
" Options
"..............................
" Keystrokes 	 Description                        	 Equivalent command
" ---------- 	 ---------------------------------- 	 -------------------
" <Space>    	 Around 1st whitespaces             	 :'<,'>EasyAlign\
" 2<Space>   	 Around 2nd whitespaces             	 :'<,'>EasyAlign2\
" -<Space>   	 Around the last whitespaces        	 :'<,'>EasyAlign-\
" -2<Space>  	 Around the 2nd to last whitespaces 	 :'<,'>EasyAlign-2\
" :          	 Around 1st colon (key: value)      	 :'<,'>EasyAlign:
" <Right>:   	 Around 1st colon (key : value)     	 :'<,'>EasyAlign:>l1
" =          	 Around 1st operators with =        	 :'<,'>EasyAlign=
" 3=         	 Around 3rd operators with =        	 :'<,'>EasyAlign3=
" *=         	 Around all operators with =        	 :'<,'>EasyAlign*=
" **=        	 Left-right alternating around =    	 :'<,'>EasyAlign**=
" <Enter>=   	 Right alignment around 1st =       	 :'<,'>EasyAlign!=
" <Enter>**= 	 Right-left alternating around =    	 :'<,'>EasyAlign!**=

"..............................
" My configurations
"..............................
let g:easy_align_ignore_groups=[]|       "[], ['String'], ['Comment'], ['String', 'Comment']
let g:easy_align_delimiters = {
\ '/': { 'pattern':'//\+\|/\*\|\*/'     ,'delimiter_align':'l','ignore_groups':[], 'left_margin':1, 'right_margin':1 },
\ ']': { 'pattern':'[[\]]'              ,'left_margin':0      ,'right_margin':0    ,'stick_to_left':0 },
\ ')': { 'pattern':'[()]'               ,'left_margin':0      ,'right_margin':0    ,'stick_to_left':0 },
\ 'd': { 'pattern':' \(\S\+\s*[;=]\)\@=','left_margin':0      ,'right_margin':0 }
\ }

"--------------------------------------------------------------------------------
" Coc.nvim
"--------------------------------------------------------------------------------
":CocInfo
":CocInstall <extensions>| "install coc extension (refer https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions)
"(e.g.) :CocInstall  coc-clangd coc-python coc-texlab coc-python coc-powershell coc-html coc-java coc-json coc-eslint
":CocUninstall
":CocList

"--------------------------------------------------------------------------------
" clang_complete (amazing, no need of tag database)
"--------------------------------------------------------------------------------
"clang_complete can be configured to use the clang executable or the clang library.
"clang_complete uses the clang executable by default but the clang library will execute lot faster
"
"- using the clang executable, needs:
"	- clang must be installed in your system and be in the PATH
"	- do not set (let) g:clang_library_path to a path containing the libclang.so library
"- using the clang library     needs:
"	-python installed in your system
"	-vim must be built with python support (do :version and look for a +python/dyn or +python3/dyn entry)
"	-set (let) g:clang_library_path to the directory path where libclang.so is contained
"--------------------------------------------------------------------------------
" juehyun:
" has('python') and has('python3') can not check +python/dyn or +python3/dyn 
" gvim82 (from www.vim.org) is not python3 enabled (:echo has('python3') -> 0), even :version command shows "+python/dyn +python3/dyn"
" gvim82 (build by myself ) is     python3 enabled (:echo has('python3') -> 1)       :version command shows "+python/dyn +python3/dyn"
" gvim82 (build by myself ), clang_complete is not compatible with python3.9 (python3.8 is ok), i guess, the reason is that it wat built with python3.8
"--------------------------------------------------------------------------------
"let g:clang_library_path='/usr/lib/llvm-3.8/lib'|       "path to directory where library can be found (libclang.{dll,so,dylib}
"let g:clang_library_path='/usr/lib64/libclang.so.3.8'|  "or path directly to the library file
if has ('win32')| "help feature-list
"let g:clang_library_path='C:\Pgm\libclang_x64.dll'
let g:clang_library_path='C:\LLVM\bin\libclang.dll'
else
"let g:clang_library_path = '/usr/lib/x86_64-linux-gnu'
"let g:clang_library_path='/usr/lib/x86_64-linux-gnu/libclang.so.1'
"let g:clang_library_path='/usr/lib/x86_64-linux-gnu/libclang-9.so' | "ubuntu 20.04/hermes
let g:clang_library_path='/usr/local/lib/libclang.so'
endif

"clang_complete compiler options can be configured in a .clang_complete file in each project root
"example of .clang_complete file :
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"  -DDEBUG
"  -include ../config.h
"  -I../common
"  -I/usr/include/c++/4.5.3/
"  -I/usr/include/c++/4.5.3/x86_64-slackware-linux/
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
"clang_complete's default key-binding conflict with vim tags command
let g:clang_jumpto_declaration_key            = '<C-k>'| "def: <C-]>'
let g:clang_jumpto_declaration_in_preview_key = '<C-j>'| "def: <C-W>'
let g:clang_jumpto_back_key                   = '<C-h>'| "def: <C-T>'

" --------------------------------------------------------------------------------
" YouCompleteMe
" --------------------------------------------------------------------------------
" installation : (it will takes about 10 minutes)
" 1. install YCM using Vim plugin manager (plugged or Vundle)
" 2. sudo apt install build-essential cmake vim-nox python3-dev
" 3. sudo apt install mono-complete golang nodejs default-jdk npm
" 4. cd ~/.vim/bundle/YouCompleteMe
" 5. python3 install.py --all

"--------------------------------------------------------------------------------
" AutoComplPop
"--------------------------------------------------------------------------------
"au BufNewFile,BufRead,BufEnter *.py AcpDisable| "AutoComplPop conflict with KITE (Python Intellisense), disable AutoCompletePop for python file

hi PmenuSel ctermfg=white
hi PmenuSel ctermbg=black

"--------------------------------------------------------------------------------
" NERDcommenter
"--------------------------------------------------------------------------------
let g:NERDCreateDefaultMappings = 0|                                   "Create default mappings
let g:NERDSpaceDelims = 0|                                             "Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1|                                         "Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'|                                       "Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1|                                          "Set a language to use its alternate delimiters by default
"let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }| "Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '//' } }| "Add your own custom formats or override the defaults
let g:NERDCommentEmptyLines = 1|                                       "Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1|                                  "Enable trimming of trailing whitespace when uncommenting
let g:NERDToggleCheckAllLines = 1|                                     "Enable NERDCommenterToggle to check all selected lines is commented or not

map <Leader>nc <Plug>NERDCommenterToggle<CR>
"NERDCommenterComment
"NERDCommenterUncomment
"NERDCommenterInvert

"vmap <C-Sapce> :s/\%V./<Space>/g<CR>

"--------------------------------------------------------------------------------
" NERDTree
"--------------------------------------------------------------------------------
"NERDTreeFocus, NERDTree, NERDTreeToggle, NERDTreeFind, NERDTreeMirror

"--------------------------------------------------------------------------------
" Tagbar
"--------------------------------------------------------------------------------
"Tagbar, TagbarToggle, TagbarOpen, TagbarAutoClose, TagbarClose, ...

"--------------------------------------------------------------------------------
" Sidebar = NERDTree + Tagbar
"--------------------------------------------------------------------------------
"let g:sidebar_with_tagbar=0| "set to 0, sidebar without tagbar
map <Leader>sb :call<space>SidebarToggle()<CR>

function! Buffers()
	for w in range(1,bufnr('$'))
		if bufname(bufnr(w)) =~ 'NERD_tree' ||  bufname(bufnr(w)) =~ '__Tagbar__'
			echo 'O  ' . bufname(bufnr(w))
		else
			if bufname(bufnr(w)) != ''
			echo '.  ' . bufname(bufnr(w))
			endif
		endif
	endfor
endfunction
map <Leader>ls :call<space>Buffers()<CR>

"--------------------------------------------------------------------------------
" vim-bookmarks
"--------------------------------------------------------------------------------
"  Keys :
"    mm  :BookmarkToggle Add/remove bookmark at current line
"    mi  :BookmarkAnnotate <TEXT> Add/edit/remove annotation at current line
"    mn  :BookmarkNext Jump to next bookmark in buffer
"    mp  :BookmarkPrev Jump to previous bookmark in buffer
"    ma  :BookmarkShowAll Show all bookmarks (toggle)
"    mc  :BookmarkClear Clear bookmarks in current buffer only
"    mx  :BookmarkClearAll Clear bookmarks in all buffers
"    mkk :BookmarkMoveUp Move up bookmark at current line
"    mjj :BookmarkMoveDown Move down bookmark at current line
"        :BookmarkSave <FILE_PATH> Save all bookmarks to a file
"        :BookmarkLoad <FILE_PATH> Load bookmarks from a file

highlight BookmarkSign ctermbg=NONE ctermfg=160
highlight BookmarkLine ctermbg=194 ctermfg=NONE
"let g:bookmark_sign = '>>'
"let g:bookmark_annotation_sign = '??
let g:bookmark_sign = '%%'
let g:bookmark_annotation_sign = '$$'
let g:bookmark_highlight_lines = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

"--------------------------------------------------------------------------------
" taglist
"--------------------------------------------------------------------------------
map <Leader>tl :TlistToggle<CR>

"help taglist-command

" check ctags input argument fields
"   $ ctags --list-maps=all
"   $ ctags --list-kinds=all
"
" following lines override 'tlist_def_cpp_settings' in taglist.vim file ( .vim/bundle/taglist-plus/plugin/taglist-plus.vim )
let tlist_cpp_settings = 'c++;n:namespace;v:variable;d:macro;t:typedef;' . 
	                     \ 'c:class;g:enum;s:struct;u:union;f:function(Def);m:member;' .
	                     \ 'e:enumerator;p:prototype(Ref);x:external;r:regex;l:local'

let tlist_c_settings   = 'c;n:namespace;v:variable;d:macro;t:typedef;' . 
	                     \ 'c:class;g:enum;s:struct;u:union;f:function(Def);m:member;' .
	                     \ 'e:enumerator;p:prototype(Ref);x:external;l:local'

let Tlist_Compact_Format = 1
let Tlist_Auto_Open = 0|        "automatically open Tlist when open supported file type
let Tlist_Use_Right_Window = 0| "appear right side window

"--------------------------------------------------------------------------------
" AnsiEsc
"--------------------------------------------------------------------------------
map <Leader>ae :AnsiEsc<CR>

"--------------------------------------------------------------------------------
" Colorize (enable ANSI color escape code in Vim)
"--------------------------------------------------------------------------------
"map <Leader>x :ColorToggle<CR>

"--------------------------------------------------------------------------------
" vim-ripgrep
"--------------------------------------------------------------------------------
" usage:
"   :Rg <string|pattern>|  "Word under cursor will be searched if no argument is passed to Rg
" configuration:
"     setting             default                 details
"   -----------           ------------            ----------------------
"   g:rg_binary           rg                      path to rg
"   g:rg_format           %f:%l:%c:%m             value of grepformat
"   g:rg_command          g:rg_binary --vimgrep   search command
"   g:rg_highlight        false                   true if you want matches highlighted
"   g:rg_derive_root      false                   true if you want to find project root from cwd
"   g:rg_root_types       ['.git']                list of files/dir found in project root
"   g:rg_window_location  botright                quickfix window location
" misc:
"   :RgRoot Show root search dir

let g:rg_command = 'rg -w --vimgrep'

"--------------------------------------------------------------------------------
" Airline, fugitive (airline needs fugitive to display git branch)
"--------------------------------------------------------------------------------
" install Powerline font for special chars (e.g. triangle)
"$ sudo apt-get install fonts-powerline (recommended)
" or
"$ git clone https://github.com/powerline/fonts
"$ ./install.sh
let g:airline_powerline_fonts = 1| "without it, missing triangle icon

"let g:airline#extensions#tabline#enabled = 1| "display tabline all buffers when there's only one tab open
"let g:airline_statusline_ontop=1|             "status line on top side

"let g:airline_theme='powerlineish'| "same as :AirlineTheme powerlineish
"let g:airline_theme='simple'
let g:airline_theme='light'
"let g:airline_theme='dark'
"let g:airline_theme='molokai'

"let g:airline#extensions#default#layout = [
"	\ [ 'a', 'b', 'c' ],
"	\ [ 'x', 'y', 'z', 'error', 'warning' ]
"	\ ]

let g:airline#extensions#default#layout = [
	\ [ 'a', 'b', 'c' ],
	\ [ 'x', 'y', 'z' ]
	\ ]

"--------------------------------------------------------------------------------
" vim-cpp-modern ( Enhanced C/C++ syntax highlighting,'github.com/bfrg/vim-cpp-modern' )
"--------------------------------------------------------------------------------
let g:cpp_no_function_highlight = 0| "Disable function highlighting (affects both C and C++ files)
let g:cpp_attributes_highlight  = 1| "Enable highlighting of C++11 attributes
let g:cpp_member_highlight      = 1| "Highlight struct/class member variables (affects both C and C++ files)
let g:apo_simple_highlight      = 1| "Put all standard C and C++ keywords under Vim's highlight group  ' Statement' (affects both C and C++ files)

"--------------------------------------------------------------------------------
" vim-transpose (https://github.com/salsifis/vim-transpose )
"--------------------------------------------------------------------------------
let g:transpose_keepindent  = 1| "controls whether the plugin should detect indentation of the range. The :TransposeIndentToggle command will toggle this variable.
" Commands
":Transpose             (for character array transposition),
":TransposeWords        (for word array transposition),
":TransposeTab          (for tab-separated table transposition),
":TransposeCSV          (for general delimited text transposition), and
":TransposeInteractive  (for custom transposition).
":TransposeIndentToggle (command will toggle this variable.

map <Leader>tr :TransposeWords<CR>

"--------------------------------------------------------------------------------
" vim-visual-multi (a.k.a vim-multiple-cursors)
"--------------------------------------------------------------------------------
" visual block vs visual-multi-key  ??

"--------------------------------------------------------------------------------
" vim-smooth-scroll
"--------------------------------------------------------------------------------
"noremap <silent> <c-u> :call smooth_scroll#up  (&scroll,   0, 2)<CR>
"noremap <silent> <c-d> :call smooth_scroll#down(&scroll,   0, 2)<CR>
"noremap <silent> <c-b> :call smooth_scroll#up  (&scroll*2, 0, 4)<CR>
"noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

"--------------------------------------------------------------------------------
" markdown-preview
"--------------------------------------------------------------------------------
map <Leader>md <Plug>MarkdownPreview<CR>
"<Plug>MarkdownPreview
"<Plug>MarkdownPreviewStop
"<Plug>MarkdownPreviewToggle

let g:mkdp_auto_start = 0|             " def(0), set to 1, nvim will open the preview window after entering the markdown buffer
let g:mkdp_auto_close = 1|             " def(1), set to 1, the nvim will auto close current preview window when change from markdown buffer to another buffer
let g:mkdp_refresh_slow = 0|           " def(0), set to 1, the vim will refresh markdown when save the buffer or leave from insert mode, default 0 is auto refresh markdown as you edit or move the cursor
let g:mkdp_command_for_global = 0|     " def(0), set to 1, the MarkdownPreview command can be use for all files, by default it can be use in markdown file
let g:mkdp_open_to_the_world = 0|      " def(0), set to 1, preview server available to others in your network by default, the server listens on localhost (127.0.0.1)
let g:mkdp_open_ip = ''|               " def(''), use custom IP to open preview page useful when you work in remote vim and preview on local browser more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
let g:mkdp_browser = ''|               " def(''), specify browser to open preview page
let g:mkdp_echo_preview_url = 0|       " def(0), set to 1, echo preview page url in command line when open preview page
let g:mkdp_browserfunc = ''|           " def(''), a custom vim function name to open preview page this function will receive url as param
let g:mkdp_markdown_css = ''|          " use a custom markdown style must be absolute path like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_highlight_css = ''|         " use a custom highlight style must absolute path like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_port = ''|                  " use a custom port to start server or random for empty
let g:mkdp_page_title = '「${name}」'| " preview page title, ${name} will be replace with the file name
let g:mkdp_filetypes = ['markdown']|   " recognized filetypes these filetypes will have MarkdownPreview... commands

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }

"--------------------------------------------------------------------------------
" vim-code-dark, color scheme (refer ~/.vim/color/scheme.vim )
"--------------------------------------------------------------------------------
" :hi[ghlight] [default] {group-name} {key}={arg} ..
"
"  {group-name} : Comment, Visual, Constant, ... etc ( to see all,  :hi <enter> )
"
"  {key}={arg}  : see followings
"  + ------------------ | ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
"  |  normal termial    | color terminal                                             | GUI                                                                                                         |
"  |  (vt100, xterm)    | (MS-Win console, color-xterm, etc.,)                       |                                                                                                             |
"  |                    |  which has 'Co' termcap entry                              |                                                                                                             |
"  | ------------------ | ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
"  |  term={attr-list}  |  cterm={attr-list}, ctermfg={color-nr}, ctermbg={color-nr} | gui={attr-list}, font={font-name}, guifg={color-name}, guibg={color-name}, guisp={color-name} , sp: special |
"  + ------------------ | ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
"
"   attr-list   : comma separated list of followings, { bold, underline, undercurl, inverse (or reverse), italic, standout, nocombine, strikethrough }
"   color-nr    : 0 ~ 15 (in case of 16-color terminal)
"   color-name  : cterm colors : color number or one of following colors (:help cterm-colors,  refer : https://ss64.com/nt/syntax-ansi.html )
"             NR-16 | 0     | 1        | 2         | 3        | 4       | 5           | 6          | 7              | 8        | 9         | 10         | 11        | 12       | 13           | 14          | 15
"                   | Black | DarkBlue | DarkGreen | DarkCyan | DarkRed | DarkMagenta | Brown      | LightGray/Grey | DarkGray | Blue      | Green      | Cyan      | Red      | Magenta      | Yellow      | White
"                   |       |          |           |          |         |             | DarkYellow | Gray/Grey      | DarkGrey | LightBlue | LightGreen | LightCyan | LightRed | LightMagenta | LightYellow |
"             NR-8  | 0     | 4        | 2         | 6        | 1       | 5           | 3          | 7              | 0*       | 4*        | 2*         | 6*        | 1*       | 5*           | 3*          | 7*
"
"                 GUI colors : hex code (e.g. #982201 only for gui) or one of following colors
"                   | Black     | Blue      | Brown     | Cyan       | Gray         | Green    | Magenta Orange |
"                   | Purple    | Red       | SeaGreen  | SlateBlue  | Violet       | Yellow   | white          |
"                   | DarkBlue  | DarkCyan  | DarkGray  | DarkGreen  | DarkMagenta  | DarkRed  | DarkYellow     |
"                   | LightBlue | LightCyan | LightGray | LightGreen | LightMagenta | LightRed | LightYellow    |
"---------------------------------------------------------------------------------
" Color test and color utility
"---------------------------------------------------------------------------------
" :runtime syntax/colortest.vim
" cmd.exe> colortool.exe
" cmd.exe> color ..
"---------------------------------------------------------------------------------
set t_Co=256| "for terminal-vim, telling Vim that my terminal support 256 color
colorscheme codedark| " VSCode Dark+ scheme (fr plugin vim-code-dark), darkblue default delek desert elflord evening koehler morning murphy pablo peachpuff ron shine slate torte zellner
"---------------------------------------------------------------------------------
" Customization (Override some highlight group)
"---------------------------------------------------------------------------------
"hi clear
"set background=dark
"if exists("syntax_on")
"	syntax reset
"endif
"let g:colors_name = "juehyun"
"highlight Comment      ctermfg=lightgrey           guifg=lightgrey
"highlight Constant     ctermfg=6                   cterm=none                   guifg=#00ffff gui=none
"highlight Identifier   ctermfg=lightblue           guifg=lightblue
"highlight Statement    ctermfg=3                   cterm=bold                   guifg=#c0c000 gui=bold
"highlight PreProc      ctermfg=2                   guifg=#00ff00
"highlight Type         ctermfg=2                   guifg=#00c000
"highlight Special      ctermfg=12                  guifg=#aaaaaa
"highlight Error        ctermbg=9                   guibg=#ff0000
"highlight Todo         ctermfg=4                   ctermbg=3                    guifg=#000080 guibg=#c0c000
"highlight Directory    ctermfg=2                   guifg=#00c000
"highlight Normal                                                                 ctermfg=white ctermbg=darkgrey                         guifg=#ffffff guibg=#101010
"highlight Visual       term=reverse                cterm=reverse                gui=reverse
"highlight Pmenu        gui=reverse guifg=black guibg=white
"highlight incSearch    term=reverse,bold           cterm=reverse,bold           guifg=black   guibg=LightGreen
highlight  Search       term=reverse                                             ctermfg=black ctermbg=yellow                           guifg=black   guibg=#c0c000
highlight  VertSplit    term=bold                   cterm=bold                   ctermfg=green ctermbg=green                            guifg=grey    guibg=grey 
highlight  StatusLineNC term=underline              cterm=underline              ctermfg=green ctermbg=black gui=underline              guifg=Grey10  guibg=grey50
highlight  StatusLine   term=underline,bold,reverse cterm=underline,bold,reverse ctermfg=green ctermbg=black gui=underline,bold,reverse guifg=#FFC524 guibg=black
highlight  CursorLine   term=underline                                                         ctermbg=black                                          guibg=black
if has('multi_byte_ime')
"highlight  Cursor       guifg=NONE guibg=Green|  "English
highlight  CursorIM     guifg=NONE guibg=Purple| "Hangul (IME or XIM is on)
endif 
":help setting-tabline for terminal vim (for gvim, Tabline will be controlled by GTK therefore refer ~/.config/gtk-3.0/gtk.css for GUI)
highlight  TabLineFill  term=underline              cterm=underline              ctermfg=green ctermbg=black
highlight  TabLine      term=underline              cterm=underline              ctermfg=green ctermbg=black
highlight  TabLineSel   term=underline,bold,reverse cterm=underline,bold,reverse ctermfg=green ctermbg=black

highlight  FZFcursor ctermfg=0  ctermbg=8
highlight  FZFsearch ctermfg=11

function! ShowCtermColors()
if !has('gui_running')| "run on 'terminal' not on 'gui' (:set t_Co=256 )
	"create highlight groups for cterm
	for i in range(0,255)
	execute "highlight  colorTest".i." ctermfg=0 ctermbg=".i
	endfor
	"show highlight groups
	highlight
	"clear
	for i in range(0,255)
	execute "highlight clear colorTest".i
	endfor
else
	echo 'Should run on terminal vim, not on gui gvim'
endif
endfunction

"================================================================================
" Key Mapping
"--------------------------------------------------------------------------------
" vi mode : (n)ormal, (i)nsert, (v)isual, (c)ommand, (r)eplace,
"           (s)elect, e(x)-mode, (o)perator-pending, (t)erminal-job
"
"      COMMANDS                    MODES ~
":map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
":nmap  :nnoremap :nunmap    Normal
":vmap  :vnoremap :vunmap    Visual and Select
":smap  :snoremap :sunmap    Select
":xmap  :xnoremap :xunmap    Visual
":omap  :onoremap :ounmap    Operator-pending
":map!  :noremap! :unmap!    Insert and Command-line
":imap  :inoremap :iunmap    Insert
":lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
":cmap  :cnoremap :cunmap    Command-line
":tmap  :tnoremap :tunmap    Terminal-Job

"================================================================================
" Frequently Used Hot-Key ( use :command <key> or :map <key> to list key mappings )
"--------------------------------------------------------------------------------
" C-s C-p M-o C-o C-Wt C-]
" \] \gf \w=
" \xa \mks \cf \uf \nu \cb \fe \ff \al \la \nt \tb \sb \tr \md \ae \nc
" \h2d \h2b \d2h \d2b \b2h \b2d \cmp
" * <C-l>
" \0..\9 \= \- \<C-l>

"================================================================================
" User command definition
"--------------------------------------------------------------------------------
command! RemoveTab     %s/\([a-zA-Z0-9,_ ]\)\t\+/\1/g
command! SearchTab     /[a-zA-Z0-9 ]\t\+/
command! Dirx          source ~/.dirx|pwd
command! Header        0r<space>~/.header
command! Headermit     0r<space>~/.header_mit
command! TestHL        so $VIMRUNTIME/syntax/hitest.vim

map  <Leader>sv        :source<space>~/.vimrc<CR>
map  <Leader>vv        :e<space>~/.vimrc<CR>
map  <Leader>vc        :e<space>~/.cshrc<CR>
map  <Leader>va        :e<space>~/.alias<CR>

xmap <Leader>so        :sort!<space>/[0-9]*/<CR>
xmap <Leader>sn        :sort!<space>/[^0-9]*/<CR>| "sort, ignoring leading non-number chars

map  <Leader>xa :tabonly<CR>:only<CR>:bdelete<CR>| "close all other files
map  <Leader>cf /{<CR>zf%|             "create fold
map  <Leader>uf za|                    "unfold
map  <Leader>nu :set invnumber<CR>
"map <ESC> :q<CR>
"map <C-z> :set scb!<CR>
"map <F2> a<C-R>=strftime("%c")<CR><Esc>| "appends the current date and time after the cursor
map // :q<CR>|                    "use <C-w>c
"map <C-n> :set invnumber<CR>
"map a/   0f/500i<Space><Esc>080ldt/|     "align (instead of this, please use vim-easy-align plugin)

"Visual Studio Code
"--------------------------------------------------------------------------------
map  <C-,>          :e<space>~/.vimrc<CR>| "open settings (.vimrc)
map  <C-k><C-s>     :map<CR>|              "list key mappings
map  <C-z>          :undo<CR>|             "undo
map  <F12>          g<C-]>zz|              "jump to tag
map  <C-`>          :terminal<CR>|         "open terminal
map  <C-s>          :w<CR>|                "save file
map  <C-k>s         :wa!<CR>|              "save all files
map  <C-k>w         :windo bd<CR>|         "close current buffer in tab (:tabclose can not close last tab)
nmap <M-j>          :m .+1<CR>==|          "move (selected) line(s) up, down
nmap <M-Down>       :m .+1<CR>==
nmap <M-k>          :m .-2<CR>==
nmap <M-Up>         :m .-2<CR>==
imap <M-j> <Esc>    :m .+1<CR>==gi
imap <M-Down> <Esc> :m .+1<CR>==gi
imap <M-k> <Esc>    :m .-2<CR>==gi
imap <M-Up> <Esc>   :m .-2<CR>==gi
vmap <M-j>          :m '>+1<CR>gv=gv
vmap <M-Down>       :m '>+1<CR>gv=gv
vmap <M-k>          :m '<-2<CR>gv=gv
vmap <M-Up>         :m '<-2<CR>gv=gv

