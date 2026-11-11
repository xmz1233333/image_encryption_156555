clear; close all; clc;

addpath('..\img');

% Step 1: 读取图像
img = imread("4.2.06.tiff");
[M, N, ~] = size(img);
fprintf('图像尺寸: %d x %d\n', M, N);

% Step 2: 生成混沌序列
x0 = 0.6;
r = 4;
seq = generate_chaos_01(x0, r, M, N);

% Step 3: 加密参数
z = 0.6;
BIG_NUMBER = 1e17;

n = N;
a = 5;
e = 0.9;
p = 13;
q = 7;
rng(0);
x1 = rand(1, n);

main_key = 0.75;
mu = 4.6;

% 新加密步骤：预生成混沌矩阵和扩散序列
big_chaotic_matrix = CML(N, 5 * N, a, e, p, q, x1);
chaos_seq = generate_chaos_sequence(main_key, mu, 2 * M * (3 * N));
[index_matrix1, index_matrix2, index_matrix3] = ...
    Generate_index_matrix(n, a, e, p, q, x1, big_chaotic_matrix);

C1 = z_encrypt(img, seq, z, BIG_NUMBER);
C2 = zhiluan(C1, index_matrix1, index_matrix2, index_matrix3);
[C, laplace_map] = kuosan(C2, main_key, mu, chaos_seq);

%% ========== 图像的相关系数分析 ==========
I_plain = uint8(img);
J_plain = double(I_plain);
RP_plain = J_plain(:,:,1); GP_plain = J_plain(:,:,2); BP_plain = J_plain(:,:,3);

I_cipher = uint8(C);
J_cipher = double(I_cipher);
RP_cipher = J_cipher(:,:,1); GP_cipher = J_cipher(:,:,2); BP_cipher = J_cipher(:,:,3);

file_plain_h = 'plain_horizontal.png';
file_plain_v = 'plain_vertical.png';
file_plain_d = 'plain_diagonal.png';
file_cipher_h = 'cipher_horizontal.png';
file_cipher_v = 'cipher_vertical.png';
file_cipher_d = 'cipher_diagonal.png';

num_pairs = min(10000, floor((M - 1) * (N - 1) / 4));
step_row = floor(M / 200);
step_col = floor(N / 200);
if step_row < 1, step_row = 1; end
if step_col < 1, step_col = 1; end

pxhr_plain = zeros(1, num_pairs); pyhr_plain = zeros(1, num_pairs);
pxhg_plain = zeros(1, num_pairs); pyhg_plain = zeros(1, num_pairs);
pxhb_plain = zeros(1, num_pairs); pyhb_plain = zeros(1, num_pairs);

pxvr_plain = zeros(1, num_pairs); pyvr_plain = zeros(1, num_pairs);
pxvg_plain = zeros(1, num_pairs); pyvg_plain = zeros(1, num_pairs);
pxvb_plain = zeros(1, num_pairs); pyvb_plain = zeros(1, num_pairs);

pxdr_plain = zeros(1, num_pairs); pydr_plain = zeros(1, num_pairs);
pxdg_plain = zeros(1, num_pairs); pydg_plain = zeros(1, num_pairs);
pxdb_plain = zeros(1, num_pairs); pydb_plain = zeros(1, num_pairs);

pxhr_cipher = zeros(1, num_pairs); pyhr_cipher = zeros(1, num_pairs);
pxhg_cipher = zeros(1, num_pairs); pyhg_cipher = zeros(1, num_pairs);
pxhb_cipher = zeros(1, num_pairs); pyhb_cipher = zeros(1, num_pairs);

pxvr_cipher = zeros(1, num_pairs); pyvr_cipher = zeros(1, num_pairs);
pxvg_cipher = zeros(1, num_pairs); pyvg_cipher = zeros(1, num_pairs);
pxvb_cipher = zeros(1, num_pairs); pyvb_cipher = zeros(1, num_pairs);

pxdr_cipher = zeros(1, num_pairs); pydr_cipher = zeros(1, num_pairs);
pxdg_cipher = zeros(1, num_pairs); pydg_cipher = zeros(1, num_pairs);
pxdb_cipher = zeros(1, num_pairs); pydb_cipher = zeros(1, num_pairs);

k = 1;
for i = 1:step_row:(M - 1)
    if k > num_pairs, break; end
    for j = 1:step_col:(N - 1)
        if k > num_pairs, break; end

        pxhr_plain(k) = RP_plain(i, j); pyhr_plain(k) = RP_plain(i + 1, j);
        pxhg_plain(k) = GP_plain(i, j); pyhg_plain(k) = GP_plain(i + 1, j);
        pxhb_plain(k) = BP_plain(i, j); pyhb_plain(k) = BP_plain(i + 1, j);

        pxvr_plain(k) = RP_plain(i, j); pyvr_plain(k) = RP_plain(i, j + 1);
        pxvg_plain(k) = GP_plain(i, j); pyvg_plain(k) = GP_plain(i, j + 1);
        pxvb_plain(k) = BP_plain(i, j); pyvb_plain(k) = BP_plain(i, j + 1);

        pxdr_plain(k) = RP_plain(i, j); pydr_plain(k) = RP_plain(i + 1, j + 1);
        pxdg_plain(k) = GP_plain(i, j); pydg_plain(k) = GP_plain(i + 1, j + 1);
        pxdb_plain(k) = BP_plain(i, j); pydb_plain(k) = BP_plain(i + 1, j + 1);

        pxhr_cipher(k) = RP_cipher(i, j); pyhr_cipher(k) = RP_cipher(i + 1, j);
        pxhg_cipher(k) = GP_cipher(i, j); pyhg_cipher(k) = GP_cipher(i + 1, j);
        pxhb_cipher(k) = BP_cipher(i, j); pyhb_cipher(k) = BP_cipher(i + 1, j);

        pxvr_cipher(k) = RP_cipher(i, j); pyvr_cipher(k) = RP_cipher(i, j + 1);
        pxvg_cipher(k) = GP_cipher(i, j); pyvg_cipher(k) = GP_cipher(i, j + 1);
        pxvb_cipher(k) = BP_cipher(i, j); pyvb_cipher(k) = BP_cipher(i, j + 1);

        pxdr_cipher(k) = RP_cipher(i, j); pydr_cipher(k) = RP_cipher(i + 1, j + 1);
        pxdg_cipher(k) = GP_cipher(i, j); pydg_cipher(k) = GP_cipher(i + 1, j + 1);
        pxdb_cipher(k) = BP_cipher(i, j); pydb_cipher(k) = BP_cipher(i + 1, j + 1);

        k = k + 1;
    end
end

actual_pairs = k - 1;

pxhr_plain = pxhr_plain(1:actual_pairs); pyhr_plain = pyhr_plain(1:actual_pairs);
pxhg_plain = pxhg_plain(1:actual_pairs); pyhg_plain = pyhg_plain(1:actual_pairs);
pxhb_plain = pxhb_plain(1:actual_pairs); pyhb_plain = pyhb_plain(1:actual_pairs);

pxvr_plain = pxvr_plain(1:actual_pairs); pyvr_plain = pyvr_plain(1:actual_pairs);
pxvg_plain = pxvg_plain(1:actual_pairs); pyvg_plain = pyvg_plain(1:actual_pairs);
pxvb_plain = pxvb_plain(1:actual_pairs); pyvb_plain = pyvb_plain(1:actual_pairs);

pxdr_plain = pxdr_plain(1:actual_pairs); pydr_plain = pydr_plain(1:actual_pairs);
pxdg_plain = pxdg_plain(1:actual_pairs); pydg_plain = pydg_plain(1:actual_pairs);
pxdb_plain = pxdb_plain(1:actual_pairs); pydb_plain = pydb_plain(1:actual_pairs);

pxhr_cipher = pxhr_cipher(1:actual_pairs); pyhr_cipher = pyhr_cipher(1:actual_pairs);
pxhg_cipher = pxhg_cipher(1:actual_pairs); pyhg_cipher = pyhg_cipher(1:actual_pairs);
pxhb_cipher = pxhb_cipher(1:actual_pairs); pyhb_cipher = pyhb_cipher(1:actual_pairs);

pxvr_cipher = pxvr_cipher(1:actual_pairs); pyvr_cipher = pyvr_cipher(1:actual_pairs);
pxvg_cipher = pxvg_cipher(1:actual_pairs); pyvg_cipher = pyvg_cipher(1:actual_pairs);
pxvb_cipher = pxvb_cipher(1:actual_pairs); pyvb_cipher = pyvb_cipher(1:actual_pairs);

pxdr_cipher = pxdr_cipher(1:actual_pairs); pydr_cipher = pydr_cipher(1:actual_pairs);
pxdg_cipher = pxdg_cipher(1:actual_pairs); pydg_cipher = pydg_cipher(1:actual_pairs);
pxdb_cipher = pxdb_cipher(1:actual_pairs); pydb_cipher = pydb_cipher(1:actual_pairs);

%% 计算相关系数并显示
fprintf('\n=== RGB通道像素相关性分析结果 ===\n');

fprintf('\n明文图像相关系数:\n');
corr_hr_plain = corrcoef(pxhr_plain, pyhr_plain);
corr_hg_plain = corrcoef(pxhg_plain, pyhg_plain);
corr_hb_plain = corrcoef(pxhb_plain, pyhb_plain);
fprintf('  水平方向: R=%.4f, G=%.4f, B=%.4f\n', ...
    corr_hr_plain(1,2), corr_hg_plain(1,2), corr_hb_plain(1,2));

corr_vr_plain = corrcoef(pxvr_plain, pyvr_plain);
corr_vg_plain = corrcoef(pxvg_plain, pyvg_plain);
corr_vb_plain = corrcoef(pxvb_plain, pyvb_plain);
fprintf('  垂直方向: R=%.4f, G=%.4f, B=%.4f\n', ...
    corr_vr_plain(1,2), corr_vg_plain(1,2), corr_vb_plain(1,2));

corr_dr_plain = corrcoef(pxdr_plain, pydr_plain);
corr_dg_plain = corrcoef(pxdg_plain, pydg_plain);
corr_db_plain = corrcoef(pxdb_plain, pydb_plain);
fprintf('  对角线方向: R=%.4f, G=%.4f, B=%.4f\n', ...
    corr_dr_plain(1,2), corr_dg_plain(1,2), corr_db_plain(1,2));

fprintf('\n密文图像相关系数:\n');
corr_hr_cipher = corrcoef(pxhr_cipher, pyhr_cipher);
corr_hg_cipher = corrcoef(pxhg_cipher, pyhg_cipher);
corr_hb_cipher = corrcoef(pxhb_cipher, pyhb_cipher);
fprintf('  水平方向: R=%.6f, G=%.6f, B=%.6f\n', ...
    corr_hr_cipher(1,2), corr_hg_cipher(1,2), corr_hb_cipher(1,2));

corr_vr_cipher = corrcoef(pxvr_cipher, pyvr_cipher);
corr_vg_cipher = corrcoef(pxvg_cipher, pyvg_cipher);
corr_vb_cipher = corrcoef(pxvb_cipher, pyvb_cipher);
fprintf('  垂直方向: R=%.6f, G=%.6f, B=%.6f\n', ...
    corr_vr_cipher(1,2), corr_vg_cipher(1,2), corr_vb_cipher(1,2));

corr_dr_cipher = corrcoef(pxdr_cipher, pydr_cipher);
corr_dg_cipher = corrcoef(pxdg_cipher, pydg_cipher);
corr_db_cipher = corrcoef(pxdb_cipher, pydb_cipher);
fprintf('  对角线方向: R=%.6f, G=%.6f, B=%.6f\n', ...
    corr_dr_cipher(1,2), corr_dg_cipher(1,2), corr_db_cipher(1,2));

%% 画图 - 明文图像
zzz = zeros(1, actual_pairs);
zzz1 = 250 * ones(1, actual_pairs);
zzz2 = 500 * ones(1, actual_pairs);

figure(1);
set(0, 'defaultfigurecolor', 'w');
plot3(zzz, pxhr_plain, pyhr_plain, '.r', ...
      zzz1, pxhg_plain, pyhg_plain, '.g', ...
      zzz2, pxhb_plain, pyhb_plain, '.b');
grid on;
set(gca, 'looseInset', [0 0.08 0.03 0.03]);
set(gcf, 'unit', 'centimeters', 'position', [3 5 15 12]);
set(gca, 'xtick', 0:0:0, 'Ylim', [0 255], 'Zlim', [0 255], 'ytick', 0:50:255);
set(get(gca, 'xlabel'), 'Rotation', 16, 'Position', [125, -30, 0], 'FontSize', 10);
set(get(gca, 'ylabel'), 'Rotation', -23, 'Position', [-85, 75, 0]);
set(gca, 'FontName', 'Times New Roma');
set(gca, 'FontWeight', 'bold');
print(file_plain_h, '-r300', '-dpng');

figure(2);
plot3(zzz, pxvr_plain, pyvr_plain, '.r', ...
      zzz1, pxvg_plain, pyvg_plain, '.g', ...
      zzz2, pxvb_plain, pyvb_plain, '.b');
grid on;
set(gca, 'looseInset', [0 0.08 0.03 0.03]);
set(gcf, 'unit', 'centimeters', 'position', [3 5 15 12]);
set(gca, 'xtick', 0:0:0, 'Ylim', [0 255], 'Zlim', [0 255], 'ytick', 0:50:255);
set(get(gca, 'xlabel'), 'Rotation', 16, 'Position', [125, -30, 0], 'FontSize', 10);
set(get(gca, 'ylabel'), 'Rotation', -23, 'Position', [-85, 75, 0]);
set(gca, 'FontName', 'Times New Roma');
set(gca, 'FontWeight', 'bold');
print(file_plain_v, '-r300', '-dpng');

figure(3);
plot3(zzz, pxdr_plain, pydr_plain, '.r', ...
      zzz1, pxdg_plain, pydg_plain, '.g', ...
      zzz2, pxdb_plain, pydb_plain, '.b');
grid on;
set(gca, 'looseInset', [0 0.08 0.03 0.03]);
set(gcf, 'unit', 'centimeters', 'position', [3 5 15 12]);
set(gca, 'xtick', 0:0:0, 'Ylim', [0 255], 'Zlim', [0 255], 'ytick', 0:50:255);
set(get(gca, 'xlabel'), 'Rotation', 16, 'Position', [125, -30, 0], 'FontSize', 10);
set(get(gca, 'ylabel'), 'Rotation', -23, 'Position', [-85, 75, 0]);
set(gca, 'FontName', 'Times New Roma');
set(gca, 'FontWeight', 'bold');
print(file_plain_d, '-r300', '-dpng');

%% 画图 - 密文图像
figure(4);
plot3(zzz, pxhr_cipher, pyhr_cipher, '.r', ...
      zzz1, pxhg_cipher, pyhg_cipher, '.g', ...
      zzz2, pxhb_cipher, pyhb_cipher, '.b');
grid on;
set(gca, 'looseInset', [0 0.08 0.03 0.03]);
set(gcf, 'unit', 'centimeters', 'position', [3 5 15 12]);
set(gca, 'xtick', 0:0:0, 'Ylim', [0 255], 'Zlim', [0 255], 'ytick', 0:50:255);
set(get(gca, 'xlabel'), 'Rotation', 16, 'Position', [125, -30, 0], 'FontSize', 10);
set(get(gca, 'ylabel'), 'Rotation', -23, 'Position', [-85, 75, 0]);
set(gca, 'FontName', 'Times New Roma');
set(gca, 'FontWeight', 'bold');
print(file_cipher_h, '-r300', '-dpng');

figure(5);
plot3(zzz, pxvr_cipher, pyvr_cipher, '.r', ...
      zzz1, pxvg_cipher, pyvg_cipher, '.g', ...
      zzz2, pxvb_cipher, pyvb_cipher, '.b');
grid on;
set(gca, 'looseInset', [0 0.08 0.03 0.03]);
set(gcf, 'unit', 'centimeters', 'position', [3 5 15 12]);
set(gca, 'xtick', 0:0:0, 'Ylim', [0 255], 'Zlim', [0 255], 'ytick', 0:50:255);
set(get(gca, 'xlabel'), 'Rotation', 16, 'Position', [125, -30, 0], 'FontSize', 10);
set(get(gca, 'ylabel'), 'Rotation', -23, 'Position', [-85, 75, 0]);
set(gca, 'FontName', 'Times New Roma');
set(gca, 'FontWeight', 'bold');
print(file_cipher_v, '-r300', '-dpng');

figure(6);
plot3(zzz, pxdr_cipher, pydr_cipher, '.r', ...
      zzz1, pxdg_cipher, pydg_cipher, '.g', ...
      zzz2, pxdb_cipher, pydb_cipher, '.b');
grid on;
set(gca, 'looseInset', [0 0.08 0.03 0.03]);
set(gcf, 'unit', 'centimeters', 'position', [3 5 15 12]);
set(gca, 'xtick', 0:0:0, 'Ylim', [0 255], 'Zlim', [0 255], 'ytick', 0:50:255);
set(get(gca, 'xlabel'), 'Rotation', 16, 'Position', [125, -30, 0], 'FontSize', 10);
set(get(gca, 'ylabel'), 'Rotation', -23, 'Position', [-85, 75, 0]);
set(gca, 'FontName', 'Times New Roma');
set(gca, 'FontWeight', 'bold');
print(file_cipher_d, '-r300', '-dpng');
