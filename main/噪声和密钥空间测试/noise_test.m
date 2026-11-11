clc; clear; close all;
addpath('..\..\img');
% Step 1: 读取图像
img = imread("2.1.02.tiff");  % 测试用小图像
 %img = imread("4.2.06.tiff");  % 测试用小图像
%img = imread("lena.tiff");  
[M, N,C] = size(img);
fprintf('图像尺寸: %d x %d\n', M, N);
n=N;
a=5;
e=0.9;
p=13;
q=7;
rng(0); % 设置随机数种子
x1 = rand(1, n);   % 初始化 x1，长度为 N 的随机行向量
% Step 2: 生成混沌序列
x0 = 0.6;
r =4;
seq = generate_chaos_01(x0, r, M, N);
% Step 3: 加密参数
z = 0.6;
BIG_NUMBER = 1e17;  % 大数因子
%% Step 4: z加密
C1 = z_encrypt(img, seq, z, BIG_NUMBER);
%% Step 5: 对图像进行置乱
%[index_matrix1, index_matrix2, index_matrix3] = Generate_index_matrix(N);
[index_matrix1, index_matrix2, index_matrix3]=Generate_index_matrix(n,a,e,p,q,x1);
C2=zhiluan(C1,index_matrix1,index_matrix2,index_matrix3);
%% Step 6: 对图像进行扩散
main_key = 0.75;
mu=4.6;
[C,laplace_map] = kuosan(C2,main_key,mu);

% %%     ========== 正常解密过程 ==========  
% %% Step 7: 对图像进行解扩散
% P2 = ikuosan(C,main_key,mu,laplace_map);
%   %% Step 8: 对图像进行逆置乱
% P1=izhiluan(P2,index_matrix1,index_matrix2,index_matrix3);
%   %% Step 9: 对图像进行逆z
% P = z_decrypt(P1, seq, z, BIG_NUMBER);
% %% 正常解密结果
% % 显示原始彩色图像
% figure(1);
% subplot(2,2,1);
% imshow(uint8(img));
% title('原始彩色图像');
% 
% % 显示加密后的彩色图像
% subplot(2,2,2);
% encrypted_img = uint8(C);
% imshow(encrypted_img);
% title('Z变换加密后的彩色图像');
% 
% % 显示解密后的彩色图像
% subplot(2,2,3);
% decrypted_img = uint8(P);
% imshow(decrypted_img);
% title('解密后的彩色图像');
% 
% % 蓝色通道
% [b_row, b_col] = find(t3(:,:,3) ~= 0);
% fprintf('蓝色通道差异: %d 个位置\n', length(b_row));
% % 显示差异
% subplot(2,2,4);
% difference = double(decrypted_img) - double(img);
% % 将差异可视化（放大差异以便观察）
% imshow(uint8(abs(difference) * 10)); % 放大10倍以便观察小差异
% title('差异图像（放大10倍）');

%% 噪声攻击测试（在正常解密步骤之前添加）
CC=double(imnoise(uint8(C),'salt & pepper',0.1)); %椒盐噪声
PP2 = ikuosan(CC, main_key, mu, laplace_map);
PP1 = izhiluan(PP2, index_matrix1, index_matrix2, index_matrix3);
PP= z_decrypt(PP1, seq, z, BIG_NUMBER);

figure(2);
imshow(uint8(PP));

% Step 5: 计算PSNR
% 转换为uint8用于PSNR计算
original_img_uint8 = uint8(img);
decrypted_noisy_uint8 = uint8(PP);

%计算PSNR
psnr_noisy = psnr(decrypted_noisy_uint8, original_img_uint8);


fprintf('========== PSNR 计算结果 ==========\n');
fprintf('无噪声解密图像的PSNR: %.4f dB\n', psnr_noisy);
ssim_noisy = ssim(decrypted_noisy_uint8, original_img_uint8);
fprintf('无噪声解密图像的SSIM: %.4f\n', ssim_noisy);
fprintf('====================================\n');



% % ========== 裁剪攻击测试 ==========
% % 定义裁剪尺寸
% crop_sizes = [64, 64; 128, 128; 256, 256; 256, 512];
% crop_names = {'64×64', '128×128', '256×256', '256×512 (上半部)'};
% 
% % 创建图形窗口进行裁剪攻击测试
% figure(2);
% set(gcf, 'Name', '裁剪攻击测试', 'Position', [100, 100, 1400, 800]);
% 
% % 存储解密结果用于PSNR计算
% decrypted_images = cell(1, 4);
% psnr_values = zeros(1, 4);
% ssim_values = zeros(1, 4);
% 
% for k = 1:4
%     crop_h = crop_sizes(k, 1);
%     crop_w = crop_sizes(k, 2);
% 
%     % 复制密文图像
%     C_cropped = C;
% 
%     % 执行裁剪攻击
%     if k == 4  % 256×512 裁剪上半部
%         C_cropped(1:crop_h, :, :) = 0;  % 将上半部分全部置0
%     else  % 其他尺寸在左上角裁剪
%         C_cropped(1:crop_h, 1:crop_w, :) = 0;
%     end
% 
%     % 解密被裁剪的密文
%     % 解扩散
%     P2_cropped = ikuosan(C_cropped, main_key, mu, laplace_map);
%     % 逆置乱
%     P1_cropped = izhiluan(P2_cropped, index_matrix1, index_matrix2, index_matrix3);
%     % 逆z加密
%     P_cropped = z_decrypt(P1_cropped, seq, z, BIG_NUMBER);
% 
%     decrypted_images{k} = uint8(P_cropped);
% 
%     % 计算PSNR
%     psnr_values(k) = psnr(decrypted_images{k}, uint8(img));
%     ssim_values(k) = ssim(decrypted_images{k}, uint8(img));
% 
%     % 第一行：裁剪后的密文
%     subplot(2, 4, k);
%     % 创建可视化用的裁剪后密文
%     C_vis = uint8(C_cropped);
%     imshow(C_vis);
%   %  title(sprintf('裁剪后密文 (%s)', crop_names{k}));
% 
%     % 第二行：对应的解密图像
%     subplot(2, 4, k+4);
%     imshow(decrypted_images{k});
%     %title(sprintf('解密图像 (PSNR: %.2f dB)', psnr_values(k)));
% end
% 
% % 输出PSNR结果
% fprintf('\n========== 裁剪攻击PSNR/SSIM计算结果 ==========\n');
% for k = 1:4
%     fprintf('裁剪尺寸 %-15s: PSNR = %.4f dB, SSIM = %.4f\n', crop_names{k}, psnr_values(k), ssim_values(k));
% end
% fprintf('==========================================\n');

% %% 可选：显示原始图像和完整解密图像作为对比
% figure(3);
% set(gcf, 'Name', '原始图像与完整解密对比', 'Position', [100, 100, 1000, 400]);
% 
% % 完整解密（无攻击）
% P2_full = ikuosan(C, main_key, mu, laplace_map);
% P1_full = izhiluan(P2_full, index_matrix1, index_matrix2, index_matrix3);
% P_full = z_decrypt(P1_full, seq, z, BIG_NUMBER);
% psnr_full = psnr(uint8(P_full), uint8(img));
% 
% subplot(1, 3, 1);
% imshow(uint8(img));
% title('原始图像');
% 
% subplot(1, 3, 2);
% imshow(uint8(P_full));
% title(sprintf('完整解密图像\nPSNR: %.2f dB', psnr_full));
% 
% subplot(1, 3, 3);
% % 显示不同裁剪攻击的PSNR对比柱状图
% bar(1:4, psnr_values);
% set(gca, 'XTickLabel', crop_names);
% xlabel('裁剪尺寸');
% ylabel('PSNR (dB)');
% title('裁剪攻击PSNR对比');
% grid on;



function seq = generate_chaos_01(x0, r, M, N)
    % 生成混沌序列
    % 输入:
    %   x0 - 初始值
    %   r - 混沌参数
    %   M, N - 输出序列的尺寸
    % 输出:
    %   seq - M×N的混沌序列矩阵
    
    total = M * N;
    seq_length = total + 1000;  % 丢弃前1000个点
    seq_vector = zeros(seq_length, 1);
    seq_vector(1) = x0;

    for k = 2:seq_length
        seq_vector(k) = r * seq_vector(k-1) * (1 - seq_vector(k-1));
    end

    % 丢弃前1000个点
    seq_vector = seq_vector(1001:end);
    seq_vector = seq_vector(1:total);

    % 重塑为矩阵
    seq = reshape(seq_vector, [M, N]);
end