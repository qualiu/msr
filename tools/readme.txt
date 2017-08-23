Liberate & Digitize daily works by 2 exe : Data Mining; Map-Reduce; Pipe Endless.
Vivid Colorful Demo/examples: Run windows-test.bat without parameters.
Download all by command : git clone https://github.com/qualiu/msr/
If you've downloaded, run an updating command in the directory: git pull or git fetch && git reset --hard origin/master (if get conflictions)

Performance comparison with findstr and grep on Windows and Cygwin:
https://github.com/qualiu/msr/blob/master/perf/summary-full-Cygwin-comparison.md
https://github.com/qualiu/msr/blob/master/perf/summary-full-Windows-comparison.md

Match/Search/Replace: msr.exe / msr.cygwin / msr.gcc**
    Search/Replace/Execute/* Files/Pipe Lines/Blocks.
    Filter/Load/Extract/Transform/Stats/* Files/Pipe Lines/Blocks.
    
Not-In-latter: nin.exe / nin.cygwin / nin.gcc**
    Get Exclusive/Mutual Line-Set or Key-Set;
    Remove Line-Set or Key-Set matched in latter file/pipe;
    Get Unique/Mutual/Distribution/Stats/* Files/Pipe Line-Set or Key-Set.

Just run the 2 exe, you'll get their usages and examples. Besides, some script/batch/shell files are also examples.
Helpful scripts use msr.exe and nin.exe : https://github.com/qualiu/msrTools
Easy to search and get colorful usages of nin.exe/msr.exe like :
    msr | msr -it replace -e "\w*pipe\w*"         with extra key words color enhancement.
    nin | msr -it "regex.*capture" -U 3 -D 3       with Up/Down context.
    
For example, running msr and nin on Windows:

# nin.exe -------------------------------------------------
Get difference-set(not-in-latter) for first file/pipe; Or intersection-set with latter file/pipe. by LQM:
  -u [ --unique ]            Discard self/mutual duplicated lines/keys, get unique result. key = Regex capture1 value.
  -m [ --intersection ]      Get intersection of files or file/pipe: reverse default 'not-in-latter'.
  -i [ --ignore-case ]       Ignore case for text or regex pattern.
  -n [ --out-not-captured ]  Output not-captured keys/lines in first file/pipe by capture1 pattern: output not-captured + captured.
  -p [ --percentage ]        Output percentage and sort output.
  -w [ --out-whole-text ]    Output whole text of line not just capture1.
  -s [ --sort-text ]         Sort output, text comparison, if no percentage.
  -a [ --ascending ]         Ascending sort output by text or percentage.
  -d [ --descending ]        Descending sort output by text or percentage.
  -A [ --no-any-info ]       Not output any info nor summary.
  -I [ --info-normal-out ]   Output info normally : not output to stderr.
  -M [ --no-summary ]        Not output summary info.
  -O [ --out-not-0-sum ]     Output summary only if result count is not 0.
  -C [ --no-color ]          No color for output.
  -P [ --no-percent ]        Not show percentage number (if has --percentage).
  -H [ --head ] arg          Output only top [N] lines of whole output,except -T
  -T [ --tail ] arg          Output only bottom [N] lines of whole, except -H
  -S [ --switch-first ]      Switch first/latter places for files or pipe/file, and their capture1 patterns.
  -Y [ --not-from-pipe ]     Force reading from files other than pipe.
  -c [ --show-command ]      Show command line, can append text for extraction.
  -h [ --help ]              Above are optional + no order but case sensitive.

Usage  : D:\lztool\nin.exe  file1-or-pipe file2-or-nul  [file1/pipe capture1-regex]  [file2 capture1-regex]  [switches like: -i -u -m]
All [Quoted-Options] in above usage are Optional , can be omitted; 
If set [xxx-capture1-regex], Must have regex capture group[1] : Simple example like "^(.+)$" or Example-1.
If only set [file1/pipe capture1-regex] then  [file2 capture1-regex] will use the same.
If both of them not set, will use normal whole line text comparison: check lines in file1/pipe which not-in/in file2.
Example-1: nin daily-sample.txt  selected-queries.txt   "^([^\t]+)"  "query = (.+)$"   -u -i
Example-2: nin daily-sample.txt nul -u -p
Example-3: type daily-sample.txt | nin nul -up
Example-1 uses regex capture1 to get new queries: only in daily-sample.txt but not in latter file. (if use -m will get intersection set of the 2 files)
Example-2/3 are same : get unique(-u) lines in file and show each percentage(-p) with order.
Return value is line count in {only first file/pipe} or {common intersection}.
Useful options : -H 0, -M, -S, -PAC, -i -u, -iuw, -ium, iumw, -iwn, -im, -imw, -iupdw, -iupdPAC
-iwn : remove lines matched in latter from first (get lines captured + not-captured in first), ignore case.
-ium : get unique common intersection, ignore case.
-iup : get top distributions and percentages, ignore case.
nin.exe treats nul as same as /dev/null on Linux.
One important feature: nin.exe Does Not change the original line order, even use unique(-u), if no sorting (-p, -s, etc.).

Frequent use cases as Quick-Start: 
nin my.txt nul -ui :        output unique lines in my.txt ignore case.
type my.txt | nin nul -ui : output unique lines in my.txt ignore case.
nin my.txt nul "^(\w+)" -ui :  output unique keys (captured words at each line begin) in my.txt ignore case.
nin my.txt nul "^(\w+)" -uiw : output unique lines (captured line) in my.txt ignore case.
nin my.txt other.txt "(capture1-my)" "(capture1-other)" -u :    output captured key set in my.txt not in other.txt.
nin my.txt other.txt "(capture1-my)" "(capture1-other)" -u -S : output captured key set in other.txt not in my.txt.
nin my.txt other.txt "(capture1-my)" "(capture1-other)" -u -m : output mutual key set in other.txt and my.txt.
nin error.log nul "(\w*Exception)" -upd -H 30 : Get error categories, distribution and percentage, output top 30 errors.
nin error.log nul "(\w*Exception)" -upd -H 30 -I > report.txt : Save top 30 errors with summary info to report.txt.
nin error.log nul "(\w*Exception)" -upd -H 30 -PAC : Get top 30 errors of raw text without percentages and summary.
nin my-config.ini exclude.csv "name = (\w+Exception)" "(\w+Exception)" -iwn > new-config.ini : New file excludes captured in exclude.csv from captured + not-captured in my-config.ini.

One limitation: Cannot process Unicode files or pipe for now; Fine with UTF-8/ANSI/etc.

With msr.exe more powerful to load files/read pipe, extract/transform, pre/post-processing: https://github.com/qualiu/msr
For example: Remove/Display/Remove+Merge duplicated path in %PATH% and merge to new %PATH%:
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -ui
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -uipd -H 9
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -ui -PAC | msr -S -t "[\r\n]+(\S+)" -o ";$1" -aPAC | msr -S -t "\s+$" -o "" -aPAC

And search usage like: nin | msr -it switch -U 2 -D 2 -e latter

As a portable cross platform tool, nin has been running on: Windows / Cygwin / Ubuntu / CentOS / Fedora
Any good ideas please to : QQ : 94394344 , aperiodic updates and docs on https://github.com/qualiu/msr
Call@Anywhere: Add to system environment variable PATH with nin.exe parent directory: D:\lztool
	 or temporarily : SET PATH=%PATH%;D:\lztool
	 or rudely but simple and permanent: copy D:\lztool\nin.exe C:\WINDOWS


# msr.exe ------------------------------------------------
Match/Search/Replace Command/File/Pipe String/Line/Block. (IGNORE case of file and directory name) by LQM:
  -r [ --recursive ]          Recursively search sub-directories.
  -p [ --path ] arg           Directories or files, use ',' or ';' to separate. Extra separator ':' for Linux.
  -f [ --file-match ] arg     Regex pattern for file name to search.
  -t [ --text-match ] arg     Regex pattern for line text must match.
  -x [ --has-text ] arg       Line must contain this normal text (not regex)
  --nx arg                    Line must NOT contain this normal/plain text.
  --nt arg                    Pattern for lines must NOT match.
  --nf arg                    Pattern for file name must NOT match.
  --pp arg                    Pattern for full file path must match.
  --np arg                    Pattern for full file path must NOT match.
  --nd arg                    Pattern for file's parent directory names must NOT match.
  -d [ --dir-has ] arg        Pattern for file's parent directory names must has one name match.
  -i [ --ignore-case ]        Ignore case of matching/replacing text.
  -e [ --enhance ] arg        Pattern to enhance text, inferior to : -t -x -o
  -o [ --replace-to ] arg     Replace -x/-t XXX to -o XXX
  -a [ --all-out ]            Output all lines including not matched.
  -A [ --no-any-info ]        No any info nor summary, only pure result.
  -I [ --no-extra ]           Not output extra info, out summary to stderr.
  -P [ --no-path-line ]       Not out path and line number at head.
  -M [ --no-summary ]         Not output summary info.
  -O [ --out-if-did ]         Out summary info only if matched/replaced/found.
  -C [ --no-color ]           Output without color effect.
  -F [ --time-format ] arg    Time pattern: use captured group[1] if has, else group[0].
  -B [ --time-begin ] arg     like "2013-01-10 11:00:00", just text NOT time.
  -E [ --time-end ] arg       like "2013-01-10 15:30", text NOT time comparing.
  -s [ --sort-by ] arg        Sort by pattern: captured group[1] if has, else group[0].
  --dsc                       Descending order to sort and output result.
  -l [ --list-count ]         Only display file path list or matched count.
  --wt                        Display/sort by file last write time(with -l)
  --w1 arg                    File write time >= like "2013-01-10 01:00:00".
  --w2 arg                    File write time <= like "2013-01-10 12:30".
  --sz                        Display/sort by file size(with -l): B,KB,MB,GB,*
  --s1 arg                    File size >= like 100kb (No Space, B if no unit)
  --s2 arg                    File size <= like 2.5M (No Space, B if no unit)
  -R [ --replace-file ]       Replace files, search text by -x/-t XXX , replace to -o XXX
  -K [ --backup ]             Backup files if changed: replaced content.
  -S [ --single-line ]        Single line mode for Regex to match/replace.
  -g [ --replace-times ] arg  Replace times for single line mode. Default = 1
  -c [ --show-command ]       Show command line, and can append text for extraction.
  -U [ --up ] arg             Out above lines of matched by -t or found by -x
  -D [ --down ] arg           Out below lines of matched by -t or found by -x
  -H [ --head ] arg           Out only top [N] lines of whole output,except -T
  -T [ --tail ] arg           Out only bottom [N] lines of whole, except -H
  -J [ --jump-out ]           Jump out if has -H [N], output line count >= [N].
  -L [ --row-begin ] arg      Begin row number of reading pipe or each file.
  -N [ --row-end ] arg        End row number of reading pipe or each file.
  -b [ --start-block ] arg    Regex pattern to begin matching text, or a block matching begin with -Q.
  -q [ --stop-at-once ] arg   Regex pattern to stop reading/replacing at once.
  -Q [ --stop-block ] arg     Regex pattern of a block matching end with -b.
  -y [ --reuse-block-end ]    Reuse a matched block end as a/next block begin. For cases of -Q as next -b.
  -X [ --execute-out-lines ]  Execute final out lines as commands.
  -Y [ --not-from-pipe ]      Force reading from files other than pipe.
  -z [ --string ] arg         Input a string instead of reading files or pipe.
  --verbose                   Show parsed arguments and return value, etc.
  -v [ --show-time ] arg      Show time at head, format like: z,s,m,o,zd,zdo
  -u [ --show-elapse ]        Show used time at output header.
  -m [ --show-count ]         Show matched count at output header.
  -h [ --help ]               See usage and https://github.com/qualiu/msr

Note: Return value is the matched/replaced count in files or pipe.
(1) Skip/Stop reading + Arbitrary block matching: 
    -L/-N: set row range for a pipe or each file: line number begin and end.
    -b/-q: set row range by begin/end Regex pattern; -q stops immediately. 
    -b/-Q: set begin/end Regex pattern to match multiple arbitrary blocks in pipe or each file, with -a to output each entire block.
    -L/-b and -N/-Q/-q can all be used at same time, contains the boundary which begin and end line.
    Special meaning of --nt/--nx for block matching(-b + -Q): --nt and --nx exclude a block if one of it's lines matches one of them.
    Special meaning of -S for block matching: -S just has 'single line' meaning for each block, other than whole text in each file or pipe.
    -B and -E only textually/literally compare with time text matched by -F XXX , not parse the text of -B and -E to time then compare.
    If replacing files, -R (--replace-file), will just copy the lines that out of -L/-b and -N/-Q/-q.
    -R does NOT change files if no lines replaced; Preview replacing result without -R.
    -K (--backup) to backup files if changed, append modify-time (--yyyy-MM-dd__HH_mm_ss) to backup file name. If exists, will append '-N' and N start from 1.
(2) Replace text/files By Regex expression or normal/plain text:
    If use both -t (--text-match) and -x (--has-text), will use the closer one to -o (--replace-to); 
    But if -t and -x distances to -o are same, replace by the prior one ( in command line position ).
(3) Sort output or file list by time or size: (sort result by time/key see usage and bottom examples)
    Both --sz and --wt only work with -l (--list-count) to display and sort by file size and last-write-time;
    sort by the prior one (in command line position) if use both of them.
    --sort-by/-s will sort output by captured regex group[1], if no group[1] by group[0];
    If input empty regex pattern "" for -s, then -s will use the pattern of -t; If no -t then try -x if it's a valid regex pattern.
(4) Execute output line as command : If has -X (--execute-out-lines): 
    -P will not output lines(commands) before executing;
    -I will not output each execution summary;  -O will not output execution summary if return value = 0.
    -A will omit both of them and new lines (which separates executions).
    -Y to force reading from files other than pipe. -Y is rarely used, only for cases which msr cannot know where to read from : files or pipe. For example, remove the -p . and -Y below:
    echo for /F "tokens=*" %a in ('msr -l -p . -H 3 -PICc -Y') do msr -Y -l -c --wt --sz -p %a | msr -X
(5) Further extraction by summary:
    Use -c (--show-command), you can append any text to the command line.
    Use -O to out summary only if matched/replaced/found or execution-result != 0.
    Use -H 0 or -T 0 if you just want summary info.
    Use -J to jump out: stop reading files/pipe if has -H [N] and output line count exceeds [N].
(6) Map <--> Reduce : -o transforms one line to multi-lines; -S changes -t to single-line Regex mode.
    msr -p my.log -t "host-list=([\d\.]+),(\d\.]+),([^,]+)" -o "${1}\n$2\n$3" -P -A -C | msr -S -t "(\d+\.[\d\.]{4,})[\r\n]*" -o "$1," -PAC | msr ... | msr ...
    ipconfig | msr -t "^.*?(\d+\.[\d\.]{4,}).*$" -o "$1" -PAC | msr -S -t "\s+(\S+)" -o "|$1" -PAC
(7) Quick look up usage by self : Also helpful to look up system/other tool usages with brief context (Up/Down lines)
    msr | msr -i -t sort -U 3 -D 3 -e time
    robocopy /? | msr -it mirror -U 3 -D 3 -e purge

Additional feature: Directly read and match text by -z (--string instead of using echo command on Windows which must escape | to ^|  in for-loop)
    Example: Finding non-exist path in %PATH% and olny check 3 header + 3 tailer paths:
    msr -z "%PATH%" -t "\s*;\s*" -o "\n" -PAC | msr -t .+ -o "if not exist \"$0\" echo NOT EXIST $0"  -PI -H 3 -T 3 -X

Example-1 : Find env in profiles:
    D:\lztool\msr.exe --recursive --path "/home/qualiu , /etc , /d/cygwin/profile"  --file-match "\.(env|xml|\w*rc)$"  --text-match "^\s*export \w+=\S+" --ignore-case

Example-2 : Find error in log files : row text (contain time) start matching(-t xxx) from -B xxx with given format(-F xxx); last-write-time between [--w1,--w2]
    msr -rp /var/log/nova/,/var/log/swift -f "\.log$"  -F "^(\d{2,4}-\d+-\d+ [\d+:]+(\D\d+)?)" -B "2013-03-12 14" -i -t "\b(error|fail|fatal|exception)"  --w1 2013-03-12 --w2 "2013-03-13 09"

Example-3 : Recursively(-r) replace-file(-R) : IP tail in <SQL> or <Connection>; Only in xxx-test directory skip Prod-xxx; Skip rows>=200 for each file; Backup(-K) if changed.
    msr -rp  .  -f "\.xml$" -d "\w+-test$" --nd "Prod-\w+" -b "^\s*<SQL|Connection>" -Q "^\s*</(SQL|Connection)>" -N 200 -it "(\d{1,3})\.(\d{1,3})\.\d{1,3}\.\d{1,3}" -o "${1}.$2.192.203" -RK 

Example-4 : Read Pipe : such as : type query.txt | msr -t words -PAC 2>nul | msr -PIC -xxx ...
    ipconfig | msr -t "^.*?(\d+\.[\d\.]{4,}).*$"  -o "${1}" -PAC

Example-5 : Single-line regex mode replacing whole text in each file and backup (preview without -R)
    msr -rp "%CD%" -f "config\w*\.(xml|ini)$" -S -t "(<Command>).*?(</Command>)" -o "$1 new-content ${2}" -RK 

Example-6 : Multi-line regex mode (normal mode) replacing lines in each file and backup (preview without -R)
    msr -rp spark\bin,spark\test -f "\.(bat|cmd)$"  -it "^(\s*@\s*echo)\s+off\b" -o "$1 on" -R -K 

Example-7 : Display current modified code files : Now time = 2017-09-12 15:42:19.497906 CST - China Standard Time
    for /f %a in ('msr -l -f "\.(cs|java|cpp|cx*|hp*|py|scala)$" -rp "%CD%" --nd "^(debug|release)$"  --w1 "2017-09-12 15:42:19" -PAC 2^>nul ') do @echo code file : %a

Example-8 : Get 2 oldest and newest mp3 (4 files) which 3.0MB<=size<=9.9MB and show size unit, in current directory (Can omit -p . or -p %CD%)
    msr -l --wt -H 2 -T 2 -f "\.mp3$" --sz --s1 3.0MB --s2 9.9m

Example-9 : Find files in %PATH% environment variable: such as ATL*.dll, 2 methods: 
    for /f "tokens=*" %d in ('msr -z "%PATH%" -t "([^;]+);*" -o "$1\n" -PAC ^| msr -t "\\\s*$" -o "" -aPAC') do @msr -l --wt --sz -p "%d" -f "^ATL.*\.dll$" -O 2>nul
    msr -l --wt --sz -p "%PATH%" -f "^ATL.*\.dll$" -M 2>nul

All optoins/switches are optional + no order + effective mean while, but case sensitive.
Can merge single char switches/options+values like : -rp -it -ix -PIC -PAC -POC -PIOCcl -PICc -PICcl , -mu -v zod, -muvzod, -uvz
Useful options : -H 0, -M, -O, -PAC, -PIC, -POC, -POlCc, -XI, -XIP, -XA, -XO, -XOPI, -muvz, 2>&1, 2>nul (2^>nul in pipe)
Like watching time/elapsed/matched (-muvzd): msr | msr -it show -v zdo -u -m

One limitation: Cannot process Unicode files or pipe for now; Fine with UTF-8/ANSI/etc.

Helpful commands - Just 1 command line: Preview replacing just remove -R
(1) Remove white spaces at each line tail in each file in directories:
    msr -r -p dir-1,dir2,file1,file2 -f "\.(cpp|cxx|hp*|cs|java|scala|py)$" -t "\s+$" -o ""  -R
(2) Replace tab(\t) to 4 spaces at line beginning in files: Run in loop until Return/Exit code %ERRORLEVEL% = 0: 
    msr -rp directory-1,dir-2 -f "\.(cpp|cxx|hp*|cs|java|scala|py)$" -t "^(\s*)\t" -o "$1    " -R
(3) Find top 100 largest old garbage log files which size >= 30MB:
    msr -rp directory-1,dir-2 -f "\.(log)$" -l --sz --s1 30MB --w2 "2015-07-27 12:30" -H 100 --dsc -PIC
(4) Get command lines to delete top 100 largest old garbage log files which size >= 30MB:
    msr -rp directory-1,dir-2 -f "\.(log)$" -l --sz --s1 30MB --w2 "2015-07-27 12:30" -H 100 --dsc -PAC | msr -t .+ -o "del /f /q /s \"$0\"" -PIC
(5) Delete top 100 largest old garbage log files which size >= 30MB:
    msr -rp directory-1,dir-2 -f "\.(log)$" -l --sz --s1 30MB --w2 "2015-07-27 12:30" -T 100 -PAC | msr -t .+ -o "del /f /q /s \"$0\"" -X -PI
(6) Delete top 100 largest old garbage log files which size >= 30MB:
    msr -rp directory-1,dir-2 -f "\.(log)$" -l --sz --s1 30MB --w2 "2015-07-27 12:30" -T 100 -PAC | msr -t .+ -o "del /f /q /s \"$0\"" -H 100 -XPI
(7) Check tail new line: Return/Exit code %ERRORLEVEL% > 0 if has a new line:
    msr -p my-file -S -t "[\r\n]+$" -H 0 -PIC
(8) Replace files to have only one new line at tail: (Add a new line or remove redundant new lines)
    msr -rp directory-1,dir-2 -f "\.(cpp|cxx|hp*|cs|java|scala|py)$" -S -t "(\S+)\s*$" -o "$1\n" -R
(9) Remove tail new lines and white spaces in pipe result:
    msr --help -C | msr -S -t "\s*$" -o "" -P
(10) Get precise time of now in millisecond; in seconds with abbreviation CST of time zone: China Standard Time
    msr -hC | msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+(\w+)?.*" -o "$1 $2 $5" -PAC
    msr -hC | msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+(\w+)?.*" -o "$1 $2.$3" -PAC
(11) Get precise time of now in microsecond and set to %TimeNow% variable for latter commands: 
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+(\w+)?.*" -o "$1__$2.$3$4" -PAC ^| msr -t ":" -o _ -aPAC') do SET "TimeNow=%a"
(12) Debug batch files, turn on all ECHO/echo:
    msr -rp directory-1,dir-2 -f "\.(bat|cmd)$" -it "\b(echo)\s+off\b" -o "$1 on"  -R

Final brief instruction as Quick-Start: Use -PAC to get pure output as other tools like findstr/grep/egrep/etc.
(1) Search files by plain text matching : msr -rp dir1,dir2,fileN -x "my plain text" -PAC
(2) Search in files with Regex pattern  : msr -rp dir1,dir2,fileN -t "my.*(capture-1).*pattern" 
(3) Search files & Replace matched text : msr -rp dir1,dir2,fileN -t "my.*(capture-1).*pattern" -o "captured $1 and you want" 
(4) Replace files and Backup if changed : msr -rp dir1,dir2,fileN -t "my.*(capture-1).*pattern" -o "captured $1 and you want" -R -K
(5) Get matched file list + distribution: msr -rp dir1,dir2,fileN -t "my.*(capture-1).*pattern" -l --nd "^(target|bin)$" 
(6) Extract or replace arbitrary blocks : msr -rp dir1,dir2,fileN -t "my.*(capture-1).*pattern" -b "block-begin" -Q "block-end" -f "\.(xml|ini|conf)$" -o "$1 something"

Search usage like: msr | msr -t Backup -U 2 -D 2 -e replace
With nin.exe more powerful to remove duplication, get exclusive/mutual key/line set, top distribution: https://github.com/qualiu/msr
For example: Remove/Display/Remove+Merge duplicated path in %PATH% and merge to new %PATH%:
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -ui
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -uipd -H 9
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -ui -PAC | msr -S -t "[\r\n]+(\S+)" -o ";$1" -aPAC | msr -S -t "\s+$" -o "" -aPAC

As a portable cross platform tool, msr has been running on: Windows / Cygwin / Ubuntu / CentOS / Fedora
Any good ideas please to : QQ : 94394344 , aperiodic updates and docs on https://github.com/qualiu/msr
Call@Anywhere: Add to system environment variable PATH with msr.exe parent directory: D:\lztool
	 or temporarily : SET PATH=%PATH%;D:\lztool
	 or rudely but simple and permanent: copy D:\lztool\msr.exe C:\WINDOWS
