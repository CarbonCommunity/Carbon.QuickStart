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
if not exist %server% mkdir %server%
if not exist %steam% mkdir %steam%

rem Download latest development build of Carbon
powershell -Command "(New-Object Net.WebClient).DownloadFile('%url%', '%root%\carbon.zip')"

rem Extract it in the server folder
cd %server%
powershell -Command "Expand-Archive %root%\carbon.zip -DestinationPath %server%"

rem Download SteamCMD
powershell -Command "(New-Object Net.WebClient).DownloadFile('%steamCmd%', '%root%\steam.zip')"

rem Extract it in the server folder
cd %steam%
powershell -Command "Expand-Archive %root%\steam.zip -DestinationPath %steam%"

rem Cleanup
del %root%\carbon.zip
del %root%\steam.zip

rem Download the server
steamcmd.exe +login anonymous ^
             +force_install_dir "%server%" ^
             +app_update 258550 ^
             validate ^
             +quit

rem Start up the server
cd %server%
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
