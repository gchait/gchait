zypper packages --unneeded | \
    awk -F'|' 'NR==0 || NR==1 || NR==2 || NR==3 || NR==4 {next} {print $3}' | \
    grep -v Name | grep -vi fwup | grep -vi font | grep -v flatpak | awk '{print $1}'
