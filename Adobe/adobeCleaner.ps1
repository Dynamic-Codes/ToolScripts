# https://rb.gy/3os8tx

function Show-Menu {
  $menuOptions = @"
=======================================================================
                      ADOBE REMNANT CLEANER v1.0
=======================================================================

    Options                      Desc
    -------                      ----
    [1] Creative Cloud Cleaner  | Download the Cleaning tool
    [2] Explorer Cleaner        | Remove Adobe folders & files
    [3] Registry Cleaner        | Cleanse Window Registry
    -----------------------------------------------------------
    [4] Discord                 | Get Support from community
    -----------------------------------------------------------
    [0] Exit
_______________________________________________________________________

Please select an option on your keyboard:
"@
  Clear-Host
  Write-Host $menuOptions
  $menuInput = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
  switch ($menuInput) {
    '1' {
      Start-CreativeCloudCleaner
      Show-Menu
    }
    '2' {
      Remove-AdobeFromExplorer
      Pause
      Show-Menu
    }
    '3' {
      Write-Host "You selected 3!"
    }
    '4' {
      Start-Process "https://www.discord.com/invite/YmmCnwzwsV"
      Show-Menu
    }
    '0' {
      Write-Host "Exiting"
      Exit
    }
    Default {
      Show-Menu
    }
  }
}

function Start-CreativeCloudCleaner {
  # Function to check internet connectivity
  function isOnline {
    return (Test-Connection -ComputerName www.google.com -count 1 -Quiet)
  }
  
  # Paths
  $ccCleaner = "https://swupmf.adobe.com/webfeed/CleanerTool/win/AdobeCreativeCloudCleanerTool.exe"
  $ccFile  = "$env:USERPROFILE\Desktop\AdobeCreativeCloudCleanerTool.exe"

  # Clear screen and display header
  Clear-Host
  Write-Host @"
=======================================================================
            ADOBE CREATIVE CLOUD CLEANER TOOL - GUIDED
=======================================================================

[i] Checking internet connection (pinging www.google.com)
"@

  # Suppress progress bar
  $ProgressPreference = 'SilentlyContinue'
  
  # Check internet connection
  if (isOnline) {
    Write-Host "[i] Connection successful"
  } else {
    Write-Host "[!] Connection failed, unable to continue"
    Pause
    Return
  }

  # Start download
  Write-Host "[i] Starting download..."
  try {
    Invoke-WebRequest -Uri $ccCleaner -OutFile $ccFile
  } catch {
    Write-Host "[!] An error occurred whilst downloading, aborting script."
    Pause
    Return
  }

  Write-Host "[i] Download complete!"
  Write-Host "[i] Starting tool..."
  try {
    Start-Process $ccFile
    Write-Host "[i] UAC prompt accepted, started tool."
  } catch {
    Write-Host "[!] UAC prompt was denied by user, failed to start tool!"
    Pause
    return
  }

  Write-Host @"
-----------------------------------------------------------------------
[1] On language prompt, type "e" and press enter.
[2] Next you'll need to accept the T&Cs, type "y" and press enter.
[3] Now select option "1" and enter.
[4] You'll now see a screen with all of the tools installed on your
    machine, select the last option that says "Clean All"
[5] On the confirmation prompt, type "y" and hit enter.
_______________________________________________________________________
"@
  Read-Host "Press Enter to continue..."
}

function Remove-AdobeFromExplorer {
  Clear-Host
  Write-Host @"
=======================================================================
                  ADOBE FOLDER AND FILES CLEANER
=======================================================================

    | You are about to delete ALL Adobe related folders, files,
    | settings and preferences. This action CAN NOT be undone.
    | Are you sure you would like to continue?
    |
    | [y] Yes, Continue; [n] No, exit 

_______________________________________________________________________
"@
  
  $WarningChoice = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character

  switch ($WarningChoice) {
    'y' {
      Clear-Host
      Write-Host = @"
=======================================================================
                  ADOBE FOLDER AND FILES CLEANER
=======================================================================
"@
    }
    'n' {
      Write-Host "[i] Aborting cleaning process."
      Start-Sleep 2
      Show-Menu
    }
    Default {
      Remove-AdobeFromExplorer
    }
  }
  function Update-Folder {
    param(
      [string]$dir
    )

    Write-Host "[i] Checking in ($dir)"
    $adobeFolders = Get-ChildItem -Path $dir -Directory -Filter 'Adobe*' -ErrorAction SilentlyContinue
    if ($adobeFolders) {
        foreach ($adobeFolder in $adobeFolders) {
            Write-Host "[i] Folder found: $($adobeFolder.FullName)"
            Write-Host "[i] Attempting to remove folder $($adobeFolder.FullName)..."
            try {
                Remove-Item -Path $adobeFolder.FullName -Recurse -Force
                Write-Host "[i] Removed folder $($adobeFolder.FullName)."
            } catch {
                Write-Host "[!] Unable to remove folder $($adobeFolder.FullName)"
            }
        }
    } else {
        Write-Host "[?] No Adobe folders exist in this directory, skipping..."
    }
  }

  

  $username = $env:USERNAME
  Update-Folder -dir "C:\Program Files"
  Update-Folder -dir "C:\Program Files\common files"
  Update-Folder -dir "C:\Program Files (x86)"
  Update-Folder -dir "C:\Program Files (x86)\common files"
  Update-Folder -dir "C:\users\$($username)\appdata\local"
  Update-Folder -dir "C:\users\$($username)\appdata\local\temp"
  Update-Folder -dir "C:\users\$($username)\appdata\roaming"

}


# Check if the current user has administrative privileges
$admin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $admin) {
  Write-Host "This application requires elevated permissions to run, please grant them on the next Prompt."
  Start-Sleep 2
  Start-Process powershell -Verb RunAs -ArgumentList "-Command irm https://rb.gy/3os8tx | iex"
  Exit
}

Show-Menu