# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is the personal blog and portfolio website for Salar Rahmanian at softinio.com, built with Hugo. The theme is embedded directly in the project (flat layout, no separate theme repo or module import).

## Commands

```bash
# Start local dev server
hugo server

# Build the site
hugo build

# Create a new blog post
hugo new post/my-new-post/index.md

# Create a new TIL entry
hugo new til/my-til-entry.md
```

## Architecture

### Technology Stack
- **Static Site Generator**: Hugo
- **CSS**: Plain CSS via Hugo Pipes (assets/css/style.css), fingerprinted at build time
- **Fonts**: Google Fonts (Inter)
- **Deployment**: Cloudflare Pages

### Directory Structure
- `layouts/_default/baseof.html`: Master template (head, topbar, sidebar+main layout, footer)
- `layouts/partials/`: Reusable components (head, topbar, sidebar, footer, hero, post-item, til-item)
- `layouts/index.html`: Home page (hero + recent posts)
- `layouts/post/`: Blog article list and single templates
- `layouts/til/`: TIL list and single templates (uses til_category param for labels)
- `layouts/projects/`: Project list (sorted by weight, no dates) and single templates
- `layouts/talks/`: Talks list (sorted by weight, year-only dates) and single templates
- `layouts/page/single.html`: Standalone pages (about, subscribe, resume) — triggered by `type = "page"` in front matter
- `layouts/shortcodes/`: Custom shortcodes (peertube, full_width_image, rawhtml)
- `layouts/_default/`: Fallback list/single + taxonomy terms/taxonomy pages
- `assets/css/style.css`: All theme CSS with CSS custom properties
- `static/js/copy-code.js`: Copy-to-clipboard button for code blocks
- `static/js/theme-toggle.js`: Light/dark theme switcher
- `static/js/scroll-top.js`: Scroll-to-top button
- `static/js/matomo.init.js`: Matomo analytics initialisation (loaded in production only)
- `archetypes/`: Content scaffolding templates (default, post, til)

### Content Structure
- `content/post/`: Blog articles (page bundles with colocated images)
- `content/til/`: "Today I Learned" short entries (flat .md files with `til_category` param)
- `content/projects/`: Project showcase (page bundles, sorted by weight)
- `content/talks/`: Conference talks (page bundles, sorted by weight)
- `content/archived/`: Archived older posts
- `content/about/`: About page (`type = "page"`)
- `content/subscribe/`: Subscribe page with Substack embed (`type = "page"`)
- `content/resume/`: Resume page (`type = "page"`)

### Configuration
- Navigation is menu-driven: `main` (topbar), `sidebar_pages`, `sidebar_about`, `footer`
- Social links: `params.social` array of `{name, url}` — used in sidebar and footer
- Hero links: `params.heroLinks` array — shown on home page hero section
- Sidebar "Recent Posts" is dynamically queried from the `post` section (not menu-driven)
- Active nav state is detected by comparing current page's `.Section` against menu item `.Identifier`
- No `theme` directive or module import — all layouts/assets live at the project root

### Shortcodes
- `{{< youtube "VIDEO_ID" >}}` — Hugo built-in YouTube embed
- `{{< peertube id="VIDEO_ID" >}}` — PeerTube embed (watch.softinio.com)
- `{{< full_width_image src="image.jpg" alt="description" >}}` — Full-width image
- `{{< rawhtml >}}...{{< /rawhtml >}}` — Raw HTML passthrough

### Front Matter Conventions
- Blog posts: `title`, `date`, `description`, `tags`, `categories`, optional `[params]` with `toc`, `keywords`, `social_media_card`
- TIL entries: `title`, `date`, `tags`, `categories`, `[params]` with `til_category`
- Projects/Talks: `title`, `weight` (for sort order), `tags`, `categories`, optional `[params]` with `projectUrl`
- Standalone pages: `title`, `type = "page"`
