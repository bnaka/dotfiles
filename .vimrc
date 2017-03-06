"
"	.vimrc
"	@author B.Naka
"

"---------------------------------------------------------------------------------------
" 基本設定関連
"---------------------------------------------------------------------------------------

"ソースコードのハイライト
syntax on

"color
set t_Co=256

"インデント自動化
set autoindent

"タブスペース
set tabstop=4
set shiftwidth=4

"括弧の対応表示
set showmatch

"括弧を入力した時にカーソルが移動しないように設定
set matchtime=0

"実行中のコマンド表示
set showcmd

"インクリメントサーチ
set incsearch
set hlsearch

"他で書き換えられたら自動で読み直す
set autoread

"バックアップ
set backup
set backupdir=$HOME/.vimtmp

"hidden bufferになった際にundo等の情報が消えてしまうのを抑える
set hidden

"ウィンドウの大きさ
set winwidth=105
set winheight=50
set winminwidth=10
set winminheight=3

"プレビューウィンドウの大きさ
set pvh=70

"スクロールoffset
set scrolloff=3

"長い行で折り返さない
set textwidth=0

" 辞書ファイルからの単語補間
set complete+=k

" putty mouse
set mouse=a
set ttymouse=xterm2

" 先頭が0でも10進数として扱う
set nrformats-=octal

" コメント行で改行したらコメントを自動挿入をoff
set formatoptions-=ro

" クリップボード共有
if has("clipboard")
	set clipboard+=unnamed,autoselect
endif
 
" クリップボード共有
if has("clipboard")
	set clipboard+=unnamed,autoselect
endif

" shell の設定
if has('win95') || has('win16') || has('win32')
	set shell=C:\WINDOWS\system32\cmd.exe
endif

"---------------------------------------------------------------------------------------
" 表示関連
"---------------------------------------------------------------------------------------

"行数表示
set number

"１行が長い際に@で省略させない
set display=lastline

"タブラインを常に表示
set showtabline=2

" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
"set wildmenu
" コマンドライン補間をシェルっぽく
set wildmode=list:longest

"ステータスラインに関して
" from id:secondlife(はてな勉強会) http://hatena.g.hatena.ne.jp/hatenatech/20060515/1147682761

"ステータスラインを常に表示
set laststatus=2

" カーソル位置のアスキーコード取得
function! GetB()"{{{
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction"}}}
" :help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)"{{{
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc"}}}
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)"{{{
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc"}}}

func! GetEnc()"{{{
	let out_e = &fenc!='' ? &fenc : &enc
	let out_b = &bomb ? '[BOM]' : ''
	return out_e . out_b
endfunction"}}}

"ステータスラインに文字コードと改行文字を表示する"{{{
" %F%だとpathを全部表示するんだけど、きもちわるいので常に%f%で
" => airlineに移行
" set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']['.&ft.']'}\ %F%=%l,%c%V%8P
" set statusline=%<[%n]%m%r\ %f%=[%{GetB()}]\ %l,%c%V%6P%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%{&bomb?'[BOM]':'[]'}%y

"if winwidth(0) >= 120
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
"else
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
"endif

"set statusline=%{GetB()}"}}}

" 補完候補の色づけ for vim7
hi Pmenu term=bold cterm=reverse ctermbg=7
"hi PmenuSel ctermbg=12
"hi PmenuSbar ctermbg=0

"showmatchの色も見辛いので変更
hi MatchParen cterm=bold ctermbg=8

"diff時にテキストが赤いので見えないから変更
hi DiffText cterm=bold ctermfg=7 ctermbg=darkred gui=bold guibg=Red


"---------------------------------------------------------------------------------------
" phpオプション設定
"---------------------------------------------------------------------------------------
let php_sql_query = 1
let php_baselib = 1
let php_htmlInStrings = 1
let php_noShortTags = 1
let php_parent_error_close = 1

let g:sql_type_default='mysql'

"---------------------------------------------------------------------------------------
" オプション設定
"---------------------------------------------------------------------------------------

"tagsファイルの指定"{{{
" from id:secondlife
"if has("autochdir")
"  set autochdir
"  set tags=tags;
"else
"  set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags,../*/tags,../*/*/tags
"endif"}}}

"---------------------------------------------------------------------------------------
" au
"---------------------------------------------------------------------------------------

augroup MyAu"{{{

	" リセット
	autocmd!

augroup END"}}}

"カレントディレクトリの移動
au MyAu BufEnter *.nut,*.sh,*.conf,*.log,*.vim,*.txt,*.c,*.cpp,*.cc,*.h,*.hpp,*.inc,*.tpp,*.pl,*.py,*.php,*.rb,*.erb,*.js,*.css,*.html,*.phtml,*.xml,*.xsl,*.sql,*.ddl,*.csv,*.tmpl,*.script,*.as,*.tpl,*.ctp,*.cs,*.json,*.ini,*.mk,*.md,[A-Z]*file execute ":lcd " . expand("%:p:h")

" 前回終了したカーソル行に移動
au MyAu BufReadPost * if !&diff && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" :grep や :make の実行後、自動的に QuickFix ウィンドウを開く(http://vimwiki.net/?tips)
au MyAu QuickfixCmdPost make,grep,grepadd,vimgrep copen
au MyAu QuickfixCmdPost l* lopen

" 拡張cppファイル認識
au MyAu BufNewFile,BufRead *.inc,*.tpp set filetype=cpp
" actionscriptファイル認識
au MyAu BufNewFile,BufRead *.as set filetype=actionscript
" genshiファイル認識
au MyAu BufNewFile,BufRead *.tmpl set filetype=textgenshi
" capfile ファイル認識
au MyAu BufNewFile,BufRead Capfile,capfile set filetype=ruby
" ddl ファイル認識
au MyAu BufNewFile,BufRead *.ddl set filetype=sql

" sqlの際は行の折り返しをしない
"au MyAu FileType sql :set nowrap

" svnファイルはutf-8で開く
au MyAu FileType svn setlocal fenc=utf-8

" gitcommit時に自動でDiffGitCachedを呼ぶ
au MyAu FileType gitcommit nmap <buffer> di :DiffGitCached\|wincmd J<CR>
au MyAu FileType gitcommit setlocal winheight=50
au MyAu FileType gitcommit setlocal fenc=utf-8

" xmlファイル開いたら自動で整形
command! Prettify :%s/></>\r</g | filetype indent on | setf xml | normal gg=G
au MyAu FileType xml nmap <buffer> <space>= :Prettify<CR>


"---------------------------------------------------------------------------------------
" key-mapping
"---------------------------------------------------------------------------------------

" 行末までヤンク
nnoremap Y y$

"wrapした行内の移動
vmap j gj
vmap k gk
nmap j gj
nmap k gk

"使いやすいキー配置
"noremap z $
"noremap 0 _
vmap f :fold

" .vimrcを再読み込み
nmap <Space>v :source $HOME/.vimrc<CR>

" 適当なショートカット
nnoremap <Space>: :noh<CR>
nmap <Space>w :w<CR>
nmap <Space>d :diffthis<CR>
nmap <Space>c :q<CR>

"カーソル位置の単語検索
nmap <C-g><C-w> :grep "<C-R><C-W>" *.c *.cpp */*.cpp *.h */*.h *.hpp *.php *.rb *.html *.js *.as *.sql *.ddl *.csv *.xml *.txt *.nut *.sh<CR>
nmap <C-g><C-a> :grep "<C-R><C-A>" *.c *.cpp */*.cpp *.h */*.h *.hpp *.php *.rb *.html *.js *.as *.sql *.ddl *.csv *.xml *.txt *.nut *.sh<CR>
nmap <C-g><C-i> :grep "<C-R>/" *.c *.cpp */*.cpp *.h */*.h *.hpp *.php *.rb *.html *.js *.as *.sql *.ddl *.csv *.xml *.txt *.nut *.sh<CR>
nmap <C-n> :cn<CR>
nmap <C-p> :cp<CR>

" command mode 時 tcsh風のキーバインドに
" from id:secondlife
cmap <C-A> <Home>
cmap <C-F> <Right>
cmap <C-B> <Left>
cmap <C-D> <Delete>
cmap <Esc>b <S-Left>

" forなどのブロックを選択(http://vimwiki.net/?tips)
nnoremap vb /{<CR>:noh<CR>%v%0

" (を挿入した際にオート関数定義表示
"inoremap ( <Esc>mzh:silent! ptag <C-r><C-w><CR>`za(
"nnoremap <Space>p mz:silent! ptag <C-r><C-w><CR>`z

" vimdiff用
if &diff
	nmap <C-p> [c
	nmap <C-n> ]c
	nmap <C-h> do
	nmap <BS>  do
	nmap <C-l> dp
endif

" 縦に並んだ数値を連番にする
nnoremap <silent> ,co :ContinuousNumber <C-a><CR>
vnoremap <silent> ,co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor

" ファイルを開いたときからの差を見る(http://vimwiki.net/?tips)
command! DiffOrig vert new | set bt=nofile
\ | r # | 0d_ | diffthis
\ | wincmd p | diffthis


"---------------------------------------------------------------------------------------
" 文字コード関連
"---------------------------------------------------------------------------------------

" 文字コードの自動認識"{{{
" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
	let s:enc_euc = 'eucjp-ms'
	let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
	let s:enc_euc = 'euc-jisx0213'
	let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
	let s:fileencodings_default = &fileencodings
	let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
	let &fileencodings = &fileencodings .','. s:fileencodings_default
	unlet s:fileencodings_default
  else
	let &fileencodings = &fileencodings .','. s:enc_jis
	set fileencodings+=utf-8,ucs-2le,ucs-2
	if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
	  set fileencodings+=cp932
	  set fileencodings-=euc-jp
	  set fileencodings-=euc-jisx0213
	  set fileencodings-=eucjp-ms
	  let &encoding = s:enc_euc
	  let &fileencoding = s:enc_euc
	else
	  let &fileencodings = &fileencodings .','. s:enc_euc
	endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif"}}}

" UTF-8の□や○でカーソル位置がずれないようにする
if exists("&ambiwidth")
	set ambiwidth=double
endif

" 改行コードの自動認識
set fileformats=unix,dos,mac

" utf-8で開きなおすことが多いので
nnoremap <Space>8 :e ++enc=utf-8<CR>
nnoremap <Space>1 :e ++enc=iso-2022-jp-3<CR>


"---------------------------------------------------------------------------------------
" 自作関数
"---------------------------------------------------------------------------------------

" 書き込んだ際にコンパイル"{{{
"function! WriteTest()
"	cclose
"	make
"	redr
"endfunction
"au! BufWritePost *.[ch],*.[ch]pp nested call WriteTest()
"}}}

" カーソルが止まった時の処理"{{{
"function! CursorHoldCall()
"	set updatetime=500
"
"	"プレビュー
"    if has("PreviewWord")
"        call PreviewWord()
"    endif
"	"ファイル保存
"    if has("AutoUp")
"		call AutoUp()
"    endif
"endfunction
"}}}

"CursorHoldが一個しか定義できないので関数をcall"{{{
"au! CursorHold *.[ch],*.cpp,*.php nested call CursorHoldCall()
"let g:svbfre = '.\+'
"}}}

"augroup vimrc-auto-cursorline"{{{
"	autocmd!
"	autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
"	autocmd CursorHold,CursorHoldI * setlocal cursorline
"augroup END
"}}}

" .hと.hppを新規で開いた場合に#ifdef - #endifを挿入する
function! IncludeGuard()"{{{
   let fl = getline(1)
   if fl =~ "^#if"
       return
   endif
   "let gatename = "__" . substitute(toupper(expand("%:t")), "\\.", "_", "g")
   let gatename = substitute(expand("%:t"), "\\.", "_", "g") . "__"
   normal! gg
   execute "normal! i#ifndef " . gatename . ""
   execute "normal! o#define " . gatename .  "\<CR>\<CR>\<CR>\<CR>\<CR>"
   execute "normal! Go#endif   /* " . gatename . " */"
   4
endfunction"}}}
au MyAu BufNewFile *.h,*.hpp call IncludeGuard()

" cプリプロセッサにかける(http://vimwiki.net/?tips)
function! CppRegion()"{{{
	let beginmark='---beginning_of_cpp_region'
	let endmark='---end_of_cpp_region'
	exe a:firstline . "," . a:lastline ."!sed -e '" . a:firstline . "i\\\\" . nr2char(10) . beginmark . "' -e '" . a:lastline . "a\\\\".nr2char(10).endmark."' " .expand("%") . "|cpp -C|sed -ne '/" . beginmark . "/,/" .endmark . "/p'"
endfunction"}}}

" カレントバッファを#!で指定したプログラムで実行(http://vimwiki.net/?tips)
function! ShebangExecute()"{{{
	let m = matchlist(getline(1), '#!\(.*\)')
	if(len(m) > 2)
		execute '!'. m[1] . ' %'
	else
		execute '!' &ft ' %'
	endif
endfunction"}}}
nmap <Space>g :call ShebangExecute()<CR>

" カレントバッファを.oにてmake
function! MakeExcute()"{{{
	execute 'make ' expand("%:r") '.o'
endfunction"}}}
nmap <Space>o :call MakeExcute()<CR>

" csvの指定列をハイライト
function! CSVH(x)"{{{
	execute 'match Keyword /^\([^,]*,\)\{'.a:x.'}\zs[^,]*/'
	execute 'normal ^'.a:x.'f,'
endfunction"}}}
command! -nargs=1 Csv :call CSVH(<args>)

" 実行した内容をPrevieWindowに表示
function! PreviewWindowExecute()"{{{
	let m = matchlist(getline(1), '#!\(.*\)')
	let src = expand("%")
	" pwin表示
	setlocal pvh=40
	silent execute ":pedit! Execute"
	" pwin移動
	wincmd P
	" set options
	setlocal buftype=nofile
	setlocal noswapfile
	setlocal syntax=none
	setlocal bufhidden=delete
	" output
	if(len(m) > 2)
		silent execute ':%!'. m[1] . ' ' . src '2>&1'
	else
		silent execute ':%!'. &ft . ' ' . src '2>&1'
	endif
	" pwin脱出
	wincmd p
endfunction"}}}
nmap <Space>g :call PreviewWindowExecute()<CR>

" 実行した内容をQuickFixに表示
function! QuickFixPreview(file)"{{{
	let msg = ''
	redir => msg
	redir END

	let lnum = 0
	let err = []
	for l in split(msg, "\n")
		let lnum += 1
		let entry = {'filename': a:file, 'lnum': lnum, 'text': l}
		call add(err, entry)
		unlet entry
	endfor
	call setqflist(err, 'r')
	cwindow
	silent! doautocmd QuickFixCmdPost make
endfunction"}}}

" 選択した領域をecho
function! VisualEcho()"{{{
	let pos = getpos(".")

	normal `<
	echo line(".")
	echo col(".")
	"# => 選択開始位置を出力

	normal `>
	echo line(".")
	echo col(".")
	"# => 選択終了位置を出力

	call setpos('.', pos)
endfunction"}}}


"---------------------------------------------------------------------------------------
" plugin
"---------------------------------------------------------------------------------------

" doxygencommenter.vim設定
" jcommenter.vimをdoxygen形式に改造
"-------------------------
au MyAu FileType c,cpp map <Space>/ :call DoxygenCommentWriter()<CR>
au MyAu FileType c,cpp vmap <Space>/ :Align //!<<CR>
let g:doxycommenter_file_author = "B.Naka"
nnoremap <Space>,, f)l<S-D>:call DoxygenCommentWriter()<CR><ESC><ESC>p0f;df<Space>2jo{<CR>}<ESC>k

" NeoBundle.vim
"-------------------------
" setup neobundle
" $ mkdir -p $HOME/.vim/bundle
" $ git clone git://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim

" プラグインの読み込み
if !executable("git")
	echo "Please install git."
	finish
endif

" プラグインのインストールディレクトリ
let s:neobundle_plugins_dir = expand(exists("$VIM_NEOBUNDLE_PLUGIN_DIR") ? $VIM_NEOBUNDLE_PLUGIN_DIR : '~/.vim/bundle')

if !isdirectory(s:neobundle_plugins_dir . "/neobundle.vim")
	echo "Please install neobundle.vim."
	function! s:install_neobundle()
		if input("Install neobundle.vim? [Y/N] : ") =="Y"
			if !isdirectory(s:neobundle_plugins_dir)
				call mkdir(s:neobundle_plugins_dir, "p")
			endif

			execute "!git clone git://github.com/Shougo/neobundle.vim "
			\ . s:neobundle_plugins_dir . "/neobundle.vim"
			echo "neobundle installed. Please restart vim."
		else
			echo "Canceled."
		endif
	endfunction
	augroup install-neobundle
		autocmd!
		autocmd VimEnter * call s:install_neobundle()
	augroup END
	finish
endif

" proxy
let g:neobundle_default_git_protocol='https'

if has('vim_starting')
	if &compatible
		set nocompatible               " Be iMproved
	endif

	" Required:
	execute "set runtimepath+=" . s:neobundle_plugins_dir . "/neobundle.vim"
endif

" Required:
call neobundle#begin(expand(s:neobundle_plugins_dir))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell $HOME/.vim/bundle/vimproc, (n,g)make -f
" your_machines_makefile

if !has("kaoriya")
	NeoBundle 'Shougo/vimproc.vim', {
		\ 'build' : {
		\ 'windows' : 'make -f make_mingw32.mak',
		\ 'cygwin' : 'make -f make_cygwin.mak',
		\ 'mac' : 'make -f make_mac.mak',
		\ 'unix' : 'make -f make_unix.mak',
		\ },
	\ }
endif

 " My Bundles here:
 " Refer to |:NeoBundle-examples|.
 " Note: You don't set neobundle setting in .gvimrc!
" My Bundle {{{
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/unite-build'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'ujihisa/unite-locate'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'osyo-manga/unite-quickfix'
"NeoBundle 'osyo-manga/unite-airline_themes'
NeoBundle 'kmnk/vim-unite-svn'
NeoBundle 'heavenshell/unite-zf'

NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/neoinclude.vim'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/context_filetype.vim'

NeoBundle 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundle 'dannyob/quickfixstatus'
NeoBundle 'cohama/vim-hier'

NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/vdbi-vim'
NeoBundle 'mattn/excelview-vim'

NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-splash'
"NeoBundle 'thinca/vim-singleton'
NeoBundle 'thinca/vim-localrc'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'thinca/vim-qfreplace'

NeoBundle 'kana/vim-submode'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'osyo-manga/vim-textobj-multiblock'
NeoBundle 'osyo-manga/vim-textobj-blockwise'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'kana/vim-smartinput'
NeoBundle 'cohama/vim-smartinput-endwise'
NeoBundle 'kana/vim-altr'
NeoBundle 'tpope/vim-surround'
NeoBundle 'haya14busa/vim-metarepeat'

NeoBundle 'tyru/capture.vim'
"NeoBundle 'tyru/caw.vim'
NeoBundle 'tyru/current-func-info.vim'

NeoBundle 'osyo-manga/vim-precious'
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'osyo-manga/vim-automatic'
NeoBundle 'osyo-manga/vim-fancy'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'osyo-manga/vim-stargate'
NeoBundle 'osyo-manga/vim-marching'
NeoBundle 'osyo-manga/vim-operator-blockwise'

NeoBundle 't9md/vim-quickhl'
NeoBundle 't9md/vim-choosewin'

"NeoBundle 'alpaca-tc/alpaca_powertabline'
NeoBundle 'powerline/powerline', { 'rtp' : 'powerline/bindings/vim/'}
"NeoBundle 'bling/vim-airline'
NeoBundle 'itchyny/lightline.vim'

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'gregsexton/gitv'
NeoBundle 'idanarye/vim-merginal'
NeoBundle 'rhysd/committia.vim'
NeoBundle 'cohama/agit.vim'

NeoBundle 'juneedahamed/vc.vim'

NeoBundleLazy 'OmniSharp/omnisharp-vim', {
\   'autoload': { 'filetypes': [ 'cs', 'csi', 'csx' ] },
\   'build': {
\     'windows' : 'msbuild server/OmniSharp.sln',
\     'mac': 'xbuild server/OmniSharp.sln',
\     'unix': 'xbuild server/OmniSharp.sln',
\   },
\ }
"NeoBundleLazy 'OrangeT/vim-csharp', { 'autoload': { 'filetypes': [ 'cs', 'csi', 'csx' ] } }
NeoBundleLazy 'scrooloose/syntastic', { 'autoload': { 'filetypes': [ 'cs', 'csi', 'csx', 'javascript', 'c', 'cpp' ] } }
NeoBundle 'tpope/vim-dispatch'

"NeoBundle 'Rip-Rip/clang_complete'
NeoBundle 'justmao945/vim-clang'
NeoBundle 'osyo-manga/vim-snowdrop'
NeoBundleLazy 'vim-jp/cpp-vim', { 'autoload': { 'filetypes' : [ 'c', 'cpp' ]}}

"NeoBundle 'kien/ctrlp.vim'
NeoBundle 'glidenote/memolist.vim'
NeoBundle 'modsound/gips-vim'
"NeoBundle 'othree/eregex.vim'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'rhysd/clever-f.vim'
"NeoBundle 'supermomonga/vimshell-kawaii'
NeoBundle 'gregsexton/VimCalc'
"NeoBundle 'yonchu/accelerated-smooth-scroll'
NeoBundle 'deris/vim-rengbang'
NeoBundle 'LeafCage/yankround.vim'
NeoBundle 'terryma/vim-expand-region'
NeoBundle 'AndrewRadev/linediff.vim'
NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'mhinz/vim-signify'
NeoBundle 'itchyny/calendar.vim'
NeoBundle 'cocopon/colorswatch.vim'
NeoBundle 'dyng/ctrlsf.vim'
NeoBundle 'gcmt/wildfire.vim'
"NeoBundle 'rbtnn/rabbit-ui.vim'
"NeoBundle 'jaxbot/semantic-highlight.vim'
NeoBundle 'szw/vim-tags' 
"NeoBundle 'haya14busa/incsearch.vim'
NeoBundle 'shawncplus/phpcomplete.vim'
NeoBundle "aklt/plantuml-syntax"

NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'vim-scripts/Align'
"NeoBundle 'vim-scripts/YankRing.vim' => yankround.vim
"NeoBundle 'vim-scripts/a.vim' => vim-altr
NeoBundle 'vim-scripts/vcscommand.vim'
NeoBundle 'vim-scripts/OmniCppComplete'
NeoBundle 'vim-scripts/svn-diff.vim'
NeoBundle 'vim-scripts/textgenshi.vim'
" }}}

call neobundle#end()

" Required:
filetype plugin indent on
syntax enable

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" unite.vim"{{{
"-------------------------
if neobundle#is_installed('unite.vim')
	" 入力モードで開始する
	let g:unite_enable_start_insert=1
	" 表示場所
	let g:unite_split_rule="lefta"
	" file_mru表示数
	let g:unite_source_file_mru_limit=3000

	" バッファ一覧
	nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
	" ファイル一覧
	nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
	" レジスタ一覧
	nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
	" 最近使用したファイル一覧
	nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
	" 常用セット
	nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
	" 全部乗せ
	nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

	" ショートカット
	nmap <silent> <Space>f :silent! Unite -default-action=split buffer file_mru<CR>
	nmap <silent> <Space>b :silent! Unite window<CR>
	nmap <silent> <Space>e :silent! UniteWithBufferDir file_mru<CR>
	"nmap <silent> <Space>s :silent! UniteWithBufferDir -default-action=split file_mru<CR>

	" fuzzy match
	call unite#custom#source('file,file/new,buffer,file_rec,file_mru,tag,tag/include,window', 'matchers', 'matcher_fuzzy')

	" ウィンドウを分割して開く
	au MyAu FileType unite nnoremap <silent> <buffer> <expr> <C-w>S unite#do_action('split')
	au MyAu FileType unite inoremap <silent> <buffer> <expr> <C-w>S unite#do_action('split')
	" ウィンドウを縦に分割して開く
	au MyAu FileType unite nnoremap <silent> <buffer> <expr> <C-w>V unite#do_action('vsplit')
	au MyAu FileType unite inoremap <silent> <buffer> <expr> <C-w>V unite#do_action('vsplit')
	" ESCキーを2回押すと終了する
	au MyAu FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
	au MyAu FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

	" ファイル内検索
	nnoremap <silent> ,/ :<C-u>Unite -buffer-name=search line/fast -start-insert -no-quit<CR>

	" Uniteウィンドウを消す
	nnoremap <silent> ,uc :<C-u>UniteClose default<CR>
endif
"}}}

" unite-build"{{{
"-------------------------
if neobundle#is_installed('unite-build')
	"nnoremap <silent> ,ub :<C-u>Unite build<CR><ESC><C-w>p
endif
"}}}

" unite-outline"{{{
"-------------------------
if neobundle#is_installed('unite-outline')
	nnoremap <silent> ,uo :<C-u>Unite outline<CR>
endif
"}}}

" unite-tag"{{{
"-------------------------
if neobundle#is_installed('unite-tag')
	nnoremap <silent> g<C-]> :<C-u>execute "Unite tag/include:".expand('<cword>')<CR>

	" ショートカット
	nmap <silent> <Space>t :silent! Unite -default-action=split tag<CR>
endif
"}}}

" vim-unite-svn"{{{
"-------------------------
if neobundle#is_installed('vim-unite-svn')
	nnoremap <silent> ,us :<C-u>Unite svn/status<CR>
endif
"}}}

" neocomplcache"{{{
"-------------------------
if neobundle#is_installed('neocomplcache')
	" 補完ウィンドウの設定
	set completeopt=menuone

	" 起動時に有効化
	let g:neocomplcache_enable_at_startup = 1

	" 大文字が入力されるまで大文字小文字の区別を無視する
	"let g:neocomplcache_enable_smart_case = 1

	" _(アンダースコア)区切りの補完を有効化
	"let g:neocomplcache_enable_underbar_completion = 1
	"let g:neocomplcache_enable_camel_case_completion  =  1

	" ポップアップメニューで表示される候補の数
	let g:neocomplcache_max_list = 20

	" シンタックスをキャッシュするときの最小文字長
	let g:neocomplcache_min_syntax_length = 3

	" ディクショナリ定義
	let g:neocomplcache_dictionary_filetype_lists = {
	\ 'default' : '',
	\ 'php' : $HOME . '/.vim/dict/php.dict',
	\ 'ctp' : $HOME . '/.vim/dict/php.dict'
	\ }

	"if !exists('g:neocomplcache_keyword_patterns')
	"  let g:neocomplcache_keyword_patterns = {}
	"endif
	"let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

	" スニペットを展開する。スニペットが関係しないところでは行末まで削除
	"imap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-o>D"
	"smap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-o>D"

	" 前回行われた補完をキャンセルします
	inoremap <expr><C-g> neocomplcache#undo_completion()

	" 補完候補のなかから、共通する部分を補完します
	inoremap <expr><C-l> neocomplcache#complete_common_string()

	" 改行で補完ウィンドウを閉じる
	"inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"

	"tabで補完候補の選択を行う
	inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
	inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

	" <C-h>や<BS>を押したときに確実にポップアップを削除します
	"inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
	"inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"

	" 現在選択している候補を確定します
	inoremap <expr><C-y> neocomplcache#close_popup()

	" 現在選択している候補をキャンセルし、ポップアップを閉じます
	inoremap <expr><C-e> neocomplcache#cancel_popup()

	" clang_completeを有効化
	let g:neocomplcache_force_overwrite_completefunc=1

	" 現在のバッファのタグファイルを生成する
	" neocomplcache が作成した tag ファイルのパスを tags に追加する
	function! g:TagsUpdate()
		" include している tag ファイルが毎回同じとは限らないので毎回初期化
		setlocal tags=
		for filename in neocomplcache#sources#include_complete#get_include_files(bufnr('%'))
			execute "setlocal tags+=".neocomplcache#cache#encode_name('tags_output', filename)
		endfor
	endfunction
	au MyAu BufRead *.cpp,*.h call g:TagsUpdate()
endif
"}}}

" neocomplete"{{{
"-------------------------
if neobundle#is_installed('neocomplete')
	" 補完ウィンドウの設定
	set completeopt=menuone

	" Disable AutoComplPop.
	let g:acp_enableAtStartup = 0

	" 起動時に有効化
	let g:neocomplete#enable_at_startup = 1

	" Use smartcase.
	let g:neocomplete#enable_ignore_case = 1
	let g:neocomplete#enable_smart_case = 1

	" minimum
	let g:neocomplete#sources#syntax#min_keyword_length = 3

	" Define keyword.
	if !exists('g:neocomplete#keyword_patterns')
	    let g:neocomplete#keyword_patterns = {}
	endif
	let g:neocomplete#keyword_patterns['default'] = '\h\w*'

	if !exists('g:neocomplete#sources#dictionary#dictionaries')
	  let g:neocomplete#sources#dictionary#dictionaries = {}
	endif
	let dict = g:neocomplete#sources#dictionary#dictionaries

	" 補完しないバッファ
	let g:neocomplete#sources#buffer#disabled_pattern = '\.log\|\.log\.\|\.jax\|Log.txt'

	"tabで補完候補の選択を行う
	inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
	inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

	" Plugin key-mappings.
	inoremap <expr><C-g>     neocomplete#undo_completion()
	inoremap <expr><C-l>     neocomplete#complete_common_string()

	" <C-h>, <BS>: close popup and delete backword char.
	inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
	inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
	inoremap <expr><C-y>  neocomplete#close_popup()
	inoremap <expr><C-e>  neocomplete#cancel_popup()

	" Enable omni completion.
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
	if neobundle#is_installed('omnisharp-vim')
		autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
	endif
	" autocmd FileType php setlocal omnifunc=OmniSharp#Complete

	" Enable heavy omni completion.
	let g:neocomplete#force_overwrite_completefunc = 1
	if !exists('g:neocomplete#sources#omni#input_patterns')
	  let g:neocomplete#sources#omni#input_patterns = {}
	endif
	if !exists('g:neocomplete#force_omni_input_patterns')
	  let g:neocomplete#force_omni_input_patterns = {}
	endif
	" let g:neocomplete#sources#omni#input_patterns.php =
	" \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
	" let g:neocomplete#sources#omni#input_patterns.php =
	" \ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
	let g:neocomplete#sources#omni#input_patterns.c =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
	let g:neocomplete#sources#omni#input_patterns.cpp =
	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
	" let g:neocomplete#force_omni_input_patterns.c =
	" 			\ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
	" let g:neocomplete#force_omni_input_patterns.cpp =
	" 			\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
	let g:neocomplete#sources#omni#input_patterns.cs = 
	\'.*[^=\);]'

	" For perlomni.vim setting.
	" https://github.com/c9s/perlomni.vim
	"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
	
endif
"}}}

" vim-clang"{{{
"-------------------------
if neobundle#is_installed('vim-clang')

	" disable auto completion for vim-clang
	let g:clang_auto = 0
	let g:clang_complete_auto = 0
	let g:clang_auto_select = 0
	let g:clang_use_library = 1
    "
	" " default 'longest' can not work with neocomplete
	let g:clang_c_completeopt   = 'menuone'
	let g:clang_cpp_completeopt = 'menuone'
    "
	" if executable('clang-3.6')
	" 	let g:clang_exec = 'clang-3.6'
	" elseif executable('clang-3.5')
	" 	let g:clang_exec = 'clang-3.5'
	" elseif executable('clang-3.4')
	" 	let g:clang_exec = 'clang-3.4'
	" else
	" 	let g:clang_exec = 'clang'
	" endif
    "
	" if executable('clang-format-3.6')
	" 	let g:clang_format_exec = 'clang-format-3.6'
	" elseif executable('clang-format-3.5')
	" 	let g:clang_format_exec = 'clang-format-3.5'
	" elseif executable('clang-format-3.4')
	" 	let g:clang_format_exec = 'clang-format-3.4'
	" else
	" 	let g:clang_exec = 'clang-format'
	" endif
    "
	
	let g:clang_cpp_options = '-std=c++1y -stdlib=libc++'
endif
"}}}

" clang_complete"{{{
"-------------------------
if neobundle#is_installed('clang_complete')
	" 自動呼出しOFF neocomplcacheと競合回避
	let g:clang_complete_auto=1
endif
"}}}

" vim-snowdrop"{{{
"-------------------------
if neobundle#is_installed('vim-snowdrop')
	let g:snowdrop#libclang_path = "/usr/lib64/llvm/"

	let g:snowdrop#include_paths = {
	\	"cpp" : filter(
	\	split(glob('/usr/include/c++/*'), '\n') +
	\	split(glob('/usr/include/*/c++/*'), '\n') +
	\	split(glob('/usr/include/*/'), '\n'),
	\	'isdirectory(v:val)')
	\}
	let g:snowdrop#goto_definition_open_cmd = "split"

	let g:snowdrop#command_options = {
	\	"cpp" : "-std=c++1y",
	\}

	autocmd FileType cpp nnoremap <C-]> :call snowdrop#goto_definition_in_cursor("edit")<CR>
	autocmd FileType cpp nnoremap <C-w>] :call snowdrop#goto_definition_in_cursor("split")<CR>

	if neobundle#is_installed('neocomplete')
		let g:neocomplete#sources#snowdrop#enable = 0
	endif
endif
"}}}

" neosnippet"{{{
"-------------------------
if neobundle#is_installed('neosnippet')
	" Plugin key-mappings.
	imap <C-k>     <Plug>(neosnippet_expand_or_jump)
	smap <C-k>     <Plug>(neosnippet_expand_or_jump)
	xmap <C-k>     <Plug>(neosnippet_expand_target)
	xmap <C-l>     <Plug>(neosnippet_start_unite_snippet_target)

	" SuperTab like snippets behavior.
	"imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
	"smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

	" For snippet_complete marker.
	if has('conceal')
	  set conceallevel=2 concealcursor=i
	endif

	" 現在の filetype のスニペットを編集する為のキーマッピング
	" こうしておくことでサッと編集や追加などを行うことができる
	" 以下の設定では新しいタブでスニペットファイルを開く
	nnoremap <Space>ns :execute "tabnew\|:NeoSnippetEdit ".&filetype<CR>

	" スニペットファイルの保存ディレクトリを設定
	let g:neosnippet#snippets_directory = "$HOME/.neosnippet"
endif
"}}}

" vimfiler"{{{
"-------------------------
if neobundle#is_installed('vimfiler')
	"VimFilerを開く
	nmap ,e :VimFilerCurrentDir -split -simple -winwidth=30 -no-quit<CR>
	"vimデフォルトのエクスプローラをvimfilerで置き換える
	let g:vimfiler_as_default_explorer = 1
	"表示拒否パターンを変更
	let g:vimfiler_ignore_pattern = '^\%(.svn\|.git\|.DS_Store\)$'
endif
"}}}

" vim-airline"{{{
"-------------------------
if neobundle#is_installed('vim-airline')
	let g:airline_theme='wombat'
	let g:airline_section_b = ''
	let g:airline_section_c = '%t%{cfi#format(":%s", "")}'
	let g:airline_section_x = '%{getcwd()}  %{airline#util#wrap(airline#parts#filetype(),0)}'
	let g:airline_section_y = '%{GetEnc()}'
	let g:airline_section_z = '%3p%% :%3l:%3c[%{GetB()}]'
	let g:airline_detect_whitespace = 2
endif
"}}}

" ctrlp.vim"{{{
"-------------------------
if neobundle#is_installed('ctrlp.vim')
	"set runtimepath^=$HOME/.vim/bundle/ctrlp.vim
	let g:ctrlp_open_new_file = 'h'
	let g:ctrlp_user_command = 'find %s \( -path "*.svn" -prune -or -name "*.o" -prune \) -o -print'
	set wildignore+=*.o,*.swp
	set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
	let g:ctrlp_map = '<Space>p'
	"nmap <Space>f :CtrlPBuffer<CR>
endif
"}}}

" vim-quickrun"{{{
"-------------------------
if neobundle#is_installed('vim-quickrun')
	"set runtimepath^=$HOME/.vim/bundle/vim-quickrun
	"nmap <Space>r :QuickRun -outputter error -outputter/error/success buffer -outputter/error quickfix<CR>
	nmap <Space>r :QuickRun -args <C-r>r<CR>
	vmap <Space>r :QuickRun -args <C-r>r<CR>
	vmap ,r "ry<Space>r
	nmap ,r qrq
	" <C-c> で実行を強制終了させる
	" quickrun.vim が実行していない場合には <C-c> を呼び出す
	nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
	" ファイル書き込み後quickrun実行
	"au! BufWritePost *.[ch],*.[ch]pp :QuickRun -outputter quickfix
	"au! BufWritePost *.[ch],*.[ch]pp :QuickRun -outputter error -outputter/error/success quickfix -outputter/error quickfix
	"au! BufReadPost quickfix  :call feedkeys("<C-w>p")

	" コンフィグ
	" ユーザの g:quickrun_config の設定
	let g:quickrun_config = {}

	" vimprocで非同期に変更
	" ファイルタイプがcppのときはmakeする
	let g:quickrun_config = {
	\	"_" : {
	\		"runner" : "vimproc",
	\		"runner/vimproc/updatetime" : 500,
	\		"outputter/buffer/split" : ":abo 8sp",
	\	},
	\
	\	"cpp" :{ "type" : "cpp/make" },
	\	"cpp/make" : {
	\		"exec" : "make all",
	\		"outputter" : "multi",
	\		"outputter/multi/targets" : ["quickfix","buffer"],
	\		"hook/close_buffer/enable_exit" : 1,
	\		"hook/close_quickfix/enable_exit" : 0,
	\		"hook/copen/enable_failure" : 1,
	\		"hook/hier_update/priority_exit" : 1,
	\	},
	\	"make" :{ "type" : "cpp/make" },
	\
	\	"javascript" :{ "type" : "js/node" },
	\	"jp/node" : {
	\		"exec" : "node",
	\		"outputter" : "multi",
	\		"outputter/multi/targets" : ["quickfix","buffer"],
	\		"hook/close_buffer/enable_exit" : 1,
	\		"hook/close_quickfix/enable_exit" : 0,
	\		"hook/copen/enable_failure" : 1,
	\		"hook/hier_update/priority_exit" : 1,
	\	},
	\
	\	"plantuml" :{ "type" : "txt/plantuml" },
	\	"txt/plantuml" : {
	\		"exec" : "sh $HOME/Library/Java/plantuml.sh %s:t:r",
	\		"outputter" : "multi",
	\		"outputter/multi/targets" : ["quickfix","buffer"],
	\		"hook/close_buffer/enable_exit" : 1,
	\		"hook/close_quickfix/enable_exit" : 0,
	\		"hook/copen/enable_failure" : 1,
	\		"hook/hier_update/priority_exit" : 1,
	\	},
	\
	\	"cpp/g++" : {
	\		"cmdopt" : "-std=c++1y -Wall",
	\	},
    \
	\	"cpp/clang++" : {
	\		"cmdopt" : "-std=c++1y -Wall",
	\	},
	\}

endif
"}}}

" vim-watchdogs"{{{
"-------------------------
if neobundle#is_installed('vim-watchdogs')
	" :WatchdogsRun 全ての共通設定
	let g:quickrun_config["watchdogs_checker/_"] = {
	\	"hook/hier_update/priority_exit" : 1,
	\	"runner/vimproc/updatetime" : 40,
	\}
	let g:quickrun_config['watchdogs_checker/php'] = {
	\   'command':     'php',
	\   'exec':        '%c -d error_reporting=E_ALL -d display_errors=1 -d display_startup_errors=1 -d log_errors=0 -d xdebug.cli_color=0 -l %o %s:p',
	\   'errorformat': '%m\ in\ %f\ on\ line\ %l'
	\}
	" let g:quickrun_config["cpp/watchdogs_checker"] = {
	" \		"type" : "watchdogs_checker/clang++",
	" \}
	" let g:quickrun_config["watchdogs_checker/g++"] = {
	" \		"cmdopt" : "-Wall",
	" \}
	" let g:quickrun_config["watchdogs_checker/clang++"] = {
	" \		"cmdopt" : "-Wall",
	" \}

	" .local.vimrcに移行
	"" 新しいツールの設定を追加
	"" g:quickrun_config.watchdogs_checker/{tool-name} に設定する
	""
	"" command はツールのコマンド
	"" exec の各オプションは
	"" %c   : command
	"" %o   : cmdopt
	"" %s:p : ソースファイルの絶対パス
	"" に展開される
	" let g:quickrun_config["watchdogs_checker/proj"] = {
	" \	"command"   : "g++",
	" \	"exec"      : "%c %o -fsyntax-only %s:p ",
	" \	"cmdopt"    : "-std=c++1y -Wall",
	" \}
	" let g:quickrun_config["cpp/watchdogs_checker"] = {
	" \	"type" : "watchdogs_checker/proj",
	" \}
	"
	"" g:quickrun_config の設定後に
	"" call watchdogs#setup(g:quickrun_config)
	"" を呼び出す
	call watchdogs#setup(g:quickrun_config)
	"
	"" 書き込み時にwatchdogsを実行
	"" cpp のみを有効
	let g:watchdogs_check_BufWritePost_enables = {}
	let g:watchdogs_check_BufWritePost_enables.cpp = 0
	let g:watchdogs_check_BufWritePost_enables.php = 1
	"let g:watchdogs_check_BufWritePost_enable = 1
endif
"}}}

" vim-ref"{{{
"-------------------------
if neobundle#is_installed('vim-ref')
	let g:ref_cache_dir = $HOME . '/.vim/vim-ref/cache'
	let g:ref_phpmanual_path = $HOME . '/.manual/php-chunked-xhtml'
	let g:ref_phpmanual_cmd = 'w3m -dump %s'
	au MyAu FileType c,cpp let g:ref_man_cmd = "man 3"
	au MyAu FileType ref-phpmanual nnoremap <silent> <buffer> q :q<CR>
endif
"}}}

" vim-singleton"{{{
"-------------------------
if neobundle#is_installed('vim-singleton')
	"call singleton#enable()
endif
"}}}

" vim-visualstar"{{{
"-------------------------
if neobundle#is_installed('vim-visualstar')
	map * <Plug>(visualstar-*)N
	map # <Plug>(visualstar-#)N
endif
"}}}

" vim-submode"{{{
"-------------------------
if neobundle#is_installed('vim-submode')
	"set runtimepath^=$HOME/.vim/bundle/vim-submode
	"call submode#enter_with('changetab', 'n', '', 'gt', 'gt')
	"call submode#enter_with('changetab', 'n', '', 'gT', 'gT')
	"call submode#map('changetab', 'n', '', 't', 'gt')
	"call submode#map('changetab', 'n', '', 'T', 'gT')
	"call submode#enter_with('wintb', 'n', '', '<C-w>k', '<C-w>k')
	"call submode#enter_with('wintb', 'n', '', '<C-w>j', '<C-w>j')
	"call submode#map('wintb', 'n', '', 'k', '<C-w>k')
	"call submode#map('wintb', 'n', '', 'j', '<C-w>j')
endif
"}}}

" vim-hier"{{{
"-------------------------
if neobundle#is_installed('vim-hier')
	"set runtimepath^=$/.vim/bundle/vim-hier

	" エラーを赤字の波線で
	"execute "highlight qf_error_ucurl gui=bold guisp=Red"
	"let g:hier_highlight_group_qf  = "qf_error_ucurl"
	"let g:hier_highlight_group_qf  = "SpellLocal"
	" 警告を青字の波線で
	"execute "highlight qf_warning_ucurl gui=underline guisp=Blue"
	"let g:hier_highlight_group_qfw = "qf_warning_ucurl"
endif
"}}}

" memolist.vim"{{{
"-------------------------
if neobundle#is_installed('memolist.vim')
	"set runtimepath^=$HOME/.vim/bundle/memolist.vim
	let g:memolist_path = "$HOME/.memolist/"
	"nmap <C-w>n :MemoNew<CR>
	let g:memolist_unite        = 1
	let g:memolist_unite_source = "file_rec"
	let g:memolist_unite_option = "-start-insert"
	nmap ,m :MemoList<CR>
endif
"}}}

" VimShell"{{{
"-------------------------
if neobundle#is_installed('vimshell')
	"nmap ,s :VimShell<CR>
	nmap <silent> <Space>s :VimShellPop<CR>

	"let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
	"let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
	
	if has('win32') || has('win64')
	  " Display user name on Windows.
	  let g:vimshell_prompt = $USERNAME."% "
	else
	  " Display user name on Linux.
	  let g:vimshell_prompt = $USER."% "
	endif
	
	" Initialize execute file list.
	let g:vimshell_execute_file_list = {}
	call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
	let g:vimshell_execute_file_list['rb'] = 'ruby'
	let g:vimshell_execute_file_list['pl'] = 'perl'
	let g:vimshell_execute_file_list['py'] = 'python'
	call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
	
	autocmd FileType vimshell
	\ call vimshell#altercmd#define('g', 'git')
	\| call vimshell#altercmd#define('i', 'iexe')
	\| call vimshell#altercmd#define('l', 'll')
	\| call vimshell#altercmd#define('ll', 'ls -l')
	"\| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')
	
	"function! g:my_chpwd(args, context)
	"  call vimshell#execute('ls')
	"endfunction
	
	autocmd FileType int-* call s:interactive_settings()
	function! s:interactive_settings()
	endfunction
endif
"}}}

"eregex.vim設定"{{{
"-------------------------
if neobundle#is_installed('eregex.vim')
	"nnoremap / :M/
	"nnoremap ,/ /
endif
"}}}

" tcomment_vim"{{{
"-------------------------
if neobundle#is_installed('tcomment_vim')
	nmap <Space>x :TComment<CR>
	vmap <Space>x :TComment<CR>
endif
"}}}

" caw.vim"{{{
"-------------------------
if neobundle#is_installed('caw.vim')
	"nmap <Space>x gci
	"vmap <Space>x gci
endif
"}}}

"Align "{{{
"-------------------------
if neobundle#is_installed('Align')
	vmap A :Align
endif
"}}}

"yankring.vim "{{{
"-------------------------
if neobundle#is_installed('yankring.vim')
	"nmap ,y :YRShow<CR>
	"let yankring_replace_n_pkey = ',p'
	"let yankring_replace_n_nkey = ',n'
	"let yankring_history_dir = "$HOME/.vim"
endif
"}}}

"yankround.vim{{{
"-------------------------
if neobundle#is_installed('yankround.vim')
	nmap p <Plug>(yankround-p)
	nmap P <Plug>(yankround-P)
	nmap ,p <Plug>(yankround-prev)
	nmap ,n <Plug>(yankround-next)
	let g:yankround_max_history = 50
	"let g:yankround_dir = '$HOME/.cache/yankround'
	nnoremap <silent>,y :Unite yankround<CR>
endif
"}}}

" OmniCppComplete"{{{
"-------------------------
if neobundle#is_installed('OmniCppComplete')
	let OmniCpp_NamespaceSearch = 1
	let OmniCpp_GlobalScopeSearch = 1
	let OmniCpp_ShowAccess = 1
	let OmniCpp_ShowScopeInAddr = 0
	let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
	let OmniCpp_MayCompleteDot = 1 " autocomplete after .
	let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
	let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
	let OmniCpp_DefaultNamespaces =["std", "_GLIBCXX_STD"]
	" automatically open and close the popup menu / preview window
	"au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
	"neocomplcache を使用している場合は副作用が出るので設定しない
	"set completeopt=menuone,menu,longest,preview
endif
"}}}

" vim-textobj-multiblock"{{{
"-------------------------
if neobundle#is_installed('vim-textobj-multiblock')
	omap ab <Plug>(textobj-multiblock-a)
	omap ib <Plug>(textobj-multiblock-i)
	vmap ab <Plug>(textobj-multiblock-a)
	vmap ib <Plug>(textobj-multiblock-i)
endif
"}}}

" vim-smartinput"{{{
"-------------------------
if neobundle#is_installed('vim-smartinput')
	call smartinput_endwise#define_default_rules()
endif
"}}}

" vim-altr"{{{
"-------------------------
if neobundle#is_installed('vim-altr')
	" a.vimになれてるので:Aでaltrする
	command! A  call altr#forward()
	" tmplに対するルールを指定
	call altr#define('%.cpp.tmpl', '%.h.tmpl', '%.hpp.tmpl', '%.c.tmpl')
endif
"}}}

" vim-metarepeat "{{{
"-------------------------
if neobundle#is_installed('vim-metarepeat')
    let g:meterepeat#default_mapping = 1
endif
"}}}

" vim-precious"{{{
"-------------------------
if neobundle#is_installed('vim-precious')
	" 行数が多いファイルで重くなってたので設定
	" コンテキストを判定する範囲を小さくする
	" カーソル位置から前後 300行の範囲で判定を行う
	let g:context_filetype#search_offset = 300"
endif
"}}}

" vim-anzu"{{{
"-------------------------
if neobundle#is_installed('vim-anzu')
	"let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus=1
	let g:anzu_no_match_word = ""
endif
"}}}

" vim-automatic"{{{
"-------------------------
if neobundle#is_installed('vim-automatic')
	" is_close_focus_out に 1 を設定することで発動
	" close_window_cmd にはウィンドウを閉じるコマンドを設定
	" デフォルトでは :close を使用する
	"let g:automatic_config = [
	"\   {
	"\       "match" : {
	"\           "filetype" : "",
	"\       },
	"\       "set" : {
	"\           "is_close_focus_out" : 1,
	"\       }
	"\   },
	"\]
endif
"}}}

" vim-marching "{{{
"-------------------------
if neobundle#is_installed('vim-marching')
	let g:marching_clang_command = "/usr/bin/clang"

	" オプションを追加する場合
	"let g:marching_clang_command_option="-std=c++1y"

	" インクルードディレクトリのパスを設定
	let g:marching_include_paths = [
	\   "/usr/include/c++"
	\]

	" neocomplete.vim と併用して使用する場合は以下の設定を行う
	let g:marching_enable_neocomplete = 0
	if g:marching_enable_neocomplete

		if !exists('g:neocomplete#force_omni_input_patterns')
		  let g:neocomplete#force_omni_input_patterns = {}
		endif

		let g:neocomplete#force_omni_input_patterns.cpp =
			\ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

		" バックエンドに同期版の実装を使用する
		" これ以外は非同期版と同様の設定
		let g:marching_backend = "sync_clang_command"

	endif
endif
"}}}

" accelerated-smooth-scroll "{{{
"-------------------------
if neobundle#is_installed('accelerated-smooth-scroll')
	" <C-d>/<C-u> 時のスリープ時間 (msec) : 小さくするとスクロールが早くなります。
	" Default : 10
	let g:ac_smooth_scroll_du_sleep_time_msec = 1

	" <C-f>/<C-b> 時のスリープ時間 (msec) : 小さくするとスクロールが早くなります。
	" Default : 10
	let g:ac_smooth_scroll_fb_sleep_time_msec = 1
endif
"}}}

" linediff.vim "{{{
"-------------------------
if neobundle#is_installed('linediff.vim')
	vmap <Space>d :Linediff<CR>
endif
"}}}

" vim-signify "{{{
"-------------------------
if neobundle#is_installed('vim-signify.vim')
	" 次の差分箇所に移動
	nmap ,gj <Plug>(signify-next-hunk)zz
	" 前の差分箇所に移動
	nmap ,gk <Plug>(signify-prev-hunk)zz
	" 差分箇所をハイライト
	nmap ,gh <Plug>(signify-toggle-highlight)
	" 差分表示をトグルする(:SignifyToggleコマンドと同じ)
	nmap ,gt <Plug>(signify-toggle)
endif
"}}}

" calendar.vim "{{{
"-------------------------
if neobundle#is_installed('calendar.vim')
	"au MyAu FileType calendar colorscheme default
endif
"}}}

" wildfire.vim "{{{
"-------------------------
if neobundle#is_installed('wildfire.vim')
    let g:wildfire_fuel_map = "<Space>a"
    let g:wildfire_water_map = "<Space>A"
endif
"}}}

" vim-tags "{{{
"-------------------------
if neobundle#is_installed('vim-tags')
	"au MyAu BufNewFile,BufRead *.php let g:vim_tags_project_tags_command = "ctags -R --languages=php /Library/WebServer/"
endif
"}}}

" incsearch.vim "{{{
"-------------------------
if neobundle#is_installed('incsearch.vim')
	map /  <Plug>(incsearch-forward)
	map ?  <Plug>(incsearch-backward)
	map g/ <Plug>(incsearch-stay)
endif
"}}}

" rabbit-ui.vim "{{{
"-------------------------
if neobundle#is_installed('rabbit-ui.vim')
	function! s:edit_csv(path)
	  call writefile(map(rabbit_ui#gridview(
			\ map(readfile(expand(a:path)),'split(v:val,",",1)')),
			\ "join(v:val, ',')"), expand(a:path))
	endfunction

	command! -nargs=1 -complete=file EditCSV  :call <sid>edit_csv(<q-args>)
endif
"}}}

" lightline.vim "{{{
"-------------------------
if neobundle#is_installed('lightline.vim')

	command! -bar LightlineUpdate
	\ call lightline#init()|
	\ call lightline#colorscheme()|
	\ call lightline#update()

	let g:lightline = {
	\	'colorscheme': 'solarized',
	\	'active': {
	\		'left': [ [ 'mode', 'paste' ], [ 'dir', 'filename' ] ]
	\	},
	\	'inactive': {
	\		'left': [ [ 'dir', 'filename' ] ]
	\	},
	\	'tabline' : {
	\		'left': [ [ 'git', 'cwd' ], [ 'tabs' ] ],
	\ 		'right': [ [ 'close' ] ]
	\	},
	\	'component': {
	\		'lineinfo': '%3l:%3c[%{GetB()}]',
	\		'dir'     : '%.35(%{expand("%:h:s?\\S$?\\0/?")}%)',
	\		'anzu'    : '%{anzu#search_status()}'
	\	},
	\	'component_function': {
	\		'modified':     'MyModified',
	\		'readonly':     'MyReadonly',
	\		'filename':     'MyFilename',
	\		'fileformat':   'MyFileformat',
	\		'filetype':     'MyFiletype',
	\		'fileencoding': 'MyFileencoding',
	\		'mode':         'MyMode',
	\		'cwd': 			'MyCwd',
	\		'git': 			'MyFugitive'
	\	},
	\	'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
	\	'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
	\}

	function! MyModified()
		return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '++++++' : &modifiable ? '' : '-'
	endfunction

	function! MyReadonly()
	"	return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
		return &readonly ? "\ue0a2" : ''
	endfunction

	function! MyFilename()
		return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
				\ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
				\  &ft == 'unite' ? unite#get_status_string() :
				\  &ft == 'vimshell' ? vimshell#get_status_string() :
				\ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
				\ ('' != MyModified() ? ' ' . MyModified() : '')
	endfunction

	function! MyFileformat()
		return winwidth(0) > 70 ? &fileformat : ''
	endfunction

	function! MyFiletype()
		return winwidth(0) > 70 ? (strlen(&ft) ? &ft : 'no ft') : ''
	endfunction

	function! MyFileencoding()
		return winwidth(0) > 70 ? GetEnc() : ''
	endfunction

	function! MyCwd()
		return winwidth(0) > 70 ? getcwd() : ''
	endfunction


	function! MyMode()
		return  &ft == 'unite' ? 'Unite' :
			  \ &ft == 'vimfiler' ? 'VimFiler' :
			  \ &ft == 'vimshell' ? 'VimShell' :
			  \ winwidth(0) > 60 ? lightline#mode() : ''
	endfunction

	function! MyFugitive()
		try
			if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head') && strlen(fugitive#head())
				return "\ue0a0 " . fugitive#head()
			endif
		catch
		endtry
		return ''
	endfunction
    "
	" let g:lightline_my_cfi_cache = 'mycfi...'
	" let g:lightline_my_cfi_cache_line = 0
	" let g:lightline_my_cfi_cache_file = ''
    "
	" function! MyCurrentFuncInfo()
    "
	" 	" callされまくって重い対策
	" 	" 関数名を探すのは画面に見えてる場合は意味無いので
	" 	" それなりに移動したときだけで良いはず
	"
	" 	" ファイルが読めなければ行わない
	" 	let fname = expand('%')
	" 	if !filereadable(fname)
	" 		return g:lightline_my_cfi_cache
	" 	endif
    "
	" 	" 引き続き同じファイルなら移動チェック
	" 	let now_line = line(".")
	" 	if fname == g:lightline_my_cfi_cache_file
	" 	
	" 		let border = 30
	" 		let chg_line = abs(now_line - g:lightline_my_cfi_cache_line)
    "
	" 		" cacheするタイミングで関数が無いこともあるので、有る場合のみcacheを使う
	" 		" ただし、行移動してないときは何度もする必要ないので基本cacheを使う
	" 		if chg_line < border && g:lightline_my_cfi_cache != ''
	" 			return g:lightline_my_cfi_cache
	" 		endif
	" 		if now_line == g:lightline_my_cfi_cache_line
	" 			return g:lightline_my_cfi_cache
	" 		endif
    "
	" 	endif
	" 	let g:lightline_my_cfi_cache_line = now_line
	" 	let g:lightline_my_cfi_cache_file = fname
    "
	" 	"下のほうに関数を書こうとするとvimが止まる対策
	" 	let lines = readfile(fname)
	" 	let max_line = len(lines)
	" 	if now_line+10 > max_line 
	" 		return g:lightline_my_cfi_cache
	" 	endif
    "
	" 	if exists('*cfi#get_func_name') && (&ft == 'c' || &ft == 'cpp')
	" 		let fname = cfi#get_func_name('c')
	" 		let g:lightline_my_cfi_cache = (fname != '') ? fname . '()' : ''
	" 		return g:lightline_my_cfi_cache
	" 	elseif exists('*cfi#format')
	" 		let g:lightline_my_cfi_cache = cfi#format('%.43s()', '')
	" 		return g:lightline_my_cfi_cache
	" 	endif
	" 	return ''
	" endfunction

endif
"}}}

" powerline "{{{
"-------------------------
if neobundle#is_installed('powerline')

	set noshowmode

	if exists("&ambiwidth")
		set ambiwidth=
	endif

	" python from powerline.vim import setup as powerline_setup
	" python powerline_setup()
	" python del powerline_setup

endif
"}}}

" vim-choosewin "{{{
"-------------------------
if neobundle#is_installed('vim-choosewin')
	nmap W <Plug>(choosewin)

	" オーバーレイを使う
	let g:choosewin_overlay_enable = 1

	" マルチバイトバッファでオーバーレイフォントを崩さないように
	let g:choosewin_overlay_clear_multibyte = 1

	" tmux の色に雰囲気を合わせる。
	let g:choosewin_color_overlay = {
		\ 'gui': ['DodgerBlue3', 'DodgerBlue3' ],
		\ 'cterm': [ 25, 25 ]
		\ }
	let g:choosewin_color_overlay_current = {
		\ 'gui': ['firebrick1', 'firebrick1' ],
		\ 'cterm': [ 124, 124 ]
		\ }
endif
"}}}

" vim-quickhl.vim "{{{
"-------------------------
if neobundle#is_installed('vim-quickhl')
	" <Space>m でカーソル下の単語、もしくは選択した範囲のハイライトを行う
	" 再度 <Space>m を行うとカーソル下のハイライトを解除する
	" これは複数の単語のハイライトを行う事もできる
	" <Space>M で全てのハイライトを解除する
	nmap m <Plug>(quickhl-manual-this)
	xmap m <Plug>(quickhl-manual-this)
	nmap <Space>m <Plug>(quickhl-manual-reset)
	xmap <Space>m <Plug>(quickhl-manual-reset)
endif
"}}}

" a.vim "{{{
"-------------------------
if neobundle#is_installed('a.vim')
	" 移動対象のウィンドウ開いているとそちらに移動してしまう
	" 強制的にhやcppにカレントウィンドウで移動するコマンドを定義
	command! -bang AH call AlternateFile("n<bang>", 'h')
	command! -bang AC call AlternateFile("n<bang>", 'cpp')

	" hの優先度を変更
	let g:alternateExtensions_h = 'cpp,c,cxx,cc,CC'
	" tmpl同士の移動
	" vim6から変数名にdotを使えなくなった
	"let g:alternateExtensions_{'h.tmpl'}   = 'cpp.tmpl,c.tmpl,cxx.tmpl,cc.tmpl,CC.tmpl'
	"let g:alternateExtensions_{'c.tmpl'}   = 'h.tmpl'
	"let g:alternateExtensions_{'cpp.tmpl'} = 'h.tmpl,hpp.tmpl'
endif
"}}}

" vcscommand.vim "{{{
"-------------------------
if neobundle#is_installed('vcscommand.vim')

	" 数値の上で実行時にVCSAnnotateをリビジョン付きで呼び出す
	au MyAu FileType svnannotate nnoremap <silent><buffer> <C-w>F :VCSAnnotate -r <C-r><C-w><CR>
	" 数値の上で実行時にVCSLogをリビジョン付きで呼び出す
	au MyAu FileType svnannotate nnoremap <silent><buffer> <C-w>L :VCSLog -r <C-r><C-w><CR>
	" 数値の上で実行時にVCSDiffをリビジョン付きで呼び出す
	au MyAu FileType svnannotate nnoremap <silent><buffer> <C-w>D :VCSDiff -c <C-r><C-w><CR>

endif
"}}}

" svn-diff.vim "{{{
"-------------------------
if neobundle#is_installed('svn-diff.vim')

	" svn commit時にSvn_diff_windowsを呼び出す
	au MyAu FileType svn nnoremap D :call Svn_diff_windows() <CR>

endif
"}}}

" agit.vim "{{{
"-------------------------
if neobundle#is_installed('agit.vim')

	autocmd FileType agit call s:my_agit_setting()
	function! s:my_agit_setting()
		nmap <buffer> ch <Plug>(agit-git-cherry-pick)
		nmap <buffer> Rv <Plug>(agit-git-revert)
		nmap <buffer> rb :<C-u>AgitGitConfirm rebase --autostash <hash><CR>
		nmap <buffer> mb :AgitGit merge --no-ff <C-R><C-W>
		nmap <buffer> f  :AgitGit fetch -p<CR>
		nmap <buffer> p  :AgitGit pull
		nmap <buffer> gp :AgitGit push
		nmap <buffer> gP :AgitGit push --set-upstream origin <branch>
		nmap <buffer> s  :AgitGit stash
		nmap <buffer> sp :AgitGit stash pop
		nmap <buffer> cB :<C-R><C-W><C-A><C-D><C-D><C-D><C-D><C-D><C-D><C-D>AgitGit checkout -B <C-E> <C-R><C-W>
	endfunction

	"git-svn 環境
	"autocmd FileType agit call s:svn_agit_setting()
	"function! s:svn_agit_setting()
	"	nmap <buffer> f  :AgitGit svn fetch -p<CR>
	"	nmap <buffer> gp :AgitGit svn dcommit
	"endfunction

	" カーソル移動で一覧と差分を更新させたくない場合は
	let g:agit_enable_auto_show_commit = 0
	" ログの行数
	let g:agit_max_log_lines = 2000

endif
"}}}

" omnisharp-vim "{{{
"-------------------------
if neobundle#is_installed('omnisharp-vim')

	let g:OmniSharp_host = "http://localhost:2000"
	let g:OmniSharp_selector_ui = 'unite'
	let g:OmniSharp_timeout = 1

	autocmd FileType cs call s:my_omnisharp_setting()
	function! s:my_omnisharp_setting()
		nmap <buffer> <C-]> :OmniSharpGotoDefinition<CR>
		nmap <buffer> <Space>] :OmniSharpBuildAsync<CR>
		nmap <buffer> <Space>r :OmniSharpReloadSolution<CR>
	endfunction

endif
"}}}

" syntastic "{{{
"-------------------------
if neobundle#is_installed('syntastic')

	" set statusline+=%#warningmsg#
	" set statusline+=%{SyntasticStatuslineFlag()}
	" set statusline+=%*

	" let g:syntastic_always_populate_loc_list = 1
	" let g:syntastic_auto_loc_list = 1
	" let g:syntastic_check_on_open = 1
	" let g:syntastic_check_on_wq = 0
	"
	" let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
	let g:syntastic_cs_checkers = ['syntax', 'semantic']

	let g:syntastic_javascript_checkers = ['syntax', 'eslint']

endif
"}}}

" Pyclewn "{{{
"-------------------------
nmap ga :exe "Cattach " . expand('<cword>')<CR>
nmap gr :Crun<CR>
nmap gn :Cnext<CR>
nmap gs :Cstep<CR>
nmap gcc :Ccontinue<CR>
nmap gb :exe "Cbreak " . expand("%:p") . ":" . line(".")<CR>
nmap ge :exe "Cclear " . expand("%:p") . ":" . line(".")<CR>
nmap gp :exe "Cprint " . substitute(expand('<cword>'), "," , "", "g")<CR>
nmap gP :exe "Cprint " . substitute(expand('<cWORD>'), "," , "", "g")<CR>
"}}}

" vim:set foldmethod=marker commentstring="%s :
