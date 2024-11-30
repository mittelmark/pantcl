#!/usr/bin/env bash
OS=`uname | grep -Eo '^[A-Za-z]+'`
BASEURL="https://github.com/mittelmark/pantcl/releases/download/v0.10.0/"
KERNEL=`uname -r | grep -Eo '^[0-9]+'`

if [[ `which tclsh` == "" ]]; then
    echo "Error: Tcl (tclsh) is not installed but required please install!" 
    exit
fi
pantcl=pantcl.bin
if [[ `which pandoc` == "" ]]; then
    echo "Missing pandoc, installing standalone application pantcl.mbin"
    pantcl=pantcl.mbin
fi    
function install-pantcl {
    if [ ! -d ~/.local/bin ]; then
        mkdir -p ~/.local/bin
    fi
    # Check if ~/bin is already in the PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        # If it's not in the PATH, add it to ~/.bashrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        # Update the PATH for the current session
        export PATH="$HOME/.local/bin:$PATH"
        echo "To update the current Bash session with the new PATH variable use: 'source ~/.bashrc'"
    fi
    URL=${BASEURL}$1
    echo "fetching $URL"
    curl  -fsSL "${URL}" --output  ~/.local/bin/pantcl
    chmod 755  ~/.local/bin/pantcl
    echo "Installation complete."
}

#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mittelmark/microemacs/refs/heads/master/install-linux.sh)"
install-pantcl $pantcl
