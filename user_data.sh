#!/bin/bash
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
# Save UserData execution log to /var/log/user-data.log

# Allow SSH login with password authentication
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
# Restart sshd service to apply changes
systemctl restart sshd

##### Create infraadmin account for CA access
# useradd -c "Account for Cloudadmin" infraadmin
# echo 'infraadmin:Ezwel123!' | sudo chpasswd
# usermod -aG wheel infraadmin

# Set password for ec2-user account for access
echo 'ec2-user:Ezwel123!' | sudo chpasswd

# Set TimeZone to Asia/Seoul
timedatectl set-timezone Asia/Seoul

# Mount Data area EBS volume (/data)
echo -e "n\np\n\n\n\nw\n" | fdisk /dev/nvme1n1           # Create a new partition using fdisk
echo "fdisk new partition complete"
mkfs -t xfs /dev/nvme1n1p1                                  # Format the partition with XFS filesystem
echo "mkfs complete"
mkdir /data                                                 # Create /data directory
mount /dev/nvme1n1p1 /data                                  # Mount the partition to /data
echo "mount complete"
UUID=$(blkid -s UUID -o value /dev/nvme1n1p1)               # Extract UUID
echo -e "UUID=$UUID\t/data\txfs\tdefaults\t0 2" >> /etc/fstab      # Add disk information to /etc/fstab

# Download and install Whatap from S3
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then     # If architecture is x86, install x86_64 agent
  echo "Architecture is aarch64"
  aws s3 cp s3://s3-esp-shared-infra-utils/whatap/whatap-infra-2.7-6.aarch64.rpm /tmp/
  yum install -y /tmp/whatap-infra-2.7-6.aarch64.rpm
  yum list installed | grep whatap-infra
elif [ "$ARCH" = "x86_64" ]; then    # If architecture is ARM, install aarch64 agent
  echo "Architecture is x86_64"
  aws s3 cp s3://s3-esp-shared-infra-utils/whatap/whatap-infra-2.7-6.x86_64.rpm /tmp/
  yum install -y /tmp/whatap-infra-2.7-6.x86_64.rpm
  yum list installed | grep whatap-infra
else
  echo "Unsupported architecture: $ARCH"
  exit 1
fi
# Enable Whatap monitoring
echo "license=x218gaug47taq-x2it3jmcs0tblc-x6am6budp7dfs0" |sudo tee /usr/whatap/infra/conf/whatap.conf
echo "whatap.server.host=10.3.214.149" |sudo tee -a /usr/whatap/infra/conf/whatap.conf
echo "createdtime=`date +%s%N`" |sudo tee -a /usr/whatap/infra/conf/whatap.conf
sudo service whatap-infra restart
systemctl enable whatap-infra.service # Enable and test Whatap service

#####1.01 Restrict remote root login
chgrp wheel /usr/bin/su         # Change group of /usr/bin/su to wheel
chmod 4750 /bin/su              # Modify permissions
# Use 'usermod -G wheel "account_name"' command to add accounts needing SU access to the wheel group

#####1.02 Configure password complexity
sed -i 's/# minlen = 8/minlen = 8/g' /etc/security/pwquality.conf # Minimum length of 8 characters
sed -i 's/# minclass = 0/minclass = 3/g' /etc/security/pwquality.conf # Require at least 3 character classes (uppercase, lowercase, numbers, special characters)
sed -i 's/pam_pwquality.so try_first_pass local_users_only retry=3/pam_pwquality.so try_first_pass local_users_only retry=5/g' /etc/pam.d/system-auth
# Allow 5 failed attempts before lockout

#####1.03 Configure account lockout threshold
if ! grep -q "auth required pam_faillock.so preauth silent audit deny=5 unlock_time=600" /etc/pam.d/password-auth; then
    echo "auth required pam_faillock.so preauth silent audit deny=5 unlock_time=600" >> /etc/pam.d/password-auth
fi # Lock account for 10 minutes after 5 failed attempts
if ! grep -q "account required pam_faillock.so" /etc/pam.d/password-auth; then
    echo "account required pam_faillock.so" >> /etc/pam.d/password-auth
fi # Enable FailLock

#####1.04 Protect password files
#####2.01 Configure root home, path directory permissions and path settings
#####2.02 Set file and directory ownership
# No files or directories without ownership exist in the initial setup
# Additional checks needed after final server configuration
# find / -nouser -o -nogroup

#####2.03 Set owner and permissions for /etc/passwd
#####2.04 Set owner and permissions for /etc/shadow
#####2.05 Set owner and permissions for /etc/hosts
# Default owner is root, and permission is 644
if [ $(stat -c %a /etc/hosts) -gt 600 ]; then
    chmod 600 /etc/hosts
fi # Change permission to 600 if higher

#####2.06 Set owner and permissions for /etc/(x)inetd.conf
#####2.07 Set owner and permissions for /etc/syslog.conf
#####2.08 Set owner and permissions for /etc/services

#####2.09 Check SUID, SGID, Sticky bit settings
chmod -s /usr/sbin/unix_chkpwd
chmod -s /usr/bin/at
chmod -s /usr/bin/newgrp

#####2.10 Configure user and system startup files and environment file permissions
find /home -type f -exec chmod o-rwx {} \;
# Since default settings require changes only for users created under /home, remove other permissions from all files in this directory

#####2.11 Check world writable files
#####2.12 Check for non-existent devices in /dev
#####2.13 Disable usage of $HOME/.rhosts and hosts.equiv

#####2.14 Restrict access by IP and port
# Initially, adding ALL:ALL to /etc/hosts.deny may cause confusion,
# so users should configure settings in /etc/hosts.allow first before manually enabling it
echo "# After completing the additional configuration in the /etc/hosts.allow file, remove the comments." >> /etc/hosts.deny
echo "#ALL: ALL" >> /etc/hosts.deny

#####3.01 Disable Finger service
#####3.02 Disable Anonymous FTP
#####3.03 Disable r-services

#####3.04 Set owner and permissions for cron files
chmod 640 /etc/crontab
chmod 640 /etc/cron.daily/*
chmod 640 /etc/cron.hourly/*
chmod 640 /etc/cron.monthly/*
chmod 640 /etc/cron.weekly/*

#####3.05 Disable services vulnerable to DoS attacks

#####3.06 Disable NFS service
systemctl disable nfs-server
systemctl disable rpcbind
systemctl disable nfs-mountd
systemctl disable nfs-idmapd
systemctl disable rpc-statd

#####3.07 Control NFS access
#####3.08 Remove automountd
#####3.09 Check RPC services
#####3.10 Check NIS, NIS+
#####3.11 Disable tftp, talk services
#####3.12 Check Sendmail version
#####3.13 Restrict spam mail relay
#####3.14 Prevent normal users from executing Sendmail
#####3.15 Apply security patches for DNS
#####3.16 Configure DNS ZoneTransfer
#####4.01 Apply latest security patches and vendor recommendations
#####5.01 Regularly review and report logs