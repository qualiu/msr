::Just run windows-test.bat which calls this file, or run this file directly, you will get a vivid sense of msr.
msr -c -z "c:\Program Files\LLVM\bin\clang.exe" -x \ -o \\
msr -c -z "c:\Program Files\LLVM\bin\clang.exe" -t \\ -o \\
msr -c -z "c:\Program Files\LLVM\bin\clang.exe" -t "\\\\" -o \\
msr -c -p %~dp0\sample-file.txt -S -t "^(.+\S+)\s*$" -H 0         # Check return value, output nothing
msr -c -p %~dp0\sample-file.txt -S -t "^(.+\S+)$" -H 0            # Check return value, output nothing
msr -c -p %~dp0\sample-file.txt -S -t "^(.+\S+)\n$" -H 0          # Check return value, output nothing
msr -c -p %~dp0\sample-file.txt -S -t "^(.+\S+)\s*$" -o "$1\n" -R # Add a new line to tail
msr -c -p %~dp0\sample-file.txt -S -t "^(.+\S+)\s*$" -o "$1" -R   # Remove tail new line
msr -c -p %~dp0 -f bat -l -PAC -H 0
msr -c -p %~dp0 -f bat -l -PIC -H 0
msr -c -p %~dp0\sample-file.txt -L 7 -N 9 -t Not -U 2 -D 2
msr -c -p %~dp0\sample-file.txt -it node --nt "node\d+"
msr -c -p %~dp0\sample-file.txt -it node --nt "node\d+" -o "NODE"
msr -c -p %~dp0\sample-file.txt -b "^\s*<Tag" -Q "^\s*</Tag" -t "Node[13]" -a -L 20 -N 50 ## Must no blocks
msr -c -p %~dp0\sample-file.txt -b "^\s*<Tag" -Q "^\s*</Tag" -t "Node[13]" -a -L 20 -N 80 ## Must have only 1 block
msr -c -p %~dp0\sample-file.txt -b "^\s*<Tag" -Q "^\s*</Tag" -t "Node[13]" -a  ## Must have and only 2 blocks: Node1 and Node3
msr -c -p %~dp0\sample-file.txt -b "^\s*<Tag" -Q "^\s*</Tag" -t "Node[1-3]" -x Node2 -a ## Must have only Node2 block
msr -c -p %~dp0\sample-file.txt -ib "^\s*<tag" -Q "^\s*</tag" --nt "Node[1-3]" -e "Node\d+"  ## Must no block to output
msr -c -p %~dp0\sample-file.txt -b "^\s*<tag" -iQ "^\s*</tag" --nt "Node[1-3]"  ## Must no block to output
msr -c -p %~dp0\sample-file.txt -b "^\s*<tag" -Q "^\s*</tag" -i --nt "Node[1-3]" -a  ## Must no block to output
msr -c -p %~dp0\sample-file.txt -b "^\s*<tag" -Q "^\s*</tag" -i --nt "Node[13]" -t "Node\d+"  ## Must have only Node2 but not whole block
msr -c -p %~dp0\sample-file.txt -b "^\s*<tag" -Q "^\s*</tag" -i --nt "Node[13]" -e "Node\d+"  ## Must have only Node2 and whole block
msr -c -p %~dp0\sample-file.txt -b "^\s*<tag" -Q "^\s*</tag" -i --nt "Node[13]" -a -e "Node\d+" ## Must have only Node2 and whole block
msr -c -p %~dp0\sample-file.txt -b "^\s*<tag" -Q "^\s*</tag" -i --nt "Node[13]" -a -t "Node2"  ## Must have only Node2 and whole block
msr -c -p %~dp0\sample-file.txt -b "^\s*<Tag" -Q "^\s*</Tag" -t "Node[13]" --nx node3 -ai -x Node -o myNode  ## Must have only block Node1 and replaced
msr -c -p %~dp0\sample-file.txt -b "^\s*<Tag" -Q "^\s*</TagNotExist>" -a ## Should no blocks and output.
msr -c -r -p %~dp0 -f "^(example-commands|sample-file)\.(txt|bat)$" -l --sz --wt -T 3
msr -c -r -p %~dp0 -f "^(example-commands|sample-file)\.(txt|bat)$" -l --wt --sz -H 3 --dsc --s1 1KB --s2 1MB --w1 "2015-07-20 13:20"
msr -c -p %~dp0\sample-file.txt -ib "^\s*enum" -q "\};" -S -t "([\r\n]+)\s+" -o "$1  "  ## Single line regex matching
msr -c -p %~dp0\sample-file.txt -ib "^\s*enum" -q "\};" -t "^\s+" -o "  " -a -P
msr -c -p %~dp0\sample-file.txt -i -t "(Deferred\w*)"
msr -c -p %~dp0\sample-file.txt -it "(Deferred\w*)\s+\1"
msr -c -p %~dp0\sample-file.txt -i -b "class DeferredRun" -Q "^};" -t "(Deferred\w*)" -o "$1Replaced"
msr -c -p %~dp0\example-commands.bat -it "class|run" -H 9
msr -c -p %~dp0\example-commands.bat -ie "class|run" -H 9
msr -c -p %~dp0\example-commands.bat -it "^msr\s+(-c\s+)?" -L 3 -o "msr -c " -H 9
msr -c -p %~dp0\example-commands.bat -x bat -o BAT -L 3 -H 5 -T 5      ## Plain text replacing to BAT , begin-row-3, and show top 5 and bottom 5 lines
msr -c -p %~dp0\example-commands.bat -t bat -o BAT -L 3 -H 5           ## Plain text replacing to BAT , begin-row-3, show top 5 lines
msr -c -p %~dp0\example-commands.bat -t com -x bat -o BAT T -H 5       ## Use both Regex and plain text , replacing from
msr -c -p %~dp0\example-commands.bat -t t -L 9 -e txt -H 9             ## single char matching and coloring test
msr -c -p %~dp0\example-commands.bat -x t -L 9 -e txt -H 9
msr -c -p %~dp0\example-commands.bat -t t -L 9 -e me.txt -H 9       ## Coloring Regex-matched/Plain-found/Regex-enhance text meanwhile
msr -c -p %~dp0\example-commands.bat -x t -L 9 -e me.txt -H 9
msr -c -p %~dp0\example-commands.bat -x me -L 20 -H 9
msr -c -p %~dp0\example-commands.bat -x me -L 20 -ie me -H 9
msr -c -p %~dp0\example-commands.bat -t me -L 20 -ie me -H 9
msr -c -p %~dp0\example-commands.bat -x me -o you -ie "you|txt|ping" -L 30 -H 9
msr -c -p %~dp0\example-commands.bat -t me -o you -ie "you|txt|ping" -L 30 -H 9
msr -c -p %~dp0\example-commands.bat -t me -ie "me|ping|\w+.txt" -L 30 -H 9
msr -c -p %~dp0\example-commands.bat -x me -ie "me|ping|\w+.txt" -L 30 -H 9
msr -c -p %~dp0\example-commands.bat -x name -o NAME -ie "name|come" -U 3 -D 3 -L 16 -H 9
::msr -c -p %~dp0\sample-file.txt -t "\b(NotMatchedLine|MatchedLine|UpLine|DownLine)" -o "LineType::$1" --nt "=\s*\d+" -R
msr -c -p %~dp0\example-commands.bat -t name -o NAME -ie Names -H 9
msr -c -p %~dp0\example-commands.bat -t name -o NAME -T 1 -C
msr -c -p %~dp0\example-commands.bat -it name -l
msr -c -p %~dp0\sample-file.txt -it name -l
msr -c -p %~dp0\example-commands.bat -t name -a -o NAME -ie Names -b "come|name\w*" -Q "mailTo|Tag" -T 9
msr -c -p %~dp0\example-commands.bat -it NOT -U 2 -e "SRC|DIR" -H 5
msr -c -p %~dp0\example-commands.bat -x name -o NAME -ie "name|come" -T 3
msr -c -p %~dp0\example-commands.bat -t name -o come -ie "name|come" -a -L 19 -H 9
msr -c -p %~dp0\example-commands.bat -t name -a -o NAM -ie "name|come" -L 19 -H 9
msr -c -p %~dp0\example-commands.bat -b "garbage" -Q publish-update -t ping -e "me|ping|you|(publish-update)"
msr -c -p %~dp0\example-commands.bat -b "garbage" -q publish-update -t ping -e "me|ping|you|(publish-update)"
msr -c -p %~dp0\example-commands.bat -x name -o NAME -ie "name|come" -t not -U 3 -D 3
msr -c -p %~dp0\sample-file.txt -ib "<Tag Name.*?\b(Node1|Node2)\b" -Q "<MailAddress>|</Tag>" -e "MailTo" -t body -o BODY -a
msr -c -p %~dp0\sample-file.txt -ib "<Tag Name.*?\b(Node2)\b" -Q "<MailAddress>|</Tag>" -e MailTo -t body -o BODY -a
msr -c -p %~dp0\sample-file.txt -ib "<Tag Name.*?\b(\w+)\b" -Q "<MailAddress>|</Tag>" -t Node1 -e "<.?Tag.*?>" -a
msr -c -p %~dp0\example-commands.bat -it name -o NAME -e Names -x update
msr -c -p %~dp0\example-commands.bat -it name -e Names -x nameX
msr -c -p %~dp0\example-commands.bat -ix update -t name -e Names
msr -c -p %~dp0\sample-file.txt -ib "<Tag name" -q "Switch" -Q "</Tag" -t MailTo -e Switch
msr -c -p %~dp0\sample-file.txt -ib "<Tag name" -q "Switch" -Q "</Tag" -t MailTo -e Switch -a
msr -c -p %~dp0\sample-file.txt -it "<name>(#.+?)</name>\s*<value>(.+?)</value>" -S -o "msr -x \"$1\" -o \"$2\"" -L 14 -e "-x (\S+)|-o (\S+)|msr "
msr -c -p %~dp0\sample-file.txt -it Tag -x ref -U 5 -D 5
msr -c -p %~dp0\sample-file.txt -F "^(\d+-\d+-\d+ [\d:]+(\.\d+)?)" -B "2012-12-27 00:03"
msr -c -p %~dp0\sample-file.txt -F "^(\d+-\d+-\d+ [\d:]+(\.\d+)?)" -E "2012-12-27 00:03"
msr -c -p %~dp0\sample-file.txt -F "^(\d+-\d+-\d+ [\d:]+(\.\d+)?)" -q "2012-12-27 00:03"
msr -c -p %~dp0\sample-file.txt -F "^(\d+-\d+-\d+ [\d:]+(\.\d+)?)" -q "2012-12-27|03"
msr -c -p %~dp0\sample-file.txt -F "^(\d+-\d+-\d+ [\d:]+(\.\d+)?)" -B "2012-12-27 00:00" -E "2012-12-27 00:03"
msr -c -p %~dp0\sample-file.txt -F "^(\d+-\d+-\d+ [\d:]+(\.\d+)?)" -B "2012-12-27 00:00" -E "2012-12-27 00:03" -it first
msr -c -p %~dp0\example-commands.bat -x " -B" -t ".*?(\d+\S+ \d+[\d:]+).*"
msr -c -p %~dp0\sample-file.txt -s "^(\d+-\d+-\d+ [\d:]+(\.\d+)?)" -it 2012
msr -c -p %~dp0\sample-file.txt -t "^((((((\d+\D\d+\D\d+[\D\s]*\d+:\d+:\d+))))))(\S*)" -s "^\d+\D\d+\D\d+[\D\s]*\d+:\d+:\d+" -e "\d+|(\w+)\s+line"
msr -c -p %~dp0\sample-file.txt -t "^((((((\d+\D\d+\D\d+[\D\s]*\d+:\d+:\d+))))))(\S*)" -s "^\d+\D\d+\D\d+[\D\s]*\d+:\d+:\d+" -e "\d+|(\w+)\s+line" --dsc
msr -c -p %~dp0\example-commands.bat -it "\w+" -H 0       ## Must NOT out any matched.
msr -c -p %~dp0\example-commands.bat -it "\w+" -H 0 -T 2  ## Must out only 2 matched of bottom.
msr -c -p %~dp0\example-commands.bat -it "\w+" -T 0       ## Must NOT out any matched.
msr -c -p %~dp0\example-commands.bat -it "\w+" -T 0 -H 2  ## Must out only 2 matched of top.
msr -c -p %~dp0\example-commands.bat -it just -U 3 -D 3
msr -c -p %~dp0\sample-file.txt -it "\W(function)\W" -e "name=(\S+)"
::Stop calling for linux-test.sh as following are advanced test. On Linux , need to replace the double quotes "" to single quotes '' in -o xxxx if contains $1 or $2 etc.
::Example bellow extract to a file then generate replacing commands and execute them.
msr -c -p %~dp0\sample-file.txt -b "<Tag Name.*?Node1.*?>" -Q "</Tag>" -PA -e "#\S+?#"
msr -c -p %~dp0\sample-file.txt -b "<Tag Name.*?Node1.*?>" -Q "</Tag>" -PIC > Node1.tmp
(msr -c -p %~dp0\sample-file.txt -it "<name>(#.+?#)</name>\s*<value>(.+?)</value>" -S -o "msr -x \"$1\" -o \"$2\""  -PAC | msr -t "^\s*(msr -x .*)" -o "$1 -p Node1.tmp -R" -PAC) |msr -XI -c
msr -c -p Node1.tmp -PA -e ".All.|4000|8000"  ## This is an expanded xml that has replaced name value settings.
msr -z "if exist Node1.tmp del Node1.tmp" -XPI
