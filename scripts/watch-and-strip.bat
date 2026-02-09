@echo off
REM Watch exe file and auto strip metadata

set "RESHACKER_PATH=E:\resource_hacker\ResourceHacker.exe"
set "TARGET_EXE=src-tauri\target\debug\cockpit-tools.exe"
set "LAST_MODIFIED="

:loop
REM Wait for exe file to exist
if not exist "%TARGET_EXE%" (
    timeout /t 2 /nobreak >nul
    goto loop
)

REM Get current modified time
for %%F in ("%TARGET_EXE%") do set "CURRENT_MODIFIED=%%~tF"

REM Check if changed
if not "%CURRENT_MODIFIED%"=="%LAST_MODIFIED%" (
    echo [INFO] Detected new build, stripping metadata...
    timeout /t 1 /nobreak >nul
    
    REM Try to strip metadata
    "%RESHACKER_PATH%" -open "%TARGET_EXE%" -save "%TARGET_EXE%" -action delete -mask VERSIONINFO,, 2>nul
    
    if %ERRORLEVEL% EQU 0 (
        echo [SUCCESS] Metadata stripped at %TIME%
    )
    
    set "LAST_MODIFIED=%CURRENT_MODIFIED%"
)

timeout /t 3 /nobreak >nul
goto loop
