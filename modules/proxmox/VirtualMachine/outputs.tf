output "vm_id" {
  description = "The unique Proxmox VM ID assigned to the created virtual machine."
  value       = proxmox_vm_qemu.vm.id
}

output "vm_name" {
  description = "The name of the created virtual machine."
  value       = proxmox_vm_qemu.vm.name
}

output "node" {
  description = "Proxmox node where the VM is deployed."
  value       = var.node
}

output "vm_ip" {
  description = "The static IP address assigned to the VM."
  value       = var.ip
}

output "vm_networks" {
  description = "List of network interfaces configured for the VM."
  value       = var.networks
}

output "vm_status" {
  description = "The current status of the VM in Proxmox."
  value       = proxmox_vm_qemu.vm.status
}
