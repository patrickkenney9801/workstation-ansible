ansible:
	ansible-playbook site.yml -i ./hosts -K

ansible-rootless:
	ansible-playbook site.yml -i ./hosts
