#!/bin/sh
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
    msrThis=$ThisDir/msr.cygwin
elif [ -n "$(uname -o | grep -ie Linux)" ]; then
    if [ -n "$(uname -m | grep 64)" ]; then
        msrThis=$ThisDir/msr.gcc48
    else
        msrThis=$ThisDir/msr-i386.gcc48
    fi
else
    echo "Unknow system type: $(uname -a)"
    exit -1
fi

if [ -f $msrThis ]; then
    chmod +x $msrThis
else
    msrThis=$(basename $msrThis)
fi


ninThis=$($msrThis -z "$msrThis" -t 'msr([^/]*?\.\w+)$' -o 'nin$1' -PAC)
if [ -f $ninThis ]; then
    chmod +x $ninThis
else
    ninThis=$(basename $ninThis)
fi

alias msr=$msrThis
alias nin=$ninThis

cd $ThisDir

alias msr=$msrThis
if [ "$md5Existed" = "$md5This" ] && [[ -x $msrExisted ]] && [ -z "$SleepSeconds" ] ; then
    # msr -p example-commands.bat -x %~dp0\\ -o "" -iq "^::.*Stop" --nt "^::" | msr -t "-o\s+.*-R" -x '"' -o "'" -a -X
    msr -p example-commands.bat -i -q "stop" -x "msr -c -p" -t "%~dp0\\\\?" -o './' -PAC --nt "-o\s+.*\s+-R" | msr -t '-o\s+\"(\$\d)\"' -o " -o '\1'" -aPAC -X
else
    msr -p example-commands.bat -i -q "stop" -x "msr -c -p" -t "%~dp0\\\\?" -o './' -PAC --nt "-o\s+.*\s+-R" | msr  -t '-o\s+\"(\$\d)\"' -o " -o '\1'" -aPAC | msr -t "^msr" -o "$msrThis" -PAC |
    while IFS= read -r cmdLine ; do
        echo $cmdLine | msr -aPA -e "(.+)"
        sh -c "$cmdLine"
        if(($SleepSeconds > 0)); then
            sleep $SleepSeconds
        fi
    done
fi
