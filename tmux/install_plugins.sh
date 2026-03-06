#!/bin/bash

set -e

TMUX_PLUGINS_DIR=~/.tmux/plugins

install_tpm() {
    if [ ! -d "$TMUX_PLUGINS_DIR/tpm" ]; then
        echo "Installing TPM..."
        git clone https://github.com/tmux-plugins/tpm.git "$TMUX_PLUGINS_DIR/tpm"
        echo "TPM installed successfully"
    else
        echo "TPM already installed"
    fi
}

install_plugins() {
    if command -v tmux &> /dev/null; then
        install_tpm
        echo "Installing tmux plugins..."
        
        if [ ! -d "$TMUX_PLUGINS_DIR/tmux-sensible" ]; then
            git clone https://github.com/tmux-plugins/tmux-sensible "$TMUX_PLUGINS_DIR/tmux-sensible"
        fi
        
        if [ ! -d "$TMUX_PLUGINS_DIR/tmux-resurrect" ]; then
            git clone https://github.com/tmux-plugins/tmux-resurrect "$TMUX_PLUGINS_DIR/tmux-resurrect"
        fi
        
        if [ ! -d "$TMUX_PLUGINS_DIR/tmux-continuum" ]; then
            git clone https://github.com/tmux-plugins/tmux-continuum "$TMUX_PLUGINS_DIR/tmux-continuum"
        fi
        
        if [ ! -d "$TMUX_PLUGINS_DIR/tmux-pain-control" ]; then
            git clone https://github.com/tmux-plugins/tmux-pain-control "$TMUX_PLUGINS_DIR/tmux-pain-control"
        fi
        
        echo "Plugins installed!"
        echo "Restart tmux or press prefix + I to load plugins"
    else
        echo "tmux not found, please install tmux first"
        exit 1
    fi
}

install_plugins
