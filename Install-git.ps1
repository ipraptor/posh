winget install --id Git.Git -e --source winget --silent --accept-package-agreements --accept-source-agreements
$p = @(
  "$env:ProgramFiles\Git\cmd",
  "$env:ProgramFiles\Git\bin",
  "${env:ProgramFiles(x86)}\Git\cmd",
  "${env:ProgramFiles(x86)}\Git\bin"
) | Where-Object { Test-Path (Join-Path $_ 'git.exe') } | Select-Object -First 1

if (-not $p) { Write-Error "git.exe не найден. Перейди к переустановке ниже."; return }

$env:Path = "$env:Path;$p"
git --version
