function [intercept, slope] = LeastSquares(x_values, y_values)
% This function fits a linear function to a set of data points using the
% least squares method.

% Inputs:
%   x_values: Array of independent variable values (1D array)
%   y_values: Array of dependent variable values (1D array)
%
% Outputs:
%   intercept: Intercept of the fitted linear function
%   slope: Slope of the fitted linear function

num_points = size(x_values, 2);
X = ones(num_points, 2); % matrix filled with 1 5x2
X(:, 2) = x_values;      

Y = y_values';           

B = (X' * X) \ X' * Y;   % Y=XB -> X'Y=X'XB -> inv(X'X)*X'Y=inv(X'X)*(X'X)B 
                         % -> inv(X'X)*X'*Y=B or (X'X)\X'Y=B from (X'Y=X'XB)

intercept = B(1);
slope = B(2);


figure;
hold on;
plot(x_values, y_values, '.', 'MarkerSize', 12); % Plotting original data points
plot([x_values(1), x_values(end)], [slope * x_values(1) + intercept, slope * x_values(end) + intercept], 'LineWidth', 2); % Plotting fitted linear function

end