# FirstPromoter docs

Source of the public FirstPromoter documentation at [docs.firstpromoter.com](https://docs.firstpromoter.com), built with [Mintlify](https://mintlify.com). It covers the product guides, integration how-tos, the `fpr.js` tracking script, webhooks, the MCP server and the REST API references (v2 and legacy v1).

`docs.json` holds the site configuration and the whole navigation. Contributor and agent conventions are in [AGENTS.md](AGENTS.md).

## Local development

Requires Node.js 20.17 or later, on an LTS release (the Mintlify CLI does not run on Node 25).

```bash
npm i -g mint
mint dev --port 3003   # preview at http://localhost:3003
```

Inside the FirstPromoter monorepo, `make start` at its root serves the docs on the same port.

## Checks

Run both before opening a pull request. CI runs them on every pull request.

```bash
mint validate       # MDX, docs.json and OpenAPI build checks
mint broken-links   # internal links
```

## Publishing

Merging to `main` publishes the site automatically through the Mintlify GitHub app. Open pull requests as drafts and coordinate API reference changes with the matching API release.
