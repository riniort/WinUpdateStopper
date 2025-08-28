# WinUpdateStopper

**WinUpdateStopper** is a lightweight batch script that allows you to **turn Windows Update ON/OFF** on Windows 11/10.  
It works by enabling or disabling the `wuauserv` service (Method 3).

> ⚠️ Use responsibly: Disabling Windows Update means you won’t get security patches. Re-enable it when you want to update.

---

## Features
- **Toggle Windows Update** between:
  - `0` — Turn **OFF** (service disabled, persists after reboot)
  - `1` — Turn **ON** (service set to Manual and started)
  - `S` — Open **Services** (`services.msc`) for manual control
- Detects if you are running as **Administrator** (auto-elevates if possible)
- Simple menu interface

---

## How it works
- **OFF (`0`)**  
  ```bat
  net stop wuauserv
  sc config wuauserv start= disabled
  ```
- **ON (`1`)**  
  ```bat
  sc config wuauserv start= demand
  net start wuauserv
  ```

These settings remain across reboots. Windows will not prompt for updates while the service is disabled.

---

## Usage
1. Download `WinUpdateStopper.bat`.
2. **Right-click → Run as administrator**.  
   (The script will also attempt to auto-elevate.)
3. Choose: `0` / `1` / `S` / `Q`.

---

## Convert to EXE (optional)
You can convert this batch script to an `.exe` for easier sharing:
- With **Bat To Exe Converter** (GUI)  
- Or with **PS2EXE** (PowerShell):
  ```powershell
  Install-Module ps2exe -Scope CurrentUser
  Invoke-ps2exe -InputFile .\WinUpdateStopper.bat -OutputFile .\WinUpdateStopper.exe
  ```

---

## License
MIT License. See `LICENSE` file.
