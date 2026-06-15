[Setup]
AppName=HERO.IA Suite Completa
AppVersion=1.0.4
DefaultDirName=E:\Main HEROIA 2026 UNIF
DefaultGroupName=HERO.IA
UninstallFilesDir={app}\_HEROIA_SYSTEM
UninstallDisplayName=HERO.IA Suite Completa
OutputDir=.
OutputBaseFilename=HEROIA-Suite-Completa
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin

[Files]
Source: "FULL_SERVER.BAT"; DestDir: "{app}"

Source: "heroia-platform\*"; DestDir: "{app}\heroia-platform"; \
Flags: recursesubdirs createallsubdirs; \
Excludes: ".git\*,.gitignore,node_modules\*,*.log,*.tmp,*.iss,*.lnk"

Source: "hero_leads\*"; DestDir: "{app}\hero_leads"; \
Flags: recursesubdirs createallsubdirs; \
Excludes: ".git\*,.gitignore,node_modules\*,*.log,*.tmp,*.iss,*.lnk,backend\server-*.log"

Source: "whatsapp-outreach\*"; DestDir: "{app}\whatsapp-outreach"; \
Flags: recursesubdirs createallsubdirs; \
Excludes: ".git\*,.gitignore,node_modules\*,*.log,*.tmp,*.iss,*.lnk,src\storage\auth\*,src\storage\logs\*,src\storage\campaign-state.json,src\storage\cooldown.json,src\storage\warmup-meta.json,src\storage\warmup-*.json,dist\storage\*"

[Icons]
Name: "{commondesktop}\HERO.IA Suite Completa"; Filename: "{app}\FULL_SERVER.BAT"
Name: "{commondesktop}\HERO.IA Ecossistema"; Filename: "explorer.exe"; Parameters: """{app}\heroia-platform"""
Name: "{commondesktop}\HERO.IA Gerador de Leads"; Filename: "{app}\hero_leads\backend\Prospect.bat"
Name: "{commondesktop}\HERO.IA Disparador"; Filename: "{app}\whatsapp-outreach\DISPARO.BAT"

Name: "{group}\HERO.IA Suite Completa"; Filename: "{app}\FULL_SERVER.BAT"
Name: "{group}\HERO.IA Ecossistema"; Filename: "explorer.exe"; Parameters: """{app}\heroia-platform"""
Name: "{group}\HERO.IA Gerador de Leads"; Filename: "{app}\hero_leads\backend\Prospect.bat"
Name: "{group}\HERO.IA Disparador"; Filename: "{app}\whatsapp-outreach\DISPARO.BAT"
Name: "{group}\Desinstalar HERO.IA Suite"; Filename: "{uninstallexe}"

[Run]
Filename: "msiexec.exe"; \
Parameters: "/i ""{app}\whatsapp-outreach\Instalacao_nvm_node\node-v24.12.0-x64.msi"" /qn"; \
Description: "Instalando Node.js..."; \
Flags: waituntilterminated skipifdoesntexist

Filename: "cmd.exe"; \
Parameters: "/c ""{app}\whatsapp-outreach\Setup_NPM.bat"""; \
Description: "Configurando ambiente do Disparador (npm install)..."; \
Flags: waituntilterminated skipifdoesntexist

Filename: "cmd.exe"; \
Parameters: "/c ""cd /d ""{app}\hero_leads\backend"" && npm ci"""; \
Description: "Configurando ambiente do Gerador de Leads (npm install)..."; \
Flags: waituntilterminated skipifdoesntexist

Filename: "{app}\FULL_SERVER.BAT"; \
Description: "Iniciar HERO.IA Suite Completa"; \
Flags: nowait postinstall skipifsilent unchecked

Filename: "{app}\whatsapp-outreach\DISPARO.BAT"; \
Description: "Iniciar HERO.IA Disparador"; \
Flags: nowait postinstall skipifsilent unchecked

Filename: "{app}\hero_leads\backend\Prospect.bat"; \
Description: "Iniciar HERO.IA Gerador de Leads"; \
Flags: nowait postinstall skipifsilent unchecked

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    MsgBox(
      'INSTALACAO CONCLUIDA - HERO.IA SUITE:'#13#10#13#10 +
      '1. Abra o Chrome ou Edge e acesse chrome://extensions manualmente'#13#10 +
      '2. Ative o "Modo Desenvolvedor"'#13#10 +
      '3. Carregue a pasta ' + ExpandConstant('{app}\heroia-platform') + #13#10 +
      '4. Carregue a pasta ' + ExpandConstant('{app}\hero_leads\hero-leads-extension') + #13#10#13#10 +
      'ATALHOS:'#13#10 +
      '- HERO.IA Suite Completa sobe juntos os servidores 3000 e 3001'#13#10 +
      '- HERO.IA Disparador inicia o servidor local em http://localhost:3000'#13#10 +
      '- HERO.IA Gerador de Leads inicia o backend local e abre o OpenStreetMap'#13#10 +
      '- HERO.IA Ecossistema abre a pasta da extensao principal'#13#10#13#10 +
      'Depois de instalar as extensoes, atualize as abas do WhatsApp Web e da pagina onde usara o Gerador de Leads.',
      mbInformation, MB_OK);
  end;
end;
