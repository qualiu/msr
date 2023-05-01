@echo off
SetLocal EnableExtensions EnableDelayedExpansion
set ThisDir=%~dp0
if %ThisDir:~-1%==\ set ThisDir=%ThisDir:~0,-1%
msr -z "LostArg%~1" -t "^LostArg(|-h|--help|/\?)$" -M -H 0 || (
    echo Usage:  %0  Folder
    echo Example: %0 !ThisDir!\usage-by-running
    exit /b -1
)
set HtmlFolder=%1
msr -rp !HtmlFolder! --nd "\.git" -f "\.html$" -it "^<(BODY)>" -o "<\1 style=\"color: #C0C0C0; background-color: #000000; white-space: nowrap; \">" -R -c Set BODY Black background-color
msr -rp !HtmlFolder! --nd "\.git" -f "\.html$" -it "(div.* style=.)" -o "\1background-color: black; " --nx background-color -R -c Set Black background-color
msr -rp !HtmlFolder! --nd "\.git" -f "\.html$" -it "font-size: \d+px" -o "font-size: 14px" -R -c Smaller font-size
msr -rp !HtmlFolder! --nd "\.git" -f "\.html$" -t "(&nbsp;){30,}" -o "" -R -c Replace unnecessary nbsp since changed background-color to black.
:: msr -rp !HtmlFolder! --nd "\.git" -f "\.html$" -l -PAC | msr -X -c Open all html files in default browser.
