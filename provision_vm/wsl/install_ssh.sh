#!/bin/bash
if [ "$EUID" != "0" ]; then
  echo "Please run as root"
  exit
fi

# Turn tracing on
set -x

echo "Installing openssh-server ..."

win_user=$( /mnt/c/Windows/System32/cmd.exe /c "echo %USERNAME%" | tr -d '\r' )
app_data=/mnt/c/Users/$win_user/AppData/Roaming

apt-get update

apt-get -y install --reinstall openssh-server

sed -i "s/^UsePrivilegeSeparation yes/UsePrivilegeSeparation no/" /etc/ssh/sshd_config
sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config
grep sshd /etc/sudoers >/dev/null || echo "%sudo ALL=NOPASSWD: /usr/sbin/sshd" >> /etc/sudoers

echo "Configuring startup scripts ..."

mkdir -p /mnt/c/Users/$win_user/ssh

echo 'C:\Windows\System32\bash.exe -c "sudo /usr/sbin/sshd -D"' > /mnt/c/Users/$win_user/ssh/sshd.bat

cat <<EOF > /mnt/c/Users/$win_user/ssh/sshd.vbs
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "%userprofile%\ssh\sshd.bat" & Chr(34), 0
Set WinScriptHost = Nothing
EOF

cp /mnt/c/Users/$win_user/ssh/sshd.vbs "$app_data/Microsoft/Windows/Start Menu/Programs/Startup"

echo "Launching sshd ..."
/mnt/c/Windows/System32/cmd.exe /c "start %userprofile%\ssh\sshd.vbs"

