```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

scoop install git
git clone https://github.com/gchait/gchait.git

winget install --id Microsoft.Powershell --source winget
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

pwsh "$HOME\gchait\Windows\bootstrap.ps1"
```
