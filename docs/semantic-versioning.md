# Semantic Versioning

## Overview

Semantic Versioning (SemVer) is a versioning standard used for software. It
helps communicate the impact of changes in a clear and predictable manner.

## Version Format

Semantic versions use the format:

```
MAJOR.MINOR.PATCH
```

- **MAJOR:** Incompatible or breaking changes.
- **MINOR:** Backwards-compatible new features.
- **PATCH:** Backwards-compatible bug fixes.

## Rules

1. **Initial Development:** Versions start at `0.y.z`. Anything may change.
2. **Stable Releases:** Start with `1.0.0`. Follows strict rules for changes.
3. **Incrementing Versions:**
   - **MAJOR:** Introduce breaking changes.
   - **MINOR:** Add functionality, no breaking changes.
   - **PATCH:** Fix bugs, no new functionality.

## Example

### Before a Change

```
Version: 1.2.3
```

### After Changes

- Add a feature: `1.3.0`
- Fix a bug: `1.2.4`
- Breaking API change: `2.0.0`

## Benefits

- **Clarity:** Users know what to expect from a version change.
- **Predictability:** Helps with dependency management.

## Resources

- [Semantic Versioning Official Site](https://semver.org)
