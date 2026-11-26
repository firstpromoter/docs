---
name: firstpromoter-manage-program
description: Run a FirstPromoter affiliate program through the FirstPromoter MCP server. Use for affiliate support lookups (is this person an affiliate, which referrals or leads are theirs, why a sale was not credited), commission and payout questions, program reports and leaderboards, screening pending affiliate applications, and checking tracking or integration health.
license: MIT
compatibility: Requires the FirstPromoter MCP server (https://mcp.firstpromoter.com, OAuth with a FirstPromoter admin or team login).
metadata:
  author: FirstPromoter
  version: "1.0.0"
---

# Manage a FirstPromoter program

Answer questions about the user's affiliate program from live data, and make changes only when the user asks for them.

## Before you start

- This skill needs the FirstPromoter MCP server. If its tools (`get_company_context`, `list_promoters`...) are not available, tell the user to connect it: `claude mcp add firstpromoter --transport http https://mcp.firstpromoter.com` (Claude Code), or add `https://mcp.firstpromoter.com` as a custom connector in their client. Setup per client: https://docs.firstpromoter.com/mcp/overview
- Call `get_company_context` first. It gives the campaigns, currency and promoter counts you need to read every other answer correctly.
- Tool reference: https://docs.firstpromoter.com/mcp/tools. Tool names can change while the server is experimental; trust the tool list you actually see.

## Rules

1. **Read-only by default.** Look things up and report. Do not create, update, accept, reject, block or move anything unless the user asked for that change in this conversation.
2. **Confirm every write.** Before a write, show what will change (which promoter, which campaign, old → new values) and wait for a yes. One confirmation covers one change, not a batch the user has not seen.
3. **Money stays in the dashboard.** Payouts, invoices, payment batches and commission creation are not available over MCP by design. Explain what to do in the dashboard instead of looking for a workaround.
4. **Be exact.** Quote IDs, emails, dates and amounts from tool results. Payout amounts are in cents; convert and state the currency from `get_company_context`. Paginate when a list may be longer than one page instead of reporting partial counts as totals.
5. **Protect personal data.** Affiliate and customer emails, addresses and payout details are personal data. Show only what the question needs.

## Recipes

### Support lookups

"Is this person an affiliate?", "which referrals are hers?", "why wasn't this sale credited?"

- Find the affiliate: `list_promoters` with `q` (fuzzy match on email, name, website). Then `get_promoter` for profile, balances and campaign membership.
- Their referrals: `list_referrals` filtered by promoter; `get_referral` shows the customer, campaign and the full event log (click, signup, sales, refunds).
- Missing credit: check the referral's event log, then `get_integrations` for billing connection, Stripe test/live mode and when the last click and referral were tracked. Do not guess that an integration is connected.

### Commissions and payouts

- `list_commissions` by status, date range, campaign or promoter for "what is pending / approved / denied".
- `list_payouts` for what was paid (cents). For "why is my payout stuck", combine the promoter's balances from `get_promoter` with their pending commissions and payout history, and point to the dashboard for the action.

### Reports and leaderboards

- Program trend: `get_overview_report` (group by day, week, month or year).
- Top affiliates or campaigns for a period: `get_promoters_report`, `get_campaigns_report`.
- Traffic: `get_urls_report`, `get_traffic_sources_report`. Quick snapshot: `get_dashboard_stats`, `get_dashboard_trending`.
- State the date range and currency in every report. For a recurring sync or dashboard, reuse the same filters each run so numbers stay comparable.
- Useful views people ask for: top affiliates and their share of revenue (`get_promoters_report`), affiliates who joined but never sent a click in the period (compare `list_promoters` with the report), new referrals since a date (`list_referrals` with `created_from`), and pending commissions per campaign (`list_commissions`).

### Screening applications

- `list_promoters` filtered to pending; for each, `get_promoter` (website, social links, country, notes). Summarize fit and risk per applicant in a table. Accept or reject (`accept_promoter`, `reject_promoter`, scoped to one campaign) only on explicit confirmation, one applicant at a time or a list the user approved.

### Program setup changes (on request only)

Campaigns, rewards, promo codes, products and emails have create/update tools. Read the current object first (`get_campaign`, `get_reward`, `get_promo_code`, `get_email`), show the diff, then write after confirmation. Notes:

- New emails are created as drafts with the trigger off; an admin enables them in the dashboard. Broadcasts and send-now are dashboard-only.
- To unblock a promoter, use `add_promoter_to_campaign` with the same promoter and campaign. `restore_promoter` is only for archived promoters.
- Hiding a reward keeps existing attachments and pending commissions working.

For suspicious affiliates or referrals, use the `firstpromoter-fraud-review` skill.
