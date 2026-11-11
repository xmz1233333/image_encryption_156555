function [encrypted_image,laplace_map] = kuosan(original_image,main_key,mu)
% 拉普拉斯卷积核
laplace_kernel = [0, 1, 0; 1, -4, 1; 0, 1, 0];
  [H, W, C] = size(original_image);
% image_R = double(original_image(:,:,1));
% image_G = double(original_image(:,:,2));
% image_B = double(original_image(:,:,3));
image_R = original_image(:,:,1);
image_G = original_image(:,:,2);
image_B = original_image(:,:,3);
img=[image_R,image_G,image_B];

%% 生成拉普拉斯特征图
laplace_map = conv2(img, laplace_kernel, 'same');
L_max = max(abs(laplace_map(:)));
if L_max == 0, L_max = 1; end

%% 加密过程 - 调用加密函数
fprintf('开始扩散过程...\n');
[encrypted_image_zuhe] = laplace_diffusion_encrypt(...
    img, main_key, mu, laplace_map, L_max);
fprintf('扩散完成！\n');
encrypted_image_R= encrypted_image_zuhe(:, 1:H);      % 前256列是R通道
encrypted_image_G = encrypted_image_zuhe(:, H+1:H*2);    % 中间256列是G通道
encrypted_image_B = encrypted_image_zuhe(:, 2*H+1:3*H);    % 后256列是B通道
% 重新组合成彩色图像
encrypted_image = cat(3, encrypted_image_R, encrypted_image_G, encrypted_image_B);
end

