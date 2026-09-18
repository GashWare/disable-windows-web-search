<#
.SYNOPSIS
    Reverts and re-enables Internet (Bing) and Microsoft Store search in Windows Start Menu.
.DESCRIPTION
    Removes policy restrictions and resets search settings to Windows default values.
#>

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[*] Requesting Administrator privileges to revert system policies..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Restoring Start Menu Web (Bing) & Store Search Defaults" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$regRemovals = @(
    @{ Path = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"; Name = "DisableSearchBoxSuggestions" },
    @{ Path = "HKCU:\Software\Policies\Microsoft\Windows\Windows Search"; Name = "DisableWebSearch" },
    @{ Path = "HKCU:\Software\Policies\Microsoft\Windows\Windows Search"; Name = "ConnectedSearchUseWeb" },
    @{ Path = "HKCU:\Software\Policies\Microsoft\Windows\Windows Search"; Name = "AllowCloudSearch" },
    @{ Path = "HKCU:\Software\Policies\Microsoft\Windows\CloudContent"; Name = "DisableWindowsConsumerFeatures" },
    @{ Path = "HKCU:\Software\Policies\Microsoft\Windows\CloudContent"; Name = "DisableTailoredExperiencesWithDiagnosticData" },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"; Name = "DisableSearchBoxSuggestions" },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; Name = "DisableWebSearch" },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; Name = "ConnectedSearchUseWeb" },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; Name = "ConnectedSearchUseWebOverMeteredConnections" },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; Name = "AllowCloudSearch" },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; Name = "AllowCortana" },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; Name = "AllowSearchToUseLocation" },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"; Name = "DisableWindowsConsumerFeatures" },
    @{ Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"; Name = "DisableSoftLanding" }
)

foreach ($item in $regRemovals) {
    if (Test-Path $item.Path) {
        Remove-ItemProperty -Path $item.Path -Name $item.Name -ErrorAction SilentlyContinue
        Write-Host " [-] Removed policy $($item.Path)\$($item.Name)" -ForegroundColor Yellow
    }
}

$regDefaults = @(
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"; Name = "BingSearchEnabled"; Value = 1; Type = "DWord" },
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"; Name = "CortanaConsent"; Value = 1; Type = "DWord" },
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"; Name = "AllowSearchToUseLocation"; Value = 1; Type = "DWord" },
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings"; Name = "IsBingSearchEnabled"; Value = 1; Type = "DWord" },
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings"; Name = "IsSearchHighlightsEnabled"; Value = 1; Type = "DWord" },
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name = "ContentDeliveryAllowed"; Value = 1; Type = "DWord" },
    @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name = "SystemPaneSuggestionsEnabled"; Value = 1; Type = "DWord" }
)

foreach ($item in $regDefaults) {
    try {
        if (-not (Test-Path $item.Path)) {
            New-Item -Path $item.Path -Force | Out-Null
        }
        Set-ItemProperty -Path $item.Path -Name $item.Name -Value $item.Value -Type $item.Type -Force
        Write-Host " [+] Reset $($item.Path)\$($item.Name) = $($item.Value)" -ForegroundColor Green
    } catch {
        Write-Host " [!] Failed to reset $($item.Path)\$($item.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`n[*] Restarting Windows Search & Explorer processes..." -ForegroundColor Yellow
Get-Process -Name "SearchHost", "StartMenuExperienceHost", "SearchApp" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue

Write-Host "`n[✓] Defaults restored. Start Menu web search has been re-enabled." -ForegroundColor Green
