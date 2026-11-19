# Experience record: kz_plot and plotBZ_V1

These lessons summarize the improvement sessions recorded on 16–17 November
2026. The statements below distinguish observed outcomes from recommendations
for future work. They are not a mandate to repeat the same layout or architecture.

## Evidence and source files

Links below resolve relative to this document; source names in prose are
relative to the repository root:

- [kz_plot review](../../../doc/kz_plot_review.md): compact layout, synchronized
  controls, recoverable managed overlays, preserved axes, and visible launch.
- [plotBZ_V1 improvement log](../../../doc/plotBZ_V1_improvement_log.md): plan,
  implementation, numerical/GUI checks, user feedback, and screenshots.
- [Plot BZ operation skill](../../arpes-plot-bz/SKILL.md) and its
  [helper](../../arpes-plot-bz/scripts/plotbz_agent.m): a concrete AI-facing API.
- [Skill session summary](../../session_summary.md): API development and
  independent behavioral validation.

The [initial Plot BZ review](../../../doc/plotBZ_V1_review.md) describes earlier
geometry defects and their fixes. Read its dated implementation record and the
later improvement log before treating an original finding as a current defect.
The reusable decisions below are self-contained; those records provide detail.

## What the sessions achieved

| Area | Observed result | Transferable lesson |
|---|---|---|
| GUI workflow | Crystal/orientation, BZ plotting, and simulation arranged in three columns | Group by user decisions; choose columns/tabs/panels to fit the actual workflow |
| Clutter | Five computed vector readouts removed, numerical vector helpers retained | Trace dataflow before removing a UI element or function |
| Structure | Generated callbacks consolidated and dead boilerplate removed | Preserve bound entry points while making the implementation inspectable |
| Simulation | Fixed-hv and photon scans share a validated free-electron backend | Reuse scientific calculations across modes and interfaces |
| Ownership | Tagged BZ and simulation objects cleared independently of measured data | Treat graphics ownership as part of the application contract |
| AI control | Configure/update/read/plot/simulate/list/clear facade with explicit defaults | Make automation deterministic and verifiable without pixel clicking |
| User feedback | Bold coloured headings, index steppers, separate section/scan colours | Visual review and user iteration add requirements that static checks miss |
| Rendering | Legacy painters setting plus explicit vector-PDF export | Test the output format, not only a property value |
| Final recorded checks | 26 repository tests passed in MATLAB R2024a; 20 package files had zero analyzer notices | State the release, scope, and evidence; counts alone are not the acceptance criterion |

Two test-only informational notices concerned intentional legacy Renderer
assertions, guarded by release. The earlier 22-test/18-file result belongs to
the first implementation stage, not the final follow-up. No beamline-data
comparison or exhaustive platform/release validation was claimed.

## Layout lessons and failure modes

### Reproducible layout needs a lifecycle contract

Both tools kept their GUIDE entry point and a source layout builder alongside
the saved `.fig`. This avoided a framework migration while making spacing and
control definitions reproducible. Original control tags continued to support
callbacks and the AI adapter.

The kz_plot builder initially saved a hidden figure: launch returned a valid
handle but no visible window. The builder was corrected to save Visible='on'.
Opening the file by its real entry point was an essential check.

The plotBZ_V1 builder initially loaded an entire old MAT-format `.fig`. Loading
its `hgM_070000` objects deserialized obsolete CreateFcn callbacks after the
source callbacks had been removed. Selective loading of `hgS_070000` allowed
reading the required metadata without instantiating those old objects. This is
a GUIDE-specific remedy: inspect another saved format rather than copying that
field name into unrelated systems. Save a clean layout without runtime handles,
selection caches, or initialization markers.

### Geometry bounds do not establish visual cleanliness

The first rebuilt screenshot showed Miller-index edit boxes overlapped by their
radio group. The controls were individually inside their parent, so a parent
bounds test was insufficient. Inspect actual screenshots and text extents,
including display scaling. Coordinate tests are useful for regressions after a
design is verified; they are not a substitute for seeing it.

### Style must communicate actual plotted state

The user requested bold frame titles and different colours for heading levels.
The chosen palette used navy main titles, teal nested titles, blue/green section
accents, and orange/purple scan accents. Labels remained present.

The optional 3D sections already read the two 2D colour selectors, but both
selectors initially defaulted to black. Changing those defaults and synchronizing
checkbox text made the distinction visible in the GUI and plot. Tests inspected
actual line colours, not just selector indices.

One shared simulation colour menu initially allowed both scan modes to inherit
the same colour. Per-mode state now stores outgoing choices and restores incoming
ones. The agent helper switches modes before applying/remembering an explicit
colour, so a callback cannot overwrite the requested value. Default colours also
match across GUI and API. The reusable principle is explicit mode state and
callback ordering, not this particular palette.

### Integer steppers need defined range behavior

Ten original index edits received minus/plus controls without changing edit tags.
The callback parses both bounds before mutation and steps by exactly one. In
this program, crossing a paired bound moves that bound too, retaining an ordered
range. Invalid text leaves both fields intact. Other applications may instead
reject a crossing or clamp it; choose and document the behavior deliberately.

## Scientific structure and state preservation

The five b1/b2/b3/s1/s2 displays were output-only. Their helpers also calculate
the rotated bulk and primitive surface bases; deleting those functions would
have broken geometry. The separate integer index ranges were useful and stayed.

Prior numerical corrections were preserved: primitive projected lattices for
high-index surfaces, valid triangular sections, physical cell validation,
adaptive Voronoi padding, and a finite allocation limit. Existing regressions
protected this behavior during layout work. Adding simulation did not justify
replacing the already verified BZ construction.

The ARPES model used degrees, eV, angstroms, positive binding energy below EF,
and a specified surface-aligned frame. Surface XY was a projection; horizontal
and vertical plots were intersections transformed into the existing BZ section
coordinates. A percent of a reciprocal vector was not interchangeable with
absolute kz. Empty, coplanar, point, and curve cases needed explicit behavior.

### Axes state includes more than limits

Several checks exposed subtle MATLAB semantics:

- Restoring XLim/YLim/ZLim values can silently change their modes to manual.
  Preserve the modes as well as values; allow automatic limits to recompute
  when that was the user's setting.
- Single-output `view(ax)` returns a 4-by-4 transform, not the two-component
  View property. Restoring it as azimuth/elevation caused a cleanup warning.
- `allchild(ax)` includes hidden label/title objects on an apparently empty
  axes. Using visible plot children avoided falsely classifying new axes as
  existing measured-data axes and suppressing initial autoscaling/view setup.
- NextPlot, View, and DataAspectRatio/mode also matter. A successful overlay
  should not unexpectedly change how subsequent data plots behave.

These are examples of why testing only the numerical arrays or final object
count misses application behavior.

### Raising a singleton must not reset configuration

A later review found OpeningFcn ran when raising an existing singleton and
selected primitive centering again. A face-centred configure followed by read
or plot could lose its configuration. Initialization now runs once per live
panel; its runtime marker is excluded from saved layout metadata. A regression
checks configure -> raise/read -> plot -> read for a centred crystal.

Apply this lesson to lifecycle callbacks, initialization effects, and read APIs
in other frameworks: apparently read-only access should not reset user choices.

## AI compatibility and independent evaluation

The operation skill and helper separated two kinds of memory:

- Configure starts from explicit defaults; update retains omitted current values.
- Repeated BZ plot calls intentionally add outlines. Simulation replaces the
  matching mode/view on the selected axes and retains the other scan mode.
- List/read return state and ownership metadata. Figure/axes/mode scoping is
  explicit; tagged clear preserves measured graphics.

Validation rejected unknown fields and contradictory crystal constraints before
touching the live panel. A hidden control fixture reused legacy production
validators where pure parsing was not yet extracted. This was a compatibility
bridge, not a recommendation to make GUI controls the permanent data model.

An independent agent used the operation skill with a hexagonal crystal, checked
analytical zone centres and reciprocal area, exercised both scans and a rotated
slit, and confirmed simulation-only clear preserved BZs and measured lines.
Its first expected graphics count was wrong: matGeom emits per-face objects.
The test was corrected to verify geometric invariants and actual inventory.
This illustrates a distinction between a product defect and a tester assumption.

The normal skill validator was unavailable because PyYAML was absent, and a
temporary download failed DNS resolution. Structural checks and behavioral
evaluation were recorded separately rather than being described as a successful
official validation. Do not repeatedly install dependencies just to hide such a
limitation, or treat structural validation as proof of operational correctness.

## Review, delegation, and evidence

GUI, numerical simulation, and AI facade work were delegated with separate file
ownership. Interfaces had to be agreed early: tags, parameter names, default
values, callback order, and coordinate transformations. The primary agent
integrated contributions, owned saved-layout generation and live-session QA,
and asked owners to freeze files before tests. Reviewers reported contract
issues directly to owners while the primary tracked final acceptance.

An independent reviewer caught the singleton centering defect during the later
colour work. Reviews should follow state and behavior across interfaces, not
just inspect a task's new lines. At the same time, a review finding should not
be used to expand a small request into an unrelated rewrite.

The full test suite initially passed assertions while emitting an onCleanup
warning from View restoration. Warning-free callback tests caught that gap.
Later suites covered actual colours, mode memory, spin boundaries, invalid input
atomicity, and centred configuration persistence. Run tests against stable
versions and distinguish the writer's checks from an independent evaluation.

Do not assume concurrent agent tools share or isolate a MATLAB session. Inspect
the actual environment and coordinate access. File storage was shared; primary
GUI mutation was serialized. The independent pass reported its own session's
initial/final figures and cleaned up only what it created.

## Rendering and artifact verification

On the tested R2024a session, output figures select painters. For saved output,
the program explicitly exports PDF with `ContentType='vector'`. Newer releases
no longer honor the legacy Renderer property, so release-aware configuration
and explicit export are distinct responsibilities.

A representative PDF containing BZ geometry and both scan surfaces had no
`/Subtype /Image` objects. That supported vector output for that example; it
does not prove that figures containing measured image data, other formats, or
all future releases will be entirely vector. A PNG screenshot is intentionally
raster and remains useful for visual inspection.

Authoritative context: [MathWorks saveas version history](https://www.mathworks.com/help/matlab/ref/saveas.html)
and [exportgraphics](https://www.mathworks.com/help/matlab/ref/exportgraphics.html).
Verify the installed release when applying this lesson again.

## Documentation that remains useful after the chat

The program log recorded the plan, changes, scientific contract, actual checks,
screenshots, follow-up requests, tool limitations, and remaining scope boundaries.
The skill session summary recorded operational API/skill changes and independent
evaluation. This division lets a maintainer find implementation evidence without
making an operation skill carry the entire development history.

Narrow ignore exceptions made intended tests, logs, images, and the new skill
reviewable without including every local artifact. Pre-existing README edits
were preserved. Reusable maintenance advice should teach these decisions, while
program-specific operation skills retain their own units, selections, and APIs.
