# isaacpierreracine.github.io — Site Construction Reference

Last updated: May 2026

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
│   └── _partials/
│       ├── topnav.html                   ← sticky top navigation bar
│       ├── sidebar/left.html             ← empty — suppresses Stack's sidebar
│       └── article/components/header.html ← hideHeroImage support
└── content/
    ├── fr/                               ← French content (source of truth)
    │   ├── about/index.md
    │   ├── archives/index.md
    │   ├── search.md
    │   ├── references/_index.md
    │   └── art/
    │       ├── _index.md
    │       ├── autour-du-moulin/
    │       │   ├── _index.md
    │       │   ├── le-projet/
    │       │   └── echeancier/
    │       ├── perpetuelle/index.md
    │       └── recherche-et-experimentation/index.md
    ├── en/                               ← mirrors fr/ structure
    └── es/                               ← mirrors fr/ structure
```

---

## 4. Custom Layout Files

### baseof.html
Overrides Stack's base template. Removes sidebar block, adds topnav partial, keeps Stack's footer and JS.

### home.html
Homepage — shows site title, tagline (from `params.sidebar.subtitle`), hero image (from `params.hero.image`). Placeholder shown if no image set.

### art.html
3 project cards sorted by `weight`. Detects sections (`.IsSection`) and external links (`.Params.externalLink`). Shows cover image, title, description, "En cours" badge for sections.

### autour-du-moulin.html
Entry list sorted newest first. Shows title, italic date, thumbnail on right. Has back link to Art.

### references.html
Liens utiles page. Auto-collects tags from all entries. Client-side tag filter. Supports `url_externe` for external links.

### _partials/topnav.html
Sticky top nav — avatar/initials, site name, main menu, language switcher (FR/EN/ES), dark mode toggle.

### _partials/article/components/header.html
Supports `hideHeroImage: true` front matter to hide large hero image on article pages while keeping thumbnail in lists.

---

## 5. config.yaml Key Settings

```yaml
baseURL: "http://localhost:1313"          # change to live URL for production
defaultContentLanguage: "fr"
defaultContentLanguageInSubdir: true      # forces /fr/ /en/ /es/ URLs

params:
  mainSections: [art, references]         # what appears in Archive
  hero:
    image: hero.jpg                       # must be in /static/
  article:
    readingTime: false
  comments:
    enabled: false                        # Giscus configured but off

outputs:
  home: [html, rss, json]                 # json required for search

languages:
  fr:
    contentDir: "content/fr"
    menu: Accueil, Art, Archive, Liens utiles, À propos
  en:
    contentDir: "content/en"
    menu: Home, Art, Archive, Useful links, About
  es:
    contentDir: "content/es"
    menu: Inicio, Arte, Archivo, Enlaces utiles, Acerca de
```

---

## 6. Front Matter Reference

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
1. Run mirror-entry.sh
2. Paste French content to Claude
3. Claude returns EN and ES translations
4. Paste into respective index.md files in VS Code

---

## 8. Image Workflow

```bash
# Resize and compress (target ~50kb)
magick ~/Downloads/source.jpg -resize 800x -quality 75 ~/Documents/hugo/stack/content/fr/art/autour-du-moulin/entry-name/image.jpg

# Check size
ls -lh path/to/image.jpg
```

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
| Autour du Moulin | ✓ | ✓ | ✓ | 2 entries: le-projet, echeancier |
| Perpetuelle | ✓ | ✓ | ✓ | External link |
| Recherche et expérimentation | ✓ | ✓ | ✓ | Single page |
| Archive | ✓ | — | — | Stack built-in, auto |
| Liens utiles | ✓ | — | — | EN/ES not yet built |
| À propos | ✓ | ✓ | ✓ | Full CV |
| Search | ✓ | — | — | EN/ES not yet built |

---

## 11. To Do

- [ ] Liens utiles EN and ES versions
- [ ] Search page EN and ES versions
- [ ] Auto-translation via Anthropic API (API key setup pending)
- [ ] Change baseURL to live URL in config.yaml
- [ ] Self-hosting migration (Phase 2)
- [ ] Giscus comments re-enable when self-hosting

---

## 12. Theme Override Map

| Theme file | Our override | Purpose |
|---|---|---|
| layouts/baseof.html | layouts/baseof.html | Remove sidebar, add topnav |
| layouts/home.html | layouts/home.html | Custom hero homepage |
| layouts/_partials/sidebar/left.html | layouts/_partials/sidebar/left.html | Empty — hides sidebar |
| layouts/_partials/article/components/header.html | same | hideHeroImage support |
| assets/scss/custom.scss | assets/scss/custom.scss | All custom styles |

New layouts (no theme equivalent):
- `layouts/art.html`
- `layouts/autour-du-moulin.html`
- `layouts/references.html`
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
hugo 2>&1                                 # full build, check errors
bash mirror-entry.sh content/fr/art/...  # mirror entry to EN/ES
find ~/Documents/hugo/stack/content -type f -name "*.md" | sort  # list all content
xattr -rc ~/Documents/hugo/stack/content # fix VS Code permission errors
git add . && git commit -m "msg" && git push  # commit and deploy
```
