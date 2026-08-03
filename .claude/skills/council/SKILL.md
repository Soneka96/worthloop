---
name: council
description: Convene a council of expert reviewers on any question. Picks the right members, runs them in parallel rounds, and converges on a verdict. Use for ship decisions, architecture choices, UX trade-offs, tooling questions, or any decision that benefits from multiple expert perspectives.
---

# Council

Spawn 2–4 expert reviewers in parallel, collect their verdicts, and synthesise. If the discussion hasn't converged after a round, surface the open threads and ask the user before spending tokens on another round.

> **Hard constraint: council debates only. It never writes files, edits code, or applies fixes.**
> If the user wants to implement a verdict, they run `/council-plan`.

---

## Invocation Contract

**Standard:** `/council <question>` or `"call the council on <question>"`
**Override:** `/council <member1> + <member2>: <question>` — skips routing, uses exactly those members
**Abort:** Ctrl-C before verdicts are collected cancels the run

Before spawning anything:

**Step 0 — Registry gap check (zero token cost):**
Scan the question against the Member Registry. If the question's core concern is not well-covered by any existing member — a domain gap, not just a missing member — output exactly:

```
⚠️ Registry gap: this question touches [domain] which no current member owns.
Suggested new member: [Name] — [one sentence on domain and verdict vocabulary].
Add them before running? (yes / no)
```

- If **yes**: stop. Do not spawn. Let the user add the member first, then re-invoke.
- If **no**: proceed with the closest available members and note the gap in the routing line.
- A gap exists only when **no member's "Include when" clause mentions this domain by name**. Partial coverage (a member touches it but doesn't own it) is not a gap.

**Then** output the routing line:
`Routing to: [Member1, Member2, Member3] — because <one-sentence reason>. Spawning…`

This lets the user catch a wrong routing decision or a missing member before any tokens are spent on agents.

---

## Cost bias — best option wins by default, not cheapest

Default to recommending the best solution to the actual problem, regardless of implementation
cost, time, or complexity — unless the user's question explicitly signals otherwise (e.g. "cheap",
"minimal", "quick", "MVP", "don't over-engineer this one", an explicit budget/deadline). "This is
more work" is never by itself a reason for a member to downgrade a better-fitting design to a
cheaper one. This overrides ponytail's general minimalism default *for council verdicts
specifically* — ponytail still governs ordinary implementation work outside a council question.
The sub-prompt template below carries this instruction to every member.

---

## Member Registry

| ID | Domain | Include when | Exclude when | Verdict vocabulary |
|---|---|---|---|---|
| QA | Test coverage, regression risk, quality gates | Releasing, changing tested behaviour, reliability concerns | Question has no correctness dimension | SHIP / HOLD |
| Architecture | Layer boundaries (datasources → repositories → use cases → presentation), dependency direction, Redux flow, structural debt | Adding patterns, migrations, cross-cutting changes | Pure cosmetic or copy changes | SHIP / HOLD |
| Product | Feature coherence, user-facing value, scope | Releasing, feature decisions, "is this good enough?" | Internal-only / infra changes | SHIP / HOLD |
| UX | Interaction clarity, workflow, information architecture | Anything a user touches, new UI patterns | No UI surface affected | APPROVE / REVISE |
| User | Real end-user perspective — non-technical beta user who just uses the app | Anything a user sees or interacts with; "does this make sense?"; onboarding, activation, day-to-day flow | Pure infra/code questions with no visible surface | LOVE / CONFUSED |
| Claude Expert | Claude Code skills, hooks, CLAUDE.md, agent prompt design | Authoring or reviewing skills, hooks, memory | No Claude tooling involved | APPROVE / REVISE |
| Security | File I/O, HTTP, permissions, user data, JWT/licensing | Filesystem access, network, auth, credentials | No data or permissions involved | SAFE / RISK |
| Performance | Runner batching, isolate usage, widget rebuild cost, drift query cost | Anything touching the runner loop, `StoreConnector`, or drift streams | No perf-sensitive path touched | OK / CONCERN |
| DevOps | Build pipeline (`flutter build windows/macos/linux`), packaging, unsigned-Windows distribution, version bumps, release process | Cross-platform build changes, version bumps, release process; any council recommendation that adds a new pub dependency | Not a build or release question | SHIP / HOLD |
| Accessibility | Keyboard navigation, screen reader, colour contrast, focus management | Any new UI component or interactive pattern | No UI surface affected | PASS / FAIL |
| Architect | Document structure, section order, placement correctness — asks "does this belong here, and only here?" Catches orphaned blocks, misplaced badges, duplicated content, skipped heading hierarchy, and ordering that violates the document's own conventions. Also checks screenshots and images: placement, proximity to relevant content, and whether surrounding copy provides sufficient context. Never judges whether content is good — only whether it is where it should be. | Any question touching written output: READMEs, docs, structured content | Pure code questions with no written output | Structurally sound / Misplaced / Out of order / Homeless / Violates convention |
| Tech Recruiter | GitHub first impressions — project legibility, portfolio signal, hirability cues. Scans as a recruiter would: 30 seconds, top-to-bottom, pattern-matching for stack keywords, test discipline, scope clarity, and whether the project looks real and shippable. Never judges code quality — only what the outward-facing surface communicates. | Any question about README appeal, portfolio projects, "will this impress X?", or outward-facing project presentation | Pure code/architecture questions with no outward-facing surface | STRONG SIGNAL / WEAK SIGNAL / NO SIGNAL |
| Copywriter | Messaging clarity, taglines, CTAs, tone, word choice, narrative flow — asks "does this say the right thing to the right person in the fewest words?" Catches vague value props, scope mismatches between headline and features, weak CTAs, and jargon that excludes the target audience. Never judges code or structure — only the words and whether they work. | Any question about README copy, marketing text, taglines, CTAs, onboarding text, or user-facing messaging | Pure code/architecture questions with no user-facing copy | LANDS / REWORK |

**Overlap resolution:** if two members' domains overlap on a question, the one whose concern is *directly load-bearing for the decision* takes precedence. Example: "should we rename this Redux slice?" → Architecture owns it; QA is secondary (coverage impact only).

**UX vs User:** UX thinks about information architecture, patterns, and interaction design. User reacts as an actual person who just opened the app — "I don't understand this", "This feels wrong", "I love this". Both can appear on the same question for complementary perspectives.

**Exclusion heuristic:** exclude a member if the question would not materially change their answer. A question purely about test structure does not need UX. When in doubt, include — but never exceed 4 members.

---

## Execution Protocol

### Code lookups — use codegraph, not grep

This repo is indexed by CodeGraph (`.codegraph/`). When a member's sub-prompt requires inspecting
code (Architecture, QA, Performance, Security), tell them to use `codegraph_explore` /
`codegraph_node` (MCP tools) or `codegraph explore "<question>"` (shell) before falling back to
grep or reading files directly — it returns the relevant symbols' source plus callers in one call,
which matters more here since 2–4 members run the same kind of lookup in parallel every round.

### Round structure

Each round, spawn all active members in parallel using the `Agent` tool with `run_in_background: true`. Send a single message with all Agent tool calls — do not spawn sequentially.

**Sub-prompt template** (fill in for each member):

```
You are the [MEMBER ID] reviewer on a council.
Domain: [DOMAIN from registry]
Lens: [INCLUDE WHEN from registry — what this member cares about]
Context: read CLAUDE.md for project background. This repo is indexed by CodeGraph
(.codegraph/) — use codegraph_explore/codegraph_node before grep or manual file reads.
Question: [QUESTION]

**Cost bias:** default to recommending the best solution to this problem, regardless of
implementation cost/time/complexity, unless the question explicitly signals a cheap/minimal/MVP
constraint. Never downgrade a better-fitting design just because it's more work.

**Artifact check:** if your verdict names a specific package, tool, CLI, or URL, state whether you have confirmed it exists (e.g. on pub.dev/GitHub). If you cannot confirm, prefix it: ⚠️ Unverified: [name] — implementation must verify before acting.

Give your verdict ([VERDICT VOCABULARY for this member]) with 2–4 bullet reasons.
Be specific — point to files, lines, or behaviours where relevant.
Under 200 words.
```

**Special template for the User member:**
```
You are the User reviewer on a council.
You are a non-technical user of this app — a Flutter desktop clean-architecture starter with a
GitHub Explorer example feature.
You are NOT an engineer. You use the app the way an end user would — searching profiles, browsing
settings — not reading its source.
You care about: does this make sense the first time I see it? Is it confusing? Does it feel good to use?
Context: read CLAUDE.md for project background.
Question: [QUESTION]

Give your verdict (LOVE / CONFUSED) with 2–4 reactions written in plain language — no jargon.
Speak as a real user would: "I don't understand why...", "I love that...", "It feels weird when..."
Under 200 words.
```

For rounds after round 1, append:
```
Previous round summary:
[paste each prior member's verdict and key points in 1–2 lines each]

Respond to the discussion: where do you agree, where do you push back,
and what is your updated position?
```

### Live verdict relay

As each background agent completes, immediately output that member's verdict using this compact format — do not wait for all agents before showing anything:

```
**[Member]** — ✅ SHIP
- reason one
- reason two
```

One block per member, as it arrives. No preamble ("X is in", "waiting for Y") — just the block. This keeps the user informed without wasting tokens on status commentary.

### Convergence check

After each round completes, assess:
- Are all members aligned on verdict?
- Are there unresolved tensions between members?
- Are there open questions no member addressed?

**If converged** → proceed to Output.

**If not converged** → output a short summary:
```
Round N complete. Still unresolved:
- [tension 1]
- [tension 2]
Run another round? (~[estimated token cost] tokens)
```
Wait for the user to confirm before spawning the next round. Do not run more than 4 rounds without explicit user approval.

---

## Dissent threshold

| HOLDs / negative verdicts | Outcome |
|---|---|
| 0 | SHIP / APPROVE — present table, list any minor flags |
| 1 | SHIP WITH FLAGS — surface the dissenter's concern prominently; flags are non-blocking but must be addressed before next release |
| 2+ | HOLD — present blocking concerns, then **stop and ask the user** |

A single dissent is a flag, not a veto. Two or more is a veto.

**Mapping non-binary verdict vocabularies to the dissent count** — every member's vocabulary must
map to a count of 0 or 1 negative verdicts before this table applies. Default mapping unless
overridden below: the *first* listed token in the registry is a positive (0), every other token
is a negative (1).

- **Architect:** `✅ Structurally sound` = 0. `⚠️ Misplaced` / `⚠️ Out of order` / `🚫 Homeless` / `🚫 Violates convention` = 1 each.
- **Tech Recruiter:** `STRONG SIGNAL` = 0. `WEAK SIGNAL` / `NO SIGNAL` = 1 each.
- **Copywriter:** `LANDS` = 0. `REWORK` = 1.
- **User:** `LOVE` = 0. `CONFUSED` = 1.

### HOLD protocol — always wait for user input

When the verdict is HOLD, after presenting the table and next steps, output exactly:

```
How would you like to proceed?
  A) Implement the fixes — use /council-plan to turn this verdict into steps
  B) Re-council with additional perspectives
  C) Override — proceed anyway
  D) Something else
```

Then **stop**. Do not fix, do not spawn more agents, do not do anything until the user replies.

- If **A**: do nothing — remind the user to run `/council-plan` with this verdict in context
- If **B**: ask which new perspectives to add, or suggest based on the unresolved tension
- If **C**: note the override in a single line and stop — the user owns the risk
- If **D**: wait for the user to describe what they want

---

## Self-optimization protocol

After every council run, the council reflects on its own performance and proposes improvements to this skill file. This uses the Claude Expert member — no extra agent spawn, done inline after the verdict is presented.

### When to trigger

Trigger a self-optimization pass after any of these **objective** signals only:
- A registry gap was surfaced in Step 0
- The verdict was HOLD and the blocking issue should have been caught earlier (e.g. a structural mistake no member flagged)
- The user explicitly expressed frustration with the council's output (e.g. "why didn't anyone catch this?", "WTF", "this is wrong")
- A new member was added mid-session in response to a gap

Do **not** trigger based on subjective judgement of a member's verdict quality — that path fires too often and degrades output.

### What to do

After presenting the verdict, append a self-optimization block. The proposed fix must show the
**literal before/after text**, not a paraphrase — the user approves the exact diff, not a summary
of intent:

```
---
🔧 Council self-optimization (Claude Expert)

What went wrong: [one sentence — what this council run failed to catch or handle well]

Proposed fix:
- Before: [exact current SKILL.md text being replaced, or "(none — new addition)"]
- After:  [exact replacement text]

Apply? (yes / no)
```

- If **yes**: re-read `SKILL.md` in full first, then apply the edit precisely as shown above. Confirm with one line: `✅ Skill updated — [what changed].`
- If **no**: note it and stop.

### Constraints

- Only propose changes with a clear causal link to what went wrong this run — no speculative improvements
- One proposed fix per run — the most impactful change only
- Never auto-apply without the user's yes
- If nothing went wrong, output nothing — do not add the block

---

## Output Schema

Present as a table followed by flags:

```
## Council verdict — [question in ≤8 words]

| Member       | Verdict              | Key reason                  |
|---|---|---|
| QA           | ✅ SHIP              | [1-line summary]            |
| Architecture | ✅ SHIP              | [1-line summary]            |
| UX           | ⚠️ SHIP WITH FLAGS  | [1-line summary]            |

### Flags (non-blocking — address before next release)
- [flag]: [owner if known]

### Next steps (only if HOLD)
- [what needs to change before re-convening]
```

Allowed verdict tokens (use exactly these, do not invent others):
- `✅ SHIP` / `✅ APPROVE` / `✅ OK` / `✅ SAFE`
- `⚠️ SHIP WITH FLAGS` / `⚠️ APPROVE WITH FLAGS`
- `🚫 HOLD` / `🚫 REVISE` / `🚫 RISK` / `🚫 CONCERN`

Architect-specific tokens (only when Architect member is included):
- `✅ Structurally sound`
- `⚠️ Misplaced` / `⚠️ Out of order`
- `🚫 Homeless` / `🚫 Violates convention`

Tech Recruiter-specific tokens:
- `✅ STRONG SIGNAL`
- `⚠️ WEAK SIGNAL`
- `🚫 NO SIGNAL`

Copywriter-specific tokens:
- `✅ LANDS`
- `🚫 REWORK`

---

## Examples

**Ship decision:** `"call the council, should we ship 0.1.0?"`
→ Members: QA + Architecture + Product
→ One round usually sufficient

**Tooling question:** `"call the council on whether to commit .claude/ to the repo"`
→ Members: Claude Expert + UX + Architecture

**Explicit override:** `"/council ux + security: is this navigation pattern safe?"`
→ Skips routing, uses exactly UX and Security

**Wrong tool:** `"call the council on what to name this variable"`
→ Do not convene. Say: "The council is for decisions with real trade-offs. This doesn't need it — just pick a name."

**Multi-round:** A question about extracting the runner logic into a separate isolate boundary might need Architecture + Performance in round 1, then Product added in round 2 after a structural tension surfaces. After round 1, ask: "Round 1 complete. Architecture and Performance disagree on the isolate boundary. Run round 2 with Product added? (~2k tokens)"
