# isaacpierreracine.github.io — Site Construction Reference

Last updated: November 8, 2026

> **Note for Claude:** Always confirm with Isaac that this is the latest README before making any updates.

---

## 1. Overview

| Item | Value |
|---|---|
| Site | Hugo static site, personal portfolio |
| Theme | Hugo Stack v4 (git submodule, never edit directly) |
| Hugo version | v0.160.1+extended (Homebrew) |
| Languages | French (default), English, Spanish |
| Local path | ~/Documents/hugo/stack |
| Config file | ~/Documents/hugo/stack/config.yaml |
| Live URL | https://isaacpierreracine.github.io/fr/ |
| GitHub repo | https://github.com/isaacpierreracine/isaacpierreracine.github.io |
| Deployment | GitHub Actions → GitHub Pages (auto-deploys on every git push) |

---

## 2. Key Principles

- **Never edit the theme folder** — `themes/hugo-theme-stack/` is a git submodule. All customizations live in the site root and override the theme via Hugo's lookup order.
- **French is the source of truth** — all content is written in French first, then mirrored and translated to EN and ES.
- **Content lives in language folders** — `content/fr/`, `content/en/`, `content/es/`
- **Folder naming convention** — folder name uses no spaces or accents (e.g. `liensderecherche`), front matter title uses proper spelling with spaces and accents (e.g. `"Liens de recherche"`). Keep folder name the same across all three languages.
- **`_index.md` (underscore) vs `index.md` (no underscore) is not cosmetic** — a section that must list child pages (e.g. `autour-du-moulin/`) requires `_index.md` in **every** language folder. A plain `index.md` makes Hugo treat that folder as a leaf page with no children — the section will still *appear* (e.g. as a project card) but `.Pages` returns empty, so the entry list renders blank. This must be verified per language independently — see section 15.

---

## 3. Directory Structure

```
~/Documents/hugo/stack/
├── config.yaml
├── mirror-entry.sh                       ← script to mirror FR entries to EN/ES
├── .github/workflows/hugo.yaml           ← GitHub Actions deployment
├── static/
│   └── hero.jpg                          ← homepage hero image
├── assets/scss/
│   └── custom.scss                       ← ALL custom styles (Stack's official hook)
├── layouts/
│   ├── baseof.html                       ← base layout (removes sidebar, adds topnav, back arrow)
│   ├── home.html                         ← homepage with hero
│   ├── art.html                          ← Art section — 3 project cards
│   ├── autour-du-moulin.html             ← Autour du Moulin entry list
│   ├── references.html                   ← Liens utiles — tag-filtered list
│   ├── cinema.html                       ← Cinéma — simple list sorted by weight (added June 28 2026)
│   ├── shortcodes/
│   │   └── peertube.html                 ← PeerTube video shortcode — added June 3 2026
│   ├── page/
│   │   ├── search.html                   ← copied from theme — required for search
│   │   └── search.json                   ← copied from theme — required for search
│   ├── _default/
│   │   └── index.json                    ← JSON index template for search
│   └── _partials/
│       ├── topnav.html                   ← sticky top navigation bar
│       ├── sidebar/left.html             ← empty — suppresses Stack's sidebar
│       └── article/components/header.html ← hideHeroImage support
└── content/
    ├── fr/                               ← French content (source of truth)
    │   ├── about/index.md
    │   ├── archives/index.md
    │   ├── search/index.md               ← page bundle (not flat .md file)
    │   ├── references/
    │   │   ├── _index.md
    │   │   ├── artist_residencies_manufacturing.md   ← added June 27 2026
    │   │   └── art submission.md         ← added by November 8 2026 (file name has a literal space)
    │   ├── cinema/                       ← _index.md + 9 flat .md entries, added June 28 2026 — see section 18
    │   └── art/
    │       ├── _index.md
    │       ├── autour-du-moulin/
    │       │   ├── _index.md
    │       │   ├── le-projet/
    │       │   ├── echeancier/
    │       │   ├── atelier/                  ← added May 7 2026
    │       │   ├── materiaux-et-processus/   ← added May 14 2026
    │       │   ├── energie-du-train/         ← added May 14 2026
    │       │   ├── recherche/                ← added May 26 2026
    │       │   ├── page-web/                 ← added May 26 2026
    │       │   ├── liensderecherche/         ← added May 28 2026
    │       │   ├── prototype-phase1/         ← added June 2 2026
    │       │   ├── mediation_1/              ← added June 2 2026
    │       │   ├── mediation-2/              ← added August 4 2026
    │       │   ├── maquette_étude_1/         ← added August 9 2026 (accent in folder name)
    │       │   ├── mediation-4/              ← added by September 1 2026
    │       │   ├── mediation-3-concepts/     ← added by September 2 2026
    │       │   ├── maquette/                 ← added September 4 2026 (maquettes préliminaires)
    │       │   ├── esquisse/                 ← added July 6 2026
    │       │   ├── prototype- phase 2/       ← first draft July 3 2026 (folder name has a literal space)
    │       │   └── liquid expansion/         ← added July 6 2026 (folder name has a literal space)
    │       ├── perpetuelle/index.md
    │       └── recherche-et-experimentation/index.md
    ├── en/                               ← mirrors fr/ structure
    │   ├── about/index.md                ← added May 7 2026
    │   ├── archives/index.md             ← added May 14 2026
    │   ├── references/_index.md
    │   ├── search/index.md
    │   └── art/autour-du-moulin/_index.md ← added July 6 2026, did not exist before — see section 15
    └── es/                               ← mirrors fr/ structure
        ├── about/index.md                ← added May 7 2026
        ├── archives/index.md             ← added May 14 2026
        ├── references/_index.md
        └── search/index.md
```

---

## 4. Custom Layout Files

### baseof.html
Overrides Stack's base template. Removes sidebar block, adds topnav partial, keeps Stack's footer JS via `footer/include.html`. Adds `← Retour` back arrow above content on all pages except homepage via `{{- if not .IsHome }}`. Note: does NOT include `footer/footer.html` directly (search template handles that itself).

**Fixed July 6 2026:** the `← Retour` link originally used `href="javascript:history.back()"`, which some browsers (Brave in particular) can misfire on — opening a blank new tab instead of navigating back. Replaced with a real URL plus an `onclick` fallback:
```html
<a class="section-back" href="{{ .Parent.RelPermalink }}" onclick="if (history.length > 1) { event.preventDefault(); history.back(); }">← Retour</a>
```
This gives a working link even with JS disabled (falls back to the parent section) while still behaving like a "back" button when there's browser history to go back to.

### home.html
Homepage — shows site title, tagline (from `params.sidebar.subtitle`), hero image (from `params.hero.image`). Placeholder shown if no image set.

### art.html
3 project cards sorted by `weight`. Detects sections (`.IsSection`) and external links (`.Params.externalLink`). Shows cover image, title, description, "En cours" badge for sections.

### autour-du-moulin.html
Entry list sorted newest first. Shows title, italic date, thumbnail on right. Has back link to Art.

### references.html
Liens utiles page. Auto-collects tags from all entries. Client-side tag filter. Supports `url_externe` for external links. If an entry has no `url_externe`, its title links to the entry's own page (`.RelPermalink`). Every entry needs a `tags:` field (use `tags: []` if none) — otherwise the build fails with `can't iterate over <nil>`.

### cinema.html
Cinéma section — simple list (`.Pages.ByWeight`) where each entry shows its title as a link to `url_externe` plus tag labels. Selected with `layout: "cinema"` in `_index.md` (set it in all three languages) — see section 18.

### shortcodes/peertube.html
PeerTube video shortcode — see section 17 for usage.

### page/search.html + page/search.json
Copied from theme into `layouts/page/` — required override so Hugo can find the search template. Do not edit.

### _default/index.json
JSON index template that generates the search index for all languages.

### _partials/topnav.html
Sticky top nav — avatar/initials, site name, main menu, language switcher (FR/EN/ES), dark mode toggle.

### _partials/article/components/header.html
Supports `hideHeroImage: true` front matter to hide large hero image on article pages while keeping thumbnail in lists.

---

## 5. config.yaml Key Settings

```yaml
baseURL: "https://isaacpierreracine.github.io"  # live URL
defaultContentLanguage: "fr"
defaultContentLanguageInSubdir: true             # forces /fr/ /en/ /es/ URLs

params:
  mainSections: [art, references]               # what appears in Archive
  hero:
    image: hero.jpg                             # must be in /static/
  article:
    readingTime: false
  comments:
    enabled: false                              # Giscus configured but off
  # sidebar subtitle removed — no tagline on homepage
  dateFormat:
    published: "2 January 2006"                 # no day name — added May 26 2026

outputs:
  home:
    - html
    - rss
    - json                                      # required for search
  section:
    - html
    - rss
  page:
    - html
    - json                                      # required for search

markup:                                         # added May 14 2026
  goldmark:
    renderer:
      unsafe: true                              # allows raw HTML in markdown (e.g. <img> tags)

languages:
  fr:
    contentDir: "content/fr"
    menu: Accueil, Art, Archive, Liens utiles, À propos
  en:
    contentDir: "content/en"
    menu: Home, Art, Archive, Useful links, About
  es:
    contentDir: "content/es"
    menu: Inicio, Arte, Archivo, Enlaces útiles, Acerca de
```

**Menu note:** each language menu also has a Cinéma entry (Cinéma / Cinema / Cine) pointing to the cinema section — added June 28 2026.

---

## 6. Front Matter Reference

### Search page (search/index.md) — all languages
```yaml
---
title: "Recherche"          # or Search / Búsqueda
slug: "search"
layout: "search"
type: "page"                # required — tells Hugo to use layouts/page/search.html
outputs:
    - html
    - json
draft: false
---
```

### Archives page (archives/index.md) — all languages — added May 14 2026
```yaml
---
title: "Archive"            # or Archive / Archivo
layout: "archives"
type: "archives"
draft: false
---
```

### References index (references/_index.md)
```yaml
---
title: "Liens utiles"       # or Useful links / Enlaces útiles
layout: "references"
---
```

### Art card (_index.md or index.md)
```yaml
---
title: "Project Title"
description: "Short description on card"
weight: 1
image: cover.jpg
externalLink: "https://..."   # if set, card links externally
draft: false
---
```

### Autour du Moulin section (_index.md)
```yaml
---
title: "Autour du Moulin"          # translate per language: "Around the Mill" / "Alrededor del Molino"
description: "Journal de projet — entrées chronologiques."
layout: "autour-du-moulin"
weight: 1
draft: false
image: image156.jpg                # must physically exist in THAT language's folder — verify, don't assume
cascade:
  hideHeroImage: true         # applies to ALL entries in this section
---
```

**Critical:** this file MUST be named `_index.md` (leading underscore), and MUST exist independently in **all three** language folders (`content/fr/art/autour-du-moulin/_index.md`, `content/en/...`, `content/es/...`). Hugo does not share or inherit this across languages. If it's missing in one language, that language's articles will each surface as standalone entries instead of being grouped under the section. If it exists but is named `index.md` (no underscore), Hugo treats the folder as a leaf page — the section still shows up (e.g. as a card elsewhere) but its entry list renders empty, since `.Pages` has nothing to range over. See section 15 for the full failure story.

### Autour du Moulin entry (index.md)
```yaml
---
title: "Entry Title"
date: 2026-03-15
draft: false
image: cover.jpg              # thumbnail in list
---
```

### Liens utiles entry (.md file)
```yaml
---
title: "Title"
date: 2026-01-15
tags: ["tag1", "tag2"]       # use tags: [] if none — never omit the field
url_externe: "https://..."
note: "Short annotation"
draft: false
---
```

### Cinéma section (_index.md) — all languages — added June 28 2026
```yaml
---
title: "Cinéma"             # Cinema / Cine
layout: "cinema"            # must be set in EN and ES too, or the default list is used
---
```

### Cinéma entry
```yaml
---
title: "Title"
date: 2026-01-15
weight: 1                   # controls the order (ByWeight)
tags: []
url_externe: "https://..."  # video link
draft: false
---
```

---

## 7. Multilingual Workflow

### Adding a new French entry
```bash
mkdir -p ~/Documents/hugo/stack/content/fr/art/autour-du-moulin/entryname
# Create index.md in Zed with front matter and content
# Folder name: no spaces or accents (e.g. liensderecherche)
# Front matter title: proper spelling with spaces and accents (e.g. "Liens de recherche")
# Keep same folder name across all 3 languages
```

### Mirror to EN and ES
```bash
cd ~/Documents/hugo/stack
bash mirror-entry.sh content/fr/art/autour-du-moulin/entryname
```
Creates matching folders in `content/en/` and `content/es/`, copies images, creates placeholder `index.md` files marked `TO TRANSLATE`.

### Translation workflow
1. Write entry in French
2. Paste French content to Claude for **orthography review first**
3. Once French is corrected, ask Claude for EN and ES translations
4. Run mirror-entry.sh
5. Paste translations into respective index.md files in Zed

---

## 8. Image Workflow

```bash
# Resize and compress single image (target ~50kb)
magick ~/Downloads/source.jpg -resize 800x -quality 75 ~/Documents/hugo/stack/content/fr/art/autour-du-moulin/entry-name/image.jpg

# Batch resize all .jpeg files from img/ folder into an entry folder
for f in ~/Documents/hugo/img/*.jpeg; do
  magick "$f" -resize 800x -quality 75 ~/Documents/hugo/stack/content/fr/art/autour-du-moulin/entry-name/"$(basename "$f")"
done

# Batch convert .jpeg to .jpg with low res output
for f in ~/Documents/hugo/img/*.jpeg; do
  magick "$f" -resize 800x -quality 75 ~/Documents/hugo/img/lowres/"$(basename "${f%.jpeg}").jpg"
done

# Batch convert .png to .jpg with low res output — added May 14 2026
mkdir -p ~/Documents/hugo/img/lowres
for f in ~/Documents/hugo/img/*.png; do
  magick "$f" -resize 800x -quality 75 ~/Documents/hugo/img/lowres/"$(basename "${f%.png}").jpg"
done

# Generate markdown image list for all jpg in a folder
cd ~/Documents/hugo/stack/content/fr/art/autour-du-moulin/entry-name && ls *.jpg | awk '{print "!["$0"]("$0")"}'

# Check size
ls -lh path/to/image.jpg
```

Note: images from camera are often `.jpeg`, `.JPG` or `.heic` — adjust extension in the batch command accordingly. iPhone HEIC files can be batch converted with magick directly.

### Images with gallery layout
Stack automatically applies a flex gallery layout to inline images (no spaces between them):
```markdown
![](image100.jpg)![](image101.jpg)![](image102.jpg)
```
Images must be in the **same folder** as the `index.md` for the gallery layout to work. If images are shared across languages, copy them to each language folder.

### Sizing images in markdown — added May 14 2026
With `markup.goldmark.renderer.unsafe: true` in config.yaml, use HTML directly in markdown:

```html
<img src="image.jpg" alt="description" style="width: 25%;">
*caption text*
```

Images in `.article-content` are centered automatically via section 17 of custom.scss.

- **Hero image:** `static/hero.jpg` — referenced in config.yaml
- **Art card cover:** same folder as section `_index.md`, referenced as `image: cover.jpg`
- **Entry thumbnail:** same folder as entry `index.md`, referenced as `image: image.jpg`

### Linking to a document stored in an entry folder
Put the file (e.g. `.stl`, `.pdf`) in the same folder as the entry's `index.md` and link to it by file name only:
```markdown
[Document CAD de l'agrafe](byciclewheelclip.stl)
```
Used in prototype phase 2. As with images, copy the file into each language folder.

---

## 9. Git Workflow

```bash
# Start server
cd ~/Documents/hugo/stack && hugo server -D

# Commit and push
git add .
git commit -m "Description of changes"
git push
```

GitHub Actions auto-deploys on every push to main.

### GitHub login — updated November 8 2026
GitHub no longer accepts a password for `git push`, and the old saved token had expired. Login now goes through the GitHub CLI (no token to paste):
```bash
brew install gh          # installed: v2.103.3
gh auth login            # GitHub.com → HTTPS → Yes → Login with a web browser
                         # copy the one-time code, paste it in the browser, click Authorize
```
After that, `git push` runs without asking for anything. To check:
```bash
gh auth status           # shows who is logged in
git ls-remote origin     # lists refs if the credentials work
```
If a push ever fails with `Invalid username or token. Password authentication is not supported`, the saved login has expired — just run `gh auth login` again. Do not type a password at the Terminal prompt (it never shows pasted text, so it looks like nothing happened).

---

## 10. Sections Status

| Section | FR | EN | ES | Notes |
|---|---|---|---|---|
| Homepage | ✓ | ✓ | ✓ | Hero image from static/ |
| Art — 3 cards | ✓ | ✓ | ✓ | Sorted by weight — 2 per row |
| Autour du Moulin | ✓ | ✓ | ✓ | 18 entries: le-projet, echeancier, atelier, materiaux-et-processus, energie-du-train, recherche, page-web, liensderecherche, prototype-phase1, mediation_1, esquisse, prototype- phase 2, liquid expansion, mediation-2, maquette_étude_1, mediation-4, mediation-3-concepts, maquette. EN/ES section grouping fixed July 6 2026 — see section 15 |
| Perpetuelle | ✓ | ✓ | ✓ | External link |
| Recherche et expérimentation | ✓ | ✓ | ✓ | Single page |
| Archive | ✓ | ✓ | ✓ | EN/ES added May 14 2026 |
| Liens utiles | ✓ | ✓ | ✓ | EN/ES added May 2026 |
| Cinéma | ✓ | ✓ | ✓ | 9 entries ordered by weight, links to external videos — see section 18 |
| À propos | ✓ | ✓ | ✓ | Full CV — FR corrected May 2026 |
| Search | ✓ | ✓ | ✓ | EN/ES added May 2026 |

---

## 11. To Do

- [x] Liens utiles EN and ES versions
- [x] Search page EN and ES versions
- [x] Archive EN and ES versions
- [x] Change baseURL to live URL in config.yaml
- [x] Back arrow navigation — consistent across all pages via baseof.html
- [x] Light mode text visibility fix
- [x] Date format — no day name
- [x] Video embedding — PeerTube account created on peertube.wtf (see section 17)
- [x] Art cards — 2 per row, white text on dark card body
- [x] Autour du Moulin — new entries: esquisse, prototype- phase 2, liquid expansion (July 5–6 2026)
- [x] Autour du Moulin — EN/ES section grouping fixed (`_index.md` naming) — July 6 2026
- [x] Retour link — replaced `javascript:history.back()` with real href + onclick fallback — July 6 2026
- [x] Autour du Moulin — new entries: mediation-2 (Aug 4), maquette_étude_1 (Aug 9), mediation-4 and mediation-3-concepts (Aug–Sep), maquette (Sep 4 2026); prototype phase 2, esquisse et proportion, energie-du-train edited
- [x] Cinéma section added (FR/EN/ES) — June 28 2026 — see section 18
- [x] Artist residencies entries in Liens utiles (FR/EN/ES) — June 27 2026
- [x] New reference file `art submission.md` (FR)
- [x] Switched editor from VS Code to Zed
- [x] Git push login fixed with GitHub CLI — November 8 2026
- [ ] Decide whether to remove `posterA4.pdf` from the repo root
- [ ] Auto-translation via Anthropic API (API key setup pending)
- [ ] Self-hosting migration (Phase 2)
- [ ] Migrate PeerTube to self-hosted instance in Phase 2
- [ ] Giscus comments re-enable when self-hosting

---

## 12. Theme Override Map

| Theme file | Our override | Purpose |
|---|---|---|
| layouts/baseof.html | layouts/baseof.html | Remove sidebar, add topnav, add back arrow |
| layouts/home.html | layouts/home.html | Custom hero homepage |
| layouts/page/search.html | layouts/page/search.html | Enable search (copied from theme) |
| layouts/page/search.json | layouts/page/search.json | Enable search (copied from theme) |
| layouts/_partials/sidebar/left.html | layouts/_partials/sidebar/left.html | Empty — hides sidebar |
| layouts/_partials/article/components/header.html | same | hideHeroImage support |
| assets/scss/custom.scss | assets/scss/custom.scss | All custom styles |

New layouts (no theme equivalent):
- `layouts/art.html`
- `layouts/autour-du-moulin.html`
- `layouts/references.html`
- `layouts/cinema.html`
- `layouts/_default/index.json`
- `layouts/_partials/topnav.html`
- `layouts/shortcodes/peertube.html`

---

## 13. Giscus (configured, disabled)

```yaml
comments:
  enabled: false              # set true to re-enable
  provider: giscus
  giscus:
    repo: isaacpierreracine/isaacpierreracine.github.io
    repoID: R_kgDOSHGN5A
    category: Announcements
    categoryID: DIC_kwDOSHGN5M4C7Oit
    mapping: pathname
    lightTheme: light
    darkTheme: dark_dimmed
    lang: fr
```

GitHub Discussions enabled. Giscus app installed. Decision: comments on main page only, not within articles.

---

## 14. Useful Commands

```bash
hugo server -D                            # start local server with drafts
hugo server -D -F                         # include future-dated entries
hugo -D 2>&1                              # full build, check errors
bash mirror-entry.sh content/fr/art/...  # mirror entry to EN/ES
find ~/Documents/hugo/stack/content -type f -name "*.md" | sort  # list all content
xattr -rc ~/Documents/hugo/stack/content # fix VS Code permission errors
git add . && git commit -m "msg" && git push  # commit and deploy
cd ..                                     # go back one directory in terminal
code .                                    # open current folder in VS Code (replaced by Zed)
zed .                                     # open current folder in Zed
gh auth status                            # check GitHub login
git ls-remote origin                      # test that git credentials work
```

## 15. Known Gotchas

- **Search requires `type: "page"`** in front matter — without it Hugo won't find `layouts/page/search.html`
- **Search content must be a page bundle** — use `search/index.md`, not `search.md`
- **Archive requires its own content file** in each language — `archives/index.md` with `layout: "archives"` and `type: "archives"`
- **`footer/footer.html` must not be in baseof.html** — the search template calls it itself; double-loading breaks search
- **`outputs` needs both `home` and `page` with `json`** — `home` alone is not enough for search to work
- **Avoid backslash folder names** — a rogue `content\` folder (with backslash) was causing EN/ES content to be invisible to Hugo. Always verify with `ls -la | grep content`
- **`markup.goldmark.renderer.unsafe: true`** required in config.yaml to use raw HTML (`<img>` tags) in markdown files
- **Renaming an entry folder** — stop the server first, rename with `mv`, update title in front matter, then restart
- **Always run hugo server from the stack folder** — `cd ~/Documents/hugo/stack && hugo server -D`
- **Gallery images must be local** — Stack's flex gallery layout only works when images are in the same folder as `index.md`. Absolute paths or static folder paths will not trigger the gallery CSS.
- **Language tabs require matching folder names** — if folder names differ across languages, add `translationKey: "keyname"` to front matter of all three files. Easiest to just keep the same folder name in all languages.
- **Future-dated entries won't show** — Hugo hides entries with a future date by default. Use `hugo server -D -F` locally to see them. They go live automatically on the live site once their date arrives.
- **VS Code empty folder** — if VS Code shows empty project, run `rm -rf ~/Library/Application\ Support/Code/User/workspaceStorage` then `code ~/Documents/hugo/stack`. Also add `"security.workspace.trust.enabled": false` to VS Code user settings to prevent recurring issue.
- **`_index.md` vs `index.md` — the July 6 2026 incident.** A section that needs to list child pages (like `autour-du-moulin/`) must have `_index.md` (underscore) in every language folder. All three language folders (`fr`, `en`, `es`) had drifted to a plain `index.md` at various points — the section still rendered (title, description, even a project card), but `.Pages.ByDate.Reverse` in `autour-du-moulin.html` returned nothing, so the entry list (`adm-list`) was empty. Symptom looked like "the whole project disappeared" but nothing was actually deleted — it was a filename issue. Fix: `mv content/<lang>/art/autour-du-moulin/index.md content/<lang>/art/autour-du-moulin/_index.md`, then `rm -rf public && hugo` and verify with `grep -c "adm-entry" public/<lang>/art/autour-du-moulin/index.html` (should match the real entry count, not 0). Check this per language independently — fixing one language's file does not fix the others.
- **File extension typos build silently with no error.** An entry (`liensderecherche` in `en/`) had its file saved as `index.med` instead of `index.md`. Hugo does not warn about this — it just never builds that page. If a single entry is missing while its sibling folder clearly exists with an `index.md`-looking file inside, run `ls` on that specific folder rather than assuming the front matter is at fault.
- **Verify image filenames per language, don't assume they match.** The same logical "section image" ended up as `cover.jpg` in some language folders and `image156.jpg` in others, copied in at different times. Always `ls` the actual folder before writing an `image:` field — a value that resolves fine in `fr` can silently fail to resolve (no image, no error) in `en` or `es` if the file isn't actually there.
- **`javascript:` hrefs are unreliable across browsers.** See the `baseof.html` fix above — Brave in particular can turn a `javascript:history.back()` link into a blank new tab instead of navigating back. Prefer a real `href` (with a sensible fallback URL) plus an `onclick` handler over any `javascript:` pseudo-protocol link.
- **When debugging a live/local mismatch, check for a stale `hugo server` process before assuming the code is broken.** A build (`hugo`) reporting the correct data (e.g. via `grep -c "adm-entry" public/.../index.html`) while the browser still shows nothing is almost always a stale dev-server session or browser cache — restart `hugo server` fully and hard-refresh (or use an incognito window) before concluding there's a real bug.
- **`tags:` is required on Liens utiles entries.** A missing field crashes the build with `can't iterate over <nil>` (from `delimit .Params.tags`). Use `tags: []` when there are none.
- **Cinéma EN/ES need `layout: "cinema"` in their own `_index.md`.** Without it Hugo falls back to the default list, even though FR looks right.
- **Heredocs (`cat <<EOF`) break on URLs containing `&`** (e.g. YouTube links) and truncate the file. Use `printf` or write the file in the editor.
- **VS Code kept opening empty projects** — the editor was switched to Zed (`zed ~/Documents/hugo/stack`). The VS Code fix above still applies if it is ever used again.
- **GitHub push: `Password authentication is not supported`** — see the login steps in section 9 (`gh auth login`).
- **Entry folder names are inconsistent** (`mediation_1` vs `mediation-2`, `maquette_étude_1` has an accent). Left as is — renaming changes URLs and must be done in FR/EN/ES. For new entries use hyphens, no spaces, no accents.
- **File names with spaces** (`art submission.md`, `prototype- phase 2/`) work but are fragile in terminal commands — quote the path.

---

## 16. custom.scss — Section Index

| Section | Purpose | Added |
|---|---|---|
| 1 | Design tokens (CSS variables) | original |
| 2 | Hide left sidebar + hamburger | original |
| 3 | Fix main container layout | original |
| 4 | Top navigation bar | original |
| 5 | Hero — homepage | original |
| 6 | Footer | original |
| 7 | Mobile responsive | original |
| 8 | Section header (Art, Références) | original |
| 9 | Art section — project cards | original |
| 10 | References section | original |
| 11 | Autour du Moulin — entry list + `.section-back` back arrow style | original |
| 12 | Hide Stack JS-injected UI elements | original |
| 13 | Language switcher | original |
| 14 | Search button | original |
| 15 | Article body — tighter spacing | original |
| 16 | Light mode — readable text colors | May 14 2026 |
| 17 | Article images — centered by default | May 14 2026 |
| 18 | Art card body — white text always | June 3 2026 |
| 19 | Art card body — black background | June 3 2026 |
| 20 | Art card body — force white text in light mode | June 3 2026 |
| 21 | Video grid — matches image gallery width | June 3 2026 |
| 22 | Gallery — contain images within content margins | June 3 2026 |
| 23 | Video grid — mobile media query | June 2026 (approx.) |

### Section 16 — Light mode readable text colors
```scss
[data-scheme="light"] {
    .adm-entry-title,
    .art-card-title,
    .ref-title,
    .section-title {
        color: #1a1a1a !important;
    }
    .adm-entry-date,
    .art-card-description,
    .ref-note,
    .section-description {
        color: #555555 !important;
    }
}
```

### Section 17 — Article images centered
```scss
.article-content img {
    display: block;
    margin: 0 auto;
}
```

### Section 18 — Art card white text
```scss
.art-card-title { color: #ffffff !important; }
.art-card-description { color: #cccccc !important; }
.art-card-count { color: #aaaaaa !important; }
```

### Section 20 — Force white text in light mode
```scss
[data-scheme="light"] .art-card-title,
[data-scheme="light"] .art-card-description,
[data-scheme="light"] .art-card-count {
    color: #ffffff !important;
}
```

### Section 21 — Video grid
```scss
.video-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 4px;
    width: 100%;
    margin: 16px 0;
}
.video-grid span { display: block !important; width: 100% !important; aspect-ratio: 16/9; }
.video-grid span img { width: 100% !important; height: 100% !important; object-fit: cover; margin: 0 !important; }
```

### Section 22 — Gallery images contained
```scss
.article-content p { overflow: hidden; }
```

---

## 17. Video Hosting — June 3 2026

**Chosen platform: peertube.wtf** — account created June 3 2026.
- Account: isaacbcn
- Channel: autourdumoulin — https://peertube.wtf/video-channels/autourdumoulin

PeerTube is open source, federated (Fediverse), no ads, no algorithm. Plan to migrate to self-hosted PeerTube instance in Phase 2.

**Known issue:** peertube.wtf sometimes returns server-side 500 errors (a vulnerability on their side, not a site bug). Accepted for now; self-hosting in Phase 2 will resolve it.

### PeerTube shortcode
File: `layouts/shortcodes/peertube.html`

**Thumbnail with play button — click opens overlay player, ✕ to close:**
```markdown
{{< peertube id="VIDEO-ID" img="image138.jpg" >}}
```

**Multiple videos in a row — wrap in video-grid div:**
```html
<div class="video-grid">{{< peertube id="ID1" img="img1.jpg" >}}{{< peertube id="ID2" img="img2.jpg" >}}{{< peertube id="ID3" img="img3.jpg" >}}</div>
```

**Full width responsive embed:**
```markdown
{{< peertube id="VIDEO-ID" full="true" >}}
```

**Parameters:**
- `id` — required — video ID from URL: `https://peertube.wtf/w/VIDEO-ID`
- `img` — optional — local image as thumbnail (default: `image01.jpg`)
- `full` — optional — `"true"` for full width embed
- `instance` — optional — PeerTube instance (default: `peertube.wtf`)

### Other platforms considered
| Platform | Type | Cost | Notes |
|---|---|---|---|
| framatube.org | PeerTube instance | Free | Registration closed Jun 2026 |
| peertube.social | PeerTube instance | Free | Domain redirected to unrelated site |
| Internet Archive | Hosted | Free | Open, no ads, permanent storage |
| Bunny Stream | Hosted indie | ~$10/mo | No tracking, clean embeds |
| Cloudflare Stream | Hosted | ~$5/mo | Fast, simple embed |

---

## 18. Cinéma Section — added June 28 2026

- Layout: `layouts/cinema.html`, selected with `layout: "cinema"` in `content/<lang>/cinema/_index.md` (all three languages).
- Content: 9 FR entries as flat `.md` files — aro-tolbukhin, art-director-commercial, art-director-films, croix-de-chemin, dieu-fait-la-fete, don-the-stain, felix-et-nati, heavens, troya (EN/ES mirror them), each with `weight` 1–9 to control the order, `url_externe` for the video link, and tags shown as labels.
- Menu: Cinéma / Cinema / Cine added to each language menu in `config.yaml`.
- Add a new entry: create `content/fr/cinema/entryname.md` (flat file, like the existing ones), give it the next `weight`, mirror to EN/ES.
