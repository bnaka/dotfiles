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

"実行中のコマンド表示
set showcmd

"インクリメントサーチ
set incsearch
set hlsearch

"他で書き換えられたら自動で読み直す
set autoread

"バックアップ
set backup
set backupdir=~/.vimtmp

"hidden bufferになった際にundo等の情報が消えてしまうのを抑える
set hidden

"ウィンドウの大きさ
set winwidth=105
set winheight=70
set winminwidth=10
set winminheight=3

"プレビューウィンドウの大きさ
set pvh=10

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

"---------------------------------------------------------------------------------------
" 表示関連
"---------------------------------------------------------------------------------------

"行数表示
set number


" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
"set wildmenu
" コマンドライン補間をシェルっぽく
set wildmode=list:longest

"ステータスラインに関して
" from id:secondlife(はてな勉強会) http://hatena.g.hatena.ne.jp/hatenatech/20060515/1147682761

"ステータスラインを常に表示
set laststatus=2

" カーソル位置のアスキーコード取得
function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" :help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

"ステータスラインに文字コードと改行文字を表示する
" %F%だとpathを全部表示するんだけど、きもちわるいので常に%f%で
" set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']['.&ft.']'}\ %F%=%l,%c%V%8P
  set statusline=%<[%n]%m%r\ %f%=[%{GetB()}]\ %l,%c%V%6P%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%{&bomb?'[BOM]':'[]'}%y
   
"if winwidth(0) >= 120
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
"else
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
"endif 

"set statusline=%{GetB()}

" 補完候補の色づけ for vim7
hi Pmenu term=bold cterm=reverse ctermbg=7
"hi PmenuSel ctermbg=12
"hi PmenuSbar ctermbg=0

"showmatchの色も見辛いので変更
hi MatchParen cterm=bold ctermbg=8


"---------------------------------------------------------------------------------------
" オプション設定
"---------------------------------------------------------------------------------------

"tagsファイルの指定
" from id:secondlife
"if has("autochdir")
"  set autochdir
"  set tags=tags;
"else
"  set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags,../*/tags,../*/*/tags
"endif



"---------------------------------------------------------------------------------------
" 便利な機能
"---------------------------------------------------------------------------------------

augroup MyAutoCmd

	" リセット
	autocmd!

	"カレントディレクトリの移動
	autocmd BufEnter *.nut,*.sh,*.conf,*.log,*.vim,Makefile,*.txt,*.c,*.cpp,*.h,*.hpp,*.pl,*.py,*.php,*.rb,*.js,*.css,*.html,*.xml,*.xsl,*.sql,*.csv,*.tmpl,*.script,*.as,*.tpl,*.ctp,*.cs execute ":lcd " . expand("%:p:h")

	" 前回終了したカーソル行に移動
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

	" :grep や :make の実行後、自動的に QuickFix ウィンドウを開く(http://vimwiki.net/?tips)
	autocmd QuickfixCmdPost make,grep,grepadd,vimgrep copen
	autocmd QuickfixCmdPost l* lopen

	" コメント行で改行したらコメントを自動挿入をoff
	autocmd FileType c,cpp,vim setlocal fo-=ro

	" sqlの際は行の折り返しをしない
	"autocmd FileType sql :set nowrap

	" actionscriptファイル認識
	autocmd BufNewFile,BufRead *.as set filetype=actionscript

	" genshiファイル認識
	autocmd BufNewFile,BufRead *.tmpl set filetype=textgenshi

augroup END

" ファイルを開いたときからの差を見る(http://vimwiki.net/?tips)
command! DiffOrig vert new | set bt=nofile 
\ | r # | 0d_ | diffthis
\ | wincmd p | diffthis

"---------------------------------------------------------------------------------------
" key-mapping
"---------------------------------------------------------------------------------------

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
nmap <Space>v :source ~/.vimrc<CR>

" 適当なショートカット
nnoremap <Space>: :noh<CR>
nmap <Space>w :w<CR>
nmap <Space>d :diffthis<CR>
nmap <Space>c :q<CR>

"カーソル位置の単語検索
nmap <C-g><C-w> :grep "<C-R><C-W>" *.c *.cpp */*.cpp *.h */*.h *.hpp *.php *.rb *.html *.js *.as *.sql *.csv *.xml *.txt *.nut *.sh<CR>
nmap <C-g><C-a> :grep "<C-R><C-A>" *.c *.cpp */*.cpp *.h */*.h *.hpp *.php *.rb *.html *.js *.as *.sql *.csv *.xml *.txt *.nut *.sh<CR>
nmap <C-g><C-i> :grep "<C-R>/" *.c *.cpp */*.cpp *.h */*.h *.hpp *.php *.rb *.html *.js *.as *.sql *.csv *.xml *.txt *.nut *.sh<CR>
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
	map <C-p> [c
	map <C-n> ]c
	map <C-o> do
	map <C-d> dp
endif

" 縦に並んだ数値を連番にする
nnoremap <silent> ,co :ContinuousNumber <C-a><CR>
vnoremap <silent> ,co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor

"---------------------------------------------------------------------------------------
" 文字コード関連
"---------------------------------------------------------------------------------------

" 文字コードの自動認識
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
endif

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

" 書き込んだ際にコンパイル
"function! WriteTest()
"	cclose
"	make
"	redr
"endfunction
"au! BufWritePost *.[ch],*.[ch]pp nested call WriteTest()

" カーソルが止まった時の処理
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

"CursorHoldが一個しか定義できないので関数をcall
"au! CursorHold *.[ch],*.cpp,*.php nested call CursorHoldCall()
"let g:svbfre = '.\+'

"augroup vimrc-auto-cursorline
"	autocmd!
"	autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
"	autocmd CursorHold,CursorHoldI * setlocal cursorline
"augroup END

" .hと.hppを新規で開いた場合に#ifdef - #endifを挿入する
au! BufNewFile *.h,*.hpp call IncludeGuard()
function! IncludeGuard()
   let fl = getline(1)
   if fl =~ "^#if"
       return
   endif
   let gatename = "__" . substitute(toupper(expand("%:t")), "\\.", "_", "g")
   normal! gg
   execute "normal! i#ifndef " . gatename . ""
   execute "normal! o#define " . gatename .  "\<CR>\<CR>\<CR>\<CR>\<CR>"
   execute "normal! Go#endif   /* " . gatename . " */"
   4
endfunction 

" cプリプロセッサにかける(http://vimwiki.net/?tips)
function! CppRegion()
	let beginmark='---beginning_of_cpp_region'
	let endmark='---end_of_cpp_region'
	exe a:firstline . "," . a:lastline ."!sed -e '" . a:firstline . "i\\\\" . nr2char(10) . beginmark . "' -e '" . a:lastline . "a\\\\".nr2char(10).endmark."' " .expand("%") . "|cpp -C|sed -ne '/" . beginmark . "/,/" .endmark . "/p'"
endfunction

" カレントバッファを#!で指定したプログラムで実行(http://vimwiki.net/?tips)
function! ShebangExecute()
	let m = matchlist(getline(1), '#!\(.*\)')
	if(len(m) > 2)
		execute '!'. m[1] . ' %'
	else
		execute '!' &ft ' %'
	endif
endfunction
nmap <Space>g :call ShebangExecute()<CR>

" カレントバッファを.oにてmake
function! MakeExcute()
	execute 'make ' expand("%:r") '.o'
endfunction
nmap <Space>o :call MakeExcute()<CR>

" csvの指定列をハイライト
function! CSVH(x)
	execute 'match Keyword /^\([^,]*,\)\{'.a:x.'}\zs[^,]*/'
	execute 'normal ^'.a:x.'f,'
endfunction
command! -nargs=1 Csv :call CSVH(<args>)

" 実行した内容をPrevieWindowに表示
function! PreviewWindowExecute()
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
endfunction
nmap <Space>g :call PreviewWindowExecute()<CR>

" 実行した内容をQuickFixに表示
function! QuickFixPreview(file)
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
endfunction


"---------------------------------------------------------------------------------------
" plugin
"---------------------------------------------------------------------------------------

" doxygencommenter.vim設定
" jcommenter.vimをdoxygen形式に改造
"-------------------------
autocmd FileType c,cpp map <Space>/ :call DoxygenCommentWriter()<CR>
autocmd FileType c,cpp vmap <Space>/ :Align //!<<CR>
let g:doxycommenter_file_author = "B.Naka"
nnoremap <Space>,, f)l<S-D>:call DoxygenCommentWriter()<CR><ESC><ESC>p0f;df<Space>2jo{<CR>}<ESC>k


" NeoBundle.vim
"-------------------------
" setup neobundle
" $ mkdir -p ~/.vim/bundle
" $ git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
set nocompatible               " Be iMproved

" proxy
let g:neobundle_default_git_protocol='https'

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f
" your_machines_makefile
NeoBundle 'Shougo/vimproc'

" My Bundle
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-build'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'osyo-manga/unite-quickfix'

NeoBundle 'Shougo/neocomplcache'
"NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimfiler'
NeoBundle "Shougo/context_filetype.vim"

NeoBundle 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundle 'dannyob/quickfixstatus'
NeoBundle 'jceb/vim-hier'

NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-splash'
NeoBundle 'thinca/vim-singleton'
NeoBundle 'thinca/vim-localrc'

NeoBundle 'kana/vim-submode'
NeoBundle "kana/vim-textobj-user"
NeoBundleLazy 'kana/vim-smartchr',   { 'autoload' : {'insert' : '1'} }
NeoBundleLazy 'kana/vim-smartinput', { 'autoload' : {'insert' : '1'} }
 

NeoBundle "osyo-manga/vim-precious"
NeoBundle "osyo-manga/vim-textobj-multiblock"

NeoBundle 'kien/ctrlp.vim'
NeoBundle 'glidenote/memolist.vim'
NeoBundle 'modsound/gips-vim'
NeoBundle 'tyru/capture.vim'
NeoBundle 'tyru/caw.vim'
"NeoBundle 'Rip-Rip/clang_complete'
"NeoBundle 'othree/eregex.vim'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'rhysd/clever-f.vim'
"NeoBundle 'supermomonga/vimshell-kawaii'
NeoBundle 'gregsexton/VimCalc'
NeoBundle 'yonchu/accelerated-smooth-scroll'
NeoBundle 'deris/vim-rengbang'

NeoBundle 'vim-scripts/Align'
NeoBundle 'vim-scripts/YankRing.vim'
NeoBundle 'vim-scripts/a.vim'
NeoBundle 'vim-scripts/vcscommand.vim'
NeoBundle 'vim-scripts/OmniCppComplete'

" Installation check.
NeoBundleCheck

"ソースコードのハイライト
syntax on

" unite.vim
"-------------------------
" 入力モードで開始する
let g:unite_enable_start_insert=1
" 表示場所
let g:unite_split_rule="lefta"
" file_mru表示数
let g:unite_source_file_mru_limit=200

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
nmap <silent> <Space>e :silent! UniteWithBufferDir file<CR>
nmap <silent> <Space>s :silent! UniteWithBufferDir -default-action=split file<CR>

" fuzzy match
call unite#custom_source('file,file/new,buffer,file_rec,file_mru,tag,tag/include', 'matchers', 'matcher_fuzzy')

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-w>S unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-w>S unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-w>V unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-w>V unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

" ファイル内検索
nnoremap <silent> ,/ :<C-u>Unite -buffer-name=search line/fast -start-insert -no-quit<CR>

" Uniteウィンドウを消す
nnoremap <silent> ,uc :<C-u>UniteClose default<CR>


" unite-build
"-------------------------
nnoremap <silent> make :<C-u>Unite build<CR><ESC><C-w>p


" unite-tag
"-------------------------
nnoremap <silent> g<C-]> :<C-u>execute "Unite tag/include:".expand('<cword>')<CR>


" neocomplcache
"-------------------------
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
inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"

"tabで補完候補の選択を行う
inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

" <C-h>や<BS>を押したときに確実にポップアップを削除します
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"

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
autocmd! BufRead *.cpp,*.h call g:TagsUpdate()


" neosnippet
"-------------------------
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif


" vimfiler
"-------------------------
"VimFilerを開く
nmap ,e :VimFiler -split -simple -winwidth=30 -no-quit<CR>
"vimデフォルトのエクスプローラをvimfilerで置き換える
let g:vimfiler_as_default_explorer = 1

" unite-outline
"-------------------------


" ctrlp.vim
"-------------------------
"set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_open_new_file = 'h'
let g:ctrlp_user_command = 'find %s \( -path "*.svn" -prune -or -name "*.o" -prune \) -o -print'
set wildignore+=*.o,*.swp
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
let g:ctrlp_map = '<Space>p'
"nmap <Space>f :CtrlPBuffer<CR>


" vim-quickrun
"-------------------------
"set runtimepath^=~/.vim/bundle/vim-quickrun
"nmap <Space>r :QuickRun -outputter error -outputter/error/success buffer -outputter/error quickfix<CR>
nmap <Space>r :QuickRun<CR>
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
\		"runner/vimproc/updatetime" : 60,
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
\}


" vim-watchdogs
"-------------------------
" :WatchdogsRun 全ての共通設定
let g:quickrun_config["watchdogs_checker/_"] = {
\	"hook/hier_update/priority_exit" : 1,
\}

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
"let g:quickrun_config["watchdogs_checker/proj"] = {
"\	"command"   : "g++",
"\	"exec"      : "%c %o -fsyntax-only %s:p ",
"\	"cmdopt"    : "",
"\}
"let g:quickrun_config["cpp/watchdogs_checker"] = {
"\	"type" : "watchdogs_checker/proj",
"\}
"
"" g:quickrun_config の設定後に
"" call watchdogs#setup(g:quickrun_config)
"" を呼び出す
"call watchdogs#setup(g:quickrun_config)
"
"" 書き込み時にwatchdogsを実行
"" cpp のみを有効
"let g:watchdogs_check_BufWritePost_enables = {}
"let g:watchdogs_check_BufWritePost_enables.cpp = 1

" vim-ref
"-------------------------
let g:ref_phpmanual_path = $HOME . '/.manual/php-chunked-xhtml'
autocmd FileType c,cpp let g:ref_man_cmd = "man 3"

" vim-singleton
"-------------------------
"call singleton#enable()


" submode
"-------------------------
"set runtimepath^=~/.vim/bundle/vim-submode
call submode#enter_with('changetab', 'n', '', 'gt', 'gt')
call submode#enter_with('changetab', 'n', '', 'gT', 'gT')
call submode#map('changetab', 'n', '', 't', 'gt')
call submode#map('changetab', 'n', '', 'T', 'gT')
"call submode#enter_with('wintb', 'n', '', '<C-w>k', '<C-w>k')
"call submode#enter_with('wintb', 'n', '', '<C-w>j', '<C-w>j')
"call submode#map('wintb', 'n', '', 'k', '<C-w>k')
"call submode#map('wintb', 'n', '', 'j', '<C-w>j')


" vim-hier
"-------------------------
"set runtimepath^=~/.vim/bundle/vim-hier

" エラーを赤字の波線で
"execute "highlight qf_error_ucurl gui=bold guisp=Red"
"let g:hier_highlight_group_qf  = "qf_error_ucurl"
let g:hier_highlight_group_qf  = "SpellLocal"
" 警告を青字の波線で
"execute "highlight qf_warning_ucurl gui=underline guisp=Blue"
"let g:hier_highlight_group_qfw = "qf_warning_ucurl"


" memolist.vim
"-------------------------
"set runtimepath^=~/.vim/bundle/memolist.vim
let g:memolist_path = "~/.memolist/"
nmap <C-w>n :MemoNew<CR>


" VimShell
"-------------------------
nmap ,v :VimShellTab<CR>


" clang_complete
"-------------------------
" 自動呼出しOFF neocomplcacheと競合回避
let g:clang_complete_auto=1


"eregex.vim設定
"-------------------------
"nnoremap / :M/
"nnoremap ,/ /


" tcomment
"-------------------------
nmap <Space>x :TComment<CR>
vmap <Space>x :TComment<CR>


" caw.vim
"-------------------------
"nmap <Space>x gci
"vmap <Space>x gci


"align.vim
"-------------------------
vmap a :Align 


"yankring.vim
"-------------------------
nmap ,y :YRShow<CR>
let yankring_replace_n_pkey = ',p'
let yankring_replace_n_nkey = ',n'
let yankring_history_dir = "$HOME/.vim"


" OmniCppComplete
"-------------------------
" OmniCppComplete
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


" vim-textobj-multiblock
"-------------------------
omap ab <Plug>(textobj-multiblock-a)
omap ib <Plug>(textobj-multiblock-i)
vmap ab <Plug>(textobj-multiblock-a)
vmap ib <Plug>(textobj-multiblock-i)


" accelerated-smooth-scroll
"-------------------------
" <C-d>/<C-u> 時のスリープ時間 (msec) : 小さくするとスクロールが早くなります。
" Default : 10
let g:ac_smooth_scroll_du_sleep_time_msec = 5

" <C-f>/<C-b> 時のスリープ時間 (msec) : 小さくするとスクロールが早くなります。
" Default : 10
let g:ac_smooth_scroll_fb_sleep_time_msec = 2


" Pyclewn
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

