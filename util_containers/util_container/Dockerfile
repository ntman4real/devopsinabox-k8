FROM reg.gitlab.chewysb.com/devops/docker/base

ENV SET_CONTAINER_TIMEZONE true
ENV ENV="/etc/profile"
ENV PATH="/usr/local/terraform:${PATH}"

RUN yum update -y \
	&& yum install -y \
	zip \
	autoconf \
	automake \
	libtool \
    graphviz \
	python3 \
	nmap \
	traceroute \
	tree \
	&& pip3 install BlastRadius \
	&& rm -rf /var/cache/yum

# Install eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin

# Install tfutils and alias's
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
    && ln -s ~/.tfenv/bin/* /usr/local/bin \
    && tfenv install 0.11.14 \
    && tfenv install 0.12.29 \
    && tfenv install latest \
    && echo 'PATH="/usr/local/terraform:${PATH}"' >> /etc/profile \
    && echo 'alias tf="terraform"' >> /etc/profile \
    && echo 'alias tfa="tf apply -auto-approve"' >> /etc/profile \
    && echo 'alias tfd="tf destroy -auto-approve"' >> /etc/profile \
    && echo 'alias tfi="tf init -upgrade=true"' >> /etc/profile \
    && echo 'alias tfp="tf plan"' >> /etc/profile \
    && echo 'alias tft="tf taint"' >> /etc/profile \
    && echo 'alias tfr="tf refresh"' >> /etc/profile \
    && echo 'alias rmt="rm -rf .terraform* && tfi && tfp"' >> /etc/profile \
    && echo 'alias tfmtc="terraform fmt -check -diff"' >> /etc/profile \
    && echo 'alias tfmtw="terraform fmt -write=true"' >> /etc/profile \
    && echo 'alias c="clear"' >> /etc/profile \
    && echo alias tfwork="'_tfwork(){ export TF_WORKSPACE="'$@'";}; _tfwork'" >> /etc/profile \
    && tfenv use latest
CMD /bin/bash -l

#Add kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
    && kubectl version --short --client \
    && export KUBECONFIG="~/.kube/config" \
    && echo 'export KUBE_CONFIG="/root/.kube/config"' >> /etc/profile \
    && echo 'export KUBECONFIG="/root/.kube/config"' >> /etc/profile \
    && echo 'alias k="kubectl --kubeconfig /root/.kube/config"' >> /etc/profile \
    && echo 'alias kall="c && k get all -o wide --all-namespaces"' >> /etc/profile \
    && echo 'alias kp="c && k get pods -o wide --all-namespaces"' >> /etc/profile \
    && echo 'alias klb="c && k logs -n kube-system $(kubectl get po -n kube-system | egrep -o alb-ingress[a-zA-Z0-9-]+)"' >> /etc/profile \
    && echo 'alias kns="c && k logs -n kube-system $(kubectl get po -n kube-system | egrep -o external[a-zA-Z0-9-]+)"' >> /etc/profile \
    && echo 'alias gettoken="aws eks get-token --cluster-name glrunner-cluster | jq -r '.status.token'"' >> /etc/profile
CMD /bin/bash -l

#Add aws-iam-authenticator
RUN curl -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/aws-iam-authenticator \
    && chmod +x /usr/local/bin/aws-iam-authenticator \
    && aws-iam-authenticator version

#Add terraform-docs
RUN yum install -y go \
#    && GO111MODULE="on" go get github.com/segmentio/terraform-docs@v0.9.1 \
    && GO111MODULE="on" go get github.com/terraform-docs/terraform-docs@v0.10.0-rc.1 \
    && mv ~/go/bin/terraform-docs /bin/ \
    && echo 'source <(/bin/terraform-docs completion bash)' >> /etc/profile

#Install HELM
RUN yum install -y openssl \
    && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh

#Install k8yaml to tf
RUN git clone https://github.com/sl1pm4t/k2tf.git \
    && cd k2tf \
    && make build \
    && mv k2tf /usr/local/bin \
    && cd ../ && rm -rf k2tf

#Add tflint
RUN curl -L "$(curl -Ls https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" -o tflint.zip \
    && unzip tflint.zip \
    && rm tflint.zip \
    && mv tflint /usr/local/bin/tflint \
    && tflint -v

#Add Scenery
RUN go get github.com/dmlittle/scenery \
    && mv ~/go/bin/scenery /bin/

#Add iam-policy-json-to-terraform
RUN curl -L "$(curl -sL https://api.github.com/repos/flosell/iam-policy-json-to-terraform/releases/latest | jq -r '.assets[].browser_download_url' |grep 64)" -o /usr/local/bin/iam2tf \
    && chmod 755 /usr/local/bin/iam2tf

#Add "hey" load tester
RUN go get -u github.com/rakyll/hey \
    && mv ~/go/bin/hey /bin/

#Add K9s
RUN k9ver=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') \
    && wget https://github.com/derailed/k9s/releases/download/$k9ver/k9s_Linux_x86_64.tar.gz \
    && tar -xvf k9s_Linux_x86_64.tar.gz \
    && mv k9s /usr/local/bin/k9s \
    && rm -rf k9s_Linux_x86_64.tar.gz

#Add KREW
RUN set -x; cd "$(mktemp -d)" \
    && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" \
    && tar zxvf krew.tar.gz \
    && KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" \
    && "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz \
    && "$KREW" update \
    && export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" \
    && export PATH="${PATH}:${HOME}/.krew/bin"

#Add copilot
RUN curl -Lo /usr/local/bin/copilot https://github.com/aws/copilot-cli/releases/download/v0.3.0/copilot-linux-v0.3.0 && chmod +x /usr/local/bin/copilot

#Set bash prompt
RUN echo 'export PS1="\e[0;36m\A\e[m-\e[0;33m\D{%m.%d}\e[m-\w \n\$ "' >> /root/.bash_profile

