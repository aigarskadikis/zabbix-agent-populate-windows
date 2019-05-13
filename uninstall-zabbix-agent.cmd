@echo off

net session 1>NUL 2>NUL || (Echo Please run this script as administrator & Exit /b 1)

setlocal EnableDelayedExpansion

sc query "Zabbix Agent" > nul 2>&1
if !errorlevel!==0 (
sc stop "Zabbix Agent"
sc delete "Zabbix Agent"
) else echo Zabbix Agent not installed

endlocal
