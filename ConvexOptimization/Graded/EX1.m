%DAWID MACZKA EXERCISE 1


img = imread('peppers-bw.bmp');
% Get the image dimensions
[rows, cols, ~] = size(img);

% Set the number of random pixels to set to black
num_pixels = 100;

% Generate random coordinates within the image
rand_rows = randi([180, 480], num_pixels, 1);
rand_cols = randi([160, 400], num_pixels, 1);

img_original = img;
img_normalized = im2double(img_original);

figure
subplot(2, 3, 1);
imshow(img_normalized);
title('Original Image');

% x - x(:, [end, 1:end-1]) is the diff between the img and the img shifted
% to the right (by 1 column) or the bottom (by 1 row). Concat by z dim (we just stack them).
gradient_operator = @(x) cat(3, x - x(:, [end, 1:end-1]), x - x([end, 1:end-1], :));
gradients = gradient_operator(img_normalized);

subplot(2, 3, 2);
imshow(abs(gradients(:, :, 1)));
title('X-Gradient');

subplot(2, 3, 3);
imshow(abs(gradients(:, :, 2)));
title('Y-Gradient');

% on dim: A*A*2
% jesus christ:
% v(:, [2:end, 1], 1) shifts the img back to normal, we subtract the
% right-shifted version from it
% same is done with the 2. layer, shift to normal, subtract the bot-shifted
% version
% those differences are then added. Result is of dim A*A
divergence_operator = @(v) (v(:, [2:end, 1], 1) - v(:, :, 1) + v([2:end, 1], :, 2) - v(:, :, 2));

noisy_image = img_normalized;
for i = 1:num_pixels
    var = randi([-2000, 2000]) / 10000;
    noisy_image(rand_rows(i), rand_cols(i), :) = img_normalized(rand_rows(i), rand_cols(i), :) + var;
end

subplot(2, 3, 4);
imshow(noisy_image);
title('Noisy Image');

regularization_lambda = 0.3 / 5;

regularization_epsilon = 0.01;
%
norm_epsilon = @(u) sqrt(regularization_epsilon^2 + sum(u.^2, 3));
regularization_term = @(x) sum(sum(norm_epsilon(gradient_operator(x))));

data_fidelity_term = @(x) 1/2 * norm(x - noisy_image)^2;
gradient_norm_epsilon = @(u) u ./ repmat(norm_epsilon(u), [1, 1, 2]);
regularization_gradient = @(x) -divergence_operator(gradient_norm_epsilon(gradient_operator(x)));
gradient_fidelity_term = @(x) x - noisy_image + regularization_lambda * regularization_gradient(x);

step_size = 10.8 / (1 + regularization_lambda * 8 / regularization_epsilon);
num_iterations = 500;
function_values = zeros(1, num_iterations);
x_restored = noisy_image;

for i = 1:num_iterations
    function_values(i) = data_fidelity_term(x_restored) + regularization_lambda * regularization_term(x_restored);
    x_restored = x_restored - step_size * gradient_fidelity_term(x_restored);
end

subplot(2, 3, 5);
plot(function_values);
title('Function Values');

subplot(2, 3, 6);
imshow(x_restored);
title('Restored Image');
