@echo off
set dest=c:\zabbix

setlocal EnableDelayedExpansion

sc query "Zabbix Agent" > nul 2>&1
if not !errorlevel!==0 (

rem create base dirrectory
if not exist "%dest%" mkdir "%dest%"

rem create directory for dynamics
if not exist "%dest%\zabbix_agentd.conf.d" mkdir "%dest%\zabbix_agentd.conf.d"

rem install all custom variables
if exist "%~dp0zabbix_agentd.conf.d" xcopy /Y "%~dp0zabbix_agentd.conf.d\*" "%dest%\zabbix_agentd.conf.d"

if not "%ProgramFiles(x86)%"=="" (
echo this is 64-bit machine
"%~dp07z.exe" e "%~dp0zabbix_agents-4.0.7-win-amd64.zip" "-o%dest%" bin\zabbix_agentd.exe -r -y
"%~dp07z.exe" e "%~dp0zabbix_agents-4.0.7-win-amd64.zip" "-o%dest%" conf\zabbix_agentd.conf -r -y
"%~dp07z.exe" e "%~dp0zabbix_agents-4.0.7-win-amd64.zip" "-o%dest%" bin\zabbix_get.exe -r -y
"%~dp07z.exe" e "%~dp0zabbix_agents-4.0.7-win-amd64.zip" "-o%dest%" bin\zabbix_sender.exe -r -y
)

if "%ProgramFiles(x86)%"=="" (
echo this is 32-bit machine
"%~dp07z.exe" e "%~dp0zabbix_agents-4.0.7-win-i386.zip" "-o%dest%" bin\zabbix_agentd.exe -r -y
"%~dp07z.exe" e "%~dp0zabbix_agents-4.0.7-win-i386.zip" "-o%dest%" conf\zabbix_agentd.conf -r -y
"%~dp07z.exe" e "%~dp0zabbix_agents-4.0.7-win-i386.zip" "-o%dest%" bin\zabbix_get.exe -r -y
"%~dp07z.exe" e "%~dp0zabbix_agents-4.0.7-win-i386.zip" "-o%dest%" bin\zabbix_sender.exe -r -y
)

if exist "%dest%\zabbix_agentd.conf" (

echo.
echo setting up dynamic host name
"%~dp0sed.exe" -i "/^Hostname=.*$/d" "%dest%\zabbix_agentd.conf"

echo.
echo removing Server and ServerActive. These attributes will be handled through zabbix_agentd.conf.d
"%~dp0sed.exe" -i "/^Server=.*$/d" "%dest%\zabbix_agentd.conf"
"%~dp0sed.exe" -i "/^ServerActive=.*$/d" "%dest%\zabbix_agentd.conf"

rem remove last backslash if exist
for /f "tokens=*" %%z in ('^
echo %dest%^|
"%~dp0sed.exe" "s|\\$||"') do (

rem workaround to escape backslash for sed
for /f "tokens=*" %%s in ('^
echo %%z^|
"%~dp0sed.exe" "s|\\|\\\\|g"') do (

echo.
echo enabling dynamics at "%%z\zabbix_agentd.conf.d"
"%~dp0sed.exe" -i "s|^.*Include=...zabbix.zabbix_agentd.conf.d...conf.*$|Include=%%s\\zabbix_agentd.conf.d\\*.conf|" "%dest%\zabbix_agentd.conf"

echo.
echo setting log file destination as "%%z\zabbix_agentd.conf.d"
"%~dp0sed.exe" -i "s|^LogFile.*$|LogFile=%%s\\zabbix_agentd.log|" "%dest%\zabbix_agentd.conf"

)
)

"%dest%\zabbix_agentd.exe" -c "%dest%\zabbix_agentd.conf" --install

) else echo "%dest%\zabbix_agentd.conf" does not exist


) else echo Zabbix Agent already exist

endlocal
pause