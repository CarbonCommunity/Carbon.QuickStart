@echo off

if "%1" EQU "" (
	set TAG=develop
) else (
	set TAG=%1
)

if "%TAG%" EQU "production" (
	set BUILD=Release
) else (
	SET BUILD=Debug
)

SET root=%cd%
SET server=%root%\server
SET steam=%root%\steam
SET url=https://github.com/CarbonCommunity/Carbon.Core/releases/download/%TAG%_build/Carbon.Windows.%BUILD%.zip	
SET steamCmd=https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip

rem Download the server
cd "%steam%"
steamcmd.exe +force_install_dir %server% ^
			 +login anonymous ^
             +app_update 258550 ^
             validate ^
             +quit ^