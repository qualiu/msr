#!/bin/bash
# For example of msr.gcc48, just replace the windows test command and execute them by -X
if [ -z "$1" ]; then
    echo "Usage:  exe-name [show-path](default: 0) [not-check-set-executable](default: 0)"
    echo "Example: msr"
    echo "Example: nin 1"
    exit 0
fi

ThisDir="$( cd "$( dirname "$0" )" && pwd )"
cd "$(dirname $0)"
ExeName=$1
ShowPath=$2
NotCheckSetExecutable=$3

SYS_TYPE=$(uname -s | sed 's/[_-].*//g' | awk '{print tolower($0)}')

# 1. find in current folder
if [ -n "$(uname -s | grep -i Darwin)" ]; then
    suffix="-$(uname -m).$SYS_TYPE"
    exePath=$ThisDir/$ExeName$suffix
elif [ -n "$(uname -s | grep -i '^Cygwin')" ]; then
    exePath=$ThisDir/$ExeName.cygwin
elif [ -n "$(uname -s | grep -i '^Linux')" ]; then
    if [ -n "$(uname -m | grep 64)" ]; then
        exePath=$(ls $ThisDir/$ExeName.gcc* | sort | head -n 1)
    else
        exePath=$(ls $ThisDir/$ExeName-i386.gcc* | sort | head -n 1)
    fi
elif [ -n "$(uname -s | grep -i -E '^MINGW')" ]; then
    # exePath=$ThisDir/$ExeName.exe
    echo "$0 : Not support MinGW test." | grep -E --color=always ".+" >&2
    exit -1
else
    echo "$0 : Unknown system type: $(uname -a)" | grep -E --color=always ".+" >&2
    exit -1
fi

# 2. find in system or alias
if [ ! -f "$exePath" ]; then
    if [ -n "$(which $ExeName 2>/dev/null)" ]; then
        exePath=$(which $ExeName) # | sed -r 's/.*?:\s*(\S+).*/\1/')
    elif [ -n "$(alias $ExeName)" ]; then
        exePath=$(alias $ExeName | sed -r 's/.*?=\s*(\S+).*/\1/')
    fi
fi

if [ ! -f "$exePath" ]; then
    echo "$0: Not found $ExeName" | grep -E --color=auto ".+" >&2
    exit -1
fi

echo $exePath
if [ ! -x $exePath ] && [ "$NotCheckSetExecutable" != "1" ]; then
    echo "$0: Will set executable: $exePath" >&2
    chmod +x $exePath
fi

if [ "$ShowPath" = "1" ]; then
    echo "Found $ExeName at: $exePath" >&2
fi

exit 0
