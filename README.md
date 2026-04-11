# HEROIA Installer

Repositorio publico para distribuir a entrega final do instalador HEROIA aos usuarios.

Este repositorio foi preparado como espelho de distribuicao. Os arquivos finais grandes nao entram no historico Git comum; eles devem ser publicados em `Releases` do GitHub.

## O que fica neste repo

- `README.md`: orientacoes de uso e publicacao
- `publish-release.ps1`: gera checksums e publica os arquivos da pasta como assets de uma release
- `SHA256SUMS.txt`: hashes SHA-256 dos arquivos finais atuais

## Arquivos de entrega atuais

- `HEROIA-Suite-Completa full.exe`
- `HEROIA-Instalador-Manual-Video-FULL.zip`
- `HEROIA-Manual-Ilustrado-FULL.pdf`
- `Instalacao_Extensao_GCrome.MP4` / `Instalação_Extensão_GCrome.MP4`
- `Manual_Usuario.MP4`

## Fluxo recomendado

1. Copie para esta pasta apenas os arquivos finais de distribuicao.
2. Gere ou atualize `SHA256SUMS.txt` com:

```powershell
.\publish-release.ps1 -Version v2026.04.10 -PrepareOnly
```

3. Revise os arquivos e faça o commit da estrutura do repositorio:

```powershell
git add README.md .gitignore publish-release.ps1 SHA256SUMS.txt
git commit -m "chore: prepare public installer mirror"
git push -u origin main
```

4. Autentique o GitHub CLI se necessario:

```powershell
gh auth login
```

5. Publique a release com os binarios:

```powershell
.\publish-release.ps1 -Version v2026.04.10
```

## Observacoes

- Este repo deve conter somente artefatos finais de entrega e metadados publicos.
- Nao inclua codigo-fonte privado, scripts internos ou credenciais.
- Para os usuarios finais, o ponto de download ideal e a aba `Releases`.
