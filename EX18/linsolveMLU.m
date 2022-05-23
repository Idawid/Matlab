function [x] = linsolveMLU(A,f)
%LINSOLVELU Solves a system Mx = f, s.t. M =[I A; A' 0]
%   input: A is a square matrix, f is a vector with a corresponding
%   dimension.
%   output: vector x s.t. Mx = f.
%   NOTE: f HAS TO 2x BIGGER THAN A
%
%   Function uses LU decomposition with Doolittle's method.
%   M * x = f  resultant equations:
%   Ix1 + Ax2 = f1
%   A'x_1 = f2
%   calculate x_1, substitute to the first one.

    [rows,cols] = size(A);
    [vrows, vcols] = size(f);
    if 2*rows~=vrows
        disp('Error using LinsolveLU');
        disp('Matrix dimensions must agree.');
        return;
    end
    %solve the second equation using LU decomposition
    x1 = linsolveLU(A', f((vrows/2)+1:vrows));
    %solve the first equation using LU decomposition by substituting x1
    x2 = linsolveLU(A, f(1:vrows/2) - x1);
    %combine the result
    x = [x1;x2];
end

