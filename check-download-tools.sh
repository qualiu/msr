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

SYS_ARCH=$(uname -m | awk '{print tolower($0)}')
SYS_TYPE=$(uname -s | sed 's/[_-].*//g' | awk '{print tolower($0)}')
DEFAULT_SUFFIX="-$SYS_ARCH.$SYS_TYPE"

if [ "$SYS_TYPE" == "darwin" ] || [ "$SYS_ARCH" == "aarch64" ] || [ "$DEFAULT_SUFFIX" == "-amd64.freebsd" ]; then
    toolSuffix=$DEFAULT_SUFFIX
elif [ "$SYS_TYPE" == "linux" ]; then
    if [ -n "$(echo "$SYS_ARCH" | grep -iE "i386|i686")" ]; then
        toolSuffix=-i386.gcc48
    else
        toolSuffix=.gcc48
    fi
elif [ "$SYS_TYPE" == "cygwin" ]; then
    toolSuffix=.cygwin
elif [ -n "$(echo "$SYS_TYPE" | grep -iE "MinGW")" ]; then
    toolSuffix=.exe
    echo "WARNING: MinGW is not fully supported: $0" | grep -E --color=always ".+" >&2
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

    toolPath=$ThisDir/$toolName$toolSuffix
    if [ ! -f $ThisDir/$toolName$toolSuffix ]; then
        wget "https://github.com/qualiu/msr/blob/master/tools/$toolName$toolSuffix?raw=true" -O $toolPath.tmp \
            && mv -f $toolPath.tmp $toolPath \
        || exit_error "Failed to download $toolName$toolSuffix"
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
