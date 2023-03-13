@echo off

SET root=%cd%
SET server=%root%\server
SET steam=%root%\steam
SET url=https://github.com/CarbonCommunity/Carbon.Core/releases/download/develop_build/Carbon.Windows.Debug.zip
SET steamCmd=https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip

rem Settings
SET branch=public
SET identity=main
SET name=My Carbon Test Server
SET size=3000
SET seed=543625
SET ip=localhost
SET port=28505
SET rconPort=28506
SET rconPassword=mypasslol

rem Ensure folders are created
if not exist "%server%" mkdir "%server%"

rem Download latest development build of Carbon
echo Downloading Carbon
powershell -Command "(New-Object Net.WebClient).DownloadFile('%url%', '%root%\carbon.zip')"

rem Extract it in the server folder
cd %server%
echo Extracting Carbon
powershell -Command "Expand-Archive '%root%\carbon.zip' -DestinationPath '%server%'" -Force


rem Download & extract Steam it in the steam folder
if not exist "%steam%" (
	mkdir "%steam%"
	cd "%steam%"
	
	echo Downloading Steam
	powershell -Command "(New-Object Net.WebClient).DownloadFile('%steamCmd%', '%root%\steam.zip')"
	echo Extracting Steam
	powershell -Command "Expand-Archive '%root%\steam.zip' -DestinationPath '%steam%'" -Force
)

rem Cleanup
del "%root%\carbon.zip"
del "%root%\steam.zip"

rem Download the server
cd "%steam%"
steamcmd.exe +force_install_dir %server% ^
			 +login anonymous ^
             +app_update 258550 ^
             validate ^
             +quit ^

rem Start up the server
cd "%server%"
RustDedicated.exe -nographics -batchmode -logs -silent-crashes ^
                  -server.hostname "%name%" ^
                  -server.identity "%identity%" ^
                  -server.port %port% ^
                  -server.netlog ^
                  -server.saveinterval 400 ^
                  -rcon.port %rconPort% ^
                  -rcon.password "%rconPassword%" ^
                  -rcon.web true ^
                  -server.maxplayers 50 ^
                  -chat.serverlog 1 ^
                  +server.seed %seed% ^
                  +server.worldsize %size% ^
                  -logfile "%identity%_log.txt" ^