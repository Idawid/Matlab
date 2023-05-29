function GradientDescent(eta, numIterations, initialPoint)
%GRADIENTDESCENT Summary of this function goes here
%   Detailed explanation goes here
    gridPoints = linspace(-1, 1, 100);
    [xValues, yValues] = meshgrid(gridPoints, gridPoints);
    functionValues = (xValues.^2+eta*yValues.^2);    
    
    Gradf = @(x) [x(1), eta * x(2)];
    stepSize = 0.5 / eta;
    x = initialPoint;
    trajectory = zeros(numIterations, 2);
    
    for i = 1:numIterations
        x = x - stepSize * Gradf(x);
        trajectory(i, :) = x;
    end

    figure
    hold on
    imagesc(gridPoints, gridPoints, functionValues);
    plot(trajectory(:, 1), trajectory(:, 2), 'w');
    hold off
end

