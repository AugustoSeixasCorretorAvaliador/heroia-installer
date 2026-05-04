# HEROIA Installer

Entrega publica final do instalador HEROIA.

Versao atual: `04.05.26`

[Baixar a versao 04.05.26](https://github.com/AugustoSeixasCorretorAvaliador/heroia-installer/releases/tag/04.05.26)

## Download

Os arquivos de instalacao e apoio ficam na aba `Releases` deste repositorio.

Arquivos normalmente incluidos em cada entrega:

- `HEROIA-Suite-Completa-full.exe`
- `HEROIA-Manual-Ilustrado-FULL.pdf`
- `SHA256SUMS.txt`

## Videos Online

- Manual de uso do HERO.IA: `https://youtu.be/InutfvU54dM?si=70TSBiKbNljsQ46G`
- Instalacao das 2 extensoes no Google Chrome: `https://youtu.be/rTsrga_pEyg?si=7qE7x2SoM2HVkW1j`

## Instalacao Rapida

1. Abra a pagina da release `04.05.26`.
2. Baixe o arquivo principal `HEROIA-Suite-Completa-full.exe`.
3. Se necessario, baixe tambem o manual em PDF.
4. Execute o instalador como administrador no Windows.
5. Siga o passo a passo exibido na instalacao.
6. Se preferir, assista aos videos no YouTube antes de instalar.

## Verificacao de Integridade

Este repositorio publica o arquivo `SHA256SUMS.txt` junto com cada release.

Para conferir o hash no Windows PowerShell:

```powershell
Get-FileHash ".\HEROIA-Suite-Completa-full.exe" -Algorithm SHA256
```

Compare o valor retornado com a linha correspondente dentro de `SHA256SUMS.txt`.

## Conteudo da Entrega

- Instalador principal para uso final.
- Manual ilustrado em PDF.
- Videos de apoio publicados no YouTube.

## Suporte de Uso

Se voce recebeu este material como cliente ou usuario final, utilize sempre a release `04.05.26` ou uma release posterior publicada neste repositorio.

Se houver duvida durante a instalacao, use primeiro:

- o manual ilustrado em PDF
- o video de instalacao
- o video do manual do usuario

## Para o Mantenedor

Este repositorio funciona como espelho publico de distribuicao. Os binarios finais devem ser publicados em `Releases`, nao no historico Git.

Fluxo recomendado para novas entregas:

```powershell
powershell -ExecutionPolicy Bypass -File ".\publish-release.ps1" -Version "04.05.26"
```

Antes de publicar, voce pode preparar e revisar checksums/notas com:

```powershell
powershell -ExecutionPolicy Bypass -File ".\publish-release.ps1" -Version "04.05.26" -PrepareOnly
```
