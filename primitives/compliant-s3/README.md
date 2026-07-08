# Compliant S3 Primitive

This module deploys a NIST 800-53 compliant AWS S3 bucket with machine-readable compliance evidence.

## Controls enforced

- **SC-28** — AES-256 server-side encryption on all objects at rest
- **AC-3** — All four public access block flags enabled, no public exposure possible
- **CM-6** — Versioning enabled, required compliance tags applied to every resource via provider default_tags
- **AU-3 / AU-6** — S3 server access logging enabled, logs delivered to a separate encrypted log bucket

## Evidence

Run `terraform show -json > evidence/state.json` after apply to generate machine-readable compliance evidence. No screenshots needed.