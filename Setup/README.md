### This is my setup 😀

- Open PowerShell

- ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
  ```

- Reopen PowerShell

- ```powershell
  scoop install git
  git clone https://github.com/gchait/gchait.git
  .\gchait\Setup\bootstrap.ps1
  ```
