### This is my setup 😀

- Open PowerShell

- ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

- ```powershell
  Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
  ```

- Reopen PowerShell

- ```powershell
  scoop install git
  ```

- ```powershell
  git clone https://github.com/gchait/gchait.git
  ```

- ```powershell
  .\gchait\Setup\bootstrap.ps1
  ```
