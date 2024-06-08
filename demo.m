% Create an IterativeDisplay object 
% with a header interval of 5 seconds,
% and a value interval of 1 second;
% force a value display every 10th call regardless of the time interval 
id = IterativeDisplay(5, 1, 10);


% Example data structure for display.
%   info.(your_metric).spec is print format spec
%   info.(your_metric).val holds the value of the metric
info = struct('itr', struct('spec', '%3d',  'val', 0), ... % iteration
              'var', struct('spec', '%5s',  'val', 'beta'), ... % var name
              'grad',struct('spec', '%4.2e','val', 0.5), ... % gradient norm
              'gap', struct('spec', '%8.2e','val', 1e2)); % primal-dual gap

% Display the start of the iteration with header and initial values.
id.display_start(info);

% Simulate an iterative process and update info
max_itr = 200;
for ii = 1:max_itr
    pause(0.2*rand);  % simulate computation for 0.1 second on average 

    info.itr.val = ii;
    if rand < 0.1 
        % simulate switching the variables to update
        if strcmp(info.var.val, 'beta')
            info.var.val = 'alpha';
        else
            info.var.val = 'beta';
        end
        force_display = true;  % when switching occurs, display is forced
    else
        force_display = false;
    end
    info.grad.val = info.grad.val*rand; % Decrease gradient value for each iteration
    info.gap.val = info.gap.val / 2; % Decrease gap value for each iteration

    if ii == max_itr || rand < 0.005  % simulate termination in 1/0.005 = 200 iterations
        break;
    end
    
    id.display_optional(info, force_display); % Display the updated values if necessary based on time interval
end

% Display the final results after the iterative process ends, regardless of the time interval
id.display_end(info);
