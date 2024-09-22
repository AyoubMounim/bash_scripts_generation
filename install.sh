#!/bin/bash

PROGNAME=${0##*/}
VERSION="0.1"
LIBS=()  # Paths to external libraries.

EXE_NAME="new_script.sh"
INSTALL_PREFIX="/usr/local/bin"
TEMPLATES_INSTALL_PREFIX="/usr/local/share/bash_scripts_generation"

function set_up(){
    [[ -d "$TEMPLATES_INSTALL_PREFIX" ]] || mkdir -p "$TEMPLATES_INSTALL_PREFIX"
    [[ -d "$(pwd)/templates" ]] || error_exit "install.sh must be run form project root directory."
    [[ -f "$(pwd)/$EXE_NAME" ]] || error_exit "install.sh must be run form project root directory."
    return 0
}

function clean_up(){
    # Graceful exit clean up.
    return 0
}

function graceful_exit(){
    clean_up
    exit 1
}

function error_exit(){
    local error_msg="$1"
    printf "%s: %s\n" "$PROGNAME" "${error_msg:-"Unknown Error"}" >&2
    graceful_exit
}

function signal_exit(){
    local signal="$1"
    case "$signal" in
        INT)
            error_exit "Program interrupted by user."
            ;;
        TERM)
            error_exit "Program terminated."
            ;;
        *)
            error_exit "Program killed by unknown signal."
            ;;
    esac
}

function load_libs(){
    local i
    for i in $LIBS; do
        [[ -r "$i" ]] || error_exit "Library '$i' not found."
        source "$i" || error_exit "Failed to source library '$i'."
    done
    return 0
}

function usage(){
    printf "%s\n" "Usage: $PROGNAME [-h | --help]"
    printf "       %s\n" "$PROGNAME [-i install_prefix] [-t templates_install_prefix]"
    return 0
}

function print_help(){
    cat <<- EOF
$PROGNAME ver. $VERSION
Installation script for "$EXE_NAME" utility.

$(usage)

Otions:
-h, --help    Display this help message.
-i, --install-prefix <prefix_path>    Executable install location.
-t, --templates-install-prefix <prefix_path>    Templates install location.

EOF
    return 0
}

trap "signal_exit TERM" TERM HUP
trap "signal_exit INT" INT

load_libs

while [[ -n "$1" ]]; do
    case "$1" in
        -h | --help)
            print_help
            graceful_exit
            ;;
        -i | --install-prefix)
            shift
            INSTALL_PREFIX="$1"
            ;;
        -t | --templates-install-prefix)
            shift
            TEMPLATES_INSTALL_PREFIX="$1"
            ;;
        *)
            usage >&2
            error_exit "Unknown option $1"
            ;;
    esac
    shift
done

set_up

cp -r "$(pwd)/templates" "$TEMPLATES_INSTALL_PREFIX"
cp "$(pwd)/$EXE_NAME" "$INSTALL_PREFIX/new_script"

graceful_exit

