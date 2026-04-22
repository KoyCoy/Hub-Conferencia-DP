using System;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Microsoft.Web.WebView2.Core;
using Microsoft.Web.WebView2.WinForms;

namespace HubRH
{
    internal static class Program
    {
        [STAThread]
        private static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }

    internal sealed class MainForm : Form
    {
        private readonly WebView2 browser;

        public MainForm()
        {
            Text = "Check da Folha IA";
            BackColor = Color.FromArgb(15, 23, 42);
            Width = 1280;
            Height = 820;
            MinimumSize = new Size(960, 640);
            StartPosition = FormStartPosition.CenterScreen;
            Icon = LoadAppIcon();

            browser = new WebView2
            {
                Dock = DockStyle.Fill,
                AllowExternalDrop = true,
                DefaultBackgroundColor = Color.FromArgb(15, 23, 42)
            };
            Controls.Add(browser);

            Load += async (sender, args) => await InitializeAsync();
        }

        protected override void OnHandleCreated(EventArgs e)
        {
            base.OnHandleCreated(e);
            EnableDarkTitleBar();
        }

        private static Icon LoadAppIcon()
        {
            string iconPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "check-da-folha-ia.ico");
            if (File.Exists(iconPath))
            {
                return new Icon(iconPath);
            }

            Icon executableIcon = Icon.ExtractAssociatedIcon(Application.ExecutablePath);
            return executableIcon ?? SystemIcons.Application;
        }

        private async System.Threading.Tasks.Task InitializeAsync()
        {
            string baseDir = AppDomain.CurrentDomain.BaseDirectory;
            string appDir = Path.Combine(baseDir, "app");
            string htmlPath = Path.Combine(appDir, "index.html");

            if (!File.Exists(htmlPath))
            {
                MessageBox.Show(
                    "Nao foi possivel encontrar o arquivo index.html na pasta app.",
                    "Check da Folha IA",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error
                );
                Close();
                return;
            }

            string userDataDir = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                "HubRH",
                "DesktopProfile"
            );
            Directory.CreateDirectory(userDataDir);

            CoreWebView2Environment environment = await CoreWebView2Environment.CreateAsync(null, userDataDir);
            await browser.EnsureCoreWebView2Async(environment);

            browser.CoreWebView2.Settings.AreDevToolsEnabled = false;
            browser.CoreWebView2.Settings.AreDefaultContextMenusEnabled = true;
            browser.CoreWebView2.Settings.AreBrowserAcceleratorKeysEnabled = true;
            browser.CoreWebView2.Settings.IsStatusBarEnabled = false;

            browser.CoreWebView2.NewWindowRequested += (sender, args) =>
            {
                args.Handled = true;
                browser.CoreWebView2.Navigate(args.Uri);
            };

            browser.CoreWebView2.Navigate(new Uri(htmlPath).AbsoluteUri);
        }

        private void EnableDarkTitleBar()
        {
            if (Environment.OSVersion.Platform != PlatformID.Win32NT) return;

            int enabled = 1;
            if (DwmSetWindowAttribute(Handle, 20, ref enabled, sizeof(int)) != 0)
            {
                DwmSetWindowAttribute(Handle, 19, ref enabled, sizeof(int));
            }
        }

        [DllImport("dwmapi.dll")]
        private static extern int DwmSetWindowAttribute(IntPtr hwnd, int attr, ref int attrValue, int attrSize);
    }
}
