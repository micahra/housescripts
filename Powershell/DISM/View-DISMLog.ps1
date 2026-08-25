# Opens CBS.log and tails the last 10 lines, to confirm that DISM is still running (even if it looks like its frozen)
Get-Content C:\Windows\Logs\CBS\CBS.log -tail 10 -wait