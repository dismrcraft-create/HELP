# FixAltGr.ps1
# Script to fix the issue where Right Alt key (AltGr) does not work for language switching 
# when the Arabic keyboard layout is active, by remapping it to act as Left Alt.

# --------------------------------------------------------------------------------------
# WARNING: This script requires administrator rights to modify the HKLM registry hive.
# --------------------------------------------------------------------------------------

# Define the binary data (Scancode Map) to remap Right Alt (E0 38) to Left Alt (00 38).
# The sequence is: Header (8 bytes), Map Count (4 bytes), Mapping (4 bytes), Null Terminator (4 bytes).
$hex = "0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x38,0x00,0x38,0xE0,0x00,0x00,0x00,0x00"

# Define the Registry path
$path = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
$KeyName = "Scancode Map"

# Check if the script is running with elevated permissions (Administrator)
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "ERROR: This script must be run as Administrator to modify system registry keys."
    exit 1
}

try {
    # 1. Apply the Registry change (remapping the Right Alt key)
    New-ItemProperty -Path $path -Name $KeyName -PropertyType Binary -Value ([byte[]]($hex.Split(","))) -Force
    
    Write-Host "SUCCESS: Right Alt key has been successfully remapped to act as Left Alt." -ForegroundColor Green
    Write-Host "-----------------------------------------------------------------------"
    Write-Host "Action Required: You MUST restart your computer for this change to take effect." -ForegroundColor Yellow
    
    # 2. Offer to restart the computer immediately
    $Choice = Read-Host "Do you want to restart now? (Y/N)"
    if ($Choice -imatch "^Y") {
        Write-Host "Restarting computer..."
        Restart-Computer -Force
    } else {
        Write-Host "Please restart your computer manually soon."
    }

} catch {
    Write-Error "An error occurred during registry modification: $($_.Exception.Message)"
}
