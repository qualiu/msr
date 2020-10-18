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

# 1. find in current folder
if [ -n "$(uname -o | grep -ie Cygwin)" ]; then
    exePath=$ThisDir/$ExeName.cygwin
elif [ -n "$(uname -o | grep -ie Linux)" ]; then
    if [ -n "$(uname -m | grep 64)" ]; then
        exePath=$(ls $ThisDir/$ExeName.gcc* | sort | head -n 1)
    else
        exePath=$(ls $ThisDir/$ExeName-i386.gcc* | sort | head -n 1)
    fi
else
    echo "$0 : Unknown system type: $(uname -a)" | egrep -E --color=auto ".+" >&2
    exit -1
fi

# 2. find in system or alias
if [ ! -f "$exePath" ]; then
    if [ -n "$(whereis $ExeName 2>/dev/null)" ]; then
        exePath=$(whereis $ExeName | sed -r 's/.*?:\s*(\S+).*/\1/')
    elif [ -n "$(alias $ExeName)" ]; then
        exePath=$(alias $ExeName | sed -r 's/.*?=\s*(\S+).*/\1/')
    fi
fi

if [ ! -f "$exePath" ]; then
    echo "$0: Not found $ExeName" | egrep -E --color=auto ".+" >&2
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
