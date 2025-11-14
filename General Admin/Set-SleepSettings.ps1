# This script sets various power settings in Windows.
# Hibernate off
# sleep (when powered) off

# C# interface  
#var newProcessInfo = new System.Diagnostics.ProcessStartInfo();
#        newProcessInfo.FileName = @"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe";
#        newProcessInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden; // hide processes as they happen
#        newProcessInfo.Verb = "runas"; // run as administrator
#       newProcessInfo.Arguments = @"-executionpolicy unrestricted -Command ""c:\power\powercfg.bat"""; //you can use the -noexit to troubleshoot and see the commands
#        System.Diagnostics.Process.Start(newProcessInfo);

@echo off
powercfg.exe -x -monitor-timeout-ac 0
powercfg.exe -x -monitor-timeout-dc 0
powercfg.exe -x -disk-timeout-ac 0
powercfg.exe -x -disk-timeout-dc 0
powercfg.exe -x -standby-timeout-ac 0
powercfg.exe -x -standby-timeout-dc 0
powercfg.exe -x -hibernate-timeout-ac 0
powercfg.exe -x -hibernate-timeout-dc 0