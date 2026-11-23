classdef PeakFit_app < handle
%PEAKFIT_APP  Peak fitting of MDCs and EDCs from 2-D ARPES cuts.
%   PEAKFIT_APP opens an empty window; choose a cut from the workspace list.
%   PEAKFIT_APP(name) loads the base-workspace variable NAME.
%   PEAKFIT_APP(data) loads a struct (x, y, value) or an OxA_CUT object.
%   PEAKFIT_APP(..., 'Visible', 'off') builds the window hidden (tests).
%   Only 2-D cuts are accepted (VALUE(x, y)); maps must be sliced first.
%   The source variable is read once and never modified.
%
%   Workflow (left column, top to bottom):
%     1 Data       pick a cut, Load.
%     2 Direction  MDC (horizontal: profile along x at fixed y) or EDC
%                  (vertical: profile along y at fixed x); slice position,
%                  integration half-width and the profile window (crop).
%     3 Model      Lorentzian / Gaussian / Pseudo-Voigt peaks on a linear
%                  background (Flat background holds the slope at 0). EDC
%                  only: optional Fermi-Dirac cutoff with held E_F and T
%                  (T from info.temperature when available).
%     4 Peaks      click on the profile to add a peak (Click to add),
%                  drag a peak marker to move it, Auto-find suggestions,
%                  Add (at the largest residual), Delete, Clear. Guide mode:
%                  click along a band on the image to guide the selected
%                  peak during tracking.
%     5 Fit        Fit slice, or Fit range: fits every slice in Track
%                  from/to, walking both ways from the current slice, each
%                  slice starting from its neighbour's accepted fit. Stop
%                  interrupts a run. Centre jumps > Max jump x FWHM are
%                  rejected.
%     6 Export     writes a NEW base-workspace variable (default
%                  <source>_peaks; asks before replacing an existing one).
%
%   Scriptable interface (same backend as the controls):
%     names = app.refreshList()           compatible base-workspace names
%     app.selectData(nameOrData)          load a cut; resets peaks and fits
%     app.setDirection('MDC'|'EDC')       also sets the default shape
%     app.setSlice(value)                 slice position (slice-axis units)
%     app.setIntegration(halfWidth)       half-width, slice-axis units
%     app.setWindow([lo hi])              profile window; [] = full axis
%     app.setModel(shape)                 'Lorentzian'|'Gaussian'|'Pseudo-Voigt'
%     app.setFlatBackground(tf)
%     app.setFermi(tf, 'EF', eV, 'T', K)  EDC Fermi-Dirac cutoff
%     k = app.addPeak(centre, Name, Value) 'FWHM','Height','Eta',
%                                         'FixCentre','FixFWHM','Lower','Upper'
%     app.setPeak(k, Name, Value)         same names as addPeak (+ 'Centre')
%     app.removePeak(k); app.clearPeaks()
%     c = app.autoFindPeaks('Prominence', p, 'MaxPeaks', n)
%     app.addGuidePoint(k, slice, centre); app.clearGuides()
%     R = app.fitCurrentSlice()           see PKF_FIT_PROFILE
%     T = app.fitRange([a b], Name, Value) see PKF_TRACK ('MaxJump',
%                                         'Step', 'StopAfter')
%     app.stop()                          request a running fitRange to stop
%     name = app.exportPeaks(name, 'Overwrite', tf)  see PKF_EXPORT
%     s = app.getState()                  read-only snapshot
%     app.exportFigure(file)              PNG of the whole window
%
%   Hidden test hooks (uiaxes CurrentPoint is read-only, so tests drive
%   pointer events with explicit data coordinates):
%     app.simulateProfileClick([u y])     click on the profile axes
%     app.simulateImageClick([x y])       click on the image (Guide mode)
%     app.simulateDrag(k, [u y])          drag marker k (centre and height)
%     app.simulateTableEdit(row, col, v)  edit one cell of the peak table
%
%   Requires base MATLAB only (R2023a tested; no toolboxes).

    properties (SetAccess = private)
        UIFigure
        Handles = struct()
        DataName = ''
        Data = []
        Direction = 'MDC'
        SliceValue = NaN
        Peaks = PeakFit_app.emptyPeaks()
        Background = [NaN NaN]
        SliceResult = []
        Track = []
        Guides = {}
    end

    properties (Access = private)
        FitState = 'Idle'
        StopRequested = false
        DragPeak = 0
        SelectedPeak = 0
        EFSource = ''
        TemperatureSource = ''
        SliceResultIndex = NaN
    end

    properties (Constant)
        Shapes = {'Lorentzian', 'Gaussian', 'Pseudo-Voigt'}
        StatusStates = {'Idle', 'Fitting…', 'Done', 'Failed'}
        StatusColors = [0.65 0.65 0.65; 1.00 0.70 0.10; 0.20 0.70 0.25; 0.85 0.15 0.15]
        PeakColors = [0.00 0.45 0.74; 0.47 0.67 0.19; 0.49 0.18 0.56; 0.93 0.69 0.13; ...
            0.30 0.75 0.93; 0.64 0.08 0.18; 0.85 0.33 0.10]
        Colors = struct('title', [0.10 0.20 0.45], 'data', [0.15 0.15 0.15], ...
            'model', [0.85 0.10 0.10], 'bg', [0.45 0.45 0.45], 'slice', [0.00 0.60 1.00], ...
            'window', [0.93 0.69 0.13])
        TableColumns = {'Peak', 'Centre', 'FWHM', 'Height', 'eta', 'Fix centre', ...
            'Fix FWHM', '±1σ centre', '±1σ FWHM', 'Centre min', 'Centre max'}
    end

    methods
        function app = PeakFit_app(varargin)
            args = varargin;
            source = [];
            if ~isempty(args) && ~((ischar(args{1}) || isstring(args{1})) && strcmpi(args{1}, 'Visible'))
                source = args{1};
                args(1) = [];
            end
            p = inputParser;
            p.addParameter('Visible', 'on', @(v) any(strcmpi(v, {'on', 'off'})));
            p.parse(args{:});
            app.build(lower(char(p.Results.Visible)));
            app.refreshList();
            if ~isempty(source)
                try
                    app.selectData(source);
                catch err
                    delete(app);
                    rethrow(err);
                end
            end
        end

        function delete(app)
            if ~isempty(app.UIFigure) && isvalid(app.UIFigure)
                delete(app.UIFigure);
            end
        end

        % ---------------- scriptable interface ----------------
        function names = refreshList(app)
            vars = evalin('base', 'whos');
            keep = false(size(vars));
            skip = {'double', 'single', 'char', 'string', 'logical', 'cell', 'function_handle', ...
                'int8', 'int16', 'int32', 'int64', 'uint8', 'uint16', 'uint32', 'uint64', 'table'};
            for k = 1:numel(vars)
                if any(strcmp(vars(k).class, skip)), continue; end
                try
                    pkf_input(vars(k).name);
                    keep(k) = true;
                catch
                    keep(k) = false;
                end
            end
            names = {vars(keep).name};
            h = app.Handles;
            if isempty(names)
                h.List.Items = {'(no 2-D cut in workspace)'};
                h.List.ItemsData = {''};
                h.List.Value = '';
            else
                h.List.Items = names;
                h.List.ItemsData = names;
                if any(strcmp(names, app.DataName)), h.List.Value = app.DataName; else, h.List.Value = names{1}; end
            end
            app.showStatus(sprintf('%d 2-D cut(s) found in the base workspace.', numel(names)));
        end

        function selectData(app, data)
            if ischar(data) || isstring(data)
                D = pkf_input(char(data));
            else
                D = pkf_input(data, '');
            end
            app.Data = D;
            app.DataName = D.name;
            h = app.Handles;
            if ~isempty(D.name) && any(strcmp(h.List.ItemsData, D.name)), h.List.Value = D.name; end
            label = D.name;
            if isempty(label), label = '(input argument)'; end
            h.DataInfo.Text = sprintf('%s | %s | %d x %d', label, D.sourceClass, numel(D.x), numel(D.y));
            h.ExportName.Value = app.defaultExportName();
            [ef, efSource] = pkf_default_ef(D);
            h.EF.Value = ef;
            app.EFSource = efSource;
            if isempty(D.temperature)
                app.TemperatureSource = '';
            else
                h.T.Value = D.temperature;
                app.TemperatureSource = 'info.temperature';
            end
            app.resetForDirection(app.Direction);
            msg = sprintf('Loaded %s (%s).', label, D.sourceClass);
            if ~isempty(app.TemperatureSource)
                msg = sprintf('%s T = %.4g K from info.temperature.', msg, D.temperature);
            end
            app.showStatus(msg);
        end

        function setDirection(app, direction)
            app.requireData();
            app.resetForDirection(pkf_direction(direction));
            app.showStatus(sprintf('%s mode: profile along %s; default shape %s.', app.Direction, ...
                app.profileLabel(), app.Handles.Shape.Value));
        end

        function setSlice(app, value)
            app.requireData();
            s = app.sliceAxis();
            if ~(isnumeric(value) && isscalar(value) && isfinite(value))
                error('PeakFit:InvalidSlice', 'The slice position must be a finite scalar.');
            end
            [~, idx] = min(abs(s - value));
            app.SliceValue = s(idx);
            h = app.Handles;
            h.SliceField.Value = s(idx);
            h.Slider.Value = min(max(s(idx), h.Slider.Limits(1)), h.Slider.Limits(2));
            h.SliceIndex.Text = sprintf('%d / %d', idx, numel(s));
            if ~app.syncFromTrack(idx)
                app.markStale();
                app.updateTable();
            end
            app.redraw();
        end

        function setIntegration(app, halfWidth)
            if ~(isnumeric(halfWidth) && isscalar(halfWidth) && isfinite(halfWidth) && halfWidth >= 0)
                error('PeakFit:InvalidWidth', 'The integration half-width must be a finite value >= 0.');
            end
            app.Handles.HalfWidth.Value = halfWidth;
            app.markStale();
            app.redraw();
        end

        function setWindow(app, w)
            app.requireData();
            u = app.profileAxis();
            if isempty(w)
                w = [min(u) max(u)];
            end
            if ~(isnumeric(w) && numel(w) == 2 && all(isfinite(w)) && w(1) ~= w(2))
                error('PeakFit:InvalidWindow', 'The profile window must be two different finite values.');
            end
            w = sort(double(w(:))).';
            w = [max(w(1), min(u)) min(w(2), max(u))];
            if w(2) <= w(1)
                error('PeakFit:InvalidWindow', 'The profile window does not overlap the %s axis.', app.profileLabel());
            end
            h = app.Handles;
            h.WinMin.Value = w(1); h.WinMax.Value = w(2);
            app.markStale();
            app.redraw();
        end

        function setModel(app, shape)
            shape = pkf_shape(shape);
            app.Handles.Shape.Value = shape;
            app.applyShapeToPeaks();
            app.markStale();
            app.redraw();
        end

        function setFlatBackground(app, tf)
            app.Handles.FlatBg.Value = logical(tf);
            if tf && isfinite(app.Background(2)), app.Background(2) = 0; end
            app.markStale();
            app.redraw();
        end

        function setFermi(app, tf, varargin)
            p = inputParser;
            p.addParameter('EF', [], @(v) isempty(v) || (isnumeric(v) && isscalar(v) && isfinite(v)));
            p.addParameter('T', [], @(v) isempty(v) || (isnumeric(v) && isscalar(v) && isfinite(v) && v > 0));
            p.parse(varargin{:});
            h = app.Handles;
            if tf && ~strcmp(app.Direction, 'EDC')
                error('PeakFit:FermiNeedsEDC', 'The Fermi-Dirac cutoff applies to EDC mode only.');
            end
            if ~isempty(p.Results.EF), h.EF.Value = p.Results.EF; app.EFSource = 'user'; end
            if ~isempty(p.Results.T), h.T.Value = p.Results.T; app.TemperatureSource = 'user'; end
            h.Fermi.Value = logical(tf);
            app.markStale();
            app.redraw();
        end

        function k = addPeak(app, centre, varargin)
            app.requireData();
            if ~(isnumeric(centre) && isscalar(centre) && isfinite(centre))
                error('PeakFit:InvalidParameter', 'The peak centre must be a finite scalar.');
            end
            w = app.window();
            if centre < w(1) || centre > w(2)
                error('PeakFit:OutsideWindow', 'Centre %g lies outside the profile window [%g %g].', centre, w(1), w(2));
            end
            [u, I] = app.currentProfile();
            [g, bg] = pkf_initial_guess(u, I, [[app.Peaks.centre] centre], 'Window', w, ...
                'Background', app.startBackground(), 'Eta', app.defaultEta());
            if any(~isfinite(app.Background)), app.Background = bg; end
            pk = app.newPeak(centre, g(end).fwhm, g(end).height, app.defaultEta());
            app.Peaks(end + 1) = pk;
            k = numel(app.Peaks);
            app.Guides{k} = zeros(0, 2);
            if ~isempty(varargin), app.applyPeakOptions(k, varargin{:}); end
            app.SelectedPeak = k;
            app.Track = [];
            app.markStale();
            app.updateTable();
            app.redraw();
        end

        function setPeak(app, k, varargin)
            app.requirePeak(k);
            app.applyPeakOptions(k, varargin{:});
            app.markStale();
            app.updateTable();
            app.redraw();
        end

        function removePeak(app, k)
            app.requirePeak(k);
            app.Peaks(k) = [];
            if numel(app.Guides) >= k, app.Guides(k) = []; end
            app.SelectedPeak = min(app.SelectedPeak, numel(app.Peaks));
            app.markStale();
            app.Track = [];
            app.updateTable();
            app.redraw();
        end

        function clearPeaks(app)
            app.Peaks = PeakFit_app.emptyPeaks();
            app.Guides = {};
            app.SelectedPeak = 0;
            app.Background = [NaN NaN];
            app.markStale();
            app.Track = [];
            app.updateTable();
            app.redraw();
        end

        function centres = autoFindPeaks(app, varargin)
            app.requireData();
            p = inputParser;
            p.addParameter('Prominence', app.Handles.Prominence.Value, @(v) isnumeric(v) && isscalar(v) && v >= 0 && v <= 1);
            p.addParameter('MaxPeaks', 6, @(v) isnumeric(v) && isscalar(v) && v >= 1);
            p.parse(varargin{:});
            [u, I] = app.currentProfile();
            w = app.window();
            centres = pkf_find_peaks(u, I, 'Window', w, 'Prominence', p.Results.Prominence, ...
                'MaxPeaks', p.Results.MaxPeaks);
            app.Handles.Prominence.Value = p.Results.Prominence;
            app.Peaks = PeakFit_app.emptyPeaks();
            app.Guides = {};
            app.Track = [];
            if isempty(centres)
                app.markStale(); app.updateTable(); app.redraw();
                app.showStatus('Auto-find: no peak above the prominence threshold; lower it or click to add.');
                return
            end
            [g, bg] = pkf_initial_guess(u, I, centres, 'Window', w, 'Eta', app.defaultEta());
            app.Background = bg;
            if app.Handles.FlatBg.Value, app.Background(2) = 0; end
            for k = 1:numel(centres)
                app.Peaks(k) = app.newPeak(centres(k), g(k).fwhm, g(k).height, app.defaultEta());
                app.Guides{k} = zeros(0, 2);
            end
            app.SelectedPeak = 1;
            app.markStale();
            app.updateTable();
            app.redraw();
            app.showStatus(sprintf('Auto-find: %d peak(s) suggested at %s.', numel(centres), mat2str(centres, 4)));
        end

        function addGuidePoint(app, k, slice, centre)
            app.requirePeak(k);
            if ~(isscalar(slice) && isscalar(centre) && isfinite(slice) && isfinite(centre))
                error('PeakFit:InvalidGuide', 'Guide points need finite slice and centre values.');
            end
            if numel(app.Guides) < k, app.Guides{k} = zeros(0, 2); end
            app.Guides{k}(end + 1, :) = [slice centre];
            app.drawImageOverlays();
            app.showStatus(sprintf('Peak %d guide: %d point(s).', k, size(app.Guides{k}, 1)));
        end

        function clearGuides(app)
            app.Guides = repmat({zeros(0, 2)}, 1, numel(app.Peaks));
            app.drawImageOverlays();
        end

        function R = fitCurrentSlice(app)
            app.requirePeaks();
            app.setFitState('Fitting…');
            cleanup = onCleanup(@() app.endBusy());
            try
                [u, I, info] = app.currentProfile();
                R = pkf_fit_profile(u, I, app.Peaks, app.fitArgs{:}, 'Background', app.startBackground());
            catch err
                app.setFitState('Failed');
                rethrow(err);
            end
            app.SliceResult = R;
            app.SliceResultIndex = info.index;
            if R.ok
                app.adoptResult(R.peaks, R.background);
                app.setFitState('Done');
                msg = sprintf('Slice %s = %.5g: χ²_red = %.4g, R² = %.4f.', app.sliceName(), ...
                    info.sliceValue, R.chi2_red, R.r2);
                if ~isempty(R.warnings), msg = [msg ' ' strjoin(R.warnings, ' ')]; end
                app.showStatus(msg);
            else
                app.setFitState('Failed');
                app.showStatus(R.message);
            end
            app.updateTable();
            app.redraw();
        end

        function T = fitRange(app, range, varargin)
            app.requirePeaks();
            h = app.Handles;
            if nargin < 2 || isempty(range), range = [h.TrackFrom.Value h.TrackTo.Value]; end
            p = inputParser;
            p.addParameter('MaxJump', h.MaxJump.Value);
            p.addParameter('Step', 1);
            p.addParameter('StopAfter', 5);
            p.parse(varargin{:});
            h.TrackFrom.Value = min(range); h.TrackTo.Value = max(range);
            app.StopRequested = false;
            app.setFitState('Fitting…');
            h.Stop.Enable = 'on';
            cleanup = onCleanup(@() app.endBusy());
            try
                T = pkf_track(app.Data, app.Peaks, 'Direction', app.Direction, 'Start', app.SliceValue, ...
                    'Range', range, 'HalfWidth', h.HalfWidth.Value, app.fitArgs{:}, ...
                    'Background', app.startBackground(), 'MaxJump', p.Results.MaxJump, ...
                    'Step', p.Results.Step, 'StopAfter', p.Results.StopAfter, 'Guides', app.paddedGuides(), ...
                    'Progress', @(d, n) app.onProgress(d, n), 'StopFcn', @() app.StopRequested);
            catch err
                app.setFitState('Failed');
                rethrow(err);
            end
            app.Track = T;
            app.SliceResult = [];
            app.syncFromTrack(T.start_index);
            nOk = nnz(all(T.valid, 2));
            if T.stopped
                app.setFitState('Done');
                app.showStatus(sprintf('Stopped: %d of %d slices accepted so far.', nOk, numel(T.slice_values)));
            elseif nOk == 0
                app.setFitState('Failed');
                app.showStatus('No slice was accepted; check the seeds, window and Max jump.');
            else
                app.setFitState('Done');
                app.showStatus(sprintf('Fitted range: %d of %d slices accepted (%d rejected, %d not reached).', ...
                    nOk, numel(T.slice_values), nnz(T.attempted & ~all(T.valid, 2)), nnz(~T.attempted)));
            end
            app.updateTable();
            app.redraw();
        end

        function stop(app)
            app.StopRequested = true;
            app.showStatus('Stopping after the current slice…');
        end

        function name = exportPeaks(app, name, varargin)
            app.requireData();
            p = inputParser;
            p.addParameter('Overwrite', false, @(v) islogical(v) || isnumeric(v));
            p.parse(varargin{:});
            if nargin < 2 || isempty(name), name = app.defaultExportName(); end
            name = char(name);
            if ~isvarname(name)
                error('PeakFit:InvalidName', '"%s" is not a valid MATLAB variable name.', name);
            end
            if strcmp(name, app.DataName)
                error('PeakFit:WouldOverwriteSource', 'The export name equals the source variable; choose another name.');
            end
            if ~isempty(app.Track)
                S = pkf_export(app.Track, app.Data);
            elseif ~isempty(app.SliceResult) && app.SliceResult.ok
                S = pkf_export(app.SliceResult, app.Data, 'SliceValue', app.SliceValue, ...
                    'Direction', app.Direction, 'HalfWidth', app.Handles.HalfWidth.Value);
            else
                error('PeakFit:NoFit', 'Fit a slice or a range before exporting.');
            end
            exists = evalin('base', sprintf('exist(''%s'', ''var'')', name));
            if exists && ~p.Results.Overwrite
                if strcmp(app.UIFigure.Visible, 'on') && app.isInteractiveCall()
                    sel = uiconfirm(app.UIFigure, sprintf('Overwrite base-workspace variable %s?', name), ...
                        'Overwrite?', 'Options', {'Overwrite', 'Cancel'}, 'DefaultOption', 2);
                    if ~strcmp(sel, 'Overwrite')
                        error('PeakFit:Cancelled', 'Cancelled: %s was not overwritten.', name);
                    end
                else
                    error('PeakFit:VariableExists', 'Variable %s exists; pass ''Overwrite'', true to replace it.', name);
                end
            end
            assignin('base', name, S);
            app.Handles.ExportName.Value = name;
            app.showStatus(sprintf('Exported %d peak(s) over %d slice(s) to %s.', numel(S.peaks), ...
                numel(S.slice_values), name));
        end

        function s = getState(app)
            h = app.Handles;
            s.dataName = app.DataName;
            s.hasData = ~isempty(app.Data);
            s.direction = app.Direction;
            s.sliceValue = app.SliceValue;
            s.sliceIndex = NaN;
            s.window = [NaN NaN];
            if s.hasData
                [~, s.sliceIndex] = min(abs(app.sliceAxis() - app.SliceValue));
                s.window = app.window();
            end
            s.halfWidth = h.HalfWidth.Value;
            s.shape = h.Shape.Value;
            s.flatBackground = h.FlatBg.Value;
            s.fermi = struct('enabled', h.Fermi.Value, 'EF', h.EF.Value, 'T', h.T.Value, ...
                'efSource', app.EFSource, 'temperatureSource', app.TemperatureSource);
            s.peaks = cell2table(app.tableData(), 'VariableNames', ...
                {'Peak', 'Centre', 'FWHM', 'Height', 'eta', 'FixCentre', 'FixFWHM', ...
                'ErrCentre', 'ErrFWHM', 'CentreMin', 'CentreMax'});
            s.background = app.Background;
            s.guides = app.Guides;
            s.clickToAdd = h.ClickAdd.Value;
            s.guideMode = h.GuideMode.Value;
            s.trackRange = [h.TrackFrom.Value h.TrackTo.Value];
            s.maxJump = h.MaxJump.Value;
            s.fitStatus = app.FitState;
            s.sliceResult = app.SliceResult;
            s.track = app.Track;
            s.exportName = h.ExportName.Value;
        end

        function exportFigure(app, file)
            drawnow;
            exportapp(app.UIFigure, file);
        end

        function showStatus(app, msg)
            app.Handles.Status.Text = msg;
        end
    end

    methods (Hidden)
        % Pointer events with explicit data coordinates. The GUI callbacks
        % call the same handlers with the axes CurrentPoint; these entry
        % points let tests and agents reproduce clicks and drags exactly.
        function simulateProfileClick(app, pt)
            app.guard(@() app.onProfileClick(pt));
        end

        function simulateImageClick(app, pt)
            app.guard(@() app.onImageClick(pt));
        end

        function simulateDrag(app, k, pt)
            app.requirePeak(k);
            app.startDrag(k);
            app.onMotion(pt);
            app.onRelease();
        end

        function simulateTableEdit(app, row, col, value)
            evt = struct('Indices', [row col], 'NewData', value);
            app.guard(@() app.onTableEdit(evt));
        end
    end

    methods (Static, Hidden)
        function P = emptyPeaks()
            P = struct('centre', {}, 'fwhm', {}, 'height', {}, 'eta', {}, 'fixCentre', {}, ...
                'fixFWHM', {}, 'lo', {}, 'hi', {}, 'err_centre', {}, 'err_fwhm', {});
        end

        function pk = newPeak(centre, fwhm, height, eta)
            pk = struct('centre', centre, 'fwhm', fwhm, 'height', height, 'eta', eta, ...
                'fixCentre', false, 'fixFWHM', false, 'lo', -Inf, 'hi', Inf, ...
                'err_centre', NaN, 'err_fwhm', NaN);
        end
    end

    methods (Access = private)
        % ---------------- layout ----------------
        function build(app, vis)
            C = app.Colors;
            f = uifigure('Visible', 'off', 'Name', 'Peak fitting (MDC / EDC)', ...
                'Position', [60 60 1100 660], 'Tag', 'PeakFit_app');
            app.UIFigure = f;
            f.CloseRequestFcn = @(~, ~) delete(app);
            g = uigridlayout(f, [3 3], 'ColumnWidth', {262, '1x', 380}, 'RowHeight', {'1x', 138, 22}, ...
                'Padding', [6 4 6 4], 'ColumnSpacing', 6, 'RowSpacing', 4);

            % ---- left: workflow ----
            pl = uipanel(g, 'BorderType', 'none');
            pl.Layout.Row = [1 2]; pl.Layout.Column = 1;
            rh = {16, 22, 22, 18, 16, 22, 22, 22, 22, 22, 16, 22, 22, 22, 22, 16, 22, 22, 22, 16, 22, 22, 22, 16, 22};
            gl = uigridlayout(pl, [numel(rh) 4], 'RowHeight', rh, 'ColumnWidth', {58, '1x', '1x', 54}, ...
                'Padding', [4 2 4 2], 'RowSpacing', 3, 'ColumnSpacing', 4, 'Scrollable', 'on');
            app.header(gl, 1, '1  Data');
            h.List = uidropdown(gl, 'Items', {'(none)'}, 'ItemsData', {''}, 'Tag', 'DataList');
            h.List.Layout.Row = 2; h.List.Layout.Column = [1 3];
            h.Refresh = app.button(gl, 2, 4, '↻', 'Refresh', @() app.refreshList());
            h.Refresh.Tooltip = 'Refresh the workspace list';
            h.Load = app.button(gl, 3, [1 4], 'Load selected cut', 'Load', ...
                @() app.selectData(app.Handles.List.Value));
            h.Load.FontWeight = 'bold';
            h.DataInfo = uilabel(gl, 'Text', 'No data loaded', 'FontColor', [0.35 0.35 0.35], 'FontSize', 11);
            h.DataInfo.Layout.Row = 4; h.DataInfo.Layout.Column = [1 4];

            app.header(gl, 5, '2  Direction and slice');
            app.label(gl, 6, 1, 'Direction');
            h.Direction = uidropdown(gl, 'Items', {'MDC (Horizontal)', 'EDC (Vertical)'}, ...
                'ItemsData', {'MDC', 'EDC'}, 'Value', 'MDC', 'Tag', 'Direction', ...
                'ValueChangedFcn', @(src, ~) app.guard(@() app.setDirection(src.Value)));
            h.Direction.Layout.Row = 6; h.Direction.Layout.Column = [2 4];
            h.SliceLabel = app.label(gl, 7, 1, 'Slice');
            h.SliceField = uieditfield(gl, 'numeric', 'Tag', 'SliceValue', 'ValueDisplayFormat', '%.5g', ...
                'ValueChangedFcn', @(src, ~) app.guard(@() app.setSlice(src.Value)));
            h.SliceField.Layout.Row = 7; h.SliceField.Layout.Column = [2 3];
            h.SliceIndex = uilabel(gl, 'Text', '- / -', 'HorizontalAlignment', 'right', 'FontSize', 11);
            h.SliceIndex.Layout.Row = 7; h.SliceIndex.Layout.Column = 4;
            h.Slider = uislider(gl, 'MajorTicks', [], 'MinorTicks', [], 'Tag', 'SliceSlider', ...
                'ValueChangingFcn', @(~, evt) app.guard(@() app.setSlice(evt.Value)), ...
                'ValueChangedFcn', @(src, ~) app.guard(@() app.setSlice(src.Value)));
            h.Slider.Layout.Row = 8; h.Slider.Layout.Column = [1 4];
            lab = app.label(gl, 9, [1 2], 'Integrate ± (slice axis)');
            lab.Tooltip = 'Half-width of the averaging band around the slice, in slice-axis units';
            h.HalfWidth = uieditfield(gl, 'numeric', 'Limits', [0 Inf], 'Value', 0, 'Tag', 'HalfWidth', ...
                'ValueDisplayFormat', '%.4g', 'ValueChangedFcn', @(src, ~) app.guard(@() app.setIntegration(src.Value)));
            h.HalfWidth.Layout.Row = 9; h.HalfWidth.Layout.Column = [3 4];
            app.label(gl, 10, 1, 'Window');
            h.WinMin = uieditfield(gl, 'numeric', 'Tag', 'WindowMin', 'ValueDisplayFormat', '%.4g', ...
                'ValueChangedFcn', @(~, ~) app.guard(@() app.setWindow([app.Handles.WinMin.Value app.Handles.WinMax.Value])));
            h.WinMin.Layout.Row = 10; h.WinMin.Layout.Column = 2;
            h.WinMax = uieditfield(gl, 'numeric', 'Tag', 'WindowMax', 'ValueDisplayFormat', '%.4g', ...
                'ValueChangedFcn', @(~, ~) app.guard(@() app.setWindow([app.Handles.WinMin.Value app.Handles.WinMax.Value])));
            h.WinMax.Layout.Row = 10; h.WinMax.Layout.Column = 3;
            h.WinFull = app.button(gl, 10, 4, 'Full', 'WindowFull', @() app.setWindow([]));

            app.header(gl, 11, '3  Model');
            app.label(gl, 12, 1, 'Shape');
            h.Shape = uidropdown(gl, 'Items', app.Shapes, 'Value', 'Lorentzian', 'Tag', 'Shape', ...
                'ValueChangedFcn', @(src, ~) app.guard(@() app.setModel(src.Value)));
            h.Shape.Layout.Row = 12; h.Shape.Layout.Column = [2 4];
            h.FlatBg = uicheckbox(gl, 'Text', 'Flat background (slope = 0)', 'Tag', 'FlatBackground', ...
                'ValueChangedFcn', @(src, ~) app.guard(@() app.setFlatBackground(src.Value)));
            h.FlatBg.Layout.Row = 13; h.FlatBg.Layout.Column = [1 4];
            h.Fermi = uicheckbox(gl, 'Text', 'Fermi-Dirac cutoff (EDC)', 'Tag', 'FermiCutoff', 'Enable', 'off', ...
                'ValueChangedFcn', @(src, ~) app.guard(@() app.setFermi(src.Value)));
            h.Fermi.Layout.Row = 14; h.Fermi.Layout.Column = [1 4];
            app.label(gl, 15, 1, 'E_F (eV)');
            h.EF = uieditfield(gl, 'numeric', 'Value', 0, 'Tag', 'EF', 'ValueDisplayFormat', '%.5g', ...
                'ValueChangedFcn', @(src, ~) app.guard(@() app.setFermi(app.Handles.Fermi.Value, 'EF', src.Value)));
            h.EF.Layout.Row = 15; h.EF.Layout.Column = 2;
            lab = app.label(gl, 15, 3, 'T (K)'); lab.HorizontalAlignment = 'right';
            h.T = uieditfield(gl, 'numeric', 'Value', 20, 'Limits', [0 Inf], 'LowerLimitInclusive', 'off', ...
                'Tag', 'Temperature', 'ValueDisplayFormat', '%.4g', ...
                'ValueChangedFcn', @(src, ~) app.guard(@() app.setFermi(app.Handles.Fermi.Value, 'T', src.Value)));
            h.T.Layout.Row = 15; h.T.Layout.Column = 4;

            app.header(gl, 16, '4  Peaks');
            h.ClickAdd = uibutton(gl, 'state', 'Text', 'Click to add', 'Tag', 'ClickToAdd', 'Value', true, ...
                'Tooltip', 'Click on the profile plot to add a peak there', ...
                'ValueChangedFcn', @(~, ~) app.onModeChanged('click'));
            h.ClickAdd.Layout.Row = 17; h.ClickAdd.Layout.Column = [1 2];
            h.GuideMode = uibutton(gl, 'state', 'Text', 'Guide on image', 'Tag', 'GuideMode', ...
                'Tooltip', 'Click along a band on the image to guide the selected peak while tracking', ...
                'ValueChangedFcn', @(~, ~) app.onModeChanged('guide'));
            h.GuideMode.Layout.Row = 17; h.GuideMode.Layout.Column = [3 4];
            h.AutoFind = app.button(gl, 18, [1 2], 'Auto-find', 'AutoFind', @() app.autoFindPeaks());
            lab = app.label(gl, 18, 3, 'Prominence'); lab.HorizontalAlignment = 'right';
            h.Prominence = uieditfield(gl, 'numeric', 'Limits', [0 1], 'Value', 0.1, 'Tag', 'Prominence', ...
                'ValueDisplayFormat', '%.2g', 'Tooltip', 'Fraction of the profile range');
            h.Prominence.Layout.Row = 18; h.Prominence.Layout.Column = 4;
            h.AddPeak = app.button(gl, 19, 1, 'Add', 'AddPeak', @() app.addAtResidual());
            h.AddPeak.Tooltip = 'Add a peak at the largest positive residual';
            h.DeletePeak = app.button(gl, 19, 2, 'Delete', 'DeletePeak', @() app.deleteSelected());
            h.ClearPeaks = app.button(gl, 19, 3, 'Clear', 'ClearPeaks', @() app.clearPeaks());
            h.ClearGuides = app.button(gl, 19, 4, 'Guides ✕', 'ClearGuides', @() app.clearGuides());

            app.header(gl, 20, '5  Fit');
            h.FitSlice = app.button(gl, 21, [1 2], 'Fit slice', 'FitSlice', @() app.fitCurrentSlice());
            h.FitSlice.FontWeight = 'bold'; h.FitSlice.BackgroundColor = [0.86 0.92 1.0];
            h.FitRange = app.button(gl, 21, [3 4], 'Fit range', 'FitRange', @() app.fitRange());
            h.FitRange.FontWeight = 'bold'; h.FitRange.BackgroundColor = [0.86 0.92 1.0];
            app.label(gl, 22, 1, 'Track');
            h.TrackFrom = uieditfield(gl, 'numeric', 'Tag', 'TrackFrom', 'ValueDisplayFormat', '%.4g');
            h.TrackFrom.Layout.Row = 22; h.TrackFrom.Layout.Column = 2;
            h.TrackTo = uieditfield(gl, 'numeric', 'Tag', 'TrackTo', 'ValueDisplayFormat', '%.4g');
            h.TrackTo.Layout.Row = 22; h.TrackTo.Layout.Column = 3;
            h.TrackFull = app.button(gl, 22, 4, 'Full', 'TrackFull', @() app.resetTrackRange());
            lab = app.label(gl, 23, 1, 'Max jump');
            lab.Tooltip = 'In units of the peak FWHM';
            h.MaxJump = uieditfield(gl, 'numeric', 'Value', 1.5, 'Limits', [0 Inf], 'LowerLimitInclusive', 'off', ...
                'Tag', 'MaxJump', 'ValueDisplayFormat', '%.3g', ...
                'Tooltip', 'Reject a slice when a centre moves more than this many FWHM');
            h.MaxJump.Layout.Row = 23; h.MaxJump.Layout.Column = 2;
            h.Stop = uibutton(gl, 'Text', 'Stop', 'Tag', 'Stop', 'Enable', 'off', ...
                'ButtonPushedFcn', @(~, ~) app.stop());
            h.Stop.Layout.Row = 23; h.Stop.Layout.Column = [3 4];

            app.header(gl, 24, '6  Export');
            h.ExportName = uieditfield(gl, 'text', 'Value', 'peakfit_peaks', 'Tag', 'ExportName');
            h.ExportName.Layout.Row = 25; h.ExportName.Layout.Column = [1 3];
            h.Export = app.button(gl, 25, 4, 'Export', 'Export', @() app.exportPeaks(app.Handles.ExportName.Value));

            % ---- centre: image ----
            h.Image = uiaxes(g, 'Tag', 'ImageAxes');
            h.Image.Layout.Row = 1; h.Image.Layout.Column = 2;
            title(h.Image, 'Cut', 'FontWeight', 'normal'); box(h.Image, 'on');
            disableDefaultInteractivity(h.Image);

            % ---- right: profile + residual ----
            gr = uigridlayout(g, [2 1], 'RowHeight', {'3x', '1x'}, 'Padding', [0 0 0 0], 'RowSpacing', 2);
            gr.Layout.Row = 1; gr.Layout.Column = 3;
            h.Profile = uiaxes(gr, 'Tag', 'ProfileAxes');
            box(h.Profile, 'on'); grid(h.Profile, 'on');
            disableDefaultInteractivity(h.Profile);
            h.Profile.ButtonDownFcn = @(src, ~) app.guard(@() app.onProfileClick(src.CurrentPoint(1, 1:2)));
            h.Residual = uiaxes(gr, 'Tag', 'ResidualAxes');
            box(h.Residual, 'on'); grid(h.Residual, 'on');
            ylabel(h.Residual, 'Residual'); disableDefaultInteractivity(h.Residual);

            % ---- bottom: peak table ----
            h.Table = uitable(g, 'ColumnName', app.TableColumns, 'RowName', {}, 'Tag', 'PeakTable', ...
                'ColumnEditable', [false true true true true true true false false true true], ...
                'ColumnWidth', {40, 'auto', 'auto', 'auto', 52, 76, 70, 'auto', 'auto', 'auto', 'auto'}, ...
                'CellEditCallback', @(~, evt) app.guard(@() app.onTableEdit(evt)), ...
                'CellSelectionCallback', @(~, evt) app.onTableSelect(evt));
            h.Table.Layout.Row = 2; h.Table.Layout.Column = [2 3];

            % ---- status bar ----
            gs = uigridlayout(g, [1 3], 'ColumnWidth', {16, 70, '1x'}, 'Padding', [2 0 2 0], 'ColumnSpacing', 6);
            gs.Layout.Row = 3; gs.Layout.Column = [1 3];
            h.StatusLamp = uilamp(gs, 'Color', app.StatusColors(1, :), 'Tag', 'StatusLamp');
            h.StatusState = uilabel(gs, 'Text', 'Idle', 'FontWeight', 'bold', 'Tag', 'StatusState');
            h.Status = uilabel(gs, 'Text', 'Ready.', 'Tag', 'StatusText');
            app.Handles = h;
            f.WindowButtonMotionFcn = @(~, ~) app.onMotion(app.Handles.Profile.CurrentPoint(1, 1:2));
            f.WindowButtonUpFcn = @(~, ~) app.onRelease();
            app.updateTable();
            f.Visible = vis;
            app.styleTitles(C);
        end

        function styleTitles(app, C)
            for ax = [app.Handles.Image app.Handles.Profile app.Handles.Residual]
                ax.Title.Color = C.title;
            end
        end

        function header(~, parent, row, text)
            l = uilabel(parent, 'Text', text, 'FontWeight', 'bold', 'FontColor', PeakFit_app.Colors.title);
            l.Layout.Row = row; l.Layout.Column = [1 4];
        end

        function l = label(~, parent, row, col, text)
            l = uilabel(parent, 'Text', text);
            l.Layout.Row = row; l.Layout.Column = col;
        end

        function b = button(app, parent, row, col, text, tag, fcn)
            b = uibutton(parent, 'Text', text, 'Tag', tag, 'ButtonPushedFcn', @(~, ~) app.guard(fcn));
            b.Layout.Row = row; b.Layout.Column = col;
        end

        % ---------------- state helpers ----------------
        function resetForDirection(app, direction)
            app.Direction = direction;
            h = app.Handles;
            h.Direction.Value = direction;
            isEDC = strcmp(direction, 'EDC');
            if isEDC, h.Shape.Value = 'Pseudo-Voigt'; else, h.Shape.Value = 'Lorentzian'; end
            h.Fermi.Enable = isEDC;
            if ~isEDC, h.Fermi.Value = false; end
            app.Peaks = PeakFit_app.emptyPeaks();
            app.Guides = {};
            app.Background = [NaN NaN];
            app.SliceResult = []; app.Track = [];
            app.SelectedPeak = 0;
            if isempty(app.Data), return; end
            s = app.sliceAxis(); u = app.profileAxis();
            lims = [min(s) max(s)];
            h.Slider.Limits = lims;
            h.SliceLabel.Text = ifelse(isEDC, 'Slice x', 'Slice y');
            h.WinMin.Value = min(u); h.WinMax.Value = max(u);
            h.TrackFrom.Value = lims(1); h.TrackTo.Value = lims(2);
            app.updateTable();
            app.drawImage();
            app.setSlice(mean(lims));
        end

        function resetTrackRange(app)
            app.requireData();
            s = app.sliceAxis();
            app.Handles.TrackFrom.Value = min(s); app.Handles.TrackTo.Value = max(s);
        end

        function s = sliceAxis(app)
            if strcmp(app.Direction, 'MDC'), s = app.Data.y(:); else, s = app.Data.x(:); end
        end

        function u = profileAxis(app)
            if strcmp(app.Direction, 'MDC'), u = app.Data.x(:); else, u = app.Data.y(:); end
        end

        function t = profileLabel(app)
            if strcmp(app.Direction, 'MDC'), t = app.Data.xLabel; else, t = app.Data.yLabel; end
        end

        function t = sliceName(app)
            if strcmp(app.Direction, 'MDC'), t = app.Data.yLabel; else, t = app.Data.xLabel; end
        end

        function w = window(app)
            w = [app.Handles.WinMin.Value app.Handles.WinMax.Value];
        end

        function [u, I, info] = currentProfile(app)
            app.requireData();
            [u, I, info] = pkf_extract_profile(app.Data, app.Direction, app.SliceValue, app.Handles.HalfWidth.Value);
        end

        function args = fitArgs(app)
            h = app.Handles;
            F = struct('enabled', logical(h.Fermi.Value) && strcmp(app.Direction, 'EDC'), ...
                'EF', h.EF.Value, 'T', h.T.Value);
            args = {'Shape', h.Shape.Value, 'FlatBackground', logical(h.FlatBg.Value), ...
                'Window', app.window(), 'Fermi', F};
        end

        function bg = startBackground(app)
            bg = app.Background;
            if any(~isfinite(bg)), bg = []; return; end
            if app.Handles.FlatBg.Value, bg(2) = 0; end
        end

        function eta = defaultEta(app)
            switch app.Handles.Shape.Value
                case 'Lorentzian', eta = 1;
                case 'Gaussian', eta = 0;
                otherwise, eta = 0.5;
            end
        end

        function applyShapeToPeaks(app)
            shape = app.Handles.Shape.Value;
            for k = 1:numel(app.Peaks)
                if strcmp(shape, 'Lorentzian'), app.Peaks(k).eta = 1;
                elseif strcmp(shape, 'Gaussian'), app.Peaks(k).eta = 0;
                elseif ~(app.Peaks(k).eta > 0 && app.Peaks(k).eta < 1), app.Peaks(k).eta = 0.5;
                end
            end
            app.updateTable();
        end

        function applyPeakOptions(app, k, varargin)
            p = inputParser;
            num = @(v) isnumeric(v) && isscalar(v) && ~isnan(v);
            p.addParameter('Centre', app.Peaks(k).centre, num);
            p.addParameter('FWHM', app.Peaks(k).fwhm, @(v) num(v) && v > 0 && isfinite(v));
            p.addParameter('Height', app.Peaks(k).height, @(v) num(v) && v >= 0 && isfinite(v));
            p.addParameter('Eta', app.Peaks(k).eta, @(v) num(v) && v >= 0 && v <= 1);
            p.addParameter('FixCentre', app.Peaks(k).fixCentre, @(v) islogical(v) || isnumeric(v));
            p.addParameter('FixFWHM', app.Peaks(k).fixFWHM, @(v) islogical(v) || isnumeric(v));
            p.addParameter('Lower', app.Peaks(k).lo, num);
            p.addParameter('Upper', app.Peaks(k).hi, num);
            p.parse(varargin{:});
            r = p.Results;
            if r.Lower >= r.Upper
                error('PeakFit:InvalidBounds', 'Peak %d: Centre min must be below Centre max.', k);
            end
            if ~isfinite(r.Centre)
                error('PeakFit:InvalidParameter', 'Peak %d: the centre must be finite.', k);
            end
            if ~strcmp(app.Handles.Shape.Value, 'Pseudo-Voigt') && r.Eta ~= app.Peaks(k).eta
                error('PeakFit:EtaFixedByShape', 'eta is fixed by the %s shape; choose Pseudo-Voigt to edit it.', ...
                    app.Handles.Shape.Value);
            end
            pk = app.Peaks(k);
            pk.centre = r.Centre; pk.fwhm = r.FWHM; pk.height = r.Height; pk.eta = r.Eta;
            pk.fixCentre = logical(r.FixCentre); pk.fixFWHM = logical(r.FixFWHM);
            pk.lo = r.Lower; pk.hi = r.Upper;
            app.Peaks(k) = pk;
        end

        function adoptResult(app, P, bg)
            for k = 1:numel(app.Peaks)
                app.Peaks(k).centre = P(k).centre; app.Peaks(k).fwhm = P(k).fwhm;
                app.Peaks(k).height = P(k).height; app.Peaks(k).eta = P(k).eta;
                app.Peaks(k).err_centre = P(k).err_centre; app.Peaks(k).err_fwhm = P(k).err_fwhm;
            end
            app.Background = bg;
        end

        function tf = syncFromTrack(app, idx)
            % Show the tracked parameters of slice IDX in the table, if any.
            tf = false;
            T = app.Track;
            if isempty(T) || numel(app.Peaks) ~= size(T.centre, 2), return; end
            row = find(T.slice_index == idx, 1);
            if isempty(row) || ~all(T.valid(row, :)), return; end
            tf = true;
            for k = 1:numel(app.Peaks)
                app.Peaks(k).centre = T.centre(row, k); app.Peaks(k).fwhm = T.fwhm(row, k);
                app.Peaks(k).height = T.height(row, k); app.Peaks(k).eta = T.eta(row, k);
                app.Peaks(k).err_centre = T.err_centre(row, k); app.Peaks(k).err_fwhm = T.err_fwhm(row, k);
            end
            app.Background = [T.c0(row) T.c1(row)];
            app.updateTable();
        end

        function markStale(app)
            app.SliceResult = [];
            for k = 1:numel(app.Peaks)
                app.Peaks(k).err_centre = NaN; app.Peaks(k).err_fwhm = NaN;
            end
        end

        function G = paddedGuides(app)
            G = app.Guides;
            if numel(G) < numel(app.Peaks), G(end + 1:numel(app.Peaks)) = {zeros(0, 2)}; end
        end

        function name = defaultExportName(app)
            if isempty(app.DataName), name = 'peakfit_peaks'; else, name = [app.DataName '_peaks']; end
            if ~isvarname(name), name = matlab.lang.makeValidName(name); end
        end

        % ---------------- table ----------------
        function d = tableData(app)
            n = numel(app.Peaks);
            d = cell(n, 11);
            for k = 1:n
                pk = app.Peaks(k);
                d(k, :) = {sprintf('%d', k), pk.centre, pk.fwhm, pk.height, pk.eta, pk.fixCentre, pk.fixFWHM, ...
                    pk.err_centre, pk.err_fwhm, pk.lo, pk.hi};
            end
        end

        function updateTable(app)
            app.Handles.Table.Data = app.tableData();
        end

        function onTableEdit(app, evt)
            k = evt.Indices(1); c = evt.Indices(2);
            names = {'', 'Centre', 'FWHM', 'Height', 'Eta', 'FixCentre', 'FixFWHM', '', '', 'Lower', 'Upper'};
            try
                app.applyPeakOptions(k, names{c}, evt.NewData);
            catch err
                app.updateTable();
                rethrow(err);
            end
            app.SelectedPeak = k;
            app.markStale();
            app.updateTable();
            app.redraw();
        end

        function onTableSelect(app, evt)
            if ~isempty(evt.Indices), app.SelectedPeak = evt.Indices(1, 1); end
        end

        % ---------------- interaction ----------------
        function onModeChanged(app, which)
            h = app.Handles;
            if strcmp(which, 'click') && h.ClickAdd.Value, h.GuideMode.Value = false; end
            if strcmp(which, 'guide') && h.GuideMode.Value
                h.ClickAdd.Value = false;
                app.showStatus('Guide mode: select a peak in the table, then click along its band on the image.');
            end
        end

        function onProfileClick(app, pt)
            if isempty(app.Data) || ~app.Handles.ClickAdd.Value, return; end
            app.addPeak(pt(1));
            app.showStatus(sprintf('Added peak %d at %.5g; drag its marker or edit the table.', ...
                numel(app.Peaks), pt(1)));
        end

        function onImageClick(app, pt)
            if isempty(app.Data), return; end
            if strcmp(app.Direction, 'MDC')
                sv = pt(2); cv = pt(1);
            else
                sv = pt(1); cv = pt(2);
            end
            if app.Handles.GuideMode.Value
                k = app.SelectedPeak;
                if k < 1 || k > numel(app.Peaks)
                    error('PeakFit:NoPeakSelected', 'Select a peak in the table before adding guide points.');
                end
                app.addGuidePoint(k, sv, cv);
            else
                app.setSlice(sv);
            end
        end

        function startDrag(app, k)
            app.DragPeak = k;
            app.SelectedPeak = k;
        end

        function onMotion(app, pt)
            k = app.DragPeak;
            if k < 1 || k > numel(app.Peaks), return; end
            w = app.window();
            c = min(max(pt(1), w(1)), w(2));
            bg = app.Background;
            if any(~isfinite(bg)), bg = [0 0]; end
            base = bg(1) + bg(2) * (c - mean(w));
            app.Peaks(k).centre = c;
            app.Peaks(k).height = max(pt(2) - base, 0);
            app.markStale();
            app.updateTable();
            app.drawProfile();
        end

        function onRelease(app)
            if app.DragPeak > 0
                app.DragPeak = 0;
                app.drawImageOverlays();
            end
        end

        function addAtResidual(app)
            app.requireData();
            [u, I] = app.currentProfile();
            w = app.window();
            m = u >= w(1) & u <= w(2) & isfinite(I);
            if ~any(m), error('PeakFit:NoData', 'No finite data in the window.'); end
            model = zeros(size(u));
            if ~isempty(app.Peaks)
                bg = app.Background; if any(~isfinite(bg)), bg = [0 0]; end
                model = pkf_model(u, app.Peaks, bg, struct('uMid', mean(w)));
            end
            r = I - model; r(~m) = -Inf;
            [~, i] = max(r);
            app.addPeak(u(i));
        end

        function deleteSelected(app)
            k = app.SelectedPeak;
            if k < 1 || k > numel(app.Peaks), k = numel(app.Peaks); end
            if k < 1, return; end
            app.removePeak(k);
        end

        function onProgress(app, done, n)
            if mod(done, 5) == 0 || done == n
                app.Handles.StatusState.Text = sprintf('%d/%d', done, n);
                drawnow;
            end
        end

        % ---------------- drawing ----------------
        function redraw(app)
            if isempty(app.Data), return; end
            app.drawImageOverlays();
            app.drawProfile();
        end

        function drawImage(app)
            ax = app.Handles.Image;
            cla(ax);
            D = app.Data;
            im = imagesc(ax, D.x, D.y, D.value');
            set(ax, 'YDir', 'normal');
            axis(ax, 'tight');
            colormap(ax, flipud(gray));
            xlabel(ax, D.xLabel); ylabel(ax, D.yLabel);
            title(ax, sprintf('%s  (%s)', ifelse(isempty(D.name), 'input', D.name), app.Direction), ...
                'Interpreter', 'none', 'FontWeight', 'normal');
            im.ButtonDownFcn = @(~, ~) app.guard(@() app.onImageClick(ax.CurrentPoint(1, 1:2)));
        end

        function drawImageOverlays(app)
            if isempty(app.Data), return; end
            ax = app.Handles.Image;
            delete(findobj(ax, '-regexp', 'Tag', '^pkf_'));
            hold(ax, 'on');
            C = app.Colors;
            isMDC = strcmp(app.Direction, 'MDC');
            s0 = app.SliceValue; hw = app.Handles.HalfWidth.Value; w = app.window();
            xl = [min(app.Data.x) max(app.Data.x)]; yl = [min(app.Data.y) max(app.Data.y)];
            if hw > 0
                if isMDC
                    patch(ax, xl([1 2 2 1]), [s0 - hw s0 - hw s0 + hw s0 + hw], C.slice, 'FaceAlpha', 0.15, ...
                        'EdgeColor', 'none', 'Tag', 'pkf_band', 'HitTest', 'off');
                else
                    patch(ax, [s0 - hw s0 + hw s0 + hw s0 - hw], yl([1 1 2 2]), C.slice, 'FaceAlpha', 0.15, ...
                        'EdgeColor', 'none', 'Tag', 'pkf_band', 'HitTest', 'off');
                end
            end
            if isMDC
                plot(ax, xl, [s0 s0], '-', 'Color', C.slice, 'LineWidth', 1.2, 'Tag', 'pkf_slice', 'HitTest', 'off');
                plot(ax, [w(1) w(1) NaN w(2) w(2)], [yl NaN yl], '--', 'Color', C.window, 'Tag', 'pkf_window', 'HitTest', 'off');
            else
                plot(ax, [s0 s0], yl, '-', 'Color', C.slice, 'LineWidth', 1.2, 'Tag', 'pkf_slice', 'HitTest', 'off');
                plot(ax, [xl NaN xl], [w(1) w(1) NaN w(2) w(2)], '--', 'Color', C.window, 'Tag', 'pkf_window', 'HitTest', 'off');
            end
            T = app.Track;
            for k = 1:numel(app.Peaks)
                col = app.peakColor(k);
                if ~isempty(T) && size(T.centre, 2) >= k
                    v = T.valid(:, k);
                    [px, py] = app.toImage(T.slice_values(v), T.centre(v, k));
                    plot(ax, px, py, '.-', 'Color', col, 'MarkerSize', 7, 'Tag', 'pkf_dispersion', 'HitTest', 'off');
                    bad = T.attempted & ~v & isfinite(T.centre(:, k));
                    [bx, by] = app.toImage(T.slice_values(bad), T.centre(bad, k));
                    plot(ax, bx, by, 'x', 'Color', [0.8 0.1 0.1], 'MarkerSize', 5, 'Tag', 'pkf_rejected', 'HitTest', 'off');
                end
                [mx, my] = app.toImage(s0, app.Peaks(k).centre);
                plot(ax, mx, my, 'o', 'MarkerEdgeColor', 'w', 'MarkerFaceColor', col, 'MarkerSize', 6, ...
                    'Tag', 'pkf_seed', 'HitTest', 'off');
                if numel(app.Guides) >= k && ~isempty(app.Guides{k})
                    G = sortrows(app.Guides{k}, 1);
                    [gx, gy] = app.toImage(G(:, 1), G(:, 2));
                    plot(ax, gx, gy, ':s', 'Color', col, 'MarkerSize', 5, 'LineWidth', 1.2, 'Tag', 'pkf_guide', 'HitTest', 'off');
                end
            end
            hold(ax, 'off');
        end

        function yl = profileLimits(app, u, I, curve, w)
            % Y range from the fit window only, so detector-edge spikes
            % outside the window do not squash the fitted peaks.
            in = u >= w(1) & u <= w(2) & isfinite(I);
            if nnz(in) < 2, in = isfinite(I); end
            vals = I(in);
            if ~isempty(curve), vals = [vals(:); curve(in)]; end
            for k = 1:numel(app.Peaks)
                vals(end + 1) = app.Peaks(k).height + app.Background(1); %#ok<AGROW>
            end
            vals = vals(isfinite(vals));
            if isempty(vals), yl = [0 1]; return; end
            lo = min(vals); hi = max(vals);
            if hi <= lo, hi = lo + max(1, abs(lo)); end
            pad = 0.06 * (hi - lo);
            yl = [lo - pad, hi + pad];
        end

        function [px, py] = toImage(app, sliceVals, centres)
            if strcmp(app.Direction, 'MDC'), px = centres; py = sliceVals; else, px = sliceVals; py = centres; end
        end

        function drawProfile(app)
            if isempty(app.Data), return; end
            h = app.Handles; ax = h.Profile; axr = h.Residual; C = app.Colors;
            delete(allchild(ax)); cla(axr);   % allchild: markers/components have hidden handles
            [u, I, info] = app.currentProfile();
            w = app.window();
            hold(ax, 'on');
            plot(ax, u, I, '.', 'Color', C.data, 'MarkerSize', 6, 'HitTest', 'off', 'DisplayName', 'Data');
            [curve, comps, bgc, label] = app.modelCurve(u, info.index);
            for k = 1:size(comps, 2)
                plot(ax, u, comps(:, k) + bgc, '-', 'Color', app.peakColor(k), 'LineWidth', 0.8, ...
                    'HitTest', 'off', 'HandleVisibility', 'off');
            end
            if ~isempty(curve)
                plot(ax, u, bgc, ':', 'Color', C.bg, 'LineWidth', 1, 'HitTest', 'off', 'DisplayName', 'Background');
                style = ifelse(strcmp(label, 'Fit'), '-', '--');
                plot(ax, u, curve, style, 'Color', C.model, 'LineWidth', 1.6, 'HitTest', 'off', 'DisplayName', label);
            end
            for k = 1:numel(app.Peaks)
                pk = app.Peaks(k);
                bg = app.Background; if any(~isfinite(bg)), bg = [0 0]; end
                top = pk.height + bg(1) + bg(2) * (pk.centre - mean(w));
                if strcmp(app.Direction, 'EDC') && h.Fermi.Value
                    top = top * pkf_fermi(pk.centre, h.EF.Value, h.T.Value);
                end
                mk = plot(ax, pk.centre, top, 'v', 'MarkerSize', 9, 'MarkerFaceColor', app.peakColor(k), ...
                    'MarkerEdgeColor', 'k', 'HandleVisibility', 'off', 'Tag', sprintf('pkf_marker%d', k));
                mk.ButtonDownFcn = @(~, ~) app.startDrag(k);
                text(ax, pk.centre, top, sprintf(' %d', k), 'VerticalAlignment', 'bottom', ...
                    'Color', app.peakColor(k), 'FontWeight', 'bold', 'HitTest', 'off');
            end
            yl = app.profileLimits(u, I, curve, w);
            plot(ax, [w(1) w(1) NaN w(2) w(2)], [yl NaN yl], '--', 'Color', C.window, 'HitTest', 'off', 'HandleVisibility', 'off');
            ylim(ax, yl);
            hold(ax, 'off');
            xlim(ax, [min(u) max(u)]);
            xlabel(ax, app.profileLabel()); ylabel(ax, 'Intensity');
            title(ax, sprintf('%s at %s = %.5g', app.Direction, app.sliceName(), info.sliceValue), 'FontWeight', 'normal');
            if ~isempty(curve)
                legend(ax, 'Location', 'best', 'Box', 'off', 'FontSize', 9);
            else
                legend(ax, 'off');
            end
            if strcmp(label, 'Fit')
                m = u >= w(1) & u <= w(2);
                plot(axr, u(m), I(m) - curve(m), '.', 'Color', C.data, 'MarkerSize', 5);
                hold(axr, 'on'); plot(axr, w, [0 0], '-', 'Color', C.model); hold(axr, 'off');
            end
            xlim(axr, [min(u) max(u)]); xlabel(axr, app.profileLabel()); ylabel(axr, 'Residual');
        end

        function [curve, comps, bgc, label] = modelCurve(app, u, idx)
            curve = []; comps = zeros(numel(u), 0); bgc = zeros(size(u)); label = '';
            if isempty(app.Peaks), return; end
            bg = app.Background;
            if any(~isfinite(bg)), bg = [0 0]; end
            fitted = ~isempty(app.SliceResult) && app.SliceResult.ok && app.SliceResultIndex == idx;
            T = app.Track;
            if ~fitted && ~isempty(T) && size(T.centre, 2) == numel(app.Peaks)
                row = find(T.slice_index == idx, 1);
                fitted = ~isempty(row) && all(T.valid(row, :));
            end
            args = app.fitArgs();
            F = args{8};
            [curve, comps, bgc] = pkf_model(u, app.Peaks, bg, struct('uMid', mean(app.window()), 'Fermi', F));
            label = ifelse(fitted, 'Fit', 'Start values');
        end

        function c = peakColor(app, k)
            c = app.PeakColors(mod(k - 1, size(app.PeakColors, 1)) + 1, :);
        end

        % ---------------- busy state / errors ----------------
        function setFitState(app, state)
            k = find(strcmp(app.StatusStates, state), 1);
            app.FitState = state;
            app.Handles.StatusLamp.Color = app.StatusColors(k, :);
            app.Handles.StatusState.Text = state;
            busy = strcmp(state, 'Fitting…');
            app.Handles.FitSlice.Enable = ~busy;
            app.Handles.FitRange.Enable = ~busy;
            if busy, app.UIFigure.Pointer = 'watch'; end
            drawnow limitrate;
        end

        function endBusy(app)
            if isvalid(app) && ~isempty(app.UIFigure) && isvalid(app.UIFigure)
                app.Handles.FitSlice.Enable = 'on';
                app.Handles.FitRange.Enable = 'on';
                app.Handles.Stop.Enable = 'off';
                app.Handles.StatusState.Text = app.FitState;
                app.UIFigure.Pointer = 'arrow';
            end
        end

        function guard(app, fcn)
            try
                fcn();
            catch err
                app.showStatus(['Error: ' err.message]);
                if strcmp(app.UIFigure.Visible, 'on')
                    uialert(app.UIFigure, err.message, 'Peak fitting', 'Icon', 'error');
                end
            end
        end

        function tf = isInteractiveCall(~)
            st = dbstack;
            tf = any(contains({st.name}, 'guard'));
        end

        function requireData(app)
            if isempty(app.Data)
                error('PeakFit:NoData', 'Load a 2-D cut first.');
            end
        end

        function requirePeaks(app)
            app.requireData();
            if isempty(app.Peaks)
                error('PeakFit:NoPeaks', 'Add at least one peak (click on the profile, Auto-find or Add).');
            end
        end

        function requirePeak(app, k)
            if ~(isnumeric(k) && isscalar(k) && k == round(k) && k >= 1 && k <= numel(app.Peaks))
                error('PeakFit:InvalidPeak', 'Peak index must be between 1 and %d.', numel(app.Peaks));
            end
        end
    end
end

function out = ifelse(c, a, b)
if c, out = a; else, out = b; end
end
