#!/bin/sh
if [ -z "$1" ]; then
    echo "Usage:   $0  Sleep-Seconds"
    echo "Example: $0  0"
    echo "Example: $0  3"
    exit -1
fi

# For example of msr.gcc48, just replace the windows test command and execute them by -X
SleepSeconds=$1
ThisDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SYS_TYPE=$(uname | sed 's/_.*//g' | awk '{print tolower($0)}')

msrExisted=$(whereis msr 2>/dev/null | msr -t "^.*?:\s*(\S+?msr\S*).*" -o '$1' -PAC 2>/dev/null | tr -d '\r')
if [ -f "$msrExisted" ]; then
    md5Existed=$(md5sum $msrExisted | msr -t "^(\w+\S+).*" -o '$1' -PAC | tr -d '\r')
    if [ ! -x $msrExisted ]; then
        chmod +x $msrExisted
    fi
fi

if [ "$SYS_TYPE"x = "linux"x ]; then
    msrThis=$ThisDir/msr.gcc48
elif [ "$SYS_TYPE"x = "cygwin"x ]; then
    msrThis=$ThisDir/msr.cygwin
else
    echo "Unknow system type: $SYS_TYPE"
    exit -1
fi

chmod +x $msrThis

md5This=$(md5sum $msrThis | msr -t "^(\w+\S+).*" -o '$1' -PAC 2>/dev/null | tr -d '\r')

cd $ThisDir

alias msr=$msrThis
if [ "$md5Existed" = "$md5This" ] && [[ -x $msrExisted ]] && [ -z "$SleepSeconds" ] ; then
    msr -p example-commands.bat -x %~dp0\\ -o "" -q "^::\s*Stop" --nt "^::" | msr -t "-o\s+.*-R" -x '"' -o "'" -a -X
else
    # echo "$msrThis -p example-commands.bat -x %~dp0\\ -o "" -q "^::\s*Stop" --nt "^::" -PAC | $msrThis -t "^\s*msr" -o \"$msrThis\" -aPAC"
    $msrThis -p example-commands.bat -x %~dp0\\ -o "" -q "^::\s*Stop" --nt "^::" -PAC | $msrThis -t "^\s*msr" -o "$msrThis" -aPAC | $msrThis -t '\s+-o\s+\"(\$.*?)\"' -o " -o '\$1'" -aPAC | $msrThis -t '\s+-o\s+\"(msr.*)\"' -o " -o '\$1'" -aPAC |
    while IFS= read -r cmdLine ; do
        sh -c "$cmdLine"
        if(($SleepSeconds > 0)); then
            sleep $SleepSeconds
        fi
    done
fi

sh $ThisDir/../fix-file-style.sh sample-file.txt
unix2dos sample-file.txt
