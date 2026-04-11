[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Version,

    [string]$Repo = "AugustoSeixasCorretorAvaliador/heroia-installer",

    [string]$ReleaseTitle,

    [string]$Target = "main",

    [switch]$Draft,

    [switch]$Prerelease,

    [switch]$PrepareOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
if (-not $root) {
    $root = (Get-Location).Path
}

$assetExtensions = @(".zip", ".exe", ".pdf", ".mp4")
$assets = Get-ChildItem -LiteralPath $root -File |
    Where-Object { $assetExtensions -contains $_.Extension } |
    Sort-Object Name

if (-not $assets) {
    throw "Nenhum asset final (.zip, .exe, .pdf, .mp4) foi encontrado em $root."
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI (gh) nao encontrado no PATH."
}

$shaFile = Join-Path $root "SHA256SUMS.txt"
$releaseTitleValue = if ($ReleaseTitle) { $ReleaseTitle } else { "HEROIA Installer $Version" }

$hashLines = foreach ($asset in $assets) {
    $hash = (Get-FileHash -LiteralPath $asset.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    "{0} *{1}" -f $hash, $asset.Name
}

Set-Content -LiteralPath $shaFile -Value $hashLines -Encoding UTF8

$notesLines = @(
    "# $releaseTitleValue",
    "",
    "Entrega publica final do instalador HEROIA.",
    "",
    "## Arquivos incluidos"
)

$notesLines += foreach ($asset in $assets) {
    $sizeMb = [math]::Round($asset.Length / 1MB, 2)
    "- {0} ({1} MB)" -f $asset.Name, $sizeMb
}

$notesLines += @(
    "",
    "## Checksums SHA-256",
    ""
)

$notesLines += $hashLines | ForEach-Object { "- $_" }

$notesPath = Join-Path $root ".release-notes.md"
Set-Content -LiteralPath $notesPath -Value $notesLines -Encoding UTF8

$allUploadPaths = @($assets.FullName) + $shaFile

Write-Host ""
Write-Host "Assets encontrados:" -ForegroundColor Cyan
$assets | ForEach-Object {
    $sizeMb = [math]::Round($_.Length / 1MB, 2)
    Write-Host (" - {0} ({1} MB)" -f $_.Name, $sizeMb)
}
Write-Host " - SHA256SUMS.txt" -ForegroundColor Cyan

if ($PrepareOnly) {
    Write-Host ""
    Write-Host "Modo PrepareOnly: release nao publicada." -ForegroundColor Yellow
    Write-Host "SHA256 atualizado em $shaFile" -ForegroundColor Green
    Write-Host "Notas temporarias em $notesPath" -ForegroundColor Green
    return
}

$viewArgs = @("release", "view", $Version, "--repo", $Repo)
$releaseExists = $true
& gh @viewArgs *> $null
if ($LASTEXITCODE -ne 0) {
    $releaseExists = $false
}

if ($releaseExists) {
    $uploadArgs = @("release", "upload", $Version) + $allUploadPaths + @("--repo", $Repo, "--clobber")
    & gh @uploadArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao enviar assets para a release existente $Version."
    }
}
else {
    $createArgs = @(
        "release", "create", $Version
    ) + $allUploadPaths + @(
        "--repo", $Repo,
        "--target", $Target,
        "--title", $releaseTitleValue,
        "--notes-file", $notesPath
    )

    if ($Draft) {
        $createArgs += "--draft"
    }

    if ($Prerelease) {
        $createArgs += "--prerelease"
    }

    & gh @createArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao criar a release $Version."
    }
}

Write-Host ""
Write-Host "SHA256 atualizado em $shaFile" -ForegroundColor Green
Write-Host "Notas temporarias em $notesPath" -ForegroundColor Green
