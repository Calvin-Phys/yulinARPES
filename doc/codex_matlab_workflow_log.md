# Codex–MATLAB workflow improvement log

## 19 November 2026 — Selecting the data-owning MATLAB

### Goal and starting state

Connect Codex to the live MATLAB workspace containing two ARPES scan variables,
then use `PlotSlices`. The scans were initially in a different MATLAB from the
one reached by Codex. The user opened both plots in the data-owning MATLAB as a
workaround.

The installed MATLAB MCP Server is v0.16.1, and MATLAB is R2024a. The initial
Codex tool reached an empty MATLAB, where neither scan was present. The user
ran `shareMATLABSession()` in the data-owning MATLAB; the private
`sessionDetails.json` discovery record then identified that process. Its
certificate and API key were not copied into this log.

### Connection findings and changes

1. MathWorks' default `auto` mode can launch a new MATLAB when it cannot attach
   to a shared one. `existing` mode attaches only to a published session, and
   selects the MATLAB that most recently ran `shareMATLABSession()`.
2. A fresh, separate MCP diagnostic with
   `--matlab-session-mode=existing` connected to the data-owning MATLAB and
   found both scan variables. This verified sharing and the mode setting at
   that moment.
3. Codex's MATLAB MCP entry in `%USERPROFILE%\.codex\config.toml` was changed to
   `args = ["--disable-telemetry=true", "--matlab-session-mode=existing"]`.
   A backup was saved alongside the file with the suffix
   `.matlab-session-backup`.
   `--disable-telemetry=true` is the explicit form documented by MathWorks.
4. The chat's already-running connector still reached the empty MATLAB after the first
   apparent app restart. Process inspection showed that its Codex agent host
   had remained alive since before the configuration change, and its MCP
   server still had the old launch arguments. Merely refreshing the app view
   did not retarget this connection.
5. Saving the MCP settings and using Settings → Plugins → MCPs → **Restart**
   refreshed the chat. A new MCP server process launched with
   `--matlab-session-mode=existing`. The next tool call returned
   `failed to attach to MATLAB session`. At the later read-only check, neither
   previously observed MATLAB process was running, while the discovery record
   still named the data-owning process. The failure is consistent with a stale
   discovery record. The live data workspace cannot now be verified through
   MCP.

The data-owning MATLAB had been observed as a child of an older MCP server
process. Its watchdog log recorded `Adding process to kill` for that MATLAB.
MathWorks states that a server closes MATLAB when it launched that MATLAB
itself, while a MATLAB started independently and shared is kept when the
server stops. These findings strongly suggest that stopping the old MCP server
closed the data-owning MATLAB; the available logs do not record the exact
shutdown event. Treat MCP-launched MATLAB workspaces as vulnerable to server
restarts.

### Recommended connection procedure

1. Start MATLAB **independently of Codex/MCP** and load the required data.
   Save important unsaved workspace changes before changing agent connections.
2. Run `shareMATLABSession()` in that MATLAB. Note its PID with
   `feature('getpid')` and verify the expected variables there.
3. Keep Codex's MATLAB MCP server in `existing` mode. If its previous attempt
   failed because no MATLAB was available, retry a tool call after sharing; in
   the follow-up below, that attached without another MCP restart. If it is
   already attached to a different MATLAB, restart the MCP server from the
   Codex MCP settings after publishing the new target.
4. In the first MATLAB tool call, compare the returned PID and expected
   workspace variables against the independently observed target. Keep that
   guard in the same call as any subsequent workspace or figure mutation.
5. If attachment fails, check whether the published PID is still running and
   re-run `shareMATLABSession()` in the intended MATLAB before restarting the
   MCP connection. Do not treat a discovery file alone as proof that its MATLAB
   is alive.

`existing` mode fails instead of silently launching an empty MATLAB when no
published session is available. The MCP tool has no per-call PID selector in
the inspected version. `matlab.engine.shareEngine` uses a separate discovery
mechanism and does not publish a MATLAB for this MCP server.

### Disconnecting a MATLAB from AI agents

There are two distinct actions:

- **Disconnect an agent:** Disable or remove that agent's MATLAB MCP server and
  restart its MCP connection. Do this for every connected agent/client. This
  stops that client's tool access; it does not itself prove that the MATLAB
  connector or other clients have been revoked. Do not restart a server that
  launched a MATLAB containing unsaved work without first saving that work.
- **Stop new discovery of a session:** `shareMATLABSession()` enables the MATLAB
  connector and writes a private `sessionDetails.json` containing connection
  credentials. The installed toolbox has a public `shareMATLABSession.m` but no
  public `unshareMATLABSession.m` or documented per-session revoke operation.
  Removing that private discovery record after disconnecting clients would
  prevent normal *new* `existing`-mode discovery until another MATLAB is shared;
  this is an inference from the source, not a tested or documented revocation
  method. It must not be treated as invalidating any credentials an already
  connected client holds. In R2024a, the installed API-key manager reuses an
  existing connector key, so re-running `shareMATLABSession()` is not a key
  rotation procedure. Keep the record and its contents out of repositories.

For a guaranteed end to the running MATLAB endpoint, save the workspace and
close that MATLAB. For keeping MATLAB open while revoking all existing MCP
connections, a supported public procedure was not found in v0.16.1; ask
MathWorks before relying on manual connector or credential manipulation.

### Follow-up verification on the same date

The user relaunched MATLAB independently, reloaded the two scans, ran
`shareMATLABSession()`, and supplied its new PID. The Codex MATLAB tool reached
that exact PID without another MCP restart and found both variables in the
base workspace. It opened both `PlotSlices` views with direction `z`, verified
both figure handles, and
stored the viewer references in the base workspace. The scan value arrays had
shapes `[77 835 1034]` and `[71 835 1135]`. This completes the live
existing-session connection check.

In a disposable MATLAB, test whether disabling the Codex MCP entry terminates
its server process and whether existing connections elsewhere remain usable.
This was not tested against the user's data workspace.

## 19 November 2026 — Subagent handoff with an in-memory workspace

### Question and ownership rule

Can one subagent start MATLAB, load data, obtain its PID, disconnect, and let a
second subagent read the same workspace? The answer is **yes when MATLAB is
started independently of the MCP server and remains running**. An MCP server
using `new` mode, or `auto` when it launches MATLAB, owns that process and
closes it when the server stops. That ownership model cannot preserve an
unsaved in-memory workspace across the owning server's disconnect.

Starting MATLAB with interactive `-r` runs a startup script and leaves MATLAB
open; `-batch` exits after the script. `shareMATLABSession()` publishes the
session for fresh `existing`-mode MCP connections. The PID is an identity check,
not an attachment selector. Codex subagents inherit the parent's MCP server
configuration; custom-agent files do not override `mcp_servers`.

### Disposable live test

1. Subagent A used the operating system to launch a separate MATLAB R2024a
   process with an interactive startup script. It created only an in-memory
   base variable:

   ```matlab
   codexHandoffProbe = reshape(uint16(1:12),3,4);
   shareMATLABSession();
   feature('getpid')
   ```

   The probe was never saved as a MAT file. A wrote the resulting PID to a
   temporary status file so the expected identity was known independently of
   any subsequent MCP connection.
2. A started a fresh standalone MCP client in `existing` mode. It connected to
   the disposable PID and verified the in-memory probe's class, shape, and
   values. A then closed that MCP client's transport; its server exited with
   code 0. The disposable MATLAB was still running afterward.
3. Subagent B's inherited Codex MATLAB tool independently connected to the
   same disposable PID and read the same unsaved probe. B also verified it with
   another fresh standalone `existing`-mode MCP client; that client exited
   cleanly and MATLAB remained running. This demonstrates a real workspace
   handoff across separate agent connections.
4. The parent chat's MCP connection stayed on the user's scan MATLAB during the
   test. After B finished, the parent ran `shareMATLABSession()` there and
   confirmed both scan variables remained present. The discovery record again
   pointed to the user's MATLAB. Only then was the disposable MATLAB stopped
   and the three temporary test files removed.

This test used an explicit standalone MCP client for A's disconnect. It does
not establish that merely ending a Codex subagent turn immediately tears down
that subagent's inherited MCP server. B's inherited tool did prove that a new
Codex subagent can attach to the published MATLAB and read A's in-memory data.

### Implementing a durable handoff

1. Have A start MATLAB as an **OS process independent of MCP**, load the data,
   and run `shareMATLABSession()` in that MATLAB. Record its PID and expected
   workspace metadata outside the connector being checked. Keep the MATLAB
   process running when A finishes.
2. Have A connect with `existing` mode, verify the PID and data, and disconnect
   only its MCP client. Do not call MATLAB `exit` or stop the OS MATLAB process.
3. Have B start a fresh `existing`-mode MCP connection, verify the same expected
   PID and data, and then continue processing. Last-shared discovery is global:
   if another MATLAB runs `shareMATLABSession()` before B connects, B may attach
   there instead. Treat a mismatch as a stop condition.
4. Serialize shared workspace and GUI mutations. When handing back to a prior
   MATLAB, re-run `shareMATLABSession()` there and verify the next connection.

For multiple simultaneous target sessions, the inspected MCP tool has no
per-call PID selection. The version-specific explicit connection-details
approach in the [session-sharing review](MATLAB_AI_session_sharing_review.md)
would require a controlled launcher and private credential handling; it was
not part of this test. MATLAB Engine `shareEngine` and Engine `disconnect()`
use a different mechanism and do not perform this MCP handoff.

## 19 November 2026 — Promoted to the default agent procedure

The tested ownership and handoff rules were summarized at the start of the
[AI manual](../Manual/Manual_for_AI.md#default-matlab-session-workflow) and
reinforced in [shared MATLAB setup](../AI_skills/MATLAB_SETUP.md#verify-the-live-session)
and the [skills map](../AI_skills/SKILLS_MAP.md#shared-operating-contract).
These instructions require every agent and subagent to verify its actual PID
and expected workspace before processing, and default to `existing` mode so an
attachment failure cannot silently create another empty MATLAB. This was a
documentation update; it did not change the live MATLAB or MCP settings.

## 19 November 2026 — Full handoff with measured scans and PlotSlices

The user asked for a sequential live workflow after stopping all prior MATLAB
sessions. The main agent launched one independent desktop MATLAB through the
operating system, ran `shareMATLABSession()` in its startup script, and recorded
its PID. A standalone `existing`-mode MCP client confirmed the PID and empty
scan workspace, then exited with code 0. Read-only checks confirmed MATLAB
remained running and was still the published session.

Subagent 1 connected through its own standalone `existing`-mode MCP client and
used `loader_UI` in script mode with `AssignToBase=true` to load the two
specified NXS files. Both loader reports were validated. The first became an
`OxA_MAP` with `value` shape `[63 835 1034]`; the second became an `OxA_CUT`
with shape `[835 1034]`. The client exited with code 0, while the MATLAB
process and its base-workspace variables remained available.

Subagent 2 started afterward and used its inherited Codex MATLAB tool. In the
same tool call it checked the independently recorded PID and both variables,
classes, and shapes, then called `PlotSlices` with `z` for the 3-D map and `x`
for the 2-D cut. Both figure handles passed `isgraphics`; the viewers opened
in two figures and their handles were retained in the base workspace.

Final read-only process and discovery checks found exactly one MATLAB, with
the same PID recorded at launch. That MATLAB and both plotted figures were left
open for the user. Only temporary startup/MCP test files were removed. This
end-to-end test demonstrates that an OS-owned MATLAB can hold loaded measured
data across an explicit first-subagent MCP disconnect and be used by a fresh
second subagent connection. It does not establish that merely ending an
inherited Codex subagent turn closes that subagent's MCP process.

## 19 November 2026 — Explicit end-of-agent disconnect guideline

The [AI manual](../Manual/Manual_for_AI.md#default-matlab-session-workflow),
[session-sharing guide](MATLAB_AI_session_sharing_review.md#disconnect-before-an-agent-ends),
[shared setup](../AI_skills/MATLAB_SETUP.md#verify-the-live-session), and
[skills map](../AI_skills/SKILLS_MAP.md#shared-operating-contract) now direct
each agent to close its own MCP client before ending a sequential phase, then
verify that MATLAB remains running. The next agent makes a fresh connection
and checks PID plus workspace data. This is an orderly handoff rule; the tests
did not show that a previous connection must end before another can attach.
The standalone-client disconnect was tested; automatic teardown of an
inherited Codex subagent MCP server remains unverified. No live MATLAB or MCP
configuration was changed by this documentation update.

## 24 November 2026 — Reconnect check and reusable skill

In the current chat, an initial read-only MATLAB tool call returned
`failed to attach to MATLAB session`. The existing Codex configuration already
used `--matlab-session-mode=existing`. After the user ran
`shareMATLABSession()` in the open MATLAB, retrying the tool connected to
R2024a without an MCP restart. A subsequent read-only probe reported the release,
PID, current folder, and sharing-function location. No independently supplied PID
or dataset contract was checked, so these probes demonstrate attachment rather
than verification of a particular measurement workspace.

The installed server reported v0.16.1. Its help, README, sharing implementation,
and primary MathWorks guidance were reviewed alongside this log, the sharing
review, shared setup, and AI manual. Their reusable procedure is consolidated in
[matlab-shared-session](../AI_skills/matlab-shared-session/SKILL.md), with separate
troubleshooting and advanced-connection references. The manual, setup guide, and
navigation now point to the skill. Earlier handoff/source observations remain
dated evidence; the consolidation did not repeat destructive failure tests,
restart MATLAB/MCP, or change connector/startup settings.

## References

- [MathWorks MATLAB MCP Server v0.16.1 setup and session modes](https://github.com/matlab/matlab-mcp-server/blob/v0.16.1/README.md)
- [MathWorks `shareMATLABSession` implementation](https://github.com/matlab/matlab-mcp-server/blob/main/matlab/matlab_mcp_toolbox/mcp/%2Bmcpserver/%2Binternal/shareMATLABSession.m)
- [MathWorks guidance on server-owned versus independently started MATLAB](https://github.com/matlab/matlab-mcp-server/issues/126)
- [MathWorks guidance on changing the shared target and reconnecting MCP](https://github.com/matlab/matlab-mcp-server/issues/109)
- [Codex MCP configuration](https://learn.chatgpt.com/docs/extend/mcp?surface=cli)
- [Codex subagent configuration inheritance](https://learn.chatgpt.com/docs/agent-configuration/subagents#custom-agents)
- [MATLAB interactive `-r` and `-batch` startup options](https://www.mathworks.com/help/matlab/ref/matlabwindows.html)
- [MathWorks clarification that Engine sharing is separate from MCP sharing](https://github.com/matlab/matlab-mcp-server/issues/118)
- [Session sharing review](MATLAB_AI_session_sharing_review.md)
