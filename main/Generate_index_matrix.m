function [index_matrix1, index_matrix2, index_matrix3] = Generate_index_matrix(n, a, e, p, q, x1, big_chaotic_matrix)
%第 7 个可选参数 big_chaotic_matrix
% 如果传入预生成的混沌矩阵，则直接使用；否则内部生成

if nargin < 7 || isempty(big_chaotic_matrix)
    P = 5 * n;
    big_chaotic_matrix = CML(n, P, a, e, p, q, x1);
end

chaotic_matrix1 = big_chaotic_matrix(:, 1:n);
chaotic_matrix2 = big_chaotic_matrix(:, n+1:2*n);
chaotic_matrix3 = big_chaotic_matrix(:, 2*n+1:3*n);

element_sort_idx = zeros(n, n, 3);
for i = 1:n
    for j = 1:n
        elements = [chaotic_matrix1(i,j), chaotic_matrix2(i,j), chaotic_matrix3(i,j)];
        [~, sort_idx] = sort(elements);
        element_sort_idx(i,j,:) = sort_idx;
    end
end

index_matrix1 = zeros(n, n, 3);
index_matrix2 = zeros(n, n, 3);
index_matrix3 = zeros(n, n, 3);

% --- 索引矩阵 1 ---
flat_grad1 = chaotic_matrix1(:);
[~, sorted_grad_indices1] = sort(flat_grad1);
for idx = 1:length(sorted_grad_indices1)
    grad_idx1 = sorted_grad_indices1(idx);
    i = ceil(grad_idx1 / n);
    j = mod(grad_idx1 - 1, n) + 1;
    target_i = ceil(idx / n);
    target_j = mod(idx - 1, n) + 1;
    index_matrix1(target_i, target_j, :) = [i, j, element_sort_idx(target_i, target_j, 1)];
end

% --- 索引矩阵 2 ---
flat_grad2 = chaotic_matrix2(:);
[~, sorted_grad_indices2] = sort(flat_grad2);
for idx = 1:length(sorted_grad_indices2)
    grad_idx2 = sorted_grad_indices2(idx);
    i = ceil(grad_idx2 / n);
    j = mod(grad_idx2 - 1, n) + 1;
    target_i = ceil(idx / n);
    target_j = mod(idx - 1, n) + 1;
    index_matrix2(target_i, target_j, :) = [i, j, element_sort_idx(target_i, target_j, 2)];
end

% --- 索引矩阵 3 ---
flat_grad3 = chaotic_matrix3(:);
[~, sorted_grad_indices3] = sort(flat_grad3);
for idx = 1:length(sorted_grad_indices3)
    grad_idx3 = sorted_grad_indices3(idx);
    i = ceil(grad_idx3 / n);
    j = mod(grad_idx3 - 1, n) + 1;
    target_i = ceil(idx / n);
    target_j = mod(idx - 1, n) + 1;
    index_matrix3(target_i, target_j, :) = [i, j, element_sort_idx(target_i, target_j, 3)];
end

end