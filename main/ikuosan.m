function [decrypted_image] = ikuosan(encrypted_image, main_key, mu, laplace_map, chaos_seq)

encrypted_image_zuhe = [encrypted_image(:,:,1), encrypted_image(:,:,2), encrypted_image(:,:,3)];
[H, ~, ~] = size(encrypted_image);

L_max = max(abs(laplace_map(:)));
if L_max == 0, L_max = 1; end

if nargin < 5 || isempty(chaos_seq)
    chaos_length = H * (3*H) * 2;
    chaos_seq = generate_chaos_sequence(main_key, mu, chaos_length);
end

decrypted_image_zuhe = laplace_diffusion_decrypt(...
    encrypted_image_zuhe, main_key, mu, laplace_map, L_max, chaos_seq);

decrypted_image_R = decrypted_image_zuhe(:, 1:H);
decrypted_image_G = decrypted_image_zuhe(:, H+1:H*2);
decrypted_image_B = decrypted_image_zuhe(:, 2*H+1:3*H);
decrypted_image = cat(3, decrypted_image_R, decrypted_image_G, decrypted_image_B);
end