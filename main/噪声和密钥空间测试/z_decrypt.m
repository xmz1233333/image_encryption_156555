% function decrypted_img = z_decrypt(encrypted_img, seq, z, BIG_NUMBER)
%     % 图像解密函数
%     % 输入:
%     %   encrypted_img - 加密后的图像
%     %   seq - 混沌序列矩阵，与图像同尺寸（必须与加密时相同）
%     %   z - 指数计算参数（必须与加密时相同）
%     %   BIG_NUMBER - 大数因子（必须与加密时相同）
%     % 输出:
%     %   decrypted_img - 解密后的图像
% 
%     [M, N] = size(encrypted_img);
%     decrypted_img = zeros(M, N, 'uint8');
% 
%     for i = 1:M
%         for j = 1:N
%             % 密文像素值
%             enc_pixel = double(encrypted_img(i, j));
%             % 混沌值
%             ck = seq(i, j);
%             % 计算扰动（必须与加密时相同）
%             exponent = ck;
%             t = z^(-exponent);
%             perturbation = mod(round(t * BIG_NUMBER), 256);
%             % 解密
%             dec_value = mod(enc_pixel - perturbation, 256);
%             decrypted_img(i, j) = uint8(dec_value);
%         end
%     end
% end


function decrypted_img = z_decrypt(encrypted_img, seq, z, BIG_NUMBER)
    % 彩色图像解密函数
    % 输入:
    %   encrypted_img - 加密后的彩色图像
    %   seq - 混沌序列矩阵（必须与加密时相同）
    %   z - 指数计算参数（必须与加密时相同）
    %   BIG_NUMBER - 大数因子（必须与加密时相同）
    % 输出:
    %   decrypted_img - 解密后的彩色图像
    
    [M, N, C] = size(encrypted_img);
    
    % 检查是否为彩色图像
    if C ~= 3
        error('输入必须是彩色图像（3个通道）');
    end
    
    decrypted_img = zeros(M, N, C);
    
    % 对每个颜色通道分别解密
    for ch = 1:C
        for i = 1:M
            for j = 1:N
                % 密文像素值
                enc_pixel = double(encrypted_img(i, j, ch));
                % 混沌值
                ck = seq(i, j);
                % 计算扰动（必须与加密时相同）
                exponent = ck;
                t = z^(-exponent);
                perturbation = mod(round(t * BIG_NUMBER), 256);
                % 解密
                dec_value = mod(enc_pixel - perturbation, 256);
                decrypted_img(i, j, ch) = dec_value;
            end
        end
    end
end

