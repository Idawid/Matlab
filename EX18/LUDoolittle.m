function [L, U] = LUDoolittle(A)
%LUDOOLITTLE LU Decomposition using Doolittle's method
%   input: A is square, non-singular matrix.
%   output: matrices L, U. L is a lower triangular matrix, U is upper,
%   s.t. LU = A.

    [rows, cols] = size(A);
    if(rows~=cols)
        disp('Error using LUDoolittle');
        disp('Matrix is not square');
        return 
    end
    U = zeros(rows, cols);
    L = eye(rows);
    for i = 1:rows
        %Note that elements of A have several products and a free element,
        %which is always the element of the diagonal of U. The elements are
        %placed convienently s.t. if we subtract product of the same row
        %and column as the diagonal from diagonal element of A we get the
        %diagonal element of U. Example. Pick 3rd diag elem of U, subtract
        %3rd row * 3rd col from the 3rd diag elem of A.
        U(i, i) = A(i, i) - L(i, 1:i-1)*U(1:i-1, i);
        %stair pattern loop, if we want to access L elements we just swap i and
        %j indexes.
        for j = i+1:cols
            U(i, j) = A(i, j) - L(i , 1:i-1) * U(1:i-1, j);
            L(j, i) = (A(j, i) - L(j , 1:i-1) * U(1:i-1, i)) / U(i,i);
        end
    end
end