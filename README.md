# Coinbase New-Customer Guide

A single-file, zero-dependency landing page that walks someone through Coinbase's
new-customer referral promotion: open an account through a referral link, buy
$15+ of any crypto, receive $20 in Bitcoin within 5–15 days of the qualifying
purchase. New customers only.

**Live:** https://coinbase-starter-guide.pages.dev

Source: https://github.com/nwfella/coinbase-starter-guide

## Why this is not on GitHub Pages

This repo is deliberately **not** served from `nwfella.github.io`.

In July 2026 a previous `coinbase-referral` repo on that domain triggered a Google
Safe Browsing **social-engineering** flag against `nwfella.github.io` as a whole.
Because every GitHub Pages site under a user account shares one `*.github.io`
reputation pool, unrelated projects (`flappy-bob` and others) started showing
interstitial "Dangerous site" warnings to visitors. Referral / "get free crypto"
pages are a well-known trigger for that classifier.

Hosting on an isolated `*.pages.dev` subdomain keeps this page's reputation
completely separate from the rest of the portfolio. **Do not enable GitHub Pages
on this repository.**

## What's in here

| File | Purpose |
| --- | --- |
| `index.html` | The entire site — HTML, CSS, and JS inline. No build step, no external requests. |

The page collects nothing: no analytics, no cookies, no forms, no server-side
anything. The optional step checkboxes write to the visitor's own `localStorage`
and never leave their device.

## Themes

Three colour themes, switched at runtime and driven entirely by CSS custom
properties on `html[data-theme]`. **Coinbase Blue is the default.**

| Theme | Look |
| --- | --- |
| `blue` (default) | Coinbase blue canvas, white cards, inverted white CTA |
| `dark` | Neutral near-black, blue accent |
| `light` | The original clean white/blue |

Each theme defines the same ~70 variables. The important distinction is
**canvas** vs **surface**: the page background and the cards sitting on it need
different text colours (the blue theme has white text on the canvas and dark text
inside white cards), so ink / body / muted / link each exist in a `canvas-*` and
a `surface-*` flavour. When adding a new element, decide which side it is on and
use the matching variable.

To change the default, edit the attribute on the `<html>` element:

```html
<html lang="en" data-theme="blue">
```

The inline script in `<head>` applies any saved preference before first paint, so
switching never flashes. The visitor's choice is stored in `localStorage` under
`cb-guide-theme` and never leaves their browser.

## Deploy

The site is static, so a direct upload of this directory is the whole deploy.

### Cloudflare Pages (direct upload, no CI)

```bash
npx wrangler login                       # once, interactive OAuth
npx wrangler pages project create coinbase-starter-guide --production-branch main
cp index.html dist/index.html && npx wrangler pages deploy dist \
  --project-name coinbase-starter-guide --branch main --commit-dirty=true
```

Or just run `./deploy-pages.sh`, which does all of the above.

Wrangler prints the live URL (`https://<project>.pages.dev`). Re-run the
`pages deploy` command to publish changes.

Make sure `.preview/` and `_*` scratch files stay out of the upload (see
`.gitignore`); only `index.html` needs to ship.

### Local preview

```bash
start index.html      # Windows
```

Or serve it if you want a real origin:

```bash
npx serve .
```

## Editing the referral link

The link lives in two places in `index.html` and they must stay in sync:

1. The hero CTA — `<a class="btn" href="https://www.coinbase.com/join/AFRLFUL" ...>`
2. The copy button — `data-copy="https://www.coinbase.com/join/AFRLFUL"`

```bash
grep -n "coinbase.com/join" index.html
```

## Verification

Rendered and checked at 1280px and a true 390px mobile viewport, in **all three
themes**, via an iframe harness — Chrome on Windows enforces a ~497px minimum
window width and silently ignores smaller `--window-size` values, so a 390px
screenshot without a harness is really laid out at 497px and clipped, which looks
exactly like a broken page:

```bash
"/c/Program Files/Google/Chrome/Application/chrome.exe" --headless=new --disable-gpu \
  --hide-scrollbars --window-size=1280,4400 --virtual-time-budget=7000 \
  --screenshot=preview.png "file:///C:/Users/homee/projects/coinbase-starter-guide/index.html"
```

(`file://` URLs need `--allow-file-access-from-files` if the page is loaded inside
an iframe harness.)

## License

MIT — see `LICENSE`.
