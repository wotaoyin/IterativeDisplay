# IterativeDisplay Class

Author: Wotao Yin

Date: June 9, 2024

## Introduction

The `IterativeDisplay` class for MATLAB is designed to assist in displaying iterative process updates in a structured and customizable manner. This class allows you to display headers and values at specified intervals, ensuring that the iterative progress is clearly visible. It is particularly useful in optimization algorithms or any iterative computations where progress information is periodically updated.

## Features

- **Header and Value Intervals**: Customize how often headers and values are displayed.
- **Forced Display**: Option to force display of values after a certain number of iterations or whenever the user wants.
- **Column Width Management**: Automatically adjusts column widths based on the data to ensure a neat display.
- **Customizable Display Formats**: Specify custom formats for displaying different metrics.

## Usage

### Class Definition

Here is a brief overview of the class properties and methods:

```matlab
classdef IterativeDisplay < handle
    properties
        header_interval       % Interval in seconds for displaying headers
        prev_header_time      % Previous time a header was displayed
        header_str            % String for header display
        
        value_interval        % Interval in seconds for displaying values
        prev_value_time       % Previous time a value was displayed
        
        value_onceevery       % Force value display every N calls
        value_skip_count      % Count of skipped value displays
        
        col_widths            % Widths of columns for display
        gap_size              % Gap size between columns
    end

    methods
        function obj = IterativeDisplay(header_interval, value_interval, value_onceevery)
            % Constructor to initialize the display intervals
        end
        
        function display_start(obj, info)
            % Display the start of the iteration with header and initial values
        end

        function display_optional(obj, info, force_value_display)
            % Conditionally display values based on intervals or force display
        end
        
        function display_end(obj, info)
            % Display the final results
        end

        function print_header_line(obj)
            % Print the header line
        end
        
        function print_value_line(obj, info)
            % Print the value line
        end
        
        function update_header_and_widths(obj, info)
            % Update the header and column widths based on the info structure
        end
        
        function needs_header = is_header_needed(obj)
            % Determine if header needs to be displayed
        end

        function needs_value = is_value_needed(obj)
            % Determine if values need to be displayed
        end
    end
end
```

### Explanation of Demo Code

demo.m is a demonstration of how to use the `IterativeDisplay` class:

1. **Creating the IterativeDisplay Object**:
   ```matlab
   id = IterativeDisplay(5, 1, 10);
   ```
   This creates an instance of `IterativeDisplay` with a header interval of 5 seconds, a value interval of 1 second, and forces a value display every 10th call.

2. **Setting Up the Info Structure**:
   ```matlab
   info = struct('itr', struct('spec', '%3d',  'val', 0), ...
                 'var', struct('spec', '%5s',  'val', 'beta'), ...
                 'grad',struct('spec', '%4.2e','val', 0.5), ...
                 'gap', struct('spec', '%8.2e','val', 1e2));
   ```
   The `info` structure holds the metrics to be displayed, with each field having a user-specific name and two subfields `spec` (format specification) and `val` (value).

3. **Starting the Display**:
   ```matlab
   id.display_start(info);
   ```
   This method displays the header and initial values.

4. **Simulating an Iterative Process**:
   ```matlab
   for ii = 1:max_itr
       % Simulate computation and update info
       % ...
       id.display_optional(info, force_display);
   end
   ```
   In this loop, the `info` structure is updated in each iteration, and the `display_optional` method is called to display updates based on the specified intervals or force display conditions.

5. **Ending the Display**:
   ```matlab
   id.display_end(info);
   ```
   This method displays the final values after the iterative process ends.

### An Example Output

   ```matlab
   itr    var      grad       gap      
     0    beta   5.00e-01   1.00e+02   
     1   alpha   1.30e-01   5.00e+01   
     6    beta   6.55e-03   1.56e+00   
    13   alpha   5.33e-05   1.22e-02   
    23   alpha   1.28e-11   1.19e-05   
    28    beta   1.10e-12   3.73e-07   
    30   alpha   1.48e-13   9.31e-08   
    33    beta   3.41e-16   1.16e-08   
    43    beta   1.54e-21   1.14e-11   
   
   itr    var      grad       gap      
    47   alpha   4.66e-23   7.11e-13   
    48    beta   3.07e-23   3.55e-13   
    57    beta   7.43e-29   6.94e-16   
    64   alpha   1.21e-34   5.42e-18   
    67    beta   4.33e-36   6.78e-19   
    77   alpha   1.25e-38   6.62e-22   
    87   alpha   4.05e-41   6.46e-25   
    92    beta   9.47e-45   2.02e-26   
    93   alpha   4.68e-45   1.01e-26   
   
   itr    var      grad       gap      
    99    beta   1.06e-47   1.58e-28   
   107    beta   3.94e-50   6.16e-31   
   117    beta   2.23e-54   6.02e-34   
   127    beta   7.97e-58   5.88e-37   
   134   alpha   4.82e-60   4.59e-39   
   144   alpha   6.85e-67   4.48e-42   
   
   itr    var      grad       gap      
   154   alpha   3.13e-73   4.38e-45   
   163    beta   9.12e-77   8.55e-48   
   164   alpha   9.03e-77   4.28e-48   
   171   alpha   1.49e-80   3.34e-50   
   181   alpha   1.01e-82   3.26e-53   
   187    beta   1.21e-85   5.10e-55   
   197    beta   3.45e-90   4.98e-58   
   
   itr    var      grad       gap      
   200    beta   1.03e-90   6.22e-59  
   ```