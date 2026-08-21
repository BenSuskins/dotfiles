# Claude Code

- Prefer the AskUserQuestion tool when the decision has discrete options.
  Plain-text questions are fine when the answer is open-ended.
- Matt Pocock's skills load as a plugin, under the `mattpocock-skills:`
  namespace. Nix pins the plugin; `/plugin` does not manage it.
