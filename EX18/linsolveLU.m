function x = linsolveLU(M, f)
%LINSOLVELU Solves a system Ax = b
%   input: A is a square matrix, b is a vector with a corresponding
%   dimension.
%   output: vector x s.t. Ax = b.
%
%   Function uses LU decomposition with Doolittle's method.
%   LUx=b => Let Y=Ux, solves LY=b then solves Ux=Y
%   Both L and U are triangular matrices, so calculations are
%   straightforward.
    [rows,cols] = size(M);
    [vrows, vcols] = size(f);
    if rows~=vrows
        disp('Error using LinsolveLU');
        disp('Matrix dimensions must agree.');
        return;
    end
    [L,U] = LUDoolittle(M);
    y = zeros(rows,1);
    x = zeros(rows,1);
    %solve Ly=b
    y(1) = f(1) / L(1,1);
    for i = 2:rows
        y(i) = (f(i) - L(i,1:i-1) * y(1:i-1,1) ) / L(i,i);
    end
    %solve Ux=y
    x(rows)=y(rows) / U(rows,cols);
    for i=rows-1:-1:1
        x(i)=(y(i) - U(i,i+1:rows) * x(i+1:rows)) / U(i,i);
    end
end

