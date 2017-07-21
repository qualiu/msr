::=======================================================
:: Check and fix file style
::=======================================================
@echo off
SetLocal EnableExtensions EnableDelayedExpansion

where msr.exe 2>nul >nul || if not exist %~dp0\msr.exe powershell -Command "Invoke-WebRequest -Uri https://github.com/qualiu/msr/blob/master/tools/msr.exe?raw=true -OutFile %~dp0\msr.exe"
where msr.exe 2>nul >nul || set "PATH=%PATH%;%~dp0"

@if "%~1" == "" (
    echo Usage  : %~n0  Files-or-Directories  [options]
    echo Example: %~n0  my.cpp
    echo Example: %~n0  "my.cpp,my.ps1,my.bat"
    echo Example: %~n0  directory-1
    echo Example: %~n0  "directory-1,file2,directory-3"
    echo Example: %~n0  "directory-1,file2,directory-3" -r
    echo Example: %~n0  %%CD%% -r
    echo Example: %~n0  . -r --nf "\.(log|md|exe|cygwin|gcc\w*|txt)$"
    echo Example: %~n0  . -r -f "\.(bat|cmd|ps1|sh)$" --nd "^(target|bin)$"
    echo Should not use --np and --pp as used by this; and -p also used. | msr -PA -t "(-\S+)|\w+"
    exit /b -1
)

set PathToDo=%1

shift
:: Begin to get other arguments, save to msrOptions
set /a hasFileFilter=0
:CheckArgs
    if "%~1" == ""  goto CheckArgsCompleted
    if "%~1" == "-f" set /a hasFileFilter=1
    set msrOptions=!msrOptions! %1
    shift
    goto CheckArgs
:CheckArgsCompleted

:: if not defined msrOptions set set msrOptions=--nd "^\.git$" -f "\.(hp*|cp*|cx*|cs|ps1|bat|cmd)$"
if not defined msrOptions (
    set msrOptions=--nd "^\.git$"
) else (
    set msrOptions=!msrOptions! --np "[\\\\/]*(\.git)[\\\\/]"
)

@echo ## Remove white spaces at each line end | msr -PA -e .+
msr !msrOptions! -p %PathToDo% -it "(\S+)\s+$" -o "$1" -R -c Remove white spaces at each line end.

::@echo ## Add a tail new line to files | msr -PA -e .+
::msr !msrOptions! -p %PathToDo% -S -t "(\S+)$" -o "$1\n" -R -c Add a tail new line to files.

@echo ## Add/Delete to have only one tail new line in files | msr -PA -e .+
msr !msrOptions! -p %PathToDo% -S -t "(\S+)\s*$" -o "$1\n" -R -c Add a tail new line to files.

:: Convert tab at head of each lines in a file, util all tabs are replaced.
:ConvertTabTo4Spaces
    if exist %PathToDo%\* (
        if !hasFileFilter! EQU 0 set FileFilterConvertTab=-f "\.(cpp|cxx|hp*|cs|java|scala|py|bat|cmd|ps1|sh)$"
        msr !msrOptions! -p %PathToDo% !FileFilterConvertTab! -it "^^(\s*)\t" -o "$1    " -R -c Covert TAB to 4 spaces.
    ) else (
        msr !msrOptions! -p %PathToDo% -it "^^(\s*)\t" -o "$1    " -R -c Covert TAB to 4 spaces.
    )
    if !ERRORLEVEL! GTR 0 goto :ConvertTabTo4Spaces else exit /b 0


@echo ## Convert line ending style from CR LF to LF for Linux files | msr -PA -e .+
set FileFilterForLinuxLineEnding=-f "^makefile$|\.sh$|\.mak\w*$"
if !hasFileFilter! NEQ 0 set FileFilterForLinuxLineEnding=--pp "[\\\\/]*makefile$|\.sh$|\.mak\w*$"
msr !msrOptions! -p %PathToDo% !FileFilterForLinuxLineEnding! -l -PICc | msr -t ".+" -o "dos2unix \"$0\"" -XA

@echo ## Convert line ending style from LF to CR LF for Windows files | msr -PA -e .+
set FileFilterForWindowsLineEnding=-f "\.(bat|cmd|ps1)$"
if !hasFileFilter! NEQ 0 set FileFilterForWindowsLineEnding=--pp "\.(bat|cmd|ps1)$"
msr !msrOptions! -p %PathToDo% !FileFilterForWindowsLineEnding! -l -PICc | msr -t ".+" -o "unix2dos \"$0\"" -XA
