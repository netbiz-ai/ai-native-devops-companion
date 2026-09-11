# Release policy

A book that sends readers to a repository owes them a statement of what will
happen to that repository. This is that statement.

## Maintainer

This repository is maintained by its GitHub owner, `netbiz-ai`, alongside the
book. There is no separate support organization and no service-level
commitment. Treat it as author-maintained project code.

## Versioning

Releases are tagged `vMAJOR.MINOR.PATCH`.

- **MAJOR** changes when a chapter's instructions no longer work against the
  repository, so a reader following the book in order would be blocked.
- **MINOR** adds chapter assets or capability without breaking a published
  chapter's path.
- **PATCH** corrects defects, versions, or documentation.

Tags are immutable. A tag is never moved or deleted once pushed; a mistake is
corrected by a new tag.

## Per-chapter handoff tags

Chapters refer to `chNN-start` and `chNN-complete` tags. These are immutable
markers of the state a chapter begins from and the state it produces. They are
cut only from a state that has actually been executed and whose observed output
matches what the chapter asserts.

Tags that have not been cut are listed as gaps in `docs/chapter-map.md` rather
than promised silently.

## Compatibility window

Each book edition names one supported release line of this repository, and the
supported baseline for tools is `docs/supported-versions.md`.

The current edition's line receives corrections. When a new edition is
published, the previous edition's line moves to security-relevant corrections
only, and its tags remain available so a reader working through the older
printed book can still check out a state that matches it.

Nothing here is deleted when it becomes old.

## Errata

GitHub Issues on this repository are the errata channel, for the book and for
the code.

The most useful report names the chapter, the step, what the book said would
happen, and what happened instead. Where the book and
`docs/chapter-map.md` disagree, the map is correct and the book is the defect.

## Update cadence

There is no fixed release schedule. Corrections are published when they are
ready rather than batched to a date, and `CHANGELOG.md` records what changed in
each release.

Version-sensitive facts in the book point here rather than being reprinted, so
`docs/supported-versions.md` is reviewed whenever a tool in it moves in a way
that changes a chapter's instructions.

## Archival

If this repository stops being maintained, the final release will say so in
`CHANGELOG.md` and in the README, with the date and the last edition it
supports. It will be archived on GitHub rather than deleted, so every tag the
printed books refer to stays resolvable.
