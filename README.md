# Tern Tab Ring

Cross-host circular tab navigation for Tern.

**Alt+Right** advances through all tabs across connected hosts as one circular ring:

```text
local:1 → local:2 → remote:1 → remote:2 → local:1
```

**Alt+Left** walks the exact same ring in reverse. Existing native keybindings stay in place.

## Features

- One continuous tab ring across connected hosts, with forward/reverse traversal.
- Transparent host boundaries; no host picker.
- Disconnected hosts skipped; reconnecting hosts dynamically rejoin.
- Native Tern `next_tab` / `previous_tab` overrides; no settings rewrite.
- Safe no-op with fewer than two destinations.

## Requirements

Fully validated on Tern 0.5.3 (`b7f1010`). The same implementation was earlier fully
qualified on Tern 0.4.5 (`1d14241`). Other versions may work but are not validated.

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

## Validation

Fully validated on Tern 0.5.3 (`b7f1010`) across both participating hosts: plugin
health, local forward/reverse circular traversal, cross-host traversal with wrap in
both directions, deterministic multi-session ordering, disconnected-host handling with
automatic reconnect, single-destination no-op, existing keybinding integrity, dynamic
topology (tab creation/removal, host availability), state safety, and unlink/relink
rollback with native behavior in between. The same implementation was previously fully
qualified on Tern 0.4.5 (`1d14241`). Native direct-tab shortcuts remain separate from
the two overridden actions.

## License

MIT. A [WumboLabs](https://github.com/WumboLabs) project, authored and maintained by
[ripperonincheez](https://github.com/ripperonincheez).
