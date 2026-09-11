# DevSecOps evidence contract

The hosted CI defines five named jobs: SAST, dependencies, secrets, IaC, and
image. Each scanner result must identify the source revision and artifact it
actually inspected.

Retain only sanitized evidence under access control. Use
`finding-disposition-template.yaml` for every material finding. A scanner exit
code is not exploit proof, and a waiver does not turn a mandatory safety
failure into a pass.

Use fake credentials only on a disposable branch. Remove the unsafe commit
from reachable history before declaring the branch clean.
