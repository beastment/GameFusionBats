@echo off
setlocal enabledelayedexpansion

:: Look for a file ending in -real.exe
set "REALFILE="
for %%f in (*-real.exe) do (
    set "REALFILE=%%f"
    goto :found
)

echo No -real.exe file found. Exiting.
exit /b 1

:found
:: Strip the -real part to get the base name
for %%X in ("%REALFILE%") do set "BASENAME=%%~nX"
set "BASENAME=!BASENAME:-real=!"
set "ORIGFILE=!BASENAME!.exe"

echo Detected real file: %REALFILE%
echo Base game name: %ORIGFILE%

:: Rename so the wrapper takes its place
rename "%ORIGFILE%" exebat.exe
rename "%REALFILE%" "%ORIGFILE%"

:: Launch AntiMicroX and wait
start "" "D:\antimicrox-3.5.1-PortableWindows-AMD64\bin\antimicrox.exe"

:: Short delay to ensurer antimicrox to starts first
ping -n 3 127.0.0.1>NUL

:: Run the game and wait until it exits
start /WAIT /MAX "" "%ORIGFILE%"

:: Restore original naming
rename "%ORIGFILE%" "%REALFILE%"
rename exebat.exe "%ORIGFILE%"

taskkill /F /IM antimicrox.exe

exit