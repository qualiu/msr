### Liberate & Digitize daily works by 2 exe: File Processing, Data Mining, Map-Reduce.

Most time **Just 1 command line** to solve your daily text or file processing work, pipe endless.

Since 2019-07-19 a [Visual Studio Code](https://code.visualstudio.com/) extension: [**vscode-msr**]( https://marketplace.visualstudio.com/items?itemName=qualiu.vscode-msr) (souce code: [here](https://github.com/qualiu/vscode-msr)) to help your coding work.

#### **M**atch/**S**earch/**R**eplace: `msr.exe`/`msr-Win32.exe`/`msr.cygwin`/`msr.gcc**`/`msr-i386.gcc**`

- **Match/Search/Replace/Execute/*** Files/Pipe Lines/Blocks.
- **Filter/Load/Extract/Transform/Stats/*** Files/Pipe Lines/Blocks.

#### **N**ot-**IN**-latter: `nin.exe`/`nin-Win32.exe`/`nin.cygwin`/`nin.gcc**`/`nin-i386.gcc**`

- Get **Exclusive/Mutual** Line-Set or Key-Set;
- **Remove** Line-Set or Key-Set matched in latter file/pipe;
- Get **Unique/Mutual/Distribution/Stats/*** Files/Pipe Line-Set or Key-Set.

# MSR overview: (usage/examples: [readme.txt](https://github.com/qualiu/msr/tree/master/tools/readme.txt) )

### Performance comparison [msr > findstr, msr ~ grep](https://github.com/qualiu/msr/tree/master/perf)

| findstr + grep + msr on Windows | findstr + grep + msr on Cygwin | grep + msr on CentOS
|-----|-----|-----|
| [**Summary table**](https://github.com/qualiu/msr/blob/master/perf/summary-full-Windows-comparison-2019-08-11.md) | [**Summary table**](https://github.com/qualiu/msr/blob/master/perf/summary-full-Cygwin-comparison-2019-08-11.md) | [**Summary table**](https://github.com/qualiu/msr/blob/master/perf/summary-part-CentOS-comparison-2019-08-11.md)
| [**Comparison screenshot**](https://qualiu.github.io/msr/perf/on-Windows-comparison-2019-08-11.html) | [**Comparison screenshot**](https://qualiu.github.io/msr/perf/on-Cygwin-comparison-2019-08-11.html) | [**Comparison screenshot**](https://qualiu.github.io/msr/perf/on-CentOS-comparison-2019-08-11.html)

### **Vivid Colorful Demo/examples**: Run [windows-test.bat](https://github.com/qualiu/msr/blob/master/tools/windows-test.bat) without parameters: [Windows screenshot](https://qualiu.github.io/msr/demo/windows-test.html)

- Download all by command (Install [git](https://git-scm.com/downloads)) : **git clone** <https://github.com/qualiu/msr/>
- If you've downloaded, run an updating command in the directory: **git pull** or **git fetch && git reset --hard origin/master** (if get conflictions)
- Helpful scripts use **msr.exe** and **nin.exe** : <https://github.com/qualiu/msrTools> , and also *.bat files in [tools](https://github.com/qualiu/msr/tree/master/tools)

### Almost no learning cost

- You can use plain text to search/replace (**-x**/**-ix** `search-text` to **-o** `replace-to`) if you're not farmiliar with `Regex`.
- You can use general `Regex` as **C++, C#, Java, Scala**, needless to learn strange Regex syntax like `FINDSTR`, `Awk` and `Sed`, etc.
- **Most** of the time **only** use searching(Regex: **-t**/**-i -t**, Plain text: **-x**/**-i -x**).
- **Some** of the time search and replace-to(**-o**);
- Just use **-PAC** or **-PIC** to get pure result as same as other tools (no **P**ath-number: **-P**, no **A**ny-info : **-A**, no **C**olor: **-C**)
- All options are **optional** and **no order** and **effective mean while**; Free with abbreviations/full-names.

## Usage + Examples + Color-Text-Screenshots

- For **msr** : See [Brief Summary of msr EXE](https://github.com/qualiu/msr#brief-summary-of-msr-exe) at bottom.
- For **msr** + **nin**: Also can see [tools/readme.txt](https://raw.githubusercontent.com/qualiu/msr/master/tools/readme.txt)
- **Zoom out** following screenshots to **90% or smaller** if it's not tidy or comfortable.

## msr on Windows/Linux

- [msr on Windows](https://qualiu.github.io/msr/usage-by-running/msr-Windows.html)
- [msr on Cygwin](https://qualiu.github.io/msr/usage-by-running/msr-Cygwin.html)
- [msr on Fedora-25](https://qualiu.github.io/msr/usage-by-running/msr-Fedora-25.html)
- [msr on CentOS-7](https://qualiu.github.io/msr/usage-by-running/msr-CentOS-7.html)
- [msr on CentOS-6 32bit](https://qualiu.github.io/msr/usage-by-running/msr-i386-CentOS-32bit.html)

## nin on Windows/Linux

- [nin on Windows](https://qualiu.github.io/msr/usage-by-running/nin-Windows.html)
- [nin on Cygwin](https://qualiu.github.io/msr/usage-by-running/nin-Cygwin.html)
- [nin on Fedora-25](https://qualiu.github.io/msr/usage-by-running/nin-Fedora-25.html)
- [nin on CentOS-7](https://qualiu.github.io/msr/usage-by-running/nin-CentOS-7.html)
- [nin on CentOS-6 32bit](https://qualiu.github.io/msr/usage-by-running/nin-i386-CentOS-32bit.html)

## Demo and test screenshots

**Zoom out** following screenshots to **90% or smaller** if it's not tidy or comfortable.

- [Linux demo and test](https://qualiu.github.io/msr/demo/linux-test.html)
- [Windows vivid demo test](https://qualiu.github.io/msr/demo/windows-test.html)
- [Windows test result compare with base logs](https://qualiu.github.io/msr/demo/windows-test-compare-base.html)
- [Peformance comparison on Cygwin](https://qualiu.github.io/msr/perf/on-Cygwin-comparison-2019-08-11.html)
- [Peformance comparison on Windows](https://qualiu.github.io/msr/perf/on-Windows-comparison-2019-08-11.html)

### Powerful

- Single exe for multiple platforms: **Windows/Linux/Cygwin/Ubuntu/CentOS/Fedora** .
- Smart Loading files with 8 composable kinds of filters:
  - 5 pairs of file attribute filters
    - File name patterns (**-f**/**--nf**)
    - Directory patterns(**-d**/**--nd**)
    - Full path patterns(**--pp**/**--np**)
      - Size range(**--s1**,**--s2**)
      - Write-time range(**--w1**,**--w2**)
    - 3 kinds of file row / block filters to start/stop/skip reading/replacing each files/pipe:
      - Row/line number begin/end (**-L**, **-N**);
      - Block begin/end patterns (**-b**, **-Q**) for each block in each file/pipe; with **-q** to stop at once for pipe/each file. 
      - Normal begin/end patterns (**b**, **-q**).
- Process pipe (output of self/other commands) **endless** as you want.
- Two composable single exe: [msr.exe/cygwin/gcc*](https://github.com/qualiu/msr/blob/master/tools/readme.txt) especially powerful with [nin.exe/cygwin/gcc*](https://github.com/qualiu/msr/blob/master/tools/readme.txt).
- **68** composable options for [msr](https://github.com/qualiu/msr/blob/master/tools/readme.txt) and **28** composable options for [nin](https://github.com/qualiu/msr/blob/master/tools/readme.txt) (just run them without parameters to get colorful usage/examples or see [readme.txt](https://github.com/qualiu/msr/blob/master/tools/readme.txt)) for further extractions/mining.

```batch
     msr --help # same as : msr -h / msr
     nin  --help # same as : nin  -h / nin
     msr | msr -t "^\s*-{1,2}\S+" -q "^\s*-h\s+" --nt "--help"
     nin | msr -t "^\s*-{1,2}\S+" -q "^\s*-h\s+" --nt "--help"
```

### One limitation

- Cannot process Unicode files/pipe so far; Fine with UTF-8 and ANSI etc.

### Just run the exe, you'll get the usage and examples.

Besides, some script/batch/shell files are also examples.

Search/Replace text by **msr.exe** / **msr.gcc**** / **msr.cygwin**

- in files or from pipe
  - pipe (command line result);
  - files recursively in directories and multiple root paths separated by comma or semicolon.
- with
  - Normal/Plain text searching/replacing;
  - Regex text searching/replacing, and with single-line/multi-line mode.
- with excluding and including syntax meanwhile for
  - Filtering file-name/directory-name/full-path-string;
  - Filtering  include text and exclude text;
  - Filtering files by write-time range and file size.
  - Finally Sort result text by specified time or text (regex pattern);
  - Output with hierarchy colors by searching-regex and enhancing-regex.

## Typical scenarios of msr: Coding/Deploying/Test/Operation/Log-Mining

1. Find text in pipe (command line result) or files (such as code, log)
2. Replace/Extract/Tranform text from pipe or files **recursively** in **multiple** root path.
3. Search/Replace and get percentage, distribution; further extraction on previous pipe or even command line.
4. [Find processes](https://github.com/qualiu/msr/blob/master/tools/psall.bat) / [Kill processes](https://github.com/qualiu/msr/blob/master/tools/pskill.bat) by regex/pid with colorful matching.
5. Find files with specified name, in modification time range, size range and other filters, then use the path list to operate (**-X** is helpful).
6. Look up a tool's usage with colors and context (Up/Down lines).
7. Grep a command's result with matching info and time cost, and colorful matched lines or blocks.
8. Adding colors to your scripts, especially nice to usage and examples section.
9. Map <--> Reduce : Filter files and load, extract, transform, ... , pipe endless.
 ... ...

### With requirements of:

1. Basic text searching(**-x**) / replacing-to(**-o**) , plus case sensitive or not (**-i**).
2. General Regex (regular expression) searching(**-t**)/replacing(**-o**) : consistent regex syntax with C#/C++/Java, not like strange or limited regex as AWK/GAWK/SED/FINDSTR …
3. Recursively (**-r**) search / replace files in paths (**-p**) (multiple paths separated by "," or ";")
   - For replacing: replace regex-pattern(**-t**)/normal-text(**-x**) to (**-o**) final-text
     - Preview: no **-R**
     - Replace : with **-R**
     - Backup files only if changed/replaced (**-K**) :
   - Backup : Original files will be backuped to : {name}--lz-backup--{file-last-write-time}-{N}
     - Such as : myConfig.xml--lz-backup-2013-11-13__11_38_24
       - But if replaced many times in a second :
       - Will be : myConfig.xml--lz-backup-2013-11-13__11_38_24**-N** (**N**  start from 1 )

4. Powerful filtering: (can use all of following options meanwhile)
   - For file : Sorting order by the prior of **--wt** and **--sz** if use both.
      - file-name(**-f**) / directory-name(**-d**) / path(**-pp**) + ALL :
      - include/exclude(**--nf**/**--nd**/**--np**) +ALL;
      - file modification time filter: **--w1**,**--w2** : like --w1 2012-09-08  --w2 "2013-03-12 15" (or "2013-03-12 15:00")
      - file size range filter: **--s1** , **--s2** : like --s1 100KB --s2 1M
      - show file modification time and sort : **--wt** : useful if list file with **-l**
      - show file size and unit and sort : **--sz** : useful if list file with **-l**
   - Line matching + **Arbitrary** block matching: if not begin or stopped, not output/match/replace even if matched.
     - Regex pattern
       - start reading  (**-b**), or start matching a block begin (with **-Q** to perform block syntax).
       - stop reading (**-q**) ignore if has matched start pattern.
       - stop reading if has matched start pattern (**-Q**) as one block end (with **-b**) in pipe/each file.
     - File line number
       - start at row (**-L**)
       - stop at row (**-N**)

5. Matching(**-t**/**-x**) and non-matching(**--nt**/**--nx**) filter at mean while.(like file filter)
6. Powerful output control:
   - Can sort by time if specified time format **-F** for the logs from multiple paths;
   - Colorful output and with hierarchy for captured matching group;
   - Capture(**-t**/**-x**) and enhance(**-e**) and with different colors;
   - Lines up(**-U**) and down(**-D**) as context to the captured row;
   - Head(**-H**) and tail(**-T**) for whole result rows.
   - Out summary info only if matched (**-O**)
   - No any info just pure result (**-A**)
   - Out summary info to stderr (**-I**)
   - Execute(**-X**) output lines as commands (if they're callable commands) : because 'for' loop on Windows need escape | to ^| , > to ^> , etc.
7. Extra and useful output info : if not use **-A**
   - **When** you did it;
   - **What** command line (**-c**) you used; What's the percentage and distribution.
   - **Where** the files and rows (if not use **-P**) you searched/modified and working directory.
   - **How** much time cost (so you know to start it at night/lunch if too long)
   - Matching count and percentages (Also can use **-l** to get just brief file list and count/percentage)
   - Use **-PAC** to get clean result (no path-line, no any info, no color)
   - Use **-PIC** to output info to stderr pipe.
   - Use **-PC**/**-POC**/**-l -PC**/**-lPOC** >nul(nul on Windows, /dev/null on Linux) to use summary info as source input for latter process/tool.
   - If has **-c** in command line, can append any extra text, useful with **-O** **-H 0** or **>nul** to do further extraction based on summary info:
     - msr -x "D:\data" -p xx.log -O >nul | msr -xxx xxx -c Checking D:\data
   - Use **-z** to directly input string to read, avoid using echo which is clumsy in pipe on Windows.
   - Use **-J** and **-H** output/match count to jump out.

# Brief Summary of msr EXE

Use the rich searching options of like below, **combine** these **optional** options (**You Can Use All**):

- Filter text by `line-matching` (default) or `whole-file-text-matching` (add **-S** / **--single-line** Regex mode):
  - Ignore case:
    - Add **-i** (`--ignore-case`)
  - Regex patterns:
    - **-t** `should-match-Regex-pattern`
    - **--nt** `should-not-match-Regex-pattern`
  - Plain text:
    - **-x** `should-contain-plain-text`
    - **--nx** `should-not-contain-plain-text`
- Filter `file name`: **-f** `should-match-Regex` , **--nf** `should-not-match`
- Filter `directory name`: **-d** `at-least-one-match` , **--nd** `none-should-match`
- Filter `full path pattern`: **--pp** `should-match` , **--np** `should-not-match`
- Skip full or sub paths: **--xp** d:\win\dir,my\sub
- Try to read once for link files: **-G** (link files's folders must be or under input root paths)
- Filter `file size`: **--s1** <= size <= **s2** , like set one or two: **--s1** `1B` **--s2** `1.5MB`
- Filter `file time`: like **--w1** `2019-07`, **--w2** `"2019-07-16 13:20"` or `2019-07-16T13:20:01` (quote it if has spaces).
- Filter rows by begin + end row numbers: like **-L** 10 **-N** 200 (for each file).
- Filter rows by begin + end Regex: like **-b** `"^\s*public.*?class"` **-q** `"^\s*\}\s*$"`
- Filter rows by 1 or more blocks: **-b** `"^\s*public.*?class"` **-Q** `"^\s*\}\s*$"`
- Filter rows by 1 or more blocks + **stop** like: **-b** `"^\s*public.*?class"` **-Q** `"^\s*\}\s*$"` **-q** `"stop-matching-regex"`
- Set max search depth (begin from input folder), like: **-k** `16` (default max search depth = `33`).
- Set searching paths: (Can use both)
  - Recursively(`-r`) search one or more files or directories, like: **-r** **-p** `file1,folder2,file2,folder3,folderN`
  - Read paths (path list) from files, like: **-w** `path-list-1.txt,path-list-2.txt`
- Skip/Exclude link files: **--xf**
- Skip/Exclude link folders: **--xd**
- **Quickly** pick up `head{N}` results + **Jump out**(`-J`), like: **-H** `30` **-J** or **-J** **-H** `300` or **-JH** `300` etc.
- Not coloring matched text: **-C**  (`Faster` to output, and **must be set** for `Linux/Cygwin` to further process).
- Output summary `info` to **stderr** + **hide** `warnings in stderr` (like BOM encoding): **-I** : Like **-I -C** or **-IC** or **-J -I -C** or **-JIC** etc.
  