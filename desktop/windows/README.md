# Hub RH Desktop Windows

Esta pasta prepara o Hub RH para uso como aplicativo no PC da empresa.

O app continua usando o mesmo `index.html` do projeto, mas abre em uma janela propria do Microsoft Edge, sem barra de endereco e sem precisar localizar o arquivo HTML manualmente.

## Instalar no PC

No PowerShell, execute:

```powershell
powershell -ExecutionPolicy Bypass -File ".\desktop\windows\Instalar-HubRH.ps1"
```

Ou de dois cliques em:

```text
desktop/windows/Instalar-HubRH.cmd
```

O instalador cria atalhos:

- `Hub RH` na Area de Trabalho.
- `Hub RH` no Menu Iniciar.

## Abrir sem instalar

```powershell
powershell -ExecutionPolicy Bypass -File ".\desktop\windows\HubRH-Launcher.ps1"
```

Ou de dois cliques em:

```text
desktop/windows/Abrir-HubRH.cmd
```

## Observacoes

- Requer Microsoft Edge instalado, que normalmente ja existe no Windows corporativo.
- Os arquivos continuam sendo processados localmente.
- Atualizar o app desktop e simples: substitua/atualize o projeto e abra pelo mesmo atalho.
- O HTML original e a versao web continuam funcionando normalmente.
