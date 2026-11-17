function state = plotBZ_V1_simulation_color(action, handles)
%PLOTBZ_V1_SIMULATION_COLOR Retain independent colours for both scan modes.
%   MODE saves the outgoing mode's colour and restores the incoming mode's
%   choice. CHANGE records an edit to the active colour menu. Defaults are
%   orange for fixed photon energy and purple for a photon-energy scan.
%   State belongs to this control panel and never modifies existing plots.

arguments
    action (1,:) char {mustBeMember(action, {'mode','change'})}
    handles (1,1) struct
end
panel = ancestor(handles.sim_mode, 'figure');
key = 'plotBZSimulationColors';
mode = get(handles.sim_mode, 'Value');
selection = get(handles.sim_color, 'Value');
validateattributes(mode, {'numeric'}, {'scalar','integer','>=',1,'<=',2});
validateattributes(selection, {'numeric'}, {'scalar','integer','>=',1,'<=',5});

state = getappdata(panel, key);
if isempty(state)
    state = struct('currentMode', 0, 'selections', [1 2]);
end
if strcmp(action, 'mode') && mode ~= state.currentMode
    if state.currentMode > 0
        state.selections(state.currentMode) = selection;
    end
    set(handles.sim_color, 'Value', state.selections(mode));
else
    state.selections(mode) = selection;
end
state.currentMode = mode;
setappdata(panel, key, state);
end
