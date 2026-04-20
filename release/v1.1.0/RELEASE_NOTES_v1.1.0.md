# Hub RH v1.1.0

Primeira release organizada para distribuicao interna do Hub RH.

## Downloads recomendados

- Windows: `HubRH-Windows.zip`
- Android: `hub-rh-1.1.0.apk`
- SharePoint: `HubRH-SharePoint.zip`
- HTML avulso: `hub_rh_v7.html`

## Novidades

- App Windows portatil com `HubRH.exe`.
- Icone proprio no executavel e na janela do app desktop.
- APK Android atualizado para versao `1.1.0`.
- Pacote SharePoint para publicacao interna.
- Manifesto PWA e service worker para navegadores que permitirem instalacao como app.
- Melhorias mobile acumuladas: menu recolhivel, abas recolhiveis, rolagem horizontal de tabelas e suporte a paisagem.

## Como usar no Windows

Baixe `HubRH-Windows.zip`, extraia a pasta completa e abra:

```text
HubRH.exe
```

Nao mova apenas o `.exe` sozinho. Ele precisa ficar junto das DLLs e da pasta `app`.

## Como usar no Android

Baixe `hub-rh-1.1.0.apk` e instale por cima da versao anterior.

## Como usar no SharePoint

Baixe `HubRH-SharePoint.zip`, extraia e envie os arquivos para uma pasta do SharePoint.

Depois, abra `index.html` no navegador ou peça para a TI publicar como conteudo estatico interno.

## Observacoes

- Os arquivos continuam sendo processados localmente.
- O app Windows usa WebView2 Runtime, normalmente ja presente em PCs com Microsoft Edge atualizado.
- Em alguns ambientes corporativos, o Windows pode alertar que o executavel nao esta assinado digitalmente.
