.PHONY: test validate run assistant agent ch10-validate ch12-validate ch13-validate ch16-validate ch01-start ch02-start ch03-start ch04-start ch05-start ch06-start ch07-start ch08-start ch09-start ch10-start ch11-start ch12-start ch13-start ch14-start ch15-start ch16-start ch01-complete ch02-complete ch03-complete ch04-complete ch05-complete ch06-complete ch07-complete ch08-complete ch09-complete ch10-complete ch11-complete ch12-complete ch13-complete ch14-complete ch15-complete ch16-complete

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

# Chapter entry points. A chapter prints `make chNN-start`; this file decides
# what that resolves to, so restructuring the repository never invalidates a
# printed page. See scripts/start-chapter.sh and docs/release-policy.md.

ch01-start:
	./scripts/start-chapter.sh 01 start

ch01-complete:
	./scripts/start-chapter.sh 01 complete

ch02-start:
	./scripts/start-chapter.sh 02 start

ch02-complete:
	./scripts/start-chapter.sh 02 complete

ch03-start:
	./scripts/start-chapter.sh 03 start

ch03-complete:
	./scripts/start-chapter.sh 03 complete

ch04-start:
	./scripts/start-chapter.sh 04 start

ch04-complete:
	./scripts/start-chapter.sh 04 complete

ch05-start:
	./scripts/start-chapter.sh 05 start

ch05-complete:
	./scripts/start-chapter.sh 05 complete

ch06-start:
	./scripts/start-chapter.sh 06 start

ch06-complete:
	./scripts/start-chapter.sh 06 complete

ch07-start:
	./scripts/start-chapter.sh 07 start

ch07-complete:
	./scripts/start-chapter.sh 07 complete

ch08-start:
	./scripts/start-chapter.sh 08 start

ch08-complete:
	./scripts/start-chapter.sh 08 complete

ch09-start:
	./scripts/start-chapter.sh 09 start

ch09-complete:
	./scripts/start-chapter.sh 09 complete

ch10-start:
	./scripts/start-chapter.sh 10 start

ch10-complete:
	./scripts/start-chapter.sh 10 complete

ch11-start:
	./scripts/start-chapter.sh 11 start

ch11-complete:
	./scripts/start-chapter.sh 11 complete

ch12-start:
	./scripts/start-chapter.sh 12 start

ch12-complete:
	./scripts/start-chapter.sh 12 complete

ch13-start:
	./scripts/start-chapter.sh 13 start

ch13-complete:
	./scripts/start-chapter.sh 13 complete

ch14-start:
	./scripts/start-chapter.sh 14 start

ch14-complete:
	./scripts/start-chapter.sh 14 complete

ch15-start:
	./scripts/start-chapter.sh 15 start

ch15-complete:
	./scripts/start-chapter.sh 15 complete

ch16-start:
	./scripts/start-chapter.sh 16 start

ch16-complete:
	./scripts/start-chapter.sh 16 complete

# Chapter validators migrated from scripts/ into labs/. Only the four chapters
# that ship an executable validator get a target; extracted verbatim commands
# are run by path, as the book prints them.
ch10-validate:
	./labs/ch10/validate.sh

ch12-validate:
	./labs/ch12/validate.sh

ch13-validate:
	./labs/ch13/validate.sh

ch16-validate:
	./labs/ch16/capstone-verify.sh
