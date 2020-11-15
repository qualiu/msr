#!/bin/bash
ThisDir="$( cd "$( dirname "$0" )" && pwd )"
cd "$(dirname $0)"

msr=$(bash $ThisDir/get-exe-path.sh msr 1)
if [ ! -f "$msr" ]; then
    echo "Not found msr as above." >&2 ; 
    exit -1
fi

$msr -c -l --wt --sz -H 5 -T 5 -p /home/../usr/bin/ -f "bash|grep"
$msr -c -l --wt --sz -H 5 -T 5 -p /home/../usr/bin/ -f "bash|grep" -W
$msr -c -l --wt --sz -H 5 -T 5 -p . -f "bash|grep"
$msr -c -l --wt --sz -H 5 -T 5 -p . -W -f "bash|grep"
$msr -c -l --wt --sz -H 5 -T 5 -p ./ -f "bash|grep"
$msr -c -l --wt --sz -H 5 -T 5 -p ./ -W -f "bash|grep"
$msr -c -l --wt --sz -H 5 -T 5 -p ~/ -f "bash|grep"
$msr -c -l --wt --sz -H 5 -T 5 -p ~/ -W -f "bash|grep"
$msr -c -l --wt --sz -H 5 -T 5 -p /usr/bin/ -f "bash|grep"
$msr -c -l --wt --sz -H 5 -T 5 -p /usr/bin/ -f "bash|grep" -W
$msr -c -l --wt --sz -H 5 -T 5 -p /home/../usr/bin/ -f "bash|grep"
$msr -c -l --wt --sz -H 5 -T 5 -p /home/../usr/bin/ -f "bash|grep" -W
$msr -c -l --wt --sz -H 3 -p /bin -f "bash|grep"
$msr -c -l --wt --sz -H 3 -p /bin -W -f "bash|grep"
$msr -c -l --wt --sz -H 3 -p /usr/bin -f "bash|grep"
$msr -c -l --wt --sz -H 3 -p /usr/bin -W -f "bash|grep"

if [ -d /cygdrive/c/ ]; then
    $msr -c -l --wt --sz -H 3 -p /cygdrive/c/
    $msr -c -l --wt --sz -H 3 -p /cygdrive/c/ -W
fi
