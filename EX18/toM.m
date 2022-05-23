function [M] = toM(A)
%TOM computes M =[I A; A' 0]
%   input: square matrix A
%   output: matrix M
    [rows, cols] = size(A);
    M = [eye(rows, cols), A; A', zeros(rows, cols)];
end