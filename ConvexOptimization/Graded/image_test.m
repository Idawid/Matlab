% Ex2. (simple import test) Given image import to matlab and display in grayscale in 200x200 format 
img = imread('parrot.png');
img = rgb2gray(img);
img = imresize(img,[200, 200]);
img = im2double(img);
figure;
imshow(img);