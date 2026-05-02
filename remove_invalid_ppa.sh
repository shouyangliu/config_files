#!/bin/bash
# Remove invalid jonathonf/vim PPA
echo "Removing invalid jonathonf/vim PPA..."
sudo rm -f /etc/apt/sources.list.d/jonathonf-ubuntu-vim-noble.sources
sudo apt update
echo "Done! Invalid PPA removed."
