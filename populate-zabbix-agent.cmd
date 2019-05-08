@echo off

net session 1>NUL 2>NUL || (Echo Please run this script as administrator & Exit /b 1)

rem set where the zabbix agent will be deployed 'c:\zabbix' is more recommended
set zabbix=%systemdrive%\zabbix
rem zabbix=%programfiles%\Zabbix Agent

rem to succesfully work with !errorlevel!
setlocal EnableDelayedExpansion

rem checks if zabbix service is installed
sc query "Zabbix Agent" | findstr "does not exist"> nul 2>&1
if !errorlevel!==0 (

rem create a destination directory to install Zabbix Agent service
if not exist "%zabbix%" md "%zabbix%"
if !errorlevel!==0 (

rem create dir for UserParameters
if not exist "%zabbix%\zabbix_agentd.conf.d" md "%zabbix%\zabbix_agentd.conf.d"

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

rem copy default configuration
if exist "%~dp0conf\zabbix_agentd.conf" (
xcopy /Y "%~dp0conf\zabbix_agentd.conf" "%zabbix%"
) else echo "%~dp0conf\zabbix_agentd.conf" do not exist

rem install Zabbix Agent
"%zabbix%\zabbix_agentd.exe" --config "%zabbix%\zabbix_agentd.conf" --install
if !errorlevel!==0 (
rem start the service
sc start "Zabbix Agent"
if not !errorlevel!==0 echo Cannot start Zabbix Agent service. Result code !errorlevel!

) else echo Cannot install Zabbix Agent. Result code !errorlevel!
) else echo Cannot create "%zabbix%". Result code !errorlevel!
) else echo Zabbix Agent already exist

endlocal

pause
