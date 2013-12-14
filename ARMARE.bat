@echo off
::----------------------------------------------------------------------------------::
:: ArmA + Bec | Automatic Server Restart Script v0.3 (07-Dec-2013)                  ::
::                                                                                  ::
:: - Autostart or UI-Mode (all settings can be changed via config)                  ::
:: - Setting variables for each Process ID                                          ::
:: - Generates config.ini                                                           ::
:: - Works full automatic and restarts itself (auto=Y or N)                         ::
:: - Can be closed at anytime                                                       ::
:: - Each step can be logged                                                        ::
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
set "first_check=1"
set "ARMA2=arma2oaserver.exe" && set "STARTPATH=%cd%" && set "BATCHNAME=%~n0%~x0"
set "BECCOUNT=1" && set "TIMERSTA=1" && set "TIMEREND=10000" && set "var=1"
set "title=ARMARE" && echo wscript.sleep 50 >%appdata%\armare_sleep_50.vbs
set "useless_0=echo\ && echo\ && echo\ && echo\"
set "useless_1=                    " && set "useless_2=----------------------------³
set "useless_3=%useless_1% ³²²²²²²²²²²²²²²²²²²²²²²²²²²²³"
title %title% - %BATCHNAME%
color F0
mode con lines=28 cols=80
::----------------------------------------------------------------------------------::
::-----generate config_new.ini (if not exist)---------------------------------------::
::----------------------------------------------------------------------------------::
if not exist config_new.ini timeout /t 3 /nobreak > nul
if not exist config_new.ini cls
if not exist config_new.ini %useless_0% && echo %useless_1% Error: config_new.ini was not found!
if not exist config_new.ini timeout /t 5 /nobreak > nul
if not exist config_new.ini goto configcreate
::----------------------------------------------------------------------------------::
::-----"process" config_new.ini-----------------------------------------------------::
::----------------------------------------------------------------------------------::
if exist config_new.ini for /f "delims=" %%x in (config_new.ini) do (set "%%x") > nul
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: var=%var% ³ ("process" config_new.ini)
::/DEBUG----------------------------------------------------------------------------::
timeout /t 1 /nobreak > nul
%useless_0%
echo %useless_1% Processing config_new.ini... && echo\
echo %useless_1% ³---------------------------³   0%%
timeout /t 1 /nobreak > nul
set "bar_0=22" && set "bar_1=28" && set "bar_2=3" && set "a=   "
:loading_0
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: var=%var% ³ bar_0=%bar_0% ³ bar_1=%bar_1% ³ (loadingbar)
::/DEBUG----------------------------------------------------------------------------::
%useless_0% && echo %useless_1% Processing config_new.ini... && echo\
if %bar_2% EQU 12 set "a=  "
if %bar_2% EQU 100 set "a= "
call echo %%useless_3:~0,%bar_0%%%%%useless_2:~-%bar_1%,%bar_1%%%%a%%bar_2%%%%%%
cscript /nologo %appdata%\armare_sleep_50.vbs
if %bar_0% EQU 50 goto loading_1
set /a "bar_0=%bar_0%+1" > nul && set /a "bar_1=%bar_1%-1" > nul
if %bar_0% LSS 38 set /a bar_2=%bar_2%+3 > nul
if %bar_0% GEQ 38 set /a bar_2=%bar_2%+4 > nul
goto loading_0
:loading_1
timeout /t 1 /nobreak > nul
::----------------------------------------------------------------------------------::
::-----detecting pid of this cmd-process--------------------------------------------::
::----------------------------------------------------------------------------------::
title %title%
if not defined sessionname set sessionname=Console
for /f "usebackq tokens=2" %%a in (`tasklist /FO list /FI "sessionname eq %sessionname%" /FI "username eq %username%" /FI "windowtitle eq %title%" ^| find /i "PID:"`) do set PID=%%a
if not defined PID for /f "usebackq tokens=2" %%a in (`tasklist /FO list /FI "sessionname eq %sessionname%" /FI "username eq %username%" /FI "windowtitle eq Administrator:  %title%" ^| find /i "PID:"`) do set PID=%%a
::if not defined PID echo !Error: xyz.  Exit.& exit /b 1
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: var=%var% ³ auto=%auto% ³ (change title)
::/DEBUG----------------------------------------------------------------------------::
%useless_0%
echo %useless_1% KRAZEY ARMARE initialized...
timeout /t 2 /nobreak > nul
set title=%title% - PID: %PID% - START: %DATE% / %TIME:~0,8%
title %title%
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: var=%var% ³ auto=%auto% ³ (random timeout + servernum info)
::/DEBUG----------------------------------------------------------------------------::
timeout /t 1 /nobreak > nul
::----------------------------------------------------------------------------------::
%useless_0%
echo %useless_1% Script starts for the following
echo %useless_1% number of servers: %servernum%
timeout /t 2 /nobreak > nul
echo\
if '%auto%' NEQ 'Y' echo %useless_1% Starting UI/Main Menu... && timeout /t 1 /nobreak > nul
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: var=%var% ³ auto=%auto% ³ (starting ui or skip) && timeout /t 1 /nobreak > nul
::/DEBUG----------------------------------------------------------------------------::
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
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && echo DEBUG: var=%var% ³ auto=%auto% ³ (ui)
::/DEBUG----------------------------------------------------------------------------::
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
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: var=%var% ³ choice=%choice%
::/DEBUG----------------------------------------------------------------------------::
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
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && echo DEBUG: var=%var% ³ (choice_var) && timeout /t 1 /nobreak > nul
::/DEBUG----------------------------------------------------------------------------::
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "windowtitle eq %%server%var%windowtitle%%"') do (echo %PIDs% | find "%%p" > nul || set "pidserver%var%=%%p")
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || set "pidbec%var%=%%p")
del %checkfile%%var% /q > nul
echo --------------------------------------------------------------------------------
goto startserver
:choice_varx
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "windowtitle eq %%server%var%windowtitle%%"') do (echo %PIDs% | find "%%p" > nul || set "pidserver%var%=%%p")
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || set "pidbec%var%=%%p")
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: var=%var% ³ (choice_varx) && timeout /t 1 /nobreak > nul
::/DEBUG----------------------------------------------------------------------------::
if defined pidbec%var% echo useless > %checkfile%%var% && echo checkfile created! ..back to UI. && goto ui_0
echo --------------------------------------------------------------------------------
call echo (!) %%server%var%%% or Bec not online! ..restarting server + Bec, then back to UI.
echo\
goto startserver
:://////////////////////////////////////////////////////////////////////////////////::
:://///DETECTING SERVER + BEC PIDS//////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:detectpid
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: var=%var% ³ (detectpid)
::/DEBUG----------------------------------------------------------------------------::
%useless_0%
echo %useless_1% Detecting PIDs... && echo\
echo %useless_1% ³---------------------------³   0%%
if %var% GTR %servernum% goto preloading
if not defined pidserver%var% for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "windowtitle eq %%server%var%windowtitle%%"') do (echo %PIDs% | find "%%p" > nul || set "pidserver%var%=%%p")
if not defined pidbec%var% for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || set "pidbec%var%=%%p")
cscript /nologo %appdata%\armare_sleep_50.vbs
set /a var=%var%+1 > nul
::/DEBUG----------------------------------------------------------------------------::
if defined debug timeout /t 1 /nobreak > nul
::/DEBUG----------------------------------------------------------------------------::
goto detectpid
:preloading
set var=1
set loadbar_var=0
set "bar_0=22" && set "bar_1=28" && set "bar_2=3" && set "a=   "
timeout /t 1 /nobreakt > nul
:loading_2
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: loadbar_var=%loadbar_var% ³ var=%var% ³ servernum=%servernum% ³ bar_0=%bar_0% ³ bar_1=%bar_1%
::/DEBUG----------------------------------------------------------------------------::
if %var% LEQ %servernum% %useless_0% && echo %useless_1% Detecting PIDs... && echo\
if %var% GTR %servernum% %useless_0% && echo %useless_1% PIDs detected. Initialize checkfiles... && echo\
if %bar_2% EQU 12 set "a=  "
if %bar_2% EQU 100 set "a= "
call echo %%useless_3:~0,%bar_0%%%%%useless_2:~-%bar_1%,%bar_1%%%%a%%bar_2%%%%%%
echo\ && echo\
if exist %appdata%\armaretemp.bat call %appdata%\armaretemp.bat
cscript /nologo %appdata%\armare_sleep_50.vbs
if %bar_2% EQU 100 if %var% GTR %servernum% goto loading_3
if %bar_2% NEQ 100 set /a bar_0=%bar_0%+1 > nul
if %bar_2% NEQ 100 set /a bar_1=%bar_1%-1 > nul
if %bar_2% NEQ 100 if %bar_0% LSS 38 set /a bar_2=%bar_2%+3 > nul
if %bar_2% NEQ 100 if %bar_0% GEQ 38 set /a bar_2=%bar_2%+4 > nul
::----------------------------------------------------------------------------------::
if %loadbar_var% EQU 2 if %var% LEQ %servernum% if defined pidserver%var% (
call echo echo %useless_1% %%server%var%%%  	   [ PID ] : %%pidserver%var%%% >> %appdata%\armaretemp.bat) else (
if defined server%var% call echo echo %useless_1% %%server%var%%%  	   [ PID ] : N/A >> %appdata%\armaretemp.bat)
if %loadbar_var% EQU 5 if %var% LEQ %servernum% if defined pidbec%var% (
call echo echo %useless_1% %%bec%var%%%  	   [ PID ] : %%pidbec%var%%% >> %appdata%\armaretemp.bat) else (
if defined server%var% call echo echo %useless_1% %%bec%var%%%  	   [ PID ] : N/A >> %appdata%\armaretemp.bat)
::----------------------------------------------------------------------------------::
if %auto% EQU Y if defined server%var% if not defined pidserver%var% if not defined pidbec%var% del %checkfile%%var% /q
::----------------------------------------------------------------------------------::
if %loadbar_var% EQU 5 if %var% LEQ %servernum% set /a var=%var%+1 > nul
set /a loadbar_var=%loadbar_var%+1 > nul
if %loadbar_var% EQU 6 set loadbar_var=0
goto loading_2
:loading_3
del %appdata%\armaretemp.bat /q
set var=1
set loadbar_var=0
timeout /t 4 /nobreak > nul
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: loadbar_var=%loadbar_var% ³ var=%var% && timeout /t 1 /nobreak > nul
::/DEBUG----------------------------------------------------------------------------::
title %title% - TIMER: %TIMERSTA% / %TIMEREND%
echo --------------------------------------------------------------------------------
:://////////////////////////////////////////////////////////////////////////////////::
:://///PROCESS CHECKFILES///////////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:check
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && echo DEBUG: var=%var% ³ beccount=%beccount% ³ first_check=%first_check% ³ (check) && cscript /nologo %appdata%\armare_sleep_50.vbs
::/DEBUG----------------------------------------------------------------------------::
::/LOGGING--------------------------------------------------------------------------::
if defined log if defined logpath%var% for /f "tokens=1* delims==" %%i in ('set logpath%var%') do set "logpathtemp=%%j"
if defined log if defined logpathinfo%var% for /f "tokens=1* delims==" %%i in ('set logpathinfo%var%') do set "logpathinfotemp=%%j"
if defined log (
	if %first_check% LEQ %servernum% if defined green_red (
		if exist %checkfile%%var% if defined logpath%var% echo green %logpathtemp%
	) else (
		if %first_check% LEQ %servernum% if exist %checkfile%%var% if defined %logpath% call echo %date% %time:~0,8%   %checkfile%%var% found! - %%server%var%%% %logpath%
	)
	if defined green_red if not exist %checkfile%%var% if defined logpath%var% (
		call echo red %logpathtemp%
		call echo %date% - %time:~0,8% -  %%server%var%%% offline %logpathinfotemp%
	) else (
		if not exist %checkfile%%var% if defined %logpath% call echo %date% %time:~0,8%   %checkfile%%var% not found! - Restarting %%server%var%%% %logpath%
	)
	if %first_check% LEQ %servernum% set /a first_check=%first_check%+1 > nul
)
::/LOGGING--------------------------------------------------------------------------::
set precheck=false
if %TIMERSTA% GTR %TIMEREND% goto restartarmare_0
if defined log (
	if %first_check% GTR %servernum% if not exist %checkfile%%var% goto startserver
) else (
	if not exist %checkfile%%var% goto startserver
)
if %servernum% EQU %var% goto beccounter
set /a var=%var%+1 > nul
goto check
:beccounter
set var=1
timeout /t 5 /nobreak > nul
set /a "BECCOUNT=%BECCOUNT%+1" > nul && set /a "TIMERSTA=%TIMERSTA%+1" > nul
title %title% - TIMER: %TIMERSTA% / %TIMEREND%
if %BECCOUNT% EQU 10 goto beccheck
goto check
::----------------------------------------------------------------------------------::
::-----bec-onlinecheck & check for hive error---------------------------------------::
::----------------------------------------------------------------------------------::
:beccheck
set "BECCOUNT=1" && set "HIVE_ERROR=" && set "hivevar=" && set "var=1"
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && echo DEBUG: var=%var% ³ beccount=%beccount% ³ (beccheck) && timeout /t 1 /nobreak > nul
::/DEBUG----------------------------------------------------------------------------::
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
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && echo DEBUG: var=%var% ³ (beccheck enabled)
::/DEBUG----------------------------------------------------------------------------::
ver > nul
if %var% GTR %servernum% set precheck=true
if '%precheck%' EQU 'true' set var=1
if '%precheck%' EQU 'true' goto check
if not defined pidbec%var% goto becoff
for /f "tokens=1* delims==" %%i in ('set pidbec%var%') do tasklist /fi "PID eq %%j" | findstr %%j > nul
if %errorlevel% EQU 1 goto becoff
timeout /t 2 /nobreak > nul
set /a var=%var%+1 > nul
goto process_beccheck
::----------------------------------------------------------------------------------::
:becoff
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && echo DEBUG: var=%var% ³ (becoff)
::/DEBUG----------------------------------------------------------------------------::
del %checkfile%%var% /q
echo (!) Bec crashed or has been closed. %checkfile%%var% deleted!
call echo (!) If %%server%var%%% not crashed, Bec will be restarted.
timeout /t 1 /nobreak > nul
if not defined pidserver%var% call echo (!) %%server%var%%% offline, restarting server + Bec && echo\ && goto startserver
for /f "tokens=1* delims==" %%i in ('set pidserver%var%') do tasklist /fi "PID eq %%j" | findstr %%j > nul
if %errorlevel% EQU 1 call echo (!) %%server%var%%% offline, restarting server + Bec && echo\ && goto startserver
call echo (!) %%server%var%%% still online..
echo useless > %checkfile%%var%
call echo (!) Restarting Bec for %%server%var%%% && echo\
call start /min "%becpath%" "%%bec%var%%%" -f %%server%var%beccfg%%
timeout /t 1 /nobreak > nul
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || set "pidbec%var%=%%p")
call echo %date% %time:~0,8%	Bec started with PID: %%pidbec%var%%%
echo\ && echo --------------------------------------------------------------------------------
timeout /t 1 /nobreak > nul
set BECCOUNT=1
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && echo DEBUG: var=%var% ³ beccount=%beccount% ³ (becoff finished)
::/DEBUG----------------------------------------------------------------------------::
goto check
:://////////////////////////////////////////////////////////////////////////////////::
:://///START SERVER FOR VAR=x///////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:startserver
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && call echo DEBUG: var=%var% ³ pidserver=%%pidserver%var%%% ³ pidbec=%%pidbec%var%%% ³ (startserver)
::/DEBUG----------------------------------------------------------------------------::
timeout /t 5 /nobreak > nul
if defined pidserver%var% call echo %date% %time:~0,8%	Kill %%server%var%%% + Bec
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
call echo %date% %time:~0,8%	Starting Bec for %%server%var%%% 
timeout /t 1 /nobreak > nul
for /f "delims=" %%l in ('for /f "skip=3 tokens=2" %%p in ^('call tasklist /fi "imagename eq %%bec%var%%%"'^) do @^<nul set /p "=%%p "') do (set "PIDs=%%l")
cd /d %becpath%
call start /min "%becpath%" "%%bec%var%%%" -f %%server%var%beccfg%%
timeout /t 1 /nobreak > nul
for /f "skip=3 tokens=2" %%p in ('call tasklist /fi "imagename eq %%bec%var%%%"') do (echo %PIDs% | find "%%p" > nul || if not defined pidbec%var% set "pidbec%var%=%%p")
if defined pidbec%var% call echo %date% %time:~0,8%	Bec started with PID: %%pidbec%var%%%
timeout /t 1 /nobreak > nul
echo useless > %checkfile%%var%
echo\ && echo --------------------------------------------------------------------------------
::/LOGGING--------------------------------------------------------------------------::
if defined log if defined logpath%var% for /f "tokens=1* delims==" %%i in ('set logpath%var%') do set "logpathtemp=%%j"
if defined log if defined logpathinfo%var% for /f "tokens=1* delims==" %%i in ('set logpathinfo%var%') do set "logpathinfotemp=%%j"
if defined log (
	if defined green_red if defined logpath%var% (
		call echo green %logpathtemp%
		call echo %date% - %time:~0,8% -  %%server%var%%% started %logpathinfotemp%
	) else (
		if defined %logpath% call echo %date% %time:~0,8%   %%server%var%%% back online %logpath%
	)
)
::/LOGGING--------------------------------------------------------------------------::
if '%choice%' EQU '%var%' goto ui_0
if '%choice%' EQU '%var%x' goto ui_0
if '%hivevar%' EQU 'true' goto beccehck
set BECCOUNT=1
set var=1
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && call echo DEBUG: var=%var% ³ pidserver=%%pidserver%var%%% ³ pidbec=%%pidbec%var%%% ³ (startserver finished)
::/DEBUG----------------------------------------------------------------------------::
goto check
:://////////////////////////////////////////////////////////////////////////////////::
:://///CREATING CONFIG_NEW.INI//////////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:configcreate
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: var=%var% ³ (configcreate)
::/DEBUG----------------------------------------------------------------------------::
%useless_0%
echo %useless_1% Do you wanna create "config_new.ini"? && echo %useless_1% (Y)es / (N)o? && set /P config=
if %config% EQU y goto configcreateY
if %config% EQU Y goto configcreateY
if %config% EQU n goto exitbatch
if %config% EQU N goto exitbatch
if '%config%' EQU '' goto exitbatch
:configcreateY
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: var=%var% ³ (configcreateY)
::/DEBUG----------------------------------------------------------------------------::
%useless_0%
echo %useless_1% Enter the number of server: && set /P numm=
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
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && echo DEBUG: var=%var% ³ (creating config)
::/DEBUG----------------------------------------------------------------------------::
echo server%var%windowtitle=>> config_new.ini
echo server%var%=>> config_new.ini
echo bec%var%=>> config_new.ini
echo server%var%beccfg=>> config_new.ini
echo serverpath%var%=>> config_new.ini
echo serverstart%var%=>> config_new.ini
echo\ >> config_new.ini
if '%numm%' EQU '%var%' goto exitbatch
set /a var=%var%+1 > nul
goto servervar
:exitbatch
cls
::/DEBUG----------------------------------------------------------------------------::
if defined debug echo DEBUG: var=%var% ³ (exitbash)
::/DEBUG----------------------------------------------------------------------------::
%useless_0% && echo %useless_1% config_new.ini created. && echo %useless_1% Closing ARMARE now!
del %appdata%\armare_sleep_50.vbs /q
timeout /t 3 /nobreak > nul
exit
:://////////////////////////////////////////////////////////////////////////////////::
:://///RESTARTING SCRIPT IF AUTO=Y//////////////////////////////////////////////////::
:://////////////////////////////////////////////////////////////////////////////////::
:restartarmare_0
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && echo DEBUG: var=%var% ³ auto=%auto% ³ (restartarmare_0) && timeout /t 1 /nobreak > nul
::/DEBUG----------------------------------------------------------------------------::
if %auto% NEQ Y set TIMERSTA=1
if %auto% NEQ Y goto check
:restartarmare_1
::/DEBUG----------------------------------------------------------------------------::
if defined debug cls && echo DEBUG: var=%var% ³ auto=%auto% ³ (restartarmare_1) && timeout /t 1 /nobreak > nul
::/DEBUG----------------------------------------------------------------------------::
del %appdata%\armare_sleep_50.vbs /q
cd /d %STARTPATH%
start /I "" %BATCHNAME%
taskkill /f /pid %PID% > nul
exit
