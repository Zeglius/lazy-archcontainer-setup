#!/usr/bin/bash

# @version 1.0

# @describe Script to install common utilities for archlinux interactve containers.
# Utilities include: git, paru

# Check we are running in an archlinux container
check_os() {
    set -euo pipefail
    # Are we in a container?
    if ! systemd-detect-virt --container >/dev/null; then
        echo >&2 "ERROR: Environment is not a container!"
        return 1
    fi

    # Are we running in an archlinux container?
    if ! grep -qP '^ID=arch$' /etc/os-release; then
        echo >&2 "ERROR: Environment is not an archlinux container!"
        return 1
    fi

    return 0
}

# @cmd Install paru
install_paru() {
    set -euo pipefail
    check_os
    sudo pacman -S --needed --noconfirm base-devel git
    pushd .
    cd $(mktemp -d)
    trap 'rm -rf "$PWD"' RETURN
    git clone --depth=1 https://aur.archlinux.org/paru-bin.git paru
    cd paru
    makepkg -si
    popd
}

# @cmd Install all utilities
all() {
    install_paru
}

eval "$(argc --argc-eval "$0" "$@")"
