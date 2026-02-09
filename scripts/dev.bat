@echo off
REM Tauri dev mode launcher with metadata stripping

set "RESHACKER_PATH=E:\resource_hacker\ResourceHacker.exe"
set "TARGET_EXE=src-tauri\target\debug\cockpit-tools.exe"

echo [INFO] Starting Tauri dev mode with metadata stripping...
echo [INFO] Resource Hacker: %RESHACKER_PATH%

REM Start metadata watcher in background
start /B cmd /c "scripts\watch-and-strip.bat"

REM Start Tauri dev mode
npm run tauri dev
