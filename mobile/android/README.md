# APK interno do Hub RH

Este app Android empacota o `hub_rh_v7.html` em uma WebView.

## Gerar APK

Na pasta raiz do projeto, execute:

```powershell
.\mobile\android\build-apk.ps1
```

O APK gerado fica em:

```text
mobile/android/dist/hub-rh-1.0.4.apk
```

## Instalar na equipe

1. Envie o APK para o celular, por OneDrive, WhatsApp, e-mail ou cabo USB.
2. Toque no arquivo `hub-rh-1.0.4.apk`.
3. Se o Android pedir permissao, permita instalar apps desta fonte.
4. Abra o app `Hub RH`.

## Atualizacoes

Para instalar uma versao nova por cima da antiga:

- mantenha o package name `br.com.koycoy.hubrh`;
- use a mesma chave `.jks`;
- aumente o `versionCode` no script de build.

Na pratica, depois da primeira instalacao, a equipe baixa o APK novo e instala por cima. Nao precisa desinstalar.

## Observacao

Esta primeira versao usa internet para carregar bibliotecas externas usadas pelo HTML, como `xlsx`, `mammoth` e `lucide`.
