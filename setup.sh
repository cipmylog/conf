#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
    echo "Please run as root"
    exit
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [[ $DIR != "/usr/local/conf" ]]; then
    echo "Repository in wrong directory [${DIR}] please use /usr/local/conf"
    exit
fi

USR=${1:?No User specified}
echo "Running setup for: ${USR}"

#### CREATE DIRECTORIES ########################################################

mkdir -p /home/${USR}/.bak
chown ${USR}:${USR} /home/${USR}/.bak
mkdir -p /home/${USR}/.i3
chown ${USR}:${USR} /home/${USR}/.i3
mkdir -p /home/${USR}/.config/i3status
chown ${USR}:${USR} /home/${USR}/.config/i3status

# TODO: chmod dirs

#### FUNCTIONS #################################################################

function link_file {

    src=${1:?No source file specified}
    dst=${2:?No destination file specified}

    if [[ -e ${dst} ]]; then
        echo "Moving ${dst} to /home/${USR}/.bak/${src}"
        mv ${dst} /home/${USR}/.bak/${src}
    elif [[ -L ${dst} ]]; then
        echo "File ${dst} points to invalid location... deleting"
        rm -f ${dst}
    fi

    echo "Linking ${DIR}/${src} to ${dst}"
    ln -s ${DIR}/${src} ${dst}
    chown -R ${USR}:${USR} ${dst}
}

#### LINK FILES ################################################################

link_file i3config /home/${USR}/.i3/config
link_file i3status.conf /home/${USR}/.config/i3status/config

