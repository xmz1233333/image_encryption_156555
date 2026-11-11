function [decrypted_image] = ikuosan(encrypted_image,main_key,mu,laplace_map)
%图像组合

encrypted_image_zuhe =[encrypted_image(:,:,1),encrypted_image(:,:,2),encrypted_image(:,:,3)];
% 拉普拉斯卷积核
  [H, W, C] = size(encrypted_image);
%% 生成拉普拉斯特征图
L_max = max(abs(laplace_map(:)));
if L_max == 0, L_max = 1; end

decrypted_image_zuhe = laplace_diffusion_decrypt(...
    encrypted_image_zuhe, main_key, mu, laplace_map, L_max);
fprintf('解扩散完成！\n');
decrypted_image_R= decrypted_image_zuhe(:, 1:H);      % 前256列是R通道
decrypted_image_G = decrypted_image_zuhe(:, H+1:H*2);    % 中间256列是G通道
decrypted_image_B = decrypted_image_zuhe(:, 2*H+1:3*H);    % 后256列是B通道
% 重新组合成彩色图像
decrypted_image = cat(3, decrypted_image_R, decrypted_image_G, decrypted_image_B);


end

