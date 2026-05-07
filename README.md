# isaacpierreracine.github.io — Site Construction Reference

Last updated: May 7, 2026

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
│   ├── baseof.html                       ← base layout (removes sidebar, adds topnav)
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
    │       │   └── atelier/                  ← added May 2026
    │       ├── perpetuelle/index.md
    │       └── recherche-et-experimentation/index.md
    ├── en/                               ← mirrors fr/ structure
    │   ├── references/_index.md          ← added May 2026
    │   └── search/index.md               ← added May 2026
    └── es/                               ← mirrors fr/ structure
        ├── references/_index.md          ← added May 2026
        └── search/index.md               ← added May 2026
```

---

## 4. Custom Layout Files

### baseof.html
Overrides Stack's base template. Removes sidebar block, adds topnav partial, keeps Stack's footer JS via `footer/include.html`. Note: does NOT include `footer/footer.html` directly (search template handles that itself).

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
mkdir -p ~/Documents/hugo/stack/content/fr/art/autour-du-moulin/entry-name
# Create index.md in VS Code with front matter and content
```

### Mirror to EN and ES
```bash
cd ~/Documents/hugo/stack
bash mirror-entry.sh content/fr/art/autour-du-moulin/entry-name
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

# Check size
ls -lh path/to/image.jpg
```

Note: images from camera are often `.jpeg` or `.JPG` — adjust extension in the batch command accordingly.

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
| Autour du Moulin | ✓ | ✓ | ✓ | 3 entries: le-projet, echeancier, atelier |
| Perpetuelle | ✓ | ✓ | ✓ | External link |
| Recherche et expérimentation | ✓ | ✓ | ✓ | Single page |
| Archive | ✓ | — | — | Stack built-in, auto |
| Liens utiles | ✓ | ✓ | ✓ | EN/ES added May 2026 |
| À propos | ✓ | ✓ | ✓ | Full CV |
| Search | ✓ | ✓ | ✓ | EN/ES added May 2026 |

---

## 11. To Do

- [x] Liens utiles EN and ES versions
- [x] Search page EN and ES versions
- [x] Change baseURL to live URL in config.yaml
- [ ] Auto-translation via Anthropic API (API key setup pending)
- [ ] Self-hosting migration (Phase 2)
- [ ] Giscus comments re-enable when self-hosting

---

## 12. Theme Override Map

| Theme file | Our override | Purpose |
|---|---|---|
| layouts/baseof.html | layouts/baseof.html | Remove sidebar, add topnav |
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
hugo -D 2>&1                              # full build, check errors
bash mirror-entry.sh content/fr/art/...  # mirror entry to EN/ES
find ~/Documents/hugo/stack/content -type f -name "*.md" | sort  # list all content
xattr -rc ~/Documents/hugo/stack/content # fix VS Code permission errors
git add . && git commit -m "msg" && git push  # commit and deploy
```

## 15. Known Gotchas

- **Search requires `type: "page"`** in front matter — without it Hugo won't find `layouts/page/search.html`
- **Search content must be a page bundle** — use `search/index.md`, not `search.md`
- **`footer/footer.html` must not be in baseof.html** — the search template calls it itself; double-loading breaks search
- **`outputs` needs both `home` and `page` with `json`** — `home` alone is not enough for search to work
- **Avoid backslash folder names** — a rogue `content\` folder (with backslash) was causing EN/ES content to be invisible to Hugo. Always verify with `ls -la | grep content`
