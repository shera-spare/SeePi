RASPBERRY PI AUFSETZEN!
(https://wiki.learnlinux.tv/index.php/Setting_up_a_Raspberry_Pi_Kubernetes_Cluster_with_Ubuntu_20.04)
(https://wiki.learnlinux.tv/index.php/Building_a_10_Node_Raspberry_Pi_Kubernetes_Cluster)

a)
Flashen!
BalenaEtcher (Balena suchen!)
Image + Sd KArte;

b)
Raspberry aufsetzen
Deutsches Layout:

sudo nano /etc/default/keyboard
XKBLAYOUT=”us” zu XKBLAYOUT=”de”

Temperatur:
cat /sys/class/thermal/thermal_zone0/temp

c)
Raspberry umbenennen:
sudo nano /etc/hostname
sepi-0X
sudo nano /etc/hosts
unter 
127.0.0.1 ...
127.0.1.1 sepi-0X


d) updaten
sudo apt-get update
sudo apt-get upgrade


e) neuer nutzer
sudo adduser sebi
sudo usermod -aG sudo sebi

f) install docker
curl -sSL get.docker.com | sh

g) add user to docker usergroup!
sudo usermod -aG docker sebi

h) docker-compose:
https://dev.to/elalemanyo/how-to-install-docker-and-docker-compose-on-raspberry-pi-1mo
Step 4!;
sudo apt-get install libffi-dev libssl-dev
(python3-dev war installiert;
https://askubuntu.com/questions/423355/how-do-i-check-if-a-package-is-installed-on-my-server
dpkg -l python3-dev)

ABER pip nicht installiert!
sudo apt-get install -y python3-pip

i) GITHUB INTERMEZZO
https://stackoverflow.com/questions/41689395/how-to-change-git-account-in-git-bash
https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token
https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/


j) 
https://www.youtube.com/watch?v=TeKKExBWiog
pihole auf docker!
https://forum-raspberrypi.de/forum/thread/49428-pihole-und-vodafone-station/
https://goneuland.de/pi-hole-mit-docker-compose-und-traefik-installieren/
https://hub.docker.com/r/pihole/pihole
https://discourse.pi-hole.net/t/dhcp-with-docker-compose-and-bridge-networking/17038


k)
what is portainer?

l)
traeffic?
https://goneuland.de/traefik-v2-reverse-proxy-fuer-docker-unter-debian-10-einrichten/

m)
https://jordancrawford.kiwi/rpi-home-server/

n)
FANS!
Ubuntu!
https://raspberrypi.stackexchange.com/questions/98078/poe-hat-fan-activation-on-os-other-than-raspbian
https://www.raspberrypi.org/forums/viewtopic.php?t=313098

https://www.raspberrypi.org/forums/viewtopic.php?t=313098
What worked for me:
sudo apt-get install libraspberrypi-bin
sudo nano /boot/firmware/usercfg.txt

dtoverlay=rpi-poe
dtparam=poe_fan_temp0=10000,poe_fan_temp0_hyst=1000
dtparam=poe_fan_temp1=55000,poe_fan_temp1_hyst=5000
dtparam=poe_fan_temp2=60000,poe_fan_temp2_hyst=5000
dtparam=poe_fan_temp3=65000,poe_fan_temp3_hyst=5000

sudo reboot

cat /sys/class/thermal/thermal_zone0/temp

o)
der anleitung weiter folgen:
https://wiki.learnlinux.tv/index.php/Setting_up_a_Raspberry_Pi_Kubernetes_Cluster_with_Ubuntu_20.04
Configure boot options
Edit /boot/firmware/cmdline.txt and add:

cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1

Set Docker daemon options
Edit the daemon.json file (this file most likely won't exist yet)

 sudo nano /etc/docker/daemon.json
 {
   "exec-opts": ["native.cgroupdriver=systemd"],
   "log-driver": "json-file",
   "log-opts": {
     "max-size": "100m"
   },
   "storage-driver": "overlay2"
 }
Enable routing
Find the following line in the file:

/etc/sysctl.conf

 #net.ipv4.ip_forward=1

 Add Kubernetes repository
 sudo nano /etc/apt/sources.list.d/kubernetes.list
Add:

 deb http://apt.kubernetes.io/ kubernetes-xenial main
Add the GPG key to the Pi:

 curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
Install required Kubernetes packages
 sudo apt update
 sudo apt install kubeadm kubectl kubelet


 und dann nur aufm boss:
  sudo kubeadm init --pod-network-cidr=10.244.0.0/16

LINE UM ZU JOINEN!
kubeadm join 192.168.0.66:6443 --token c315c0.x6c6wrtbsfeumum9 \
        --discovery-token-ca-cert-hash sha256:ec95663b9d1080613f8132c34a8a857ba015114c0de9f2e410baec66900b8f6f

# hat bei mir ein sudo benötigt!

Befehle, die mir kubernetes sagt:
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Next:
Flannel network driver?
    https://github.com/flannel-io/flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
