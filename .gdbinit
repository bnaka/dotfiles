# fork時にスレッド毎のgdbを可能にする
set follow-fork-mode child

# 以前起動した履歴を残しておく
set history save on
set history size 10000
set history filename ~/.gdb_history

# structなどをprintで表示したときに見やすく
set print pretty on
# 長い文字列を表示した際に途中で省略されないように
set print elements 0

#set print static-members off
