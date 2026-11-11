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
%img = uint8(imread('4.1.04.tiff')); %%256
img = uint8(imread('4.2.06.tiff')); %%512
M = size(img, 1);
N = size(img, 2);

rng(0);
x1 = rand(1, N);

seq = generate_chaos_01(x0, r0, M, N);
big_chaotic_matrix = CML(N, 5 * N, a, e, p, q, x1);
chaos_seq = generate_chaos_sequence(main_key, mu, 2 * M * (3 * N));
[im1, im2, im3] = Generate_index_matrix(N, a, e, p, q, x1, big_chaotic_matrix);

tic;
C1 = z_encrypt(img, seq, z, B);
C2 = zhiluan(C1, im1, im2, im3);
[C, laplace_map] = kuosan(C2, main_key, mu, chaos_seq);
enc_time = toc;

throughput_Mbps = (M * N * 3 * 8) / enc_time / 1e6;

fprintf('\n速度测试结果:\n');
fprintf('  图像尺寸:   %d x %d x 3\n', M, N);
fprintf('  加密时间:   %.4f s\n', enc_time);
fprintf('  吞吐量:     %.2f Mbit/s\n', throughput_Mbps);