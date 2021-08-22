echo "[TASK 1] Enabling Swap off, fstab swap remove & firewall disable"
sudo sed -i '/ swap / s/^/#/' /etc/fstab
sudo swapoff -a
sudo systemctl disable --now ufw

echo "[TASK 2] Adding kernel settings"
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl -p

echo "[TASK 3] Installing other softwares & Adding Docker repo"
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release\
    htop \
    vim \
    bash-completion \
    net-tools \
    unzip \
    tree
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[TASK 4] Docker installation"
sudo apt update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo apt-mark hold docker-ce
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

echo "[TASK 5] Add apt repo for k8s"
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/dev/null 2>&1

echo "[TASK 6] Installation of k8s components"
sudo apt-get update
sudo apt-get install -y kubelet=1.21.2-00 kubeadm=1.21.2-00 kubectl=1.21.2-00
sudo apt-mark hold kubelet kubeadm kubectl

echo "[TASK 7] kubectl bash completion"
echo "source <(k completion bash)" >> ~/.bashrc
echo "alias k=kubectl" >> /etc/bash.bashrc
echo "complete -F __start_kubectl k" >>  ~/.bashrc 

echo "[TASK 8] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
service sshd restart