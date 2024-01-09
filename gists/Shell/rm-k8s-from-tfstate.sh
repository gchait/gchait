terraform state list | grep -e kubernetes_ -e helm_ | awk '{printf "terraform state rm '\''%s'\''\n", $1}' | bash
