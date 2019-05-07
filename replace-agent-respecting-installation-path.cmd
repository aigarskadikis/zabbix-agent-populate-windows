@echo off
net session 1>NUL 2>NUL || (Echo This script requires elevated rights. & Exit /b 1)

setlocal EnableDelayedExpansion

rem obtaining zabbix service installation path
if exist "%~dp0sed.exe" (
for /f "tokens=*" %%v in ('^
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Zabbix Agent" /v ImagePath ^|
findstr "ImagePath" ^|
sed "s/^.*REG_EXPAND_SZ[ \t]*//"') do (

rem obtaining the direcotry where agent is installed
for /f "tokens=*" %%b in ('^
echo %%v ^|
grep -E -o ".:.*exe" ^|
sed "s/zabbix_agentd.exe//"') do (
echo.
echo zabbix binary installed on:
echo %%b

echo.
echo zabbix version before replacement:
"%%bzabbix_agentd.exe" -V | grep -E -o "[0-9]+\.[0-9]+\.[0-9]+"

sc query "Zabbix Agent" > nul 2>&1
if !errorlevel!==0 (
echo.
echo stopping service
net stop "Zabbix Agent"

echo.
echo overwriting file:

sc query "Zabbix Agent" | findstr "RUNNING" > nul 2>&1
if not !errorlevel!==0 (

if not "%ProgramFiles(x86)%"=="" (
echo this is 64-bit machine
"%~dp07z.exe" e "%~dp0zabbix_agents-4.0.7-win-amd64.zip" "-o%%b" bin\zabbix_agentd.exe -r -y
)

if "%ProgramFiles(x86)%"=="" (
echo this is 32-bit machine
"%~dp07z.exe" e "%~dp0zabbix_agents-4.0.7-win-i386.zip" "-o%%b" bin\zabbix_agentd.exe -r -y
)

) else echo Zabbix agent not completely stopped. Cannot replace the binary

)

sc query "Zabbix Agent" | findstr "RUNNING" > nul 2>&1
if not !errorlevel!==0 (
echo.
echo starting agent..
net start "Zabbix Agent"
)

echo.
echo zabbix version after replacement:
"%%bzabbix_agentd.exe" -V | grep -E -o "[0-9]+\.[0-9]+\.[0-9]+"

)

)

) else echo please install sed.exe in order for script to properly function

endlocal

