function det = detLU(A)
%DETLU Calculates determinant of a matrix
%   Function uses LU decomposition with Doolittle's method.
%   det(A) = det(L)*det(U)
%   det(L) is always 1, det(U) is multiplication of its diagonal elements
    [L,U] = LUDoolittle(A);
    det = prod(diag(U));
end

