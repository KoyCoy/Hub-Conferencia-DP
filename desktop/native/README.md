# App desktop instalavel nativo

Este e o proximo nivel depois do SharePoint/PWA.

## Recomendacao tecnica

Para um app Windows realmente instalavel, o caminho mais adequado e:

- WebView2 para embutir o Hub RH em uma janela nativa.
- Instalador `.msi` ou `.exe`.
- Assinatura digital se a empresa exigir.

## Por que ainda nao foi gerado aqui

Nesta maquina, no momento, nao estao instalados os componentes necessarios para gerar um instalador nativo:

- .NET SDK ou Visual Studio Build Tools.
- Ferramenta de empacotamento MSI/EXE, como WiX Toolset ou Inno Setup.
- Certificado de assinatura, se a politica da empresa exigir.

## Caminho pratico

1. Usar o SharePoint/PWA como solucao oficial inicial.
2. Validar com a equipe se a instalacao pelo Edge funciona.
3. Se a empresa exigir `.exe` ou `.msi`, preparar o ambiente de build.

## Ambiente necessario para gerar o instalador

Uma das opcoes:

- Visual Studio 2022 Build Tools com .NET Desktop Build Tools.
- .NET SDK 8 ou superior.
- WebView2 Runtime, normalmente ja instalado no Windows 10/11 com Edge.
- WiX Toolset ou Inno Setup para gerar instalador.

Depois disso, o HTML atual pode ser reaproveitado sem reescrever a regra de negocio.
