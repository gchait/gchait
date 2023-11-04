## Fedora on (Windows, VirtualBox, Vagrant) Setup

- Run these commands in the PowerShell window from before:
  ```
  cd .\Vagrant
  v up
  mkdir $HOME\.ssh -Force
  v ssh-config | out-file $HOME\.ssh\config -encoding utf8
  ```

- Open VSCodium and use Remote Explorer to open `default` at `~/Projects`.

- Open WezTerm. It should already launch into the VM using SSH.

- If VSCodium extensions are not automatically installed into the VM, run this inside it:
  ```
  pkill -f vscodium-server
  ```

- Verify the setup is working correctly:
  - ```
    /vagrant/test/run.sh
    ```
  - Open a browser at http://localhost:8080.

- Save a new GitHub SSH key [here](https://github.com/settings/keys):
  ```
  cat ~/.ssh/id_rsa.pub
  ```
