set nojoinspaces
set sw=4 ts=4 sts=4 expandtab
set hls inc
set autoindent smartindent
let hostname=system('hostname -s')
set statusline=%F\ %P\ %c:%l\ %{hostname}
