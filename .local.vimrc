
au MyAu BufEnter qf resize

"バックアップ
let s:backup_dir = $HOME.'/prj/.vimtmp'
if !isdirectory(s:backup_dir)
	call mkdir(s:backup_dir, "p")
endif
set backup
let &backupdir=s:backup_dir

let g:prj_inc_dir = ['.'] +
			\ split(glob('/home/vagrant/prj.git/sv/prog/common/'), '\n') +
			\ split(glob('/home/vagrant/prj.git/sv/prog/common/inc'), '\n') +
			\ split(glob('/home/vagrant/prj.git/sv/prog/prjsv/'), '\n') +
			\ split(glob('/home/vagrant/prj.git/sv/prog/library/'), '\n') +
			\ split(glob('/home/vagrant/prj.git/sv/prog/library/*/inc/'), '\n') +
			\ split(glob('/home/vagrant/prj.git/sv/prog/library/*/include/'), '\n') +
			\ split(glob('/opt/rh/devtoolset-6/root/usr/include/c++/*'), '\n') + 
			\ split(glob('/opt/rh/devtoolset-6/root/usr/include/c++/*/x86_64-redhat-linux/'), '\n') +
			\ split(glob('/usr/include/'), '\n') +
			\ split(glob('/usr/local/boost_1_63_0/include/'), '\n')

let &l:path .= join(g:prj_inc_dir, ',')

let g:prj_inc = '-I' . join(g:prj_inc_dir,' -I')

let s:prj_cc_opt = "-std=c++1z -Dlinux -D__STDC_FORMAT_MACROS -DREDIS -Wall -Wno-attributes "

" agit.vim "{{{
"-------------------------
if neobundle#is_installed('agit.vim')

	autocmd FileType agit call s:prj_agit_setting()
	function! s:prj_agit_setting()
		nmap <buffer> f  :AgitGit svn fetch -p<CR>
		nmap <buffer> gp :AgitGit svn dcommit --rmdir
	endfunction

endif
"}}}

" vim-clang"{{{
"-------------------------
if neobundle#is_installed('vim-clang')

	let g:clang_cpp_options = "-stdlib=libc++ -std=c++1y -Dlinux -D__STDC_FORMAT_MACROS -DREDIS " . g:prj_inc

endif
"}}}

" vim-snowdrop"{{{
"-------------------------
if neobundle#is_installed('vim-snowdrop')
	let g:snowdrop#libclang_path = "/usr/lib64/llvm/"

	let g:snowdrop#include_paths["cpp"] = g:prj_inc_dir

	let g:snowdrop#command_options["cpp"] = "-stdlib=libc++ " . s:prj_cc_opt

	if neobundle#is_installed('neocomplete')
		let g:neocomplete#sources#snowdrop#enable = 0
	endif
endif
"}}}


" neocomplete"{{{
"-------------------------
if neobundle#is_installed('neocomplete')

	" let g:neocomplete#include_paths = {
	" \ 'cpp' : join(g:prj_inc_dir, ',')
	" \}
	" "インクルード文のパターンを指定
	" let g:neocomplete#include_patterns = {
	" \ 'cpp' : '^\s*#\s*include',
	" \ }

endif
"}}}

" vim-watchdogs"{{{
"-------------------------
if neobundle#is_installed('vim-watchdogs')

	let g:watchdogs_check_BufWritePost_enables.cpp = 1

	" 新しいツールの設定を追加
	" g:quickrun_config.watchdogs_checker/{tool-name} に設定する
	"
	" command はツールのコマンド
	" exec の各オプションは
	" %c   : command
	" %o   : cmdopt
	" %s:p : ソースファイルの絶対パス
	" に展開される
	let g:quickrun_config["watchdogs_checker/prj"] = {
	\	"command"   : "g++",
	\	"exec"      : "%c %o -fsyntax-only %s:p",
	\	"cmdopt"    : s:prj_cc_opt . g:prj_inc,
	\	"hook/hier_update/priority_exit" : 1,
	\}
	" let g:quickrun_config["watchdogs_checker/prj"] = {
	" \	"command"   : "clang",
	" \	"cmdopt"    : "-std=c++1y -stdlib=libc++ " . g:prj_inc,
	" \}
	let g:quickrun_config["cpp/watchdogs_checker"] = {
	\	"type" : "watchdogs_checker/prj",
	\}
	" call watchdogs#setup(g:quickrun_config)

endif
"}}}


" syntastic"{{{
"-------------------------
if neobundle#is_installed('syntastic')

	let g:syntastic_cpp_config_file = "/home/vagrant/prj.git/.syntastic_cpp_config"
	let g:syntastic_cpp_checkers = ['']

endif

" vim-quickrun"{{{
"-------------------------
if neobundle#is_installed('vim-quickrun')

    au MyAu FileType cpp call s:prj_quickrun_setting()
    function! s:prj_quickrun_setting()
        nmap <buffer> <Space>r :QuickRun -args 'debug USE_ICECC=1'<CR>
        nmap <buffer> <Space>RR :QuickRun -args 'minimal'<CR>
        nmap <buffer> <Space>RD :QuickRun -args 'minimal USE_ICECC=1'<CR>
    endfunction

    let g:quickrun_config['sql'] = {
                \ 'command': 'mysql',
                \ 'exec': ['%c -u root < %s'],
                \ }
    let g:quickrun_config['python'] = {
                \ 'command': 'python3',
                \ }

endif
"}}}

