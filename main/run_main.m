clear; close all; clc;

% ------------------ 参数设置 ------------------
x0 = 0.6;
r0 = 4;
z  = 0.6;
B  = 1e17;
a  = 5;
e  = 0.9;
p  = 13;
q  = 7;
main_key = 0.75;
mu = 4;

% 读取图像
addpath('..\img');
img = uint8(imread('4.2.06.tiff'));

M = size(img, 1);
N = size(img, 2);

rng(0);
x1 = rand(1, N);

% 预生成混沌序列和索引矩阵
seq = generate_chaos_01(x0, r0, M, N);
big_chaotic_matrix = CML(N, 5 * N, a, e, p, q, x1);
chaos_seq = generate_chaos_sequence(main_key, mu, 2 * M * (3 * N));
[im1, im2, im3] = Generate_index_matrix(N, a, e, p, q, x1, big_chaotic_matrix);

% 加密
C1 = z_encrypt(img, seq, z, B);
C2 = zhiluan(C1, im1, im2, im3);
[C, laplace_map] = kuosan(C2, main_key, mu, chaos_seq);

% 解密
P2 = ikuosan(C, main_key, mu, laplace_map, chaos_seq);
P1 = izhiluan(P2, im1, im2, im3);
P  = z_decrypt(P1, seq, z, B);

fprintf('无损恢复检查: %d\n', isequal(uint8(img), uint8(P)));

% 显示加密解密结果和直方图
show_encryption_figures(img, C, P);

function show_encryption_figures(plain, cipher, decrypted)
% 使用 imhist + bar 显示图像与 RGB 直方图

figure('Position', [100, 100, 1000, 800]);

subplot(3, 3, 1);
imshow(uint8(plain));
title('原始图像');

subplot(3, 3, 2);
plot_rgb_histogram(plain);
title('原始图像 RGB 直方图');

subplot(3, 3, 4);
imshow(uint8(cipher));
title('加密图像');

subplot(3, 3, 5);
plot_rgb_histogram(cipher);
title('加密图像 RGB 直方图');

subplot(3, 3, 7);
imshow(uint8(decrypted));
title('解密图像');

subplot(3, 3, 8);
plot_rgb_histogram(decrypted);
title('解密图像 RGB 直方图');
end

function plot_rgb_histogram(image_data)
[countR, bins] = imhist(uint8(image_data(:,:,1)));
[countG, ~] = imhist(uint8(image_data(:,:,2)));
[countB, ~] = imhist(uint8(image_data(:,:,3)));

bar(bins, countR, 'FaceColor', [1, 0.6, 0.6], ...
    'EdgeColor', [1, 0.6, 0.6], 'BarWidth', 1, 'FaceAlpha', 0.7); hold on;
bar(bins, countG, 'FaceColor', [0.6, 1, 0.6], ...
    'EdgeColor', [0.6, 1, 0.6], 'BarWidth', 1, 'FaceAlpha', 0.7);
bar(bins, countB, 'FaceColor', [0.6, 0.6, 1], ...
    'EdgeColor', [0.6, 0.6, 1], 'BarWidth', 1, 'FaceAlpha', 0.7); hold off;

xlim([0 255]);
ylim([0 max([max(countR), max(countG), max(countB)]) * 1.1]);
grid on;
xlabel('像素值');
ylabel('频数');
end
