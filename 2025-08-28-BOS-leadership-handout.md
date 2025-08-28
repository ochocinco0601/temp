# Business Observability — One-Page Leadership Handout

## Problem (what we can’t afford to ignore)

* Technical health ≠ whether the software is doing what the business needs it to do.
* During incidents and daily ops, we spend hours inferring outcomes from system metrics. That delays decisions on priorities, fixes, and trade-offs.
* If Product goals aren’t defined as requirements, we can’t instrument, alert, or report against them.

**Premise + justification**

1. **A problem is only solved if the intended outcome is achieved.** *Green systems can still fail the business goal.*
2. **Achieving an outcome requires knowing the outcome.** *Undefined targets can’t be hit.*
3. **Knowing whether the outcome happened requires explicit validation.** *Assumptions aren’t evidence.*
4. **Validation requires instrumentation and measurement.** *You can’t validate what you don’t observe.*
5. **Instrumentation requires the goal to be a requirement.** *If it’s not a requirement, it won’t be built, tested, or monitored.*

---

## Model (how we express and operate this)

* **Flows → Stages → Steps → Signals.** Define from the entry point of business intent (e.g., “fund today’s loans,” “settle trades”).
* **Signal types.** Business signals (outcome/fulfillment) and Performance-Reliability signals (process + system).
* **Three-party contract.**

  * **Product:** defines outcome, success baseline, and thresholds; owns the artifact of record.
  * **Development:** implements telemetry and business rules; emits events aligned to schema.
  * **Platform/SRE:** operationalizes dashboards, alerts, playbooks, and incident hooks.
* **Schema-first.** A lightweight system of record (SoR) expresses the above as fields (YAML/JSON). “Observability as code.”

---

## Minimal Start (thin slice; two weeks)

1. **Pick 1 high-value flow** with clear completion semantics.
2. **Fill the Step Template** (SoR) for 1–2 critical steps: purpose, success baseline, required timing, failure modes, owner.
3. **Emit 2–3 events** from code for those steps (e.g., `step_started`, `step_succeeded`, `step_failed`) with IDs we can join.
4. **Wire a simple dashboard** that rolls step signals up to a flow-level state.
5. **Set one alert** tied to the business rule (not CPU): threshold, window, owner, runbook link.
6. **Run 1 retrospective** after a real or simulated event; tighten definitions and thresholds.

---

## Example (Treasury wire funding — concrete and testable)

* **Outcome statement:** “All scheduled wires for Home Lending close of business are completed today.”
* **Business SLIs:**

  * `completion_rate`: number\_completed / number\_scheduled (target: 100% by 5:00 PM CT).
  * `on_time_rate`: number\_completed\_by\_deadline / number\_scheduled (target: ≥95% by 3:30 PM CT).
* **Performance-Reliability SLIs:**

  * `queue_age_p95` < 10 min; `retry_count_p95` ≤ 1; `gateway_success_rate` ≥ 99.5%.
* **Alert rule (single, meaningful):** If `completion_rate < 100%` at 4:30 PM **or** projected to miss by trend, page the on-call; if `on_time_rate < 95%` at 3:00 PM, open incident with playbook.
* **Dashboard:** One flow tile (Now/Today/Trend), plus drill-downs for the two steps that most often cause misses.

---

## The Ask (what I need from leadership)

1. **Endorse business-owned definitions.** Direct Product to author the Step Template for two pilot flows this PI.
2. **Nominate owners.** Name 1 Product lead, 1 Dev lead, 1 SRE lead per pilot; give them explicit decision rights on thresholds.
3. **Approve the SoR standard.** A minimal YAML/JSON schema in Git becomes the artifact of record.
4. **Fund the thin slice.** Capacity for: (a) 2–3 business events in code, (b) one dashboard, (c) one alert + runbook, (d) a short retrospective.
5. **Set cadence.** A 30-minute weekly review until roll-out; then fold into the normal ops rhythm.

**What you get in 2–4 weeks:** A visible, testable link between work and outcomes; faster time-to-clarity in incidents; a repeatable pattern we can scale across flows without adding tool sprawl.
