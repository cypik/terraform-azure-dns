# Terraform-azure-dns

# Terraform Azure Cloud Dns Module

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [Authors](#authors)
- [License](#license)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This repository contains Terraform code to deploy resources on Microsoft Azure, including a resource group and a dns.

## Usage
To use this module, you should have Terraform installed and configured for AZURE. This module provides the necessary Terraform configuration
for creating AZURE resources, and you can customize the inputs as needed. Below is an example of how to use this module:

# Example: dns_zone

```hcl
module "dns_zone" {
  depends_on                   = [module.resource_group, module.vnet]
  source                       = "cypik/dns/azure"
  version                      = "1.0.3"
  name                         = local.name
  environment                  = local.environment
  resource_group_name          = module.resource_group.resource_group_name
  dns_zone_names               = "example0000.com"
  private_registration_enabled = true
  private_dns                  = true
  private_dns_zone_name        = "webserver0000.com"
  virtual_network_id           = module.vnet.id
  a_records = [{
    name    = "test"
    ttl     = 3600
    records = ["10.0.180.17", "10.0.180.18"]
  },
    {
      name    = "test2"
      ttl     = 3600
      records = ["10.0.180.17", "10.0.180.18"]
    }]

  cname_records = [{
    name   = "test1"
    ttl    = 3600
    record = "example.com"
  }]

  ns_records = [{
    name    = "test2"
    ttl     = 3600
    records = ["ns1.example.com.", "ns2.example.com."]
  }]
}
```
This example demonstrates how to create various AZURE resources using the provided modules. Adjust the input values to suit your specific requirements.

# Examples
For detailed examples on how to use this module, please refer to the [example](https://github.com/cypik/terraform-azure-dns/blob/master/_example) directory within this repository.

# License
This Terraform module is provided under the **MIT** License. Please see the [LICENSE](https://github.com/cypik/terraform-azure-dns/blob/master/LICENSE) file for more details.

# Authors
Your Name
Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15.8 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 5.4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 5.4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.9.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/azure | 1.0.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_dns_a_record.records_a](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_cname_record.records_cname](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record) | resource |
| [azurerm_dns_ns_record.records_ns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_private_dns_zone.private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_a_records"></a> [a\_records](#input\_a\_records) | List of a records to be added in azure dns zone. | `any` | `[]` | no |
| <a name="input_cname_records"></a> [cname\_records](#input\_cname\_records) | List of cname records | `any` | `[]` | no |
| <a name="input_dns_zone_names"></a> [dns\_zone\_names](#input\_dns\_zone\_names) | The public dns zone to be created for internal vnet resolution | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Flag to enable or disable the resource. When set to true, the resource will be created. | `bool` | `true` | no |
| <a name="input_enabled_dns"></a> [enabled\_dns](#input\_enabled\_dns) | Flag to enable or disable DNS settings for the resource. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(string)` | `{}` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'info@cypik.com' | `string` | `"info@cypik.com"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_ns_records"></a> [ns\_records](#input\_ns\_records) | List of ns records | <pre>list(object({<br>    name    = string,      #(Required) The name of the DNS NS Record. Changing this forces a new resource to be created.<br>    ttl     = number,      # (Required) The Time To Live (TTL) of the DNS record in seconds.<br>    records = list(string) #(Required) A list of values that make up the NS record.<br>  }))</pre> | `[]` | no |
| <a name="input_private_dns"></a> [private\_dns](#input\_private\_dns) | Flag to specify whether private DNS should be enabled. When set to true, private DNS will be used. | `bool` | `false` | no |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | The private dns zone to be created for internal vnet resolution | `string` | `null` | no |
| <a name="input_private_registration_enabled"></a> [private\_registration\_enabled](#input\_private\_registration\_enabled) | Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? | `bool` | `true` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/cypik/terraform-azure-dns"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the Azure DNS resides | `string` | `""` | no |
| <a name="input_soa_record"></a> [soa\_record](#input\_soa\_record) | Customize details about the root block device of the instance. See Block Devices below for details. | `list(any)` | `[]` | no |
| <a name="input_soa_record_private_dns"></a> [soa\_record\_private\_dns](#input\_soa\_record\_private\_dns) | Customize details about the root block device of the instance. See Block Devices below for details. | `list(any)` | `[]` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | The name of the virtual network | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_a_record_fqdn"></a> [dns\_a\_record\_fqdn](#output\_dns\_a\_record\_fqdn) | The FQDN of the DNS A Record. |
| <a name="output_dns_a_record_id"></a> [dns\_a\_record\_id](#output\_dns\_a\_record\_id) | The DNS A Record ID. |
| <a name="output_dns_cname_record_fqdn"></a> [dns\_cname\_record\_fqdn](#output\_dns\_cname\_record\_fqdn) | The FQDN of the DNS CNAME Record. |
| <a name="output_dns_cname_record_id"></a> [dns\_cname\_record\_id](#output\_dns\_cname\_record\_id) | The DNS CNAME Record ID. |
| <a name="output_dns_ns_record_fqdn"></a> [dns\_ns\_record\_fqdn](#output\_dns\_ns\_record\_fqdn) | The FQDN of the DNS NS Record. |
| <a name="output_dns_ns_record_id"></a> [dns\_ns\_record\_id](#output\_dns\_ns\_record\_id) | The DNS NS Record ID. |
| <a name="output_dns_zone_id"></a> [dns\_zone\_id](#output\_dns\_zone\_id) | The DNS Zone ID. |
| <a name="output_dns_zone_max_number_of_record_sets"></a> [dns\_zone\_max\_number\_of\_record\_sets](#output\_dns\_zone\_max\_number\_of\_record\_sets) | Maximum number of Records in the zone. Defaults to 1000. |
| <a name="output_dns_zone_name_servers"></a> [dns\_zone\_name\_servers](#output\_dns\_zone\_name\_servers) | A list of values that make up the NS record for the zone. |
| <a name="output_dns_zone_number_of_record_sets"></a> [dns\_zone\_number\_of\_record\_sets](#output\_dns\_zone\_number\_of\_record\_sets) | The number of records already in the zone. |
| <a name="output_private_dns_zone_id"></a> [private\_dns\_zone\_id](#output\_private\_dns\_zone\_id) | The Private DNS Zone ID. |
| <a name="output_private_dns_zone_max_number_of_record_sets"></a> [private\_dns\_zone\_max\_number\_of\_record\_sets](#output\_private\_dns\_zone\_max\_number\_of\_record\_sets) | The maximum number of record sets that can be created in this Private DNS zone. |
| <a name="output_private_dns_zone_max_number_of_virtual_network_links"></a> [private\_dns\_zone\_max\_number\_of\_virtual\_network\_links](#output\_private\_dns\_zone\_max\_number\_of\_virtual\_network\_links) | The maximum number of virtual networks that can be linked to this Private DNS zone. |
| <a name="output_private_dns_zone_max_number_of_virtual_network_links_with_registration"></a> [private\_dns\_zone\_max\_number\_of\_virtual\_network\_links\_with\_registration](#output\_private\_dns\_zone\_max\_number\_of\_virtual\_network\_links\_with\_registration) | The maximum number of virtual networks that can be linked to this Private DNS zone with registration enabled. |
| <a name="output_private_dns_zone_number_of_record_sets"></a> [private\_dns\_zone\_number\_of\_record\_sets](#output\_private\_dns\_zone\_number\_of\_record\_sets) | The current number of record sets in this Private DNS zone. |
| <a name="output_private_dns_zone_virtual_network_link_id"></a> [private\_dns\_zone\_virtual\_network\_link\_id](#output\_private\_dns\_zone\_virtual\_network\_link\_id) | The ID of the Private DNS Zone Virtual Network Link. |
<!-- END_TF_DOCS -->