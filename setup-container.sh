#!/bin/bash
# script that runs 
# https://kubernetes.io/docs/setup/production-environment/container-runtime


##### CentOS 7 config
echo setting up CentOS 7 with Docker 
yum install -y vim yum-utils device-mapper-persistent-data lvm2
echo adding repo
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# notice that only verified versions of Docker may be installed
# verify the documentation to check if a more recent version is available
echo install docker-ce
yum install -y docker-ce

echo make docker directory


mkdir -p /etc/docker
echo make directory to docker service

mkdir -p /etc/systemd/system/docker.service.d

echo cat json

cat > /etc/docker/daemon.json <<- EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF


systemctl daemon-reload
systemctl restart docker
systemctl enable docker
