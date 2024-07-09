###Installation
See details [here](..)

### Testing installation of a single module on an already installed cluster
* Copy cluster configuration files (created previously during cluster installation) into this folder:
```
cfg_kubernetes_ca_certificate.pem  
cfg_kubernetes_client_key.pem  
cfg_kubernetes_certificate.pem
cfg_kubernetes_host
cfg_kubernetes_routing_zone_name
```
* Adjust local variables in mainin.tf (registry host, username and password)
* Run terraform apply for a single module, e.g.
```
terraform init
terraform apply -target module.service-monitoring -auto-approve
```
* Uninstall the module
* Run terraform apply for a single module, e.g.
```
terraform destroy -target module.service-monitoring -auto-approve
```