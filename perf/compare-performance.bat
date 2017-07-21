@echo off
SetLocal EnableExtensions EnableDelayedExpansion

if "%~2" == "" if "%~3" == "" (
    echo Usage   : %0  Test-file                Plain-Finding-String   Regex-Pattern            [Optional : TestTimes]
    echo Example : %0  d:\tmp\large-test.log    Exception             "[0-9]*Exception[0-9]*"    3
    exit /b -1
)

if not exist %1 (
    echo NOT EXIST test file : %1 | msr -PA -t .*
    exit /b -1
)

set TestFilePath=%1
for %%a in ("%~1") do (
    set TestFileDir="%%~dpa"
    set TestFileName="%%~nxa"
)

where msr.exe 2>nul >nul || set "PATH=%~dp0..\tools;%PATH%"
set PlainFinding=%2
set RegexFinding=%3
set "TestTimes=%~4"
if "%TestTimes%" == "" set "TestTimes=1"

where grep.exe 2>nul >nul
if %ERRORLEVEL% EQU 0 (
    set Grep=grep
    set GrepResult=msr -l -c Read  grep :
) else (
    set Grep=echo
    set GrepResult=msr -PAC -H 0 -M
)

set EnhanceShow=msr -PA -e "((((((.+))))))" -it "((((((Plain|Regex|(?<=by : )\S+))))))|Test|small|ignore\s*case|(Windows|Cygin|Linux|Centos|Fedora|UBuntu)\w*\s*(\d+\w*)?"

call :GetCPUInfo
call :GetMemoryInfo
call :GetOSVersionBit

:: set SystemInformation=Windows 10 Enterprise x64 32GB RAM Intel E5-1630 V3 3.70GHz
set SystemInformation=%OSVersionBit% + %CPUInfo% + %MemoryInfo%

for /F "tokens=*" %%a in ('msr -l -t . -p %TestFilePath% -H 0 -c Get size and rows ^| msr -it "^.*read (\d+ lines \d+\S+ \w+).*from (\d+\S+.+?)Checked.*" -o "$1" -PAC') do (
    set TestFileInfo=%%a
)

pushd %TestFileDir%
if not %PlainFinding% == ""   call :Compare_By_File_Pattern_3_Options "Plain text finding"  %TestFileName%    %PlainFinding%  ""       ""   -x
if not %PlainFinding% == ""   call :Compare_By_File_Pattern_3_Options "Plain ignore case"   %TestFileName%    %PlainFinding%  /I       -i   -ix
if not "%RegexFinding%" == "" call :Compare_By_File_Pattern_3_Options "Regex text finding"  %TestFileName%    %RegexFinding%  /R       -e   -t
if not "%RegexFinding%" == "" call :Compare_By_File_Pattern_3_Options "Regex ignore case"   %TestFileName%    %RegexFinding%  "/I /R"  -ie  -it
popd

exit /b 0

::Paramters : Title, File, pattern , findstr-options, grep-options, msr-options
:Compare_By_File_Pattern_3_Options
    echo %date% %time% : %~1 : %3 : %SystemInformation% | %EnhanceShow%
    echo Test file info : !TestFileInfo! : %~1 by findstr / grep / msr ; To find = %3 | msr -t "(\d+\.\d+)" -e "(\d+)|\w+" -PA -a
    for /L %%k in (1,1,%TestTimes%) do (
        findstr %~4 %3    %2      | msr -l -c Read  findstr : %3
        %Grep%  %~5 %3    %2      | %GrepResult% %3
        msr    %~6 %3 -p %2 -PAC | msr -l -c Read  msr : %3
    )
    echo.
    exit /b 0

:GetCPUInfo
    ::for /F "tokens=*" %%a in ('wmic CPU GET /VALUE ^| msr -it "^NumberOfCores=(\d+)" -o $1 -PAC ') do set NumberOfCores=%%a
    ::for /F "tokens=*" %%a in ('wmic CPU GET /VALUE ^| msr -it "^Name=(.+)" -o $1 -PAC ') do set "CPUInfo=%%a"
    for /f "tokens=1,2 delims==" %%a in ('wmic CPU GET NumberOfCores /VALUE ^| findstr /I NumberOfCores') do set NumberOfCores=%%b

    for /f "tokens=1,2 delims==" %%a in ('wmic CPU GET Name /VALUE ^| findstr /I Name') do set CPUInfo=%%b
    set "CPUInfo=%CPUInfo% %NumberOfCores% Cores"
    exit /b 0

:GetOSVersionBit
    for /f "tokens=1,2 delims==" %%a in ('wmic OS GET Caption^,OSArchitecture /Value ^| findstr /I /R "[0-9a-z]"') do (
        if "%%a" == "Caption" (
            set SystemCaption=%%b
        ) else if "%%a" == "OSArchitecture" (
            set OSArchitecture=%%b
        )
    )
    set "OSVersionBit=!SystemCaption! !OSArchitecture!"
    exit /b 0

:GetMemoryInfo
    set /a TotalMemory=0
    set /a MemoryChannels=0
    for /f "tokens=1,2 delims==" %%a in ('wmic MEMORYCHIP where ^(Caption^="Physical Memory"^) GET Capacity^,Speed^,DeviceLocator /Value ^| findstr /I /R "[0-9a-z]"') do (
        if "%%a" == "Capacity" (
            call :GetNumberOfMB %%b
            set /a TotalMemory+=!numberMB!
        ) else if "%%a" == "Speed" (
            set MemorySpeed=%%b
        ) else if "%%a" == "DeviceLocator" (
            set /a MemoryChannels+=1
        )
    )
    set Units[0]=MB
    set Units[1]=GB
    set Units[2]=TB

    set /a unitIndex=0
    set /a MemoryNumber=%TotalMemory%
    for /L %%k in (1,1,2) do (
        if !MemoryNumber! GEQ 1024 (
            set /a unitIndex=%%k
            set /a MemoryNumber/=1024
        )
    )

    set "MemoryInfo=!MemoryNumber! !Units[%unitIndex%]! RAM"
    ::set MemoryInfo="!MemoryInfo!/%MemoryChannels% Channels/%MemorySpeed% Speed"
    exit /b 0

:GetNumberOfMB
    :: if number >= 4294967296 will get error.
    set bytes=%~1
    ::set /a tail=%bytes:~-9%/1048576
    set /a "tail=%bytes:~-9%>>20"
    set /a head=%bytes:~0,-9% || set /a head=0
    :: first divide by 1000 other than 1024 to avoid decresing real memory size
    if %head% GTR 0  set /a "head=%head%*100000/1000 * 10000 /1024"
    set /a numberMB=%head% + %tail%
    exit /b %numberMB%
