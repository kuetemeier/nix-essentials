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

- **Feature:** Introduces a new feature.
- **WIP:** Work in Progess (to build a feature)
- **Fix:** Fixes a bug.
- **Docs:** Documentation-only changes.
- **Style:** Changes that do not affect code behavior (e.g., formatting, whitespace).
- **Refactor:** Code changes that neither fix a bug nor add a feature.
- **Perf:** Changes that improve performance.
- **Test:** Adds or modifies tests.
- **Chore:** Updates to build processes or auxiliary tools.
- **CI:** Changes related to Continuous Integration configurations.

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

1.  **Readability:** Clearly structured and standardized commit history.
2.  **Automation:** Supports tools like:

    - _commitlint_ for enforcing message rules.
    - _standard-version_ for automated changelog generation.

3.  **Semantic Versioning:** Enables automatic versioning based on commit types
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
