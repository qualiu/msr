Liberate & Digitize daily works by 2 exe: File Processing, Data Mining, Map-Reduce.
Most time Just 1 command line to solve your daily text or file processing work, pipe endless.
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
  -u [ --unique ]              Get unique results, discard self/mutual duplicate lines/keys (key = captured groups[1] if set Regex pattern).
  -m [ --intersection ]        Get mutual lines/keys intersection in 2 files or file-with-pipe (default is exclusive: 'not-in-latter').
  -i [ --ignore-case ]         Ignore case for plain text matching or Regex pattern.
  -n [ --out-not-captured ]    Also output not-captured keys/lines of Regex pattern in first file/pipe.
  -p [ --percentage ]          Output key percentage at each line head, and sort output.
  -w [ --out-whole-line ]      Output matched lines other than keys (key = captured groups[1] of Regex pattern).
  -a [ --ascending ]           Ascending sort output by line or captured-key or percentage.
  -d [ --descending ]          Descending sort output by line or captured-key or percentage.
  -k [ --stop-at-count ] arg   Stop if matched count of a key/line > [N] when ascending output, or if count < [N] when descending output.
  -K [ --stop-percentage ] arg Stop if matched percentage of a key/line > [P%] when ascending output, or if percentage < [P%] when descending output.
  -A [ --no-any-info ]         Not output any info nor summary, only pure result (Please always use -PAC or -PIC to get pure result).
  -I [ --info-normal-out ]     Output summary info to stdout (default is to stderr).
  -M [ --no-summary ]          Not output summary info.
  -O [ --out-not-0-sum ]       Output summary only if result count is not 0.
  -C [ --no-color ]            No color effect for output (Can ignore this on Windows. For Linux it's better to set if has latter matching).
  -P [ --no-percent ]          Not output percentage number at line head (Overwrite --percentage).
  -H [ --head ] arg            Output top [N] lines of whole output if N > 0; Skip top [N] lines if N < 0; [N] = 0 means not output.
  -T [ --tail ] arg            Output bottom [N] lines of whole output if N > 0; Skip bottom [N] lines if N < 0; [N] = 0 means not output.
  -J [ --jump-out ]            Jump out (stop and exit) if has set -H [N] and already has output [N] lines.
  -S [ --switch-first ]        Switch positions (first/latter roles) of 2 files or file/pipe (also will switch their Regex patterns).
  -Y [ --not-from-pipe ]       Force reading from files other than pipe (to avoid reading pipe if running in another command).
  -c [ --show-command ]        Show command line, and you can append text after -c (if append text, -c and text must be last).
  -Z [ --skip-last-empty ]     Skip last empty line in first/latter file.
  -x [ --has-text ] arg        Line must contain this normal/plain text (Can use meanwhile: -t, -x, --nt, --nx).
  --nx arg                     Line must NOT contain this normal/plain text.
  -t [ --text-match ] arg      Regex pattern for line text must match (Can use meanwhile: -t, -x, --nt, --nx).
  --nt arg                     Regex pattern for lines must NOT match.
  --verbose                    Show parsed arguments, return value, time zone and EXE path, etc.
  -h [ --help ]                See usage and examples below. More detail: https://github.com/qualiu/msr

Usage: nin  File1-or-pipe  File2-or-nul  [Regex-capture1-pattern-1]  [Regex-capture1-pattern-2]  [Options like: -i -u -m -w -H 2 -t xxx --nt xxx]
All [Quoted Args Options] above are Optional, can be omitted.
If has set [Regex-capture1-pattern-N], Must have Regex capture group[1]: Simple examples like: "^(.+)$" or "(.+)" or "^(\S+)" or "^([^\t]+)" or "^(\w+)" etc. 
If only set [Regex-capture1-pattern-1] then [Regex-capture1-pattern-2] will use the same.
If both of them not set, will use normal whole line text comparison: check lines in file1/pipe which not-in/in file2.
Example-1: D:\lztool\nin.exe daily-sample.txt  selected-queries.txt   "^([^\t]+)"  "query = (.+)$"   -u -i
Example-2: nin daily-sample.txt nul -u -p
Example-3: type daily-sample.txt | nin nul -up
Example-1 uses regex capture1 to get new queries: only in daily-sample.txt but not in latter file. (if use -m will get intersection set of the 2 files)
Example-2/3 are same : get unique(-u) lines in file and show each percentage(-p) with order.

Return value/Exit code(%ERRORLEVEL%) = matched line/key count in {first file/pipe} or {mutual intersection}.
But if Return value = 0 and caught N errors, will set Return value = -N which is error count.
All error messages will be output to stderr . You can redirect them to stdout by appending 2>&1 to your command line.

Useful options : -H 20 -J, -H 0, -T 3, -k 30, -K 33.33, -T -1, -M, -S, -PAC, -i -u, -iuw, -iuwa, -ip, -ipa, -ipdw, -ium, iumw, -iwn, -im, -imw, -ipdPAC
-iwn : Remove lines matched in latter from first (get lines captured + not-captured in first, except captured in latter), ignore case.
-ium : Get unique mutual intersection, ignore case.
-ipd : Get top distributions and percentages by descending order, ignore case.
nin treats nul as same as /dev/null on Linux.
One important feature: nin.exe Does Not change the original line order, even if used unique(-u), if no sorting (-p, -a/-d, etc.).

Frequent use cases as Quick-Start: Use -PAC or -PC to get pure output result.
nin my.txt nul -ui :        output unique lines in my.txt ignore case.
type my.txt | nin nul -ui : output unique lines in my.txt ignore case.
nin my.txt nul "^(\w+)" -ui :  output unique keys (captured words at each line begin) in my.txt ignore case.
nin my.txt nul "^(\w+)" -uiw : output unique lines (captured line) in my.txt ignore case.
nin my.txt other.txt "(capture1-my)" "(capture1-other)" -u :    output captured key set in my.txt not in other.txt.
nin my.txt other.txt "(capture1-my)" "(capture1-other)" -u -S : output captured key set in other.txt not in my.txt.
nin my.txt other.txt "(capture1-my)" "(capture1-other)" -u -m : output mutual key set in other.txt and my.txt.
nin error.log nul "(\w*Exception)" -pd -H 30 : Get error categories, distribution and percentage, output top 30 errors.
nin error.log nul "(\w*Exception)" -pd -H 30 -I > report.txt : Save top 30 errors with summary info to report.txt.
nin error.log nul "(\w*Exception)" -pd -H 30 -PAC : Get top 30 errors of raw text without percentages and summary info.
nin my-config.ini exclude.csv "name = (\w+Exception)" "(\w+Exception)" -iwn > new-config.ini : Output whole lines in my-config.ini except lines also captured in exclude.csv .
nin -h -C | nin nul "^\s{2}(-+\S+)\s+" -w --nt help : Get all command options of nin and output with original order.
nin -h -C | nin nul "^\s{2}-(\w)\s+" -wa --nt help : Get all single letter command options of nin and output with ascending order.
nin -h -C | nin nul "^\s{2}-(\w)\s+" -wpdi : Get percentages of nin single letter command options.
nin -h -C | nin nul "^\s{2}-(\w)\s+" -wpdi -k 2 : Get percentages of nin single letter command options which matched count >= 2.
nin -h -C | nin nul "^\s{2}-(\w)\s+" -wpdi -K 5.0 : Get percentages of nin single letter command options which percentage >= 5%.
nin -h -C | nin nul "^\s{2}-(\w)\s+" -wpdi -k 2 -K 5.0 -P : Get percentages of nin single letter command options: count >= 2 and percentage >= 5% without percentage info.

One limitation: Cannot process Unicode files or pipe for now; Fine with UTF-8/ANSI/etc.

With msr.exe more powerful to load files/read pipe, extract/transform, pre/post-processing: https://github.com/qualiu/msr
For example: Remove/Display/Remove+Merge duplicate path in %PATH% and merge to new %PATH%:
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -ui
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -uipd -H 9
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -ui -PAC | msr -S -t "[\r\n]+(\S+)" -o ";$1" -aPAC | msr -S -t "\s+$" -o "" -aPAC

And search usage like: nin | msr -it return.*value  or  nin -hC | msr -it "summary.*stdout|jump out"  or  nin | msr -it switch -U 2 -D 2 -e latter

As a portable cross platform tool, nin has been running on: Windows / Cygwin / Ubuntu / CentOS / Fedora
Any good ideas please to : QQ : 94394344 , aperiodic updates and docs on https://github.com/qualiu/msr , more tools/examples see: https://github.com/qualiu/msrTools
Call@Everywhere: Add to system environment variable PATH with nin.exe parent directory: D:\lztool
	 or temporarily: SET "PATH=%PATH%;D:\lztool"
	 or rudely but simple and permanent: copy D:\lztool\nin.exe C:\WINDOWS\


# msr.exe ------------------------------------------------
Match/Search/Replace String/Lines/Blocks in Command/Files/Pipe. (IGNORE case of file and directory name) by LQM:
  -r [ --recursive ]          Recursively search files in descendant directories.
  -k [ --max-depth ] arg      Maximum depth to search directories (begin depth = 1 from/for each input path). Default maximum depth = 33.
  -p [ --path ] arg           Source paths (directories or files) to find/read: Use ',' or ';' to separate paths; Extra separator ':' for Linux.
  -w [ --read-paths ] arg     Read source path lines from files: Use ',' or ';' to separate files; Extra separator ':' for Linux.
  -f [ --file-match ] arg     Regex pattern for file name to search.
  -t [ --text-match ] arg     Regex pattern for line text must match (Can use meanwhile: -t, -x, --nt, --nx, -e).
  -x [ --has-text ] arg       Line must contain this normal/plain text (Can use meanwhile: -t, -x, --nt, --nx, -e).
  --nx arg                    Line must NOT contain this normal/plain text.
  --nt arg                    Regex pattern for lines must NOT match.
  --nf arg                    Regex pattern for file name must NOT match.
  --pp arg                    Regex pattern for full file path must match.
  --np arg                    Regex pattern for full file path must NOT match.
  --nd arg                    Regex pattern for file's parent directory names must NOT match.
  -d [ --dir-has ] arg        Regex pattern for file's parent directory names must has one name matched at least.
  --xd                        Skip link directories.
  --xf                        Skip link files.
  -i [ --ignore-case ]        Ignore case of matching/replacing for -t/-x/-e . You can add to one of them like: -it/-ix/-ie .
  -e [ --enhance ] arg        Regex pattern to enhance text (just add color from some text), inferior to : -t -x -o.
  -o [ --replace-to ] arg     Replace text from -x/-t XXX to -o XXX .
  -j [ --out-replaced ]       Just output replaced lines by -o xxx (no impact to replacing file, -R will ignore this).
  -a [ --out-all ]            Output all lines including not matched; Or each whole block range if used -b and -Q.
  -W [ --out-full-path ]      Output full paths if input relative paths by -p or -w. This can avoid duplicates and trim extra slashes and dots.
  -A [ --no-any-info ]        Not output any info nor summary, warnings etc., only pure result (Please always use -PAC or -PIC to get pure result).
  -I [ --no-extra ]           Not output extra info and warnings; Output summary to stderr.
  -P [ --no-path-line ]       Not output path and line number at head of each line.
  -M [ --no-summary ]         Not output summary info.
  -O [ --out-if-did ]         Output summary info only if matched/replaced/found.
  -C [ --no-color ]           No color effect for output (Can ignore color on Windows. For Linux it's better to without color if has latter matching).
  -Z [ --skip-last-empty ]    Skip last empty line in each file.
  -F [ --time-format ] arg    Regex pattern to grep time for -B and -E , will use captured group[1] if has, else group[0].
  -B [ --time-begin ] arg     Begin time, format like "2013-01-10 11:00:00". Just text comparison NOT time.
  -E [ --time-end ] arg       End time, format like "2013-01-10 15:30". Just text comparison NOT time.
  -s [ --sort-by ] arg        Regex pattern to sort result lines by captured group[1] if has, else by group[0]. If set to "" will try groups from -t .
  -n [ --sort-as-number ]     If has used -s : Convert to number or decimal at first then sort the captured group[1] or group[0] of -s .
  --dsc                       Descending order for sorting of matching (-t/-x), list(-l with --wt --sz), sorting-key (-s), time (-F with -B -E), etc.
  -l [ --list-count ]         Only output matched file path list or matched count.
  --wt                        Sort file list by last write time (with -l). If used both --wt and --sz, order by prior then by latter.
  --w1 arg                    Lower bound of file write time, format like "2013-01-10T01:00:00", as a filter to list/find/replace files.
  --w2 arg                    Upper bound of file write time, format like "2013-01-10 12:30", as a filter to list/find/replace files.
  --sz                        Sort file list by file size (with -l) and display with unit like: B,KB,MB,GB,* etc.
  --s1 arg                    Lower bound of file size, format like 100kb (No Space between number and unit, use B if no unit).
  --s2 arg                    Upper bound of file size, format like 2.5M (No Space between number and unit, use B if no unit).
  -R [ --replace-file ]       Replace files, search text by -x/-t XXX , replace to -o XXX. Without this, just preview replacing.
  -K [ --backup ]             Backup files if replaced files content (Rename them by appending last write times like: --bak-2018-06-08__09_15_20).
  --force                     Force replacing BOM files. Default only replace UTF-8 BOM files which header bytes = 0xEFBBBF.
  -S [ --single-line ]        Single line Regex mode to match/replace (Treat each file or pipe as one line).
  -g [ --replace-times ] arg  Maximum times to replace a line text with --replace-to. Use a big number or -1 to replace radically. Default = 1.
  -c [ --show-command ]       Show command line, and you can append text after -c for summary or further extraction.
  -U [ --up ] arg             Output [N] lines above matched line by -t or/and found by -x.
  -D [ --down ] arg           Output [N] lines below matched line by -t or/and found by -x.
  -H [ --head ] arg           Output top [N] lines of whole output if N > 0; Skip top [N] lines if N < 0; [N] = 0 means not output.
  -T [ --tail ] arg           Output bottom [N] lines of whole output if N > 0; Skip bottom [N] lines if N < 0; [N] = 0 means not output.
  -J [ --jump-out ]           Jump out (stop and exit) if has set -H [N] and already has outputted [N] lines.
  -L [ --row-begin ] arg      Begin row number of reading/matching/replacing pipe or each file.
  -N [ --row-end ] arg        End row number of reading/matching/replacing pipe or each file.
  -b [ --start-block ] arg    Regex pattern to begin matching text; If with -Q this will be block begin pattern for each block.
  -q [ --stop-at-once ] arg   Regex pattern to stop reading/matching/replacing pipe or each file.
  -Q [ --stop-block ] arg     Regex pattern of a block end (must has set -b) ; Can set to "" if same with -b.
  -y [ --reuse-block-end ]    Reuse a matched block end as next block begin (For cases of a line matched by -Q as next block begin for -b).
  -X [ --execute-out-lines ]  Execute each final output line as a command. Will show command -> run -> show return value, if no: -P -I -A.
  -Y [ --not-from-pipe ]      Force reading from files other than pipe (To avoid reading pipe if running in another command and no reading paths set).
  -z [ --string ] arg         Input a string and read from it (without reading files or pipe). You can also use it to learn/test Regex, or test input args.
  --verbose                   Show parsed arguments, return value, time zone and EXE path, content error rows, BOM infos, link files' real paths, etc.
  -m [ --show-count ]         Show matched count at each output line head.
  -u [ --show-elapse ]        Show used time at output line head.
  -v [ --show-time ] arg      Show time at each output line head: s,dz,dzs,dzo (s = second, m = millisecond, o = microsecond; d = date, z = zone, t = offset).
  -h [ --help ]               See usage and examples below. More detail: https://github.com/qualiu/msr

Return value/Exit code(%ERRORLEVEL%) = matched/replaced count of lines/blocks/files in files or pipe.
But if Return value = 0 and caught N errors, will set Return value = -N which is error count.
If used -X(--execute-out-lines): Return value = non-zero-return-count of all executions if executed count > 1; Return value = One command line return value if executed count = 1.
All error messages will be output to stderr . You can redirect them to stdout by appending 2>&1 to your command line.

Detail instruction and examples ( Quick-Start at bottom is more brief ):
(1) Skip/Stop reading + Arbitrary block matching: 
    -L/-N: set row range for a pipe or each file: line number begin and end.
    -b/-q: set row range by begin/end Regex pattern; -q stops immediately for a pipe or each file. 
    -b/-Q: set begin/end Regex pattern to match multiple arbitrary blocks in pipe or each file, with -a to output each entire block.
    -L/-b and -N/-Q/-q can all be used at same time, contains the boundary which begin and end line.
    Special meaning of --nt/--nx for block matching(-b + -Q): --nt and --nx exclude a block if one of it's lines matches one of them.
    Special meaning of -S for block matching: -S just has 'single line' meaning for each block, other than whole text in each file or pipe.
    -B and -E only textually/literally compare with time text matched by -F XXX , not parse the text of -B and -E to time then compare.
    If replacing files, -R (--replace-file), will just copy the lines that out of -L/-b and -N/-Q/-q.
    -R does NOT change files if no lines replaced; Preview replacing result without -R.
    -K(--backup) to backup files if changed, append modify-time (--yyyy-MM-dd__HH_mm_ss) to backup file name. If exists, will append '-N' and N start from 1.
(2) Replace text/files By Regex expression or normal/plain text: (To not output immediate replaced info, use anyone of : -A , -I , -H 0 , -T 0 )
    If used both -t (--text-match) and -x (--has-text), will use the closer one to -o (--replace-to); 
    But if -t and -x distances to -o are same, replace by the prior one ( in command line position ).
(3) Sort output or file list by time or size: (sort result by time/key see usage and bottom examples)
    Both --sz and --wt only work with -l (--list-count) to display and sort by file size and last-write-time;
    sort by the prior one (in command line position) if used both of them.
    -s(--sort-by) will sort output by captured regex group[1], if no group[1] will try group[0] of -F(--time-format) at first, then try -t(--text-match) (if found).
    If input empty regex pattern "" for -s, then -s will sort by the pattern of -F(--time-format) if found; else check and use the pattern of -t(--text-match) to sort.
(4) Execute output line as command : If has -X (--execute-out-lines): 
    -P(--no-path-line) will not output lines(commands) before executing;
    -I(--no-extra) will not output each execution summary;  -O(--out-if-did) will not output execution summary if return value = 0.
    -A(--no-any-info) will not output any info or summary, and new lines (which separates executions).
    -Y(--not-from-pipe) to force reading from files other than pipe. -Y is rarely used, only for cases which msr cannot know where to read from : files or pipe. 
    For example, you can remove the -p . and -Y below, then run it, you will see that using -Y can avoid reading pipe:
    echo for /F "tokens=*" %a in ('msr -l -p . -H 3 -PICc -Y') do msr -Y -l -c --wt --sz -p %a | msr -X
(5) Further extraction by summary:
    Use -c (--show-command), you can append any text to the command line.
    Use -O to out summary only if matched/replaced/found or execution-result != 0.
    Use -H 0 or -T 0 if you just want summary info, without other outputs.
    Use -J to jump out: Quit(exit) if has set -H [N] and output line count exceeds [N].
(6) Map <--> Reduce : -o transforms one line to multi-lines; -S changes -t to single-line Regex mode.
    msr -p my.log -t "host-list=([\d\.]+),(\d\.]+),([^,]+)" -o "${1}\n$2\n$3" -P -A -C | msr -S -t "(\d+\.[\d\.]{4,})[\r\n]*" -o "$1," -PAC | msr ... | msr ...
    ipconfig | msr -t "^.*?(\d+\.[\d\.]{4,}).*$" -o "$1" -PAC | msr -S -t "\s+(\S+)" -o "|$1" -PAC
(7) Quick look up usage by self : Also helpful to look up system/other tool usages with brief context (Up/Down lines)
    msr | msr -i -t sort -U 3 -D 3 -e time
    robocopy /? | msr -it mirror -U 3 -D 3 -e purge

Additional feature: Directly read and match text by -z (--string instead of using echo command on Windows which must escape | to ^|  in for-loop)
    Example: Finding non-exist path in %PATH% and only check 3 head(top) + 3 tail(bottom) paths:
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
    msr -rp myApp\bin,myApp\scripts,D:\myApp\tools -f "\.(bat|cmd)$"  -it "^(\s*@\s*echo)\s+off\b" -o "$1 on" -R -K 

Example-7 : Display current modified code files:
    for /f %a in ('msr -l -f "\.(cs|java|cpp|cx*|hp*|py|scala)$" -rp "%CD%" --nd "^(debug|release)$"  --w1 "2018-06-08 09:15:20" -PAC 2^>nul ') do @echo code file : %a

Example-8 : Get 2 oldest and newest mp3 (4 files) which 3.0MB<=size<=9.9MB and show size unit, in current directory (Can omit -p . or -p %CD%)
    msr -l --wt -H 2 -T 2 -f "\.mp3$" --sz --s1 3.0MB --s2 9.9m

Example-9 : Find files in %PATH% environment variable: such as ATL*.dll, 2 methods: 
    for /f "tokens=*" %d in ('msr -z "%PATH%" -t "([^;]+);*" -o "$1\n" -PAC ^| msr -t "\\\s*$" -o "" -aPAC') do @msr -l --wt --sz -p "%d" -f "^ATL.*\.dll$" -O 2>nul
    msr -l --wt --sz -p "%PATH%" -f "^ATL.*\.dll$" -M 2>nul

All options/switches are optional + no order + effective mean while, but case sensitive.
Can merge single char switches/options+values like : -rp -it -ix -PIC -PAC -POC -PIOCcl -PICc -PICcl , -mu -v zod, -muvzod, -uvz
Useful options : -a, -H 3, -H 3 -J, -H 0, -T 3, -T -1, -M, -O, -PAC, -PIC, -POC, -POlCc, -XI, -XIP, -XA, -XO, -XOPI, -muvz, 2>&1, 2>nul (2^>nul in pipe)
Like watching time/elapsed/matched (-muvzd): msr | msr -it show -v zdo -u -m

One limitation: Cannot process Unicode files or pipe for now; Fine with UTF-8/ANSI/etc.

Helpful commands - Just 1 command line: Preview replacing just remove -R
(1) Remove white spaces at each line tail in each file in directories:
    msr -r -p dir-1,dir2,file1,file2 -f "\.(cpp|cxx|hp*|cs|java|scala|py)$" -t "\s+$" -o ""  -R
(2) Replace each tab(\t) to 4 spaces at each line begin in files: (Recursive/Radically change all head tabs in a line by -g -1)
    msr -rp directory-1,dir-2 -f "\.(cp*|cxx|hp*|cs|java|scala|py)$" -t "^(\s*)\t" -o "$1    " -g -1 -R
(3) Find top 100 largest old garbage log files which size >= 30MB:
    msr -rp directory-1,dir-2 -f "\.(log)$" -l --sz --s1 30MB --w2 "2015-07-27 12:30:00" -H 100 --dsc -PIC
(4) Get command lines to delete top 100 largest old garbage log files which size >= 30MB:
    msr -rp directory-1,dir-2 -f "\.(log)$" -l --sz --s1 30MB --w2  2015-07-27T12:30  -H 100 --dsc -PAC | msr -t .+ -o "del /f /q /s \"$0\"" -PIC
(5) Delete top 100 largest old garbage log files which size >= 30MB:
    msr -rp directory-1,dir-2 -f "\.(log)$" -l --sz --s1 30MB --w2 "2015-07-27 12:30" -T 100 -PAC | msr -t .+ -o "del /f /q /s \"$0\"" -X -PI
(6) Delete top 100 largest old garbage log files which size >= 30MB:
    msr -rp directory-1,dir-2 -f "\.(log)$" -l --sz --s1 30MB --w2 "2015-07-27T12:30" -T 100 -PAC | msr -t .+ -o "del /f /q /s \"$0\"" -H 100 -XPI
(7) Check tail new line: Return/Exit code %ERRORLEVEL% > 0 if has a new line:
    msr -p my-file -S -t "[\r\n]+$" -H 0 -PIC
(8) Replace files to have only one new line at tail: (Add a new line or remove redundant new lines)
    msr -rp directory-1,dir-2 -f "\.(cpp|cxx|hp*|cs|java|scala|py)$" -S -t "(\S+)\s*$" -o "$1\n" -R
(9) Remove tail new lines and white spaces in pipe result:
    msr --help -C | msr -S -t "\s*$" -o "" -P
(10) Debug batch files, turn on all ECHO/echo:
    msr -rp directory-1,dir-2 -f "\.(bat|cmd)$" -it "\b(echo)\s+off\b" -o "$1 on"  -R
(11) Get precise time of now and set to %TimeNow-XXX% variable for latter commands: Now time = 2018-06-08 09:15:20.524577 +0800 CST = China Standard Time
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1 \2" -PAC') do SET "TimeNowInSecond=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1 \2.\3" -PAC') do SET "TimeNowMillisecond=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1 \2.\3\4" -PAC') do SET "TimeNowMicrosecond=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1 \2 \5" -PAC') do SET "TimeNowOffset=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1 \2.\3 \5" -PAC') do SET "TimeNowMilliOffset=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1 \2.\3\4 \5" -PAC') do SET "TimeNowMicroOffset=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1 \2 \6" -PAC') do SET "TimeNowZone=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1 \2.\3 \6" -PAC') do SET "TimeNowMilliZone=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1 \2.\3\4 \6" -PAC') do SET "TimeNowMicroZone=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1__\2" -PAC ^| msr -t ":" -o _ -aPAC') do SET "TimeNowForFileName=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1__\2.\3" -PAC ^| msr -t ":" -o _ -aPAC') do SET "TimeNowMilliForFileName=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1__\2.\3\4" -PAC ^| msr -t ":" -o _ -aPAC') do SET "TimeNowMicroForFileName=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1__\2_\6" -PAC ^| msr -t ":" -o _ -aPAC') do SET "TimeNowZoneForFileName=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1__\2.\3_\6" -PAC ^| msr -t ":" -o _ -aPAC') do SET "TimeNowZoneMilliForFileName=%a"
    for /f "tokens=*" %a in ('msr -hC ^| msr -t ".*Now time = (\d+\S+) (\d+[:\d]+)\.(\d{3})(\d*)\s+([-\+]\d+)?\s*(\w+)?.*" -o "\1__\2.\3\4_\6" -PAC ^| msr -t ":" -o _ -aPAC') do SET "TimeNowZoneMicroForFileName=%a"

Final brief instruction as Quick-Start: Use -PAC or -PIC to get pure output result as other tools like findstr/grep/egrep/etc.
(1) Search files by plain text matching : msr -rp dir1,dir2,fileN -x "my plain text" -PAC 
(2) Search in files with Regex pattern  : msr -rp dir1,dir2,fileN -t "my.*(capture-1).*pattern" -P -I -C
(3) Search files & Replace matched text : msr -rp dir1,dir2,fileN -t "my.*(capture-1).*pattern" -o "captured \1 and you want" -P -A -C
(4) Replace files and Backup if changed : msr -rp dir1,dir2,fileN -t "my.*(capture-1).*pattern" -o "captured $1 and you want" -R -K
(5) Get matched file list + distribution: msr -rp dir1,dir2,fileN -t "my.*(capture-1).*pattern" -l --nd "^(target|bin)$" 
(6) Extract or replace arbitrary blocks : msr -rp dir1,dir2,fileN -t "my.*(capture-1).*pattern" -b "block-begin" -Q "block-end" -f "\.(xml|ini|conf)$" -o "$1 something"
(7) Execute top 2 output lines(commands): msr -l -f "\.(pdb|obj)$" -rp . -PAC | msr -t "(.+)" -o "del \"\1\"" -H 2 -X
(8) Radically replace + only out changed: msr -z "Same with replacing files or pipe" -t "^(\w+)\s+" -o "$1_" -g -1 -j
(9) Extract key + Sort as number + Stats: msr -rp dir1,dir2,fileN -it "Key\s*=\s*(-?\d+\S*)"  -n -s ""  -c Set pattern for -s if different to -t or as you want.
(A) Match an input string or Learn Regex: msr -z "NotFirstArg%~1" -t "^NotFirstArg(|-h|--help|/\?)$" > nul || echo goto show usage as no input args or input 'help' to script.
(B) Search in pipe, Skip Head 3 + Tail 2: type my.txt | msr -it want-pattern -H -3 -T -2 -PIC
(C) Replace with Many filters + Jump out: msr -w path-lines-1.txt,list-3.txt -rp dir1,fileN -k 33 -f "\.(cs|cp*|hp*|cx*)$" --nf "test|unit" -d src --nd "^(\.git|Debug)$" --pp code.*src --np "bin\S*Release" --w1 2016-02 --w2 2016-02-01T23:30:01 --s1 1B --s2 1.5MB -it public.*Find -x class -o Class -U 3 -D 3 -b start-find-line -q stop-line-pattern -L 10 -N 3000 -H 100 -J -O -c Show command + Out summary only if found.

Search usage like: msr | msr -it block.*match  or  msr -hC | msr -it "max.*depth|full.*path|jump out"  or  msr | msr -t Backup -U 2 -D 2 -e replace
With nin.exe more powerful to remove duplication, get exclusive/mutual key/line set, top distribution: https://github.com/qualiu/msr
For example: Remove/Display/Remove+Merge duplicate path in %PATH% and merge to new %PATH%:
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -ui
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -uipd -H 9
    msr -z "%PATH%" -t "\\*\s*;\s*" -o "\n" -aPAC | nin nul "(\S+.+)" -ui -PAC | msr -S -t "[\r\n]+(\S+)" -o ";$1" -aPAC | msr -S -t "\s+$" -o "" -aPAC

As a portable cross platform tool, msr has been running on: Windows / Cygwin / Ubuntu / CentOS / Fedora
Any good ideas please to : QQ : 94394344 , aperiodic updates and docs on https://github.com/qualiu/msr , more tools/examples see: https://github.com/qualiu/msrTools
Call@Everywhere: Add to system environment variable PATH with msr.exe parent directory: D:\lztool
	 or temporarily: SET "PATH=%PATH%;D:\lztool"
	 or rudely but simple and permanent: copy D:\lztool\msr.exe C:\WINDOWS\
