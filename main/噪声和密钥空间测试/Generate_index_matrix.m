function [index_matrix1, index_matrix2, index_matrix3] = Generate_index_matrix(n,a,e,p,q,x1)
%function [index_matrix1, index_matrix2, index_matrix3] = Generate_index_matrix(n)
% 生成三个基于混沌系统的索引矩阵
% 输入:
%   n - 矩阵大小 (n x n)
% 输出:
%   index_matrix1, index_matrix2, index_matrix3 - 三个索引矩阵，每个大小为 n x n x 3

% 生成三个混沌矩阵（确保充分混沌）
P = 5 * n;  % 更多迭代
%big_chaotic_matrix = CML_matrix(n, P);
big_chaotic_matrix=CML(n, P,a,e,p,q,x1);
chaotic_matrix1 = big_chaotic_matrix(:, 1:n);
chaotic_matrix2 = big_chaotic_matrix(:, n+1:2*n);
chaotic_matrix3 = big_chaotic_matrix(:, 2*n+1:3*n);

fprintf('=== 生成确保一一映射的索引矩阵 ===\n');

% 基于混沌矩阵的梯度方向创建索引矩阵
element_sort_idx = zeros(n, n, 3);
for i = 1:n
    for j = 1:n
        elements = [chaotic_matrix1(i,j), chaotic_matrix2(i,j), chaotic_matrix3(i,j)];
        [~, sort_idx] = sort(elements);
        element_sort_idx(i,j,:) = sort_idx;
    end
end

% 计算梯度
[grad_x1, grad_y1] = gradient(chaotic_matrix1);
[grad_x2, grad_y2] = gradient(chaotic_matrix2);
[grad_x3, grad_y3] = gradient(chaotic_matrix3);

% 计算梯度幅度
grad_magnitude1 = sqrt(grad_x1.^2 + grad_y1.^2);
grad_magnitude2 = sqrt(grad_x2.^2 + grad_y2.^2);
grad_magnitude3 = sqrt(grad_x3.^2 + grad_y3.^2);

% 初始化索引矩阵
index_matrix1 = zeros(n, n, 3);
index_matrix2 = zeros(n, n, 3);
index_matrix3 = zeros(n, n, 3);

%% 索引矩阵1
% 按梯度幅度排序，然后分配索引
%flat_grad1 = grad_magnitude1(:);
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

%% 索引矩阵2
%flat_grad2 = grad_magnitude2(:);
flat_grad2= chaotic_matrix2(:);
[~, sorted_grad_indices2] = sort(flat_grad2);

for idx = 1:length(sorted_grad_indices2)
    grad_idx2 = sorted_grad_indices2(idx);
    i = ceil(grad_idx2 / n);
    j = mod(grad_idx2 - 1, n) + 1;
    
    target_i = ceil(idx / n);
    target_j = mod(idx - 1, n) + 1;
    
    index_matrix2(target_i, target_j, :) = [i, j, element_sort_idx(target_i, target_j, 2)];
end

%% 索引矩阵3
%flat_grad3 = grad_magnitude3(:);
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
