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
$youtubeManualUrl = "https://youtu.be/InutfvU54dM?si=70TSBiKbNljsQ46G"
$youtubeInstallUrl = "https://youtu.be/rTsrga_pEyg?si=7qE7x2SoM2HVkW1j"
$mainInstaller = $assets | Where-Object { $_.Name -like "*.exe" } | Select-Object -First 1
$pdfManual = $assets | Where-Object { $_.Extension -eq ".pdf" } | Select-Object -First 1
$videoFiles = @($assets | Where-Object { $_.Extension -eq ".mp4" })
$zipPackage = $assets | Where-Object { $_.Extension -eq ".zip" } | Select-Object -First 1

$hashLines = foreach ($asset in $assets) {
    $hash = (Get-FileHash -LiteralPath $asset.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    "{0} *{1}" -f $hash, $asset.Name
}

Set-Content -LiteralPath $shaFile -Value $hashLines -Encoding UTF8

$notesLines = @(
    "# $releaseTitleValue",
    "",
    "Entrega publica do instalador HEROIA para distribuicao aos usuarios finais.",
    "",
    "## Como baixar",
    "",
    "1. Baixe o instalador principal listado abaixo.",
    "2. Se necessario, baixe tambem o manual em PDF e os videos de apoio.",
    "3. Execute a instalacao no Windows com permissao de administrador.",
    "4. Se preferir, assista aos videos online listados abaixo.",
    ""
)

if ($mainInstaller) {
    $notesLines += "## Arquivo principal recomendado"
    $notesLines += ""
    $notesLines += ("- {0}" -f $mainInstaller.Name)
    $notesLines += ""
}

$notesLines += @(
    "## Conteudo desta entrega",
    "",
    "- Instalador principal do HEROIA",
    "- Materiais de apoio para instalacao e uso",
    "- Arquivo `SHA256SUMS.txt` para verificacao de integridade",
    "- Links diretos para videos no YouTube",
    "",
    "## Arquivos incluidos"
)

$notesLines += foreach ($asset in $assets) {
    $sizeMb = [math]::Round($asset.Length / 1MB, 2)
    "- {0} ({1} MB)" -f $asset.Name, $sizeMb
}

$notesLines += @(
    "",
    "## Videos Online",
    "",
    "- Manual de uso do HERO.IA: $youtubeManualUrl",
    "- Instalacao das 2 extensoes no Google Chrome: $youtubeInstallUrl",
    "",
    "## Orientacoes de uso",
    ""
)

if ($mainInstaller) {
    $notesLines += "- Instale usando `"$($mainInstaller.Name)`"."
}

if ($pdfManual) {
    $notesLines += "- Consulte `"$($pdfManual.Name)`" para orientacoes ilustradas."
}

if ($videoFiles.Count -gt 0) {
    $notesLines += "- Utilize os videos incluidos ou os links do YouTube para apoio visual durante a instalacao e o uso."
}

if ($zipPackage) {
    $notesLines += "- O pacote compactado `"$($zipPackage.Name)`" pode ser usado como copia completa da entrega."
}

$notesLines += @(
    "",
    "## Checksums SHA-256",
    "",
    "Compare os hashes abaixo com os arquivos baixados para validar a integridade da entrega.",
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

$releaseExists = $false
$listArgs = @("release", "list", "--repo", $Repo, "--limit", "100", "--json", "tagName")
$releaseListJson = & gh @listArgs
if ($LASTEXITCODE -ne 0) {
    throw "Falha ao consultar as releases do repositorio $Repo."
}

if ($releaseListJson) {
    $releaseList = $releaseListJson | ConvertFrom-Json
    if ($releaseList) {
        $releaseExists = @($releaseList | Where-Object { $_.tagName -eq $Version }).Count -gt 0
    }
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
