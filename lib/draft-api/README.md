## Draft & Experimental APIs

This project includes a set of **draft APIs** that are available for early access and testing. These APIs are **not stable** and may change or be removed in any future release..

### What "Draft" Means

- Draft APIs are **opt-in only** and **not available by default**.
- They may be **incomplete**, **undocumented**, or **subject to breaking changes** at any time.
- These APIs are intended for **experimental use only** and are not guaranteed to remain in the final API surface.

### How to Use Draft APIs

To access draft APIs, you must explicitly opt in by defining the `draft` define in your build.

Once defined, draft APIs will be included at compile-time and become available for use.

>  **Without the `draft` define**, draft-related code will be excluded from your build entirely.

### Release Policy

- **New** draft APIs may be added in **patch** releases.
- **Breaking changes or removals** to draft APIs will only occur in **minor** or **major** releases.
- Draft APIs will not affect the stability of the public API surface.

### Feedback Welcome

If you're using a draft API and have suggestions, questions, or run into issues:
- Open an *issue*
- Or contribute improvements via pull request

Your feedback helps shape the future of these features before they become stable.

---

**Thanks** for experimenting with us and helping evolve the project!