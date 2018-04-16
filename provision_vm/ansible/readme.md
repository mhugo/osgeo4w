# Ansible provisioning scripts for QGIS CI

Ansible version == `2.4.2.0`.

Ansible is based on Python, so it is recommended to setup a virtual env
in this directory before anything else. This will keep all updated
packages in a local directory which won't conflict with the modules
installed on the system.

Virtual env creation:

    virtualenv venv

Virtual env activation:

    source venv/bin/activate

Now you can install dependencies with:

    pip install -r requirements.txt

Oslandia specific readme : [readme-osl.md](readme-osl.md)

### ESG setup

This setup is done with ansible, in 2 phases:
- phase 1 provisions the linux machine, configures the vm and its auto-installation and starts it.
- phase 2 provisions the windows machine, once it is up and running.

#### Configure ansible connection:

1. Either: 
- change "esg" in `./hosts` to a ssh-accessible machine name and copy `host_vars/example.yml` to `host_vars/<hostname>.yml`
- or add an entry for "esg" in your ~/.ssh/config

To check that this steps is correctly configured, you can execute

```bash
<path_to_venv>/bin/ansible -vvv -i hosts -m ping gitlab
```

2. Customize all parameters in `host_vars/<hostname>.yml`

### ci server (linux + gitlab + virtualbox + bootstrap the vm)

Provisioning the Linux server and boostrap the windows installation with ansible: 

```bash
ansible-playbook -i hosts -e win_username=<windows username> -e win_password=<windows password> play-ci.yml
```

Once this playbook complete, you need to wait for the windows installation to
finish. At this point, you should be able to connect to it with rdp. One way to
achieve it:

- open a ssh tunnel: 
```bash
ssh -L 3389:localhost:3389 <user>@<hostname>
```
- connect to localhost:3389 with a rdp client

### Windows vm (build machine)

Before running this step, check that:
- The virtualbox extension pack is installed (`vboxmanage list extpacks` should list at least one, with `Usable: true`)
- the VM installation is complete
- the guest additions are installed in the vm (check the system tray icon).

Open a ssh tunnel to allow ansible to connect to the windows machine via winrm:
```bash
ssh -L 5985:localhost:5985 <user>@<hostname>
```

We'll have to authorize some scripts to run to the vm. To be able to do so,
connect to the vm via RDP. You'll need to click on "yes" on each administrative
prompt that might appear.

Then run:
```bash
ansible-playbook -i hosts -e win_username=<windows username> -e win_password=<windows password> play-win.yml
```

### Registering the windows vm to gitlab-runner

This part is not yet automated.

Now that the win10 vm is ready, we need to register it to the gitlab instance:

The VM needs to have a ssh daemon running to allow connections from the gitlab-runner.
Here are some manual steps to execute inside the VM:

- start the ssh daemon inside the vm. On a admin cygwin shell on the windows vm:
```
ssh-host-config --cygwin ntsec --yes
net start sshd
```
- Add the ssh public key to ~/.ssh/known_hosts (of the VM)
On the gitlab host

```
su - gitlab-runner
ssh-copy-id -i ~/.ssh/id_rsa <vm_username>@localhost -p 2222
```
and test connection from the linux host: 

```
ssh <vm_username>@localhost -p 2222
```

- Update the snapshot which is now ready for the Continuous integration
```
VBoxManage snapshot win10 take "win10_ready4ci"
```

- get the registration token from this page :
  https://<gitlab_url>/admin/runners and register a runner on the linux host:

```
gitlab-runner register --non-interactive --name win10 \
  --url <gitlab_url> \
  --registration-token <the token> \
  --virtualbox-base-name win10 \
  --executor virtualbox \
  --ssh-user oslandia \
  --ssh-identity-file /home/gitlab-runner/.ssh/id_rsa \
  --virtualbox-base-snapshot win10_ready4ci
```

ref:

  - https://docs.gitlab.com/runner/executors/virtualbox.html#how-it-works
  - https://git.oslandia.net/Oslandia-infra/devtools/tree/master/virtual/windows_ci
