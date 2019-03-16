#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage:   $0  Sleep-Seconds"
    echo "Example: $0  0"
    echo "Example: $0  3"
    echo "This file leverages test cases in windows-test.bat to test."
    exit -1
fi

# For example of msr.gcc48, just replace the windows test command and execute them by -X
SleepSeconds=$1
ThisDir="$( cd "$( dirname "$0" )" && pwd )"

if [ -n "$(uname -o | grep -ie Cygwin)" ]; then
    msr=$ThisDir/msr.cygwin
elif [ -n "$(uname -o | grep -ie Linux)" ]; then
    if [ -n "$(uname -m | grep 64)" ]; then
        msr=$ThisDir/msr.gcc48
    else
        msr=$ThisDir/msr-i386.gcc48
    fi
else
    echo "Unknown system type: $(uname -a)"
    exit -1
fi

if [ -f "$msr" ]; then
    chmod +x $msr
elif [ -n "$(whereis msr 2>/dev/null)" ]; then
    msr=$(whereis msr | sed -r 's/.*?:\s*(\S+).*/\1/')
elif [ -n "$(alias msr)" ]; then
    msr=$(alias msr | sed -r 's/.*?=\s*(\S+).*/\1/')
else
    msr=$ThisDir/$(basename $msr)
    if [ !-f "$msr" ]; then
        echo "Not exist msr nor $msr"
        exit /b -1
    fi
    chmod +x $msr
fi

nin=$(echo $msr | sed -r 's/msr([^/]*)$/nin\1/')
if [ -f "$nin" ]; then
    chmod +x $nin
else
    nin=$ThisDir/$(basename $nin)
    if [ !-f "$nin" ]; then
        echo "Not exist nin nor $nin"
        exit /b -1
    fi
fi

alias msr=$msr
alias nin=$nin

cd $ThisDir

if [ "$md5Existed" = "$md5This" ] && [[ -x $msrExisted ]] && [ -z "$SleepSeconds" ] ; then
    $msr -p example-commands.bat -i -q "stop" -x "msr -c -p" -t "%~dp0\\\\?" -o './' -PAC --nt "-o\s+.*\s+-R" | $msr -t '-o\s+\"(\$\d)\"' -o " -o '\1'" -aPAC -X
else
    $msr -p example-commands.bat -i -q "stop" -x "msr -c -p" -t "%~dp0\\\\?" -o './' -PAC --nt "-o\s+.*\s+-R" | $msr  -t '-o\s+\"(\$\d)\"' -o " -o '\1'" -aPAC | $msr -t "^msr" -o "$msr" -PAC |
    while IFS= read -r cmdLine ; do
        echo $cmdLine | $msr -aPA -e "(.+)"
        sh -c "$cmdLine"
        if(($SleepSeconds > 0)); then
            sleep $SleepSeconds
        fi
    done
fi
