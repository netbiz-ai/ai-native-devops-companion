# Running the labs with a coding agent

Every command the book prints ships in this repository as a runnable file, and every chapter has one validation command that says whether you are done.
That structure was built so you never retype from the page, and it has a second consequence: an AI coding agent can drive the same loop for you while you supervise and learn.

This page is for readers who want to work that way.
It is optional; every chapter is fully workable by hand with [getting-started.md](getting-started.md) alone.

## What an agent is good for here

A coding agent working in this repository can enter a chapter's starting state, run the numbered lab scripts in order, show you each result, copy the chapter's Configuration documents to their destinations, and finish by running the chapter's validation command.
The repository carries instructions for it in [`AGENTS.md`](../AGENTS.md) at the root: most current coding agents, including Claude Code, Codex CLI, and Cursor, read that file (or a pointer to it) automatically when opened in the repository, so the safety rules below are enforced from both sides.

## What stays yours

The agent executes; the book teaches.
Three responsibilities do not transfer:

- **Reading the chapter.**
  The labs are the chapter's *Build It* section made runnable; the reasoning around them is the book, and the AI Prompt Lab and Hallucination Check sections are exercises for you, not the agent.
- **Destructive and cost-bearing steps.**
  A script whose header says `Destructive` creates or changes real things, and cluster creation, Terraform apply, and anything on your cloud or GitHub credentials can cost money.
  `AGENTS.md` instructs agents to stop and ask you before each of these; expect those questions and read the script before answering yes.
- **The three things you supply.**
  From Chapter 8 onward you provide the disposable cluster, the registry with your image digest, and the Git source Argo CD can reach, exactly as in [getting-started.md](getting-started.md).
  A script whose header says `Partial` waits for your values; the agent should ask you for them, never invent them.

## A working prompt

Something like this, adjusted to the chapter:

> Work through chapter 3 of this repository per AGENTS.md.
> Run the lab scripts in labs/ch03/ in numbered order, show me each command and its result before moving on, and stop for my confirmation before anything labeled Destructive or anything that would create a cluster or cost money.
> Finish with the chapter's validation command from docs/chapter-map.md and report whether it passed.

Chapters 1, 2, 3, and 14 run at the offline level and are good first chapters for this way of working.

## When you are done

The chapter is complete when its validation command from [chapter-map.md](chapter-map.md) passes - the same standard as working by hand.
If the agent reports that a lab file appears defective, do not let it patch the file: the lab bodies are verbatim copies of the printed page, and the fix belongs in [GitHub Issues](https://github.com/netbiz-ai/ai-native-devops-companion/issues), the errata channel.
