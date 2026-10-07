# Security Policy

## Supported versions

Security fixes target the most recent released version.

| Version | Supported |
| ------- | --------- |
| 0.1.0   | Yes       |

0.1.0 is the initial release prepared for publication. Once published, it is supported
until superseded by a newer release; older releases do not receive separate security fixes.

## Reporting a vulnerability

Private vulnerability reporting is enabled for this repository:

<https://github.com/WumboLabs/tern-tab-ring/security/advisories/new>

Please report security issues through that private channel. Do not put unpatched
vulnerability details, exploit code, credentials, or sensitive logs in a public issue.

Please do not post or otherwise disclose an unpatched vulnerability publicly. When
reporting, include the plugin version, the Tern version, and the steps needed to reproduce
the issue. Reports are handled by the maintainer on a best-effort basis.

Tern Tab Ring is a WumboLabs open-source project, maintained by ripperonincheez.

## Scope

Tern Tab Ring is a small, window-only Tern plugin. Its entire behavior consists of
overriding the built-in `next_tab` and `previous_tab` actions so that navigation traverses
existing tabs across hosts Tern already has attached. It intentionally does not:

- execute subprocesses or shell commands;
- make HTTP or other network requests;
- read credentials or secrets;
- read or write arbitrary files;
- create sessions or tabs for navigation;
- install or run host-side services.

These properties describe intended behavior, not an absolute security guarantee.
