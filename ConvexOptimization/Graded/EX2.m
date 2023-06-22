%DAWID MACZKA EXERCISE 3%
% Let 𝑓(𝑥,𝑦)=1/2 * (x-2)^2 + y 
% RADIUS 1
% Perform 100 iterations of gradient descent algorithm to minimize the function.
% Start from point (2,2).
% Display the values of function in graph where on OX axis are iteration numbers. 

f = @(x, y) 0.5*(x-2)^2 + y;

% derivative df/dx, df/dy, df/dz
grad_f = @(x, y) [x-2;1]; 

% starting point (3,3)
x0 = 3;
y0 = 3;

step_size = 0.1;

iterations = 1:500;
function_values = zeros(1, 100);

% for 2nd plot
gridPoints = linspace(-5, 5, 200);
[xValues, yValues] = meshgrid(gridPoints, gridPoints);
functionValues = (0.5*(xValues-2).^2 + yValues); 
trajectory = zeros(500, 2);

for i = 1:500
    gradient = grad_f(x0, y0);

    x0 = x0 - step_size * gradient(1);
    y0 = y0 - step_size * gradient(2);
   
    % apply projection function lol
    if (x0^2 + y0^2 > 1)
        norm = sqrt(x0^2 + y0^2);
        x0 = x0 /norm;
        y0 = y0 /norm;
    end

    function_values(i) = f(x0,y0);
    trajectory(i, :) = function_values(i);
end

figure;
subplot(1, 2, 1);
plot(iterations, function_values);
xlabel('iteration number');
ylabel('f value');
title('Value plot');

subplot(1,2,2);
hold on
imagesc(gridPoints, gridPoints, functionValues);
plot(trajectory(:, 1), trajectory(:, 2), 'w');
title('Trajectory');
hold off