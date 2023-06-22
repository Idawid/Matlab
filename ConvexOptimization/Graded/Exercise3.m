% Ex3. Hide the following cells of image in black color.
% Restore the black-white image using projected gradient descent algorithm.
% Display 4 results on separate figures progressed in a loop for iterations 1/4, 2/4, 3/4, 1
% times number of the iterations.


img = imread('parrot.png');
img = rgb2gray(img);
img = imresize(img,[200, 200]);
img = im2double(img);
figure;
subplot(2, 3, 1);
imshow(img);
title('Original Image');
restored_image = img;
% Positions of the cells we want to hide
positions = [ 
    1, 58;   % pos 1
    72, 58;    % pos 2
    110, 97     % pos 3
];

for i = 1:size(positions, 1)
    x = positions(i, 2);
    y = positions(i, 1);
    img(x:x+38, y:y+38) = 0;
end

subplot(2, 3, 2);
imshow(img);
title('Defective Image');


% Parameters for the projected gradient descent algorithm
alpha = 0.1;  % Learning rate
num_iterations = 200;  % Total number of iterations
output_iterations = [50, 100, 150, num_iterations];  % Iterations to display output

% Projected Gradient Descent algorithm
for iteration = 1:num_iterations
    % Compute the gradient of the objective function
    gradient = 2 * (restored_image - img);
    
    % Update the restored image using projected gradient descent
    restored_image = restored_image - alpha * gradient;
    
    % Project the restored image back to the valid range [0, 1]
    restored_image = max(0, min(1, restored_image));
    
    % Display output at specific iterations
    if ismember(iteration, output_iterations)
        figure;
        imshow(restored_image);
        title(sprintf('Iteration %d/%d', iteration, num_iterations));
    end
end