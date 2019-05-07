@echo off
if "%1"=="" set version=4.0.7
if not "%1"=="" set version=%1
if "%2"=="" set sec="amd64.zip\|i386.zip"
if not "%2"=="" set sec="%2"
set base=https://www.zabbix.com/download_agents

setlocal EnableDelayedExpansion

echo.
echo listing zip archives under %base% with filters: "%version%", %sec%
rem see all zip files available at home page
for /f "tokens=*" %%a in ('^
curl -k -sL "%base%" ^|
grep -E -o "\/downloads\/.*zip" ^|
sed "s/^/https:\/\/www.zabbix.com/" ^|
grep "/%version%" ^|
grep -i %sec%') do (

rem determine the filename
for /f "tokens=*" %%f in ('^
echo %%a ^|
sed "s/^.*\///g"') do (

rem check if file exist in current directory
if not exist "%~dp0%%f" (
echo.
echo %%f
curl -sL %%a > %%f
) else echo %%falready exist

)

)
endlocal
