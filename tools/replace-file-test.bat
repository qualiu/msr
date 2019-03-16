@echo off
SetLocal EnableExtensions EnableDelayedExpansion
if "%~1" == "" (
    echo Usage:   %0  msr-exe-name  [Test-Number]
    echo Example: %0  msr
    echo Example: %0  msr-dbg
    echo Example: %0  msr-dbg		3
    exit /b -1
)

pushd %~dp0
set MSR_EXE=%1
set Specified_Test_Number=%~2
where bcompare 2>nul >nul  && set /a HasBCompareExe=1

set Restore_Pattern_New_Line=-S -t " -New-Line- (\r?\n|\n\r?)?" -o "\n"
set Restore_Pattern_Text=-t PairName -o Name

for /f "tokens=*" %%a in ("sample-file.txt") do set /a SizeMustBe=%%~za

set /a TestNumber=0
:: No change replacing test
call :Replace_And_Check -p sample-test.txt -t Function -o Function -R -c Should not replace or change file || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -t Function -o FuncTion --nx pair -R -c Should not replace or change file || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -t Function -o FuncTion --nt pair -R -c Should not replace or change file || goto :Pop_Exit_Error

:: Range replacing
call :Replace_And_Check -p sample-test.txt -L 37 -N 40 -S -t "\r?\n|\r\n?" -o " -New-Line- " -R -c || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -L 33 -N 36 -t "\bName\b" -o PairName -R -c || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -L 37 -N 40 -t "\bName\b" -o PairName -R -c || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -L 35 -t "\bName\b" -o PairName -q 4000 -R -c || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -b "\s*</pair" -t "\bName\b" -o PairName -q 4000 -R -c || goto :Pop_Exit_Error

:: Block replacing
call :Replace_And_Check -p sample-test.txt -b "\s*<pair" -Q "\s*</pair" -t "\bName\b" -o PairName -R -c || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -b "\s*<pair" -Q "\s*</pair" -t "\bName\b" -o PairName -q "\s*</pair" -R -c || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -b "\s*<pair" -Q "\s*</pair" -S -t "\r?\n|\r\n?" -o " -New-Line- " -R -c || goto :Pop_Exit_Error

:: Block replacing + Range
call :Replace_And_Check -p sample-test.txt -b "\s*<pair" -Q "\s*</pair" -L 33 -N 36 -t "\bName\b" -o PairName -R -c || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -b "\s*<pair" -Q "\s*</pair" -L 37 -N 40 -t "\bName\b" -o PairName -R -c || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -b "\s*<pair" -Q "\s*</pair" -L 35 -t "\bName\b" -o PairName -q 4000 -R -c || goto :Pop_Exit_Error

:: Block replacing + Single line mode + Range
call :Replace_And_Check -p sample-test.txt -L 37 -q "\s*</pair" -S -t "\r?\n|\r\n?" -o " -New-Line- " -R -c || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -b "\s*<pair" -Q "\s*</pair" -L 35 -S -t "\r?\n|\r\n?" -o " -New-Line- " -R -c || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -b "\s*<pair" -Q "\s*</pair" -L 35 -S -t "\r?\n|\r\n?" -o " -New-Line- " -q "\s*</pair" -R -c || goto :Pop_Exit_Error
call :Replace_And_Check -p sample-test.txt -b "\s*<pair" -Q "\s*</pair" -N 36 -S -t "\r?\n|\r\n?" -o " -New-Line- " -R -c || goto :Pop_Exit_Error

del sample-test.txt sample-test-restore.txt
exit /b 0

:Pop_Exit_Error
    popd & exit /b -1

:Replace_And_Check
    set /a TestNumber+=1
    if not "%Specified_Test_Number%" == "" if not "%Specified_Test_Number%" == "%TestNumber%" ( echo Skip Test-%TestNumber%: %MSR_EXE% %* | %MSR_EXE% -aPA -e "Skip \w+" -t "(?<=Test-)\d+" & exit /b 0 )
    echo Test-Replace-File-And-Verify-!TestNumber!: %MSR_EXE% %* | %MSR_EXE% -aPA -x Test-Replace-File- -e "Verify|((%MSR_EXE%.+))" -t "And|(?<=-)\d+(?:)"
    :: Copy -> replace -> restore -> compare
    copy /y sample-file.txt sample-test.txt >nul
    for /f "tokens=*" %%a in ('%MSR_EXE% -l -p sample-test.txt --wt -PCM ^| %MSR_EXE% -t ".*?(\d+-\d+-\d+ \d+\S+).*" -o "$1" -PAC') do set "testFileTime=%%a"

    %MSR_EXE% %*  >nul
    set /a returnValue=!ERRORLEVEL!
    echo %* | %MSR_EXE% -x "Should not replace or change file" >nul
    if !ERRORLEVEL! GTR 0 (
        if !returnValue! GTR 0 (
            call :Show_Error_And_Retry %*
            exit /b 1
        )

        %MSR_EXE% -p sample-test.txt -l --w1 "%testFileTime%" --w2 "%testFileTime%" -c Check file time not changed >nul
        if !ERRORLEVEL! NEQ 1 (
            call :Show_Error_And_Retry %*
            exit /b 1
        )
    )

    call :Restore_To_Another_File >nul

    ::bcompare sample-test.txt sample-test-restore.txt
    nin sample-file.txt sample-test-restore.txt -O  || ( call :Repro_Error_Replacing %* & exit /b !ERRORLEVEL! )
    nin sample-file.txt sample-test-restore.txt -S -O || ( call :Repro_Error_Replacing %* & exit /b !ERRORLEVEL! )
    fc sample-file.txt sample-test-restore.txt >nul || ( call :Repro_Error_Replacing %* & exit /b !ERRORLEVEL! )
    for /f "tokens=*" %%a in ("sample-test-restore.txt") do if not %%~za EQU %SizeMustBe% ( call :Repro_Error_Replacing %* & exit /b !ERRORLEVEL! )
    exit /b 0


:Restore_To_Another_File
    copy /y sample-test.txt sample-test-restore.txt  >nul
    %MSR_EXE% -p sample-test-restore.txt %Restore_Pattern_Text% -Rc
    %MSR_EXE% -p sample-test-restore.txt %Restore_Pattern_New_Line% -Rc
    exit /b 0

:Repro_Error_Replacing
    copy /y sample-file.txt sample-test.txt  >nul
    %MSR_EXE% %* >nul
    call :Show_Error_And_Retry %*
    if "%HasBCompareExe%" == "1" (
        call :Restore_To_Another_File
        start bcompare sample-file.txt sample-test.txt
        nin sample-test.txt sample-test-restore.txt -I >nul || start bcompare sample-test.txt sample-test-restore.txt
        start bcompare sample-file.txt sample-test-restore.txt
        exit /b -1
    )

    echo Not found bcompare in PATH, so use nin.exe to compare content:
    copy /y sample-file.txt sample-test-restore.txt >nul
    :: Check and exit by file content , then by file size
    nin sample-file.txt sample-test-restore.txt
    for /f "tokens=*" %%a in ("sample-test-restore.txt") do if not %%~za EQU %SizeMustBe% (
        echo sample-test-restore.txt size is %%~za not equal %SizeMustBe% | %MSR_EXE% -t .+
    )

    echo Test-%TestNumber% failed: %MSR_EXE% %* | %MSR_EXE% -aPA -it "(Test-.*failed)" -e "(%MSR_EXE%.+)"
    exit /b -1

:Show_Error_And_Retry
    echo Error test: %MSR_EXE% %* | %MSR_EXE% -aPA -e "((%MSR_EXE%.+))" -t "((Error \S+))"
    :: echo You can try: %MSR_EXE% %* | %MSR_EXE% -aPA -x sample-test.txt -o sample-test-restore.txt | %MSR_EXE% -aPA -e "(%MSR_EXE%.+)" -t "((You.*?try:))"
    echo Full retry: copy /y sample-file.txt sample-test.txt AND %MSR_EXE% %* AND bcompare sample-file.txt sample-test.txt | %MSR_EXE% -aPA -x AND -o "&" -e "copy.*?\s+&|((%MSR_EXE%.*?))\s+&|bcompare.*txt" -t "((Full retry:))"
    echo Test-%TestNumber% failed: %MSR_EXE% %* | %MSR_EXE% -aPA -it "(Test-.*failed)" -e "((%MSR_EXE%.+))"
