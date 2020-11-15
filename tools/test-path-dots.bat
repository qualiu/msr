@if not exist %~dp0test-dots-path.tmp\dots\deep md %~dp0test-dots-path.tmp\dots\deep
@copy /y %~dp0*.bat %~dp0test-dots-path.tmp\
@copy /y %~dp0*.cmd %~dp0test-dots-path.tmp\dots\
@copy /y %~dp0*.txt %~dp0test-dots-path.tmp\dots\deep\
@pushd %~dp0test-dots-path.tmp\dots\
msr -c -l --sz -H 5 -T 5 -p . -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p . -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p .. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p .. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p .\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p .\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p ..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p ..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p ..\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p ..\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p ..\..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p ..\..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p ..\..\. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p ..\..\. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p ./ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p ./ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p ../ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p ../ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p ../.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p ../.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p ../../ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p ../../ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p ../../. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p ../../. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p deep -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p deep -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p deep\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p deep\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p deep\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p deep\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p deep\..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p deep\..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p .\deep\..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p .\deep\..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p . -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p . -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p .\deep -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p .\deep -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p .\deep\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p .\deep\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p .\deep\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p .\deep\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p .\deep\..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p .\deep\..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p .,deep\..\deep -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p .,deep\..\deep -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p .,.\deep\..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p .,.\deep\..\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p .,.\deep\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p .,.\deep\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p .,deep\..\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p .,deep\..\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p deep\..\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p deep\..\.. -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p deep\\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p deep\\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p %~dp0\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p %~dp0\ -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
msr -c -l --sz -H 5 -T 5 -p %~dp0test-dots-path.tmp\dots -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for"
msr -c -l --sz -H 5 -T 5 -p %~dp0test-dots-path.tmp\dots -f "\.(txt|cmd|bat)$" --nf "test-path|env.*for" -W
@popd & rd /q /s %~dp0test-dots-path.tmp
