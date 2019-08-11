:: Genereate summary table of markdown format
@echo off
SetLocal EnableExtensions EnableDelayedExpansion

:: msr -p full-Windows-comparison.txt -it ".*Used (\d+\.\d{1,3}).* Read (\w+)\s*:\s*(.+)"  -o "| $2 | $3 | $1 s |" -a -PAC | msr -t "Test file.*" -o "$0\n\n| exe | text pattern | cost |\n| -- | -- | -- |" -aPAC

if "%~1" == "" (
    echo Usage   : %0  Performance-comparison-file  [OutputFile-Path]
    echo Example : %0  full-Windows-comparison.txt   summary-full-Windows-comparison.md
    echo Example : %0  full-Windows-comparison.txt
    exit /b 0
)

set PerformanceFile=%1
if "%~2" == "" ( set "OutputFile=%~dp1\summary-%~n1.md" ) else ( set "OutputFile=%~2" )
set "TmpOutput=%OutputFile%.tmp"

set "AllSystems=Windows|Linux|CentOS|Cygwin|Ubuntu|Fedora"

set ThisDir=%~dp0
if %ThisDir:~-1%==\ set ThisDir=%ThisDir:~0,-1%
set "PATH=%ThisDir%\..\tools;%PATH%"

msr -p %PerformanceFile% -it ".*Used (\d+\.\d{1,3}).* Read (\w+)\s*:\s*(.+)"  -o "| $2 | $1 s | ```$3``` | type-replace | case-replace | rows-replace | size-replace | system-replace |" -a -PAC | msr -t "Test file.*" -o "$0\n\n| EXE | Cost | To find | Type | Text case | File rows | File size | System Info |\n| -- | -- | -- | -- | -- | -- | -- | -- |" -aPAC > "%TmpOutput%"

for /f "tokens=*" %%a in ('msr -p %PerformanceFile% -it ".*from\s+(\d+\S+ \d+:\d+:\d+)\S*\s*(\w*).*" -o "$1 $2" -PAC -H 1') do set "BeginTestTime=%%a"

for /f "tokens=*" %%a in ('nin "%TmpOutput%" nul ".*:(.+)$" -upd -H 1 -PAC') do set FullSystemInfo=%%a
for /f "tokens=*" %%a in ('msr -z "%FullSystemInfo%" -it ".*?((?:%AllSystems%)\S*)\s+(\S+).*" -o "$1 $2" -PAC') do set SystemInfo=%%a
for /f "tokens=*" %%a in ('msr -z "%SystemInfo%" -it "[^\w\.\s-]\S*" -o "" -aPAC ^| msr -t "\s+" -o " " -aPAC') do set SystemInfo=%%a
for /f "tokens=*" %%a in ('msr -z "%SystemInfo%" -it ".*((?:%AllSystems%)\w*).*" -o "$1" -aPAC') do set SystemInfo=%%a

for /f "tokens=*" %%a in ('msr -p "%TmpOutput%" -t "Test file info.*?(\d+)\s*lines (\d+\.?\d*\s*\wB).*" -o "$1" -H 1 -PAC') do set "fileRows=%%a"
for /f "tokens=*" %%a in ('msr -p "%TmpOutput%" -t "Test file info.*?(\d+)\s*lines (\d+\.?\d*\s*\wB).*" -o "$2" -H 1 -PAC') do set "fileSize=%%a"

msr -p "%TmpOutput%" -it rows-replace -o "%fileRows%" -R -c
msr -p "%TmpOutput%" -it size-replace -o "%fileSize%" -R -c
msr -p "%TmpOutput%" -it system-replace -o "%SystemInfo%" -R -c

set beginPattern=
set endPattern=
set /a tables=0

set blockFinding=msr -p "%TmpOutput%" --nt "^(Test file|\s*\|)" -t "^(.*?\d+:\d+:\d+[\w\.:/\s-]+).*" -o "$1" -PIC -c Finding blocks
for /f "tokens=*" %%a in ('%blockFinding%') do (
    set /a tables+=1
    if !tables! EQU 1 (
        set beginPattern=%%a
    ) else (
        set endPattern=%%a
        set CommonCommand=msr -p "%TmpOutput%" -b "!beginPattern!" -q "!endPattern!" --nt "!endPattern!"

        :: Replace type of Plain of Regex
        !CommonCommand! -it "Regex" -c Check pattern type -PAC >nul
        if !ERRORLEVEL! GTR 0 ( set typeReplaceTo=Regex ) else ( set typeReplaceTo=Plain )
        !CommonCommand! -it type-replace -o !typeReplaceTo! -R -c Replace type

        :: Replace ignore case
        !CommonCommand! -it "ignore\s*case" -c Check case type -PAC >nul
        if !ERRORLEVEL! GTR 0 ( set caseReplaceTo=insensitive ) else ( set caseReplaceTo=sensitive )
        !CommonCommand! -it case-replace -o !caseReplaceTo! -R -c Replace case

        set beginPattern=%%a
    )
)

:: Replace remained last item
set CommonCommand=msr -p "%TmpOutput%" -b "!beginPattern!"
:: Replace type of Plain of Regex
!CommonCommand! -it "Regex" -c Check pattern type -PAC >nul
if !ERRORLEVEL! GTR 0 ( set typeReplaceTo=Regex ) else ( set typeReplaceTo=Plain )
!CommonCommand! -it type-replace -o !typeReplaceTo! -R

:: Replace ignore case
!CommonCommand! -it "ignore\s*case" -c Check case type -PAC >nul
if !ERRORLEVEL! GTR 0 ( set caseReplaceTo=insensitive ) else ( set caseReplaceTo=sensitive )
!CommonCommand! -it case-replace -o !caseReplaceTo! -R -c

msr -p "%TmpOutput%" -it .+ -o "" --nt "^\s*\|" -R -c Keep only table line
echo * %BeginTestTime% Genereated by ```%~nx0 %PerformanceFile%``` > "%OutputFile%
echo * %FullSystemInfo% >> "%OutputFile%"

nin "%TmpOutput%" nul -u >> "%OutputFile%"
del "%TmpOutput%"
msr -p "%OutputFile%" -t "(\d+)\.(\d+)(\s*s)" -o "**$1**.*$2*$3" -R -c

echo Please see "%OutputFile%" | msr -PA -e .+
