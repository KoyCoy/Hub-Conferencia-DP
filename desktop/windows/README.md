# Check da Folha IA Desktop Windows

Esta pasta prepara o Check da Folha IA para uso como aplicativo no PC da empresa.

O app continua usando o mesmo `index.html` do projeto, mas abre em uma janela propria do Microsoft Edge, sem barra de endereco e sem precisar localizar o arquivo HTML manualmente.

## Opcao mais indicada na empresa

Se comandos `.cmd` ou PowerShell forem bloqueados, use a versao PWA pelo Microsoft Edge:

1. Abra o link publicado do Check da Folha IA no Edge.
2. Clique em `...`.
3. Va em `Apps`.
4. Clique em `Instalar este site como aplicativo`.

O proprio Edge cria o app no Windows, normalmente sem permissao de administrador.

## Instalar no PC

No PowerShell, execute:

```powershell
powershell -ExecutionPolicy Bypass -File ".\desktop\windows\Instalar-CheckDaFolhaIA.ps1"
```

Ou de dois cliques em:

```text
desktop/windows/Instalar-CheckDaFolhaIA.cmd
```

O instalador cria atalhos:

- `Check da Folha IA` na Area de Trabalho.
- `Check da Folha IA` no Menu Iniciar.

## Abrir sem instalar

```powershell
powershell -ExecutionPolicy Bypass -File ".\desktop\windows\CheckDaFolhaIA-Launcher.ps1"
```

Ou de dois cliques em:

```text
desktop/windows/Abrir-CheckDaFolhaIA.cmd
```

## Observacoes

- Requer Microsoft Edge instalado, que normalmente ja existe no Windows corporativo.
- Os arquivos continuam sendo processados localmente.
- Atualizar o app desktop e simples: substitua/atualize o projeto e abra pelo mesmo atalho.
- O HTML original e a versao web continuam funcionando normalmente.
