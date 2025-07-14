# Azure VM Deployment Bicep Template Explanation

This document explains the purpose, structure, and best practices implemented in the `main.bicep` template for deploying a secure Azure Virtual Machine (VM).

## Purpose
The Bicep template automates the deployment of a Windows Server VM in Azure, following security and operational best practices. It is designed for flexibility, security, and maintainability.

## Key Features
- **Managed Identity**: The VM is assigned a system-managed identity for secure access to Azure resources without hardcoded credentials.
- **No Hardcoded Secrets**: Admin credentials are passed as parameters, with the password marked as `@secure()` to prevent exposure.
- **Boot Diagnostics**: Enabled for troubleshooting and monitoring VM health.
- **Configurable Parameters**: VM name, size, OS disk size, admin credentials, and subnet are all configurable.
- **No Public IP by Default**: The VM is deployed without a public IP for enhanced security. You can add one if needed.

## Parameters
- `location`: Azure region for deployment (defaults to resource group location).
- `vmName`: Name of the VM (default: `mySecureVM`).
- `adminUsername`: Administrator username for the VM.
- `adminPassword`: Administrator password (secure parameter).
- `vmSize`: VM size (default: `Standard_B2s`).
- `osDiskSizeGB`: OS disk size in GB (default: 64).
- `subnetId`: Resource ID of the subnet for the VM's NIC.

## Resources Deployed
- **Virtual Machine (`Microsoft.Compute/virtualMachines`)**: Configured with managed identity, Windows Server 2022 image, premium OS disk, and boot diagnostics.
- **Network Interface (`Microsoft.Network/networkInterfaces`)**: Connects the VM to the specified subnet.

## Security Considerations
- Credentials are never hardcoded; use Azure Key Vault or GitHub secrets for secure parameter passing.
- Managed identity is enabled for secure resource access.
- No public IP is assigned by default, reducing attack surface.

## Usage Instructions
1. **Prepare a Subnet**: Ensure you have an existing VNet and subnet. Pass the subnet's resource ID as `subnetId`.
2. **Set Admin Credentials**: Provide `adminUsername` and `adminPassword` securely (never commit secrets).
3. **Customize VM Size and Disk**: Adjust `vmSize` and `osDiskSizeGB` as needed for your workload.
4. **Deploy**: Use Azure CLI, Bicep CLI, or GitHub Actions to deploy the template.

## Example Deployment Command
```sh
az deployment group create \
  --resource-group <your-resource-group> \
  --template-file infra/main.bicep \
  --parameters adminUsername=<username> adminPassword=<password> subnetId=<subnet-resource-id>
```

## Best Practices Followed
- Infrastructure as Code (IaC) for repeatable, auditable deployments
- Secure parameter handling
- Resource separation and clear organization
- Comments for maintainability

## Extending the Template
- To add a public IP, create a `Microsoft.Network/publicIPAddresses` resource and attach it to the NIC.
- To use Linux, change the image reference and adjust OS profile parameters.
- For advanced security, integrate with Azure Key Vault for secrets and certificates.

---
For more details, see [Azure VM documentation](https://learn.microsoft.com/azure/virtual-machines/) and [Bicep documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/).
