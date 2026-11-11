function [encrypted_image, laplace_map] = kuosan(original_image, main_key, mu, chaos_seq)


laplace_kernel = [0, 1, 0; 1, -4, 1; 0, 1, 0];
[H, W, ~] = size(original_image);

image_R = original_image(:,:,1);
image_G = original_image(:,:,2);
image_B = original_image(:,:,3);
img = [image_R, image_G, image_B];

laplace_map = conv2(img, laplace_kernel, 'same');
L_max = max(abs(laplace_map(:)));
if L_max == 0, L_max = 1; end

% 若未提供混沌序列，则内部生成
if nargin < 4 || isempty(chaos_seq)
    chaos_length = H * (3*W) * 2;
    chaos_seq = generate_chaos_sequence(main_key, mu, chaos_length);
end

[encrypted_image_zuhe] = laplace_diffusion_encrypt(...
    img, main_key, mu, laplace_map, L_max, chaos_seq);

encrypted_image_R = encrypted_image_zuhe(:, 1:H);
encrypted_image_G = encrypted_image_zuhe(:, H+1:H*2);
encrypted_image_B = encrypted_image_zuhe(:, 2*H+1:3*H);
encrypted_image = cat(3, encrypted_image_R, encrypted_image_G, encrypted_image_B);
end