# BOS Dashboard Walkthrough Script (3 Minutes)
**Audience**: Platform Operations Technology Directors (Executive Offsite)
**Context**: Progress demo of BOS dashboard hierarchy
**Delivery**: Talking script with PowerPoint slides showing dashboard screenshots

---

## [0:00-0:15] Opening

**[SHOW: Title slide or L4 Dashboard]**

Thanks for the time today. I want to show you where we are with BOS and walk you through something your teams will use every day. We all know the pain - when something breaks at 3 AM, your on-call engineers can eventually figure it out, but the knowledge is scattered. Runbooks in different wikis, tribal knowledge in Slack, SME contacts buried in emails. **What BOS does is bring that business context and technical knowledge together in one consistent interface.** Today I'll walk you through the complete navigation hierarchy we've built - from your product line view all the way down to individual service detail. Let me show you what "see red, drill down" looks like.

---

## [0:15-0:40] L4 Product Line Dashboard

**[SHOW: L4 Product Line Dashboard screenshot]**

This is your strategic view - the L4 Product Line level. You see all four major product lines: Home Lending, Consumer Banking, Wealth Management, and Payments. Each shows its current health status. Notice Home Lending is showing Amber. **This is where you'd start during a war room or when the business asks "what's wrong with Home Lending?"**

Now here's the business enrichment piece - in upcoming enhancements, this view will show who the L4 product line director is, who the key product leads are. We're data-mining this from existing org charts and product catalogs, so it's not extra work for your teams to maintain. When you see Amber, you drill down.

---

## [0:40-1:05] L3 Products Dashboard

**[SHOW: L3 Products Dashboard screenshot]**

I've drilled into Home Lending, and now I'm seeing the L3 product level - Originations versus Servicing. Originations is Red - that narrows our focus immediately. You can see the health status, how many services are underneath it, and how many active incidents.

**Again, future enhancements will show the L3 product owner, the development lead, the ops lead right here on this screen.** Your SRE lead doesn't have to search for "who owns Originations?" - it's right there. Everything we're adding comes from data sources that already exist in the enterprise. We keep drilling.

---

## [1:05-1:30] Services Dashboard

**[SHOW: Services Dashboard screenshot]**

Now I'm looking at all services within Originations, sorted by health - worst first. Credit Check Service is Red, and that's clearly our problem. You can see the service name, its current health percentage, and its status at a glance.

**This is what your junior ops person sees when they get paged.** They don't need to know the entire architecture - they follow the red. They see Credit Check Service is the issue, and they drill into it. This is where business observability really pays off.

---

## [1:30-2:45] Service Detail Dashboard

**[SHOW: Service Detail Dashboard screenshot]**

This is the payoff. This is where all the centralized knowledge lives. Let me walk through what your on-call engineer sees:

**[Point to Business Purpose section]**
First, business context. "What does this service actually do?" Credit Check Service retrieves credit scores from bureaus for loan applications. Plain language, not tech jargon. Your responder immediately knows what business capability is affected.

**[Point to Stakeholder Expectations section]**
Second, who cares about this? You see stakeholder expectations - executives expect instant results, loan officers expect same-day decisions, compliance expects audit trails. **This helps your team understand urgency and who to communicate with during an incident.**

**[Point to Technical Health Signals section]**
Third, technical signals showing exactly what's broken. Credit Score Retrieval percentage, response time, bureau connection health. Not just "the service is down" - you see specifically which signal is degraded. And in the future, each signal will show the technical owner and runbook links.

**[Point to Business Impact section]**
Fourth, and this is critical - **business impact translation**. Your engineer sees: 10 customers blocked, $4.8 million in revenue at risk, 5 compliance violations, 3 manual interventions required. **This translates technical failure into business language.** When your director gets the call at 7 AM asking "how bad is this?" - your team has the answer immediately. They're not guessing about customer impact or financial exposure - it's measured and displayed.

**[Point to Actions section]**
Finally, next actions. Links to runbooks, related incidents, everything a responder needs. And coming soon - service owner contact, dev team rotation, ops escalation path. All data-mined from existing sources.

**This is what makes BOS different from traditional monitoring.** It's not just "CPU is high" - it's "here's what's broken, here's the business impact, here's who to call, here's what to do."

---

## [2:45-3:15] What's Next & Closing

**[SHOW: Summary slide or return to L4]**

So that's the complete hierarchy - L4 product line down to service detail. What you saw is business observability in action: **technical metrics enriched with business context at every level.** Your teams get consistent investigation paths, centralized knowledge, and the business impact data they need for escalations and stakeholder communication.

**Here's what's coming.** By end of October, we'll have working BOS implementations in Grafana - not mockups, production-ready dashboards. At that point, I'll have updates on how we're integrating existing operational workflows into this framework - things like HealthScope checks and start-of-day operational flows. We're bringing those patterns into BOS so they're consistent and centralized, not scattered across different tools.

And critically, **we'll open up the onboarding process** so your product teams, development teams, and platform operations teams can begin instrumenting their services with BOS signal definitions. They'll be able to expand this coverage to their domains using the same patterns you saw today.

Now, here's what we need from you. **We'll do the heavy lifting on initial data population** - we're pulling from product registry for product hierarchy and application mappings, from ServiceNow CMDB for asset relationships, and extracting signal data from existing monitoring tools where possible. But BOS only becomes real when it becomes your operational standard. **We need your commitment as leaders to champion this framework with your teams** - to use these dashboards in your war rooms, to reference them in your operational reviews, to make this how your teams investigate and communicate. BOS works when it becomes the way we operate, not just another tool in the stack. Your engagement and participation is what makes this transformation happen.

**Everything you saw solves real problems your teams face today: scattered knowledge, inconsistent investigation, and explaining technical failures in business terms.** Happy to take questions.

---

## Delivery Notes

**Timing Management**:
- If running short: Expand Service Detail section (most important)
- If running long: Compress L4/L3/Services sections (they're simpler)

**Emphasis Points**:
- "Business context enrichment" (theme)
- "$4.8 million in revenue at risk" (concrete impact)
- "Data-mined from existing sources" (low maintenance burden)
- "See red, drill down" (investigation pattern)

**Screen Transitions**:
- Smooth progression showing drill-down pattern
- Point to specific sections on Service Detail (most complex screen)
- Return to L4 at end to show full cycle

**Audience Connection**:
- "Your teams" (they own the people using this)
- "3 AM page" (they know the pain)
- "7 AM director call" (they take those calls)
- "War room" (they lead those)

**Questions to Anticipate**:
- "When will org ownership data be added?" → Next phase, Q[X]
- "How much manual data entry?" → Data-mined, low maintenance
- "What about my product line?" → Expanding beyond Home Lending now
- "Integration with [existing tool]?" → Walking skeleton first, integrations next
