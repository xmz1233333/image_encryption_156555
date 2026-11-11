function [recovered_rgb] = izhiluan(scrambled_rgb,index_matrix1,index_matrix2,index_matrix3)
%IZHILUAN 此处显示有关此函数的摘要
    [H, W, C] = size(scrambled_rgb);
  N=H;
     scrambled_R = scrambled_rgb(:,:,1);
     scrambled_G = scrambled_rgb(:,:,2);
     scrambled_B = scrambled_rgb(:,:,3);
     % 初始化还原后的图像
recovered_R = zeros(N, N);
recovered_G = zeros(N, N);
recovered_B = zeros(N, N);

% 遍历每个位置进行还原
for i = 1:N
    for j = 1:N
        % 获取当前位置三个索引矩阵的目标位置和通道信息
        target_i1 = index_matrix1(i,j,1);  % R通道的目标行
        target_j1 = index_matrix1(i,j,2);  % R通道的目标列
        target_i2 = index_matrix2(i,j,1);  % G通道的目标行  
        target_j2 = index_matrix2(i,j,2);  % G通道的目标列
        target_i3 = index_matrix3(i,j,1);  % B通道的目标行
        target_j3 = index_matrix3(i,j,2);  % B通道的目标列
        
        % 获取通道来源信息
        third_val1 = index_matrix1(i,j,3);  % R通道的来源
        third_val2 = index_matrix2(i,j,3);  % G通道的来源  
        third_val3 = index_matrix3(i,j,3);  % B通道的来源
        
        % 根据来源信息还原R通道
        switch third_val1
            case 1
                recovered_R(i,j) = scrambled_R(target_i1,target_j1);  % 来自原R通道
            case 2
                recovered_G(i,j) = scrambled_R(target_i1,target_j1);  % 来自原G通道
            case 3
                recovered_B(i,j) = scrambled_R(target_i1,target_j1);  % 来自原B通道
        end
        
        % 根据来源信息还原G通道
        switch third_val2
            case 1
                recovered_R(i,j) = scrambled_G(target_i2,target_j2);  % 来自原R通道
            case 2
                recovered_G(i,j) = scrambled_G(target_i2,target_j2);  % 来自原G通道
            case 3
                recovered_B(i,j) = scrambled_G(target_i2,target_j2);  % 来自原B通道
        end
        
        % 根据来源信息还原B通道
        switch third_val3
            case 1
                recovered_R(i,j) = scrambled_B(target_i3,target_j3);  % 来自原R通道
            case 2
                recovered_G(i,j) = scrambled_B(target_i3,target_j3);  % 来自原G通道
            case 3
                recovered_B(i,j) = scrambled_B(target_i3,target_j3);  % 来自原B通道
        end

    end
end

%% 组合还原后的RGB图像
recovered_rgb = cat(3, recovered_R, recovered_G, recovered_B);
end

