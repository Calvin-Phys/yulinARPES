# Advanced connection models

Use these branches only when standard existing-session sharing does not meet
the requested workflow. They are not prerequisites for ordinary MATLAB work.

## Multiple agents or MATLAB sessions

The inspected v0.16.1 tools accept code/file paths, not a PID selector. Standard
discovery follows the most recently shared MATLAB; already attached clients may
keep older connections. Inspect the current tool schema before assuming newer
selection capabilities. A prompt containing a PID does not select a transport.

When multi-agent work is authorized, give each agent the independently expected
PID and dataset contract and verify each connection. Serialize workspace, path,
GUI, and output-file mutations. An alternative is one coordinator executing
reviewed self-contained functions prepared by other agents. Shared discovery
does not provide an exclusive lock. Use the parent's effective MCP configuration
rather than assuming an agent prompt can replace host-level server settings.

## Explicit targeting in v0.16.1

Source inspection found hidden flag `--matlab-session-connection-details` and
environment variable `MW_MCP_SERVER_MATLAB_SESSION_CONNECTION_DETAILS`. These
are internal, version-specific startup settings, not public per-call selection.
Use only for a requested, version-checked launcher integration.

A discovery record contains authenticated connector details, including an API
key, port, certificate, PID, and base path. A launcher can privately snapshot the
record immediately after sharing the independently identified MATLAB, verify
the PID, and supply the snapshot to the processes it starts. Keep the value out
of command arguments, prompts, logs, repositories, and ordinary skill files.
An `env_vars` allowlist forwards a value only if the launching environment has
one; it does not populate that value. Check presence without printing contents.

Explicit settings can override ordinary discovery. An intentional return to
standard sharing must address the populated override at its source and start
a fresh relevant client. Do not clear unrelated environment settings. Do not
reuse a record after MATLAB ends. The repository review described this launcher
pattern but did not validate it with live parent/subagent explicit targeting.

## MATLAB Engine is a separate bridge

For a specifically requested Python Engine integration, MATLAB can publish a
named Engine session with `matlab.engine.shareEngine('AgentData')`. `AgentData`
is an example name. Connect using the actual independently selected name:

```python
import matlab.engine

target = 'AgentData'  # replace with the intended Engine session name
if target not in matlab.engine.find_matlab():
    raise RuntimeError('The required MATLAB Engine session is not shared')
eng = matlab.engine.connect_matlab(target)
```

Check Engine/Python compatibility for the actual MATLAB release. Supply a name;
an unnamed connection can pick another session or start MATLAB if none is shared.
Engine discovery and lifecycle methods do not publish or disconnect an MCP
session. Do not install Engine or build a bridge to repair an ordinary MCP
sharing failure.

## Handoff and revocation

The 19 November 2026 repository log records sequential handoffs with synthetic
in-memory data and measured scans. An agent-owned standalone MCP client closed
its transport, its server exited, and the independently started MATLAB kept its
workspace for a later connection. It did not prove that ending an inherited
Codex subagent turn tears down that subagent's MCP server.

For an explicitly requested verified handoff, record expected PID/data, finish
and verify the work, close only the agent-owned client if supported, verify
server exit and MATLAB survival, then let the next client attach and check.
Keep relevant figures open. If explicit disconnect is unavailable, report it
as unverified; do not claim the connection was closed.

Disconnecting one client does not revoke other clients. No public
`unshareMATLABSession` or guaranteed per-session revoke procedure was found in
the inspected v0.16.1 toolbox. Deleting its private discovery record is not
credential revocation; re-sharing is not key rotation. For a request to revoke
all access while keeping MATLAB open, recheck current supported MathWorks
procedures. Closing MATLAB ends that running endpoint, but requires preserving
unsaved work and explicit authorization to close the session.

## Optional startup convenience

If the user explicitly wants automatic publication, consider adding a guarded
`shareMATLABSession()` to the intended release/profile's existing `startup.m`.
Inspect and merge the file rather than replacing it. Do not enable this merely
by installing the skill. With several MATLABs, publishing each at startup makes
the last-started session the discovery target; an explicit Command Window share
is clearer when the data-owning session must remain unambiguous.
