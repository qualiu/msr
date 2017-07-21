@echo off
SetLocal EnableExtensions EnableDelayedExpansion

if "%~1" == "" (
    echo Usage   : %0  Test-file
    echo Example : %0  d:\tmp\large-test.log
    exit /b 0
)

set script=%~dp0\compare-performance.bat
set TestFile=%1

echo :: Case-1: Both found
call %script% %TestFile% Exception "Error.*found"

echo :: Case-2: Both found, simpler regex
call %script% %TestFile% Exception "[0-9]*Exception[0-9]*"

echo :: Case-3: Not found, partial matched both
call %script% %TestFile% ExceptionX "[0-9]*ExceptionX[0-9]*"

echo :: Case-4: Not found, not matched
call %script% %TestFile% Not-Exist "Not-exist.*"
