# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal blog and portfolio website for Salar Rahmanian (softinio.com) built with Zola static site generator, managed with Nix Flakes, and deployed to Cloudflare Pages.

## Commands

### Development
```bash
# Enter development shell with all dependencies
nix develop

# Start local development server
zola serve

# Build the site
zola build
```

### Building with Nix
```bash
# Build the site using Nix
nix build

# The output will be in result/

# Update flake inputs to latest versions
nix flake update
```

### Deployment
```bash
# Deploy to Cloudflare Pages
wrangler pages deploy public/
```

### Testing
```bash
# Check for broken links and validate build
zola check
```

### CI/CD

This project uses GitHub Actions for continuous integration and deployment:

- **Main branch pushes**: Deploys directly to production (https://www.softinio.com)
- **Pull requests**: Deploys to preview URLs (https://[branch-name].softinio.com)
- **Other branch pushes**: No deployment (only builds on PR creation)

Required secrets in GitHub repository settings:
- `CLOUDFLARE_ACCOUNT_ID`: Your Cloudflare account ID
- `CLOUDFLARE_API_TOKEN`: Cloudflare API token with Pages:Edit permissions

## Architecture

### Technology Stack
- **Static Site Generator**: Zola (Rust-based) - NOT Hugo
- **Theme**: Tabi theme (pinned to specific commit in flake.nix)
- **Package Management**: Nix Flakes
- **Hosting**: Cloudflare Pages
- **Comments**: Isso (self-hosted at comments.softinio.com)
- **Analytics**: Matomo (self-hosted at wisdom.softinio.com)

### Content Structure
- `content/post/`: Main blog articles with full metadata
- `content/projects/`: Project showcase pages
- `content/talks/`: Conference presentations
- `content/til/`: "Today I Learned" short posts
- `content/archived/`: Archived posts

### Key Configuration Files
- `config.toml`: Zola site configuration with theme settings, CSP headers, and integrations
- `flake.nix`: Nix development environment and build configuration
- `wrangler.toml`: Cloudflare deployment configuration

### Template Customizations
- `templates/partials/custom_header.html`: Matomo analytics integration
- `templates/shortcodes/`: YouTube and PeerTube video embedding
- `templates/subscribe.html`: Newsletter subscription page