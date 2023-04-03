% Load log data into a table
log_table = NiGaablog;
items = log_table.Properties.VariableNames; % Get variable names from the table
v_num = size(log_table,1); % Number of variables (rows)
p_num = size(log_table,2); % Number of properties (columns)

% Loop through each variable in the log table
for i = 1:v_num
    % Check if the variable exists in the workspace
    if exist(log_table{i,1},'var') == 1
        % Loop through each property for the current variable
        for j = 2:p_num
            % Update the corresponding info property of the variable with the log_table value
            eval(append(log_table{i,1},'.info.(items{j}) = log_table{i,j};'));
        end
    else
        % If the variable is not found, display a message
        disp(append('Variable ',log_table{i,1}, ' is not found.'));
    end
end


% 
% % load log into table
% log_table = NiGaablog;
% items = log_table.Properties.VariableNames;
% v_num = size(log_table,1);
% p_num = size(log_table,2);
% 
% for i = 1:v_num
%     if exist(log_table{i,1},'var') == 1
%         for j = 2:p_num
%             eval(append(log_table{i,1},'.info.(items{j}) = log_table{i,j};'));
%         end
%     else
%         disp(append('Variable ',log_table{i,1}, ' is not found.'));
%     end
% end

