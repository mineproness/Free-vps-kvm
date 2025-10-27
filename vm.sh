cat > user-data <<EOF
#cloud-config
hostname: ubuntu22
manage_etc_hosts: true
disable_root: false
ssh_pwauth: true
chpasswd:
  list: |
    root:root
  expire: false
growpart:
  mode: auto
  devices: ["/"]
  ignore_growroot_disabled: false
resize_rootfs: true
runcmd:
 - growpart /dev/vda 1 || true
 - resize2fs /dev/vda1 || true
 - sed -ri "s/^#?PermitRootLogin.*/PermitRootLogin yes/" /etc/ssh/sshd_config
 - systemctl restart ssh
EOF

cat > meta-data <<EOF
instance-id: iid-local01
local-hostname: ubuntu22
EOF

cloud-localds seed.iso user-data meta-data 
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img -O ubuntu.img
qemu-img resize  ubuntu.img 25G
touch cdrom
