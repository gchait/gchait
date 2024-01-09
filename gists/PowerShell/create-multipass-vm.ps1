multipass launch lunar `
    --name vm `
    --cpus 4 `
    --memory 8G `
    --disk 32G `
    --cloud-init cloud-init.yaml

multipass transfer ../dotfiles/.zshrc vm:/home/ubuntu
multipass transfer -pr ../dotfiles/.config/nvim vm:/home/ubuntu/.config/nvim

multipass exec vm -- chmod 644 /home/ubuntu/.zshrc
multipass exec vm -- chmod 644 /home/ubuntu/.config/nvim/init.vim
