---
name: matlab-shared-session
description: Connect agents to an existing, data-owning MATLAB through the MathWorks MCP server, verify the target workspace, recover failed or wrong-session connections, and preserve MATLAB during agent handoffs. Use for live MATLAB connection, sharing, reconnection, and session ownership questions; use operation-specific skills for scientific processing after attachment.
---

# MATLAB shared session

Use the user's intended running MATLAB. Keep its workspace and figures available
across agent work. The ordinary route is an independently started MATLAB shared
with `shareMATLABSession()` and an MCP server in `existing` mode.

## Connect with the least disruption

1. Discover the available MATLAB tools and inspect the existing MCP configuration
   when relevant. Do not install a second connector or replace a working entry.
   Prefer the connected `evaluate_matlab_code` tool over UI control or a separate
   MATLAB process. Inspect its schema; tool names may differ across hosts.
2. Try one harmless probe with no project-folder argument:

   ```matlab
   fprintf('MATLAB release: %s\n', version('-release'));
   fprintf('MATLAB PID: %d\n', feature('getpid'));
   fprintf('Current folder: %s\n', pwd);
   fprintf('Sharing function: %s\n', which('shareMATLABSession'));
   ```

   `feature('getpid')` is an undocumented identity diagnostic, not an attachment
   API. This probe does not independently prove that the target is correct.
3. If attachment fails, have the user run the following in the **intended open
   MATLAB's Command Window**, then retry the probe after they confirm completion:

   ```matlab
   shareMATLABSession()
   feature('getpid')
   ```

   Do not ask for the same action again if the user already confirmed it in the
   current connection attempt. A previously failed connector may attach on the
   next tool call without a restart. This worked in the 24 November 2026 session.
4. Compare the tool PID with one independently obtained from the intended MATLAB
   (user's Command Window or an independently verified launch record). For loaded
   data, inspect the expected variables' names, classes, dimensions, and relevant
   acquisition metadata; for GUI tasks, verify the actual app/figure identity.
   Obtain expected inputs from the task or user. Do not define the expected PID
   using the unverified tool's own output. Metadata inspection can start with:

   ```matlab
   evalin('base', 'whos')
   ```

   Prefer named-variable inspection for large workspaces; do not dump raw arrays.
   A successful probe is a connection check; report target/data verification
   separately when those inputs are not yet known.
5. Stop mutations if the PID, dataset, or figure is wrong. Read
   [troubleshooting](references/troubleshooting.md) for the matching symptom.
   Preserve independently established expected identity across reconnects; refresh
   it only after an independently confirmed MATLAB restart or intentional switch.

## Configure only when needed

Merge changes into the parent's existing MATLAB MCP entry, preserving unrelated
settings. Resolve the actual executable path and confirm `--version` / `--help`.
This Windows example uses an illustrative path that must be replaced:

```toml
[mcp_servers.matlab]
command = 'C:\path\to\matlab-mcp-server.exe'
args = ['--disable-telemetry=true', '--matlab-session-mode=existing']
env_vars = ['WINDIR']
```

Keep existing environment forwarding entries. `existing` avoids `auto`'s fallback
to a new, empty MATLAB. Do not combine it with `--matlab-root`,
`--initial-working-folder`, or `--matlab-display-mode`. Existing-session sharing
is documented for R2023a onward; the local runtime check used R2024a and server
v0.16.1. Recheck version-specific details on other installations.

If `which shareMATLABSession` returns nothing, follow the one-time setup in
[troubleshooting](references/troubleshooting.md#sharing-function-is-missing).
Installing this skill does not install or configure the MATLAB connector.

Sharing another MATLAB changes discovery for **fresh** connections; it does not
reliably retarget an already attached server. Reconnect only the relevant MCP
client when necessary, after checking process ownership and unsaved work.

## Operate in the verified session

- Include the target guard in the same call as a workspace or figure mutation.
  Build assertions with the independently known numeric PID and actual expected
  variables; inspect their shapes/classes before processing. For existence checks,
  validate names with `isvarname` before interpolating them into `evalin`.
- Serialize shared workspace, path, and GUI changes. Multiple connections to one
  MATLAB share state; they do not provide isolated or transactional workspaces.
- Preserve raw inputs, unrelated variables/figures, and the current folder. Use
  distinct output names and retained figure handles. Do not use `clear all`,
  `close all`, or `restoredefaultpath`; the latter can break MCP communication.
- Check `which entryPoint -all` before adding paths. Add only needed directories.
  For ARPES, read the checkout's `AI_skills/MATLAB_SETUP.md` and operation skill;
  avoid recursively adding an entire checkout and exposing archived duplicates.
- A batch run has a separate workspace and does not retain interactive windows.
  Use it only when independent file inputs and saved outputs satisfy the task.
- A timeout does not prove MATLAB stopped or rolled back. Inspect status/results
  before retrying a command with side effects.

## Finish and hand off

Leave the user's MATLAB and requested figures open. Closing an MCP client is
different from stopping MATLAB or revoking every client's access. Never use
MATLAB `exit` / `quit` as an agent disconnect.

For an explicitly requested sequential handoff, close an **agent-owned** MCP
client if supported, verify that its server exited and the independently started
MATLAB remains running, then have the next connection repeat PID/data checks.
The inspected inherited Codex tools expose no disconnect action. Ending a turn
does not prove disconnection; report that limit without stopping a host-wide
service. Do not create a standalone bridge or delegate work just to satisfy an
ordinary task's completion. For authorized multi-agent work, explicit pinning,
Engine alternatives, or access revocation, read
[advanced connections](references/advanced-connections.md).

Report the connection outcome, actual release, target/data checks, and remaining
limitations. Do not save live PIDs, private paths, credentials, or measurement
identifiers into reusable skill files. Read
[sources and validation](references/sources-and-validation.md) for provenance and
the boundary between observed behavior and untested recovery branches.
