# App desktop nativo

Esta pasta contem a base do app desktop Windows usando WebView2.

## Gerar EXE portatil

Na raiz do projeto, execute:

```powershell
.\scripts\build-desktop-exe.ps1
```

Saidas:

```text
dist/desktop/HubRH-Windows/HubRH.exe
dist/desktop/HubRH-Windows.zip
```

O ZIP pode ser distribuido internamente. A pessoa extrai a pasta e abre `HubRH.exe`.

## Requisitos no PC

- Windows 10/11.
- Microsoft Edge WebView2 Runtime instalado. Normalmente ja vem com Windows/Edge atualizado.

## Instalador real

Este build gera um EXE portatil. Para virar instalador `.msi` ou setup `.exe`, ainda precisamos de uma ferramenta de empacotamento:

- WiX Toolset, Advanced Installer, Inno Setup ou Visual Studio Installer Projects.
- Certificado de assinatura, se a politica da empresa exigir.

O HTML atual e reaproveitado dentro da pasta `app`, sem reescrever a regra de negocio.
