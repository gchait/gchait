sudo sh -c 'cat > /etc/apt/sources.list.d/focal-dell.list << EOF
deb http://dell.archive.canonical.com/updates/ focal-dell public
deb http://dell.archive.canonical.com/updates/ focal-oem public
deb http://dell.archive.canonical.com/updates/ focal-somerville public
deb http://dell.archive.canonical.com/updates/ focal-somerville-melisa public
EOF'

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F9FDA6BED73CDC22
sudo apt update -qq

sudo apt install libfprint-2-tod1-goodix oem-somerville-meta tlp-config -y

sudo add-apt-repository ppa:boltgolt/howdy -y
sudo apt update -qq
sudo apt install howdy -y
