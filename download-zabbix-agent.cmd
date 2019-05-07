@echo off
setlocal EnableDelayedExpansion

if "%1"=="" set version=4.2
if not "%1"=="" set version=%1

rem see all zip files available at home page
for /f "tokens=*" %%a in ('^
curl -k -sL "https://www.zabbix.com/download_agents" ^|
grep -E -o "\/downloads\/.*zip" ^|
sed "s/^/https:\/\/www.zabbix.com/" ^|
grep "/%version%"') do (

rem determine the filename
for /f "tokens=*" %%f in ('^
echo %%a ^|
sed "s/^.*\///g"') do (

rem check if file exist in current directory
if not exist "%~dp0%%f" (
curl -L %%a > %%f
) else echo %%f already exist

)

)
endlocal
