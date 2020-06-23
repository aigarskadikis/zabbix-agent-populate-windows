@echo off

set version=5.0.1

net session 1>NUL 2>NUL || (Echo Please run this script as administrator & Exit /b 1)

rem set where the zabbix agent will be deployed 'c:\zabbix' is more recommended
set zabbix=%systemdrive%\zabbix
rem zabbix=%programfiles%\Zabbix Agent

rem to succesfully work with !errorlevel!
setlocal EnableDelayedExpansion

rem checks if zabbix service is installed
sc query "Zabbix Agent" > nul 2>&1
if !errorlevel!==0 (

rem check the version
"%zabbix%\zabbix_agentd.exe" -V | find "%version%"> nul 2>&1
if not !errorlevel!==0 (

echo No "%version%" version detected, but
"%zabbix%\zabbix_agentd.exe" -V | find "zabbix_agentd"

echo.
echo Stopping agent..
sc stop "Zabbix Agent"

rem install zabbix_agentd.exe, zabbix_sender.exe, zabbix_get for 32-bit system
if not exist "%programfiles(x86)%" (
echo this is 32-bit system
xcopy /Y "%~dp0win32\*" "%zabbix%"
)

rem install zabbix_agentd.exe, zabbix_sender.exe, zabbix_get for 64-bit system
if exist "%programfiles(x86)%" (
echo this is 64-bit system
xcopy /Y "%~dp0win64\*" "%zabbix%"
)

echo.
echo Starting agent..

sc start "Zabbix Agent"

) else echo Version %version% already exist
) else echo Zabbix Agent already exist

endlocal
