# Setup Guide – Microsoft Fabric Terraform Deployment

This guide walks through all prerequisites before running `terraform apply` for the first time.

---

## 1. Create an App Registration (Service Principal)

In the [Azure Portal](https://portal.azure.com) → **Entra ID → App registrations → New registration**:

1. Name: `sp-fabric-terraform-demo`
2. Supported account types: **Single tenant**
3. Click **Register**

Save the **Application (client) ID** and **Directory (tenant) ID** — you'll need them.

### Create a client secret

App registrations → your app → **Certificates & secrets → New client secret**

- Description: `terraform-demo`
- Expires: 12 months

Save the **Value** immediately (shown only once).

---

## 2. Grant Azure RBAC on the Subscription

In the Azure Portal → **Subscriptions → your subscription → Access control (IAM) → Add role assignment**:

- Role: `Contributor`
- Members: your Service Principal (`sp-fabric-terraform-demo`)

This is required to create the Resource Group and Fabric Capacity.

---

## 3. Grant Fabric Capacity Admin Access

The Service Principal needs access to administer Fabric workspaces.

**Option A – Fabric Admin Portal (recommended for least-privilege):**

1. Go to [https://app.fabric.microsoft.com/admin](https://app.fabric.microsoft.com/admin)
2. Navigate to **Capacity settings → your F64 capacity → Admins**
3. Add the Service Principal object ID

**Option B – Azure RBAC on the Fabric Capacity resource:**

```bash
# After the capacity is created, grant Contributor on the capacity resource
CAPACITY_ID=$(az fabric capacity show \
  --resource-group rg-demo-medallion-fabric \
  --name fcdemomedallion \
  --query id -o tsv)

az role assignment create \
  --assignee "<your-spn-object-id>" \
  --role "Contributor" \
  --scope "$CAPACITY_ID"
```

---

## 4. Create the Terraform State Backend

```bash
# Variables
RG="rg-terraform-state"
SA="sttfabricstate"    # Must be globally unique
CONTAINER="tfstate"
LOCATION="eastus"

# Create resources
az group create --name $RG --location $LOCATION
az storage account create --name $SA --resource-group $RG \
  --location $LOCATION --sku Standard_LRS \
  --allow-blob-public-access false \
  --min-tls-version TLS1_2

az storage container create --name $CONTAINER \
  --account-name $SA \
  --auth-mode login
```

Update `versions.tf` → `backend "azurerm"` block with your actual `storage_account_name`.

---

## 5. Verify the Terraform Provider

```bash
# Check provider is accessible
terraform providers

# Expected output:
# provider[registry.terraform.io/microsoft/fabric] ~> 1.9
# provider[registry.terraform.io/hashicorp/azurerm] ~> 4.0
# provider[registry.terraform.io/hashicorp/azuread] ~> 3.0
```

---

## 6. Configure GitHub Actions Secrets

In your GitHub repo → **Settings → Secrets and variables → Actions → New repository secret**:

| Name | Value |
|------|-------|
| `AZURE_SUBSCRIPTION_ID` | Your Azure Subscription ID |
| `AZURE_TENANT_ID` | Your Entra Tenant ID |
| `AZURE_CLIENT_ID` | Service Principal Client ID |
| `AZURE_CLIENT_SECRET` | Service Principal Client Secret |

---

## 7. Create the GitHub Environment

In your GitHub repo → **Settings → Environments → New environment**:

- Name: `demo`
- Enable **Required reviewers** and add yourself

This creates a manual approval gate before `terraform apply` runs in CI/CD.

---

## 8. First Deployment

```bash
# Clone the repo
git clone https://github.com/edjaja-olr/fabric-terraform.git
cd fabric-terraform

# Set secrets as env vars
export TF_VAR_azure_subscription_id="<subscription-id>"
export TF_VAR_azure_tenant_id="<tenant-id>"
export TF_VAR_spn_client_id="<client-id>"
export TF_VAR_spn_client_secret="<client-secret>"

# Init, plan, apply
terraform init
terraform plan -var-file="environments/demo/terraform.tfvars"
terraform apply -var-file="environments/demo/terraform.tfvars"
```

After apply, Terraform prints workspace portal links:

```
fabric_portal_links = {
  "bronze" = "https://app.fabric.microsoft.com/groups/<workspace-id>"
  "silver" = "https://app.fabric.microsoft.com/groups/<workspace-id>"
  "gold"   = "https://app.fabric.microsoft.com/groups/<workspace-id>"
}
```
