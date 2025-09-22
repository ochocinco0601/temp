# Business Observability Meta-App — Overview

## Purpose

The **Business Observability Meta-App** provides a structured, hierarchical view of observability maturity and health across **Consumer Technology (CT)**.
It consolidates data from monitoring platforms (Splunk, AppDynamics, ThousandEyes), CMDB sources, and incident systems into a single Grafana-based meta-dashboard.

The objective is to give:

* **Leaders**: clear roll-ups at CT and sub-line (L4) levels.
* **App owners**: at-a-glance signal health, incidents, and links to supporting artifacts.
* **SREs and engineers**: a consistent design pattern and transparent logic for dashboards.

---

## Scope

The meta-app answers three questions consistently across all levels:

1. **Coverage** — Do we have signals at all?
2. **Health** — Of the signals we do have, how many are green?
3. **Incidents** — What Sev1/Sev2 incidents are open?

---

## Drill Path

The dashboard hierarchy follows the CT structure:

* **CT Root View** → enterprise-wide summary across all sub-LOBs.
* **L4 View (Sub-LOB Overview)** → aggregate status across App IDs within a sub-line.
* **App ID Landing Page (L3)** → detailed signal inventory, health, and linked artifacts (Dashboard, Playbook, Owner).

---

## Documentation Structure

Two complementary tracks of documentation support this system:

### 1. User-Facing (Logic + Usage)

* **Overview** (this page)
* **CT Root View**
* **L4 View**
* **App ID Landing Page**
* **Dashboard Logic Page (Companion in Grafana)**
* **Definition Cards (Coverage, Health, Incidents, Future extensions)**
* **Tooltip Copy**

### 2. Engineering-Facing (Data + Design)

* **Canonical Data Model**
* **Mock Data Package**
* **Dashboard Design Patterns**
* **Governance**

---

## Why This Matters

* **Executives and managers** get clarity without debating what the numbers mean.
* **App owners and SREs** have a consistent landing page for their systems.
* **Engineers** can extend the design using a canonical data model and standard patterns.
* **Everyone** benefits from transparency: the logic is published, versioned, and linked directly from the dashboards.

---

## Next Steps

* See: [CT Root View](#) — enterprise summary
* See: [Dashboard Logic Page](#) — definitions and formulas
* See: [Canonical Data Model](#) — engineering schema

