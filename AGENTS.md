# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Codex, Copilot, Cursor, ...) when working with code in this repository. It follows the [AGENTS.md](https://agents.md) convention; `CLAUDE.md` only includes this file.

## Project Overview

The public FirstPromoter documentation site, built with [Mintlify](https://mintlify.com): product guides, integration how-tos, the tracking script docs, webhooks, the MCP server docs, and the REST API references for both the v1 and v2 APIs. Published automatically from `main` by the Mintlify GitHub app.

## Commands

Use the monorepo Docker stack (`make start` at its root) for local development; the docs are served on http://localhost:3003. For a standalone checkout, run from the directory containing `docs.json`:

```bash
npm i -g mint         # current Mintlify CLI; Node.js 20.17+ required
mint dev --port 3003 --no-open
mint validate         # check MDX and the documentation build
mint broken-links     # check internal links
```

See the [CLI reference](https://www.mintlify.com/docs/cli/commands). The existing Docker configuration still invokes the legacy `mintlify` CLI; migrating the container is a separate build change.

## Layout

```
docs.json             # site config and the whole navigation tree (versions v2 and v1)
introduction.mdx, how-it-works.mdx, quickstart.mdx
guides/               # how-to guides (website integration, fpr.js tracking, proxy, mobile)
integrations/         # per-platform integration pages
advanced/
automation/
script-docs/          # fpr.js / tracking script reference
webhooks-v2/, webhooks/   # v2 and v1 webhook docs
api-reference-v2/     # v2 API: api-admin/, api-affiliate/, api-advanced/
api-reference-v1/     # legacy v1 API
mcp/                  # MCP server overview and tools
snippets/             # reusable MDX snippets
images/, logo/, downloadables/
```

## Rules

- **New navigable pages must be added to `docs.json`** under the right version and group. Reusable snippets and intentionally unlisted pages do not need navigation entries. The file has two `versions` entries (`v2` first, then `v1`); put new content under `v2` unless it documents the legacy API.
- **Pages are MDX** with a frontmatter `title` (and usually `description`). Use Mintlify components (`<Note>`, `<Warning>`, `<Steps>`, `<Tabs>`, `<CodeGroup>`, `<ParamField>`, `<ResponseField>`) rather than raw HTML.
- **API reference pages mirror `fpr-api`.** Public v2 endpoints use `/api/v2/company/`, `/api/v2/affiliate/` and `/api/v2/track/`. Verify their routes, authentication, parameters and serializers in the matching API branch; the dashboard's `/api/admin/v1/` and `/api/affiliate/v1/` endpoints are separate. Prepare docs alongside API changes, but coordinate merging to `main` with the API release because it publishes the site.
- **Webhook docs mirror the delivery implementation**: check `fpr-api/app/services/webhook_event_listener.rb`, its payload serializers and `app/workers/webhook_delivery_worker.rb` for v2; legacy delivery lives under `app/models/webhooks/`. Event types, payloads and signatures must match the corresponding version.
- **Reuse snippets** from `snippets/` for text that appears on several pages instead of copying it.
- Keep images in `images/`; prefer PNG screenshots sized for the page width.
- Do not edit `docs-main-mintlify.textClipping` or the `Dockerfile` unless the task is about the docs build itself.

## Git Workflow

- Main branch: `main`. Merging to `main` publishes the site.
- Open pull requests as **drafts** by default (`gh pr create --draft`). Only mark a PR ready for review (`gh pr ready`) when the user explicitly asks for it.
- Never force-push or push directly to `main` without being explicitly asked.

## Cross-repo

The monorepo root `AGENTS.md` (`firstpromoter/firstpromoter`) lists the API namespaces and domain models the docs describe, and `fpr-api/AGENTS.md` covers the backend conventions behind them.
