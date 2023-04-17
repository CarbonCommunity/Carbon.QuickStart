@echo off

SET root=%cd%
SET server=%root%\server
SET steam=%root%\steam
SET steamCmd=https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip

:: Check if steam directory exists, if it doesn't then download steam
if not exist "%steam%" (
	mkdir "%steam%"
	cd "%steam%"
	
	echo Downloading Steam
	powershell -Command "(New-Object Net.WebClient).DownloadFile('%steamCmd%', '%root%\steam.zip')"
	echo Extracting Steam
	powershell -Command "Expand-Archive '%root%\steam.zip' -DestinationPath '%steam%'" -Force

	del "%root%\steam.zip"
)

rem Download the server
cd "%steam%"
steamcmd.exe +force_install_dir %server% ^
			 +login anonymous ^
             +app_update 258550 ^
             validate ^
             +quit ^