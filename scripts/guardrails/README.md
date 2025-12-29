# Guardrails Runner

This repo ships an offline-safe guardrail runner that inspects the Terraform configuration and emits a neutral result.

## Local run

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python3 scripts/guardrails/run.py
```

### Expected output
- On failure: `guardrail unmet: least-privilege policy violation`
- On success: `guardrail met`

`IAC_ROOT` defaults to `senior/terraform`.
