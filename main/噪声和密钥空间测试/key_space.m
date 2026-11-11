clc; clear; close all;
addpath('.\img');
% Step 1: 读取图像
img = imread("2.1.01.tiff");  % 测试用小图像
%img = imread("4.2.06.tiff");  % 测试用小图像
%img = imread("lena.tiff");  
[M, N,~] = size(img);
fprintf('图像尺寸: %d x %d\n', M, N);

% Step 2: 生成混沌序列
x0 = 0.75;
r = 3.99;
seq = generate_chaos_01(x0, r, M, N);

% Step 3: 加密参数 
z = 0.5;
BIG_NUMBER = 1e17;  % 大数因子

%置乱密钥
n=N;
a=5;
e=0.9;
p=13;
q=7;
rng(0); % 设置随机数种子
x1 = rand(1, n);   % 初始化 x1，长度为 N 的随机行向量

%扩散密钥
main_key = 0.75;
mu=4.6;

%% Step 4: z加密
C1 = z_encrypt(img, seq, z, BIG_NUMBER);

%% Step 5: 对图像进行置乱
[index_matrix1, index_matrix2, index_matrix3]=Generate_index_matrix(n,a,e,p,q,x1);
C2=zhiluan(C1,index_matrix1,index_matrix2,index_matrix3);

%% Step 6: 对图像进行扩散
[C,laplace_map] = kuosan(C2,main_key,mu);

%% ========== 解密过程 ==========  
%% Step 7: 对图像进行解扩散
%P2 = ikuosan(C,main_key,mu,laplace_map);

%% Step 8: 对图像进行逆置乱
%P1=izhiluan(P2,index_matrix1,index_matrix2,index_matrix3);

%% Step 9: 对图像进行逆z
%P = z_decrypt(P1, seq, z, BIG_NUMBER);

%%  z变换密钥
% x0_wrong=x0+1e-16;
% r_wrong=r+1e-15;
% z_wrong=z+1e-14;
% seq1 = generate_chaos_01(x0_wrong, r, M, N);
% seq2 = generate_chaos_01(x0,r_wrong, M, N);
% decrypted_img1 = z_decrypt(P1, seq1, z, BIG_NUMBER);
% decrypted_img2= z_decrypt(P1, seq2, z, BIG_NUMBER);
% decrypted_img3 = z_decrypt(P1, seq, z_wrong, BIG_NUMBER);
% 
% figure('Position', [100, 100, 800, 600]);
% 
% subplot(2, 3, 1);
% imshow(img);
% title('原图像', 'FontSize', 10);
% 
% subplot(2, 3, 2);
% imshow(uint8(C), []);
% title('加密后图像', 'FontSize', 10);
% 
% % 2. 解密结果
% subplot(2, 3, 3);
% imshow(uint8(P), []);
% title('正确密钥解密图像', 'FontSize', 10);
% 
% % 4. 密钥错误解密对比
% subplot(2, 3, 4);
% imshow(uint8(decrypted_img1), []);
% 
% 
% subplot(2, 3, 5);
% imshow(uint8(decrypted_img2), []);
% 
% 
% subplot(2, 3, 6);
% imshow(uint8(decrypted_img3));


%%  置乱密钥
% a_wrong=a+1e-15;
% e_wrong=e+1e-16;
% x10=x1;
% x11=x1;
% x12=x1;
% x10(1)=x1(1)+1e-16;
% x11(256)=x1(256)+1e-16;
% x12(512)=x1(512)+1e-16;
% [index_matrix10, index_matrix20, index_matrix30]=Generate_index_matrix(n,a_wrong,e,p,q,x1);
% [index_matrix11, index_matrix21, index_matrix31]=Generate_index_matrix(n,a,e_wrong,p,q,x1);
% [index_matrix12, index_matrix22, index_matrix32]=Generate_index_matrix(n,a,e,p,q,x10);
% [index_matrix13, index_matrix23, index_matrix33]=Generate_index_matrix(n,a,e,p,q,x11);
% [index_matrix14, index_matrix24, index_matrix34]=Generate_index_matrix(n,a,e,p,q,x12);
% P11=izhiluan(P2,index_matrix10,index_matrix20,index_matrix30);
% P12=izhiluan(P2,index_matrix11,index_matrix21,index_matrix31);
% P13=izhiluan(P2,index_matrix12,index_matrix22,index_matrix32);
% P14=izhiluan(P2,index_matrix13,index_matrix23,index_matrix33);
% P15=izhiluan(P2,index_matrix14,index_matrix24,index_matrix34);
% decrypted_img1 = z_decrypt(P11, seq, z, BIG_NUMBER);
% decrypted_img2 = z_decrypt(P12, seq, z, BIG_NUMBER);
% decrypted_img3 = z_decrypt(P13, seq, z, BIG_NUMBER);
% decrypted_img4 = z_decrypt(P14, seq, z, BIG_NUMBER);
% decrypted_img5 = z_decrypt(P15, seq, z, BIG_NUMBER);

%%  扩散密钥
main_key_wrong=main_key+1e-16;
mu_wrong=mu+1e-15;
P21 = ikuosan(C,main_key_wrong,mu,laplace_map);
P22= ikuosan(C,main_key,mu_wrong,laplace_map);
P211=izhiluan(P21,index_matrix1,index_matrix2,index_matrix3);
P212=izhiluan(P22,index_matrix1,index_matrix2,index_matrix3);

decrypted_img1= z_decrypt(P211, seq, z, BIG_NUMBER);
decrypted_img2= z_decrypt(P212, seq, z, BIG_NUMBER);
subplot(1, 2, 1);
imshow(uint8(decrypted_img1));
subplot(1, 2, 2);
imshow(uint8(decrypted_img2));



% figure('Position', [100, 100, 800, 600]);
% subplot(2, 3, 1);
% imshow(img);
% title('原图像', 'FontSize', 10);
% subplot(2, 3, 2);
% imshow(uint8(decrypted_img1), []);
% % 2. 解密结果
% subplot(2, 3, 3);
% imshow(uint8(decrypted_img2), []);
% % 4. 密钥错误解密对比
% subplot(2, 3, 4);
% imshow(uint8(decrypted_img3), []);
% subplot(2, 3, 5);
% imshow(uint8(decrypted_img4), []);
% subplot(2, 3, 6);
% imshow(uint8(decrypted_img5));





%% 混沌序列生成函数
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
        %seq_vector(k) = r * seq_vector(k-1) * (1 - seq_vector(k-1));
         seq_vector(k) = mod(100 * sin((pi * seq_vector(k-1))^r) * exp(26 * (1 - seq_vector(k-1))), 1);
    end

    % 丢弃前1000个点
    seq_vector = seq_vector(1001:end);
    seq_vector = seq_vector(1:total);

    % 重塑为矩阵
    seq = reshape(seq_vector, [M, N]);
end