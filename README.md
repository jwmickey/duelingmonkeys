# DuelingMonkeys Site

A static Jekyll blog with automated preview deployments and production hosting.

## About

* Static site (no database, no authentication needed)
* Write posts, recipes, games, galleries in [Markdown](https://www.markdownguide.org/cheat-sheet/)
* Automated deployments via GitHub Actions
* Preview deployments for pull requests

## Development Setup

### Local Development

Everything you need to know about Jekyll: http://jekyllrb.com/docs/home/

**Quick start with Docker:**

```bash
docker compose up
```

Then visit http://localhost:4000

The site rebuilds automatically as you edit files (with `--drafts` and `--future` flags enabled, so you can preview unpublished content).

**Without Docker:**

```bash
bundle install
bundle exec jekyll serve --drafts --future
```

## Contributing

### Branching Strategy

**For new features or content:**

1. Create a feature branch from `main`:
   ```bash
   git checkout -b feature/my-new-feature
   ```
   Use descriptive names: `feature/add-game-review`, `feature/recipe-collection`, etc.

2. Make your changes and commit

3. Push to your branch:
   ```bash
   git push origin feature/my-new-feature
   ```

4. Open a pull request on GitHub

5. **Preview your changes** at: `https://pr-{PR-NUMBER}.preview.duelingmonkeys.com`
   - GitHub will automatically comment with your preview link
   - The preview updates with each commit to the PR

6. Once reviewed and approved, merge to `main`

### Content Areas

- **Posts/News**: `_posts/YYYY-MM-DD-title.md`
- **Games**: `_games/title.md`
- **Recipes**: `_recipes/title.md`
- **Gallery**: Images are hosted on S3; use [sync-gallery.yml](.github/workflows/sync-gallery.yml) to update

See individual front matter examples in existing files.

## Deployment Strategy

### Preview Deployments (Pull Requests)

Every pull request automatically:
1. Builds the Jekyll site
2. Deploys to a preview subdomain
3. Posts a comment with the preview link

**Preview URLs:**
- Pull requests: `https://pr-{PR-NUMBER}.duelingmonkeys.com`
- Feature branches: `https://branch-{BRANCH-NAME}.duelingmonkeys.com`

Previews are automatically cleaned up when a PR is closed.

### Production Deployment

Merging to `main` automatically:
1. Builds the Jekyll site in production mode
2. Deploys to `https://duelingmonkeys.com`
3. No manual steps required

**Deployment requirements:**
- GitHub Actions must pass (tests, build succeeds)
- Merge to `main` branch
- Automatic via rsync after a successful build

### Deployment Infrastructure

- **DNS/CDN**: Cloudflare with Flexible SSL/TLS
- **Web Server**: Nginx (runs on dedicated preview subdomain for testing)
- **Deployment**: SSH key-based rsync
- **Deploy User**: Dedicated `deploy` user (least privilege setup)

## GitHub Workflows

### deploy.yml
- Triggers on: pushes to `main` and `feature/**` branches, pull requests
- **Main branch**: Deploys to production
- **PR**: Deploys preview and posts comment
- **Feature branches**: Deploys to preview (useful for testing without a PR)

### sync-gallery.yml
- Manual trigger (or scheduled daily)
- Regenerates gallery manifest from S3 bucket
- Requires: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` secrets

### cleanup-preview.yml
- Triggers when a PR is closed
- Removes preview deployment from server
- Cleans up disk space automatically

## Required Secrets (Repository Settings)

For deployments to work, add these GitHub secrets:

- `DEPLOY_HOST`: Your server IP or hostname
- `DEPLOY_USER`: `deploy` (dedicated deploy user)
- `DEPLOY_PATH`: `/var/www/duelingmonkeys` (base deployment directory; live and preview subdirs deployed as suffixes)
- `DEPLOY_SSH_KEY`: Private SSH key (Ed25519 format)
- `AWS_ACCESS_KEY_ID`: For gallery sync workflow
- `AWS_SECRET_ACCESS_KEY`: For gallery sync workflow

## Troubleshooting

**Docker `compose up` fails with `Bundler::GemNotFound`?**
```bash
docker compose down
docker compose run --rm --entrypoint bash dev -lc 'cd /site && bundle lock --add-platform aarch64-linux && bundle install'
docker compose up -d
docker compose logs --tail=120 dev
```

If needed, force a clean rebuild:
```bash
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

**Build fails locally?**
```bash
bundle install --redownload
docker compose down && docker compose up
```

**Site looks wrong in preview?**
- Check that file names follow Jekyll conventions
- Verify front matter is valid YAML
- Check GitHub Actions logs for build errors

**Preview not updating?**
- Force push to the branch (or close/reopen PR)
- Check GitHub Actions workflow status


