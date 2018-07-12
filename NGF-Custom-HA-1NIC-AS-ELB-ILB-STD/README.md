# Barracuda CloudGen Firewall Custom High Availability with Azure Standard Load Balancer

## Introduction
This Azure Resource Manager (ARM) template will deploy a cluster of Barracuda CloudGen Firewall virtual machines in an existing VNET. Deployment is done with in a one-armed fashion where north-south, east-west and VPN tunnel traffic can be intercepted and inspected based on the User Defined Routing that is attached to the subnets that need this control. Additionally this template will deploy a Azure Load Balancer with an external IP to direct the traffic to the active unit in the cluster. Do not apply any UDR to the subnet where the CGF is located that points back to the CGF. This will cause routing loops.

To adapt this deployment to your requirements you can modify the azuredeploy.paramters.json file and/or the deployment script in Powershell or Azure CLI (Bash).

![CGF Azure Network Architecture](images/ngf-ha.png)

## Prerequisites
The solution does a check of the template when you use the provide scripts. It does require that [Programmatic Deployment](https://azure.microsoft.com/en-us/blog/working-with-marketplace-images-on-azure-resource-manager/) is enabled for the Barracuda CloudGen Firewall BYOL or PAYG images. Barracuda recommends use of **D**, **D_v2**, **F** or newer series. 

It is not possible to connect the Azure Basic Load Balancer and the Azure Standard Load Balancer to the same VM or Availability Set. This is a limitation of the Azure Platform.

## Deployed resources
Following resources will be created by the template:
- One route table that will route all traffic for networks except for the internal networks to the CGF
- Two Virtual machines with a network interface and public IP in a Availability Set
- One external Azure Standard Load Balancer containing the deployed virtual machines with a public IP and services for IPSEC and TINA VPN tunnels available
- One internal Azure Standard Load Balancer containing the deployed virtual machines 1 load balancing rule directing all UDP and TCP traffic to the active firewall (HA Ports).

**Note** The backend subnets and resources are *not* automatically created by the template. This has to be done manually after template deployment has finished.

## Template Parameters
| Parameter Name | Description
|---|---
adminPassword | Password for the CloudGen Admin tool 
prefix | identifying prefix for all VM's being build. e.g WeProd would become WeProd-VM-CGF (Max 19 char, no spaces, [A-Za-z0-9]
vNetResourceGroup | Resource Group that contains the VNET where the CGF will be installed in
vNetName | The name of the VNET where the CGF will be installed in
subnetNameCGF | The name of the subnet where CGF will be installed
subnetPrefixCGF | Network range of the Subnet containing the CloudGen Firewall (e.g. 172.16.136.0/24)
imageSKU | SKU Hourly (PAYG) or BYOL (Bring your own license)
vmSize | Size of the VMs to be created
fwVMAddressA | Static IP Address of the first CGF VM in Azure
fwVMAddressB | Static IP Address of the second CGF VM in Azure
ccManaged | Is this instance managed via a CloudGen Control Center (Yes/No)
ccClusterName | The name of the cluster of this instance in the CloudGen Control Center
ccRangeId | The range location of this instance in the CloudGen Control Center
ccIpAddress | IP address of the CloudGen Control Center
ccSecret | Secret to retrieve the configuration from the CloudGen Control Center

## Launching the Template

The package provides a deploy.ps1 and deploy.sh for Powershell or Azure CLI based deployments. This can be peformed from the Azure Portal as well as the any system that has either of these scripting infrastructures installed. Or you can deploy from the Azure Portal using the provided link.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjvhoof%2Fngf-azure-templates%2Fmaster%2FNGF-Custom-HA-1NIC-AS-ELB-ILB-STD%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fjvhoof%2Fngf-azure-templates%2Fmaster%2FCGF-Custom-HA-1NIC-AS-ELB-ILB-STD%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

## Additional Resources