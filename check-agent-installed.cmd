@echo off
cls
setlocal EnableDelayedExpansion

echo.
echo Zabbix agent:

sc query "Zabbix Agent" > nul 2>&1
if !errorlevel!==0 (
echo.
echo .. is installed as service
sc query "Zabbix Agent" | findstr "RUNNING" > nul 2>&1
if !errorlevel!==0 (
echo.
echo .. already running
)

reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Zabbix Agent" > nul 2>&1
if !errorlevel!==0 (

if not exist "%~dp0sed.exe" (
echo.
echo .. location and config:
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Zabbix Agent" /v ImagePath | findstr "ImagePath"
)

rem if sed utility is placed in dir then run custom analisys
if exist "%~dp0sed.exe" (
for /f "tokens=*" %%v in ('^
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Zabbix Agent" /v ImagePath ^|
findstr "ImagePath" ^|
sed "s/^.*REG_EXPAND_SZ[ \t]*//"') do (

rem extract where exactly the binary is installed
for /f "tokens=*" %%b in ('^
echo %%v ^|
grep -E -o ".:.*exe"') do (
echo.
echo binary location:
echo %%b
echo.
echo agent version:
%%b -V | grep -E -o "[0-9]+\.[0-9]+\.[0-9]+"
)

)

)

)

) else echo .. not installed as service

if exist "%systemroot%\System32\tasklist.exe" (
TASKLIST | findstr "zabbix_agentd.exe" > nul 2>&1
if !errorlevel!==0 (
echo.
echo .. agent running currently as an process
TASKLIST | findstr "zabbix_agentd.exe"
)
)

endlocal
