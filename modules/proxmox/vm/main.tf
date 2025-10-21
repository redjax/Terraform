resource "proxmox_vm_qemu" "vm" {
    name = var.name
    target_node = var.node
    clone = var.template
    full_clone = var.full_clone
    cores = var.cores
    memory = var.memory

    disk {
        size = var.disk_size
        type = var.disk_type
        storage = var.host_storage
    }

    dynamic "network" {
        for_each = var.networks
        content {
            bridge = network.value.bridge
            model = network.value.model
            tag = try(network.value.tag, null)
        }
    }

    ipconfig0 = "ip=${var.ip},gw=${var.gateway},dns=${var.dns},dnssearch=${var.dns_search}"

    bootdisk = var.bootdisk
    agent    = var.enable_agent ? 1 : 0
    onboot   = var.autostart
}