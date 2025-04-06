"################################
"## Options
"################################
set clipboard=unnamed
unmap <Space>

"################################
"## Default
"################################
exmap q obcommand workspace:close
exmap e obcommand app:reload


"################################
"## App command
"################################
" exmap back obcommand app:go-back
" nmap <C-o> :back
" exmap forward obcommand app:go-forward
" nmap <C-i> :forward

"################################
"## Editor command
"################################
exmap focusRight obcommand editor:focus-right
nmap <C-l> :focusRight
exmap focusLeft obcommand editor:focus-left
nmap <C-h> :focusLeft
exmap focusTop obcommand editor:focus-top
nmap <C-k> :focusTop
exmap focusBottom obcommand editor:focus-bottom
nmap <C-j> :focusBottom
exmap nextTab obcommand workspace:next-tab
nmap L :nextTab
exmap prevTab obcommand workspace:previous-tab
nmap H :prevTab
exmap toggleFold obcommand editor:toggle-fold
nmap <CR> :toggleFold
exmap openLink obcommand editor:open-link-in-new-leaf
nmap <Space>o :openLink
exmap vsp obcommand workspace:split-vertical
exmap sp obcommand workspace:split-horizontal
exmap toggleCheck obcommand editor:toggle-checklist-status
nmap <Space>l :toggleCheck



"################################
"## Find module
"################################
exmap findHeader obcommand obsidian-another-quick-switcher:header-search-in-file
nmap <Space>fh :findHeader
exmap findWords obcommand obsidian-another-quick-switcher:grep
nmap <Space>fw :findWords
exmap findHistory obcommand obsidian-another-quick-switcher:search-command_Recent-search
nmap <Space>fo :findHistory
exmap findFile obcommand obsidian-another-quick-switcher:search-command_file-name-search
nmap <Space>ff :findFile
exmap findStar obcommand obsidian-another-quick-switcher:search-command_star-search
nmap <Space>fs :findStar
exmap moveFile obcommand obsidian-another-quick-switcher:move
nmap <Space>mf :moveFile

"################################
"## Module
"################################
exmap diff obcommand obsidian-version-history-diff:open-recovery-diff-view
exmap format obcommand markdown-prettifier:markdown-prettifier-run
nmap <C-f> :format
