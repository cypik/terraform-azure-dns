provider "azurerm" {
  features {}
}

locals {
  name        = "app"
  environment = "test"
}

module "resource_group" {
  source      = "cypik/resource-group/azure"
  version     = "1.0.3"
  name        = "app"
  environment = "tested"
  location    = "North Europe"
}


module "vnet" {
  source              = "cypik/vnet/azure"
  version             = "1.0.3"
  name                = "app"
  environment         = "test"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.0.0.0/16"
}


module "dns_zone" {
  depends_on                   = [module.resource_group, module.vnet]
  source                       = "../"
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
