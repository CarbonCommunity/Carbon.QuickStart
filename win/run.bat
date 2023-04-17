@echo off

SET root=%cd%
SET server=%root%\server

rem Settings
SET identity=myrustserver
SET name=My Carbon Test Server
SET size=3000
SET seed=543625
SET ip=localhost
SET port=28505
SET queryport=28506
SET rconPort=28507
SET rconPassword=mypasslol

rem Start up the server
cd "%server%"
RustDedicated.exe -nographics -batchmode -logs -silent-crashes ^
                  -server.hostname "%name%" ^
                  -server.identity "%identity%" ^
                  -server.port %port% ^
                  -server.queryport %queryport% ^
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