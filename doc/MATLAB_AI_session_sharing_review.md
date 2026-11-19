# MATLAB session sharing for AI agents

Reviewed: 19 November 2026. The source-level details below were checked against
MathWorks MATLAB MCP Server **v0.16.1**. Verify the installed connector version
before applying version-specific settings. Paths, process IDs, and workspace
names must come from the current environment.

## Choose the connection model

Agents can operate a running MATLAB containing data. Passing a Windows/Linux
process ID in a prompt helps identify the intended session; it does not attach
the current MATLAB MCP tools to that process. The inspected tool schemas have
no per-call PID selector.

| Approach | Appropriate use | Limits |
|---|---|---|
| Shared session with MCP `existing` mode | Standard attachment to the desktop containing data. | Discovery selects the most recently shared MATLAB; verify the target. |
| Explicit MCP connection details | Pin a newly launched server to a specific authenticated connector. | Hidden/internal setting in v0.16.1; requires launcher integration and validation. |
| One coordinator executes reviewed functions | Subagents prepare/check work while an agent already owns the intended live connection. | Execution is sequential in that session; return outputs for review. |
| Named MATLAB Engine bridge | A custom Python-based tool must choose a shared MATLAB by name. | Separate API/tool integration and release-compatible Python required. |

For most ARPES tasks, start with documented existing-session sharing and verify
the workspace before each operation. A later
[live handoff test](codex_matlab_workflow_log.md)
confirmed that a fresh subagent can attach to the same independently started
MATLAB and read data left by a prior agent. Serialize shared workspace/GUI
changes; subagents may also return self-contained functions for a coordinator
to execute in the verified session.

## Standard MCP sharing procedure

1. In the MATLAB that owns the data, check `which shareMATLABSession`. If the
   command is absent, use the installed server's documented one-time setup.
   In PowerShell, with `$serverExecutable` and `$matlabRoot` set to the actual
   discovered executable and MATLAB root:

   ```powershell
   & $serverExecutable --setup-matlab "--matlab-root=$matlabRoot"
   ```

   Setup installs an add-on. Verify that this is required and within the task's
   authorization before running it; the command is not routine data processing.

2. In the intended data-owning MATLAB:

   ```matlab
   shareMATLABSession()
   ```

3. Configure the parent agent's existing MATLAB MCP entry. For Codex, a minimal
   example is below; `command` must resolve on `PATH` or be replaced with the
   discovered absolute executable path. Merge with the existing entry:

   ```toml
   [mcp_servers.matlab]
   command = 'matlab-mcp-server'
   args = ['--disable-telemetry', '--matlab-session-mode=existing']
   ```

   On Windows, preserve/enable forwarding of `WINDIR` as described by MathWorks.
   If an approved launcher supplies explicit connection details, also allow
   `MW_MCP_SERVER_MATLAB_SESSION_CONNECTION_DETAILS` through the host's environment
   forwarding configuration. An allowlist does not populate the variable.

4. Establish fresh agent/MCP connections, then check their actual MATLAB target.
   An existing server can retain its previous connection; sharing another MATLAB
   or changing a prompt is not a reliable retargeting mechanism.

## Disconnect before an agent ends

For a sequential handoff, each agent or subagent should close **its own MCP
client connection** after completing and verifying its work, before ending its
turn. Confirm that its client/server exited and that the independently started
MATLAB PID still runs. Leave MATLAB, its base workspace, and requested figures
open. The next agent opens a fresh `existing`-mode connection and checks the
independently expected PID and data before acting. This is an orderly handoff
procedure; sharing does not grant one MCP client exclusive ownership.

The inspected inherited Codex MATLAB tool exposes no per-call disconnect
action. Completing a subagent turn was not verified to stop that inherited MCP
server. For a handoff that requires proof of disconnection, have the agent use
an agent-owned standalone MCP client, close its transport explicitly, and
verify that the server exited while MATLAB remained running. This was tested
with both a synthetic in-memory variable and measured scans in the
[workflow log](codex_matlab_workflow_log.md). If the connection cannot be
explicitly closed, report that limitation instead of claiming a disconnect.
Do not call MATLAB `exit` or stop a host-wide MCP service to disconnect one
agent; the former ends the shared workspace, and the latter can affect other
agents. A MATLAB launched by MCP `new` mode or `auto` fallback can be closed
when that server stops, so start handoff sessions independently of MCP.

MathWorks documents `new`, `auto`, and `existing` modes. `auto` can start a new
MATLAB when discovery fails. `existing` avoids that initial launch fallback.
Do not combine `existing` with `--matlab-root`, `--initial-working-folder`, or
`--matlab-display-mode`. Standard sharing chooses the last MATLAB to publish its
session; avoid sharing every open MATLAB automatically when the intended target
must remain unambiguous. See the [MathWorks setup instructions](https://github.com/matlab/matlab-mcp-server/tree/v0.16.1#arguments).

OpenAI documents that custom subagent files do not override the parent's
`mcp_servers` configuration. Configure it in the parent environment. Inherited
configuration does not prove that parent and child use the same server process
or live MATLAB. See [subagent configuration](https://learn.chatgpt.com/docs/agent-configuration/subagents#custom-agents)
and [MCP configuration](https://learn.chatgpt.com/docs/extend/mcp?surface=cli).

## Precise startup targeting in v0.16.1

The tagged [parameter definitions](https://github.com/matlab/matlab-mcp-server/blob/v0.16.1/internal/adaptors/application/parameter/defaultparameters/defaultparameters.go#L181)
implement hidden flag `--matlab-session-connection-details` and environment
variable `MW_MCP_SERVER_MATLAB_SESSION_CONNECTION_DETAILS`. These are internal-use
settings, not a public per-call PID interface.

The sharing toolbox generates connector details including `port`, `certificate`,
`apiKey`, `pid`, and `basePath`. A PID alone cannot supply this authentication.
The [configuration logic](https://github.com/matlab/matlab-mcp-server/blob/v0.16.1/internal/adaptors/application/config/config.go#L418)
infers `existing` mode when details are supplied without an explicit mode.
Specify `existing` deliberately for a clear connection contract.

A version-pinned launcher can capture the discovery record immediately after
sharing the correct MATLAB, verify its PID independently, retain a private
session-specific snapshot, and load that snapshot into the environment variable
before starting the parent agent/MCP processes. Child MCP launches must receive
the same value. This avoids dependence on whichever session later overwrites
the global discovery record. It is a proposed integration pattern, not a live
subagent attachment test completed by this documentation review.

The snapshot contains an API key. Keep it outside repositories, reports,
prompts, and command-line arguments. Do not construct credentials from a PID or
reuse a record after its MATLAB session has ended. Use the actual sharing
toolbox's discovery location; do not assume another version/platform's path.

MathWorks' [functional tests](https://github.com/matlab/matlab-mcp-server/blob/v0.16.1/tests/functional/matlab/existingexplicitsession_test.go)
exercise explicit targeting, failure without discovery fallback, and preservation
of an external MATLAB when the MCP client closes. They use mock connectors;
they establish intended server behavior, not compatibility with every live UI
or agent host. [Issue 72](https://github.com/matlab/matlab-mcp-server/issues/72)
tracks broader multi-session/per-call selection requirements; inspect current
schemas rather than assuming its proposed interface exists.

## Verify the target before ARPES execution

Obtain the expected PID and workspace names from the intended MATLAB/session
owner independently of the connector being checked. Setting the expected PID
from that same unverified connector defeats the check. A reusable guard can be
saved as a function and called immediately before the requested operation:

```matlab
function assertArpesSession(expectedPid, expectedNames)
assert(feature('getpid') == expectedPid, 'ARPES:WrongSession', ...
    'Wrong MATLAB process; stop without processing.');
expectedNames = cellstr(expectedNames);
for k = 1:numel(expectedNames)
    name = expectedNames{k};
    assert(isvarname(name), 'ARPES:InvalidName', 'Expected a variable name.');
    present = evalin('base', sprintf('exist(''%s'',''var'')', name));
    assert(present == 1, 'ARPES:MissingData', 'Expected data are absent.');
end
end
```

`feature('getpid')` is a commonly used undocumented diagnostic, not a public
attachment API. A PID changes after restart. Variable existence is only an
initial check: verify classes, array shape, axes, and identifying acquisition
metadata against the intended dataset. For figures, verify owned graphics/app
identity through the existing API rather than assuming a reused figure number
still represents the same target.

Keep the guard and mutation in the same tool call. Use distinct derived names,
preserve raw measurements, and serialize changes to shared figures, selections,
app settings, and the base workspace. Several agents reaching one MATLAB do not
receive independent transactional workspaces.

## Named MATLAB Engine alternative

MATLAB supports separately named Engine sessions:

```matlab
matlab.engine.shareEngine('ARPES_Data')
matlab.engine.engineName
```

`ARPES_Data` is an illustrative name, not a recorded dataset/session identifier.
Use the actual returned name if already shared. In a compatible Python with the
matching MATLAB Engine package:

```python
import matlab.engine

target = 'ARPES_Data'
if target not in matlab.engine.find_matlab():
    raise RuntimeError('Required ARPES MATLAB is not shared')
eng = matlab.engine.connect_matlab(target)
```

Always supply a name: [connect_matlab](https://www.mathworks.com/help/matlab/apiref/matlab.engine.connect_matlab.html)
can start MATLAB when called without one and no shared session is found.
MathWorks documents the [named-session workflow](https://www.mathworks.com/help/matlab/matlab_external/connect-python-to-running-matlab-session.html).
This requires a separate bridge exposed to the agents. `shareEngine` does not
configure MCP sharing; a MathWorks collaborator distinguishes the mechanisms
in [issue 66](https://github.com/matlab/matlab-mcp-server/issues/66).

Match Python and Engine to the installed MATLAB release. For example, R2024a
supports Python 3.9–3.11 in the [compatibility table](https://www.mathworks.com/support/requirements/python-compatibility.html).
Installing PyYAML does not install MATLAB Engine or enable attachment.

## Acceptance check and limits

In a controlled verification session, establish fresh parent and child
connections to the designated shared MATLAB. Have each report the same
independently expected PID and dataset metadata; check that no extra MATLAB
appeared. Verify failure when the designated target is unavailable rather than
silently accepting an unrelated workspace. Test failure behavior with a
disposable session, not by terminating a user's data-owning MATLAB.

This guide is based on inspected documentation, v0.16.1 source/tests, and earlier
observed session isolation. Documentation cleanup did not reconfigure a host,
publish a session, restart MATLAB/MCP, run processing, or validate direct
subagent attachment. Use [shared setup guidance](../AI_skills/MATLAB_SETUP.md)
and the relevant [operation skill](../AI_skills/SKILLS_MAP.md) for actual work.
