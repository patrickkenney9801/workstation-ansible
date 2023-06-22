# Workstation Ansible

Workstation-Ansible is a git repo for `ansible` to configure new workstations
and to install specific tools that require extra configuration.

## Authors

Patrick Kenney

## Tools

### [asdf](https://asdf-vm.com)

Provides a declarative set of tools pinned to
specific versions for environmental consistency.

These tools are defined in `.tool-versions`.
Run `make dependencies` to initialize a new environment.

### [pre-commit](https://pre-commit.com)

A left shifting tool to consistently run a set of checks on the code repo.
Our checks enforce syntax validations and formatting.
We encourage contributors to use pre-commit hooks.

```shell
# install all pre-commit hooks
make hooks

# run pre-commit on repo once
make pre-commit
```

### [ansible](https://www.ansible.com/)

A set of automations tooling that uses ssh to configure machines.

We recommend installing this tool via anaconda:

```shell
  conda install --channel conda-forge ansible
```

The directives describing how tooling is installed can be found in
`roles/role-name/tasks/main.yml`.

## Setup

To configure a new machine ensure it is running `ssh` and copy your
public key to it to enable passwordless ssh connections.

```shell
  ssh-copy-id -i path/to/key.pub user@hostname
```

Add the workstations to be configured to the `hosts` file, this file
is in the `.gitignore` and is not committed.

```shell
[workstations]
user@remote-hostname
user2@remote-hostname2
...
```

To only install tools that do not require root use `[rootless-workstations]` instead.

To install a different set of tools, new types of hosts can be added to
`playbooks/workstation.yml` in the style of the other hosts.  The `roles`
are the directory names under `roles` and correspond to installing different tooling.

## Usage

To install/configure tooling on a workstation add the user and hostname to the `hosts`
file as described in `Setup`.

Then for configuration that requires `root` privileges run:

```shell
  make ansible
```

And for configurations that do not run:

```shell
  make ansible-rootless
```
