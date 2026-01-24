@echo off
setlocal enabledelayedexpansion

:: Clean up any prior bad exit
if exist "exebat.exe" (
    ren "exebat.exe" "exebat.pre"
)

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
:: Otherwise it's Y

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
