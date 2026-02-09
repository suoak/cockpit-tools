@echo off
REM Full build with auto metadata stripping

echo [INFO] Starting Tauri build...
call npm run tauri build

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Build failed!
    exit /b 1
)

echo [INFO] Build complete, stripping metadata...

set "RESHACKER_PATH=E:\resource_hacker\ResourceHacker.exe"
set "TARGET_EXE=src-tauri\target\release\cockpit-tools.exe"

if not exist "%RESHACKER_PATH%" (
    echo [ERROR] Resource Hacker not found: %RESHACKER_PATH%
    exit /b 1
)

if not exist "%TARGET_EXE%" (
    echo [ERROR] Target exe not found: %TARGET_EXE%
    exit /b 1
)

"%RESHACKER_PATH%" -open "%TARGET_EXE%" -save "%TARGET_EXE%" -action delete -mask VERSIONINFO,,

if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] Metadata stripped from %TARGET_EXE%
) else (
    echo [WARNING] Resource Hacker error: %ERRORLEVEL%
)

echo [DONE] Build complete with metadata stripped!
