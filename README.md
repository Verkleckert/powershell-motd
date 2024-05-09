# Powershell MOTD
---
A collection of motd's for your Powershell

For the complete coolness factor take a look at [OH-MY-POSH](https://ohmyposh.dev/) with many great designs for a personalized wondows powershell.

> **_NOTE:_**  If you use it with oh-my-posh just put the line for it over or under the script

### Requirements

- Nerd Font
    * Some styles require a Nerd Font. 

### Disclaimer

We are not responsible for any issues or damages that may occur during or as a result of using this installer. Use at your own risk.

### Installation

> **_NOTE:_**  If you use it with oh-my-posh just put the line for it over or under the script

> **_NOTE:_**  You can use the installer but its still WIP so if it doesn't work please report it or ignore it :)

1. open profile file of your powershell
```powershell
notepad $PROFILE
```

2. Past the content of the **Microsoft.PowerShell_profile.ps1** into the profile file and save it

3. To refresh the powershell instance run:
```powershell
. $PROFILE
```

### Nerd Font

1. Chose a Nerd Font you like. You can choose one here: [Nerdfonts](https://www.nerdfonts.com/font-downloads)

2. Install it on your machine (Normaly the regular but you can choose a different)

3. Open the settings.json
    * On the Windows Terminal (The one with tabs) application press `CTL + SHIFT + ,` in your to open the *settings.json*. In the *settings.json* add your font like this (make sure to add *"Nerd Font"* at  the end):
    ```json
    {
        "profiles":
        {
            "defaults":
            {
                "font":
                {
                    "face": "MesloLGM Nerd Font"
                }
            }
        }
    }
    ```
    * If you use the normal Powershell rightclick the title bar and select "Properties". In the Properties select the tab "Font" and select your Font there.
    
> **_NOTE:_** If you use Visual Studio Code or any other IDE you need to select the Nerd Font in there too.

> **_Warning:_** It is a little bugged in some IDEs

### Made by
- Popa_42
- Verkleckert