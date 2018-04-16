Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
Invoke-WebRequest https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -UseBasicParsing -OutFile c:\Users\{{ win_username }}\ConfigureRemotingForAnsible.ps1
c:\Users\{{ win_username }}\ConfigureRemotingForAnsible.ps1
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
NetSh Advfirewall set allprofiles state off
