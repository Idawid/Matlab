% read image and convert to double precision grayscale
originalImage = imread('star.jpg');
originalImage = imresize(originalImage, [192,192]); % scale it down or else it takes ages
initialImage = im2double(rgb2gray(originalImage));
% plot
figure
subplot(1, 3, 1);
imshow(initialImage);
title('Original Image');

% create a mask
maskSize = 4;
imageSize = size(initialImage, 1);
mask = ones(imageSize);
mask([(floor(imageSize/2)-maskSize):(floor(imageSize/2)+maskSize)],:) = 0;

% apply mask to initial image
noisyImage = mask .* initialImage;
% plot
subplot(1, 3, 2);
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

% projected gradient descent loop
for i=1:iterations
    energy(i) = totalVariation(currentImage, smoothingParam);
    tempImage = currentImage - stepSize * gradientOfTV(currentImage, smoothingParam);
    currentImage = projectOntoD(tempImage);
end

% display denoised image
subplot(1, 3, 3);
imshow(currentImage);
title('Restored Image')