@echo off

if exist "GH-Default Profile.amgp" (
    copy /Y "GH-Default Profile.amgp" "C:\GH-Default Profile.amgp" >NUL
)
if exist "setup.bat" (
    copy /Y "setup.bat" "X:\setup.bat" >NUL
)
if exist "exebat.pre" (
    copy /Y "setup.bat" "X:\exebat.pre" >NUL
)
if exist "helper.bat" (
    copy /Y "helper.bat" "X:\helper.bat" >NUL
)

cd X:\
setup.bat