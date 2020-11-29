:: ############################################################################
:: This tool is to find all process by the searching options of the process:
::  ParentProcessId ProcessId Name CommandLine
:: Filter self of msr.exe please append with:
::    --nx msr.exe or --nt msr\.exe
::
:: Output line format, separated by TAB: ParentProcessId ProcessId Name CommandLine
:: [1]: Default: :RowNumber: ParentProcessId ProcessId Name CommandLine
:: [2]: With -P: ParentProcessId ProcessId Name CommandLine
::
:: Latest version in: https://github.com/qualiu/msrTools/
:: ############################################################################

@echo off
SetLocal EnableExtensions EnableDelayedExpansion

where msr.exe 2>nul >nul || if not exist %~dp0\msr.exe powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri https://github.com/qualiu/msr/blob/master/tools/msr.exe?raw=true -OutFile %~dp0\msr.exe"
where msr.exe 2>nul >nul || set "PATH=%~dp0;%PATH%;"

msr -z "LostArg%~1" -t "^LostArg(|-h|--help|/\?)$" > nul || (
    echo To see msr.exe matching options just run: msr --help | msr -PA -ie "options|\S*msr\S*" -x msr
    echo Usage  : %~n0 -t/-x "process-match-options"  -e "to-enhance"  -H "header-lines", ... -P, etc. | msr -aPA -e "\s+-+\w+\s+|-[txP]" -x %~n0
    echo Example: %~n0 -H 9 -T 9 -P  | msr -aPA -e "\s+-+\w+\s+" -x %~n0
    echo Example: %~n0 -it C:\\Windows --nx msr.exe | msr -PA -e "\s+-\w\s+" | msr -aPA -e "\s+-+\w+\s+" -x %~n0
    echo Example: %~n0 -ix C:\Windows -t "java.*" -H 3 --nx C:\Windows\system32 --nt msr\.exe | msr -aPA -e "\s+-+\w+\s+" -x %~n0
    echo Example: %~n0  2030 3021 19980        ---- find processes by id | msr -PA -e "\s+(\d+|\bid\b)" -x %~n0
    exit /b 0
)

:: wmic process get ParentProcessId,ProcessId,Name,CommandLine /FORMAT:csv | msr -it "^(Node|%COMPUTERNAME%)," -o "" -aPAC | msr -t "(.+)?,(.*?),(\d+),(\d+)$" -o "\3 \4 \2 \1" -aPAC
set Command1=wmic process get ParentProcessId,ProcessId,Name,CommandLine /FORMAT:csv
set Command2=msr -it "^(Node|%COMPUTERNAME%)," -o "" -aPAC
set Command3=msr -t "(CommandLine|.*)?,(Name|.*?),(ParentProcessId|\d+),(ProcessId|\d+)$" -o "\3\t\4\t\2\t\1" -aPAC

:: Test args for msr.exe
msr -z justTestArgs %* >nul 2>nul
if %ERRORLEVEL% LSS 0 (
    echo Error parameters for %~nx0: %* , test with: -z justTestArgs: | msr -aPA -t "Error.*for \S+(.*(test with.*(-z (justTestArgs))))"
    msr -z justTestArgs %*
    exit /b -1
)

for /f "tokens=*" %%a in ('echo %* ^| msr -t "^(\d+[\s\d]*)\s*(.*)" -o "\1" -PAC ^| msr -t "\s+(\d+)" -o "|\1" -aPAC ^| msr -t "\s*$" -o "" -aPAC') do (
    set "PidPattern=%%a"
)

if "!PidPattern!" == "" (
    %Command1% | %Command2% | %Command3% | msr %*
    exit /b !ERRORLEVEL!
)

for /f "tokens=*" %%a in ('echo %* ^| msr -t "^(\d+[\s\d]*)\s*(.*)" -o "\2" -PAC') do set OtherArgs=%%a
msr -z %* -t . >nul 2>nul
if !ERRORLEVEL! NEQ -1 (
    set ColorPid=-t "^(!PidPattern!)|(?=\d+\t)(!PidPattern!)"
) else (
    msr -z %* -e .  >nul 2>nul
    if !ERRORLEVEL! NEQ -1 set ColorPid=-e "^(!PidPattern!)|^\d+\t(!PidPattern!)"
)

%Command1% | %Command2% | msr -t ",(!PidPattern!)(,|\s*$)" -PICc | %Command3% | msr !OtherArgs! !ColorPid!
