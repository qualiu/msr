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
cd $ThisDir

msr=$(bash $ThisDir/get-exe-path.sh msr 1)
nin=$(bash $ThisDir/get-exe-path.sh nin 1)
if [ ! -f "$msr" ] || [ ! -f "$nin" ]; then
    echo "Not found msr or nin as above." >&2
    exit -1
fi

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
