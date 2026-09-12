#!/bin/bash
set -e

# fcitx5-config-qt 在 24.04+ 改名为 fcitx5-frontend-all 或不再单独提供
if apt-cache show fcitx5-config-qt &>/dev/null; then
    sudo apt install -y fcitx5 fcitx5-chinese-addons fcitx5-config-qt im-config
else
    sudo apt install -y fcitx5 fcitx5-chinese-addons im-config
fi

