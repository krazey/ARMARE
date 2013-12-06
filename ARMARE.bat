@echo off
::----------------------------------------------------------------------------------::
:: ArmA + BEC | Automatic Server Restart Script v0.1                                ::
::                                                                                  ::
:: - Autostart (or GUI-Mode) (all settings can be changed via config)               ::
:: - Setting variables for each Process ID                                          ::
:: - Generating config.ini                                                          ::
:: - Restarting itself                                                              ::
:: - Can be closed at anytime                                                       ::
:: - (Each step can be logged)                                                      ::
::                                                                                  ::
:: Tested with: ArmA 2 OA v1.62 106400 // Bec v1.496                                ::
:: - http://www.arma2.com/beta-patch.php - ArmA 2 OA Beta                           ::
:: - http://ibattle.org/ - latest Bec                                               ::
::                                                                                  ::
:: http://krazey.de // Written by Mathias 'kraZey'                                  ::
::----------------------------------------------------------------------------------::
:://////////////////////////////////////////////////////////////////////////////////::
:://///INITIALIZATION///////////////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
set title=ARMARE
title %title%
color F0
mode con lines=28 cols=80
::----------------------------------------------------------------------------------::
::-----process config_new.ini-------------------------------------------------------::
::----------------------------------------------------------------------------------::
if exist config_new.ini for /f "delims=" %%x in (config_new.ini) do (set "%%x")
cls
::----------------------------------------------------------------------------------::
::-----standard variables-----------------------------------------------------------::
::----------------------------------------------------------------------------------::
set ARMA2=arma2oaserver.exe
set STARTPATH=%cd%
set COUNT=1
set TIMERSTA=1
set TIMEREND=20
set PID=
set var=1
::----------------------------------------------------------------------------------::
::-----detecting pid of this cmd-process--------------------------------------------::
::----------------------------------------------------------------------------------::
if not defined sessionname set sessionname=Console
for /f "usebackq tokens=2" %%a in (`tasklist /FO list /FI "sessionname eq %sessionname%" /FI "username eq %username%" /FI "windowtitle eq %title%" ^| find /i "PID:"`) do set PID=%%a
if not defined PID for /f "usebackq tokens=2" %%a in (`tasklist /FO list /FI "sessionname eq %sessionname%" /FI "username eq %username%" /FI "windowtitle eq Administrator:  %title%" ^| find /i "PID:"`) do set PID=%%a
::if not defined PID echo !Error: xyz.  Exit.& exit /b 1
cls
echo KRAZEY ARMARE initialized...
timeout /t 2 /nobreak > nul
set title=ARMARE - PID: %PID% - START: %DATE% / %TIME:~0,8%
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
::-----faking process of config_new.ini - placeholder-------------------------------::
::----------------------------------------------------------------------------------::
timeout /t 1 /nobreak > nul
cls
echo Processing config_new.ini...
timeout /t 2 /nobreak > nul
cls
echo Script starts for the following number of servers: %servernum%
timeout /t 2 /nobreak > nul
cls
echo Processing config_new.ini...
echo [][][]
timeout /t 1 /nobreak > nul
cls
echo Processing config_new.ini...
echo [][][][][][][][][][][][][][][][][][]
timeout /t 1 /nobreak > nul
cls
echo Processing config_new.ini...
echo [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
timeout /t 1 /nobreak > nul
cls
echo Initialization complete.
timeout /t 1 /nobreak > nul
if '%auto%' NEQ 'Y' echo Starting GUI/Main Menu...
if '%auto%' NEQ 'Y' timeout /t 1 /nobreak > nul
cls
::----------------------------------------------------------------------------------::
::-----process checkfiles, skip GUI if AUTO=Y---------------------------------------::
::----------------------------------------------------------------------------------::
cd /d %becpath%
cls
::if defined choice set "choice="
::if '%auto%' NEQ 'Y' goto gui
if '%auto%' EQU 'Y' goto detectpid
:://////////////////////////////////////////////////////////////////////////////////::
:://///GUI - MAIN MENU//////////////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:gui
set var=1
echo	--------------------------------------------------------------------------------
echo 	  Delete all checkfiles?
:checkfile_1
if '%var%' GTR '%servernumm%' goto gui_1
if exist %checkfile%%var% echo 	  %checkfile%%var% - gefunden
if not exist %checkfile%%var% echo 	  %checkfile%%var% - nicht gefunden
set /a var=%var%+1 > nul
goto checkfile_1
:gui_1
set var=1
echo	--------------------------------------------------------------------------------
echo	--------------------------------------------------------------------------------
echo	--------------------------------------------------------------------------------
echo 	  Y =	All checkfiles will be deleted, all running server will be restarted
echo	--------------------------------------------------------------------------------
echo 	  N = 	Detecting PIDs of running server, initialize checkfiles
:checkfile_2
if '%var%' GTR '%servernumm%' goto gui_2
if not exist %checkfile%%var% call echo 	 	(!) %checkfile%%var% - not found, %%server%var%%% will be restarted
set /a var=%var%+1 > nul
goto checkfile_2
:gui_2
set var=1
echo	--------------------------------------------------------------------------------
:gui_3
if '%var%' GTR '%servernumm%' goto gui_4
if exist %checkfile%%var% call echo 	  %var% = 	starting/restarting %%server%var%%%
if exist %checkfile%%var% echo			Delete checkfile, detect PIDs, back to GUI
if not exist %checkfile%%var% call echo 	  %var%x = 	%%server%var%%% is online!
if not exist %checkfile%%var% echo			Create checkfile if server online, back to GUI
echo	--------------------------------------------------------------------------------
set /a var=%var%+1 > nul
goto gui_3
:gui_4
echo 	  RE =	Restarting KraZey ARMARE
echo	--------------------------------------------------------------------------------
echo Your choice:
set /P choice=
::----------------------------------------------------------------------------------::
::-----process selection------------------------------------------------------------::
::----------------------------------------------------------------------------------::
set var=1
if '%choice%' EQU 'RE' goto restartarmare
if '%choice%' EQU 'Y' goto choice_y
if '%choice%' EQU 'N' goto detectpid
if '%choice%' EQU '%var%' goto choice_var
if '%choice%' EQU '%var%x' goto choice_varx
:choice_y
if '%var%' GTR '%servernumm%' goto detectpid
del %checkfile%%var% /q > nul
set /a var=%var%+1 > nul
goto choice_y
:choice_var
set var=%choice%
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "windowtitle eq %%server%var%windowtitle%%"') do (echo %PIDs% | find "%%p" > nul || if not defined PIDSERVER%var% set "PIDSERVER%var%=%%p")
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || if not defined PIDBEC%var% set "PIDBEC%var%=%%p")
del %checkfile%%var% /q > nul
goto startserver
:choice_varx
set var=%choice:~0,-1%
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "windowtitle eq %%server%var%windowtitle%%"') do (echo %PIDs% | find "%%p" > nul || if not defined PIDSERVER%var% set "PIDSERVER%var%=%%p")
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || if not defined PIDBEC%var% set "PIDBEC%var%=%%p")
cls
if defined PIDSERVER%var% echo useless > %checkfile%%var% && echo checkfile created! ..back to GUI.
if not defined PIDSERVER%var% echo %%server%var%%% not online! ..back to GUI.
timeout /t 2 /nobreak > nul
goto gui
:://////////////////////////////////////////////////////////////////////////////////::
:://///DETECTING SERVER + BEC PIDS//////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:detectpid
if '%var%' GTR '%servernum%' goto finisheddetectpid
::for /f "tokens=1* delims==" %%i in ('set server%var%') do echo %%j
::call echo %%server%var%windowtitle%%
::call echo %%server%var%%%
if not defined PIDSERVER%var% timeout /t 1 /nobreak > nul
if not defined PIDSERVER%var% echo --------------------------------------------------------------------------------
if not defined PIDSERVER%var% for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "windowtitle eq %%server%var%windowtitle%%"') do (echo %PIDs% | find "%%p" > nul || if not defined PIDSERVER%var% set "PIDSERVER%var%=%%p")
if defined PIDSERVER%var% call echo %%server%var%%% - PID: %%PIDSERVER%var%%%
if defined PIDSERVER%var% timeout /t 1 /nobreak > nul
if not defined PIDBEC%var% for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || if not defined PIDBEC%var% set "PIDBEC%var%=%%p")
if defined PIDBEC%var% call echo %%bec%var%%% - PID: %%PIDBEC%var%%%
if defined PIDBEC%var% echo\
if defined PIDBEC%var% echo --------------------------------------------------------------------------------
if defined PIDBEC%var% timeout /t 1 /nobreak > nul
set /a var=%var%+1 > nul
goto detectpid
::----------------------------------------------------------------------------------::
::-----fake detect, placeholder-----------------------------------------------------::
::----------------------------------------------------------------------------------::
:finisheddetectpid
cd /d %becpath%
set var=1
cls
timeout /t 1 /nobreak > nul
echo Loading...
echo [][][][][][][]][][]
timeout /t 1 /nobreak > nul
cls
echo Loading...
echo [][][][][][][][][][][][][][][][][][][][][]][][][][][]
timeout /t 1 /nobreak > nul
cls
echo Loading...
echo [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
timeout /t 2 /nobreak > nul
cls
echo PIDs detected. Initialize checkfiles...
timeout /t 5 /nobreak > nul
cls
echo --------------------------------------------------------------------------------
goto check
:://////////////////////////////////////////////////////////////////////////////////::
:://///PROCESS CHECKFILES///////////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:check
if '%TIMERSTA%' GTR '%TIMEREND%' goto restartarmare
if not exist %checkfile%%var% goto startserver
if '%servernum%' EQU '%var%' goto counter
set /a var=%var%+1 > nul
goto check
:counter
set var=1
timeout /t 5 /nobreak > nul
title %title% - TIMER: %TIMERSTA% / %TIMEREND%
set /a COUNT=%COUNT%+1 > nul
set /a TIMERSTA=%TIMERSTA%+1 > nul
if '%COUNT%' EQU '10' goto BECCHECK
goto check
::----------------------------------------------------------------------------------::
::-----bec-onlinecheck--------------------------------------------------------------::
::----------------------------------------------------------------------------------::
:BECCHECK
set COUNT=1
goto check
::if '%becONchecker%' == 'OFF' set COUNT=1
::if '%becONchecker%' == 'OFF' goto check
::add varcheck for hive_error
::for /f "skip=3 tokens=2" %%p in ('tasklist /fi "windowtitle eq hive error"') do (echo %PIDs% | find "%%p" > nul || if not defined HIVE_ERROR set "HIVE_ERROR=%%p")
::if defined HIVE_ERROR timeout /t 2 /nobreak > nul
::if defined HIVE_ERROR set COUNT=1
::if not defined HIVE_ERROR goto BECCHECKjump
::if '%HIVE_ERROR%' == '%PIDSERVER1%' goto startserver
::----------------------------------------------------------------------------------::
::BECCHECKjump
::if defined PIDBEC1 tasklist /fi "PID eq %PIDBEC1%" | findstr %PIDBEC1% > nul
::if defined PIDBEC1 if %errorlevel%==1 goto becoff1
::if defined PIDBEC1 timeout /t 2 /nobreak > nul
::set COUNT=1
::goto check
::----------------------------------------------------------------------------------::
::becoff1
::set COUNT=1
::if exist %checkfile%1 del %checkfile%1 /q
::if not exist %checkfile%1 goto becoffjump
:://////////////////////////////////////////////////////////////////////////////////::
:://///START SERVER FOR VAR=x///////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:startserver
::if defined server%var%offline call echo %%server%var%offline%%

timeout /t 5 /nobreak > nul
if defined PIDSERVER%var% call echo %date% %time:~0,8%	Kill %%server%var%%% Server + BEC
if defined PIDSERVER%var% call taskkill /f /pid %%PIDSERVER%var%%% > nul
if defined PIDBEC%var% call taskkill /f /pid %%PIDBEC%var%%% > nul
timeout /t 1 /nobreak > nul
if defined PIDSERVER%var% set "PIDSERVER%var%="
if defined PIDBEC%var% set "PIDBEC%var%="
if defined HIVE_ERROR set "HIVE_ERROR="
timeout /t 1 /nobreak > nul
for /f "delims=" %%l in ('for /f "skip=3 tokens=2" %%p in ^('tasklist /fi "imagename eq %ARMA2%"'^) do @^<nul set /p "=%%p "') do (set "PIDs=%%l")
call echo %date% %time:~0,8%	Starting %%server%var%%% Server...
call cd /d %%serverpath%var%%%
call start /min .\Expansion\beta\arma2oaserver.exe %%serverstart%var%%%
timeout /t 1 /nobreak > nul
for /f "skip=3 tokens=2" %%p in ('tasklist /fi "imagename eq %ARMA2%"') do (echo %PIDs% | find "%%p" > nul || if not defined PIDSERVER%var% set "PIDSERVER%var%=%%p")
if defined PIDSERVER%var% call echo %date% %time:~0,8%	%%server%var%%% started with PID: %%PIDSERVER%var%%%
timeout /t %timeoutRE% /nobreak > nul
call echo %date% %time:~0,8%	Starting BEC for %%server%var%%% Server... 
timeout /t 1 /nobreak > nul
for /f "delims=" %%l in ('for /f "skip=3 tokens=2" %%p in ^('call tasklist /fi "imagename eq %%bec%var%%%"'^) do @^<nul set /p "=%%p "') do (set "PIDs=%%l")
cd /d %becpath%
call start /min "%becpath%" "%%bec%var%%%" -f %%server%var%beccfg%%
timeout /t 1 /nobreak > nul
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || if not defined PIDBEC%var% set "PIDBEC%var%=%%p")
if defined PIDBEC%var% call echo %date% %time:~0,8%	BEC started with PID: %%PIDBEC%var%%%
timeout /t 1 /nobreak > nul
cd /d %becpath%
echo useless > %checkfile%%var%

::if defined server%var%started call echo %date% - %time:~0,8% -  %%server%var%%% Server started... %%server%var%started%%
::if defined server%var%online call echo %%server%var%online%%

::if '%entry%' == '1' goto random
::if '%entry%' == 'Y' set "entry="
::if '%entry%' == 'y' set "entry="
::if '%entry%' == 'YN' set /a var=%var%+1 > nul
::if '%entry%' == 'yn' goto startserver
::if '%entry%' == 'N' set "entry="
::if '%entry%' == 'n' set "entry="
echo\
echo --------------------------------------------------------------------------------
set COUNT=1
set var=1
goto check
:://////////////////////////////////////////////////////////////////////////////////::
:://///CREATING CONFIG_NEW.INI//////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:configcreate
cls
echo Do you wanna create "config_new.ini"?
set /P config=(Y)es / (N)o? 
if '%config%' == 'Y' goto configcreateJ
if '%config%' == 'y' goto configcreateJ
if '%config%' == 'N' goto exitbatch
if '%config%' == 'n' goto exitbatch
if '%config%' == '' goto exitbatch
:configcreateJ
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
echo server%var%offline=>> config_new.ini
echo server%var%online=>> config_new.ini
echo server%var%started=>> config_new.ini
echo\ >> config_new.ini
if '%numm%' == '%var%' goto exitbatch
set /a var=%var%+1 > nul
goto servervar
:exitbatch
cls
echo "config_new.ini" created. Script is going to be closed now!
timeout /t 3 /nobreak > nul
exit
:://////////////////////////////////////////////////////////////////////////////////::
:://///RESTARTING SCRIPT IF AUTO=Y//////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:restartarmare
if '%auto%' == 'N' set timer=1
if '%auto%' == 'N' goto check
cd /d %STARTPATH%
start /I "" ARMARE.bat
taskkill /f /pid %PID% > nul
exit