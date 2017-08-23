#!/bin/sh
#==================================================================
# Check and fix file style.
# Latest version in: https://github.com/qualiu/msrTools
#==================================================================

ThisDir="$( cd "$( dirname "$0" )" && pwd )"
SYS_TYPE=$(uname | sed 's/_.*//g' | awk '{print tolower($0)}')

sh $ThisDir/check-download-tools.sh
if [ $? -ne 0 ]; then
    echo "Failed to call $ThisDir/check-download-tools.sh"
    exit -1
fi

if [ -z "$1" ]; then
    echo "Usage  : $0  Files-or-Directories  [options]"
    echo "Example: $0  my.cpp"
    echo "Example: $0  \"my.cpp,my.ps1,my.bat\""
    echo "Example: $0  directory-1"
    echo "Example: $0  \"directory-1,file2,directory-3\""
    echo "Example: $0  \"directory-1,file2,directory-3\" -r"
    echo "Example: $0  \$PWD -r"
    echo "Example: $0  . -r --nf \"\.(log|md|exe|cygwin|gcc\w*|txt)$\""
    echo "Example: $0  . -r -f \"\.(bat|cmd|ps1|sh)$\" --nd \"^(target|bin)$\""
    echo "Should not use --np and --pp as used by this; and -p also used." | msr -PA -t "\s+(-\S+)|\w+"
    exit -1
fi

PathToDo=$1
msrOptions=${@:2}

for ((k = 2; k <= $#; k++)) ; do
    if [ "${!k}" = "-f" ]; then
        hasFileFilter=1
    fi
done

if [ -z "${msrOptions[@]}" ]; then
    msrOptions=("--nd" "^\.git$")
else
    msrOptions=(${msrOptions[@]} "--np" "[\\\\/]*(\.git)[\\\\/]")
fi

# if path has one directory, add file filter
if [ ! -f "$PathToDo" ]; then
    if [ "$hasFileFilter" != "1" ]; then
        FileFilter=("-f" "\.(c|cpp|cxx|h|hpp|cs|java|scala|py|bat|cmd|ps1|sh)$")
    else
        FileFilter=("--pp" "\.(c|cpp|cxx|h|hpp|cs|java|scala|py|bat|cmd|ps1|sh)$")
    fi
fi

echo "## Remove white spaces at each line end" | msr -PA -e .+
msr ${msrOptions[@]} -p $PathToDo ${FileFilter[@]} -it "(\S+)\s+$" -o '$1' -R -c Remove white spaces at each line end.

# echo "## Add a tail new line to files" | msr -PA -e .+
# msr ${msrOptions[@]} -p $PathToDo -S -t "(\S+)$" -o '$1\n' -R -c Add a tail new line to files.

echo "## Add/Delete to have only one tail new line in files" | msr -PA -e .+
msr ${msrOptions[@]} -p $PathToDo ${FileFilter[@]} -S -t "(\S+)\s*$" -o '$1\n' -R -c Add a tail new line to files.

echo "## Convert tab at head of each lines in a file, util all tabs are replaced." | msr -aPA -e .+
function ConvertTabTo4Spaces() {
    if [ -d $PathToDo ]; then
        msr ${msrOptions[@]} -p $PathToDo ${FileFilter[@]} -it "^(\s*)\t" -o '$1    ' -R -c Covert TAB to 4 spaces.
    else
        msr ${msrOptions[@]} -p $PathToDo -it "^(\s*)\t" -o '$1    ' -R -c Covert TAB to 4 spaces.
    fi
    
    if (($? > 0)); then
        ConvertTabTo4Spaces
    fi
}

ConvertTabTo4Spaces


echo "## Convert line ending style from CR LF to LF for Linux files" | msr -PA -e .+
FileFilterForLinuxLineEnding=("-f" "^makefile$|\.sh$|\.mak\w*$")
if [ "$hasFileFilter" = "1" ]; then
    FileFilterForLinuxLineEnding=("--pp" "[\\\\/]*makefile$|\.sh$|\.mak\w*$")
fi
msr ${msrOptions[@]} -p $PathToDo ${FileFilterForLinuxLineEnding[@]} -l -PICc | msr -t ".+" -o 'dos2unix \"$0\"' -XA

echo "## Convert line ending style from LF to CR LF for Windows files" | msr -PA -e .+
FileFilterForWindowsLineEnding=("-f" "\.(bat|cmd|ps1)$")
if [ "$hasFileFilter" = "1" ]; then
    FileFilterForWindowsLineEnding=("--pp" "\.(bat|cmd|ps1)$")
fi
msr ${msrOptions[@]} -p $PathToDo ${FileFilterForWindowsLineEnding[@]} -l -PICc | msr -t ".+" -o 'unix2dos \"$0\"' -XA
