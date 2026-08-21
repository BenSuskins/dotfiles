# Troubleshooting

> Common issues and fixes for `dotfiles`. Organised by symptom.

## How to use this doc

- Search by symptom (the bold question line) first
- If you fix something not listed here, add it — the bar is "would future-me
  have wanted this written down?"
- Keep entries short: symptom → cause → fix

---

## Apply / darwin-rebuild

**`Could not write domain com.apple.universalaccess`**

Cause: the terminal application lacks Full Disk Access, so `darwin-rebuild`
cannot write the macOS accessibility preferences domain.
Fix: System Settings → Privacy & Security → Full Disk Access → enable for your
terminal application, then re-run `sudo darwin-rebuild switch --flake .#<host>`.

---

_If your fix doesn't fit a section above, add a new H2 section. Keep symptoms
in **bold** so they're scannable._
