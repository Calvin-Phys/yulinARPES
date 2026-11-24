# Sources and validation

Consolidated on 24 November 2026. The repository copy is maintained under
`AI_skills/matlab-shared-session`; an installed personal copy has the same files.
When updating, validate the maintained copy and synchronize the installed copy.
This file is evidence, not a guarantee about a future connection.

## Repository material reviewed

The following paths are relative to the yulinARPES checkout. They are provenance
references, not required dependencies of a separately installed skill:

- `doc/MATLAB_AI_session_sharing_review.md`: connection models, target guards,
  credential limits, and documented versus internal APIs.
- `doc/codex_matlab_workflow_log.md`: 19 November connection failures, ownership
  findings, and observed sequential handoffs.
- `AI_skills/MATLAB_SETUP.md`: path/dependency setup and live/batch boundaries.
- `Manual/Manual_for_AI.md`: default session operation and task routing.
- `AI_skills/SKILLS_MAP.md`: discovery and shared operating contract.

The installed server's `--version`, `--help`, README, public
`shareMATLABSession.m`, and internal sharing implementation were inspected.
The server identified itself as v0.16.1. The sharing implementation enables the
local connector and writes a private discovery record; the skill includes no
credentials or live discovery snapshots.

## Authoritative references

- [MathWorks v0.16.1 README](https://github.com/matlab/matlab-mcp-server/blob/v0.16.1/README.md): session modes, setup, arguments, Windows environment forwarding.
- [MathWorks ownership guidance, issue 126](https://github.com/matlab/matlab-mcp-server/issues/126): server-launched MATLAB can close on server shutdown; an independently started shared MATLAB is retained.
- [MathWorks retargeting guidance, issue 109](https://github.com/matlab/matlab-mcp-server/issues/109): publish the desired MATLAB, then reconnect the MCP server.
- [Versioned explicit connection parameters](https://github.com/matlab/matlab-mcp-server/blob/v0.16.1/internal/adaptors/application/parameter/defaultparameters/defaultparameters.go): internal startup pinning.
- [MathWorks named Engine connections](https://www.mathworks.com/help/matlab/matlab_external/connect-python-to-running-matlab-session.html): a distinct Python integration.

## Observed checks and limits

- In this chat on 24 November, an MCP probe initially failed to attach. The user
  ran `shareMATLABSession()` in the open MATLAB; the next probe succeeded without
  an MCP restart, reporting MATLAB R2024a. A later read-only probe confirmed the
  release, PID, current folder, and sharing-function location. These tool
  probes did not independently validate a particular dataset or session owner.
- The installed connector configuration already used `existing` mode and
  forwarded `WINDIR`; no connector settings were changed for skill creation.
- The skill's frontmatter, UI metadata, packaged files, and relative links were
  checked. The live diagnostic example was exercised with read-only output.
- Recovery branches are derived from inspected source, primary documentation,
  and the dated repository tests. This task did not intentionally break paths,
  disconnect clients, restart MCP/MATLAB, install an add-on, change `startup.m`,
  test explicit pinning, or run a new multi-agent handoff. Treat those as
  documented procedures or prior evidence, not newly executed acceptance tests.
