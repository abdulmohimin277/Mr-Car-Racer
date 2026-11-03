# ============================================================
#  Mr-Racer - Windows desktop shortcut installer
#  Creates a "Mr-Racer" shortcut on the Desktop and Start Menu.
#  The shortcut opens the game in a Chrome/Edge app window.
# ============================================================
param(
  [switch]$NoLaunch
)

$ErrorActionPreference = 'Stop'

$root  = Split-Path -Parent $MyInvocation.MyCommand.Path
$index = Join-Path $root 'index.html'
$icon  = Join-Path $root 'icons\mr-racer.ico'

if (-not (Test-Path $index)) {
  Write-Host 'ERROR: index.html not found next to this installer.' -ForegroundColor Red
  exit 1
}

# ---- find Chrome or Edge ------------------------------------------------
$browsers = @(
  (Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe'),
  (Join-Path ${env:ProgramFiles(x86)} 'Google\Chrome\Application\chrome.exe'),
  (Join-Path $env:LOCALAPPDATA 'Google\Chrome\Application\chrome.exe'),
  (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe'),
  (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe')
)

$browser = $browsers | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1

if ($browser) {
  $target = $browser
  $arguments = '--app="' + ([System.Uri]$index).AbsoluteUri + '" --start-maximized'
  $mode = 'app window'
} else {
  # No Chrome/Edge: open with the default browser instead.
  $target = $index
  $arguments = ''
  $mode = 'default browser'
}

# ---- create shortcuts --------------------------------------------------
$shell = New-Object -ComObject WScript.Shell
$places = @(
  [Environment]::GetFolderPath('Desktop'),
  (Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs')
)

foreach ($place in $places) {
  if (-not (Test-Path $place)) { continue }
  $linkPath = Join-Path $place 'Mr-Racer.lnk'
  $shortcut = $shell.CreateShortcut($linkPath)
  $shortcut.TargetPath       = $target
  $shortcut.Arguments        = $arguments
  $shortcut.WorkingDirectory = $root
  $shortcut.IconLocation     = "$icon,0"
  $shortcut.Description      = 'Mr-Racer - 3D Highway Racer'
  $shortcut.WindowStyle      = 1
  $shortcut.Save()
  Write-Host "Created: $linkPath"
}

Write-Host ''
Write-Host "Mr-Racer shortcut is ready ($mode)." -ForegroundColor Green

if (-not $NoLaunch) {
  Start-Process -FilePath $target -ArgumentList $arguments
}
