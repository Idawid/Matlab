function imageFeatureDetection(imagePath, image2Path)
% imageFeatureDetection detects features in two input images and displays the results.
    %
    % Inputs:
    %   imagePath: File path of the first image
    %   image2Path: File path of the second image
    
    imgWFeature = imread(imagePath);    % they could be very well reversed
    imgWOFeature = imread(image2Path);
    
    % Display the original images
    figure;
    subplot(2, 2, 1);
    imshow(imgWFeature);
    title('Image 1');
    subplot(2, 2, 2);
    imshow(imgWOFeature);
    title('Image 2');

    % Convert images to grayscale
    img1Gray = rgb2gray(imgWFeature);
    img2Gray = rgb2gray(imgWOFeature);

    % Calculate the absolute difference between the grayscale images
    imageDifference = abs(img1Gray - img2Gray);
    
    % Display the difference image
    subplot(2, 2, 3);
    imshow(imageDifference);
    title('Difference Image');

    % Find the maximum difference and its location
    maxDifference = max(imageDifference(:));
    [maxDiffRow, maxDiffCol] = find(maxDifference == imageDifference);
    % and highlight it
    hold on;
    plot(maxDiffRow, maxDiffCol, 'r*');
    hold off;

    % Select pixels where the diff is bigger than 10
    imageThreshold = imageDifference > 10;  
    % Remove objects containing fewer than 500000 total pixels
    imageThreshold = bwareaopen(imageThreshold, 500000); 
    
    % Display the image with detected features
    subplot(2, 2, [3, 4]);
    imshow(imageThreshold * 255);
    title('Detected Features');

end