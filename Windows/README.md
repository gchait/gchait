- Open PowerShell
- ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; powershell "Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression"
  ```
- Reopen PowerShell
- ```powershell
  scoop install git; git clone https://github.com/gchait/gchait.git; .\gchait\Windows\bootstrap.ps1
  ```
