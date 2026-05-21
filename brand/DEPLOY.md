# Rank On Maps · Brand Kit · Deploy Guide

Internal access for the team and editors.

**Current password:** `ROM247`

> The password is stored as a SHA-256 hash inside `index.html`. The plain password never leaves your browser, never gets sent over the network. To rotate it, open `set-password.html`, type a new password, copy the hash, paste it back into `index.html`.

---

## What you're deploying

Just this folder, as-is. It's a static site — no build step, no server, no database. The whole kit is one folder of HTML, SVG, and TTF files.

```
rankonmaps-brand/
├─ index.html          ← the kit, password-gated
├─ set-password.html   ← helper to rotate the password
├─ logo/               ← 5 SVG variants
├─ templates/          ← 7 SVG video templates
├─ fonts/              ← local font fallbacks
├─ explorations/       ← history (direction comparisons)
└─ DEPLOY.md           ← this file
```

After deploying, share the URL + password with editors. Default URL pattern: `brand.rankonmaps.io` or `rankonmaps.vercel.app`.

---

## Option A · Vercel (5 minutes, recommended)

Free. Fast CDN. Custom domain in 2 minutes. The path of least resistance.

### Steps

1. Go to **vercel.com** and sign in with GitHub or email (free).
2. Click **Add New** → **Project** → **Import** (or just hit the **Deploy** button).
3. **Drag-drop** the `rankonmaps-brand` folder onto the page (or use the CLI — see below).
4. Project name: `rom-brand-kit` (or whatever).
5. Framework preset: leave as **Other**.
6. Click **Deploy**. Done in ~30 seconds.
7. Visit the resulting URL: `https://rom-brand-kit.vercel.app` → enter `ROM247`.

### Custom domain (optional, 2 minutes)

1. In your Vercel project → **Settings** → **Domains** → **Add**.
2. Type `brand.rankonmaps.io`.
3. Vercel shows a CNAME record. Add it to your DNS provider (Cloudflare, GoDaddy, etc.).
4. Wait 1–5 minutes for DNS to propagate.
5. URL becomes: `https://brand.rankonmaps.io`.

### CLI alternative

If you have Node installed:

```bash
npm i -g vercel
cd /Users/danielgirmay/rankonmaps-brand
vercel
# follow prompts; accept defaults
vercel --prod   # to push to production
```

---

## Option B · Netlify (also 5 minutes)

Equivalent to Vercel. Pick whichever you already have an account on.

1. Go to **app.netlify.com** → sign in.
2. **Sites** → drag the `rankonmaps-brand` folder onto the dropzone.
3. Site is live at `https://random-name-12345.netlify.app`.
4. Rename in **Site settings** → **Change site name** to something like `rom-brand-kit`.
5. **Domain management** → **Add custom domain** → `brand.rankonmaps.io` → follow CNAME instructions.

---

## Option C · Cloudflare Pages (if you already use Cloudflare)

If `rankonmaps.io` is on Cloudflare DNS, this is the cleanest fit.

1. **Cloudflare dashboard** → **Pages** → **Create a project** → **Direct Upload**.
2. Drag the folder. Done.
3. Custom domain auto-detects since the apex is already on Cloudflare.

---

## Add a second layer of protection (optional)

If you want platform-level password protection on top of the in-page gate (belt + suspenders):

| Platform | How |
|---|---|
| **Vercel** | Pro plan ($20/mo). Settings → Deployment Protection → Password Protection. |
| **Netlify** | Pro plan ($19/mo). Site settings → Visitor access → Password protection. |
| **Cloudflare** | Cloudflare Access (Zero Trust) — free up to 50 users. Adds an email/OTP auth wall. Strongest option. |

**Recommendation:** the in-page gate is enough for a brand kit. The kit isn't sensitive — it's just non-public. If a video editor accidentally shares the link, the password stops casual snooping. That's the right level of protection for this artifact.

---

## Rotating the password

1. Open `set-password.html` in a browser (locally or on the deployed URL).
2. Type the new password.
3. Click the hash to copy it.
4. Open `index.html` in any text editor.
5. Find this line near the bottom:
   ```js
   const PASSWORD_HASH = '74211262...';
   ```
6. Replace the long hex string with the new one. Save.
7. Re-deploy (drag-drop the updated folder again, or `vercel --prod` from the CLI).
8. Tell the team the new password.

The old password stops working as soon as the new deploy goes live. Anyone already logged in stays logged in until they clear local storage — for a hard reset, change the `STORAGE_KEY` constant on the same line below `PASSWORD_HASH`.

---

## Sharing with the team

Once live, send editors something like:

> **Rank On Maps Brand Kit · Internal**
> URL: `https://brand.rankonmaps.io`
> Access code: `ROM247`
>
> Bookmark it. Tick "Remember on this device" so you don't have to re-enter it.
> Need a new color value? Click any swatch in the Color section to copy the hex.

---

## Notes

- The password gate is **client-side**. It deters casual snooping but isn't bank-grade security. Anyone who views the page source can see the SHA-256 hash and could brute-force a weak password offline. So: pick a non-trivial password (current `ROM247` is fine for internal use; don't use `password` or `1234`).
- The kit's font fallbacks load from Google Fonts CDN. The page works offline against the local TTFs in `fonts/`.
- For real public deployment of any of this content, see the parent project's marketing site — that's where premium positioning gets external proof.
