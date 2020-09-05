## Process and Script to auto create or delete workspaces.

#### To Create

Requirements:

Docker
Kind
Lens

What this creates
- a Utility Container, containing:
    - Terraform
- A kind k8's cluster with your specified amount of Master's and Worker's
- Some k8's Base Application's
    - krew
    - promethesis
    - Metrics
    - Custom Metrics Adapter

Optional:
weaveworks

sslCert

Modifies local hosts

Domain Name
DNS
```
tfi
tf workspace list
tf workspace new dev_east
tf workspace new dev_west
tf workspace new qat_east
tf workspace new qat_west
tf workspace new stg_east
tf workspace new stg_west
tf workspace new prd_east
tf workspace new prd_west
tf workspace list
export TF_WORKSPACE=dev_east
tfi
tfp
```

#### To Delete
```
tfi
tf workspace list
tf workspace delete dev_east
tf workspace delete dev_west
tf workspace delete qat_east
tf workspace delete qat_west
tf workspace delete stg_east
tf workspace delete stg_west
tf workspace delete prd_east
tf workspace delete prd_west
tf workspace list
```
<br>

#### Or to script in one line 

#####To Create:
``
curl https://gitlab.chewysb.com/snippets/2/raw?line_ending=raw | bash -s -- corp app1
``
#####To Delete:
``
curl https://gitlab.chewysb.com/snippets/2/raw?line_ending=raw | bash -s -- corp app1 delete
``