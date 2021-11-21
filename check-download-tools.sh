#!/bin/bash
#================================================================
# Initialize tools.
# Latest version in: https://github.com/qualiu/msrTools
#================================================================
ThisDir="$( cd "$( dirname "$0" )" && pwd )"

function show_error() {
    echo "$1" | GREP_COLOR='01;31' grep -E .+ --color=always 1>&2
}

function show_info() {
    echo "$1" | GREP_COLOR='01;32' grep -E .+ --color=always
}

function show_warning() {
    echo "$1" | GREP_COLOR='01;33' grep -E .+ --color=always
}

function exit_error() {
    show_error "$1"
    exit 1
}

SYS_ARCH=$(uname -m)
SYS_TYPE=$(uname -s | sed 's/_.*//g' | awk '{print tolower($0)}')

if [ "$SYS_TYPE" == "darwin" ]; then
    toolExtension="-$SYS_ARCH.$SYS_TYPE"
elif [ "$SYS_TYPE" == "linux" ]; then
    toolExtension=.gcc48
elif [ "$SYS_TYPE" == "cygwin" ]; then
    toolExtension=.cygwin
else
    exit_error "Unknow system type: $(uname -smr)"
    exit -1
fi

check_tool() {
    toolName=$1
    # toolPath=$(whereis $toolName 2>/dev/null | msr -t "^.*?:\s*(\S+?${toolName}\S*).*" -o '$1' -PAC 2>/dev/null | tr -d '\r')
    toolPath=$(which $toolName)
    if [ -f "$toolPath" ]; then
        show_info "Skip downloading $toolName, already exists: $toolPath"
        return
    fi

    toolPath=$ThisDir/$toolName$toolExtension
    if [ ! -f $ThisDir/$toolName$toolExtension ]; then
        wget "https://github.com/qualiu/msr/blob/master/tools/$toolName$toolExtension?raw=true" -O $toolPath.tmp \
            && mv -f $toolExtension.tmp $toolExtension \
        || exit_error "Failed to download $toolName$toolExtension"
    fi

    if [ ! -x $toolPath ]; then
        chmod +x $toolPath
    fi

    if [ "$toolName" == "msr" ]; then
        export msr=$toolPath
        alias msr=$toolPath
    else
        export nin=$toolPath
        alias nin=$toolPath
    fi
}

check_tool msr
check_tool nin
