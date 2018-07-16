# Ansible provisioning scripts for OSGeo4W CI

This set of Ansibl scripts are able to instal and configure:
- a Gitlab instance on a Linux machine
- VirtualBox with a Windows 10 virtual machine (VM) preconfigured for the compilation of OSGeo4W packages
- all the glue necessary to make the virtual machine manageable by gitlab-ci

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

### Setup

This setup is done with Ansible, in different steps:
- step 1 provisions the Linux machine, configures the VM and its auto-installation and starts it.
- step 2 provisions the Windows machine, once it is up and running.
- step 3 registers the Windows machine to the Gitlab instance and requires a registration token

#### Configure ansible connection:

Have a detailed look at the sample host configuration file `hosts.sample`, copy it to `hosts` and set
all the required configuration parameters.

To check that this step is correctly configured, you can test the connection to the host by typing:

```bash
<path_to_venv>/bin/ansible -vvv -i hosts -m ping gitlab
```

### CI server (linux + gitlab + virtualbox + bootstrap the vm)

Provisioning the Linux server and boostrap the windows installation with Ansible: 

```bash
ansible-playbook -i hosts -e win_username=<windows username> -e win_password=<windows password> play-gitlab.yml -K
```

This will ask first for the 'sudo' password on the Linux machine.

Once this playbook complete, you need to wait for the Windows installation to
finish. You will need to watch for the Windows installation to complete
by a graphical connection to the virtual machine, either by using the native virtualbox Graphical User Interface, or,
in headless mode, using an RDP client to the virtual machine.

During installation, the VirtualBox RDP server is enabled on port 6666. So you will be able to connect to the
running instance using an RDP client on this port (`rdesktop` or `remmina` under Linux for instance).

### Windows VM (build machine)

Before running this step, check that:
- The virtualbox extension pack is installed (`vboxmanage list extpacks` should list at least one, with `Usable: true`)
- the VM installation is complete
- the guest additions are installed in the VM (check the system tray icon).

On the "gitlab" machine, open an ssh tunnel to allow ansible to connect to the windows machine via winrm:
```bash
ssh -L 5985:localhost:5985 <user>@<hostname>
```

We'll have to authorize some scripts to run to the VM. To be able to do so,
connect to the vm via RDP. You'll need to click on "yes" on each administrative
prompt that might appear.

Then run:
```bash
ansible-playbook -i hosts -e win_username=<windows username> -e win_password=<windows password> play-vm.yml -K
```

### Registering the windows VM to gitlab-runner

This third part requires a "runner registration token" that is randomly generated on each gitlab installation.
There is currently no way to automate the retrieval of this token using the Gitlab API.

So once the previous steps are completed, connect to the gitlab instance through its web interface with the
"root" user and get a runner registration token. Runners can be registered either as shared runners for all the
gitlab projects, as group runners or for a specific project.

Complete your `hosts` file with the runner registration token (variable `runner_registration_token`).

Then run:
```bash
ansible-playbook -i hosts -e win_username=<windows username> -e win_password=<windows password> play-register-runner.yml -K
```
