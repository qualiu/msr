#!/bin/bash
# For example of msr.gcc48, just replace the windows test command and execute them by -X
ThisDir="$( cd "$( dirname "$0" )" && pwd )"
cd "$(dirname $0)"

msr=$(bash $ThisDir/get-exe-path.sh msr 1)
nin=$(bash $ThisDir/get-exe-path.sh nin 1)
if [ ! -f "$msr" ] || [ ! -f "$nin" ]; then
    echo "Not found msr or nin as above." >&2
    exit -1
fi

$msr -p ./example-commands.bat -i -q "stop" -t "msr -c -p %~dp0\\\\?" -o "$msr -c -p ./" --nt "-o\s+.*\s+-R" -PAC | $msr -t "\s+-P(\w*)" -o '$1' -aPAC | $msr -t "\s+-(\w*)A(\w*)" -o ' -$1$2' -aPAC | $msr -t "($msr -c)" -o '$1 -PA' -aXIM > tmp-linux-color-test.log

$msr -p color-group-test.cmd -t "^msr" -o $msr --nx dp0 -XIM >> tmp-linux-color-test.log

$msr -p tmp-linux-color-test.log -t "^.*?(Run-Command\S*).*? = (\S*msr.*)" -o '$1 = $2' -R -c

$msr -p tmp-linux-color-test.log -x $msr -o msr -R -c

if [ -n "$(echo $msr | grep cygwin)" ]; then
    where bcompare >/dev/null 2>/dev/null
    export noBCompare=$?
fi

$nin base-linux-color-test.log tmp-linux-color-test.log
diff=$?
if [ $? -ne 0 ] && [ "$noBCompare" = "0" ]; then
    bcompare base-linux-color-test.log tmp-linux-color-test.log /fv="Text Compare" &
fi

$nin base-linux-color-test.log tmp-linux-color-test.log -S
diff=$(($diff + $?))
if [ $diff -ne 0 ]; then
    if [ "$noBCompare" = "0" ]; then
        bcompare base-linux-color-test.log tmp-linux-color-test.log /fv="Text Compare" &
    else
        echo Tests failed in $0 as above. | $msr -aPA -t "($0)|\w+"
    fi
elif [ $diff -eq 0 ]; then
    rm tmp-linux-color-test.log
    echo Passed all tests in $0 | $msr -aPA -e "($0)|\w+"
fi
