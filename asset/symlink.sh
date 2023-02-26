#!/bin/bash

if [ -L /asset/WebStatis/tegar/upgrade.sh ]; then
    echo "Symbolic link already exists"
else
    ln -s /asset/upgrade.sh /asset/WebStatis/tegar/
fi