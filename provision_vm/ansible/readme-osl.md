## Oslandia development server specific instructions

### SSH configuration

Generate a key for esg.oslandia.net: 

	ssh-keygen -f ~/.ssh/esg.oslandia.net

Example to add to the ~/.ssh/config:

	Host esg.oslandia.net    
    	Hostname ns3063251.ip-193-70-80.eu
    	User root
    	IdentityFile ~/.ssh/esg.oslandia.net

Copy the ssh key to the server: 

	ssh-copy-id -i ~/.ssh/esg.oslandia.net esg.oslandia.net

(credentials can be found in `secrets` repository: projets/1711_02_esg_qgisbuild/root@esg.oslandia.net) 

Try to connect : 

	ssh esg.oslandia.net

### OVH kernel setup

OVH doesn't provide headers for their custom kernel and we need them for virtualbox. We need to recompile the OVH kernel with support of module loading for virtualbox (dkms). A role has been created for that: 

    ansible-playbook -i oslandia.hosts setup-ovh.yml

After finished we need to change the default grub configuration to use the new kernel, this step can't be done easily with ansible, so here is the things to do: 

      # determine the order kernels are listed by grub 
      # be aware of submenu entries
      fgrep menuentry /boot/grub/grub.cfg
      # change default kernel to load at boot time
      vi /etc/default/grub # -> GRUB_DEFAULT="1>1"
      update-grub
      reboot


### Provisioning

Basically the same step as in readme.md, but use `oslandia.hosts` instead of `hosts`.
