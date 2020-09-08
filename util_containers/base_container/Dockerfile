FROM amazonlinux:2 as installer

ENV SET_CONTAINER_TIMEZONE true
ENV CONTAINER_TIMEZONE America/New_York
ENV HOSTNAME amzlinux2
ENV EDITOR "/usr/bin/nano"

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && yum install -y unzip \
    && unzip awscliv2.zip \
    && ./aws/install --bin-dir /aws-cli-bin/ \
    && rm -rf awscliv2.zip

FROM amazonlinux:2

RUN yum update -y  \
    && yum install -y \
    git \
    wget \
    jq \
    unzip \
    mlocate\
    nano \
    which \
    sed \
    cronie \
    tar \
    net-tools \
    less \
    groff \
    openssh \
    awslogs \
    bind-utils \
    tree \
    nmap \
    zip \
    less \
    groff \
	traceroute \
    && cp /usr/share/zoneinfo/America/New_York /etc/localtime \
    && wget https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py  \
    && pip install requests \
    && pip install -U awscli aws-shell \
#    && pip install --upgrade awscli-cwlogs awscli aws-shell \
    && rm -rf /var/cache/yum \
    && echo "PS1='\w\n\$ '" > ~/.profile
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/
CMD /bin/bash -l


#lastver=$(date +"%m.%d")

#docker-squash -t reg.theclientcloud.org/publicrepo/docker/bases/awslnx reg.theclientcloud.org/publicrepo/docker/bases/awslnx
#docker tag reg.theclientcloud.org/publicrepo/docker/bases/awslnx reg.theclientcloud.org/publicrepo/docker/bases/awslnx:$lastver
#docker push reg.theclientcloud.org/publicrepo/docker/bases/awslnx
