import os
import re
import sys
from pathlib import Path

FAIL = "guardrail unmet: least-privilege policy violation"
PASS = "guardrail met"

root_arg = os.environ.get("IAC_ROOT", "senior/terraform")
ROOT = Path(root_arg)

if not ROOT.exists():
    print(FAIL)
    print("issues: iac_path_missing=1")
    sys.exit(1)

high_risk_verbs = 0
broad_scopes = 0
missing_not_actions = 0
overbroad_builtins = 0
secondary_missing = 0

HIGH_RISK = re.compile(r"Microsoft\.(Authorization/.*/write|KeyVault/.*/delete)", re.I)
ASSIGNABLE = re.compile(r"assignable_scopes\s*=\s*\[(.*?)\]", re.S | re.I)
PERMS = re.compile(r"permissions\s*{(.*?)}", re.S | re.I)
ACTIONS = re.compile(r"actions\s*=\s*\[(.*?)\]", re.S | re.I)
NOT_ACTIONS = re.compile(r"not_actions\s*=\s*\[(.*?)\]", re.S | re.I)
OWNER_CONTRIB = re.compile(r'role_definition_name\s*=\s*\"(?:Owner|Contributor)\"', re.I)
SECONDARY = re.compile(r'\balias\s*=\s*\"secondary\"|secondary_location|secondary_region|dr_', re.I)

secondary_seen = False

for tf in ROOT.rglob("*.tf"):
    try:
        text = tf.read_text(errors="ignore")
    except Exception:
        continue

    if SECONDARY.search(text):
        secondary_seen = True

    for perm in PERMS.finditer(text):
        block = perm.group(1)
        actions = ACTIONS.search(block)
        if actions and HIGH_RISK.search(actions.group(1)):
            high_risk_verbs += 1
        if NOT_ACTIONS.search(block) is None:
            missing_not_actions += 1

    for scopes in ASSIGNABLE.finditer(text):
        if re.search(r"/subscriptions/|/providers/microsoft\.authorization", scopes.group(1), re.I):
            broad_scopes += 1

    if OWNER_CONTRIB.search(text):
        overbroad_builtins += 1

if not secondary_seen:
    secondary_missing = 1

if any([high_risk_verbs, broad_scopes, missing_not_actions, overbroad_builtins, secondary_missing]):
    print(FAIL)
    print(
        "issues: "
        f"high_risk_verbs={high_risk_verbs}, "
        f"broad_scopes={broad_scopes}, "
        f"missing_not_actions={missing_not_actions}, "
        f"overbroad_builtins={overbroad_builtins}, "
        f"secondary_missing={secondary_missing}"
    )
    sys.exit(1)

print(PASS)
