# Exact name matches to current
comm -1 -2 <(grep "|command|" /var/log/zypp/history | \
    grep -Eo -e "'in' (.+)|" -e "'install' (.+)|" | \
    cut -d" " -f2- | tr -d "'|" | sed "s/ /\n/g" | sort) \
    <(rpm -qa --qf "%{NAME}\n" | sort)

# All installed
grep "|command|" /var/log/zypp/history | \
    grep -Eo -e "'in' (.+)|" -e "'install' (.+)|" | \
    cut -d" " -f2- | tr -d "'|" | sed "s/ /\n/g" | sort
