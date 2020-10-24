#cloud-config

runcmd:
# change host name
  - hostnamectl set-hostname <hostname>

# package install
  - yum update -y

# set timezone
## backup config
  - cp  -p /etc/localtime /etc/localtime.org

## create symbolic link
  - ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
