# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Codex, Copilot, Cursor, ...) when working with code in this repository. It follows the [AGENTS.md](https://agents.md) convention; `CLAUDE.md` only includes this file.

## Project Overview

The public FirstPromoter documentation site, built with [Mintlify](https://mintlify.com): product guides, integration how-tos, the tracking script docs, webhooks, the MCP server docs, and the REST API references for both the v1 and v2 APIs. Published automatically from `main` by the Mintlify GitHub app.

## Commands

```bash
npm i -g mintlify     # once
mintlify dev          # preview at http://localhost:3000
mintlify install      # if dev refuses to start, reinstall dependencies
```

In the monorepo docker stack the site is served on http://localhost:3003.

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

- **Every new page must be added to `docs.json`** under the right version and group, or it will not appear in the navigation. The file has two `versions` entries (`v2` first, then `v1`); put new content under `v2` unless it documents the legacy API.
- **Pages are MDX** with a frontmatter `title` (and usually `description`). Use Mintlify components (`<Note>`, `<Warning>`, `<Steps>`, `<Tabs>`, `<CodeGroup>`, `<ParamField>`, `<ResponseField>`) rather than raw HTML.
- **API reference pages mirror `fpr-api`.** When an endpoint, parameter or response field changes in `fpr-api` (`/api/v2/company/`, `/api/v2/affiliate/`, `/api/v2/track/`), update the matching page here in the same change set. Do not document endpoints that are not released.
- **Webhook docs mirror `fpr-api/app/services/webhooks/`**: event types and payload shapes in `webhooks-v2/` must match what the API sends.
- **Reuse snippets** from `snippets/` for text that appears on several pages instead of copying it.
- Keep images in `images/`; prefer PNG screenshots sized for the page width.
- Do not edit `docs-main-mintlify.textClipping` or the `Dockerfile` unless the task is about the docs build itself.

## Git Workflow

- Main branch: `main`. Merging to `main` publishes the site.
- Open pull requests as **drafts** by default (`gh pr create --draft`). Only mark a PR ready for review (`gh pr ready`) when the user explicitly asks for it.
- Never force-push or push directly to `main` without being explicitly asked.

## Cross-repo

The monorepo root `AGENTS.md` (`firstpromoter/firstpromoter`) lists the API namespaces and domain models the docs describe, and `fpr-api/AGENTS.md` covers the backend conventions behind them.
