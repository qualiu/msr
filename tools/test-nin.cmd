@echo off
SetLocal EnableExtensions EnableDelayedExpansion

set ThisDir=%~dp0
if %ThisDir:~-1% == \ set ThisDir=%ThisDir:~0,-1%
set ThisScript=%~dp0%~nx0

where msr.exe 2>nul >nul || if not exist %ThisDir%\msr.exe powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri https://github.com/qualiu/msr/blob/master/tools/msr.exe?raw=true -OutFile %ThisDir%\msr.exe"
where msr.exe 2>nul >nul || set "PATH=%ThisDir%;%PATH%"

where nin.exe 2>nul >nul || if not exist %ThisDir%\nin.exe powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri https://github.com/qualiu/msr/blob/master/tools/nin.exe?raw=true -OutFile %ThisDir%\nin.exe"
where nin.exe 2>nul >nul || set "PATH=%ThisDir%;%PATH%"

if "%~1" == ""       set IsShowUsage=1
if "%~1" == "-h"     set IsShowUsage=1
if "%~1" == "--help" set IsShowUsage=1
if "%~1" == "/?"     set IsShowUsage=1

if "%IsShowUsage%" == "1" (
    echo Usage   : %0  SaveToFile  NIN_EXE
    echo Example : %0  0
    echo Example : %0  1  nin
    echo Example : %0  1  nin-dbg
    exit /b 0
)

set /a SaveToFile=%1
if "%~2" == "" ( set "NIN_EXE=nin" ) else ( set "NIN_EXE=%~2" )

pushd %~dp0
set ninTestLog=%ThisDir%\test-nin.log
for /f "tokens=*" %%a in ("%ninTestLog%") do set "BaseLogFile=%ThisDir%\base-%%~nxa"

set TmpSourceFile=%ThisDir%\tmp-nin-source.txt
msr -z "1,2,3,4,5" -t "," -o "\n" -PAC | msr -t "\d+" -o "Line $0" -PAC > %TmpSourceFile%

set TmpDupliatedFile=%ThisDir%\tmp-nin-duplicated.txt
msr -z "3,5,5,6,7" -t "," -o "\n" -PAC | msr -t "\d+" -o "Line $0" -PAC > %TmpDupliatedFile%

set TmpDupliatedDiffFile=%ThisDir%\tmp-nin-duplicated-diff.txt
msr -z "3,5 one,5 two,5 three,7" -t "," -o "\n" -PAC | msr -t "\d+" -o "Line $0" -PAC > %TmpDupliatedDiffFile%

msr -p %TmpSourceFile%,%TmpDupliatedFile% -t "\s+$" -o "" -S -R -c Remove tail empty line >nul

set ExtractCmd=msr -p %~dp0%~nx0 -t "^nin\s+(%%\S+%%)" -o "%NIN_EXE% $1" -PIC
set TransformFile1=msr -x %%TmpSourceFile%% -o %TmpSourceFile% -aPIC
set TransformFile2=msr -x %%TmpDupliatedFile%% -o %TmpDupliatedFile% -aPIC
set RepalceFolder=msr -x %%ThisDir%% -o %ThisDir% -aPIC
set RedirectSummaryAndExecute=msr -t .+ -o "$0 -I" -X -c RedirectSummaryAndExecute
set ColorCommands=msr -aPA -e "^(nin.+?)\s*(?=\||$|>)" -x %ninTestLog%

if %SaveToFile% EQU 0 (
    echo %ExtractCmd% ^| %TransformFile1% ^| %TransformFile2% ^| %RepalceFolder% ^| %RedirectSummaryAndExecute% -X
    %ExtractCmd% | %TransformFile1% | %TransformFile2% | %RepalceFolder% | %RedirectSummaryAndExecute%
    del %TmpSourceFile%
    exit /b 0
)

echo %ExtractCmd% ^| %TransformFile1% ^| %TransformFile2% ^| %RepalceFolder% ^| %RedirectSummaryAndExecute% ^> %ninTestLog%
::echo %ExtractCmd% ^| %TransformFile1% ^| %TransformFile2% ^| %RedirectSummaryAndExecute% ^> %ninTestLog% | %ColorCommands%
%ExtractCmd% | %TransformFile1% | %TransformFile2% | %RepalceFolder% | %RedirectSummaryAndExecute% > %ninTestLog%
call :Compare_Title_Base_TestLog "Test nin.exe" %BaseLogFile% %ninTestLog%
if !ERRORLEVEL! NEQ 0 (
    popd & exit /b -1
)

del %ninTestLog% %TmpSourceFile% %TmpDupliatedFile% %TmpDupliatedDiffFile%
popd & exit /b 0

nin %TmpSourceFile% nul -H 0
nin %TmpSourceFile% nul -T 0
nin %TmpSourceFile% nul -H 2 -T 0
nin %TmpSourceFile% nul -H 0 -T 2
nin %TmpSourceFile% nul -H -2 -T 0
nin %TmpSourceFile% nul -H 0 -T -2
nin %TmpSourceFile% nul -Z
nin %TmpSourceFile% nul -H 2
nin %TmpSourceFile% nul -T 2
nin %TmpSourceFile% nul -H 2 -T 2
nin %TmpSourceFile% nul -H -2
nin %TmpSourceFile% nul -T -2
nin %TmpSourceFile% nul -H -2 -T -2
nin %TmpSourceFile% nul -H 2 -T -2
nin %TmpSourceFile% nul -H -2 -T 2

nin %TmpDupliatedFile% nul -iu
nin %TmpDupliatedFile% %TmpSourceFile%
nin %TmpDupliatedFile% %TmpSourceFile% -S
nin %TmpDupliatedFile% %TmpSourceFile% -m
nin %TmpDupliatedFile% %TmpSourceFile% -mS

nin %TmpDupliatedFile% nul -ip -T 0
nin %TmpDupliatedFile% nul -ipd -H 2 -T 0
nin %TmpDupliatedFile% nul -iu -H 0 -T 2
nin %TmpDupliatedFile% nul -ua -H -2 -T 0
nin %TmpDupliatedFile% nul -ud -H 0 -T -2

nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -mu
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)"
nin %TmpDupliatedFile% %TmpSourceFile% "([3-5])" -mu
nin %TmpDupliatedFile% %TmpSourceFile% "([3-5])"
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -H 2
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -H -1
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -T -1
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -H 1 -T -1
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -H -1 -T -1
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -H 1 -T 1
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -H 1 -T 0
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -H -1 -T 0
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -m --nx 3
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -m --nt "[4-5]"
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -m -t "[3-5]" -x 5
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -m -x 3
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -m -t 3
nin %TmpDupliatedFile% %TmpSourceFile% "(\d+)" -t "[3-5]" -S

nin %TmpDupliatedFile% nul "(\d+)" -p
nin %TmpDupliatedFile% nul "(\d+)" -p -k 1
nin %TmpDupliatedFile% nul "(\d+)" -p -K 30
nin %TmpDupliatedFile% nul "(\d+)" -p -k 1 -K 30
nin %TmpDupliatedFile% nul "(\d+)" -p -d
nin %TmpDupliatedFile% nul "(\d+)" -p -d -k 2
nin %TmpDupliatedFile% nul "(\d+)" -p -d -K 40
nin %TmpDupliatedFile% nul "(\d+)" -p -d -k 2 -K 40

nin %TmpDupliatedFile% nul "(\d+)" -p -k 1 -H 0
nin %TmpDupliatedFile% nul "(\d+)" -p -k 1 -T 0
nin %TmpDupliatedFile% nul "(\d+)" -p -k 1 -H 2
nin %TmpDupliatedFile% nul "(\d+)" -p -k 1 -H 2 -T 0
nin %TmpDupliatedFile% nul "(\d+)" -p -k 1 -H 1 -T 1
nin %TmpDupliatedFile% nul "(\d+)" -p -k 1 -H -2 -T 1
nin %TmpDupliatedFile% nul "(\d+)" -p -k 1 -H -1 -T -1

nin %TmpDupliatedFile% nul -iu -H 2 -J
nin %TmpDupliatedFile% nul -iu -H 2 -T 2 -J
nin %TmpDupliatedFile% nul "(\d+)" -p -k 1 -H 2 -J
nin %TmpDupliatedFile% nul "(\d+)" -p -k 1 -H 2 -T 2 -J

nin %TmpDupliatedFile% nul "(\d+)" -p -it line --nx 3
nin %TmpDupliatedFile% nul "(\d+)" -p -ix line --nt 3
nin %TmpDupliatedFile% nul "([3-5])" -p -w
nin %TmpDupliatedFile% nul "([3-5])" -p -wn
nin %TmpDupliatedFile% nul -p -ix line --nt 3
nin %TmpDupliatedFile% nul -p -ix line --nt 3
nin %TmpDupliatedFile% nul -it line -H 2
nin %TmpDupliatedFile% nul -ix line -H 2 -t Line
nin %TmpDupliatedFile% nul -it "([3-5])"
nin %TmpDupliatedFile% nul -it "([3-5])" -n
nin %TmpDupliatedFile% nul -it "([3-5])" -wn
nin %TmpDupliatedFile% nul -H2
nin %TmpDupliatedFile% nul -pdk2

nin %TmpDupliatedDiffFile% nul "(5)" -pd
nin %TmpDupliatedDiffFile% nul "(5)" -pdw
nin %TmpDupliatedDiffFile% nul "(5)" -wa

nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -wa
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -wd
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -a
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -d
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -wai
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -wdi
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -ia
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -id
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -pa
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -pd
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -ipa
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -ipd
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -iu
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -iuw
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -iua
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -iuaw
nin %ThisDir%\sort-nin-test.txt nul "(\S+)$" -iudw
nin %ThisDir%\sort-nin-test.txt nul "\b([lmn]\w+)$" -wua
nin %ThisDir%\sort-nin-test.txt nul "\b([lmn]\w+)$" -wud
nin %ThisDir%\sort-nin-test.txt nul "\b([lmn]\w+)$" -wp
nin %ThisDir%\sort-nin-test.txt nul "\b([lmn]\w+)$" -wpd
nin %ThisDir%\sort-nin-test.txt nul "\b([lmn]\w+)$" -p

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
        echo ################## %1 has !differences! differences ###################### | msr -PA -it "(\d+)|\w+" -e "#+"
        where bcompare >nul 2>nul && start bcompare %2 %3
    ) else (
        echo ################## %1 passed and no differences ###################### | msr -PA -ie "( no )|\w+|#+"
    )
    exit /b !differences!

:Unify_TestLog_Before_Compare
    msr -p %1 -it "(?<=files)\s*\(\d+\S+\) in \d+ files.*|Used\s*\d+.*from.*\d-\d+.*|[,;]\s*(EXE|Directory|command)\s*=.*|[,;]*\s*read\s+\d+\s+line.*|Used \d+.*?command\S+\s*=\s*" -o "" -ROc RemoveTotalFileInfoAndDateTimeDir
    msr -p %1 -it "(^|\s+)[\\\\/\w\.:-]+(example-commands.bat|sample-file.txt)" -o "$1$2" -ROc UnifyDirectory
    for /f "tokens=*" %%a in ('msr -p %ThisScript% -t "^\s*set (\w+)=(\S+)\.\w+\s*$" -o "$1" -PAC') do msr -p %1 -x %%%%a%% -o !%%a! -ROc
    msr -p %1 -ix %ThisDir%\ -o "" -ROc UnifyCurrentToDot
    msr -p %1 -t "\s*\d+\.?\d*(\s*[KM]?B)(\s*\t\s*)\d+" -o "  Number-Unit  Bytes" -ROc ReplaceDetailSizeBytes
    msr -p %1 -t "\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}(\s*\t\s*)" -o "yyyy-MM-dd HH:mm:ss$1" -ROc ReplaceDetailFileTime
    msr -p %1 -t "^\d+\S+ \d+:\d+:\S+.*?(Run-Command|Return-Value)" -o "$1" -ROc UnifyExecuteCommands
    msr -p %1 -t "\b%NIN_EXE%\b" -o "nin" -ROc UnifyExeName
