# OpenFL Release Policy

This `RELEASE_POLICY.md` file outlines how OpenFL manages versioning, release cadence, and feature stability. It is meant to be included in the root of the OpenFL GitHub repository or any fork that follows a similar structure.

OpenFL follows a structured versioning model to balance **stability**, **developer feedback**, and **ongoing innovation**. We loosely follow [Semantic Versioning (SemVer)](https://semver.org/) with practical allowances for experimental APIs.

## Version Format
```
MAJOR.MINOR.PATCH
```
- **MAJOR** – Breaking changes or architecture overhauls
- **MINOR** – Backward-compatible new features or platform support
- **PATCH** – Bug fixes and small non-breaking changes; may include draft APIs if opt-in and clearly isolated

---

## Release Types

### Patch Releases (`x.y.Z`)
Patch releases are:
- Focused on bug fixes and platform compatibility
- Allowed to include **experimental or draft APIs** if they:
  - Do not affect existing stable behavior
  - Are strictly opt-in
- Must not change or remove public APIs without exceptional reason

### Minor Releases (`x.Y.0`)
Minor releases:
- Introduce new features, APIs, or improvements
- May stabilize previously experimental features
- Maintain full backward compatibility
- May include optional performance enhancements or dependency bumps

### Major Releases (`X.0.0`)
Major releases:
- Introduce breaking changes, deprecated API removal, or major system rewrites
- May require migration steps
- Include detailed changelogs and migration guides

---

## Draft & Experimental APIs
Experimental APIs help us gather early feedback and encourage community experimentation. These APIs:

- Should be gated behind compiler flags
- May appear in patch releases *if fully isolated and opt-in*
- Are not guaranteed to remain stable or even exist in future versions

These features are clearly documented in changelogs and should be used with caution.

---

## Changelogs
Every release includes a `CHANGELOG.md` entry with:
- Highlights of fixes, features, and improvements
- Notes on experimental, deprecated, or removed APIs
- Migration steps (for major releases)

---

## Dependency Policy
- Dependencies may be updated in patch or minor releases only if the update is non-breaking
- Platform-specific workarounds and fixes may be included in any release
- Major version updates of dependencies happen during OpenFL major or minor releases only

---

## Community Feedback
OpenFL welcomes early feedback via:
- GitHub Issues and Discussions
- Pull Requests on experimental features
- Feature proposals or RFC-style discussions

Use experimental APIs to help shape OpenFL’s future — responsibly!

---

## Release Summary Table

| Release Type | Bug Fixes | New Features | Draft APIs | Breaking Changes |
|--------------|-----------|---------------|-------------|------------------|
| Patch        | ✅         | 🔹 (hidden/opt-in) | ✅ (opt-in only) | ❌                |
| Minor        | ✅         | ✅             | ✅          | ❌                |
| Major        | ✅         | ✅             | ✅          | ✅                |

---

For internal contributors: please reference this policy before introducing new APIs or merging platform-specific patches.
