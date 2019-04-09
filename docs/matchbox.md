OS installation with Matchbox
###

## Launch Matchbox

```sh
# Launch matchbox VM:
cd matchbox
vagrant up
cd -

# Configure matchbox VM:
ansible-playbook -i matchbox, -u vagrant -e ansible_host=127.0.0.1 -e ansible_port=2222 playbooks/matchbox.yml

# Configure matchbox service:
cd matchbox
terraform init
terraform plan
terraform apply
cd -
```

## Launch VM cluster:

```sh
cd terraform
terraform init
terraform plan
terraform apply
cd -
```

## Teardown

```sh
# Delete cluster
cd terraform
terraform destroy
cd -

# Delete matchbox config
cd matchbox
terraform destroy
vagrant destroy
cd -
```
