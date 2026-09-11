# Capstone platform contract

User outcome: demonstrate one traceable, human-controlled release through
delivery, runtime, controlled failure, recovery, and cleanup.

Scope: one non-production environment and one immutable reference-app image.

Trust boundaries:

- Git review controls desired state.
- CI builds and reports evidence but does not own runtime acceptance.
- Terraform state, credentials, raw logs, and private identifiers remain
  protected operational data.
- The assistant is read-only and cited.
- The agent uses allowlisted read-only tools and can only create a proposal.
- A named human owns promotion, recovery, and final acceptance.

Canonical criteria:

| ID | Criterion | Required evidence |
|---|---|---|
| CAP-01 | Source maps to running image digest | Identity record across CI, registry, GitOps, and workload |
| CAP-02 | Delivery and security gates control promotion | Blocked failure and approved passing record |
| CAP-03 | Infrastructure, Git, and runtime agree | Plan/drift, reconciliation, and live object record |
| CAP-04 | Service behavior meets the lab target | Functional, telemetry, and reliability results |
| CAP-05 | A safe failure is detected and recovered | Incident timeline and Git-based recovery |
| CAP-06 | AI operations remain bounded | Citation, refusal, permission, proposal, and audit tests |
| CAP-07 | Cost is bounded and temporary resources are removed | Guardrail and independent cleanup evidence |

Every mandatory result must pass or remain visibly failed. A waiver records
risk but cannot convert a safety failure into a pass.
