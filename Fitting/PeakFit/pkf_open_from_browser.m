function app = pkf_open_from_browser(src, ~)
%PKF_OPEN_FROM_BROWSER  Menu callback: open PeakFit_app on the browser selection.
%   Used by "Fit Peaks (MDC/EDC)" in data_browser_demo_v32 (Tools) and
%   ARPES_data_browser_v5 (Analyze > Fit spectra). The first selected
%   base-workspace variable that is a 2-D cut is loaded; otherwise the app
%   opens empty and its status line says why. The browser is only read.
name = '';
note = '';
try
    fig = ancestor(src, 'figure');
    h = guidata(fig);
    names = {};
    if isstruct(h) && isfield(h, 'VarNames'), names = cellstr(h.VarNames); end
    for k = 1:numel(names)
        candidate = names{k};
        if ~isvarname(candidate) || ~evalin('base', sprintf('exist(''%s'', ''var'')', candidate))
            continue
        end
        try
            pkf_input(candidate);
            name = candidate;
            break
        catch err
            note = sprintf('%s was not loaded: %s', candidate, err.message);
        end
    end
catch
    name = '';
end
if isempty(name)
    app = PeakFit_app();
    if ~isempty(note), app.showStatus(note); end
else
    app = PeakFit_app(name);
end
end
