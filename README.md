# Azure IAM Incident Lab (Senior) — Terraform

A production automation identity is being used across multiple environments and regions. After a routine access review, multiple teams report:
- unexpected authorization success for actions outside the intended change window,
- inconsistent access behavior between primary and secondary regions,
- audit findings that the automation identity can perform high-risk operations and holds broad privileges.

Your job is to restore least privilege while preserving necessary operational capabilities and maintaining parity across regions.

## Guardrail

This repo is expected to **fail** the guardrail in its initial state.

- Failure string (must match CI and local runner): **`guardrail unmet: least-privilege policy violation`**
- Success string: **`guardrail met`**

Run locally:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python3 scripts/guardrails/run.py
```

## Terraform validation

```bash
terraform -chdir=senior/terraform fmt
terraform -chdir=senior/terraform init -backend=false
terraform -chdir=senior/terraform validate
```

## Deliverables (evidence)

Provide an evidence bundle that includes the following:
- policy diff
- deny/allow matrix
- plan/state json with role definitions
- assignable scope evidence
- kv/secret access matrix
- secondary region provider alias
- cross-region role parity evidence

## Scenario sources

- Catalog entry: **cat-clean-0161** (Azure / terraform / security/iam)
- Sampled incident metadata (sanitized):
  - 2025-Q2 / IAM / Senior
  - 2024-Q1 / IAM / Senior
  - 2025-Q2 / IAM / Senior

## Notes

- This is an incident-style practice repo: CI should pass Terraform formatting and validation but fail the guardrail until remediations are complete.
