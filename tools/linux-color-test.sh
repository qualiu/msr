#!/bin/bash
# For example of msr.gcc48, just replace the windows test command and execute them by -X
ThisDir="$( cd "$( dirname "$0" )" && pwd )"
cd "$(dirname $0)"
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
    nin=$(basename $nin)
    if [ !-f "$nin" ]; then
        echo "Not exist nin nor $nin"
        exit /b -1
    fi
fi

alias msr=$msr
alias nin=$nin

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
        echo Tests failed in $0 | $msr -aPA -t "($0)|\w+"
    fi
elif [ $diff -eq 0 ]; then
    rm tmp-linux-color-test.log
    echo Passed all tests in $0 | $msr -aPA -e "($0)|\w+"
fi
