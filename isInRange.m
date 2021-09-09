% Checks wheter a specific value lies in a specific range.
% Input: The value and the interval to check for.
% Output: A boolean value indicating whether the value lies in the interval
% or not.

function is_in_range = isInRange(number, interval)

% Get mionimum and maximum from interval.
min = interval(1);
max = interval(2);

% Check whether specified value is in the specified range.
is_in_range = number >= min && number <= max;
end

