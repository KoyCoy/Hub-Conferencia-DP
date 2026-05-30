package br.com.koycoy.hubrh;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.DownloadManager;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.print.PrintAttributes;
import android.print.PrintManager;
import android.provider.MediaStore;
import android.util.Base64;
import android.view.ViewGroup;
import android.webkit.CookieManager;
import android.webkit.DownloadListener;
import android.webkit.JavascriptInterface;
import android.webkit.MimeTypeMap;
import android.webkit.URLUtil;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.Locale;

public class MainActivity extends Activity {
    private static final int FILE_CHOOSER_REQUEST = 4101;
    private WebView webView;
    private ValueCallback<Uri[]> filePathCallback;

    @SuppressLint({"SetJavaScriptEnabled", "AddJavascriptInterface"})
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        webView = new WebView(this);
        setContentView(webView, new ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
        ));

        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setDatabaseEnabled(true);
        settings.setAllowFileAccess(true);
        settings.setAllowContentAccess(true);
        settings.setAllowFileAccessFromFileURLs(true);
        settings.setAllowUniversalAccessFromFileURLs(true);
        settings.setBuiltInZoomControls(false);
        settings.setDisplayZoomControls(false);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            settings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

        CookieManager.getInstance().setAcceptCookie(true);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            CookieManager.getInstance().setAcceptThirdPartyCookies(webView, true);
        }

        webView.addJavascriptInterface(new AndroidBridge(), "AndroidBridge");
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                return false;
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                injectAndroidHelpers();
            }
        });
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public boolean onShowFileChooser(WebView view, ValueCallback<Uri[]> callback, FileChooserParams params) {
                if (filePathCallback != null) {
                    filePathCallback.onReceiveValue(null);
                }
                filePathCallback = callback;
                try {
                    Intent intent = params.createIntent();
                    startActivityForResult(intent, FILE_CHOOSER_REQUEST);
                } catch (Exception ex) {
                    filePathCallback = null;
                    Toast.makeText(MainActivity.this, "Nao foi possivel abrir o seletor de arquivos.", Toast.LENGTH_LONG).show();
                    return false;
                }
                return true;
            }
        });
        webView.setDownloadListener(createDownloadListener());
        webView.loadUrl("file:///android_asset/hub_rh_v7.html");
    }

    private DownloadListener createDownloadListener() {
        return (url, userAgent, contentDisposition, mimeType, contentLength) -> {
            String fileName = URLUtil.guessFileName(url, contentDisposition, mimeType);
            if (url != null && url.startsWith("blob:")) {
                String js = "window.__hubSaveBlob && window.__hubSaveBlob(" + jsQuote(url) + "," + jsQuote(fileName) + ");";
                webView.evaluateJavascript(js, null);
                return;
            }
            try {
                DownloadManager.Request request = new DownloadManager.Request(Uri.parse(url));
                request.setMimeType(mimeType);
                request.addRequestHeader("User-Agent", userAgent);
                request.addRequestHeader("Cookie", CookieManager.getInstance().getCookie(url));
                request.setTitle(fileName);
                request.setDescription("Baixando arquivo do Check da Folha IA");
                request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
                request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, fileName);
                DownloadManager dm = (DownloadManager) getSystemService(DOWNLOAD_SERVICE);
                dm.enqueue(request);
                Toast.makeText(this, "Download iniciado.", Toast.LENGTH_SHORT).show();
            } catch (Exception ex) {
                Toast.makeText(this, "Nao foi possivel baixar o arquivo.", Toast.LENGTH_LONG).show();
            }
        };
    }

    private void injectAndroidHelpers() {
        String js =
                "(function(){"
                        + "if(window.__hubAndroidReady)return;window.__hubAndroidReady=true;"
                        + "window.print=function(){AndroidBridge.printPage();};"
                        + "window.__hubSaveBlob=function(url,name){"
                        + "fetch(url).then(function(r){return r.blob();}).then(function(blob){"
                        + "var reader=new FileReader();"
                        + "reader.onloadend=function(){AndroidBridge.saveBase64(reader.result,blob.type||'application/octet-stream',name||'arquivo');};"
                        + "reader.readAsDataURL(blob);"
                        + "}).catch(function(){AndroidBridge.toast('Nao foi possivel salvar o arquivo.');});"
                        + "};"
                        + "document.addEventListener('click',function(e){"
                        + "var t=e.target;if(!t||!t.closest)return;"
                        + "var a=t.closest('a[download]');"
                        + "if(a&&a.href&&a.href.indexOf('blob:')===0){e.preventDefault();window.__hubSaveBlob(a.href,a.download||'arquivo');}"
                        + "},true);"
                        + "})();";
        webView.evaluateJavascript(js, null);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == FILE_CHOOSER_REQUEST && filePathCallback != null) {
            Uri[] result = WebChromeClient.FileChooserParams.parseResult(resultCode, data);
            filePathCallback.onReceiveValue(result);
            filePathCallback = null;
        }
    }

    @Override
    public void onBackPressed() {
        if (webView != null && webView.canGoBack()) {
            webView.goBack();
            return;
        }
        super.onBackPressed();
    }

    private String jsQuote(String value) {
        if (value == null) return "''";
        return "'" + value.replace("\\", "\\\\").replace("'", "\\'").replace("\n", "\\n") + "'";
    }

    public class AndroidBridge {
        @JavascriptInterface
        public void toast(String message) {
            runOnUiThread(() -> Toast.makeText(MainActivity.this, message, Toast.LENGTH_LONG).show());
        }

        @JavascriptInterface
        public void printPage() {
            runOnUiThread(() -> {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.KITKAT) {
                    Toast.makeText(MainActivity.this, "Impressao indisponivel nesta versao do Android.", Toast.LENGTH_LONG).show();
                    return;
                }
                PrintManager printManager = (PrintManager) getSystemService(Context.PRINT_SERVICE);
                PrintAttributes attributes = new PrintAttributes.Builder()
                        .setMediaSize(PrintAttributes.MediaSize.ISO_A4)
                        .setColorMode(PrintAttributes.COLOR_MODE_COLOR)
                        .build();
                printManager.print("Check da Folha IA", webView.createPrintDocumentAdapter("Check da Folha IA"), attributes);
            });
        }

        @JavascriptInterface
        public void saveBase64(String dataUrl, String mimeType, String fileName) {
            try {
                String safeName = sanitizeFileName(fileName);
                String mime = (mimeType == null || mimeType.trim().isEmpty()) ? guessMime(safeName) : mimeType;
                String base64 = dataUrl;
                int comma = dataUrl == null ? -1 : dataUrl.indexOf(',');
                if (comma >= 0) base64 = dataUrl.substring(comma + 1);
                byte[] bytes = Base64.decode(base64, Base64.DEFAULT);
                saveToDownloads(safeName, mime, bytes);
                runOnUiThread(() -> Toast.makeText(MainActivity.this, "Arquivo salvo em Downloads.", Toast.LENGTH_LONG).show());
            } catch (Exception ex) {
                runOnUiThread(() -> Toast.makeText(MainActivity.this, "Nao foi possivel salvar o arquivo.", Toast.LENGTH_LONG).show());
            }
        }
    }

    private String sanitizeFileName(String fileName) {
        String name = (fileName == null || fileName.trim().isEmpty()) ? "hub-rh-arquivo" : fileName.trim();
        name = name.replaceAll("[\\\\/:*?\"<>|]", "_");
        return name;
    }

    private String guessMime(String fileName) {
        String ext = MimeTypeMap.getFileExtensionFromUrl(fileName.toLowerCase(Locale.ROOT));
        String mime = MimeTypeMap.getSingleton().getMimeTypeFromExtension(ext);
        return mime == null ? "application/octet-stream" : mime;
    }

    private void saveToDownloads(String fileName, String mimeType, byte[] bytes) throws Exception {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ContentResolver resolver = getContentResolver();
            ContentValues values = new ContentValues();
            values.put(MediaStore.Downloads.DISPLAY_NAME, fileName);
            values.put(MediaStore.Downloads.MIME_TYPE, mimeType);
            values.put(MediaStore.Downloads.IS_PENDING, 1);
            Uri uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values);
            if (uri == null) throw new IllegalStateException("Falha ao criar arquivo.");
            try (OutputStream out = resolver.openOutputStream(uri)) {
                if (out == null) throw new IllegalStateException("Falha ao abrir arquivo.");
                out.write(bytes);
            }
            values.clear();
            values.put(MediaStore.Downloads.IS_PENDING, 0);
            resolver.update(uri, values, null, null);
            return;
        }

        File dir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
        if (!dir.exists()) dir.mkdirs();
        File outFile = new File(dir, fileName);
        try (FileOutputStream out = new FileOutputStream(outFile)) {
            out.write(bytes);
        }
    }
}
