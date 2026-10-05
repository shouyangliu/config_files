#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing awesome..."
# x11-xserver-utils 提供 xset（rc.lua 的 autostart 调键盘速率）和 xrdb
sudo apt-get install -y awesome x11-xserver-utils

echo "==> Setting up symlinks..."
mkdir -p ~/.config
rm -rf ~/.config/awesome
ln -snf "$SCRIPT_DIR" ~/.config/awesome
ln -snf "$SCRIPT_DIR/.Xresources" ~/.Xresources

# ---------------------------------------------------------------------------
# 验证：先在不开 X 的情况下查语法，再用 Xephyr 起一个嵌套 X 服务器真跑一遍。
# 这两步必须在删旧 WM 之前做完 —— 万一 rc.lua 有问题，chadwm/dwm 还在，
# 你至少还有一个能用的会话，不会卡在无 WM 的状态。
# ---------------------------------------------------------------------------

if [ ! -f "$SCRIPT_DIR/rc.lua" ]; then
    echo "ERROR: $SCRIPT_DIR/rc.lua 不存在，无法验证。" >&2
    echo "       （配置没写完就跑了？装 awesome 包和建软链已经做了，补上 rc.lua 再重跑）" >&2
    exit 1
fi

echo "==> Checking config syntax..."
# -k/--check 做离线语法检查（4.3 的 man page 确认有 -k/--check 和 -c FILE）。
# 但它只查语法、查不出 API 用错，所以下面那步实跑才是真正的判据；
# 这里失败也不立刻中止，先让实跑把更完整的报错带出来。
if SYNTAX_OUT=$(awesome -k -c "$SCRIPT_DIR/rc.lua" 2>&1); then
    echo "    OK"
else
    echo "    语法检查未通过，继续做实跑验证："
    printf '%s\n' "$SYNTAX_OUT" | sed 's/^/      /'
fi

echo "==> Checking theme palettes..."
# 8 套配色里只有被选中的那套会在实跑里被加载，其余 7 套语法错了平时发现不了，
# 等哪天切过去才发现就晚了 —— 所以这里一次性全查完，有错就当失败处理。
PALETTE_BAD=0
for palette in "$SCRIPT_DIR"/themes/*.lua; do
    [ -e "$palette" ] || continue
    if ! PALETTE_OUT=$(awesome -k -c "$palette" 2>&1); then
        echo "    FAILED — $(basename "$palette"):"
        printf '%s\n' "$PALETTE_OUT" | sed 's/^/      /'
        PALETTE_BAD=1
    fi
done
if [ "$PALETTE_BAD" -ne 0 ]; then
    echo
    echo "    配色文件有语法错，先修好再重跑。旧窗口管理器未改动。"
    exit 1
fi
echo "    OK"

echo "==> Smoke test in a nested X server..."

if ! command -v Xephyr >/dev/null 2>&1; then
    echo "    需要 Xephyr，正在安装 xserver-xephyr..."
    sudo apt-get install -y xserver-xephyr
fi

# 找一个没被占用的显示号
TEST_DISPLAY=""
for n in 9 8 7 6 5 4 3 2; do
    if [ ! -e "/tmp/.X${n}-lock" ]; then
        TEST_DISPLAY=":${n}"
        break
    fi
done

if [ -z "$TEST_DISPLAY" ]; then
    echo "    SKIP: 找不到空闲显示号，跳过实跑验证"
else
    Xephyr "$TEST_DISPLAY" -screen 1280x800 -noreset >/dev/null 2>&1 &
    XEPHYR_PID=$!
    # 不管脚本怎么退出，都别把嵌套 X 服务器留下
    trap 'kill "$XEPHYR_PID" 2>/dev/null || true' EXIT

    sleep 2

    if ! xset -display "$TEST_DISPLAY" q >/dev/null 2>&1; then
        echo "    SKIP: 嵌套 X 服务器没起来（此环境可能不支持 Xephyr），跳过实跑验证"
    else
        # AWESOME_NO_AUTOSTART=1 让 rc.lua 跳过自启段，避免在测试里
        # 把 picom / feh / fcitx5 真的拉起来干扰当前会话。
        # timeout 会在几秒后杀掉 awesome，所以退出码非 0 是正常的。
        TEST_OUT=$(AWESOME_NO_AUTOSTART=1 DISPLAY="$TEST_DISPLAY" \
                   timeout 6 awesome -c "$SCRIPT_DIR/rc.lua" 2>&1 || true)

        # 匹配 Lua 报错的特征串。这几条是实测踩过的两类错：
        #   配置语法/构造错 —— "error while running function!" + "stack traceback:"
        #   回调里的运行时错 —— "E: awesome: Error during a protected call:" + 行号
        # 刻意不写成宽泛的 'E: awesome:'：那会把 "Failed to load <图标>"、
        # 通知类噪音也算成失败，导致正常的配置被误判。
        if printf '%s' "$TEST_OUT" | grep -qiE \
                'attempt to|stack traceback|error while running|protected call|\.lua:[0-9]+:'; then
            echo "    FAILED — 配置运行时报错："
            printf '%s\n' "$TEST_OUT" | sed 's/^/      /'
            echo
            echo "    旧窗口管理器未改动，当前会话不受影响。"
            echo "    修好（上面 file.lua:行号 就是出错位置）后重跑本脚本。"
            exit 1
        else
            echo "    OK — rc.lua 加载无报错"
        fi
    fi

    kill "$XEPHYR_PID" 2>/dev/null || true
    trap - EXIT
fi

# ---------------------------------------------------------------------------
# 验证过了，这时才动旧 WM。放在最后是为了让上面任何一步失败都不破坏现有环境。
# ---------------------------------------------------------------------------

echo "==> Removing previous window managers (chadwm / dwm)..."
# chadwm 的二进制和会话文件是上一轮装的，dwm 的是更早那轮
sudo rm -f /usr/local/bin/chadwm /usr/local/bin/dwm \
           /usr/share/xsessions/chadwm.desktop /usr/share/xsessions/dwm.desktop
# 旧配置目录：chadwm/dwm 可能是真目录也可能是软链，都清掉
rm -rf ~/.config/chadwm ~/.config/dwm

echo "awesome installed."
echo "  会话文件由 awesome 包自带: /usr/share/xsessions/awesome.desktop"
echo "  注销后在 lightdm 里选 awesome 即可"
