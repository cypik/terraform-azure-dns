
module "labels" {
  source      = "cypik/labels/azure"
  version     = "1.0.3"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
  extra_tags  = var.extra_tags
}


resource "random_id" "this" {
  byte_length = "8"
}

resource "azurerm_dns_zone" "dns_zone" {
  count               = var.enabled && var.enabled_dns ? 1 : 0
  name                = var.dns_zone_names
  resource_group_name = var.resource_group_name
  tags                = module.labels.tags

  dynamic "soa_record" {
    for_each = var.soa_record
    content {
      email        = lookup(soa_record.value, "email", null)
      expire_time  = lookup(soa_record.value, "expire_time", null)
      minimum_ttl  = lookup(soa_record.value, "minimum_ttl", null)
      refresh_time = lookup(soa_record.value, "refresh_time", null)
      retry_time   = lookup(soa_record.value, "retry_time", null)
      ttl          = lookup(soa_record.value, "ttl", null)
    }
  }

}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  count               = var.enabled && var.private_dns ? 1 : 0
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  dynamic "soa_record" {
    for_each = var.soa_record_private_dns
    content {
      email        = lookup(soa_record.value, "email", null)
      expire_time  = lookup(soa_record.value, "expire_time", null)
      minimum_ttl  = lookup(soa_record.value, "minimum_ttl", null)
      refresh_time = lookup(soa_record.value, "refresh_time", null)
      retry_time   = lookup(soa_record.value, "retry_time", null)
      ttl          = lookup(soa_record.value, "ttl", null)
    }
  }
  tags = module.labels.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_vnet_link" {
  count                = var.enabled && var.private_dns ? 1 : 0
  name                 = "vnet-link-${random_id.this.hex}"
  private_dns_zone_id  = join("", azurerm_private_dns_zone.private_dns_zone[*].id)
  registration_enabled = var.private_registration_enabled
  virtual_network_id   = var.virtual_network_id
  tags                 = module.labels.tags
}

resource "azurerm_dns_a_record" "records_a" {
  for_each            = { for record in var.a_records : record.name => record }
  name                = lookup(each.value, "name", null) # Required
  zone_name           = join("", azurerm_dns_zone.dns_zone[*].name)
  resource_group_name = var.resource_group_name
  ttl                 = lookup(each.value, "ttl", null)
  records             = lookup(each.value, "records", null)
  target_resource_id  = lookup(each.value, "target_resource_id", null)
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
## Below resource will add cname_record in DNS zone.
##-----------------------------------------------------------------------------
resource "azurerm_dns_cname_record" "records_cname" {
  for_each            = { for record in var.cname_records : record.name => record }
  name                = lookup(each.value, "name", null)
  zone_name           = join("", azurerm_dns_zone.dns_zone[*].name)
  resource_group_name = var.resource_group_name
  ttl                 = lookup(each.value, "ttl", null)
  record              = lookup(each.value, "record", null)
  target_resource_id  = lookup(each.value, "target_resource_id", null)
  tags                = module.labels.tags

}

resource "azurerm_dns_ns_record" "records_ns" {
  for_each = { for record in var.ns_records : record.name => record }

  name                = each.value.name
  zone_name           = join("", azurerm_dns_zone.dns_zone[*].name)
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
  tags                = module.labels.tags
}