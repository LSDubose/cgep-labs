# Compliant GCS Bucket Module

A reusable Terraform module that deploys a NIST 800-53 compliant 
Google Cloud Storage bucket with customer-managed encryption keys 
and machine-readable compliance attestation.

## Controls enforced

- **SC-12** — Customer-managed KMS keyring and crypto key. You own 
  the key, not Google.
- **SC-13 / SC-28** — CMEK AES-256 encryption at rest with automatic 
  90-day key rotation.
- **AC-3** — Uniform bucket-level access enforced. Public access 
  prevention set to enforced on every deployment.
- **AU-11** — Configurable object retention policy. Production 
  environments require a minimum of 365 days — enforced at plan time.
- **CM-6** — Four required compliance labels applied to every bucket 
  automatically. Consumers can add labels but cannot remove the 
  required ones.

## Usage

```hcl
module "data_bucket" {
  source = "../../modules/compliant-gcs-bucket"

  gcp_project        = "your-gcp-project"
  project_label      = "cgep-lab"
  environment        = "dev"
  retention_days     = 30
  bucket_name_suffix = "unique-suffix"
}
```

## Inputs

| Name | Description | Required |
|------|-------------|----------|
| gcp_project | GCP project ID | yes |
| project_label | Short project identifier | yes |
| environment | dev, staging, or prod | yes |
| retention_days | Object retention in days | yes |
| bucket_name_suffix | Globally unique bucket suffix | yes |
| location | GCS bucket location | no |
| kms_location | KMS keyring region | no |
| labels | Additional labels | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_url | gs:// URL of the bucket |
| bucket_self_link | Self-link of the bucket |
| kms_key_id | Resource ID of the CMEK key |
| compliance_attestation | Machine-readable control attestation |

## Evidence

After apply, capture attestation with:
```bash
terraform output -json attestation > evidence/attestation.json
```