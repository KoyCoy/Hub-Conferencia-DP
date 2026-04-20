# Publicacao no SharePoint

Este e o caminho recomendado para usar o Hub RH nos PCs da empresa sem depender de `.cmd`, PowerShell, GitHub Pages publico ou instalador com permissao de administrador.

## Ideia

Subir os arquivos estaticos do Hub RH em uma pasta do SharePoint e abrir o `index.html` pelo Microsoft Edge.

Depois, cada pessoa instala pelo proprio Edge:

```text
... > Apps > Instalar este site como aplicativo
```

O Windows cria um app `Hub RH` no Menu Iniciar e ele abre em janela propria.

## Arquivos que precisam ir juntos

- `index.html`
- `hub_rh_v7.html`
- `manifest.webmanifest`
- `service-worker.js`
- `assets/icons/hub-rh-192.png`
- `assets/icons/hub-rh-512.png`

## Como publicar

1. Crie uma pasta no SharePoint, por exemplo:

```text
Documentos Compartilhados / Hub RH App
```

2. Envie para essa pasta todo o conteudo do pacote `dist/sharepoint/HubRH-SharePoint.zip`.

3. Abra o arquivo `index.html` pelo Microsoft Edge.

4. No Edge, use:

```text
... > Apps > Instalar este site como aplicativo
```

5. Nome sugerido:

```text
Hub RH
```

## Atualizacao

Quando houver nova versao:

1. Gere um novo pacote SharePoint.
2. Substitua os arquivos da pasta no SharePoint.
3. Peça para os usuarios fecharem e abrirem o app novamente.

## Observacao importante

Algumas configuracoes de SharePoint podem abrir HTML em modo de visualizacao/download, em vez de servir como pagina web. Se isso acontecer, ainda da para usar o arquivo, mas a instalacao como PWA pode nao aparecer.

Nesse caso, peça para a TI publicar a pasta como conteudo estatico em um site interno ou liberar a abertura do `index.html` no navegador.
