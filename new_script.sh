#!/bin/bash

PROGNAME=${0##*/}
VERSION="0.1"
LIBS=()  # Paths to external libraries.

SCRIPT_NAME=""
QUIET=0  # TODO: this flag is not used.
TEMPLATES_DIR="/usr/local/share/bash_scripts_generation/templates"
OUTPUT_DIR="$(pwd)"

function set_up(){
    [[ -d "$TEMPLATES_DIR" ]] || error_exit "Teplates directory '$TEMPLATES_DIR' does not exist."
    [[ -f "$OUTPUT_DIR/$SCRIPT_NAME" ]] && rm "$OUTPUT_DIR/$SCRIPT_NAME"
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
    printf "%s\n" "Usage: $PROGNAME [-h|--help]"
    printf "%s\n" "\t$PROGNAME script_name"
    return 0
}

function print_help(){
    cat <<- EOF
$PROGNAME ver. $VERSION
Bash scripts template generator.

$(usage)

Otions:
-h, --help          Display this help message.

Arguments:
script_name         New script name.

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
        -q | --quiet)
            QUIET=1
            ;;
        -o | --output)
            shift
            OUTPUT_DIR="$1"
            ;;
        -t | --templates)
            shift
            TEMPLATES_DIR="$1"
            ;;
        -* | --*)
            usage >&2
            error_exit "Unknown option $1"
            ;;
        *)
            SCRIPT_NAME="$1"
            ;;
    esac
    shift
done

set_up

[[ -z "$SCRIPT_NAME" ]] && error_exit "Mandatory argument 'script_name' not given."
[[ -f "$TEMPLATES_DIR/new_script_template.sh" ]] || error_exit "Template not found in given template directory."
cp "$TEMPLATES_DIR/new_script_template.sh" "$OUTPUT_DIR/$SCRIPT_NAME"  # TODO: hardcode path not good.
chmod +x "$OUTPUT_DIR/$SCRIPT_NAME"

graceful_exit

