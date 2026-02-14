@echo off
setlocal EnableExtensions DisableDelayedExpansion

REM -----------------------------
REM STEP 0: marker override
REM -----------------------------
set "MARKERCOUNT=0"
set "MARKERBASE="

REM Enumerate markers without using a (...) block
for %%m in (*.gfbats) do if exist "%%m" call :count_marker "%%~nm"

if %MARKERCOUNT%==1 goto usemarker
if %MARKERCOUNT% GTR 1 goto multimarker
goto nomarker

:usemarker
set "current=%MARKERBASE%.exe"
echo Found marker: "%MARKERBASE%.gfbats"
echo Using exe from marker: "%current%"
goto confirmed

:multimarker
echo.
echo Multiple .gfbats marker files found. Falling back to EXE search:
for %%m in (*.gfbats) do if exist "%%m" echo   - %%~nxm
echo.
goto nomarker

:nomarker

REM -----------------------------
REM Clean up any prior bad exit
REM -----------------------------
if exist "exebat.exe" ren "exebat.exe" "exebat.pre"
if exist "*-real.exe" ren "*-real.exe" "*.exe"

REM -----------------------------
REM Build list of eligible EXEs
REM -----------------------------
set "count=0"

if not exist "*.exe" goto noexes
for %%f in (*.exe) do if exist "%%f" call :maybe_add_exe "%%~nxf"

if %count%==0 goto noeligible
if %count%==1 goto oneexe
goto chooseexe

:noexes
echo No .exe files found.
exit /b 1

:noeligible
echo No eligible .exe files found.
exit /b 1

:oneexe
call set "current=%%exe1%%"
echo.
echo Only one eligible .exe found: %current%
goto confirmed

:chooseexe
set "idx=1"

:nextfile
if %idx% GTR %count% goto noconfirm

call set "current=%%exe%idx%%%"
echo.
echo File %idx% of %count%: %current%

REM (If you want to skip prompting in Proton, just uncomment the next line)
REM goto confirmed

choice /c YNQ /n /m "Is this the main game app? (Y/N/Q): "
if errorlevel 3 goto quit
if errorlevel 2 goto notthis
goto confirmed

:notthis
set /a idx+=1
goto nextfile

:noconfirm
echo No game app confirmed. Exiting.
exit /b 1

:quit
echo Quit requested. Exiting.
exit /b 0


:confirmed
for %%X in ("%current%") do set "BASENAME=%%~nX"
set "REALFILE=%BASENAME%-real.exe"
set "NEWFILE=%BASENAME%.exe"

REM Create marker file (overwrites)
set "MARKER=%BASENAME%.gfbats"
break > "%MARKER%"

if exist "%REALFILE%" goto realexists

echo Renaming "%current%" to "%REALFILE%" ...
ren "%current%" "%REALFILE%"

if exist "exebat.pre" goto renamepre
echo exebat.pre not found!
goto done

:renamepre
echo Renaming exebat.pre to "%NEWFILE%" ...
ren "exebat.pre" "%NEWFILE%"
goto done

:realexists
echo Skipping: "%REALFILE%" already exists.
exit /b 1

:done
echo Done. Exiting.
exit /b 0


:count_marker
set /a MARKERCOUNT+=1
set "MARKERBASE=%~1"
exit /b


:maybe_add_exe
set "F=%~1"

if /I "%F%"=="exebat.exe" exit /b
if /I "%F%"=="exebat.pre" exit /b
if /I "%F%"=="UnityCrashHandler64.exe" exit /b
if /I "%F%"=="UnityCrashHandler32.exe" exit /b

set /a count+=1
call set "exe%%count%%=%F%"
exit /b


