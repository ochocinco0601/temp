# GitHub Copilot Instructions - BOS Knowledge Base

When working in this repository, you have access to a Business Observability System (BOS) knowledge base at `bos-knowledge/`. Reference this for methodology, vocabulary, and implementation patterns.

## What is BOS?

BOS transforms technical monitoring into business intelligence. Instead of "2% error rate," BOS shows "47 loan applications blocked, $18.8M impacted."

## Core Concepts (Memorize These)

### Four-Layer Model
| Layer | Name | Question |
|-------|------|----------|
| 1 | System | "Is the platform up?" |
| 2 | Process | "Is the workflow correct?" |
| 3 | Business Health | "Is the expectation met?" |
| 4 | Business Impact | "How bad when we fail?" |

**Traditional monitoring = Layers 1-2. BOS adds Layers 3-4.**

### Semantic Flow
```
Stakeholder → Expectation → Impact → Signal → Dashboard/Playbook
```

### Impact Categories
Every business impact fits one of: **Customer**, **Financial**, **Legal/Risk**, **Operational**

## File Navigation

| Topic | Reference File |
|-------|----------------|
| Overview & orientation | `bos-knowledge/CONTEXT.md` |
| Core principles | `bos-knowledge/1-methodology/foundational-principles.md` |
| Four-layer model details | `bos-knowledge/1-methodology/four-layer-model.md` |
| Factory/scaling model | `bos-knowledge/1-methodology/factory-model.md` |
| BOS vocabulary/terms | `bos-knowledge/2-concepts/vocabulary.md` |
| Entity relationships | `bos-knowledge/2-concepts/entity-relationships.md` |
| Quick start (5-min process) | `bos-knowledge/3-implementation/quick-start-reference.md` |
| Onboarding workflow | `bos-knowledge/3-implementation/onboarding-workflow.md` |
| Batch job example | `bos-knowledge/4-examples/batch-job-example/` |
| Executive pitch | `bos-knowledge/5-communication/executive-summary.md` |
| SME value proposition | `bos-knowledge/5-communication/sme-value-prop.md` |

## When User Asks About BOS

1. **Read `bos-knowledge/CONTEXT.md` first** if you haven't already
2. Reference specific files from the table above based on the question
3. Use BOS vocabulary consistently (see `2-concepts/vocabulary.md`)
4. Apply four-layer model when discussing signals or monitoring

## Key Patterns to Apply

### Good BOS Signal
✅ "99.2% of credit checks succeed" (Layer 3 - Business Health)
✅ "27 loan applications blocked" (Layer 4 - Business Impact)

### Bad Signal (Avoid)
❌ "CPU is at 45%" (technical metric without business context)
❌ "Service is down" (no quantification)

### Impact Statement Formula
```
"[service] degradation: [count] [stakeholder_type] affected.
Impact: [business_consequence].
Current: [rate]% (target: [target]%)"
```

## Anti-Patterns to Catch

- Missing Layer 3-4 signals (only infrastructure monitoring)
- Vague impacts ("service degraded" vs "47 customers blocked")
- No stakeholder identification
- Technical metrics without business context

---

*Reference `bos-knowledge/CONTEXT.md` for complete navigation guide.*
