@echo off
setlocal enabledelayedexpansion

:: =========================================================
:: STEP 0: If a *.gfbats marker exists, use it to choose exe
:: e.g. Timberborn.gfbats -> Timberborn.exe
:: =========================================================
set "MARKERCOUNT=0"
set "MARKERBASE="

:: Clean up any prior bad exit
if exist "exebat.exe" (
    ren "exebat.exe" "exebat.pre"
)

for %%m in (*.gfbats) do (
    set /a MARKERCOUNT+=1
    set "MARKERBASE=%%~nm"
)

if %MARKERCOUNT%==1 (
    set "current=%MARKERBASE%.exe"
    echo Found marker: "%MARKERBASE%.gfbats"
    echo Using exe from marker: "%current%"
    goto :confirmed
) else if %MARKERCOUNT% gtr 1 (
    echo(
    echo Multiple .gfbats marker files found. Falling back to EXE search:
    for %%m in (*.gfbats) do echo   - %%~nxm
    echo(
)

:: Build a list of eligible exe files (end with .exe, excluding known non-targets)
set i=0
for %%f in (*.exe) do (
    if /I not "%%~nxf"=="exebat.exe" (
    if /I not "%%~nxf"=="exebat.pre" (
    if /I not "%%~nxf"=="UnityCrashHandler64.exe" (
    if /I not "%%~nxf"=="UnityCrashHandler32.exe" (
        set /a i+=1
        set "file[!i!]=%%~nxf"
    ))))
)
set total=%i%

if %total%==0 (
    echo No eligible .exe files found.
    exit /b 1
)

:: If there's only one eligible EXE, skip prompt and use it
if %total%==1 (
    set "current=!file[1]!"
    echo(
    echo Only one eligible .exe found: !current!
    goto :confirmed
)

set idx=1
:nextfile
if %idx% gtr %total% (
    echo No game app confirmed. Exiting.
    exit /b 1
)

set "current=!file[%idx%]!"
echo(
echo File %idx% of %total%: !current!

:: Single-key prompt (no Enter)
choice /c YNQ /n /m "Is this the main game app? (Y/N/Q): "

:: CHOICE sets ERRORLEVEL:
:: 1=Y, 2=N, 3=Q
if errorlevel 3 (
    echo Quit requested. Exiting.
    exit /b 0
)
if errorlevel 2 (
    set /a idx+=1
    goto :nextfile
)

:confirmed
for %%X in ("!current!") do set "BASENAME=%%~nX"
set "REALFILE=!BASENAME!-real.exe"
set "NEWFILE=!BASENAME!.exe"

:: Create marker file: e.g. timberborn.gfbats (empty; overwrites if exists)
set "MARKER=!BASENAME!.gfbats"
break > "!MARKER!"

if exist "!REALFILE!" (
    echo Skipping: "!REALFILE!" already exists.
    exit /b 1
)

echo Renaming "!current!" to "!REALFILE!" ...
ren "!current!" "!REALFILE!"

if exist "exebat.pre" (
    echo Renaming exebat.pre to "!NEWFILE!" ...
    ren "exebat.pre" "!NEWFILE!"
) else (
    echo exebat.pre not found!
)

echo Done. Exiting.
exit /b 0
