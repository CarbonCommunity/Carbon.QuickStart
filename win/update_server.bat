@echo off

SET root=%cd%
SET server=%root%\server
SET steam=%root%\steam
SET steamCmd=https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip

rem Download the server
cd "%steam%"
steamcmd.exe +force_install_dir %server% ^
			 +login anonymous ^
             +app_update 258550 ^
             validate ^
             +quit ^