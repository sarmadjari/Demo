// main.bicep
// Bicep file to deploy a secure Azure Virtual Machine (VM)
// Follows Azure code generation and deployment best practices
// - Uses managed identity
// - No hardcoded credentials
// - Enables boot diagnostics
// - Configurable parameters for flexibility
// - Comments for key decisions

param location string = resourceGroup().location
param vmName string = 'mySecureVM'
param adminUsername string
@secure()
param adminPassword string
param vmSize string = 'Standard_B2s'
param osDiskSizeGB int = 64
param subnetId string

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter'
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        diskSizeGB: osDiskSizeGB
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
  }
}

// Usage:
// - Pass subnetId from an existing VNet/subnet
// - Set adminUsername and adminPassword securely
// - Customize vmSize and osDiskSizeGB as needed
// Security:
// - Uses managed identity for VM
// - No secrets in code
// - Boot diagnostics enabled for troubleshooting
// - No public IP by default (add if needed)
