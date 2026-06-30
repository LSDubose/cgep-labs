# Compliance Policy Library

Rego policies that evaluate `terraform plan -json` output against 
NIST 800-53 controls before any resource is deployed.

## Policies

| Control | File | Severity | Enforces |
|---------|------|----------|----------|
| SC-28 | `sc28_encryption.rego` | High | Every `google_storage_bucket` has a non-empty `encryption { default_kms_key_name }` block. |
| AC-3 | `ac3_no_public.rego` | Critical | Buckets enforce `uniform_bucket_level_access=true` and `public_access_prevention="enforced"`. Firewalls don't expose ports 22 or 3389 to `0.0.0.0/0`. |
| CM-6 | `cm6_required_tags.rego` | Medium | Every taggable resource carries `project`, `environment`, `managed_by`, `compliance_scope`. |

## Remediation

Every deny message includes the resource address and the control ID, 
so a developer can fix their own violation without filing a ticket.

- **SC-28**: Add `encryption { default_kms_key_name = ... }` referencing 
  a `google_kms_crypto_key` you control.
- **AC-3**: Set `uniform_bucket_level_access = true` and 
  `public_access_prevention = "enforced"`. For firewalls, narrow 
  `source_ranges` or remove the rule.
- **CM-6**: Add the missing required labels to the resource.

## Usage

```bash
# Run all tests
opa test -v policies/

# Evaluate against a real plan
terraform show -json tfplan > plan.json
opa eval -d policies -i plan.json data.compliance.sc28.deny --format=pretty
opa eval -d policies -i plan.json data.compliance.ac3.deny  --format=pretty
opa eval -d policies -i plan.json data.compliance.cm6.deny  --format=pretty
```

## Test coverage

8 tests across 3 policies — each policy has at least one passing 
fixture and one failing fixture. Run `opa test -v policies/` to verify.