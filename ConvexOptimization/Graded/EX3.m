%DAWID MACZKA EXERCISE 3%


% Load image, convert to grayscale, and resize
originalImage = imread('hibiscus.bmp');
imageSize = 256;
originalImageGray = originalImage; %just to keep the existing code
originalImageGray = im2double(originalImageGray);
originalImageGray = imresize(originalImageGray, [imageSize, imageSize]);
% plot
figure
subplot(2, 3, 1);
imshow(originalImageGray);
title('Original Image');

% Generate a binary mask with randomly distributed zeros
maskDensity = 1 - 0.7;
randomMask = rand(imageSize,imageSize) > maskDensity;
% I had to change the mask because I had to resize the file (my laptop is
% too slow)
randomMask(1:50,:) = 1;
randomMask(180:end,:) = 1;
randomMask(:,1:50) = 1;
randomMask(:,180:end) = 1;

% Apply mask to create a noisy image
noisyImage = randomMask .* originalImageGray;
% plot
subplot(2, 3, 2);
imshow(noisyImage);
title('Noisy Image');

% Define gradient and divergence functions
gradientFunc = @(image) cat(3,image-image(:,[end, 1:end-1]),image-image([end, 1:end-1],:));
divergenceFunc = @(gradient) (gradient(:,[2:end 1],1)-gradient(:,:,1) + gradient([2:end 1],:,2)-gradient(:,:,2));

% Define norm and objective function (total variation)
normFunc = @(gradient) sqrt(sum(gradient.^2,3)); 
totalVariationFunc = @(image) sum(sum(normFunc(gradientFunc(image))));

% Define proximal operators
proximalOperatorF = @(gradient, stepSize) max(0,1-stepSize./repmat(normFunc(gradient),[1 1 2])).*gradient;
proximalOperatorFs = @(gradient, stepSize) gradient - stepSize * proximalOperatorF(gradient/stepSize, 1/stepSize);
proximalOperatorG = @(image, stepSize, channel) image + randomMask .* (noisyImage(:,:,channel) - randomMask .* image);

% Initialize algorithm parameters
dualStepSize = 10; 
primalStepSize = 0.9/80;
relaxationParam = 1; 
numIterations = 100;


% Initialize primal and dual variables
initialPrimalVar = noisyImage;
initialRelaxedPrimalVar = noisyImage;
initialDualVar = noisyImage & 0;


% Initialize variables for storing the total variation and SNR at each iteration
totalVariation = zeros(1, numIterations);
SNR = zeros(1, numIterations);

% Main loop for the primal-dual splitting method
for c=1:3

    %image = image(:,:,c);
    primalVar = initialPrimalVar(:,:,c);
    relaxedPrimalVar = initialRelaxedPrimalVar(:,:,c);
    dualVar = initialDualVar(:,:,c);

    for i=1:numIterations
        dualVar = proximalOperatorFs(dualVar + dualStepSize * gradientFunc(relaxedPrimalVar), dualStepSize);
        oldPrimalVar = primalVar;
        primalVar = proximalOperatorG(primalVar + primalStepSize * divergenceFunc(dualVar), primalStepSize, c);
        relaxedPrimalVar = primalVar + relaxationParam * (primalVar - oldPrimalVar);
        totalVariation(i) = totalVariationFunc(relaxedPrimalVar);
        %SNR(i) = snr(originalImageGray, relaxedPrimalVar);    
    end

    initialPrimalVar(:,:,c) = primalVar;
    initialRelaxedPrimalVar(:,:,c) = relaxedPrimalVar;
end

% Display the denoised and inpainted image
subplot(2, 3, 3);
imshow(initialRelaxedPrimalVar);
title('Denoised Image');

% Display the total variation at each iteration
subplot(2, 3, 4);
plot(totalVariation);
title('Energy');

% Display the SNR at each iteration
subplot(2, 3, 5);
plot(SNR);
title('SNR');
