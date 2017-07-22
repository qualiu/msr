git checkout master & git checkout gh-pages checkout-master-htmls.bat
@where msr.exe 2>nul >nul || set "PATH=%~dp0\tools;%PATH%"
msr -rp . --nd "\.git" -f "\.html$" -l -PAC > master-htmls
git checkout gh-pages
for /f "tokens=*" %%a in (master-htmls) do git checkout master %%a && git add %%a
del master-htmls
msr -rp . --nd "\.git" -f "\.html$" -l -PAC | msr -x \ -o / -aPAC | msr -t .+ -o https://qualiu.github.io/msr/$0 -aPIC
