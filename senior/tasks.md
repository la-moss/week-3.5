# Senior Tasks — Azure IAM / Terraform

## Constraints
- Prove the symptom before any change.
- Keep blast radius low; smallest scope first.
- Document rollback and approvals before applying changes.
- Remediations must preserve operational intent and avoid privilege regression across regions.

## Guardrail (required)
Reproduce locally using the standard venv workflow:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python3 scripts/guardrails/run.py
```

Expected strings:
- Fail: `guardrail unmet: least-privilege policy violation`
- Pass: `guardrail met`

## Tasks

1) **Triage**
- Capture the guardrail output and record the aggregated issue counts.
- Establish the current intended permission model for the automation identity (what it must do, when, and where).

2) **Least-privilege remediation**
- Produce a deny/allow matrix for the automation identity scoped to operational requirements.
- Reduce broad privileges and remove high-risk operations that are not explicitly required.
- Ensure permission narrowing includes explicit exclusions where appropriate.

3) **Scope controls**
- Provide assignable scope evidence that the automation identity is limited to the minimum set of scopes required for operations.
- Document any necessary exceptions with rationale and compensating controls.

4) **Key management access**
- Provide a Key Vault / secret access matrix for the automation identity (data-plane vs management-plane).
- Ensure access is consistent across regions and environments.

5) **Multi-region parity**
- Provide evidence of secondary region provider configuration and RBAC parity between primary and secondary regions.
- Validate that access changes do not introduce regional drift.

6) **Evidence pack**
Attach a bundle containing:
- policy diff
- deny/allow matrix
- plan/state json with role definitions
- assignable scope evidence
- kv/secret access matrix
- secondary region provider alias
- cross-region role parity evidence

7) **Completion**
- Guardrail output shows `guardrail met`.
- CI is green.

## Scenario sources

- Catalog entry: cat-clean-0161 (Azure / terraform / security/iam)
- Sampled incident metadata (sanitized):
  - 2025-Q2 / IAM / Senior
  - 2024-Q1 / IAM / Senior
  - 2025-Q2 / IAM / Senior
