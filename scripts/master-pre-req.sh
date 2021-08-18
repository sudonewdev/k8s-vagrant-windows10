POD_CIDR=$1
API_IP=$2

echo "[TASK 1] k8s cluster images pull and init"
sudo kubeadm config images pull
sudo kubeadm init  --apiserver-advertise-address=$API_IP --pod-network-cidr=$POD_CIDR >> /root/kubeinit.log 2>/dev/null

echo "[TASK 2] Correct internal ip for the nodes"
ETH0=$(ip -f inet addr show eth1 | grep -Po 'inet \K[\d.]+')
sudo sed -i "s/^ExecStart=\/usr\/bin\/kubelet.*/&  --node-ip $ETH0/"  /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload && sudo systemctl restart kubelet

echo "[TASK 3] Configure kubectl"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# for vagrant user
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config
# for root user
mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kubeconfig
sudo chown $(id -u root):$(id -g root) /root/.kube/config

echo "[TASK 4] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 5] Create join command"
kubeadm token create --print-join-command > /vagrant_data/join.sh
chmod +x /vagrant_data/join.sh

echo "[TASK 6] Install MetalLB"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/metallb.yaml
kubectl apply -f scripts/metallb_configmap.yaml