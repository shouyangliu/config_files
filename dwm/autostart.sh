#!/bin/sh
# --experimental-backends 是必须的：picom.conf 里 blur-method = "dual_kawase" 和
# corner-radius 都只有实验后端实现，legacy 后端会警告并静默忽略这两项。
# 代价是内存基线从 ~69MB 涨到 ~100MB（实测，压测 200 次开关窗口不涨）。
picom --experimental-backends --config ~/.picom.conf &

# 通知守护进程。dwm 自己不发通知，但 notify-send / 截图工具 / 各种程序都往
# org.freedesktop.Notifications 上发 —— 没有守护进程在总线上占这个名字，
# 发出来的通知会被直接丢掉（不是弹不出来，是根本没画）。picom.conf 里那几条
# class_g = 'Dunst' 的排除规则也是给它留的。
dunst &

# 锁屏看门狗：xss-lock 监听 X 的空闲超时和 logind 的挂起前信号，到点自己调 slock。
# 单靠 config.h 里 Super+Escape 那个手动键做不到"合盖自动锁"。
xss-lock -- slock &

fcitx5 &
~/.config/dwm/bar/dwm_bar.sh &
