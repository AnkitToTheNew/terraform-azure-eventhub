locals {
  networks_rules = {
    subnet_ids = var.allowed_subnet_ids
    cidrs      = var.allowed_cidrs
  }

  hubs_auth_rules = flatten([
    for hub_name, hub in try(var.hubs_parameters, {}) : [
      for rule in ["listen", "send", "manage"] : {
        hub_name       = hub_name
        hub            = hub
        rule           = rule
        custom_name    = hub.custom_name
        authorizations = hub.authorizations
      }
    ]
  ])
}

locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  namespace_name = coalesce(var.custom_namespace_name, data.azurecaf_name.eventhub_namespace.result)
}

locals {
  default_tags = var.default_tags_enabled ? {
    env   = var.environment
    stack = var.stack
  } : {}
  tags = merge(local.default_tags, var.extra_tags)
}
