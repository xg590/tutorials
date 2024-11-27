* login-3 [192.168.11.1]
```
sudo apt update -y && sudo apt install -y docker.io
sudo mkdir /home/share/docker/root
cat << EOF | sudo tee /etc/docker/daemon.json  
{ 
  "data-root": "/home/share/docker/root"
}
docker info -f '{{ .DockerRootDir}}'
EOF
sudo systemctl daemon-reload && sudo systemctl restart docker

sudo usermod -aG docker $USER
docker load < ubuntu22.04.tgz
docker load < registry2.8.3.tgz 
docker tag ubuntu:22.04 localhost:5000/ubuntu:22.04
docker run -d -p 5000:5000 --name registry registry:2.8.3 
docker push localhost:5000/ubuntu:22.04
docker logs -f registry
```
* node-17 [192.168.11.17]
```
sudo apt update -y && sudo apt install -y docker.io 
cat << EOF | sudo tee /etc/docker/daemon.json  
{
  "insecure-registries" : [ "192.168.0.0/16" ],
  "registry-mirrors": [ "http://192.168.11.1:5000" ]
}
EOF
sudo systemctl daemon-reload && sudo systemctl restart docker

sudo usermod -aG docker $USER
docker pull 192.168.11.1:5000/ubuntu:22.04
docker pull ubuntu
curl http://192.168.11.1:5000/v2/_catalog
```

export LD_LIBRARY_PATH=/opt/pywfn/libs