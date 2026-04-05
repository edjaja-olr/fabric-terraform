locals {
  # ── Naming convention: {env}-{project}-{layer}
  name_prefix = "${var.environment}-${var.project_name}"

  # Fabric Capacity name (lowercase alphanum only, 3-63 chars)
  capacity_name = lower(replace("fc${var.environment}${var.project_name}", "-", ""))

  # Medallion layer definitions – drives workspace + lakehouse creation
  medallion_layers = {
    bronze = {
      display_name = "${local.name_prefix}-bronze"
      description  = "Bronze layer – raw data ingestion. Preserves source fidelity with no transformations."
      lakehouse    = "${local.name_prefix}-lh-bronze"
      order        = 1
    }
    silver = {
      display_name = "${local.name_prefix}-silver"
      description  = "Silver layer – cleansed, conformed, and deduplicated data ready for analytics."
      lakehouse    = "${local.name_prefix}-lh-silver"
      order        = 2
    }
    gold = {
      display_name = "${local.name_prefix}-gold"
      description  = "Gold layer – business-ready aggregates, semantic models, and serving layer."
      lakehouse    = "${local.name_prefix}-lh-gold"
      order        = 3
    }
  }

  # Common Azure tags
  common_tags = merge(var.tags, {
    environment = var.environment
    project     = var.project_name
  })
}
