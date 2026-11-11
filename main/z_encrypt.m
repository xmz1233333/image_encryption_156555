% function encrypted_img = z_encrypt(img, seq, z, BIG_NUMBER)
%     % 图像加密函数
%     % 输入:
%     %   img - 原始图像（灰度）
%     %   seq - 混沌序列矩阵，与图像同尺寸
%     %   z - 指数计算参数
%     %   BIG_NUMBER - 大数因子
%     % 输出:
%     %   encrypted_img - 加密后的图像
% 
%     [M, N] = size(img);
%     encrypted_img = zeros(M, N, 'uint8');
% 
%     for i = 1:M
%         for j = 1:N
%             % 原像素值
%             pixel = double(img(i, j));
%             % 混沌值
%             ck = seq(i, j);
%             % 计算扰动
%             exponent = ck;  % 直接用ck作为指数
%             t = z^(-exponent);
%             perturbation = mod(round(t * BIG_NUMBER), 256);
%             % 加密
%             enc_value = mod(pixel + perturbation, 256);
%             encrypted_img(i, j) = uint8(enc_value);
%         end
%     end
% end

function encrypted_img = z_encrypt(img, seq, z, BIG_NUMBER)
    % 彩色图像加密函数
    % 输入:
    %   img - 原始图像（彩色，M×N×3）
    %   seq - 混沌序列矩阵，与每个颜色通道同尺寸（M×N）
    %   z - 指数计算参数
    %   BIG_NUMBER - 大数因子
    % 输出:
    %   encrypted_img - 加密后的彩色图像
    
    [M, N, C] = size(img);
    
    % 检查是否为彩色图像
    if C ~= 3
        error('输入必须是彩色图像（3个通道）');
    end
    
    encrypted_img = zeros(M, N, C);
    
    % 对每个颜色通道分别加密
    for ch = 1:C
        for i = 1:M
            for j = 1:N
                % 原像素值
                pixel = double(img(i, j, ch));
                % 混沌值（每个通道使用相同的混沌序列）
                ck = seq(i, j);
                % 计算扰动
                exponent = ck;
                t = z^(-exponent);
               perturbation = mod(round(t * BIG_NUMBER), 256);
                % 加密
                enc_value = mod(pixel + perturbation, 256);
                encrypted_img(i, j, ch) = enc_value;
            end
        end
    end
end

