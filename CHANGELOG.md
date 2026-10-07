# Changelog

## Unreleased

- Document Tern 0.6.0 native across-session actions equivalent to Tab Ring v0.1.0's
  tested core cross-session/cross-host navigation, and recommend the native actions.
- Show native Alt+Right / Alt+Left bindings and explain the separate leader-binding
  choice when disabling Tab Ring.
- Preserve historical 0.4.5 / 0.5.3 qualification and 0.6.0 plugin compatibility;
  distinguish action introduction in 0.5.2 from equivalence proven on 0.6.0.
- Retain the plugin as an older-build compatibility/reference implementation and
  base for possible future extensions.
- Clarify that automatic reconnect/rejoin after a true transport outage remains
  unproven for native and plugin paths.

## 0.1.0 — 2026-10-07

- Cross-host circular tab navigation.
- Exact forward/reverse traversal with Alt+Right / Alt+Left.
- Connected-host-aware dynamic ring, rebuilt on invocation.
- Native `next_tab` / `previous_tab` action overrides without settings rewrites.
- Safe no-op with fewer than two destinations.
- Window-only implementation with no external dependencies.
