# Windows 元数据剥离脚本
# 由 beforeBundleCommand 调用，在 NSIS 打包前剥离 exe 元数据

# 只在设置了 RESHACKER_PATH 时执行（CI 环境）
if (!$env:RESHACKER_PATH) {
    Write-Host "[SKIP] RESHACKER_PATH not set, skipping metadata stripping"
    exit 0
}

# exe 路径（相对于 src-tauri 目录）
$exePath = "target\release\cockpit-tools.exe"

if (!(Test-Path $exePath)) {
    Write-Host "[WARN] Exe not found: $exePath"
    exit 0
}

if (!(Test-Path $env:RESHACKER_PATH)) {
    Write-Host "[ERROR] ResourceHacker not found at: $env:RESHACKER_PATH"
    exit 1
}

Write-Host "[INFO] Stripping metadata from $exePath..."
& $env:RESHACKER_PATH -open $exePath -save $exePath -action delete -mask "VERSIONINFO,,"

if ($LASTEXITCODE -eq 0) {
    Write-Host "[SUCCESS] Exe metadata stripped!"
} else {
    Write-Host "[WARN] ResourceHacker returned code: $LASTEXITCODE"
}
