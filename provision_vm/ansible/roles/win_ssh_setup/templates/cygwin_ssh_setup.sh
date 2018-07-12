cygrunsrv --stop sshd
cygrunsrv --remove sshd
ssh-host-config --cygwin ntsec --yes --pwd cygserver
cygrunsrv --start sshd
