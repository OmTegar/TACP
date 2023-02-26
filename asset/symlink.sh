#!/bin/bash

source ./upgrade.sh

if [ -f /asset/WebStatis/tegar/upgrade.sh ]; then
    echo "File already exists"
else
    progress_bar cp asset/upgrade.sh asset/WebStatis/tegar/
fi

