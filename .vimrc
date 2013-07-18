"
"       俺様ちゃん用.vimrc
"

"ローカルファイルの設定のみ使用
"つか勝手に後から変更してんじゃねぇぞこの野郎＞＜q


"ソースコードをハイライト！
syntax on

"バックアップを撮る
set backup
set backupdir=~/.vimtmp

"ステータス行の表示レベルを上げる
set laststatus=2

"やっぱり行数わからないとな！
set number

"勝手にインデントだぜ！
set smartindent

"タブスペースは4に限る！
set tabstop=4
set shiftwidth=4

"括弧の対応がわかっちまう！
set showmatch

"実行中のコマンドを表示しちゃうぜ！（右下に
set showcmd

"検索打ち込み中にも検索だ！
set incsearch
set hlsearch

"hidden bufferになった際にundo等の情報が消えてしまうのを抑える
set hidden

"ウィンドウの大きさはこれくらい！
set winwidth=105
set winheight=40
set winminwidth=10
set winminheight=3

"スクロールから下の行がわからないのは気に食わないぜ！
set scrolloff=5

	"勝手になにかするよ！
function! CursorHoldCall()
	set updatetime=500

"勝手にプレビューしちゃうぜ！
"    if has("PreviewWord")
"		call PreviewWord()
"    endif
"勝手に保存しちゃうぜ！
"    if has("AutoUp")
"		call AutoUp()
"    endif
endfunction

"CursorHoldが一個しか定義できないのでfunctionに飛ばすよん
au! CursorHold *.[ch],*.php nested call CursorHoldCall()
set updatetime=500 "機能しない;なぜなのなぜなの
let g:svbfre = '.\+'

"勝手にカレントディレクトリを移動しちゃうぜ！
au BufEnter Makefile,*.txt,*.c,*.h,*.cpp,*.hpp,*.pl,*.php,*.js,*.css,*.html,*.xml,*.xsl,*.sql execute ":lcd " . expand("%:p:h")

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" 必要なタグファイルを指定すんだよ！
" set tags
" from id:secondlife
if has("autochdir")
  set autochdir
  set tags=tags;
else
  set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
endif

"これは便利杉！
"id:secondlifeグッジョブ
vmap j gj
vmap k gk
nmap j gj
nmap k gk

"なんとなく使いやすいキー配置になるぜ！
noremap z $
noremap 0 _

"面倒くさいコマンドをキーに割り当てだぜ！
nnoremap <C-k><C-j> :make<CR>
nnoremap <C-k><C-t> :make tag<CR>
nnoremap <Space>: :noh<CR>
nnoremap <C-k>esjis :e ++enc=iso-2022-jp-3<CR>
nmap <Space>w :w<CR>
nmap <Space>d :diffthis<CR>
nmap <Space>c :q<CR>

"カーソル位置の単語検索
nmap <C-g><C-w> :grep "<C-R><C-W>" *.c *.h *.php *.html *.js *.sql<CR>
nmap <C-g><C-a> :grep "<C-R><C-A>" *.c *.h *.php *.html *.js *.sql<CR>
nmap <C-g><C-h> :grep "<C-R>/" *.c *.h *.php *.html *.js *.sql<CR>
nmap <C-n> :cn<CR>
nmap <C-p> :cp<CR>

" command mode 時 tcsh風のキーバインドに
" from id:secondlife
cmap <C-A> <Home>
cmap <C-F> <Right>
cmap <C-B> <Left>
cmap <C-D> <Delete>
cmap <Esc>b <S-Left>
" こりゃいいわ！

" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
"set wildmenu
" コマンドライン補間をシェルっぽく
set wildmode=list:longest


" ステータスラインに関して
" id:secondlife(はてな勉強会) http://hatena.g.hatena.ne.jp/hatenatech/20060515/1147682761

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
" %F%だとpathを全部表示するんだけど、きもちわるいので常に%f%でお願いします＞＜
" つか前のほうが冗長すぎてうざいので順番入れ替える＞＜
" set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']['.&ft.']'}\ %F%=%l,%c%V%8P
set statusline=%<[%n]%m%r\ %f%=[%{GetB()}]\ %l,%c%V%6P%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y
"if winwidth(0) >= 120
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
"else
"  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
"endif 

"set statusline=%{GetB()}

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

" ただし、下記ファイルタイプのファイルはなにがなんでもutf-8でお願いします＞＜
autocmd FileType php :set fileencoding=utf-8
autocmd FileType js :set fileencoding=utf-8
autocmd FileType css :set fileencoding=utf-8
autocmd FileType html :set fileencoding=utf-8
autocmd FileType xml :set fileencoding=utf-8

"autocmd FileType php :set fileencoding=euc-jp
"utocmd FileType php :set fileencodings=euc-jp
"autocmd FileType php :set encoding=euc-jp

" UTF-8の□や○でカーソル位置がずれないようにする
if exists("&ambiwidth")
set ambiwidth=double
endif

" 改行コードの自動認識
set fileformats=unix,mac,dos

" utf-8で開きなおすことが多いので
map <Space>e :e ++ehp=utf-8<CR>

" 辞書ファイルからの単語補間
set complete+=k


"yankring.vim
nmap ,y :YRShow<CR>
let yankring_replace_n_pkey = ',p'
let yankring_replace_n_nkey = ',n'


" 補完候補の色づけ for vim7
hi Pmenu term=bold cterm=reverse ctermbg=7
"hi PmenuSel ctermbg=12
"hi PmenuSbar ctermbg=0

"showmatchの色も見辛いので変更
hi MatchParen cterm=bold ctermbg=8

"align.vim
vmap a :Align 

"EnhancedCommentify.vim
nmap <Space>x <Leader>x
vmap <Space>x <Leader>x

"eregex.vim設定
"nnoremap / :M/
"nnoremap ,/ /

"suround.vim設定
let g:surround_36 = "$(\r)"
nmap $' ysiw$
let g:surround_95 = "__\r__"
nmap _' ysiw_

"jcommeter.vim設定
autocmd FileType php map <Space>/ :call JCommentWriter()<CR>

"phpmanual.vim設定
" DLしてきたのに:%s/euc-jp/utf-8/gとソースencodingもutf-8に変換してある(utf-8環境なので
"source ~/.vim/ftplugin/phpmanual.vim
"let phpmanual_dir             = "$HOME/tool/manual/php/html/"
"let phpmanual_file_ext        = 'html'
"let phpmanual_convfilter      = 'iconv -f utf- -t utf-8'
"autocmd FileType php nmap <S-k> <Leader>P

nmap _ :.w !nkf -Ws\|pbcopy<CR><CR>
vmap _ :w !nkf -Ws\|pbcopy<CR><CR>

"コンパイラの指定
autocmd FileType perl,cgi :compiler perl 

function! ScriptInit()
  let result = system( &ft . " " . expand("%:p") )
  echo result
endfunction
map <Space>f :call ScriptInit()<CR>

