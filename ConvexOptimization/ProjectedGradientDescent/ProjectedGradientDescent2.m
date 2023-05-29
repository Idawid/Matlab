% read image and convert to double precision grayscale
originalImage = imread('parrot.png');
originalImage = imresize(originalImage, [192,192]); % scale it down or else it takes ages
initialImage = im2double(rgb2gray(originalImage));
% plot
figure
subplot(2, 3, 1);
imshow(initialImage);
title('Original Image');

% create a mask
imageSize = size(initialImage,1);
mask = ones(imageSize);

% generate three random positions for the 40x40 squares within the image boundaries
for i = 1:3
    randRow = randi([1, imageSize-40]); % generate a random row index
    randCol = randi([1, imageSize-40]); % generate a random column index
    mask(randRow:(randRow+39), randCol:(randCol+39)) = 0;
end

% apply mask to initial image
noisyImage = mask .* initialImage;
% plot
subplot(2, 3, 2);
imshow(noisyImage);
title('Noisy Image');

% define functions
applyMask = @(image) mask .* image; % function to apply mask to processed image
applyMaskConjugate = @(image) mask .* image; % conjugate function to apply mask to processed image
projectOntoD = @(image) image + applyMaskConjugate(noisyImage - applyMask(image));

% define gradient and divergence
computeGradient = @(image)cat(3, image-image(:,[end,1:(end-1)]),image-image([end,1:(end-1)],:));
computeDivergence = @(gradient) (gradient(:,[2:end,1],1)-gradient(:,:,1)+gradient([2:end,1],:,2)-gradient(:,:,2));

% define smoothing parameters
smoothingParam = 0.001;
normWithSmoothing = @(gradient,smoothingParam) sqrt(smoothingParam^2+sum(gradient.^2,3));
totalVariation = @(image,smoothingParam) sum(sum(normWithSmoothing(computeGradient(image),smoothingParam)));
normalize = @(gradient,smoothingParam) gradient./repmat(normWithSmoothing(gradient,smoothingParam),[1,1,2]);
gradientOfTV = @(image,smoothingParam)-computeDivergence(normalize(computeGradient(image),smoothingParam));

% define step size for gradient iteration
stepSize = 1.8/(8/smoothingParam);
iterations = 40000;

% initialize by noisy image
currentImage = noisyImage;
energy = zeros(1,iterations);


output_iterations = [iterations/4, iterations/2, iterations*3/4];

% projected gradient descent loop
for i=1:iterations
    energy(i) = totalVariation(currentImage, smoothingParam);
    tempImage = currentImage - stepSize * gradientOfTV(currentImage, smoothingParam);
    currentImage = projectOntoD(tempImage);
    
    if ismember(i, output_iterations)
        % display denoised image
        subplot_position = find(output_iterations == i);
        subplot(2, 3, 3+subplot_position);
        imshow(currentImage);
        title(sprintf('Iteration %d/%d', i, iterations));
    end
end

% display denoised image
subplot(2, 3, 3);
imshow(currentImage);
title('Restored Image')