param(
  [string]$Branch = "main",
  [string]$UpstreamRef = "upstream/main",
  [string]$AuditScript = "E:\AIData\Codex\.codex\skills\merge-upstream-branding\scripts\audit-branding.mjs",
  [switch]$Push,
  [switch]$SkipTypecheck,
  [switch]$SkipReleaseTests,
  [switch]$AllowTrackedChanges
)

$ErrorActionPreference = "Stop"

function Write-Step {
  param([string]$Message)
  Write-Host ""
  Write-Host "==> $Message" -ForegroundColor Cyan
}

function Invoke-Checked {
  param(
    [string]$Command,
    [string[]]$Arguments
  )
  & $Command @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "$Command $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
  }
}

function Get-GitOutput {
  param([string[]]$Arguments)
  $output = & git @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "git $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
  }
  return $output
}

function Get-FirstGitLine {
  param([string[]]$Arguments)
  $output = @(Get-GitOutput $Arguments)
  if ($output.Count -eq 0) {
    return ""
  }
  return [string]$output[0]
}

Write-Step "Checking repository"
$repoRoot = Get-FirstGitLine @("rev-parse", "--show-toplevel")
Set-Location $repoRoot

$currentBranch = Get-FirstGitLine @("branch", "--show-current")
if ($currentBranch -ne $Branch) {
  throw "Current branch is '$currentBranch'. Switch to '$Branch' before syncing."
}

$statusLines = @(Get-GitOutput @("status", "--porcelain"))
$trackedChanges = @($statusLines | Where-Object { $_ -and ($_ -notmatch "^\?\? ") })
$untracked = @($statusLines | Where-Object { $_ -match "^\?\? " })

if ($trackedChanges.Count -gt 0 -and -not $AllowTrackedChanges) {
  Write-Host "Tracked changes found:" -ForegroundColor Yellow
  $trackedChanges | ForEach-Object { Write-Host "  $_" }
  throw "Commit or stash tracked changes first, or pass -AllowTrackedChanges."
}

if ($untracked.Count -gt 0) {
  Write-Host "Untracked files will be left alone:" -ForegroundColor Yellow
  $untracked | ForEach-Object { Write-Host "  $_" }
}

$remoteName = ($UpstreamRef -split "/", 2)[0]
if (-not $remoteName) {
  throw "UpstreamRef must look like 'upstream/main'."
}

Write-Step "Fetching $remoteName"
Invoke-Checked "git" @("fetch", $remoteName)
Invoke-Checked "git" @("rev-parse", "--verify", $UpstreamRef)

Write-Step "Merging $UpstreamRef"
$headBeforeMerge = Get-FirstGitLine @("rev-parse", "HEAD")
& git merge --no-edit $UpstreamRef
if ($LASTEXITCODE -ne 0) {
  Write-Host ""
  Write-Host "Merge stopped with conflicts." -ForegroundColor Yellow
  Write-Host "Ask Codex: use merge-upstream-branding skill to resolve conflicts and preserve suoak branding."
  Write-Host "Useful commands:"
  Write-Host "  git status --short"
  Write-Host "  git diff --name-only --diff-filter=U"
  exit 2
}
$headAfterMerge = Get-FirstGitLine @("rev-parse", "HEAD")
if ($headAfterMerge -eq $headBeforeMerge) {
  Write-Host ""
  Write-Host "Already up to date; skipping branding audit, typecheck, and release tests." -ForegroundColor Green
  exit 0
}

Write-Step "Running branding audit"
if (-not (Test-Path -LiteralPath $AuditScript)) {
  throw "Branding audit script not found: $AuditScript"
}
Invoke-Checked "node" @($AuditScript)

if (-not $SkipTypecheck) {
  Write-Step "Running typecheck"
  Invoke-Checked "npm" @("run", "typecheck")
}

if (-not $SkipReleaseTests) {
  $releaseFilesChanged = @(& git diff --name-only HEAD~1..HEAD -- ".github/workflows/release.yml" "scripts/release" "Casks/cockpit-tools.rb")
  if ($releaseFilesChanged.Count -gt 0) {
    Write-Step "Running release script checks"
    Invoke-Checked "node" @("--check", "scripts/release/publish_github_release_and_cask.cjs")
    Invoke-Checked "node" @("scripts/release/stage_release_assets.test.cjs")
    Invoke-Checked "node" @("scripts/release/build_target_latest_json.test.cjs")
    Invoke-Checked "node" @("scripts/release/verify_published_updater_manifests.test.cjs")
  }
}

Write-Step "Sync summary"
Invoke-Checked "git" @("status", "-sb")

if ($Push) {
  Write-Step "Pushing to origin $Branch"
  Invoke-Checked "git" @("push", "origin", $Branch)
} else {
  Write-Host ""
  Write-Host "Checks passed. Push manually with:" -ForegroundColor Green
  Write-Host "  git push origin $Branch"
  Write-Host ""
  Write-Host "Or rerun with -Push to push automatically."
}
