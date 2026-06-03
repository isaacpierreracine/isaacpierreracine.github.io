# isaacpierreracine.github.io — Site Construction Reference

Last updated: June 3, 2026

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
    │   ├── references/_index.md
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
    │       │   └── mediation_1/              ← added June 2 2026
    │       ├── perpetuelle/index.md
    │       └── recherche-et-experimentation/index.md
    ├── en/                               ← mirrors fr/ structure
    │   ├── about/index.md                ← added May 7 2026
    │   ├── archives/index.md             ← added May 14 2026
    │   ├── references/_index.md
    │   └── search/index.md
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

### home.html
Homepage — shows site title, tagline (from `params.sidebar.subtitle`), hero image (from `params.hero.image`). Placeholder shown if no image set.

### art.html
3 project cards sorted by `weight`. Detects sections (`.IsSection`) and external links (`.Params.externalLink`). Shows cover image, title, description, "En cours" badge for sections.

### autour-du-moulin.html
Entry list sorted newest first. Shows title, italic date, thumbnail on right. Has back link to Art.

### references.html
Liens utiles page. Auto-collects tags from all entries. Client-side tag filter. Supports `url_externe` for external links.

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
title: "Autour du Moulin"
layout: "autour-du-moulin"
weight: 1
draft: false
cascade:
  hideHeroImage: true         # applies to ALL entries in this section
---
```

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
tags: ["tag1", "tag2"]
url_externe: "https://..."
note: "Short annotation"
draft: false
---
```

---

## 7. Multilingual Workflow

### Adding a new French entry
```bash
mkdir -p ~/Documents/hugo/stack/content/fr/art/autour-du-moulin/entryname
# Create index.md in VS Code with front matter and content
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
5. Paste translations into respective index.md files in VS Code

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

---

## 10. Sections Status

| Section | FR | EN | ES | Notes |
|---|---|---|---|---|
| Homepage | ✓ | ✓ | ✓ | Hero image from static/ |
| Art — 3 cards | ✓ | ✓ | ✓ | Sorted by weight |
| Autour du Moulin | ✓ | ✓ | ✓ | 9 entries: le-projet, echeancier, atelier, materiaux-et-processus, energie-du-train, recherche, page-web, liensderecherche, prototype-phase1, mediation_1 |
| Perpetuelle | ✓ | ✓ | ✓ | External link |
| Recherche et expérimentation | ✓ | ✓ | ✓ | Single page |
| Archive | ✓ | ✓ | ✓ | EN/ES added May 14 2026 |
| Liens utiles | ✓ | ✓ | ✓ | EN/ES added May 2026 |
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
- `layouts/_default/index.json`
- `layouts/_partials/topnav.html`

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
code .                                    # open current folder in VS Code
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

---

## 16. custom.scss additions — May 14 2026

### Section 16 — Light mode readable text colors
```scss
// ------------------------------------------------------------------
// 16. Light mode — readable text colors
// ------------------------------------------------------------------
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

### Section 17 — Article images centered by default
```scss
// ------------------------------------------------------------------
// 17. Article images — centered by default
// ------------------------------------------------------------------
.article-content img {
    display: block;
    margin: 0 auto;
}
```

---

## 17. Video Hosting — June 3 2026

**Chosen platform: peertube.wtf** — account created June 3 2026.
- Account: isaacbcn
- Channel: autourdumoulin — https://peertube.wtf/video-channels/autourdumoulin

PeerTube is open source, federated (Fediverse), no ads, no algorithm. Plan to migrate to self-hosted PeerTube instance in Phase 2.

### Getting the thumbnail URL for a video
Go to: `https://peertube.wtf/api/v1/videos/VIDEO-ID`
Look for `thumbnailPath` field — prepend `https://peertube.wtf` to get the full URL.

### Full width responsive embed (no black side bars)
```html
<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
  <iframe title="video title" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" src="https://peertube.wtf/videos/embed/VIDEO-ID" frameborder="0" allowfullscreen></iframe>
</div>
```

### Thumbnail with play button (click to play inline)
```html
<div id="video-container" style="width: 300px; cursor: pointer; position: relative;" onclick="this.innerHTML='<iframe width=300 height=169 src=https://peertube.wtf/videos/embed/VIDEO-ID?autoplay=1 frameborder=0 allowfullscreen></iframe>'">
  <img src="THUMBNAIL-URL" style="width: 300px; height: 169px; object-fit: cover;">
  <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 50px; height: 50px; background: rgba(0,0,0,0.7); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
    <div style="width: 0; height: 0; border-top: 12px solid transparent; border-bottom: 12px solid transparent; border-left: 20px solid white; margin-left: 4px;"></div>
  </div>
</div>
```

Replace `VIDEO-ID` with your video's short UUID and `THUMBNAIL-URL` with the full thumbnail URL from the API.

**Note:** Use `/videos/embed/VIDEO-ID` not `/w/VIDEO-ID` in the src — the `/w/` URL does not work for embedding.

### Other platforms considered
| Platform | Type | Cost | Notes |
|---|---|---|---|
| framatube.org | PeerTube instance | Free | Registration closed Jun 2026 |
| peertube.social | PeerTube instance | Free | Domain redirected to unrelated site |
| Internet Archive | Hosted | Free | Open, no ads, permanent storage |
| Bunny Stream | Hosted indie | ~$10/mo | No tracking, clean embeds |
| Cloudflare Stream | Hosted | ~$5/mo | Fast, simple embed |