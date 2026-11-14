# Releasing

Releases are built and published by `.github/workflows/release.yml` on a `v*` tag.

## Checklist

1. Update `upstream.lock` if the upstream base changed, and regenerate the patches.
2. Update `CHANGELOG.md` with a `## [vX.Y.Z] - YYYY-MM-DD` section.
3. Build and flash-test locally (`./scripts/bootstrap.sh && ./scripts/build.sh && ./scripts/flash.sh`).
4. Open a PR, merge to `main`.
5. Create a **signed** tag and push it:
   ```bash
   git tag -s vX.Y.Z -m "vX.Y.Z"
   git push origin vX.Y.Z
   ```
6. The `release` workflow builds, attests and publishes the release.
7. Verify:
   ```bash
   sha256sum -c SHA256SUMS
   gh attestation verify Bruce-Freenove-FNK0104AB.bin --repo chinderdelis/bruce-freenove-fnk0104b
   gh release view vX.Y.Z
   ```

## Prereleases

Tags with a suffix (e.g. `v0.1.1-rc.1`) are published as prereleases.

## Testing the workflow

Use `workflow_dispatch` with `dry_run=true` (default) to build and verify without
creating a release. Set `dry_run=false` only when you intend to publish.

## Rules

- Tags are immutable: never force-push or delete a published tag.
- If a release already exists, the workflow refuses to overwrite it unless
  `force=true` is passed via `workflow_dispatch`.
- Use `vMAJOR.MINOR.PATCH` (SemVer) for stable releases.
