using System;
using System.Drawing;
using System.IO;
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
            Text = "Hub RH";
            Width = 1280;
            Height = 820;
            MinimumSize = new Size(960, 640);
            StartPosition = FormStartPosition.CenterScreen;

            browser = new WebView2
            {
                Dock = DockStyle.Fill,
                AllowExternalDrop = true
            };
            Controls.Add(browser);

            Load += async (sender, args) => await InitializeAsync();
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
                    "Hub RH",
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
    }
}
