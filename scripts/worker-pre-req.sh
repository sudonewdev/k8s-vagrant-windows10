POD_CIDR=$1
echo "[TASK 1] Join node to Kubernetes Cluster"
sh /vagrant_data/join.sh

########### correct internal ip for the kubelet
#ETH0=$(ip -f inet addr show eth1 | grep -Po 'inet \K[\d.]+')
#sudo sed -i "s/^ExecStart=\/usr\/bin\/kubelet.*/&  --node-ip $ETH0/"  /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
#sudo systemctl daemon-reload && sudo systemctl restart kubelet
