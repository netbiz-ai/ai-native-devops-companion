.PHONY: test validate run assistant agent

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
