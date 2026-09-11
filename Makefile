.PHONY: test validate run assistant agent method-start prompt-library-start reference-app-start container-start ci-start delivery-start infrastructure-start kubernetes-start gitops-start observability-start security-start incident-start capacity-start assistant-start agent-start capstone-start method-complete prompt-library-complete reference-app-complete container-complete ci-complete delivery-complete infrastructure-complete kubernetes-complete gitops-complete observability-complete security-complete incident-complete capacity-complete assistant-complete agent-complete capstone-complete observability-validate incident-validate capacity-validate assistant-validate capstone-validate

test:
	python3 -m unittest discover -s reference-app/tests -p 'test_*.py'
	python3 -m unittest discover -s operations-assistant/tests -p 'test_*.py'
	python3 -m unittest discover -s operations-agent/tests -p 'test_*.py'

validate:
	./scripts/validate-offline.sh

run:
	python3 reference-app/src/app.py

assistant:
	python3 operations-assistant/src/assistant.py "What should I check for high latency?"

agent:
	python3 operations-agent/src/agent.py deployment-status

# Lab entry points, one per subject. A chapter prints `make <subject>-start`; this file decides
# what that resolves to, so restructuring the repository never invalidates a
# printed page. See scripts/start-lab.sh and docs/release-policy.md.

method-start:
	./scripts/start-lab.sh method start

method-complete:
	./scripts/start-lab.sh method complete

prompt-library-start:
	./scripts/start-lab.sh prompt-library start

prompt-library-complete:
	./scripts/start-lab.sh prompt-library complete

reference-app-start:
	./scripts/start-lab.sh reference-app start

reference-app-complete:
	./scripts/start-lab.sh reference-app complete

container-start:
	./scripts/start-lab.sh container start

container-complete:
	./scripts/start-lab.sh container complete

ci-start:
	./scripts/start-lab.sh ci start

ci-complete:
	./scripts/start-lab.sh ci complete

delivery-start:
	./scripts/start-lab.sh delivery start

delivery-complete:
	./scripts/start-lab.sh delivery complete

infrastructure-start:
	./scripts/start-lab.sh infrastructure start

infrastructure-complete:
	./scripts/start-lab.sh infrastructure complete

kubernetes-start:
	./scripts/start-lab.sh kubernetes start

kubernetes-complete:
	./scripts/start-lab.sh kubernetes complete

gitops-start:
	./scripts/start-lab.sh gitops start

gitops-complete:
	./scripts/start-lab.sh gitops complete

observability-start:
	./scripts/start-lab.sh observability start

observability-complete:
	./scripts/start-lab.sh observability complete

security-start:
	./scripts/start-lab.sh security start

security-complete:
	./scripts/start-lab.sh security complete

incident-start:
	./scripts/start-lab.sh incident start

incident-complete:
	./scripts/start-lab.sh incident complete

capacity-start:
	./scripts/start-lab.sh capacity start

capacity-complete:
	./scripts/start-lab.sh capacity complete

assistant-start:
	./scripts/start-lab.sh assistant start

assistant-complete:
	./scripts/start-lab.sh assistant complete

agent-start:
	./scripts/start-lab.sh agent start

agent-complete:
	./scripts/start-lab.sh agent complete

capstone-start:
	./scripts/start-lab.sh capstone start

capstone-complete:
	./scripts/start-lab.sh capstone complete

# Chapter validators migrated from scripts/ into labs/. Only the five chapters
# that ship an executable validator get a target; extracted verbatim commands
# are run by path, as the book prints them.
observability-validate:
	./labs/observability/validate.sh

incident-validate:
	./labs/incident/validate.sh

capacity-validate:
	./labs/capacity/validate.sh

assistant-validate:
	./labs/assistant/validate.sh

capstone-validate:
	./labs/capstone/capstone-verify.sh
