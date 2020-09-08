## Process and Script to auto create or delete workspaces.

#### To Create

#### Requirements:
- Docker
- Kind
- Lens 

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

#TODO
- requirements
- question script(start.sh)
- instructions
- local hosts file
- local registry
- dockerfile
- remote state
- k8bit cleanup
- Base
- Admin
- APP
- cleanup nginx image
- run/test
- test lens/k8bit
- cleanup all comments
- cleanup readme
- cleanup script
- check credits
- add todo
- merge to master
- make repo public



#### To Delete
```
tfi
```
<br>

#### Or to script in one line 

#####To Create:
``
curl https://raw.githubusercontent.com/ntman4real/devopsinabox-k8/master/start.sh | bash -s -- corp app1
``