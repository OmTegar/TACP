#!/bin/bash

source ./upgrade.sh

if [ -L /asset/WebStatis/tegar/upgrade.sh ]; then
    echo "Symbolic link already exists"
else
    progress_bar ln -s asset/upgrade.sh asset/WebStatis/tegar/
fi