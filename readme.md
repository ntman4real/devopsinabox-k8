### A 100% completly local K8's implementation.
#### Requirements(Locally):
- git
- Docker
- Kind
- Lens 
#### What this repo creates:
- a local Utility Container, containing:
    - Terraform
    - xxx
    - xxx
- A kind k8's cluster with your specified amount of Master's and Worker's
    - an SSL cert, based on chosen domain name
    - A private docker registry
    - Some k8's Base Application's
        - krew
        - promethesis
        - Metrics
        - Custom Metrics Adapter for several WebApp types(Nginx, GO, and more to come)
- A Simple Dashboard page which displays your app main index.html as well as a cluster visialization of your clusters(courtsey of K8BITS)

#### To Create:
- Just clone/fork this repo and run command `` sh  ./start.sh``

##### or to script in one line 
``
curl https://raw.githubusercontent.com/ntman4real/devopsinabox-k8/master/start.sh | bash -s
``
##### to bypass creating the config file, or use existing, after cloning repo run command
``
sh ./start.sh | bash -s
``


#### To Delete
```
tfi
```
<br>

#TODO
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
- integrate, optionally, weaveworks
- A clean delete process
- Diagrams


