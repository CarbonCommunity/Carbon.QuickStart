@echo off

if "%1" EQU "" (
	set TAG=preview
) else (
	set TAG=%1
)

if "%TAG%" EQU "production" (
	set BUILD=Release
) else (
	SET BUILD=Debug
)

if "%1" EQU "" (
	set BRANCH=public
) else (
	set BRANCH=%3
)

SET root=%cd%
SET server=%root%\server
SET steam=%root%\steam
SET url=https://github.com/CarbonCommunity/Carbon/releases/download/%TAG%_build/Carbon.Windows.%BUILD%.zip	
SET steamCmd=https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip

echo * Server directory: %server%
echo * Steam directory: %steam%
echo * Root directory: %root%
echo * Carbon: %url%

if not "%1" EQU "" (
	set server=%root%\%2
)

rem Ensure folders are created
if not exist "%server%" mkdir "%server%"

rem Download latest development build of Carbon
echo Downloading Carbon from the '%TAG%' tag for %BUILD% build
powershell -Command "(New-Object Net.WebClient).DownloadFile('%url%', '%root%\carbon.zip')"

rem Extract it in the server folder
cd %server%
echo Extracting Carbon
powershell -Command "Expand-Archive '%root%\carbon.zip' -DestinationPath '%server%\server'" -Force

rem Download & extract Steam it in the steam folder
if not exist "%steam%" (
	mkdir "%steam%"
	cd "%steam%"
	
	echo Downloading Steam
	powershell -Command "(New-Object Net.WebClient).DownloadFile('%steamCmd%', '%root%\steam.zip')"
	echo Extracting Steam
	powershell -Command "Expand-Archive '%root%\steam.zip' -DestinationPath '%steam%'" -Force

	del "%root%\steam.zip"
)

rem Cleanup
del "%root%\carbon.zip"

rem Download the server
cd "%steam%"
steamcmd.exe +force_install_dir "%server%\server" ^
			 +login anonymous ^
             +app_update 258550 ^
			 -beta %BRANCH% ^
             validate ^
             +quit ^