# Projected Gradient Descent for Total Variation Denoising
This script uses a projected gradient descent algorithm for total variation (TV) denoising of grayscale images. The aim is to remove noise while preserving edges in the image.
## Script Description
The script takes a grayscale image, artificially introduces noise via a mask, and then applies a projected gradient descent algorithm to denoise the image.

Here are the functions defined in the script and their mathematical background:
- `applyMask` and `applyMaskConjugate`: These functions are used to apply a mask to the image.
 The mask is an array with the same size as the image where the elements that correspond to the noisy parts of the image are set to zero and the rest are set to one.
 When the mask is applied to an image, it sets the pixel values corresponding to the noisy parts to zero.
- `projectOntoD`: This function is the projection operator, which projects an image back onto the feasible set after each gradient descent step. This ensures that the modified image remains close to the observed noisy image. Mathematically, it adds the difference between the masked noisy image and the masked processed image to the processed image.

- `computeGradient` and `computeDivergence`: These functions compute the gradient and divergence of an image, respectively.
 They use finite differences to approximate the derivatives.
 The gradient of an image measures the change in pixel intensities, while the divergence is a measure of how much the image "spreads out" from a point.

- `normWithSmoothing`:
 This function computes a smoothed norm of a gradient.
 The smoothing parameter epsilon is used to avoid numerical issues when the gradient is zero. It adds a small constant to the squared sum of the gradient components before taking the square root.

- `totalVariation`: This function computes the total variation of the image, which is a measure of the "roughness" or "complexity" of the image. It sums up the smoothed norm of the gradient across the whole image.

- `normalize`: This function normalizes a gradient by dividing it by its smoothed norm. This is used in the computation of the gradient of the total variation.

- `gradientOfTV`: This function computes the gradient of the total variation, which is used to perform the gradient descent step. The gradient points in the direction of the greatest increase of the total variation, so subtracting it from the current image will decrease the total variation.

## Results

<p align="center">
  <img src="https://github.com/Idawid/Matlab/blob/main/ConvexOptimization/ProjectedGradientDescent/result.jpg" alt="Result Image">
</p>
