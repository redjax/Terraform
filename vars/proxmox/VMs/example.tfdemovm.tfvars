name         = "my-vm-01"
node         = "proxmox-node1"
template     = "tf-template-deb12"
full_clone   = true
cores        = 2
memory       = 1024
disk_size    = "20G"
disk_type    = "virtio"
host_storage = "local-lvm"

networks = [
  {
    bridge = "vmbr0"
    model  = "virtio"
  }
]

ip         = "192.168.1.50/24"
gateway    = "192.168.1.1"
dns        = "1.1.1.1 9.9.9.9"
dns_search = "localdomain"

bootdisk     = "virtio0"
enable_agent = true
autostart    = false
