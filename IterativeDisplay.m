classdef IterativeDisplay < handle

    properties
        header_interval
        prev_header_time
        header_str

        value_interval
        prev_value_time

        value_onceevery
        value_skip_count
        
        col_widths
        gap_size
    end

    methods
        
        function obj = IterativeDisplay(header_interval, value_interval, value_onceevery)
            if nargin > 0
                obj.header_interval = header_interval;
            else
                obj.header_interval = 5; % default header interval
            end
            if nargin > 1
                obj.value_interval = value_interval;
            else
                obj.value_interval = 2; % default value interval
            end
            if nargin > 2
                obj.value_onceevery = value_onceevery;
            else
                obj.value_onceevery = inf;
            end
            obj.prev_header_time = tic;
            obj.prev_value_time = tic;
            obj.header_str = '';
            obj.col_widths = [];
            obj.gap_size = 3;   % default gap size between columns
        end
        
        function display_start(obj, info)
            update_header_and_widths(obj, info);
            print_header_line(obj);
            print_value_line(obj, info);
        end

        function display_optional(obj, info, force_value_display)
            if nargin < 3
                force_value_display = false;
            end
            if is_header_needed(obj)
                print_header_line(obj);
            end
            if force_value_display || is_value_needed(obj)
                print_value_line(obj, info);
            end
        end
        
        function display_end(obj, info)
            print_value_line(obj, info);
            obj.prev_value_time = tic;
        end

        function print_header_line(obj)
            if ~isempty(obj.header_str)
                fprintf('\n%s\n', obj.header_str);
                obj.prev_header_time = toc;
            end
        end
        
        function print_value_line(obj, info)
            for i = 1:length(fieldnames(info))
                metric_names = fieldnames(info);
                metric_name = metric_names{i};
                spec = info.(metric_name).spec;
                val = info.(metric_name).val;
                fprintf(sprintf('%%%ds%s', obj.col_widths(i)-obj.gap_size, ...
                                repmat(' ', 1, obj.gap_size)),...
                        sprintf(spec, val));
            end
            fprintf('\n');
            obj.prev_value_time = toc;
            obj.value_skip_count = 0;
        end
        
        function update_header_and_widths(obj, info)
            metric_names = fieldnames(info);
            name_widths = cellfun(@(name) length(name), metric_names);
            spec_widths = cellfun(@(name) length(sprintf(info.(name).spec,1)), metric_names);
            coln_widths = max(name_widths, spec_widths);

            front_padding = floor(max(coln_widths-name_widths,0)/2);
            rear_padding = ceil(max(coln_widths-name_widths,0)/2)+obj.gap_size;
            
            for ii = 1:length(metric_names)
                metric_names{ii} = append(repmat(' ', 1, front_padding(ii)), ...
                                          metric_names{ii}, ...
                                          repmat(' ', 1, rear_padding(ii)));
            end

            if ~isequal(obj.col_widths, coln_widths + obj.gap_size)
                obj.header_str = strjoin(metric_names,'');
                obj.col_widths = coln_widths + obj.gap_size;
            end
        end
        
        function needs_header = is_header_needed(obj)
            needs_header = (toc - obj.prev_header_time) >= obj.header_interval;
        end

        function needs_value = is_value_needed(obj)
            needs_value = obj.value_skip_count >= obj.value_onceevery - 1 ...
                          || (toc - obj.prev_value_time) >= obj.value_interval;
            if ~needs_value && ~isinf(obj.value_onceevery)
                obj.value_skip_count = obj.value_skip_count + 1;
            end
        end
    
    end

end