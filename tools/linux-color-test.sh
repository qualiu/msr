#!/bin/bash
# For example of msr.gcc48, just replace the windows test command and execute them by -X
ThisDir="$( cd "$( dirname "$0" )" && pwd )"
cd "$(dirname $0)"
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
    exit -1
}

msr=$(bash $ThisDir/get-exe-path.sh msr 1)
nin=$(bash $ThisDir/get-exe-path.sh nin 1)
if [ ! -f "$msr" ] || [ ! -f "$nin" ]; then
    exit_error "Not found msr or nin as above."
fi

export MSR_USE_BRIGHT_COLOR=0

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
        exit_error "Tests failed in $0 as above."
    fi
elif [ $diff -eq 0 ]; then
    rm tmp-linux-color-test.log
    show_info "Passed all tests in $0"
    exit 0
fi
