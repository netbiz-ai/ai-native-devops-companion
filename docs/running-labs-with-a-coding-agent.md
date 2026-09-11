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

## Step by step

1. **Do the first-time setup yourself.**
   Follow the ten-minute setup in [getting-started.md](getting-started.md) until `./scripts/validate-offline.sh` finishes with `offline_validation=pass`.
   Handing the agent a proven environment separates "my setup is broken" from "the lab failed", which are otherwise indistinguishable in an agent's transcript.
2. **Install a coding agent and sign in.**
   Any agent that reads `AGENTS.md` works; three current examples, each with its own install and sign-in flow documented by its vendor:
   - Claude Code, a terminal agent: `npm install -g @anthropic-ai/claude-code`, then run `claude`.
   - Codex CLI, a terminal agent: `npm install -g @openai/codex`, then run `codex`.
   - Cursor, an editor with an agent built in: install the application, then open a folder.
   Install commands drift; treat the vendor's install page as authoritative, the same way [supported-versions.md](supported-versions.md) treats every other tool.
3. **Start the agent at the repository root** - the clone directory itself, not a subdirectory.
   That is where agents look for their instruction files, so starting here is what loads `AGENTS.md` (Claude Code reads it via `CLAUDE.md`; most others read it directly).
   Keep the agent's permission prompts on rather than granting blanket approval: the stop-and-ask rules in `AGENTS.md` work best when the agent must also ask the harness.
4. **Give it the starter prompt**, adjusted to the chapter:

   > Work through chapter 3 of this repository per AGENTS.md.
   > Run the lab scripts in labs/ch03/ in numbered order, show me each command and its result before moving on, and stop for my confirmation before anything labeled Destructive or anything that would create a cluster or cost money.
   > Finish with the chapter's validation command from docs/chapter-map.md and report whether it passed.

   Chapters 1, 2, 3, and 14 run at the offline level and are good first chapters for this way of working.
5. **Supervise the run.**
   Expect the agent to stop and ask at exactly the points `AGENTS.md` names: before anything labeled `Destructive`, before anything that creates a cluster or could cost money, and whenever a `Partial` script needs your values - supply real ones; it must never invent them.
   Read each script the agent asks about before answering yes, and read the chapter alongside the run: the agent executes the *Build It* section, but the reasoning around it is the book.
6. **Close the chapter.**
   The chapter is done when its validation command from [chapter-map.md](chapter-map.md) passes; ask for each check's actual output rather than a bare "passed", since a few chapters validate through their own success and failure runs rather than one command.
   Keep the artifacts the chapter produced - later chapters read some of them, and the cards in [getting-started.md](getting-started.md) say which.

## Where the human gate lives

The book's central discipline is that a human gates every consequential action, and handing the labs to an agent does not hand over the gate.
It survives at three layers, and knowing them tells you what your supervision is actually for:

1. **The agent's stop points.**
   [`AGENTS.md`](../AGENTS.md) hard-codes where the agent must halt and hand the decision back: before any `Destructive` script, before anything that creates a cluster or could cost money, and whenever a `Partial` script needs your values.
   Your yes or no at each stop is the gate - which is why step 5 says to read the script before answering.
2. **The harness's permission prompts.**
   Step 3 says to keep your agent's own permission prompts on rather than granting blanket approval.
   The two layers overlap on purpose: `AGENTS.md` catches a safe-looking script whose label says `Destructive`, and the harness catches anything an agent might rationalize past.
3. **The book's gate artifacts.**
   The chapter work itself is human-gate machinery only you can operate: the verification checklist ends with a named human owning the decision, review records and ADRs need your dispositions, Chapter 6's delivery route requires a production reviewer who is not the dispatcher - a gate no agent can satisfy for you - and the Chapter 14 and 15 assistants are read-only and proposal-only by construction.
   `AGENTS.md` forbids the agent from inventing those judgments, and the Chapter 14 demo will not produce its safe answer until the knowledge doc you write in Step 1 exists.

In short: the agent executes inside the gates; it never becomes one.

### The gate, chapter by chapter

The gate changes form as the book progresses, and three chapters show the whole arc.

**Chapter 1 - the gate is the artifacts you sign.**
No lab here is `Destructive`, so no stop fires; the gate is the work itself.
The AI Prompt Lab runs in *your* approved assistant, and the draft's provenance header records which route it came from.
The verification checklist's result cells start as `pending` and only your observed outputs may replace them, ending with a named human owning the decision.
The correction between labs 06 and 07 - seeing the release gate exit 0 on a missing artifact and deciding to make it exit 1 - is your judgment, and the review record takes your disposition on every suggestion before anything is committed.
The chapter's namesake artifact is itself the lesson: a machine gate that false-passes until a human verifies it.

**Chapter 8 - the gate has migrated into the system.**
Every lab is `Runnable` (the blast radius is your disposable cluster), so the label layer stays quiet here too; the stop that fires is the one before cluster creation, crossed knowingly and once.
After that the gate is compiled into the deployment: the shipped image digest is an all-zero placeholder that cannot pull, so an unreplaced value fails at admission rather than deploying something you never reviewed, and labs 02 and 07 refuse to proceed while placeholders remain - the only way through is the digest of the image *you* built and promoted in Chapters 4 to 6.
The script order reviews before it applies (validate, PSA check, diff, then apply), and the denial tests make you witness the platform saying no - lab 09 even hard-stops on ambiguity (`STOP: the egress test failed ambiguously`) rather than classify it as success.

**Chapter 16 - the gate becomes the deliverable.**
The evidence manifest is a gate ledger: every criterion CAP-01 to CAP-07 carries `status: pending` *and* `reviewer: pending`, one named-human signature per criterion, and its release identities ship as `REPLACE_AFTER_BUILD` values only a real run may fill.
`capstone-verify.sh` is Chapter 1's release gate grown up: it fails a criterion on missing evidence *and* on evidence still containing `REPLACE`, `pending`, or `not_evaluated`, so it cannot false-pass on hollow files, and its design mode honestly prints `live_acceptance=not_evaluated` on a fresh clone.
The evidence itself can only come from your own executed chapters, and the final gate is a human audience: the five-minute demo requires showing a *failed* gate that blocked promotion, the human incident decision, and the agent's write refusal - the gates proven by their refusals, not their approvals.

An agent can execute every command along that arc; what the capstone verifies is precisely the trail of human decisions no agent could have made.

## If a lab file looks wrong

If the agent reports that a lab file appears defective, do not let it patch the file: the lab bodies are verbatim copies of the printed page, and the fix belongs in [GitHub Issues](https://github.com/netbiz-ai/ai-native-devops-companion/issues), the errata channel.
