Vagrant.configure("2") do |config|
    # This will be applied to every vagrant file that comes after it
    config.vm.box = "opensuse/Leap-15.2.x86_64"
    # K8s Node
    config.vm.define "rke" do |k8s_node|
      k8s_node.vm.provision "shell", path: "node_script.sh"
      k8s_node.vm.network "private_network", ip: "172.16.131.21" 
      k8s_node.vm.hostname = "rke"
      k8s_node.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--audio", "none"]
        v.memory = 4024
        v.cpus = 2
      end
    end
end
  