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
set IsSavingToFile=%1
set msrExeName=%2
set SleepSeconds=%3
set ReplaceTo=%4

set ThisDir=%~dp0
if %ThisDir:~-1% == \ set ThisDir=%ThisDir:~0,-1%
set ThisDir2Slash=%ThisDir:\=\\%

for %%a in ("%ThisDir%") do set ParentDir=%%~dpa
if %ParentDir:~-1% == \ set ParentDir=%ParentDir:~0,-1%
set ParentDir2Slash=%ParentDir:\=\\%

where msr.exe 2>nul >nul || if not exist %ThisDir%\msr.exe powershell -Command "Invoke-WebRequest -Uri https://github.com/qualiu/msr/blob/master/tools/msr.exe?raw=true -OutFile %ThisDir%\msr.exe"
where msr.exe 2>nul >nul || set "PATH=%ThisDir%;%PATH%"

where nin.exe 2>nul >nul || if not exist %ThisDir%\nin.exe powershell -Command "Invoke-WebRequest -Uri https://github.com/qualiu/msr/blob/master/tools/nin.exe?raw=true -OutFile %ThisDir%\nin.exe"
where nin.exe 2>nul >nul || set "PATH=%ThisDir%;%PATH%"

set SourceFile=%ThisDir%\example-commands.bat
if "%1" == "-h" set IsShowUsage=1
if "%1" == "--help" set IsShowUsage=1
if "%1" == "/?" set IsShowUsage=1

if "%IsShowUsage%" == "1" (
    echo Usage   : %0  IsSavingToFile  msrExeName   SleepSeconds  ReplaceTo
    echo Example : %0       -- directly test and output on this command window, using msr.
    echo Example : %0   1   -- output to files and compare with base-windows-**.log, using msr.
    echo Example : %0   0              msr           3    -- output to window, sleep 3 seconds for each execution.
    echo Example : %0   0              msrdbg        3             -cA
    exit /b 0
)

if "%msrExeName%" == "" set msrExeName=msr
if "%SleepSeconds%" == "" set SleepSeconds=3

if "%~4" == "" (
    set "ReplaceTo=-c"
)

set msrThis=msr
:: Check and add tool directory to %PATH% in case of no %msrExeName%.exe
%msrThis% -z "%PATH%" -ix "%ThisDir%;" -PAC >nul -- Can also use -H 0 to hide result and -M to hide summary.
if %ERRORLEVEL% LSS 1 SET "PATH=%PATH%;%ThisDir%;"

set StopCalling="::Stop calling"
set FirstReplaceForFile=%msrExeName% -it "%msrThis% -c" -o "%msrExeName% %ReplaceTo%" -p %SourceFile% --nt "\s+-R\b" -PAC
set FirstReplaceForPipe=%msrExeName% -it "%msrThis% -c" -o "%msrExeName% %ReplaceTo% -A" -p %SourceFile% --nt "\s+(-R|-PAC|-PIC)\b" -PAC -q "%StopCalling%|stop pipe test"
set ReplaceExeName=%msrExeName% -it "\b%msrExeName%\s+" -o "%msrExeName% " -PAC
::set ReplaceToThisDirMainCmd=%msrExeName% -ix "%%~dp0" -o "%ThisDir2Slash%"
set ReplaceToThisDirMainCmd=%msrExeName% -ix "%%~dp0" -o %ThisDir% -a

:: Need append file like : -p %pipeResult%  or -p %fileResult%
set UnifyPipeTestExeName=%msrExeName% -it "(\|\s*)%msrExeName%\b" -o "${1}%msrThis%" -ROc UnifyPipeTestExeName
set UnifyFileTestExeName=%msrExeName% -it "(^|\|\s+|^\s*echo\s+)%msrExeName%\b" -o "$1%msrThis%" -ROc UnifyFileTestExeName
set UnifyExtraExeName=%msrExeName% -it "%msrExeName% (-cA?|-x)" -o "%msrThis% $1" -ROc UnifyExtraExeName
set RemoveDateTimeDir=%msrExeName% -it "Used\s*\d+.*from\s*\d+.*|[,;]*\s*(Directory|command)\s*=.*|[,;]*\s*read\s+\d+\s+line.*" -o "" -ROc RemoveDateTimeDir
set UnifyDirectory=%msrExeName% -it "(^|\s+)[\\\\/\w\.:-]+(example-commands.bat|sample-file.txt)" -o "$1$2" -ROc UnifyDirectory
set UnifyCurrentToDot=%msrExeName% -ix "%ThisDir%" -o "." -ROc UnifyCurrentToDot

:: Directly test and output result on current command window
if not "%IsSavingToFile%" == "1" (
    if %SleepSeconds% GTR 0 (
        :: %FirstReplaceForFile% -q %StopCalling%| %ReplaceExeName% | %ReplaceToThisDirMainCmd% -PAC | %msrExeName% -t "^.+$" -o "$0 && sleep %SleepSeconds%" -XI
        echo %FirstReplaceForFile%^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd%
        for /F "tokens=*" %%a in ('%FirstReplaceForFile% ^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd% -PAC ') do (
            echo %%a | %msrThis% -XI 2>nul
            :: a trick to sleep
            ping 127.0.0.1 -n %SleepSeconds% -w 1000 > nul 2>nul
            echo.
        )
    )  else (
        echo %FirstReplaceForFile% ^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd%
        %FirstReplaceForFile% | %ReplaceExeName% | %ReplaceToThisDirMainCmd% -I -X
    )

    echo %SourceFile% | %msrExeName% -t .+  -o "findstr xml $0" -XI
    %msrExeName% -p %SourceFile% -b %StopCalling% -ix "%%~dp0" -o %ThisDir% -a -XI
    exit /b 0
)

echo ######### Reading from file test begin ######################## | %msrThis% -PA -e .+
set fileResult=%ThisDir%\file-test-result-on-windows.log
if exist %fileResult% del %fileResult%
echo %FirstReplaceForFile% ^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd%
for /F "tokens=*" %%a in ('%FirstReplaceForFile% ^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd% -PIC ') do (
    echo %%a >> %fileResult%
    %%a >> %fileResult%
    echo Return = !ERRORLEVEL! : %%a >> %fileResult%
    ::%%a --verbose 2>&1 | %msrExeName% -it "^(Return\s*=\s*\d+).*" -o "$1" -T 1 -PAC >> %fileResult%
    echo.>> %fileResult%
)

echo.>>%fileResult%
echo echo %SourceFile% ^| %msrExeName% -t .+  -o "findstr xml $0" -XA >> %fileResult%
echo %SourceFile% | %msrExeName% -t .+  -o "findstr xml $0" -XA >>  %fileResult%

echo.>>%fileResult% & echo.>>%fileResult%
echo %msrExeName% -p %SourceFile% -b %StopCalling% --nt %StopCalling% -ix "%%~dp0" -o %%~dp0 -a -PAC ^| %msrExeName% -it "\b%msrThis%\b" -o "%msrExeName%" -a -XPAC
echo %msrExeName% -p %SourceFile% -b %StopCalling% --nt %StopCalling% -ix "%%~dp0" -o %%~dp0 -a -PAC ^| %msrExeName% -it "\b%msrThis%\b" -o "%msrExeName%" -a -XPAC >> %fileResult%
%msrExeName% -p %SourceFile% -b %StopCalling% --nt %StopCalling% -ix "%%~dp0" -o %ThisDir% -a -PAC | %msrExeName% -it "\b%msrThis%\b" -o "%msrExeName%" -a -XPAC >> %fileResult%

%UnifyFileTestExeName% -p %fileResult%
%RemoveDateTimeDir% -p %fileResult%
%UnifyExtraExeName% -p %fileResult%
%UnifyDirectory% -p %fileResult%
%UnifyCurrentToDot% -p %fileResult%

call :Compare_Title_Files "File test comparison" %ThisDir%\base-windows-file-test.log  %fileResult%

echo. & echo.

set /a allDifferences=0
echo ######### Reading from pipe test begin ######################## | %msrThis% -PA -e .+
set pipeResult=%ThisDir%\pipe-test-result-on-windows.log
echo %FirstReplaceForPipe% ^| %ReplaceExeName% ^| %ReplaceToThisDirMainCmd% -PAC ^| %msrExeName% --nt "--wt|--sz" -it "^(%msrExeName%.*?)\s+-p\s+(\S+)(\s*.*)" -o "type $2 | $1 $3" -XI
%FirstReplaceForPipe% | %ReplaceExeName% | %ReplaceToThisDirMainCmd% -PAC | %msrExeName% --nt "--wt|--sz" -it "^(%msrExeName%.*?)\s+-p\s+(\S+)(\s*.*)" -o "type $2 | $1 $3" -XI > %pipeResult%
%UnifyPipeTestExeName% -p %pipeResult%
%RemoveDateTimeDir% -p %pipeResult%
%UnifyExtraExeName% -p %pipeResult%
%UnifyDirectory% -p %pipeResult%
%UnifyCurrentToDot% -p %pipeResult%

call :Compare_Title_Files "Pipe test comparison" %ThisDir%\base-windows-pipe-test.log %pipeResult%
set /a allDifferences+=%ERRORLEVEL%
exit /b %allDifferences%

:: Always return 0 so NOT use : diff %fileResult% %ThisDir%\base-windows-file-test.log
:: Call nin.exe to get the differences count which ERRORLEVEL as following. By the way, this is an example of nin.exe .
:Compare_Title_Files
    :: nin %2 %3 >nul
    nin %2 %3 -H 0
    set /a diff1=%ERRORLEVEL%
    :: nin %3 %2 >nul
    nin %2 %3 -H 0 -S
    set /a diff2=%ERRORLEVEL%

    if %diff1% EQU %diff2% (
        set /a differences=%diff1%
    ) else (
        set /a differences=%diff1%+%diff2%
    )

    if %differences% GTR 0 (
        echo ######### %1 has %differences% differences ############# | %msrThis% -PA -it "(\d+)|\w+" -e "#+"
        where bcompare >nul 2>nul && start bcompare %2 %3
    ) else (
        echo ######### %1 passed and no differences ############# | %msrThis% -PA -ie "( no )|\w+|#+"
    )
    exit /b %differences%
