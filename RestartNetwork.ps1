# Check for Administrator Privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "This script requires administrative privileges. Please run as Administrator."
    Exit
}

# Function to log events
function Log-Event {
    param([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path "C:\Users\HP\Desktop\RestartNetwork.ps1" -Value "$timestamp - $message"
}

# Function to display a message box
function Show-MessageBox {
    param([string]$message, [string]$title)
    [System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

try {
    # Restarting Network Services
    Restart-Service -Name "AarSvc_728f4"
    Restart-Service -Name "AdobeARMservice"
    Restart-Service -Name "AJRouter"

# Restart Services
$servicesToRestart = "AarSvc_728f4", "AdobeARMservice", "AJRouter"

foreach ($service in $servicesToRestart) {
    Restart-Service -Name $service -Force -ErrorAction SilentlyContinue
}


    # Disabling and Enabling Server Network Adapter
    $adapterName = "Ethernet"  # Replace with your actual adapter name

    # Disable the network adapter
    Disable-NetAdapter -Name $adapterName -Confirm:$false

    # Wait for a moment before enabling the adapter
    Start-Sleep -Seconds 5

    # Enable the network adapter
    Enable-NetAdapter -Name $adapterName

    # Log success
    Log-Event -message "Network services and server adapter restarted successfully"

    # Display a success message box
    Show-MessageBox -message "Network services and server adapter restarted successfully" -title "Success"
}
catch {
    # Log errors
    Log-Event -message "Error: $_"
    
    # Display an error message box
    Show-MessageBox -message "An error occurred. Check the log for details." -title "Error"
    
    # Add any additional error-handling steps here
}
finally {
    # Prompt to confirm
    $confirmation = Show-MessageBox -message "Do you want to proceed?" -title "Confirmation" -button "YesNo"

    if ($confirmation -eq 'No') {
        Log-Event -message "Script execution aborted."
        exit
    }
}

2024-01-22 10:24:22 - Network services and server adapter restarted successfully
2024-01-22 10:26:56 - Network services and server adapter restarted successfully
2024-01-22 10:27:39 - Network services and server adapter restarted successfully
2024-01-22 10:29:06 - Network services and server adapter restarted successfully
2024-01-22 10:29:40 - Network services and server adapter restarted successfully
