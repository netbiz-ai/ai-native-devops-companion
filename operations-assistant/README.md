# Operations assistant

Run:

```bash
python3 src/assistant.py "What should I check for high latency?"
python3 -m unittest discover -s tests -p 'test_*.py'
```

The initial release is deterministic and offline. It demonstrates retrieval,
citation, refusal, and non-execution boundaries without a live model. Adding a
model does not authorize wider data or operational access.
