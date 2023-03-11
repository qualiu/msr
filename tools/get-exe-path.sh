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

SYS_ARCH=$(uname -m | awk '{print tolower($0)}')
SYS_TYPE=$(uname -s | sed 's/[_-].*//g' | awk '{print tolower($0)}')
DEFAULT_SUFFIX="-$SYS_ARCH.$SYS_TYPE"

if [ "$SYS_TYPE" == "darwin" ] || [ "$SYS_ARCH" == "aarch64" ]; then
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

exePath=$ThisDir/$ExeName$toolSuffix
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
