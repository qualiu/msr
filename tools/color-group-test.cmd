msr -PA -z "  -u " -t "^\s{2}(-+(\S+))\s"
msr -PA -z "ExactMatchCount = 3" -t "Match|(\d+)" -e "Exact\w+" -x Count
msr -PA -z "ExactMatchCount = 3, " -t "Match|(\d+)" -e "Exact\w+" -x Count
msr -PA -z "not captured, abc = 2" -t "\w+ = (\S+)"
msr -PA -z "not captured, abc = 2, ok" -t "\w+ = (\S+)"
msr -PA -z "Test file info : 3332543 lines 1.39 GB : Plain text finding by findstr / grep / msr ; To find = Exception" -t "(\d+\.\d+)" -e "(\d+)|\w+" -a
msr -PA -z "Test:217 TimeCost = 6467 ms, ExactMatches = 0, TotalResults = 0, ExtraResults = 0, Types = All" -t "^\s*$|Cost|Ex\w+ = (\d+)" -e "Test:\d+.*"
msr -PA -z "msr -c -p %~dp0 -l -f bat -T -2 # Should skip bottom 2 items." -t t -e txt
msr -PA -p %~dp0\sample-file.txt -ib "<Tag name" -q "Switch" -Q "</Tag" -t MailTo -e Switch
msr -PA -z "myFileLog" -t "(.+)File(.+)"
msr -PA -z "myFileLog" -t "(.+)(File)(.+)"
msr -PA -z "myFileLog" -t ".+(File)(.+)"
msr -PA -z "myFileLog" -t ".+(File).+"
msr -PA -z "myFileLog" -t ".+(File)"
msr -PA -z CENTOS_MANTISBT_PROJECT_VERSION-7a -it centos.*7
msr -PA -z "by %%Name%% command: SET Name=Value" -e ".+?(SET \S+)" -t "(%%*Name%%*)"
msr -PA -z "by %%Name%% command: SET Name=Value" -e ".+?(SET \S+)" -t "(%%*Name%%*)|(Value)"
msr -PA -z "by %%Name%% command: SET Name=Value" -e ".+?(SET \S+)" -t "(%%*Name%%*)" -x "=Value"
msr -PA -z "by %%Name%% command: SET Name=Value" -e ".+?(SET \S+)" -t "(%%*Name%%*)" -x "command"
msr -PA -z "by %%Name%% command: SET Name=Value" -e ".+?(SET \S+)" -t "(%%*Name%%*)" -x " command:"
msr -PA -z "by %%Name%% command: SET Name=Value" -e ".+?(SET \S+)" -t "(%%*Name%%*)" -x "SET Name"
msr -PA -z "by %%Name%% command: SET Name=Value" -e ".+?(SET \S+)" -t "(%%*Name%%*)|(=Value)" -x "Name="
msr -PA -z "by %%Name%% command: SET Name=Value" -e ".+?(SET \S+)" -t "(%%*Name%%*)|(Value)" -x "Name="
msr -PA -z "by %%Name%% command: SET Name=Value" -e ".+?(SET \S+)|(\w+=\w+)" -t "(%%*Name%%*)" -x "Name=Value"
msr -PA -z "by %%Name%% command: SET Name=Value" -e ".+?(SET \S+)|(\w+=\w+)" -t "(%%*Name%%*)" -x "=Value"
msr -PA -z "by %%Name%% command: SET Name=Value" -e ".+?(SET \S+)|(\w+=\w+)" -t "(%%*Name%%*)"
msr -PA -z "by %%Name%% command: SET \"Name=Value\"" -e ".+?(SET \S+)|(\w+=\w+)" -t "(%%*Name%%*)"
