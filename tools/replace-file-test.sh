#!/bin/bash
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage:   $0  [Test-Number]"
    echo "Example: $0  "
    echo "Example: $0  3"
    echo "This file leverages test cases in replace-file-test.bat to test."
    exit -1
fi

# For example of msr.gcc48, just replace the windows test command and execute them by -X
Specified_Test_Number=$1
ThisDir="$( cd "$( dirname "$0" )" && pwd )"
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
    exit 1
}

cd "$(dirname $0)"
cd $ThisDir
msr=$(bash $ThisDir/get-exe-path.sh msr 1)
nin=$(bash $ThisDir/get-exe-path.sh nin 1)
if [ ! -f "$msr" ] || [ ! -f "$nin" ]; then
    exit_error "Not found msr or nin as above."
fi

alias msr=$msr
alias nin=$nin

which dos2unix && which unix2dos
if [ $? -ne 0 ]; then
    echo Please install dos2unix at first. | $msr -aPA -t "(.+)" >&2
    exit -1
fi

cp -ap sample-file.txt sample-test-restore.txt  >/dev/null
unix2dos sample-test-restore.txt

duArgs="-sb"
uname -s | grep -i Darwin >/dev/null && duArgs="-s"
ExpectedTxtSize=$(du $duArgs sample-test-restore.txt | awk '{printf $1}')
ExpectedJsonSize=$(du $duArgs sample-block-expected-result.json | awk '{printf $1}')

export TestNumber=0
Restore_Pattern_Text=$($msr -p replace-file-test.bat -it "^SET\s+Restore_Pattern_Text=(.+)" -o '$1' -PAC)
Restore_Pattern_New_Line=$($msr -p replace-file-test.bat -it "^SET\s+Restore_Pattern_New_Line=(.+)" -o '$1' -PAC)

echo Restore_Pattern_Text=$Restore_Pattern_Text
echo Restore_Pattern_New_Line=$Restore_Pattern_New_Line

function Restore_To_Another_File() {
    cp -ap sample-test.txt sample-test-restore.txt >/dev/null
    echo $msr -p sample-test-restore.txt $Restore_Pattern_Text -RO | $msr -XM >/dev/null
    echo $msr -p sample-test-restore.txt $Restore_Pattern_New_Line -RO | $msr -XM >/dev/null
}

function Repro_Error_Replacing() {
    cp -ap sample-file.txt sample-test.txt  >/dev/null
    echo $msr $@ | msr -XA  >/dev/null
    echo Error test: msr $@ | $msr -aPA -e "((msr.+))" -t "((Error \S+))"
    echo Full retry: pushd $ThisDir AND cp -ap sample-file.txt sample-test.txt AND msr $@ AND $msr -p sample-test.txt $Restore_Pattern_Text -RO AND $msr -p sample-test.txt $Restore_Pattern_New_Line -RO AND $nin sample-file.txt sample-test.txt | msr -aPA -x AND -o ";" -e "copy.*?\s+&|((msr.*?))\s+&|bcompare.*txt" -t "((Full retry:))"

    echo Test-$TestNumber failed: msr $@ | $msr -aPA -it "(Test-.*failed)" -e "((msr.+))"
    cp -ap sample-file.txt sample-test-restore.txt  >/dev/null
    unix2dos sample-test-restore.txt 2>/dev/null

    # Check and exit by file content , then by file size
    $nin sample-test.txt sample-test-restore.txt

    restoredFileSize=$(du $duArgs sample-test-restore.txt | awk '{printf $1}')
    if (( $restoredFileSize != $ExpectedTxtSize )); then
        echo "sample-test-restore.txt size is $restoredFileSize not equal $ExpectedTxtSize of sample-file.txt" | $msr -aPA -t "((\d+)|\S+.txt)|\w+"
    fi
    echo Test-$TestNumber failed: msr $@ | $msr -aPA -it "(Test-.*failed)" -e "(msr.+)"
    exit -1
}

function Replace_And_Check() {
    export TestNumber=$(($TestNumber + 1))
    if [ -n "$Specified_Test_Number" ] && [ "$Specified_Test_Number" != "$TestNumber" ]; then
        [ $Specified_Test_Number -lt $TestNumber ] && exit 0
        echo Skip Test-$TestNumber: msr $@ | $msr -aPA -e "Skip \w+" -t "(?<=Test-)\d+"
        [ $Specified_Test_Number -gt $TestNumber ] && return 0
    fi

    echo Test-Replace-File-And-Verify-$TestNumber: msr $@ | $msr -aPA -x Test-Replace-File- -e "Verify|((msr.+))" -t "And|(?<=-)\d+(?:)"

    # Copy -> replace -> restore -> compare
    cp -ap sample-file.txt sample-test.txt >/dev/null

    echo "$msr $@" | $msr -XMI  >/dev/null
    Restore_To_Another_File #  >/dev/null

    $nin sample-file.txt sample-test-restore.txt -O || Repro_Error_Replacing $@ || exit -1
    $nin sample-file.txt sample-test-restore.txt -S -O || Repro_Error_Replacing $@ || exit -1

    unix2dos sample-test-restore.txt 2>/dev/null
    restoredFileSize=$(du $duArgs sample-test-restore.txt | awk '{printf $1}')
    if [ "$restoredFileSize" -ne $ExpectedTxtSize ]; then
        echo Failed to validate: sample-test-restore.txt size = $restoredFileSize not $ExpectedTxtSize of sample-file.txt | $msr -aPA -t "((\d+)|\S+.txt)|\w+"
        Repro_Error_Replacing $@
        exit -1
    fi
}

function Show_Json_Error() {
    echo Error test: $msr $@ | $msr -aPA -e "($msr.+)" -t "((Error test))"
    echo Full retry: pushd $ThisDir AND cp -ap sample-block.json sample-block-test.json AND $msr $@ AND $nin sample-block-expected-result.json sample-block-test.json \
        | $msr -aPA -x AND -o ";" -t "Full retry:" -e "(pushd.+)"
    exit -1
}

function Replace_Json_And_Check() {
    export TestNumber=$(($TestNumber + 1))
    if [ -n "$Specified_Test_Number" ] && [ "$Specified_Test_Number" != "$TestNumber" ]; then
        [ $Specified_Test_Number -lt $TestNumber ] && exit 0
        echo Skip Test-$TestNumber: msr $@ | $msr -aPA -e "Skip \w+" -t "(?<=Test-)\d+"
        [ $Specified_Test_Number -gt $TestNumber ] && return 0
    fi

    cp -ap sample-block.json sample-block-test.json >/dev/null
    echo Test-Replace-File-And-Verify-$TestNumber: msr $@ | $msr -aPA -x Test-Replace-File- -e "Verify|((msr.+))" -t "And|(?<=-)\d+(?:)"
    echo "$msr $@" | $msr -XMI >/dev/null

    $nin sample-block-expected-result.json sample-block-test.json -O || Show_Json_Error $@ || exit -1
    $nin sample-block-expected-result.json sample-block-test.json -S -O || Show_Json_Error $@ || exit -1

    unix2dos sample-block-test.json 2>/dev/null
    restoredFileSize=$(du $duArgs sample-block-test.json | awk '{printf $1}')
    if [ "$restoredFileSize" -ne $ExpectedJsonSize ]; then
        echo sample-block-test.json = $restoredFileSize not equal $ExpectedJsonSize of sample-block-expected-result.json | $msr -aPA -t "((\d+)|\S+.txt)|\w+"
        Show_Json_Error $@
        exit -1
    fi
}

$msr -p replace-file-test.bat -t "^call :(?:Replace_Json_And_Check|Replace_And_Check)\s+(.+?)(\s*\|\|.+)?\s*$" -o '$1' -PAC |
    while IFS= read -r cmdLine ; do
        echo $cmdLine | $msr -x sample-block-test.json -H 0 -M #>/dev/null
        if [ $? -eq 1 ]; then
            Replace_Json_And_Check $cmdLine || exit $?
        else
            Replace_And_Check $cmdLine || exit $?
        fi
    done

if [ $? -eq 0 ]; then
    show_info "Passed all tests in $0" # | $msr -aPA -e "($0)|\w+"
fi

rm sample-test-restore.txt sample-test.txt sample-block-test.json 2>/dev/null >/dev/null
