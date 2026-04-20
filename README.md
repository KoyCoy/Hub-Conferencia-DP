# Hub RH - Conferencia DP

Aplicacao HTML unica para apoiar rotinas de conferencia do Departamento Pessoal.

## Como usar

Abra o arquivo `hub_rh_v7.html` no navegador. O arquivo `index.html` e uma copia do HTML principal para facilitar publicacao no GitHub Pages.

## Como atualizar no GitHub

Depois de alterar o `hub_rh_v7.html`, publique a nova versao com:

```powershell
.\scripts\publicar.ps1 "Descreva a alteracao"
```

O script atualiza tambem o `index.html`, cria um commit e envia para o GitHub.

## APK interno

O projeto tambem possui uma versao Android interna em `mobile/android`.

O APK atual fica em:

```text
mobile/android/dist/hub-rh-1.0.3.apk
```

Para gerar novamente:

```powershell
.\mobile\android\build-apk.ps1
```

Para atualizar nos celulares da equipe, envie o APK novo e instale por cima. Isso funciona enquanto o app mantiver o mesmo package name, a mesma chave de assinatura e um `versionCode` maior.

## Modulos atuais

- Ocorrencias
- Conferencia de Espelho de Ponto
- Relatorio de Banco de Horas
- Relatorio de Marcacoes
- Conferencia de Folha
- Historico e Excecoes

## Fluxo recomendado

1. Use sempre a versao mais recente do arquivo no repositorio.
2. Salve os JSONs de fechamento em uma pasta compartilhada no OneDrive.
3. Ao iniciar uma nova competencia, carregue os fechamentos anteriores pela aba Historico.
4. Guarde excecoes exportadas pelo proprio hub para manter o historico consistente.

## Observacoes

Os arquivos `hub_rh_v7_backup_*.html` ficam ignorados pelo Git para evitar duplicacao. A partir deste repositorio, o historico de alteracoes passa a ser controlado pelos commits.

## GitHub Pages

O repositorio ja possui um workflow em `.github/workflows/pages.yml` para publicar o `index.html` como site estatico. Para liberar um link web:

1. Abra o repositorio no GitHub.
2. Va em `Settings` > `Pages`.
3. Em `Build and deployment`, selecione `GitHub Actions`.
4. Rode o workflow `Publicar Hub RH` ou faça um novo push na branch `main`.
