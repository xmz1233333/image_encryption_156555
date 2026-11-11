function [scrambled_rgb] = zhiluan(img,index_matrix1,index_matrix2,index_matrix3)

  [H, W, C] = size(img);
  imgR = img(:,:,1);
  imgG = img(:,:,2);
  imgB = img(:,:,3);
  N=H;
  % 初始化置乱后的图像
scrambled_R = zeros(N, N);
scrambled_G = zeros(N, N);
scrambled_B = zeros(N, N);

% 遍历每个位置
for i = 1:N
    for j = 1:N
        target_i1 = index_matrix1(i,j,1);  % 列排序索引
        target_j1 = index_matrix1(i,j,2);  % 行排序索引
        target_i2 = index_matrix2(i,j,1);
        target_j2 = index_matrix2(i,j,2);
        target_i3 = index_matrix3(i,j,1);
        target_j3 = index_matrix3(i,j,2);
        % 获取当前位置三个索引矩阵的第三个数据
        third_val1 = index_matrix1(i,j,3);  % 对应R通道的索引矩阵
        third_val2 = index_matrix2(i,j,3);  % 对应G通道的索引矩阵  
        third_val3 = index_matrix3(i,j,3);  % 对应B通道的索引矩阵
        
        % 根据第三个数据的值决定像素值的来源
        % R通道置乱
        switch third_val1
            case 1
                scrambled_R(target_i1,target_j1) = imgR(i,j);  % 保持原R通道
            case 2
                scrambled_R(target_i1,target_j1) = imgG(i,j);  % 使用G通道
            case 3
                scrambled_R(target_i1,target_j1) = imgB(i,j);  % 使用B通道
        end
        
        % G通道置乱
        switch third_val2
            case 1
                scrambled_G(target_i2,target_j2) = imgR(i,j);  % 使用R通道
            case 2
                scrambled_G(target_i2,target_j2)  = imgG(i,j);  % 保持原G通道
            case 3
                scrambled_G(target_i2,target_j2)  = imgB(i,j);  % 使用B通道
        end
        
        % B通道置乱
        switch third_val3
            case 1
                scrambled_B(target_i3,target_j3) = imgR(i,j);  % 使用R通道
            case 2
                scrambled_B(target_i3,target_j3) = imgG(i,j);  % 使用G通道
            case 3
                scrambled_B(target_i3,target_j3) = imgB(i,j);  % 保持原B通道
        end
    end
end

% 组合置乱后的RGB图像
scrambled_rgb = cat(3, scrambled_R, scrambled_G, scrambled_B);

end

