# Release Version

GitHub Action used to compute the next release version based on the following
format:

```
<Year>.<ISO week number>.<increment>-<release candidate increment>
```

## Usage

To use the action you can add the following to your GitHub Action workflow
file:

```yaml
jobs:
  build:
    name: build
    runs-on: ubuntu-latest

    steps:
      - name: Check out code
        uses: actions/checkout@v2

      - name: Next version
        id: next_version
        uses: sortlist/release-version-action@main
        with:
          prefix: v
          prerelease: true
          prerelease-prefix: rc.

      - name: Show version
        run: echo "${{ steps.next_version.outputs.version }}"
```

## Inputs

* `prefix:` - a prefix added to the version (default: `v`)
* `prerelease:` - if the current version represents a prerelease, incrementing
  the prerelease counter (default: `false`)
* `prerelease-prefix:` - the prefix of the pre-release part of the version
  (default: `rc.`)

## Outputs

* `version` - will contain the computed version

## Tests

```bash
LC_CTYPE=C ./test/test.bats
```
