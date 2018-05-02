To install WSL + ssh server on a VM:

1. Make sure Windows is up to date (try a restart and wait for updates
if needed)

2. execute install_wsl.ps1 under an administrator powershell. It will install WSL,
download and install Ubuntu as well (it will take some time). It will
ask for a username and password during last stage.

3. Under bash (C:\WSLDistros\Ubuntu\ubuntu.exe) :
  # get the ssh installation script install_ssh.sh
  # make it executable
  - chmod a+x install_ssh.sh
  # run it as root
  - sudo ./install_ssh.sh

4. If every goes well, you should be able to ssh into localhost with the
username / password configured in 2. Try "ssh localhost" in ubuntu.exe
