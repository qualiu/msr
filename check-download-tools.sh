#!/bin/bash
#================================================================
# Initialize tools.
# Latest version in: https://github.com/qualiu/msrTools
#================================================================
ThisDir="$( cd "$( dirname "$0" )" && pwd )"
SYS_TYPE=$(uname | sed 's/_.*//g' | awk '{print tolower($0)}')
if [ "$SYS_TYPE"x = "linux"x ]; then
    export toolExtension=.gcc48
elif [ "$SYS_TYPE"x = "cygwin"x ]; then
    export toolExtension=.cygwin
else
    echo "Unknow system type: $SYS_TYPE"
    exit -1
fi

check_tool() {
    toolName=$1
    toolPath=$(whereis $toolName 2>/dev/null | msr -t "^.*?:\s*(\S+?${toolName}\S*).*" -o '$1' -PAC 2>/dev/null | tr -d '\r')
    if [ -z "$toolPath" ] || [ ! -f $toolPath ]; then
        toolPath=$ThisDir/$toolName$toolExtension
        if [ ! -f $ThisDir/$toolName$toolExtension ]; then
            wget "https://github.com/qualiu/msr/blob/master/tools/$toolName$toolExtension?raw=true" -O $toolPath
        fi
        
        # echo "toolPath=$toolPath"
        if [[ ! -x $toolPath ]]; then
           chmod +x $toolPath
        fi
        
        if [ "$toolName" == "msr" ]; then
            export msr=$toolPath
            alias msr=$toolPath
        else
            export nin=$toolPath
            alias nin=$toolPath
        fi
    fi
}

check_tool msr
check_tool nin
