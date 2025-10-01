@echo off
setlocal enabledelayedexpansion

:: Clean up any prior bad exit
if exist "exebat.exe" (
    ren "exebat.exe" "exebat.pre")

:: Build a list of exe files
set i=0
for %%f in (*.exe) do (
    set /a i+=1
    set "file[!i!]=%%f"
)
set total=%i%

if %total%==0 (
    echo No .exe files found.
    exit /b 1
)

set idx=1
:nextfile
if %idx% gtr %total% (
    echo No game app confirmed. Exiting.
    exit /b 1
)

set "current=!file[%idx%]!"
echo(
echo File %idx% of %total%: %current%
set /p CONFIRM=Is this the main game app? (Y/N/Q): 

if /I "%CONFIRM%"=="Y" (
    for %%X in ("%current%") do set "BASENAME=%%~nX"
    set "REALFILE=!BASENAME!-real.exe"
    set "NEWFILE=!BASENAME!.exe"

    if exist "!REALFILE!" (
        echo Skipping: "!REALFILE!" already exists.
        exit /b 1
    )

    echo Renaming "%current%" to "!REALFILE!" ...
    ren "%current%" "!REALFILE!"

    if exist "exebat.pre" (
        echo Renaming exebat.pre to "!NEWFILE!" ...
        ren "exebat.pre" "!NEWFILE!"
    ) else (
        echo exebat.pre not found!
    )

    echo Done. Exiting.
    exit /b 0
)

if /I "%CONFIRM%"=="Q" (
    echo Quit requested. Exiting.
    exit /b 0
)

set /a idx+=1
goto :nextfile