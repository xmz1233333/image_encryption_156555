clear; close all; clc;

% 参数设置
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

addpath('..\img');
img = uint8(imread('2.1.01.tiff'));
M = size(img, 1);
N = size(img, 2);

rng(0);
x1 = rand(1, N);

seq = generate_chaos_01(x0, r0, M, N);
big_chaotic_matrix = CML(N, 5 * N, a, e, p, q, x1);
chaos_seq = generate_chaos_sequence(main_key, mu, 2 * M * (3 * N));
[im1, im2, im3] = Generate_index_matrix(N, a, e, p, q, x1, big_chaotic_matrix);

% 第一个像素加 1，构造仅一个像素不同的图像
img1 = img;
img2 = img;
old_value = img1(1, 1, :);
new_value = mod(old_value + 1, 255);
img2(1, 1, 1) = new_value(1);
img2(1, 1, 2) = new_value(2);
img2(1, 1, 3) = new_value(3);

% 加密两幅图像
C1_1 = z_encrypt(img1, seq, z, B);
C2_1 = zhiluan(C1_1, im1, im2, im3);
[E1, laplace_map1] = kuosan(C2_1, main_key, mu, chaos_seq);

C1_2 = z_encrypt(img2, seq, z, B);
C2_2 = zhiluan(C1_2, im1, im2, im3);
[E2, laplace_map2] = kuosan(C2_2, main_key, mu, chaos_seq);

E1 = uint8(E1);
E2 = uint8(E2);

total_pixels = M * N;
npcrs = zeros(1, 3);
uacis = zeros(1, 3);

for ch = 1:3
    A = E1(:, :, ch);
    Bc = E2(:, :, ch);

    D = zeros(M, N);
    D(A ~= Bc) = 1;
    npcrs(ch) = sum(D(:)) / total_pixels * 100;

    diff = double(abs(int16(A) - int16(Bc)));
    uacis(ch) = sum(diff(:)) / (total_pixels * 255) * 100;
end

fprintf('\nNPCR/UACI 测试结果:\n');
fprintf('  NPCR: R=%.6f%%  G=%.6f%%  B=%.6f%%  平均=%.6f%%\n', ...
        npcrs(1), npcrs(2), npcrs(3), mean(npcrs));
fprintf('  UACI: R=%.6f%%  G=%.6f%%  B=%.6f%%  平均=%.6f%%\n', ...
        uacis(1), uacis(2), uacis(3), mean(uacis));
