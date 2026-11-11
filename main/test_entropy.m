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
mu = 4.6;

addpath('..\img');
img = uint8(imread('4.2.06.tiff'));
M = size(img, 1);
N = size(img, 2);

rng(0);
x1 = rand(1, N);

seq = generate_chaos_01(x0, r0, M, N);
big_chaotic_matrix = CML(N, 5 * N, a, e, p, q, x1);
chaos_seq = generate_chaos_sequence(main_key, mu, 2 * M * (3 * N));
[im1, im2, im3] = Generate_index_matrix(N, a, e, p, q, x1, big_chaotic_matrix);

C1 = z_encrypt(img, seq, z, B);
C2 = zhiluan(C1, im1, im2, im3);
[C, laplace_map] = kuosan(C2, main_key, mu, chaos_seq);

plain_entropy = zeros(1, 3);
cipher_entropy = zeros(1, 3);

for ch = 1:3
    plain_entropy(ch) = channel_entropy(img(:, :, ch));
    cipher_entropy(ch) = channel_entropy(uint8(C(:, :, ch)));
end

fprintf('\n信息熵测试结果:\n');
fprintf('  明文 R 通道: %.6f\n', plain_entropy(1));
fprintf('  明文 G 通道: %.6f\n', plain_entropy(2));
fprintf('  明文 B 通道: %.6f\n', plain_entropy(3));
fprintf('  明文平均:     %.6f\n', mean(plain_entropy));
fprintf('  密文 R 通道: %.6f\n', cipher_entropy(1));
fprintf('  密文 G 通道: %.6f\n', cipher_entropy(2));
fprintf('  密文 B 通道: %.6f\n', cipher_entropy(3));
fprintf('  密文平均:     %.6f\n', mean(cipher_entropy));

function ent = channel_entropy(channel_data)
[counts, ~] = histcounts(channel_data(:), 0:256);
prob = counts / numel(channel_data);
prob = prob(prob > 0);
ent = -sum(prob .* log2(prob));
end
