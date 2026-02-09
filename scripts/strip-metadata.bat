@echo off
REM Strip version info from exe after build
REM Requires Resource Hacker: http://www.angusj.com/resourcehacker/

set "RESHACKER_PATH=E:\resource_hacker\ResourceHacker.exe"
set "TARGET_EXE=target\release\cockpit-tools.exe"

REM Check if Resource Hacker exists
if not exist "%RESHACKER_PATH%" (
    echo [ERROR] Resource Hacker not found at: %RESHACKER_PATH%
    echo Please download from: http://www.angusj.com/resourcehacker/
    exit /b 1
)

REM Check if target exe exists
if not exist "%TARGET_EXE%" (
    echo [ERROR] Target exe not found: %TARGET_EXE%
    exit /b 1
)

echo [INFO] Removing version info from %TARGET_EXE%...

REM Delete version info resource
"%RESHACKER_PATH%" -open "%TARGET_EXE%" -save "%TARGET_EXE%" -action delete -mask VERSIONINFO,,

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Version info removed successfully!
) else (
    echo [WARNING] Resource Hacker returned error code: %ERRORLEVEL%
)

echo Done.
pause
