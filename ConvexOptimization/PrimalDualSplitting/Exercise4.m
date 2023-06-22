% Load image, convert to grayscale, and resize
originalImage = imread('parrot.png');
imageSize = 256;
originalImage = im2double(originalImage);
originalImage = imresize(originalImage,[imageSize,imageSize]);
% plot
figure
subplot(2, 3, 1);
imshow(originalImage);
title('Original Image');

% Generate a binary mask with randomly distributed zeros
maskDensity = 0.2;
randomMask1 = rand(imageSize,imageSize) > maskDensity;

% Apply mask to create a noisy image
noisyImage = randomMask1 .* originalImage;

maskDensity = 0.3;
randomMask2 = rand(imageSize,imageSize) > maskDensity;

% Apply mask to create a noisy image
noisyImage = randomMask2 .* noisyImage;

randomMask = randomMask1 & randomMask2;

% plot
subplot(2, 3, 2);
imshow(noisyImage);
title('Noisy Image');

noisyImage = rgb2gray(noisyImage);
originalImageGray = rgb2gray(originalImage);

% Define gradient and divergence functions
gradientFunc = @(image) cat(3,image-image(:,[end, 1:end-1]),image-image([end, 1:end-1],:));
divergenceFunc = @(gradient) (gradient(:,[2:end 1],1)-gradient(:,:,1) + gradient([2:end 1],:,2)-gradient(:,:,2));

% Define norm and objective function (total variation)
normFunc = @(gradient) sqrt(sum(gradient.^2,3)); 
totalVariationFunc = @(image) sum(sum(normFunc(gradientFunc(image))));

% Define proximal operators
proximalOperatorF = @(gradient, stepSize) max(0,1-stepSize./repmat(normFunc(gradient),[1 1 2])).*gradient;
proximalOperatorFs = @(gradient, stepSize) gradient - stepSize * proximalOperatorF(gradient/stepSize, 1/stepSize);
proximalOperatorG = @(image, stepSize) image + randomMask .* (noisyImage - randomMask .* image);

% Initialize algorithm parameters
dualStepSize = 10; 
primalStepSize = 0.9/80;
relaxationParam = 1; 
numIterations = 100;

% Initialize primal and dual variables
primalVar = noisyImage;
relaxedPrimalVar = noisyImage;
dualVar = 0 * gradientFunc(noisyImage);

% Initialize variables for storing the total variation and SNR at each iteration
totalVariation = zeros(1, numIterations);
SNR = zeros(1, numIterations);

% Main loop for the primal-dual splitting method
for i=1:numIterations
    dualVar = proximalOperatorFs(dualVar + dualStepSize * gradientFunc(relaxedPrimalVar), dualStepSize);
    oldPrimalVar = primalVar;
    primalVar = proximalOperatorG(primalVar + primalStepSize * divergenceFunc(dualVar), primalStepSize);
    relaxedPrimalVar = primalVar + relaxationParam * (primalVar - oldPrimalVar);
    totalVariation(i) = totalVariationFunc(relaxedPrimalVar);
    SNR(i) = snr(originalImageGray, relaxedPrimalVar);    
end

% Display the denoised and inpainted image
rgbImageAgain =cat(3, relaxedPrimalVar, relaxedPrimalVar, relaxedPrimalVar);
subplot(2, 3, 3);
imshow(rgbImageAgain);
title('Denoised Image');

% Display the total variation at each iteration
subplot(2, 3, 4);
plot(totalVariation);
title('Total variation');

% Display the SNR at each iteration
subplot(2, 3, 5);
plot(SNR);
title('SNR');
