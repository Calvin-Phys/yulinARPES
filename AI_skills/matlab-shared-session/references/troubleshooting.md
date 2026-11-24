# Troubleshooting MATLAB agent connections

Start with the matching symptom. Make one targeted recovery attempt, repeat the
read-only probe, and inspect the result. If the same failure persists, collect
the relevant diagnostic below rather than looping through restarts. Preserve the
workspace and do not change authentication, networking, or unrelated settings
without a demonstrated cause and task authorization.

## Failed to attach to MATLAB session

1. Check that the intended MATLAB is open and responsive. Have its owner run
   `shareMATLABSession()` there and independently report `feature('getpid')`.
2. Retry `evaluate_matlab_code` once. When the prior attempt never attached,
   re-sharing may be sufficient; a restart is not the default first step.
3. If it still fails, compare the expected PID with running MATLAB processes.
   In PowerShell, this read-only check lists process identity and launch time:

   ```powershell
   Get-Process -Name MATLAB -ErrorAction SilentlyContinue |
       Select-Object Id, StartTime, Path
   ```

   A discovery file can outlive its MATLAB. If the expected process ended, ask
   the user to reopen MATLAB and reload unsaved inputs from available backups;
   do not imply the agent recovered lost memory. Share again and obtain a new
   independently confirmed PID.
4. Verify effective server mode, binary version, and environment forwarding.
   If still necessary, reconnect the specific MCP client after the ownership
   check below. Capture the error text, release, mode, and sanitized logs.

An explicitly supplied connection-details environment variable can pin a stale
or different endpoint despite re-sharing. An allowlist alone does not set its
value. Check whether it is populated without printing its contents; see
[advanced connections](advanced-connections.md).

## Sharing function is missing

In the intended MATLAB, inspect:

```matlab
which shareMATLABSession -all
matlabroot
version('-release')
```

Discover the actual installed server executable from MCP configuration or the
toolkit installation. Set `$serverExecutable` and `$matlabRoot` to the discovered
paths, then inspect `--version` and `--help`. If installation is needed and within
the task's authorization, run the documented one-time setup in PowerShell:

```powershell
& $serverExecutable --setup-matlab "--matlab-root=$matlabRoot"
```

This installs the MATLAB MCP Server Toolbox for the selected MATLAB; it is not
the normal reconnect procedure. Multiple releases may need different add-on
setup. Recheck `which` in the intended MATLAB, then share and probe. Do not reset
the live search path to repair add-on discovery. If the function exists but
fails, capture its specific error before reinstalling anything.

## Connected, but variables or figures are missing

Connection success alone does not establish the intended workspace. Compare the
independently expected PID first, then expected variable class, dimensions, and
dataset metadata. Check named base variables with `evalin('base', ...)`; a helper
function's local workspace is different from the base workspace.

Common causes include another MATLAB, `auto` launch fallback, a separate batch
process, or a fresh agent discovering the last session shared by somebody else.
Stop data/GUI mutations. Publish the intended MATLAB again and reconnect the
relevant client if it remains attached to the old session. Then repeat the guard.
Do not load substitute data into the wrong session simply to make checks pass.

Figure numbers can be reused. Verify retained handles with `isgraphics` and
check the app's public state/ownership before editing. Never use `close all` to
resolve an ambiguous target.

## Sharing a different MATLAB did not switch the tools

The server may retain its existing attachment. Re-sharing updates discovery for
a fresh server connection; an already connected MCP tool has no inspected
per-call PID selector. A PID supplied in a prompt is not a transport credential.

Before reconnecting, establish whether the current MATLAB was independently
started or launched by this MCP server. If ownership is uncertain, preserve
unsaved work through the user's normal save procedure before restarting anything.
Then use the host's MCP reconnect/restart control for the relevant entry and
verify the next tool's PID/data. The historical Codex log used Settings →
Plugins → MCPs → Restart; labels can vary, so inspect the current settings rather
than treating that path as a permanent UI contract. Refreshing a view may leave
the underlying agent host/server alive with old arguments.

For a config change that seems ignored, inspect actual launch arguments locally
and compare them with the edited entry. Redact any connection details before
reporting them. Do not terminate every Codex/MATLAB process to force a refresh.

## MATLAB closed when MCP restarted

An MCP server can stop MATLAB that it launched in `new` mode or via `auto`
fallback. An independently started, shared MATLAB survives that server's normal
disconnect. A later `shareMATLABSession()` call does not transfer ownership of a
process originally launched by MCP.

For future work that must survive agent reconnects, start MATLAB independently,
load the intended data, share it, and connect in `existing` mode. Interactive
`-r` can run startup code and leave MATLAB running; `-batch` exits when done.
Do not recreate the failure using the user's unsaved workspace.

## Tools are unavailable or the MCP server will not start

Inspect the configured executable's existence, `--version`, `--help`, enabled
state, and the host's surfaced startup error. On Windows, preserve forwarding
of `WINDIR` in `env_vars`; merge entries instead of replacing the allowlist.
Use TOML literal single-quoted Windows paths or correctly escaped strings.

For an existing-session entry, remove conflicting launch-only options
(`--matlab-root`, `--initial-working-folder`, `--matlab-display-mode`) from that
entry when authorized. `--matlab-root` remains valid for the separate one-time
`--setup-matlab` command. Installing a skill alone does not register an MCP server.

## A call timed out, hung, or returned an error after partial work

Check whether MATLAB is busy, paused at a breakpoint, or waiting for a modal
dialog. Do not send a stream of probes while an operation is still running.
After it becomes responsive, inspect relevant outputs/status before retrying;
the earlier command may have completed despite the transport error. Capture the
error and determine which mutations occurred.

For legitimate long work, inspect the client's supported tool timeout settings;
there is no universal server timeout flag to invent. Split work only at safe,
observable boundaries. Do not automatically rerun loaders, writes, or plot
creation, or restart a server that owns unsaved MATLAB state.

## Connection works, but project functions do not resolve

Inspect `which entryPoint -all` and the intended checkout version. Add only
required active paths, preserving MCP helpers and the current directory. For
yulinARPES use its `setup_yulinARPES` and `AI_skills/MATLAB_SETUP.md`; helpers in
skill `scripts/` may require their own path addition. Do not use
`restoredefaultpath`, recursively add an entire checkout, or install arbitrary
toolboxes to fix an unverified path problem.

If `restoredefaultpath` already broke communication, repair the sharing toolbox's
path from MATLAB's Command Window using its actual installed location, verify
`which shareMATLABSession`, then share and retry. Avoid further path resets.

## Access denied, authentication, certificate, or local connector errors

Read the exact error. Check that sharing and the agent run under the intended
user/account, and that the published MATLAB is still alive. Re-sharing can
refresh the discovery record, but is not a documented API-key rotation or global
revocation action. Check a populated explicit connection override if applicable.

Use version-matching documentation/logs for connector failures. Do not disable
certificate validation, open firewall ports, expose the connector to a network,
or print the private `sessionDetails.json` to make a local connection work.
Inspect private diagnostics locally and return only the minimum sanitized facts.

## An agent finished, but MATLAB still appears connected

Ending a chat/agent turn is not proof that its inherited MCP client exited.
The inspected MATLAB tools have no disconnect method. Do not use MATLAB
`exit` / `quit`, or stop a shared host-wide service, as a substitute. For a handoff
requiring proof, use an authorized agent-owned client with an explicit transport
close and verify both server exit and MATLAB survival. See
[handoff and revocation](advanced-connections.md#handoff-and-revocation).
