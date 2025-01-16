# Conventional Commits Documentation

## Overview

The **Conventional Commits** specification provides a simple, structured format
for writing commit messages. It improves clarity, facilitates automated tooling,
and supports semantic versioning (SemVer) workflows.

## Commit Message Structure

A commit message should follow this format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Elements of the Commit Message

### 1. `type` (Required)

Specifies the nature of the commit. Common types include:

- **feat:** Introduces a new feature.
- **wip:** Work in Progess (to build a feature)
- **fix:** Fixes a bug.
- **docs:** Documentation-only changes.
- **style:** Changes that do not affect code behavior (e.g., formatting, whitespace).
- **refactor:** Code changes that neither fix a bug nor add a feature.
- **perf:** Changes that improve performance.
- **test:** Adds or modifies tests.
- **chore:** Updates to build processes or auxiliary tools.
- **ci:** Changes related to Continuous Integration configurations.
- **update:** Update of dependencies and modules

### 2. `scope` (Optional)

Specifies the module, feature, or component the commit affects. Examples:

```
feat(api): add user authentication endpoint
fix(ui): resolve button alignment issue
```

### 3. `description` (Required)

A concise summary of the change, written in the present tense. It should be 50
characters or less.

### 4. `body` (Optional)

Provides a more detailed explanation of the commit, including motivations and
context. Line breaks should be used for readability.

### 5. `footer` (Optional)

- **Breaking Changes:** Includes a `BREAKING CHANGE` keyword for incompatible
  changes:

  ```
  BREAKING CHANGE: API endpoint /v1/token has been removed.
  ```

- **Issue references:** Links to issues or tickets, e.g., `Closes #123` or
  `Resolves JIRA-456`.

## Examples

### Basic Commit

```
feat(auth): add OAuth2 support
```

### Commit with Body

```
fix(server): resolve crash on startup

The issue was caused by a null pointer exception in the initialization phase.
A null check has been added to prevent this.
```

### Commit with Footer

```
refactor(auth): update token validation logic

Improved code readability and reduced complexity in token validation.

BREAKING CHANGE: The token validation endpoint now requires additional headers.
Closes #45
```

## Benefits

1. **Readability:** Clearly structured and standardized commit history.
2. **Automation:** Supports tools like:
   - *commitlint* for enforcing message rules.
   - *standard-version* for automated changelog generation.
3. **Semantic Versioning:** Enables automatic versioning based on commit types
   (e.g., `fix` for patches, `feat` for minor updates, `BREAKING CHANGE` for
   major releases).

## Tools

- **commitlint:** Validate commit messages against Conventional Commit rules.
- **standard-version:** Automate versioning and changelog generation.
- **Semantic Release:** Fully automate versioning and package publishing based
  on commit messages.

## Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org)
- [Semantic Versioning](semantic-versioning.md)
