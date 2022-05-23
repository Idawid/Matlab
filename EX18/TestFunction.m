function [RES] = TestFunction()
%TESTFUNCTION compares my functions against matlab's implementations
%   LU decomposition is used primarily for calculating determinants and
%   solving linear systems.
%   
%   input: matrix A
%   output: RES = 
%           dr - relative determinant error,
%           a - biggest error of LU decomposition
%           ar - relative biggest error of LU decomposition
%           xra - relative error of Ax=b
%           xrm - relative error of Mx=f
%           ir - relative error of inv(A) using LU
%           
%           (relative to the biggest element of the relevant matrix)
d=0;dr=0;a=0;ar=0;xra=0;xrm=0;ir=0;
for i=1:100
%   generate random matrix
    minv = randi(1000) - 500;
    maxv = randi(1000) + 501;
    sizev = randi(40) + 10;
    A = randi([minv maxv], [sizev,sizev]);
%   test determinant errors
    testdet = abs(det(A) - detLU(A));
    d = max(d, testdet);
    dr = max(dr, testdet/det(A));
%   test if LU really equals A
    [L,U] = LUDoolittle(A);
    testa = max(abs(A - L * U), [], 'all');
    a = testa;
    ar = max(a / max(A(:)));

%   generate random vectors
    b = randi([-1000 1000],size(A,1),1);
    f = randi([-1000 1000],size(A,1)*2,1);
    
%   test Ax=b and Mx=f errors
    x1 = linsolve(A,b);
    x2 = linsolve(toM(A),f);
    xra = max(xra, max(linsolveLU(A,b) - x1, [], 'all') / max(x1(:)));
    xrm = max(xrm, max(linsolveMLU(A,f) - x2, [], 'all') / max(x2(:)));
%   test inv(A) errors
    invA = inv(A);
    invALU = inv(U) * inv(L);
    ia = max(abs(invA - invALU), [], 'all');
    ir = max(ir,ia / max(invA(:)));
end
RES = [dr, a, ar, xra, xrm, ir];
end

