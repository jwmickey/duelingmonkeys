# Copilot Instructions for DuelingMonkeys

## Repository Overview

This is a static Jekyll blog for DuelingMonkeys.com featuring posts, games, recipes, and a photo gallery. The site uses GitHub Actions for automated deployments to production and preview environments.

## Technology Stack

- **Static Site Generator**: Jekyll 4.3.3
- **Language**: Ruby 3.3
- **Frontend**: HTML, CSS, JavaScript (vanilla)
- **Containerization**: Docker with Docker Compose
- **Hosting**: Custom server via rsync deployment
- **Gallery Storage**: AWS S3

## Development Setup

### Local Development
- Use Docker Compose for development: `docker compose up`
- Site available at http://localhost:4000
- Jekyll auto-rebuilds on file changes with `--drafts` and `--future` flags enabled
- Manual setup: `bundle install` then `bundle exec jekyll serve --drafts --future`

### Building and Testing
- Build: `JEKYLL_ENV=production bundle exec jekyll build`
- Output directory: `_site/`
- No automated test suite exists; manual validation required

## Project Structure

### Content Collections
- **Posts**: `_posts/YYYY-MM-DD-title.md` - Blog posts and news
- **Games**: `_games/title.md` - Game descriptions with metadata
- **Recipes**: `_recipes/title.md` - Cooking recipes
- **Gallery**: Images hosted on S3, manifest generated via `sync-gallery.yml` workflow

### Key Directories
- `_layouts/` - Jekyll layouts (default, posts, game, recipe, etc.)
- `_includes/` - Reusable Jekyll components
- `_sass/` - Stylesheets
- `_plugins/` - Custom Jekyll plugins
- `.github/workflows/` - CI/CD workflows

## Deployment

### Workflows
1. **deploy.yml**: Builds and deploys on push/PR
   - Main branch → Production (`/live`)
   - PRs → Preview (`/preview/pr-{number}`)
   - Feature branches → Preview (`/preview/branch-{name}`)

2. **sync-gallery.yml**: Regenerates gallery manifest from S3 (manual or scheduled)

3. **cleanup-preview.yml**: Removes preview deployments when PR closed or branch deleted

### Secrets Required
- `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_PATH`, `DEPLOY_SSH_KEY`
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`

## Code Conventions

### General Guidelines
- Use existing patterns and conventions found in the codebase
- Keep changes minimal and surgical
- Preserve existing formatting and style

### HTML/JavaScript
- Gallery uses vanilla JavaScript with hash-based routing
- Event listeners preferred over inline onclick handlers
- Use `decodeURIComponent` for URL-encoded gallery names
- Gallery lightbox uses `pointer-events: none` when closed and clears image src after 300ms

### Jekyll/Markdown
- All content files use YAML front matter
- Follow existing front matter patterns for each content type
- Use Markdown for content formatting
- Jekyll configuration in `_config.yml`

### Ruby/Gems
- Gemfile specifies dependencies
- Only add gems if absolutely necessary for the task

## File Handling

### Excluded Files
The following are excluded from Jekyll builds (see `_config.yml`):
- `.ruby-version`, `Gemfile*`, `Dockerfile`, `docker-compose.yml`
- `provision.sh`, `README.md`, `vendor/`

### Important Files to Preserve
- Do not modify workflow files unless specifically required
- Gallery implementation in `gallery/index.html` has specific functionality for routing and lightbox

## Testing and Validation

- No automated test framework exists
- Manual testing required:
  - Test locally with Docker Compose
  - Verify Jekyll builds successfully
  - Check that content renders correctly
  - Validate links and images load properly

## Common Tasks

### Adding Content
- Posts: Create `_posts/YYYY-MM-DD-title.md` with proper front matter
- Games: Create `_games/title.md` with game metadata
- Recipes: Create `_recipes/title.md` with recipe details

### Updating Gallery
- Images stored on S3, not in repository
- Use `sync-gallery.yml` workflow to regenerate manifest
- Gallery implementation in `gallery/index.html`

### Troubleshooting Builds
- Check Docker logs: `docker compose logs --tail=120 dev`
- Clean rebuild: `docker compose down -v && docker compose build --no-cache`
- Redownload gems: `bundle install --redownload`

## Best Practices

1. **Minimal Changes**: Make smallest possible modifications to achieve goals
2. **Follow Patterns**: Use existing code patterns and conventions
3. **Test Locally**: Always test with Docker Compose before committing
4. **Preserve Structure**: Don't reorganize or refactor unrelated code
5. **Security**: Never commit secrets; use GitHub repository secrets
6. **Documentation**: Update README.md if making significant structural changes
7. **Dependencies**: Avoid adding new gems or dependencies unless absolutely necessary
