---
name: firstpromoter-fraud-review
description: Review a FirstPromoter affiliate program for fraud and abuse through the FirstPromoter MCP server. Use when auditing an affiliate before a payout, checking for self-referrals, duplicate signups, refund-heavy or ad-driven referrals, leaked promo codes, or unusual spikes, or when asked to find suspicious affiliates.
license: MIT
compatibility: Requires the FirstPromoter MCP server (https://mcp.firstpromoter.com, OAuth with a FirstPromoter admin or team login).
metadata:
  author: FirstPromoter
  version: "1.0.0"
---

# Fraud review for FirstPromoter

Find affiliates and referrals that look like fraud or policy abuse, show the evidence, and let the user decide what to do.

## Before you start

- Needs the FirstPromoter MCP server; if its tools are missing, tell the user to connect `https://mcp.firstpromoter.com` (setup: https://docs.firstpromoter.com/mcp/overview).
- Call `get_company_context` for campaigns and currency.
- Agree the scope: one affiliate (for example before a payout), one campaign, or the whole program over a date range. Default to the last 90 days.

## Rules

1. **Read-only.** A review never changes data. Flag, do not act.
2. **Evidence, not verdicts.** A signal is a reason to look, not proof. Each finding states the data behind it and an innocent explanation if there is one (shared office IP, a customer who later became an affiliate).
3. **Actions only on request.** If the user decides to act, the only MCP action is `block_promoter` (per campaign; pauses links and commissions without deleting anything). Show exactly which promoter and campaign, and confirm first. Denying commissions and holding payouts are dashboard actions; tell the user where.
4. **Keep personal data minimal** in the report: IDs and the fields that support the finding.

## Signals to check

| Signal | How to find it |
|---|---|
| **Flagged referrals** | `list_referrals` returns `suspicion` per referral: `same_ip_suspicion` (lead used the affiliate's own sign-in IP), `same_promoter_email` (affiliate referred their own email), `ad_source` (paid-ad traffic on a campaign where ad traffic is pending approval). Count per affiliate. |
| **Self or duplicate signups** | In `list_referrals` / `get_referral`, look for customer emails that match the affiliate's own (`get_promoter`) or each other exactly, or after normalizing aliases (`+tag`, and dots for Gmail). A shared domain alone is not evidence: common providers (gmail.com) and coworkers share domains. Treat a domain match as a signal only together with other evidence, such as the same IP flag or the affiliate's own company domain. |
| **Refund and chargeback heavy** | `get_referral` event log shows refunds and disputes; `get_promoters_report` / `get_overview_report` give revenue vs refunds. Flag affiliates whose refund share is far above the program's. |
| **Referrals without clicks** | `get_promoters_report` clicks vs referrals and customers. Many customers with zero or almost no tracked clicks can mean coupon leakage or cookie stuffing (or a legit coupon-only affiliate: check `list_promo_codes`). |
| **Promo code leakage** | `list_promo_codes` for the affiliate, then their referral volume and timing. Sudden bursts from many unrelated customers suggest the code is on a coupon site. |
| **Spikes** | For one affiliate, bucket their `list_referrals` by `created_at` day (the overview report is not filtered by promoter). For a campaign, `get_overview_report` with its `campaign_id`, grouped by day. Look for a burst of signups or sales in a short window, especially followed by refunds. |
| **Fast cash-out pattern** | Large pending commissions (`list_commissions`) concentrated on new customers who refund or churn soon after, close to a payout date. |

Paginate fully before computing rates; partial pages give wrong shares.

**Use the program as the baseline.** Compute the program's own refund rate and clicks-per-customer first (`get_overview_report`), then flag affiliates far above it, rather than using fixed thresholds. Most affiliates have no refunds at all, so a handful with a large refund share stand out clearly.

**Check that the signals exist before trusting a clean result.** If the program has sales but has never tracked a refund, refund-based checks are blind: report it as a setup gap (see the `firstpromoter-integrate` skill, "Diagnose an existing setup") instead of "no refund abuse found". Likewise, very few `suspicion` flags on a large program means "not detected", not "not happening".

**Concentration.** When a few affiliates earn most of the revenue, review those first: a problem there costs the most.

## Report

Return:

1. Scope and date range.
2. A table: affiliate (ID, name), campaign, signals hit, evidence (counts, example referral IDs, dates), risk (high / medium / low), innocent explanation if any.
3. Recommended next steps per high-risk affiliate (review in dashboard, hold payout, deny specific commissions, ask the affiliate, block on campaign).
4. What you could not check (for example data outside the date range or tools not available).

Then stop and let the user decide. For general lookups afterwards, use the `firstpromoter-manage-program` skill.
