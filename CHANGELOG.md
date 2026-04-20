# Changelog

## Desktop EXE - 2026-04-20

- Adiciona app Windows portatil `HubRH.exe` com WebView2.
- Adiciona script `scripts/build-desktop-exe.ps1` para gerar `dist/desktop/HubRH-Windows.zip`.
- Atualiza guias do SharePoint/PWA para incluir Google Chrome.

## SharePoint - 2026-04-20

- Adiciona pacote de publicacao para SharePoint.
- Adiciona guia de instalacao pelo Edge sem `.cmd` ou PowerShell.
- Adiciona script local para gerar `dist/sharepoint/HubRH-SharePoint.zip`.
- Documenta caminho futuro para app desktop nativo instalavel.

## PWA Desktop - 2026-04-20

- Adiciona manifesto PWA para instalar o Hub RH pelo Microsoft Edge/Chrome.
- Adiciona service worker para cache basico da aplicacao publicada.
- Adiciona icones PNG do Hub RH para instalacao como app.
- Documenta fluxo sem `.cmd` para ambientes corporativos.

## Desktop Windows - 2026-04-20

- Adiciona launcher do Hub RH para abrir como aplicativo no Microsoft Edge.
- Adiciona instalador de atalhos para Area de Trabalho e Menu Iniciar.
- Adiciona comandos `.cmd` para facilitar instalacao e abertura sem digitar PowerShell.

## 1.0.6 - 2026-04-20

- Libera rotacao do APK para usar em modo paisagem.
- Corrige crescimento infinito da rolagem vertical no mobile.
- Amplia o layout mobile para telas de celular em paisagem.

## 1.0.5 - 2026-04-20

- Corrige corte lateral de tabelas/listas no APK mobile.
- Tabelas largas passam a ter rolagem horizontal propria no celular.
- Reforca wrappers dinamicos para tabelas geradas depois da analise.

## 1.0.4 - 2026-04-20

- Corrige corte de listas e relatorios no APK mobile.
- Iframes passam a crescer conforme o conteudo no celular, usando rolagem da pagina inteira.
- Mantem menu e abas recolhiveis sem prender resultados grandes dentro de uma area fixa.

## 1.0.3 - 2026-04-20

- Menu principal mobile recolhivel para liberar espaco vertical.
- Abas internas dos modulos recolhiveis no celular.
- APK travado em modo retrato para evitar quebra ao virar o aparelho.
- Mais respiro inferior no conteudo mobile para evitar lista cortada perto do rodape.

## 1.0.2 - 2026-04-20

- Menu principal mobile em grade visivel, sem depender de arrastar lateralmente.
- Sub-abas mobile em quebra de linha para revelar todas as funcionalidades.
- Rodape mobile compacto para evitar corte na barra inferior do Android.

## 1.0.1 - 2026-04-20

- Ajuste responsivo para APK/celular: menu no topo, conteudo em largura total e modulos adaptados a telas pequenas.

## 1.0.0 - 2026-04-19

- Padronizacao visual dos modulos.
- Ajustes de tema claro/escuro.
- PDFs gerados com fundo branco.
- Estado independente nas sub-abas do Espelho de Ponto.
- Correcoes no Historico para ler regras com chaves `3`, `4`, `5` e `R3`, `R4`, `R5`.
- Persistencia do campo "Executado por" no navegador.
- Indicador de versao no rodape.
- Modal inicial com orientacao de fluxo de equipe.
- Clique na caixa inteira para selecionar arquivos, sem abertura duplicada do seletor.
- Organizacao inicial do projeto no GitHub.
- Script local de publicacao e workflow preparado para GitHub Pages.
- Primeira versao de APK interno Android com WebView, selecao de arquivos, downloads e impressao/PDF via sistema Android.
