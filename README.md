# Disable Windows Web & Store Search

A lightweight, clean set of scripts (PowerShell, Batch, and Registry files) to completely disable Bing web search, Microsoft Store suggestions, and cloud highlights in the Windows Start Menu and Taskbar Search.

Restores Windows Search to its fast, focused, and private original purpose: **searching only local files, apps, and settings**.

---

## Features

- 🚫 **Disables Bing Web Search:** Removes internet search results, web previews, and Bing suggestions from the Start Menu.
- 🚫 **Disables Microsoft Store Promotions:** Prevents promoted apps, store suggestions, and suggested downloads in Search and Start.
- 🚫 **Disables Search Highlights & Cloud Search:** Turns off daily Bing trending content, cloud content delivery, and search highlights.
- ⚡ **Faster Search Performance:** Eliminates network latency during search queries.
- 🔒 **Enhanced Privacy:** Stops keystrokes and search queries from being sent to Microsoft Bing servers.
- 🔄 **Reversible:** Includes 1-click restore scripts to re-enable default Windows web search features anytime.

---

## Compatibility

- **Windows 11** (All builds, including 22H2, 23H2, 24H2+)
- **Windows 10** (All builds)
- Windows 10/11 Home, Pro, Enterprise, and Education editions

---

## Project Structure

Organized cleanly by script type:

```
disable-windows-web-search/
├── Batch/
│   ├── Disable-StartMenuWebAndStoreSearch.bat   # 1-click Batch script to disable web/store search
│   └── Enable-StartMenuWebAndStoreSearch.bat    # 1-click Batch script to revert to defaults
├── PowerShell/
│   ├── Disable-StartMenuWebAndStoreSearch.ps1   # PowerShell script with detailed output
│   └── Enable-StartMenuWebAndStoreSearch.ps1    # PowerShell script to revert to defaults
├── Registry/
│   ├── Disable-Web-And-Store-Search.reg         # Standalone .reg file to apply tweaks
│   └── Enable-Web-And-Store-Search.reg          # Standalone .reg file to restore tweaks
├── LICENSE                                      # MIT License
└── README.md                                    # Documentation
```

---

## How to Use

### Option 1: Batch Script (Recommended for Quick Execution)
1. Navigate to the `Batch/` folder.
2. Right-click [`Disable-StartMenuWebAndStoreSearch.bat`](./Batch/Disable-StartMenuWebAndStoreSearch.bat) and select **Run as Administrator** (or double-click; it will automatically request elevation).
3. The script will apply the registry policies and restart the search background processes automatically.

### Option 2: PowerShell Script
1. Open PowerShell as Administrator.
2. Run:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
   .\PowerShell\Disable-StartMenuWebAndStoreSearch.ps1
   ```

### Option 3: Registry File (.reg)
1. Double-click [`Registry/Disable-Web-And-Store-Search.reg`](./Registry/Disable-Web-And-Store-Search.reg).
2. Click **Yes** when prompted by UAC and the Registry Editor.
3. Restart Windows Explorer or sign out and sign back in.

---

## How It Works

The scripts configure official Windows Group Policy and Explorer registry keys:

| Registry Key | Value | Purpose |
| :--- | :--- | :--- |
| `HKCU\Software\Policies\Microsoft\Windows\Explorer\DisableSearchBoxSuggestions` | `1` | Disables search box suggestions in Explorer/Start |
| `HKCU\Software\Policies\Microsoft\Windows\Windows Search\DisableWebSearch` | `1` | Disables Bing web search in Start search |
| `HKCU\Software\Policies\Microsoft\Windows\Windows Search\ConnectedSearchUseWeb` | `0` | Disables connected web search services |
| `HKCU\Software\Policies\Microsoft\Windows\Windows Search\AllowCloudSearch` | `0` | Disables Microsoft account / work cloud search |
| `HKCU\Software\Microsoft\Windows\CurrentVersion\Search\BingSearchEnabled` | `0` | Turns off Bing integration in Windows Search |
| `HKCU\Software\Microsoft\Windows\CurrentVersion\Search\CortanaConsent` | `0` | Disables Cortana web consent |
| `HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings\IsBingSearchEnabled` | `0` | Disables Bing search in newer Windows 11 settings |
| `HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings\IsSearchHighlightsEnabled` | `0` | Removes daily trending images/content in Search |
| `HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent\DisableWindowsConsumerFeatures` | `1` | Disables consumer promotions & Store app recommendations |
| `HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\...` | `0` | Disables subscription & recommendation panes |

---

## How to Revert (Restore Defaults)

If you ever want to restore default Windows web search and Store suggestions:
- Run [`Batch/Enable-StartMenuWebAndStoreSearch.bat`](./Batch/Enable-StartMenuWebAndStoreSearch.bat) as Administrator, or
- Run [`PowerShell/Enable-StartMenuWebAndStoreSearch.ps1`](./PowerShell/Enable-StartMenuWebAndStoreSearch.ps1), or
- Merge [`Registry/Enable-Web-And-Store-Search.reg`](./Registry/Enable-Web-And-Store-Search.reg).

---

## License

This project is licensed under the [MIT License](LICENSE).
