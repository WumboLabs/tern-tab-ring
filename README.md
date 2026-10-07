# Tern Tab Ring

Cross-host circular tab navigation for Tern.

## Current Tern versions

Tern 0.6.0 provides native `next_tab_across_sessions` and
`previous_tab_across_sessions` actions that reproduce Tern Tab Ring v0.1.0's tested
core circular cross-session/cross-host navigation behavior. On Tern 0.6.0, prefer
these native actions rather than installing this plugin solely for that behavior.

Tab Ring was originally developed and validated against Tern 0.4.5, where these
action IDs did not exist. Tern introduced them in 0.5.2; they are present in 0.5.3.
Native behavioral equivalence was empirically verified on 0.6.0, not on 0.5.2 or 0.5.3.

The repository remains available as an older-build compatibility/reference
implementation and for possible future extensions beyond native core navigation.

## Features

- One continuous tab ring across connected hosts, with forward/reverse traversal.
- Transparent host boundaries; no host picker.
- Disconnected hosts skipped; hosts restored to the attached set rejoin the ring.
- Native Tern `next_tab` / `previous_tab` overrides; no settings rewrite.
- Safe no-op with fewer than two destinations.

## Requirements

Fully validated on Tern 0.5.3 (`b7f1010`). The same implementation was earlier fully
qualified on Tern 0.4.5 (`1d14241`). On Tern 0.6.0, release 0.1.0 passed
compatibility qualification when enabled and bound to its overridden
`next_tab` / `previous_tab` actions. Other versions are not validated.

## Native replacement on Tern 0.6.0

Stock Tern 0.6.0 ships these actions without default shortcuts. Bind them as desired.
For Alt+Right / Alt+Left, merge these entries into `settings.json`'s existing
`keybinds` object, preserving unrelated bindings:

```json
{
  "keybinds": {
    "alt+right": "next_tab_across_sessions",
    "alt+left": "previous_tab_across_sessions"
  }
}
```

Tab Ring overrides `next_tab` / `previous_tab`; it does not register Alt chords.
Bindings to the across-session actions use native navigation, not the plugin.
Disable Tab Ring when using the native replacement. Bindings that still target
`next_tab` / `previous_tab`, including leader n/p if configured that way, return to
ordinary session-local navigation when the plugin is disabled; migrating those
bindings is a separate choice.

## Installation

```bash
tern plugin install github.com/WumboLabs/tern-tab-ring
```

Open a fresh Tern window after installation to verify the integration with your attached hosts.

## Development linking

```bash
tern plugin link /path/to/tern-tab-ring
```

Edit the linked runtime files, then run `tern plugin reload` and verify in a fresh window.

## Removal

For an installed plugin:

```bash
tern plugin remove tern-tab-ring
```

For a development-linked plugin:

```bash
tern plugin unlink tern-tab-ring
```

Removal restores native action behavior without rewriting settings.

## Updating

Tern (through 0.5.3) has no separate plugin-update command. Replace an installed copy using:

```bash
tern plugin install github.com/WumboLabs/tern-tab-ring --force
```

`--force` replaces an installed copy, never a linked one. For a linked checkout, update its
files and run `tern plugin reload`. Verify in a fresh window afterward.

## Ordering

The topology is rebuilt on every invocation. Connected-host membership comes from Tern;
sessions follow `sessions:list()` ordering, and tabs within each session follow their native
one-based positions. Forward/reverse navigation is exactly circular ±1 traversal of this
same ring. Host identity is not inferred from tab or pane IDs.

## Security / scope

The implementation is window-only, with no external dependencies. It does not intentionally
execute subprocesses, run shell commands, make HTTP/network requests, read credentials, read
or write arbitrary files, create sessions or tabs for navigation, or install host services.
Cross-host access uses Tern's existing attached-host model. The plugin does not mutate
`settings.json`. See [SECURITY.md](SECURITY.md) for the security policy and how to report
vulnerabilities.

## Known Tern behavior

- Action-dispatch paths that bypass overrides may retain native behavior. In particular,
  `cx.actions:run("next_tab")` runs the built-in directly in the tested version.
- Tern's shown-session state is daemon-global. Switching a remote session can also be
  reflected by another window attached to that daemon. This is native Tern behavior,
  not a plugin defect.
- Rejoin is validated for supported host re-add / restoration lifecycles: a re-added
  host rejoins the ring on the next invocation, and a fresh window automatically
  reattaches saved hosts. Automatic rejoin after a true transport outage (network drop
  or remote service interruption) in an existing window has not been proven and should
  not be assumed.

## Validation

Fully validated on Tern 0.5.3 (`b7f1010`) across both participating hosts: plugin
health, local forward/reverse circular traversal, cross-host traversal with wrap in
both directions, deterministic multi-session ordering, disconnected-host skip with
rejoin across host removal/restoration lifecycles, single-destination no-op, existing
keybinding integrity, dynamic topology (tab creation/removal, host availability), state
safety, and unlink/relink rollback with native behavior in between. The same
implementation was previously fully qualified on Tern 0.4.5 (`1d14241`). Native
direct-tab shortcuts remain separate from the two overridden actions.

On Tern 0.6.0, release 0.1.0 additionally passed compatibility qualification when
enabled and bound to its overridden actions. Native equivalence covered local tabs,
multiple sessions, attached hosts, forward/reverse wrap, exact inverse traversal,
deterministic ordering for the same topology, explicit disconnected-host removal,
supported re-add, single-destination no-op, no picker and no navigation-side settings
mutation. Automatic reconnect/rejoin after a true transport outage remains unproven
for both native and plugin paths.

## Attribution

Built for [Tern](https://stencil.so/tern) by Stencil Labs. Tern Tab Ring is a
third-party WumboLabs plugin and is not affiliated with or endorsed by Stencil Labs.

## License

MIT. A [WumboLabs](https://github.com/WumboLabs) project, authored and maintained by
[ripperonincheez](https://github.com/ripperonincheez).
