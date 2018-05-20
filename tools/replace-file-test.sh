#!/bin/sh
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

export TestNumber=0
SizeMustBe=$(du -sb sample-file.txt | awk '{printf $1}')
Restore_Pattern_Text=$(msr -p replace-file-test.bat -it "^SET\s+Restore_Pattern_Text=(.+)" -o '$1' -PAC)
Restore_Pattern_New_Line=$(msr -p replace-file-test.bat -it "^SET\s+Restore_Pattern_New_Line=(.+)" -o '$1' -PAC)

# echo Restore_Pattern_Text=$Restore_Pattern_Text
# echo Restore_Pattern_New_Line=$Restore_Pattern_New_Line

function Restore_To_Another_File() {
    cp -ap sample-test.txt sample-test-restore.txt   >/dev/null
    echo $msrThis -p sample-test-restore.txt $Restore_Pattern_Text -Rc | msr -XA  >/dev/null
    echo $msrThis -p sample-test-restore.txt $Restore_Pattern_New_Line -Rc | msr -XA  >/dev/null
}

function Repro_Error_Replacing() {
    cp -ap sample-file.txt sample-test.txt  >/dev/null
    echo $msrThis $@ | msr -XA  >/dev/null
    echo Error test: msr $@ | msr -aPA -e "((msr.+))" -t "((Error \S+))"
    # echo You can try: msr $@ | msr -aPA -x sample-test.txt -o sample-test-restore.txt | msr -aPA -e "(msr.+)" -t "((You.*?try:))"
    echo Full retry: cp -ap sample-file.txt sample-test.txt AND msr $@ AND nin sample-file.txt sample-test.txt | msr -aPA -x AND -o ";" -e "copy.*?\s+&|((msr.*?))\s+&|bcompare.*txt" -t "((Full retry:))"

    echo Test-$TestNumber failed: msr $@ | msr -aPA -it "(Test-.*failed)" -e "((msr.+))"
    cp -ap sample-file.txt sample-test-restore.txt  >/dev/null
    # Check and exit by file content , then by file size
    nin sample-file.txt sample-test-restore.txt
    unix2dos sample-test-restore.txt 2>/dev/null
    restoredFileSize=$(du -sb sample-test-restore.txt | awk '{printf $1}')
    if (( $restoredFileSize != $SizeMustBe )); then
        echo "sample-test-restore.txt size is $restoredFileSize not equal $SizeMustBe" | msr -t .+
    fi
    echo Test-$TestNumber failed: msr $@ | msr -aPA -it "(Test-.*failed)" -e "(msr.+)"
    exit -1
}

function Replace_And_Check() {
    TestNumber=$(($TestNumber + 1))
    if [ -n "$Specified_Test_Number" ] && [ "$Specified_Test_Number" != "$TestNumber" ]; then
        echo Skip Test-$TestNumber: msr $@ | msr -aPA -e "Skip \w+" -t "(?<=Test-)\d+"
        return
    fi
    echo Test-Replace-File-And-Verify-$TestNumber: msr $@ | msr -aPA -x Test-Replace-File- -e "Verify|((msr.+))" -t "And|(?<=-)\d+(?:)"
    # Copy -> replace -> restore -> compare
    cp -ap sample-file.txt sample-test.txt  >/dev/null
    #args=$(echo $@ | msr -x '"' -o '\"' -PAC)
    echo "$msrThis $@" | msr -XMI  >/dev/null
    Restore_To_Another_File #  >/dev/null
    # bcompare sample-test.txt sample-test-restore.txt
    nin sample-file.txt sample-test-restore.txt -O # || ( Repro_Error_Replacing $@ ; exit -1 )
    if [ "$?" -ne 0 ]; then
        Repro_Error_Replacing $@
        exit -1
    fi

    nin sample-file.txt sample-test-restore.txt -S -O # || ( Repro_Error_Replacing $@ ; exit -1 )
    if [ "$?" -ne 0 ]; then
        Repro_Error_Replacing $@
        exit -1
    fi

    unix2dos sample-test-restore.txt 2>/dev/null
    restoredFileSize=$(du -sb sample-test-restore.txt | awk '{printf $1}')
    if [ "$restoredFileSize" -ne $SizeMustBe ]; then
        echo Failed validation: sample-test-restore.txt size = $restoredFileSize not $SizeMustBe
        Repro_Error_Replacing $@
        exit -1
    fi
}

$msrThis -p replace-file-test.bat -t "^call :Replace_And_Check\s+(.+?)(\s*\|\|.+)?\s*$" -o '$1' -PAC |
    while IFS= read -r cmdLine ; do
        Replace_And_Check $cmdLine || exit $?
    done
