@echo off
::----------------------------------------------------------------------------------::
:: ArmA + BEC | Automatic Server Restart Script v0.2 (07-Dec-2013)                  ::
::                                                                                  ::
:: - Autostart or UI-Mode (all settings can be changed via config)                  ::
:: - Setting variables for each Process ID                                          ::
:: - Generating config.ini                                                          ::
:: - Restarting itself (auto=Y or N)                                                ::
:: - Can be closed at anytime                                                       ::
:: - (Each step can be logged)                                                      ::
::                                                                                  ::
:: Tested on: Windows 2008 R2 Standard Edition                                      ::
:: with: ArmA 2 OA v1.62 106400 & Bec v1.496                                        ::
:: - http://www.arma2.com/beta-patch.php - ArmA 2 OA Beta                           ::
:: - http://ibattle.org/ - Bec                                                      ::
::                                                                                  ::
:: http://krazey.de // Written by Mathias 'kraZey'                                  ::
::----------------------------------------------------------------------------------::
:://////////////////////////////////////////////////////////////////////////////////::
:://///INITIALIZATION///////////////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
::----------------------------------------------------------------------------------::
::-----standard variables-----------------------------------------------------------::
::----------------------------------------------------------------------------------::
set ARMA2=arma2oaserver.exe
set STARTPATH=%cd%
set BATCHNAME=%~n0%~x0
set BECCOUNT=1
set TIMERSTA=1
set TIMEREND=10000
set var=1
set title=ARMARE
title %title% - %~n0%~x0
color F0
mode con lines=28 cols=80
::----------------------------------------------------------------------------------::
::-----"process" config_new.ini-----------------------------------------------------::
::----------------------------------------------------------------------------------::
if exist config_new.ini for /f "delims=" %%x in (config_new.ini) do (set "%%x") > nul
cls
timeout /t 1 /nobreak > nul
echo Processing config_new.ini...
echo [][][][][][][][][]
timeout /t 1 /nobreak > nul
cls
echo Processing config_new.ini...
echo [][][][][][][][][][][][][][][][][][][][][][][][][][][]
timeout /t 1 /nobreak > nul
cls
echo Processing config_new.ini...
echo [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
timeout /t 1 /nobreak > nul
cls
::----------------------------------------------------------------------------------::
::-----detecting pid of this cmd-process--------------------------------------------::
::----------------------------------------------------------------------------------::
title %title%
if not defined sessionname set sessionname=Console
for /f "usebackq tokens=2" %%a in (`tasklist /FO list /FI "sessionname eq %sessionname%" /FI "username eq %username%" /FI "windowtitle eq %title%" ^| find /i "PID:"`) do set PID=%%a
if not defined PID for /f "usebackq tokens=2" %%a in (`tasklist /FO list /FI "sessionname eq %sessionname%" /FI "username eq %username%" /FI "windowtitle eq Administrator:  %title%" ^| find /i "PID:"`) do set PID=%%a
::if not defined PID echo !Error: xyz.  Exit.& exit /b 1
cls
echo KRAZEY ARMARE initialized...
timeout /t 2 /nobreak > nul
set title=%title% - PID: %PID% - START: %DATE% / %TIME:~0,8%
title %title%
cls
timeout /t 1 /nobreak > nul
::----------------------------------------------------------------------------------::
::-----generate config_new.ini (if not exist)---------------------------------------::
::----------------------------------------------------------------------------------::
if not exist config_new.ini timeout /t 3 /nobreak > nul
if not exist config_new.ini cls
if not exist config_new.ini echo Error: config_new.ini was not found!
if not exist config_new.ini timeout /t 5 /nobreak > nul
if not exist config_new.ini goto configcreate
::----------------------------------------------------------------------------------::
echo Script starts for the following number of servers: %servernum%
timeout /t 2 /nobreak > nul
if '%auto%' NEQ 'Y' echo Starting UI/Main Menu... && timeout /t 1 /nobreak > nul
cls
::----------------------------------------------------------------------------------::
::-----process checkfiles, skip UI if AUTO=Y----------------------------------------::
::----------------------------------------------------------------------------------::
cd /d %becpath%
if '%auto%' NEQ 'Y' goto ui_0
goto detectpid
:://////////////////////////////////////////////////////////////////////////////////::
:://///UI - MAIN MENU///////////////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:ui_0
mode con lines=60 cols=80
set var=1
echo	--------------------------------------------------------------------------------
echo 	  Delete all checkfiles?
:checkfile_1
if %var% GTR %servernum% goto ui_1
if exist %checkfile%%var% echo 	  %checkfile%%var% - found
if not exist %checkfile%%var% echo 	  %checkfile%%var% - not found
set /a var=%var%+1 > nul
goto checkfile_1
:ui_1
set var=1
echo	--------------------------------------------------------------------------------
echo 	  Y =	Deleting all checkfiles, restarting all running server
echo	--------------------------------------------------------------------------------
echo 	  N = 	Detecting PIDs of running server, initialize checkfiles
:checkfile_2
if %var% GTR %servernum% goto ui_2
if not exist %checkfile%%var% call echo 	 	(!) %checkfile%%var% - not found, %%server%var%%% will be restarted
set /a var=%var%+1 > nul
goto checkfile_2
:ui_2
set var=1
echo	--------------------------------------------------------------------------------
:ui_3
if %var% GTR %servernum% goto ui_4
if exist %checkfile%%var% call echo 	  %var% = 	starting/restarting %%server%var%%%
if exist %checkfile%%var% echo			Delete checkfile, detect PIDs, back to UI
if not exist %checkfile%%var% call echo 	  %var%x = 	checking %%server%var%%%
if not exist %checkfile%%var% echo			Create checkfile if server online, back to UI
echo	--------------------------------------------------------------------------------
set /a var=%var%+1 > nul
goto ui_3
:ui_4
echo 	  UP =	Update/Reload UI
echo 	  RE =	Restart ARMARE
echo 	  EX =	Exit ARMARE
echo	--------------------------------------------------------------------------------
echo Your choice:
set /P choice=
::----------------------------------------------------------------------------------::
::-----process selection------------------------------------------------------------::
::----------------------------------------------------------------------------------::
set var=1
cls
if '%choice%' EQU 'ex' exit
if '%choice%' EQU 'EX' exit
if '%choice%' EQU 'up' goto ui_0
if '%choice%' EQU 'UP' goto ui_0
if '%choice%' EQU 're' goto restartarmare_1
if '%choice%' EQU 'RE' goto restartarmare_1
if '%choice%' EQU 'y' goto choice_y
if '%choice%' EQU 'Y' goto choice_y
if '%choice%' EQU 'n' goto detectpid
if '%choice%' EQU 'N' goto detectpid
set var=%choice:~0,1%
if '%choice%' EQU '%var%' goto choice_var
if '%choice%' EQU '%var%x' goto choice_varx
:choice_y
if %var% GTR %servernum% goto choice_y_detect
del %checkfile%%var% /q > nul
set /a var=%var%+1 > nul
goto choice_y
:choice_y_detect
set var=1
goto detectpid
:choice_var
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "windowtitle eq %%server%var%windowtitle%%"') do (echo %PIDs% | find "%%p" > nul || set "pidserver%var%=%%p")
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || set "pidbec%var%=%%p")
del %checkfile%%var% /q > nul
echo --------------------------------------------------------------------------------
goto startserver
:choice_varx
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "windowtitle eq %%server%var%windowtitle%%"') do (echo %PIDs% | find "%%p" > nul || set "pidserver%var%=%%p")
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || set "pidbec%var%=%%p")
cls
if defined pidbec%var% echo useless > %checkfile%%var% && echo checkfile created! ..back to UI. && goto ui_0
echo --------------------------------------------------------------------------------
call echo (!) %%server%var%%% or Bec not online! ..restarting server + Bec, then back to UI.
echo\
goto startserver
:://////////////////////////////////////////////////////////////////////////////////::
:://///DETECTING SERVER + BEC PIDS//////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:detectpid
if %var% GTR %servernum% goto finisheddetectpid
echo --------------------------------------------------------------------------------
if not defined pidserver%var% for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "windowtitle eq %%server%var%windowtitle%%"') do (echo %PIDs% | find "%%p" > nul || set "pidserver%var%=%%p")
if defined pidserver%var% call echo %%server%var%%% - PID: %%pidserver%var%%%
if defined pidserver%var% timeout /t 1 /nobreak > nul
if not defined pidbec%var% for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || set "pidbec%var%=%%p")
if defined pidbec%var% call echo %%bec%var%%% - PID: %%pidbec%var%%%
echo\
echo --------------------------------------------------------------------------------
timeout /t 1 /nobreak > nul
set /a var=%var%+1 > nul
goto detectpid
::----------------------------------------------------------------------------------::
::-----fake detect, placeholder-----------------------------------------------------::
::----------------------------------------------------------------------------------::
:finisheddetectpid
set var=1
cls
timeout /t 1 /nobreak > nul
echo Loading...
echo [][][][][][][][][]
timeout /t 1 /nobreak > nul
cls
echo Loading...
echo [][][][][][][][][][][][][][][][][][][][][][][][][][][]
timeout /t 1 /nobreak > nul
cls
echo Loading...
echo [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
timeout /t 2 /nobreak > nul
cls
echo PIDs detected. Initialize checkfiles...
timeout /t 5 /nobreak > nul
cls
title %title% - TIMER: %TIMERSTA% / %TIMEREND%
echo --------------------------------------------------------------------------------
:://////////////////////////////////////////////////////////////////////////////////::
:://///PROCESS CHECKFILES///////////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:check
set precheck=false
if %TIMERSTA% GTR %TIMEREND% goto restartarmare_0
if not exist %checkfile%%var% goto startserver
if %servernum% EQU %var% goto beccounter
set /a var=%var%+1 > nul
goto check
:beccounter
set var=1
timeout /t 5 /nobreak > nul
set /a BECCOUNT=%BECCOUNT%+1 > nul
set /a TIMERSTA=%TIMERSTA%+1 > nul
title %title% - TIMER: %TIMERSTA% / %TIMEREND%
if %BECCOUNT% EQU 10 goto beccheck
goto check
::----------------------------------------------------------------------------------::
::-----bec-onlinecheck & check for hive error---------------------------------------::
::----------------------------------------------------------------------------------::
:beccheck
set BECCOUNT=1
set HIVE_ERROR=
set hivevar=
set var=1
if '%becONchecker%' EQU 'ON' goto process_beccheck
goto check
::hive_error
::if %var% GTR %servernum% goto process_beccheck
::for /f "skip=3 tokens=2" %%p in ('tasklist /fi "windowtitle eq hive error"') do (echo %PIDs% | find "%%p" > nul || if not defined HIVE_ERROR set "HIVE_ERROR=%%p")
::if defined HIVE_ERROR timeout /t 2 /nobreak > nul
::call if '%HIVE_ERROR%' EQU '%%pidserver%var%%%' set hivevar=true
::call if '%HIVE_ERROR%' EQU '%%pidserver%var%%%' goto startserver
::set /a var=%var%+1 > nul
::goto hive_error
::----------------------------------------------------------------------------------::
:process_beccheck
ver > nul
if %var% GTR %servernum% set precheck=true
if '%precheck%' EQU 'true' set var=1
if '%precheck%' EQU 'true' goto check
for /f "tokens=1* delims==" %%i in ('set pidbec%var%') do tasklist /fi "PID eq %%j" | findstr %%j > nul
if %errorlevel% EQU 1 goto becoff
if not defined pidbec%var% goto becoff
timeout /t 2 /nobreak > nul
set /a var=%var%+1 > nul
goto process_beccheck
::----------------------------------------------------------------------------------::
:becoff
del %checkfile%%var% /q
echo (!) BEC crashed or has been closed. %checkfile%%var% deleted!
call echo (!) If %%server%var%%% not crashed, BEC will be restarted.
timeout /t 1 /nobreak > nul
for /f "tokens=1* delims==" %%i in ('set pidserver%var%') do tasklist /fi "PID eq %%j" | findstr %%j > nul
if %errorlevel% EQU 1 call echo (!) %%server%var%%% offline, restarting server + BEC && echo\ && goto startserver
call echo (!) %%server%var%%% still online..
echo useless > %checkfile%%var%
call echo (!) Restarting BEC for %%server%var%%% && echo\
call start /min "%becpath%" "%%bec%var%%%" -f %%server%var%beccfg%%
timeout /t 1 /nobreak > nul
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || set "pidbec%var%=%%p")
call echo %date% %time:~0,8%	BEC started with PID: %%pidbec%var%%%
echo\
echo --------------------------------------------------------------------------------
timeout /t 1 /nobreak > nul
set BECCOUNT=1
goto check
:://////////////////////////////////////////////////////////////////////////////////::
:://///START SERVER FOR VAR=x///////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:startserver
timeout /t 5 /nobreak > nul
if defined pidserver%var% call echo %date% %time:~0,8%	Kill %%server%var%%% Server + BEC
if defined pidserver%var% call taskkill /f /pid %%pidserver%var%%% > nul
if defined pidbec%var% call taskkill /f /pid %%pidbec%var%%% > nul
timeout /t 1 /nobreak > nul
if defined pidserver%var% set "pidserver%var%="
if defined pidbec%var% set "pidbec%var%="
if defined HIVE_ERROR set "HIVE_ERROR="
timeout /t 1 /nobreak > nul
for /f "delims=" %%l in ('for /f "skip=3 tokens=2" %%p in ^('tasklist /fi "imagename eq %ARMA2%"'^) do @^<nul set /p "=%%p "') do (set "PIDs=%%l")
call echo %date% %time:~0,8%	Starting %%server%var%%%
call cd /d %%serverpath%var%%%
for /f "tokens=1* delims==" %%i in ('set serverstart%var%') do start /min .\Expansion\beta\arma2oaserver.exe %%j
timeout /t 1 /nobreak > nul
for /f "skip=3 tokens=2" %%p in ('tasklist /fi "imagename eq %ARMA2%"') do (echo %PIDs% | find "%%p" > nul || if not defined pidserver%var% set "pidserver%var%=%%p")
if defined pidserver%var% call echo %date% %time:~0,8%	%%server%var%%% started with PID: %%pidserver%var%%%
timeout /t %timeoutRE% /nobreak > nul
call echo %date% %time:~0,8%	Starting BEC for %%server%var%%% 
timeout /t 1 /nobreak > nul
for /f "delims=" %%l in ('for /f "skip=3 tokens=2" %%p in ^('call tasklist /fi "imagename eq %%bec%var%%%"'^) do @^<nul set /p "=%%p "') do (set "PIDs=%%l")
cd /d %becpath%
call start /min "%becpath%" "%%bec%var%%%" -f %%server%var%beccfg%%
timeout /t 1 /nobreak > nul
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || if not defined pidbec%var% set "pidbec%var%=%%p")
if defined pidbec%var% call echo %date% %time:~0,8%	BEC started with PID: %%pidbec%var%%%
timeout /t 1 /nobreak > nul
echo useless > %checkfile%%var%
echo\
echo --------------------------------------------------------------------------------
if '%choice%' EQU '%var%' goto ui_0
if '%choice%' EQU '%var%x' goto ui_0
if '%hivevar%' EQU 'true' goto beccehck
set BECCOUNT=1
set var=1
goto check
:://////////////////////////////////////////////////////////////////////////////////::
:://///CREATING CONFIG_NEW.INI//////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:configcreate
cls
echo Do you wanna create "config_new.ini"?
set /P config=(Y)es / (N)o? 
if %config% EQU y goto configcreateY
if %config% EQU Y goto configcreateY
if %config% EQU n goto exitbatch
if %config% EQU N goto exitbatch
if '%config%' EQU '' goto exitbatch
:configcreateY
cls
set /P numm=Enter the number of server: 
set var=1
echo // config_new.ini - generated on %date% >> config_new.ini
echo servernum=>> config_new.ini
echo auto=>> config_new.ini
echo becONchecker=>> config_new.ini
echo becpath=>> config_new.ini
echo timeoutRE=>> config_new.ini
echo checkfile=>> config_new.ini
echo\ >> config_new.ini
:servervar
echo server%var%windowtitle=>> config_new.ini
echo server%var%=>> config_new.ini
echo bec%var%=>> config_new.ini
echo server%var%beccfg=>> config_new.ini
echo serverpath%var%=>> config_new.ini
echo serverstart%var%=>> config_new.ini
::echo server%var%offline=>> config_new.ini
::echo server%var%online=>> config_new.ini
::echo server%var%started=>> config_new.ini
echo\ >> config_new.ini
if '%numm%' EQU '%var%' goto exitbatch
set /a var=%var%+1 > nul
goto servervar
:exitbatch
cls
echo "config_new.ini" created. Closing ARMARE now!
timeout /t 3 /nobreak > nul
exit
:://////////////////////////////////////////////////////////////////////////////////::
:://///RESTARTING SCRIPT IF AUTO=Y//////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:restartarmare_0
if %auto% NEQ Y set timer=1
if %auto% NEQ Y goto check
:restartarmare_1
cd /d %STARTPATH%
start /I "" %BATCHNAME%
taskkill /f /pid %PID% > nul
exit