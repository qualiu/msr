#!/bin/bash

if [ -z "$3" ] && [ -z "$2" ]; then
    echo "Usage   : $0  Test-file                        Plain-Finding-String   Regex-Pattern             [Optional : Test-times]"
    echo "Example : $0  /cygdrive/d/tmp/large-test.log   Exception              \"[0-9]*Exception[0-9]*\"   3"
    exit -1
fi

if [ ! -e  $1 ];  then
    echo NOT EXIST test file : $1 | msr -PA -t .*
    exit -1
fi

TestFilePath=$1
TestFileDir=$(dirname $1)
TestFileName=$(basename $1)
PlainFinding=$2
RegexFinding=$3

TestTimes=$4
if [ -z "$TestTimes" ]; then
    TestTimes=1
fi

## alias msr=msr.cygwin/msr.gcc* or make link to it : ln -s msr.gcc*/msr.cygwin /usr/bin/msr
msrPath=$(whereis msr | awk '{if (match($0, /msr:\s*(\S+)/, arr)) printf("%s", arr[1]); }')
msrFiles=$(ls $(dirname $0)/../tools/msr* 2>/dev/null)
if [ -z "$msrPath" ]; then
    echo "You should set msr in your path."
    if [ -n "$msrFiles" ]; then
        echo "Just choose your system version msr:"
        echo "$msrFiles"
    fi
    exit
fi

function GetCPUCoresInfo() {
    NumberOfCores=$(wmic CPU GET NumberOfCores /VALUE | tr -d '\r' | awk '{if (match($0, /NumberOfCores=([0-9]+)/, arr)) print arr[1]; }')
    #msr -z "$NumberOfCores" -c
    cpu="$(wmic CPU GET Name /VALUE /VALUE | tr -d '\r' | awk '{if (match($0, /Name\s*=\s*(.+)/, arr)) printf("%s", arr[1]); }')"
    #msr -z "$cpu" -t ".+" -c
    export CPUCoresInfo="$NumberOfCores Cores $cpu"
    #echo "CPUCoresInfo = $CPUCoresInfo"
}

function GetOSVersionBit() {
    export OSVersionBit="$(uname -mors)"
: '
    OSArchitecture=""
    SystemCaption=""
    for line in $(wmic OS GET Caption,OSArchitecture /Value | tr -d '\r' ); do
        pos=$(expr index "$line" "=")
        if(($pos < 1)); then
            continue
        fi
        name=${line:0:$(($pos-1))}
        value=${line:$pos}
        if [ "$name" = "Caption" ]; then
            SystemCaption=$value;
        elif [ "$name" = "OSArchitecture" ] ; then
            OSArchitecture=$value
        fi
    done
    export OSVersionBit="$SystemCaption $OSArchitecture"
    echo "OSVersionBit=$SystemCaption $OSArchitecture"
 '
}

function GetMemoryInfo() {
    TotalMemory=0
    MemoryChannels=0
    ##for line in $(wmic MEMORYCHIP where \(Caption like "Physical Memory" \) GET Capacity,Speed,DeviceLocator /Value | findstr /I /R "[0-9a-z]" ); do
    for line in $(wmic MEMORYCHIP GET Capacity,Speed,DeviceLocator /Value | tr -d '\r' | grep -ie "[0-9a-z]" ); do
        pos=$(expr index "$line" "=")
        name=${line:0:$(($pos-1))}
        value=${line:$pos}
        if [ "$name" = "Capacity" ]; then
            numberMB=$(($value/1024/1024))
            let TotalMemory+=$numberMB
        elif [ "$name" = "Speed" ]; then
            MemorySpeed=$value
        elif [ "$name" = "DeviceLocator" ]; then
            let MemoryChannels+=1
        fi
    done
    declare -a Units=(MB GB TB)
    unitIndex=0
    MemoryNumber=$TotalMemory
    for k in {0..2}; do
        if [ $MemoryNumber -ge 1024 ]; then
            let unitIndex=$k+1
            let MemoryNumber/=1024
            MemoryInfo="$MemoryNumber ${Units[$unitIndex]}"
        fi
    done
    #echo "unitIndex=$unitIndex, FullMemoryInfo=$MemoryInfo/$MemoryChannels Channels/$MemorySpeed Speed"
    export MemoryInfo="$MemoryNumber ${Units[$unitIndex]} RAM"
}

## Paramters : Title, File, pattern , findstr-options, grep-options, msr-options
function Compare_By_File_Pattern_3_Options() {
    #echo "args[$#] = $*"
    echo "$(date +'%F %T') : $1: $3 : $SystemInformation" | msr -PA -e "((((((.+))))))" -it "((((((Plain|Regex|(?<=by : )\S+))))))|Test|small|ignore\s*case|(Windows|Cygin|Linux|Centos|Fedora|UBuntu)\w*\s*(\d+\w*)?"
    echo "Test file info : $TestFileInfo : $1 by findstr / grep / msr ; To find = $3" | msr -t "(\d+\.\d+)" -e "(\d+)|\w+" -PA
    for ((k=1; k <= $TestTimes; k++)); do
        #echo "Test[$k]-$TestTimes : $1 : $3 "
        findstr $4 "$3"    $2      | msr -l -c Read  findstr : $3
        grep    $5 "$3"    $2      | msr -l -c Read  grep : $3
        msr    $6 "$3" -p $2 -PAC | msr -l -c Read  msr : $3
    done
    echo
}

GetOSVersionBit
GetMemoryInfo
GetCPUCoresInfo
export SystemInformation="$OSVersionBit + $MemoryInfo + $CPUCoresInfo"
export TestFileInfo=$(msr -l -t . -p $TestFilePath -H 0 -c Get size and rows -PC | msr -it "^.*read (\d+ lines \d+\S+ \w+).*from (\d+\S+.+?)Checked.*" -o '$1' -PAC)

cd $TestFileDir
if [ -n "$PlainFinding" ]; then Compare_By_File_Pattern_3_Options "Plain text finding"   $TestFileName   "$PlainFinding"    ""       ""   -x  ; fi
if [ -n "$PlainFinding" ]; then Compare_By_File_Pattern_3_Options "Plain ignore case"    $TestFileName   "$PlainFinding"    /I       -i   -ix ; fi
if [ -n "$RegexFinding" ]; then Compare_By_File_Pattern_3_Options "Regex text finding"   $TestFileName   "$RegexFinding"   /R        -e   -t  ; fi
if [ -n "$RegexFinding" ]; then Compare_By_File_Pattern_3_Options "Regex ignore case"    $TestFileName   "$RegexFinding"   "/I /R"   -ie  -it ; fi
