% Let 𝑓(𝑥,𝑦,𝑧)=𝑥2+𝑐𝑜𝑠(𝑦)𝑦4+𝑠𝑖𝑛2(𝑦)𝑧4.
% Perform 100 iterations of gradient descent algorithm to minimize the function.
% Start from point (2,1,2).
% Display the values of function in graph where on OX axis are iteration numbers. 

f = @(x, y, z) x.^2 + cos(y)*y.^4 + (sin(z))^2*z.^4;

% derivative df/dx, df/dy, df/dz
grad_f = @(x, y, z) [2*x; (4*y^3)*(cos(y))-(y^4)*(sin(y)) + (z^4)*(2*sin(y)*cos(y)); (4*z^3)*(sin(y)^2)]; 

x0 = 2;
y0 = 1;
z0 = 2;
step_size = 0.1;

iterations = 1:100;
function_values = zeros(1, 100);

for i = 1:100
    gradient = grad_f(x0, y0, z0);

    x0 = x0 - step_size * gradient(1);
    y0 = y0 - step_size * gradient(2);
    z0 = z0 - step_size * gradient(3);
   
    function_values(i) = f(x0,y0,z0);
end

figure;
plot(iterations, function_values);
xlabel('iteration number');
ylabel('f value');