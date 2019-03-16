:: #############################################
:: Running this script will show you a vivid colorful demo of msr.
:: This script calls the commands/lines in example-commands.bat which can be directly executed.
:: The difference to example-commands.bat is that this script can also :
::  1) Test reading/replacing in files and pipe by following 'Reading from file test' and 'Reading from pipe test'.
::  2) Test -X which executes output lines as commands.
::  3) Compare the 2 above test results with base-windows-file-test.log and base-windows-pipe-test.log.
:: #############################################
@echo off
SetLocal EnableExtensions EnableDelayedExpansion

set ThisDir=%~dp0
if %ThisDir:~-1% == \ set ThisDir=%ThisDir:~0,-1%
set ThisDir2Slash=%ThisDir:\=\\%

where msr.exe 2>nul >nul || if not exist %ThisDir%\msr.exe powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri https://github.com/qualiu/msr/blob/master/tools/msr.exe?raw=true -OutFile %ThisDir%\msr.exe"
where msr.exe 2>nul >nul || set "PATH=%ThisDir%;%PATH%"

where nin.exe 2>nul >nul || if not exist %ThisDir%\nin.exe powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri https://github.com/qualiu/msr/blob/master/tools/nin.exe?raw=true -OutFile %ThisDir%\nin.exe"
where nin.exe 2>nul >nul || set "PATH=%ThisDir%;%PATH%"

if "%~1" == ""       set IsShowUsage=1
if "%~1" == "-h"     set IsShowUsage=1
if "%~1" == "--help" set IsShowUsage=1
if "%~1" == "/?"     set IsShowUsage=1

if "%IsShowUsage%" == "1" (
    echo Usage   : %0  TestMode  [MSR_EXE]   [SleepSeconds]   [BeginTestGroup]   [EndTestGroup]   [ReplaceTo]
    echo Example : %0   0    -- directly test and output on this command window, using msr.
    echo Example : %0   1    -- output to files and compare with base-windows-**.log, using msr.
    echo Example : %0   2    -- output to files and compare with base-windows-**.log, using msr, do not break if one test group failed.
    echo Example : %0   0    msr       3    -- output to window, sleep 3 seconds for each execution.
    echo Example : %0   0    msr-dbg   3
    echo Example : %0   1    msr-dbg   0  4
    echo Example : %0   1    msr-dbg   0  4  4
    exit /b 0
)

msr -p %0 -t "^\s*set /a TestGroupNumber\s*\+\s*=" >nul
set /a TestGroupCount=!ERRORLEVEL!

set /a TestGroupNumber=0
set /a failedGroups=0

set /a TestMode=%1
set MSR_EXE=%2
set SleepSeconds=%3
if "%~4" == "" ( set /a BeginTestGroup=1 ) else ( set /a BeginTestGroup=%~4 )
if "%~5" == "" ( set /a EndTestGroup=!TestGroupCount! ) else ( set /a EndTestGroup=%~5 )
if "%~6" == "" ( set "ReplaceTo=-c" ) else ( set "ReplaceTo=%~6" )

if exist %ThisDir%\Node*.tmp del %ThisDir%\Node*.tmp
for %%a in ("%ThisDir%") do set ParentDir=%%~dpa
if %ParentDir:~-1% == \ set ParentDir=%ParentDir:~0,-1%
set ParentDir2Slash=%ParentDir:\=\\%
set SourceFile=%ThisDir%\example-commands.bat

pushd %ThisDir%

if "%MSR_EXE%" == "" set MSR_EXE=msr
if "%SleepSeconds%" == "" set SleepSeconds=3

for /f "tokens=*" %%a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1__\2.\3\4" -PAC ^| msr -t ":" -o _ -aPAC') do SET "TimeNowMicro=%%a"

set MSR_UNIFY_NAME=msr
:: Check and add tool directory to %PATH% in case of no %MSR_EXE%.exe
%MSR_EXE% -z "%PATH%" -ix "%ThisDir%;" -PAC >nul -- Can also use -H 0 to hide result and -M to hide summary.
if %ERRORLEVEL% LSS 1 SET "PATH=%PATH%;%ThisDir%;"

set StopCalling="::Stop calling"
set FirstReplaceForFile=%MSR_EXE% -it "%MSR_UNIFY_NAME% -c" -o "%MSR_EXE% %ReplaceTo%" -p %SourceFile% --nt "\s+-R\b" -PAC
set FirstReplaceForPipe=%MSR_EXE% -it "%MSR_UNIFY_NAME% -c" -o "%MSR_EXE% %ReplaceTo% -A" -p %SourceFile% --nt "\s+(-R|-PAC|-PIC)\b" -PAC -q "%StopCalling%|stop pipe test"
set ReplaceExeName=%MSR_EXE% -it "\b%MSR_EXE%\s+" -o "%MSR_EXE% " -PAC
::set ReplaceToThisDirMainCmd=%MSR_EXE% -ix "%%~dp0" -o "%ThisDir2Slash%"
set ReplaceToThisDirMainCmd=%MSR_EXE% -ix "%%~dp0" -o %ThisDir% -a

:: Directly test and output result on current command window
if %TestMode% EQU 0 (
    if %SleepSeconds% GTR 0 (
        :: %FirstReplaceForFile% -q %StopCalling%| %ReplaceExeName% | %ReplaceToThisDirMainCmd% -PAC | %MSR_EXE% -t "^.+$" -o "$0 && sleep %SleepSeconds%" -XI
        echo %FirstReplaceForFile%^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd%
        for /F "tokens=*" %%a in ('%FirstReplaceForFile% ^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd% -PAC ') do (
            echo %%a | %MSR_EXE% -XI 2>nul
            :: a trick to sleep
            ping 127.0.0.1 -n %SleepSeconds% -w 1000 > nul 2>nul
            echo.
        )
    )  else (
        echo %FirstReplaceForFile% ^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd%
        %FirstReplaceForFile% | %ReplaceExeName% | %ReplaceToThisDirMainCmd% -I -X
    )

    echo %SourceFile% | %MSR_EXE% -t .+  -o "findstr xml $0" -XI
    %MSR_EXE% -p %SourceFile% -b %StopCalling% -ix "%%~dp0" -o %ThisDir% -a -XI
    popd & exit /b 0
)

set /a TestGroupNumber+=1
echo ################## %TestGroupNumber%-%TestGroupCount%: Test color group begin ##################  | %MSR_EXE% -PA -e .+
if %TestGroupNumber% GEQ %BeginTestGroup% if %TestGroupNumber% LEQ %EndTestGroup% (
    %MSR_EXE% -p %ThisDir%\color-group-test.cmd -x msr -o %MSR_EXE% -aPAC > "%ThisDir%\tmp-color-group-test-%TimeNowMicro%.cmd"
    call "%ThisDir%\tmp-color-group-test-%TimeNowMicro%.cmd" > %ThisDir%\tmp-color-group-test.log
    del "%ThisDir%\tmp-color-group-test-%TimeNowMicro%.cmd"
    call :Compare_Title_Base_TestLog "%TestGroupNumber%-%TestGroupCount%: Test color group" %ThisDir%\base-color-group-test.log %ThisDir%\tmp-color-group-test.log
    if !ERRORLEVEL! NEQ 0 (
        echo ################## %TestGroupNumber%-%TestGroupCount%: Test color group failed ##################  | %MSR_EXE% -PA -t .+
        set /a failedGroups+=1
        if %TestMode% NEQ 2 exit /b -1
    ) else (
        del %ThisDir%\tmp-color-group-test.log
    )
)


set /a TestGroupNumber+=1 & echo. & echo.
echo ################## %TestGroupNumber%-%TestGroupCount%: Replace file and verify begin ##################  | %MSR_EXE% -PA -e .+
if %TestGroupNumber% GEQ %BeginTestGroup% if %TestGroupNumber% LEQ %EndTestGroup% (
    call %ThisDir%\replace-file-test.bat %MSR_EXE%
    if !ERRORLEVEL! NEQ 0 (
        echo ################## %TestGroupNumber%-%TestGroupCount%: Replace file and verify failed ##################  | %MSR_EXE% -PA -t .+
        set /a failedGroups+=1
        if %TestMode% NEQ 2 exit /b -1
    ) else (
        echo ################## %TestGroupNumber%-%TestGroupCount%: Replace file and verify passed ##################  | %MSR_EXE% -PA -e .+
    )
)


set /a TestGroupNumber+=1 & echo. & echo.
echo ################## %TestGroupNumber%-%TestGroupCount%: Test output only replaced ##################  | %MSR_EXE% -PA -e .+
if %TestGroupNumber% GEQ %BeginTestGroup% if %TestGroupNumber% LEQ %EndTestGroup% (
    set onlyOuputReplacedTestLog=test-only-output-replaced-lines.log
    echo %MSR_EXE% -p example-commands.bat -t "^msr -c (.+\s+-o\s+)" --nt "\s+-R" -o "%MSR_EXE% -c -j $1" -PAC ^| %MSR_EXE% -x %%~dp0 -o . -a -X ^> !onlyOuputReplacedTestLog!
    %MSR_EXE% -p example-commands.bat -t "^msr -c (.+\s+-o\s+)" --nt "\s+-R" -o "%MSR_EXE% -c -j $1" -PAC | %MSR_EXE% -x %%~dp0 -o . -a -X > !onlyOuputReplacedTestLog!

    call :Compare_Title_Base_TestLog "%TestGroupNumber%-%TestGroupCount%: Test output only replaced" %ThisDir%\base-!onlyOuputReplacedTestLog! %ThisDir%\!onlyOuputReplacedTestLog!
    if !ERRORLEVEL! NEQ 0 (
        set /a failedGroups+=1
        if %TestMode% NEQ 2 exit /b -1
    ) else (
        del %ThisDir%\!onlyOuputReplacedTestLog!
    )
)



set /a TestGroupNumber+=1 & echo. & echo.
echo ################## %TestGroupNumber%-%TestGroupCount%: Test list files ##################  | %MSR_EXE% -PA -e .+
if %TestGroupNumber% GEQ %BeginTestGroup% if %TestGroupNumber% LEQ %EndTestGroup% (
    set listFilesTestLog=test-list-files.log
    set extractListTestCmd=-p %ThisDir%\test-list-files.cmd -x "%%~dp0" -o %ThisDir% -PAC
    set replaceExeCmd=-t "^\S+" -o "%MSR_EXE%"
    echo %MSR_EXE% !extractListTestCmd! ^| %MSR_EXE% !replaceExeCmd! -X ^> !listFilesTestLog!
    call %MSR_EXE% !extractListTestCmd! | %MSR_EXE% !replaceExeCmd! -X > !listFilesTestLog!
    %MSR_EXE% -z "" -t .* -o "\n\n\n" -PAC >> !listFilesTestLog!
    echo %MSR_EXE% !extractListTestCmd! ^| %MSR_EXE% !replaceExeCmd! -PAC ^| %MSR_EXE% -t "\s*(--wt|--sz)\s*" -o " " -X ^>^> !listFilesTestLog!
    call %MSR_EXE% !extractListTestCmd! | %MSR_EXE% !replaceExeCmd! -PAC | %MSR_EXE% -t "\s*(--wt|--sz)\s*" -o " " -X >> !listFilesTestLog!

    call :Compare_Title_Base_TestLog "%TestGroupNumber%-%TestGroupCount%: Test list files" %ThisDir%\base-!listFilesTestLog! %ThisDir%\!listFilesTestLog!
    if !ERRORLEVEL! NEQ 0 (
        set /a failedGroups+=1
        if %TestMode% NEQ 2 exit /b -1
    ) else (
        del %ThisDir%\!listFilesTestLog!
    )
)


set /a TestGroupNumber+=1 & echo. & echo.
echo ################## %TestGroupNumber%-%TestGroupCount%: Reading from file test begin ##################  | %MSR_EXE% -PA -e .+
if %TestGroupNumber% GEQ %BeginTestGroup% if %TestGroupNumber% LEQ %EndTestGroup% (
    set fileTestLog=file-test-result-on-windows.log
    if exist !fileTestLog! del !fileTestLog!
    echo %FirstReplaceForFile% ^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd% -PIC ^| %MSR_EXE% --nx Node1.tmp
    for /F "tokens=*" %%a in ('%FirstReplaceForFile% ^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd% -PIC ^| %MSR_EXE% --nx Node1.tmp -PAC') do (
        echo %%a >> !fileTestLog!
        %%a >> !fileTestLog!
        echo Return-Value = !ERRORLEVEL! : %%a >> !fileTestLog!
        ::%%a --verbose 2>&1 | %MSR_EXE% -it "^(Return\s*=\s*\d+).*" -o "$1" -T 1 -PAC >> !fileTestLog!
        echo.>> !fileTestLog!
    )

    echo.>>!fileTestLog!
    echo echo %SourceFile% ^| %MSR_EXE% -t .+  -o "findstr xml $0" -XA >> !fileTestLog!
    echo %SourceFile% | %MSR_EXE% -t .+  -o "findstr xml $0" -XA >>  !fileTestLog!

    echo.>>!fileTestLog! & echo.>>!fileTestLog!
    echo %MSR_EXE% -p %SourceFile% -b %StopCalling% --nt %StopCalling% -ix "%%~dp0" -o %%~dp0 -a -PAC ^| %MSR_EXE% -it "\b%MSR_UNIFY_NAME%\b" -o "%MSR_EXE%" -a -XPAC
    echo %MSR_EXE% -p %SourceFile% -b %StopCalling% --nt %StopCalling% -ix "%%~dp0" -o %%~dp0 -a -PAC ^| %MSR_EXE% -it "\b%MSR_UNIFY_NAME%\b" -o "%MSR_EXE%" -a -XPAC >> !fileTestLog!
    %MSR_EXE% -p %SourceFile% -b %StopCalling% --nt %StopCalling% -ix "%%~dp0" -o %ThisDir% -a -PAC | %MSR_EXE% -it "\b%MSR_UNIFY_NAME%\b" -o "%MSR_EXE%" -a -XPAC >> !fileTestLog!
    %MSR_EXE% -p %ThisDir% -f base.*.log -t "^Replaced \d+ \S+?\b(\d+\.\d+)%%" -s "" -n -H 20 >> !fileTestLog!

    call :Compare_Title_Base_TestLog "%TestGroupNumber%-%TestGroupCount%: File test comparison" %ThisDir%\base-windows-file-test.log  %ThisDir%\!fileTestLog!
    if !ERRORLEVEL! NEQ 0 (
        set /a failedGroups+=1
        if %TestMode% NEQ 2 exit /b -1
    ) else (
        if exist %ThisDir%\Node*.tmp del %ThisDir%\Node*.tmp
        del %ThisDir%\!fileTestLog!
    )
)



set /a TestGroupNumber+=1 & echo. & echo.
echo ################## %TestGroupNumber%-%TestGroupCount%: Reading from pipe test begin ##################  | %MSR_EXE% -PA -e .+
if %TestGroupNumber% GEQ %BeginTestGroup% if %TestGroupNumber% LEQ %EndTestGroup% (
    set pipeTestLog=pipe-test-result-on-windows.log
    echo %FirstReplaceForPipe% ^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd% -PAC ^| %MSR_EXE% --nt "--wt|--sz" -it "^(%MSR_EXE%.*?)\s+-p\s+(\S+)(\s*.*)" -o "type $2 | $1 $3" -PAC ^| %MSR_EXE% --nx "type %ThisDir% " -XI
    %FirstReplaceForPipe% | %ReplaceExeName% | %ReplaceToThisDirMainCmd% -PAC | %MSR_EXE% --nt "--wt|--sz" -it "^(%MSR_EXE%.*?)\s+-p\s+(\S+)(\s*.*)" -o "type $2 | $1 $3" -PAC | %MSR_EXE% --nx "type %ThisDir% " -XI > !pipeTestLog!

    call :Compare_Title_Base_TestLog "%TestGroupNumber%-%TestGroupCount%: Pipe test comparison" %ThisDir%\base-windows-pipe-test.log %ThisDir%\!pipeTestLog!
    if !ERRORLEVEL! NEQ 0 (
        set /a failedGroups+=1
        if %TestMode% NEQ 2 exit /b -1
    ) else (
        del %ThisDir%\!pipeTestLog!
    )

    echo.

    if !failedGroups! GTR 0 (
        echo ################## Failed test group count = !failedGroups! ################## | %MSR_EXE% -aPA -t "(.+?(\d+).*)"
    ) else (
        ::%MSR_EXE% -p %~dp0%~nx0 -it "^set\s+\w+=(\S+\.log)\s*" -o "if exist $1 del $1" -X -H 0 -c Delete temp test files.
        echo ################## All %TestGroupCount% test groups passed. ################## | %MSR_EXE% -aPA -e "(.+?(\d+).*)"
    )
)

popd

if !failedGroups! NEQ 0 exit /b !failedGroups!

echo. & echo.

msr -z "call %ThisDir%\test-nin.cmd 1" -XM
exit /b !ERRORLEVEL!

:: Always return 0 so NOT use : diff !fileTestLog! %ThisDir%\base-windows-file-test.log
:: Call nin.exe to get the differences count which ERRORLEVEL as following. By the way, this is an example of nin.exe .
:Compare_Title_Base_TestLog
    call :Unify_TestLog_Before_Compare %3
    :: nin %2 %3 >nul
    nin %2 %3 -H 0
    set /a diff1=!ERRORLEVEL!
    :: nin %3 %2 >nul
    nin %2 %3 -H 0 -S
    set /a diff2=!ERRORLEVEL!

    if !diff1! EQU !diff2! (
        set /a differences=!diff1!
    ) else (
        set /a differences=!diff1!+!diff2!
    )

    if !differences! EQU 0 (
        for /f "tokens=*" %%a in ("%~2") do set /a fileSize1=%%~za
        for /f "tokens=*" %%a in ("%~3") do set /a fileSize2=%%~za
        if !fileSize1! NEQ !fileSize2! (
            echo File size: %2 = !fileSize1! NOT equal !fileSize2! = %3 | msr -aPA -t "(\S+)\s*=\s*(\d+)|(\d+)\s*=(\s*(\S+))|\w+" -x "Not equal"
            set /a differences+=1
        )
    )

    fc %2 %3 >nul
    set /a differences=!ERRORLEVEL!

    if !differences! NEQ 0 (
        echo ################## %1 has !differences! differences ###################### | !MSR_EXE! -PA -it "(\d+)|\w+" -e "#+"
        where bcompare >nul 2>nul && start bcompare %2 %3
    ) else (
        echo ################## %1 passed and no differences ###################### | !MSR_EXE! -PA -ie "( no )|\w+|#+"
    )

    exit /b !differences!


:Unify_TestLog_Before_Compare
    :: Need append file like : -p !pipeTestLog!  or -p !fileTestLog!
    %MSR_EXE% -p %1 -it "(\|\s*)%MSR_EXE%\b" -o "${1}%MSR_UNIFY_NAME%" -ROc UnifyPipeTestExeName
    %MSR_EXE% -p %1 -it "(^|\|\s+|^\s*echo\s+)%MSR_EXE%\b" -o "$1%MSR_UNIFY_NAME%" -ROc UnifyFileTestExeName
    ::set UnifyExtraExeName=%MSR_EXE% -it "%MSR_EXE% (-cA?|-x)" -o "%MSR_UNIFY_NAME% $1" -ROc UnifyExtraExeName
    %MSR_EXE% -p %1 -it "\b%MSR_EXE%\b" -o "%MSR_UNIFY_NAME%" -ROc UnifyExtraExeName
    %MSR_EXE% -p %1 -it "(?<=files)\s*\(\d+\S+\) in \d+ files.*|Used\s*\d+.*from.*\d-\d+.*|[,;]\s*(EXE|Directory|command)\s*=.*|[,;]*\s*read\s+\d+\s+line.*|Used \d+.*?command\S+\s*=\s*" -o "" -ROc RemoveTotalFileInfoAndDateTimeDir
    %MSR_EXE% -p %1 -it "(^|\s+)[\\\\/\w\.:-]+(example-commands.bat|sample-file.txt)" -o "$1$2" -ROc UnifyDirectory
    %MSR_EXE% -p %1 -ix "%ThisDir%" -o "." -ROc UnifyCurrentToDot
    %MSR_EXE% -p %1 -t "\s*\d+\.?\d*(\s*[KM]?B)(\s*\t\s*)\d+" -o "  Number-Unit  Bytes" -ROc ReplaceDetailSizeBytes
    %MSR_EXE% -p %1 -t "\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}(\s*\t\s*)" -o "yyyy-MM-dd HH:mm:ss$1" -ROc ReplaceDetailFileTime
    %MSR_EXE% -p %1 -t "^\d+\S+ \d+:\d+:\S+.*?(Run-Command|Return-Value)" -o "$1" -ROc UnifyExecuteCommands
    %MSR_EXE% -p %1 -b "^(%MSR_EXE%|%MSR_UNIFY_NAME%).*\s+-l -f bat\s+" -Q "^Matched|^\s*$" -t "\S+\.bat$" -o "Replace-Real-File-Name-To-Avoid-Difference" -Rc
