* 2017-05-06 14:30:03 CST Genereated by ```generate-summary-table.bat perf\full-Windows-comparison.log``` 
* Microsoft Windows 10 Enterprise 64-bit + Intel(R) Xeon(R) CPU E5-1630 v3 @ 3.70GHz 4 Cores + 32 GB RAM 

| EXE | Cost | To find | Type | Text case | File rows | File size | System Info |
| -- | -- | -- | -- | -- | -- | -- | -- |
| findstr | **2**.*158* s | ```Exception``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| grep | **2**.*956* s | ```Exception``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| msr | **2**.*613* s | ```Exception``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| findstr | **4**.*587* s | ```Exception``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| grep | **3**.*110* s | ```Exception``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| msr | **4**.*142* s | ```Exception``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| findstr | **65**.*964* s | ```"Error.*found"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| grep | **6**.*261* s | ```"Error.*found"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| msr | **6**.*362* s | ```"Error.*found"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| findstr | **96**.*983* s | ```"Error.*found"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
| grep | **6**.*870* s | ```"Error.*found"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
| msr | **7**.*813* s | ```"Error.*found"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
| findstr | **2**.*041* s | ```Exception``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| grep | **2**.*907* s | ```Exception``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| msr | **2**.*521* s | ```Exception``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| findstr | **4**.*423* s | ```Exception``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| grep | **2**.*930* s | ```Exception``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| msr | **4**.*238* s | ```Exception``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| findstr | **5**.*333* s | ```"[0-9]*Exception[0-9]*"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| grep | **2**.*956* s | ```"[0-9]*Exception[0-9]*"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| msr | **9**.*644* s | ```"[0-9]*Exception[0-9]*"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| findstr | **29**.*177* s | ```"[0-9]*Exception[0-9]*"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
| grep | **3**.*108* s | ```"[0-9]*Exception[0-9]*"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
| msr | **12**.*147* s | ```"[0-9]*Exception[0-9]*"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
| findstr | **2**.*154* s | ```ExceptionX``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| grep | **2**.*601* s | ```ExceptionX``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| msr | **2**.*429* s | ```ExceptionX``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| findstr | **6**.*344* s | ```ExceptionX``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| grep | **3**.*132* s | ```ExceptionX``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| msr | **4**.*371* s | ```ExceptionX``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| findstr | **5**.*520* s | ```"[0-9]*ExceptionX[0-9]*"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| grep | **2**.*559* s | ```"[0-9]*ExceptionX[0-9]*"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| msr | **9**.*743* s | ```"[0-9]*ExceptionX[0-9]*"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| findstr | **27**.*626* s | ```"[0-9]*ExceptionX[0-9]*"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
| grep | **2**.*869* s | ```"[0-9]*ExceptionX[0-9]*"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
| msr | **11**.*914* s | ```"[0-9]*ExceptionX[0-9]*"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
| findstr | **2**.*021* s | ```Not-Exist``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| grep | **2**.*910* s | ```Not-Exist``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| msr | **2**.*287* s | ```Not-Exist``` | Plain | sensitive | 3332543 | 1.39 GB | Windows |
| findstr | **1**.*945* s | ```Not-Exist``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| grep | **2**.*997* s | ```Not-Exist``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| msr | **3**.*920* s | ```Not-Exist``` | Plain | insensitive | 3332543 | 1.39 GB | Windows |
| findstr | **2**.*472* s | ```"Not-exist.*"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| grep | **2**.*899* s | ```"Not-exist.*"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| msr | **4**.*894* s | ```"Not-exist.*"``` | Regex | sensitive | 3332543 | 1.39 GB | Windows |
| findstr | **11**.*020* s | ```"Not-exist.*"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
| grep | **3**.*053* s | ```"Not-exist.*"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
| msr | **5**.*694* s | ```"Not-exist.*"``` | Regex | insensitive | 3332543 | 1.39 GB | Windows |
