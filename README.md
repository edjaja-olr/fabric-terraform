# Microsoft Fabric – Medallion Architecture (Terraform)

[![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.8-623CE4?logo=terraform)](https://www.terraform.io/)
[![Provider: microsoft/fabric](https://img.shields.io/badge/provider-microsoft%2Ffabric-0078D4?logo=microsoftazure)](https://registry.terraform.io/providers/microsoft/fabric/latest)
[![CI/CD](https://img.shields.io/github/actions/workflow/status/edjaja-olr/fabric-terraform/terraform-deploy.yml?label=deploy)](https://github.com/edjaja-olr/fabric-terraform/actions)

Infrastructure-as-Code for a production-grade **Microsoft Fabric** deployment using the official [`microsoft/fabric`](https://registry.terraform.io/providers/microsoft/fabric/latest) Terraform provider.

## Architecture

```
Azure Subscription
└── Resource Group: rg-demo-medallion-fabric
    └── Fabric Capacity: fcdemomedallion  (F64 – 64 CUs)
        ├── Workspace: demo-medallion-bronze   → Lakehouse: demo-medallion-lh-bronze
        ├── Workspace: demo-medallion-silver   → Lakehouse: demo-medallion-lh-silver
        └── Workspace: demo-medallion-gold     → Lakehouse: demo-medallion-lh-gold
```

### Medallion Layers

| Layer  | Purpose | RBAC |
|--------|---------|------|
| **Bronze** | Raw data ingestion — source-faithful, no transformations | Admin only |
| **Silver** | Cleansed, conformed & deduplicated data | Admin + Contributor |
| **Gold**   | Business-ready aggregates, semantic models, serving layer | Admin + Contributor + Viewer |

### Why F64?

- Required for **Managed Virtual Networks** and **trusted workspace ingestion**
- Unlocks **Copilot for Data Factory** and advanced AI features
- Recommended minimum for enterprise-grade data platform deployments

---

## Repository Structure

```
fabric-terraform/
├── main.tf                          # Root module – wires all child modules
├── versions.tf                      # Provider & backend configuration
├── variables.tf                     # All input variables with descriptions
├── locals.tf                        # Naming conventions & layer definitions
├── outputs.tf                       # Workspace IDs, Lakehouse IDs, portal links
│
├── modules/
│   ├── fabric-capacity/             # Azure Fabric Capacity (F-SKU)
│   ├── fabric-workspace/            # Fabric Workspace per medallion layer
│   ├── fabric-lakehouse/            # Lakehouse inside each workspace
│   └── fabric-rbac/                 # Workspace role assignments (Admin/Contributor/Viewer)
│
├── environments/
│   └── demo/
│       └── terraform.tfvars         # Demo environment variable values
│
├── .github/
│   └── workflows/
│       └── terraform-deploy.yml     # CI/CD: Validate → Plan → Apply → Destroy
│
└── docs/
    └── SETUP.md                     # Step-by-step prerequisites guide
```

---

## Prerequisites

1. **Azure Subscription** with permission to create resource groups and Fabric capacities
2. **Microsoft Fabric capacity** – F64 (Terraform does not support Trial capacities)
3. **Service Principal** (App Registration) with:
   - `Contributor` role on the Azure subscription (for capacity creation)
   - `Fabric Administrator` role in the Fabric Admin portal (for workspace management)
4. **Azure Storage Account** for Terraform remote backend (or comment out the `backend` block to use local state)
5. **Terraform ≥ 1.8** installed locally

See [`docs/SETUP.md`](docs/SETUP.md) for detailed step-by-step instructions.

---

## Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/edjaja-olr/fabric-terraform.git
cd fabric-terraform
```

### 2. Set environment variables

```bash
export TF_VAR_azure_subscription_id="<your-subscription-id>"
export TF_VAR_azure_tenant_id="<your-tenant-id>"
export TF_VAR_spn_client_id="<your-app-client-id>"
export TF_VAR_spn_client_secret="<your-app-client-secret>"
```

### 3. Update `environments/demo/terraform.tfvars`

Fill in:
- `capacity_admin_upns` – your UPN (e.g. `admin@contoso.com`)
- `workspace_admins`, `workspace_contributors`, `workspace_viewers` – Entra ID object IDs

### 4. Initialize Terraform

```bash
# If using Azure backend (recommended):
terraform init

# If testing locally without a remote backend, comment out the backend block in versions.tf first:
terraform init -backend=false
```

### 5. Plan

```bash
terraform plan -var-file="environments/demo/terraform.tfvars"
```

### 6. Apply

```bash
terraform apply -var-file="environments/demo/terraform.tfvars"
```

---

## CI/CD with GitHub Actions

The pipeline in `.github/workflows/terraform-deploy.yml` runs automatically:

| Trigger | Jobs |
|---------|------|
| Pull Request | Validate → Plan (posts output as PR comment) |
| Push to `main` | Validate → Plan → Apply (with `demo` environment approval gate) |
| Manual dispatch | Choose: `plan` / `apply` / `destroy` |

### Required GitHub Secrets

Set these in **Settings → Secrets and variables → Actions**:

| Secret | Description |
|--------|-------------|
| `AZURE_SUBSCRIPTION_ID` | Azure Subscription ID |
| `AZURE_TENANT_ID` | Entra ID Tenant ID |
| `AZURE_CLIENT_ID` | Service Principal Client ID |
| `AZURE_CLIENT_SECRET` | Service Principal Client Secret |

### GitHub Environment Setup

Create a GitHub Environment named `demo` (**Settings → Environments**) with required reviewers to enforce a manual approval gate before `terraform apply` executes.

---

## Outputs

After a successful apply:

| Output | Description |
|--------|-------------|
| `fabric_capacity_id` | Azure ARM ID of the F64 capacity |
| `fabric_capacity_name` | Capacity display name |
| `workspace_ids` | Map of `bronze/silver/gold → workspace GUID` |
| `workspace_display_names` | Map of layer → display name |
| `lakehouse_ids` | Map of layer → lakehouse GUID |
| `fabric_portal_links` | Direct Fabric portal URLs for each workspace |

---

## Customisation

| Want to… | How |
|----------|-----|
| Change capacity SKU | Set `capacity_sku = "F128"` in `.tfvars` |
| Add more workspaces | Extend `medallion_layers` in `locals.tf` |
| Enable lakehouse schemas | Set `enable_schemas = true` (preview feature) |
| Use a different environment | Duplicate `environments/demo/` and update values |
| Add Eventhouse / KQL Database | Add `fabric_eventhouse` resources per the [provider docs](https://registry.terraform.io/providers/microsoft/fabric/latest/docs) |

---

## Provider Versions

| Provider | Version | Notes |
|----------|---------|-------|
| `microsoft/fabric` | `~> 1.9` | GA since March 2025 |
| `hashicorp/azurerm` | `~> 4.0` | For capacity & resource group |
| `hashicorp/azuread` | `~> 3.0` | For Entra ID lookups |

---

## References

- [Terraform Provider for Microsoft Fabric – GA announcement](https://blog.fabric.microsoft.com/en-us/blog/terraform-provider-for-microsoft-fabric-now-generally-available)
- [Terraform Registry – microsoft/fabric](https://registry.terraform.io/providers/microsoft/fabric/latest/docs)
- [Fabric Capacity setup guide](https://library.tf/providers/microsoft/fabric/latest/docs/guides/fabric_capacity_setup)
- [Medallion Architecture in Microsoft Fabric](https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion)
- [azurerm_fabric_capacity resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/fabric_capacity)

---

## License

MIT – see [LICENSE](LICENSE)
