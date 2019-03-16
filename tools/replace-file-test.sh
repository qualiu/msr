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

cd $ThisDir

cp -ap sample-file.txt sample-test-restore.txt  >/dev/null
unix2dos sample-test-restore.txt 2>/dev/null
SizeMustBe=$(du -sb sample-test-restore.txt | awk '{printf $1}')

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
    alias msr=$msr
    alias nin=$nin
    cp -ap sample-file.txt sample-test.txt  >/dev/null
    echo $msr $@ | msr -XA  >/dev/null
    echo Error test: msr $@ | msr -aPA -e "((msr.+))" -t "((Error \S+))"
    # echo You can try: msr $@ | msr -aPA -x sample-test.txt -o sample-test-restore.txt | msr -aPA -e "(msr.+)" -t "((You.*?try:))"
    echo Full retry: cp -ap sample-file.txt sample-test.txt AND msr $@ AND $msr -p sample-test.txt $Restore_Pattern_Text -RO AND $msr -p sample-test.txt $Restore_Pattern_New_Line -RO AND nin sample-file.txt sample-test.txt | msr -aPA -x AND -o ";" -e "copy.*?\s+&|((msr.*?))\s+&|bcompare.*txt" -t "((Full retry:))"

    echo Test-$TestNumber failed: msr $@ | msr -aPA -it "(Test-.*failed)" -e "((msr.+))"
    cp -ap sample-file.txt sample-test-restore.txt  >/dev/null
    unix2dos sample-test-restore.txt 2>/dev/null

    # Check and exit by file content , then by file size
    $nin sample-test.txt sample-test-restore.txt

    restoredFileSize=$(du -sb sample-test-restore.txt | awk '{printf $1}')
    if (( $restoredFileSize != $SizeMustBe )); then
        echo "sample-test-restore.txt size is $restoredFileSize not equal $SizeMustBe of sample-file.txt" | msr -aPA -t "((\d+)|\S+.txt)|\w+"
    fi
    echo Test-$TestNumber failed: msr $@ | msr -aPA -it "(Test-.*failed)" -e "(msr.+)"
    exit -1
}

function Replace_And_Check() {
    alias msr=$msr
    alias nin=$nin
    TestNumber=$(($TestNumber + 1))
    if [ -n "$Specified_Test_Number" ] && [ "$Specified_Test_Number" != "$TestNumber" ]; then
        echo Skip Test-$TestNumber: msr $@ | $msr -aPA -e "Skip \w+" -t "(?<=Test-)\d+"
        return
    fi

    echo Test-Replace-File-And-Verify-$TestNumber: msr $@ | $msr -aPA -x Test-Replace-File- -e "Verify|((msr.+))" -t "And|(?<=-)\d+(?:)"

    # Copy -> replace -> restore -> compare
    cp -ap sample-file.txt sample-test.txt >/dev/null

    echo "$msr $@" | $msr -XMI  >/dev/null
    Restore_To_Another_File #  >/dev/null

    $nin sample-file.txt sample-test-restore.txt -O
    if [ "$?" -ne 0 ]; then
        Repro_Error_Replacing $@
        exit -1
    fi

    $nin sample-file.txt sample-test-restore.txt -S -O
    if [ "$?" -ne 0 ]; then
        Repro_Error_Replacing $@
        exit -1
    fi

    unix2dos sample-test-restore.txt 2>/dev/null
    #diff sample-file.txt sample-test-restore.txt

    restoredFileSize=$(du -sb sample-test-restore.txt | awk '{printf $1}')
    if [ "$restoredFileSize" -ne $SizeMustBe ]; then
        echo Failed to validate: sample-test-restore.txt size = $restoredFileSize not $SizeMustBe of sample-file.txt | msr -aPA -t "((\d+)|\S+.txt)|\w+"
        Repro_Error_Replacing $@
        exit -1
    fi
}

$msr -p replace-file-test.bat -t "^call :Replace_And_Check\s+(.+?)(\s*\|\|.+)?\s*$" -o '$1' -PAC |
    while IFS= read -r cmdLine ; do
        Replace_And_Check $cmdLine || exit $?
    done

if [ $? -eq 0 ]; then
    echo Passed all tests in $0 | $msr -aPA -e "($0)|\w+"
fi

rm sample-test-restore.txt sample-test.txt 2>/dev/null >/dev/null
