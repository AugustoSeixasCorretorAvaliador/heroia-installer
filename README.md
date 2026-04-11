# HEROIA Installer

Entrega publica final do instalador HEROIA.

[Baixar a versao mais recente](https://github.com/AugustoSeixasCorretorAvaliador/heroia-installer/releases/latest)

## Download

Os arquivos de instalacao e apoio ficam na aba `Releases` deste repositorio.

Arquivos normalmente incluidos em cada entrega:

- `HEROIA-Suite-Completa full.exe`
- `HEROIA-Instalador-Manual-Video-FULL.zip`
- `HEROIA-Manual-Ilustrado-FULL.pdf`
- `Instalacao_Extensao_GCrome.MP4`
- `Manual_Usuario.MP4`
- `SHA256SUMS.txt`

## Instalacao Rapida

1. Abra a pagina de `Releases`.
2. Baixe o arquivo principal `HEROIA-Suite-Completa full.exe`.
3. Se necessario, baixe tambem o manual em PDF e os videos de apoio.
4. Execute o instalador como administrador no Windows.
5. Siga o passo a passo exibido na instalacao.

## Verificacao de Integridade

Este repositorio publica o arquivo `SHA256SUMS.txt` junto com cada release.

Para conferir o hash no Windows PowerShell:

```powershell
Get-FileHash ".\HEROIA-Suite-Completa full.exe" -Algorithm SHA256
```

Compare o valor retornado com a linha correspondente dentro de `SHA256SUMS.txt`.

## Conteudo da Entrega

- Instalador principal para uso final.
- Pacote completo compactado para distribuicao.
- Manual ilustrado em PDF.
- Videos de apoio para instalacao e uso.

## Suporte de Uso

Se voce recebeu este material como cliente ou usuario final, utilize sempre a release mais recente publicada neste repositorio.

Se houver duvida durante a instalacao, use primeiro:

- o manual ilustrado em PDF
- o video de instalacao
- o video do manual do usuario

## Para o Mantenedor

Este repositorio funciona como espelho publico de distribuicao. Os binarios finais devem ser publicados em `Releases`, nao no historico Git.

Fluxo recomendado para novas entregas:

```powershell
powershell -ExecutionPolicy Bypass -File ".\publish-release.ps1" -Version "v2026.04.10"
```

Antes de publicar, voce pode preparar e revisar checksums/notas com:

```powershell
powershell -ExecutionPolicy Bypass -File ".\publish-release.ps1" -Version "v2026.04.10" -PrepareOnly
```
