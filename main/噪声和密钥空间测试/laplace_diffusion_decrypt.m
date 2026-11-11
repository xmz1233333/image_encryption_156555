% function decrypted_image = laplace_diffusion_decrypt(...
%     encrypted_image, main_key, mu, laplace_map, L_max)
% 
%     [height, width] = size(encrypted_image);
% 
%     % 生成解密用的混沌序列（确保与加密一致）
%     total_pixels = height * width;
%     chaos_length = total_pixels * 2;
%         chaos_sequence = generate_chaos_sequence(main_key, mu, chaos_length);
% 
% 
%     % 初始化
%     decrypted_image = zeros(height, width);
%     intermediate_image = encrypted_image;
% 
%     % 解密过程 - 逆向扩散的逆（从左上到右下）
%     decrypt_chaos_idx = chaos_length; % 从序列末尾开始
% 
%     for i = 1:height
%         for j = 1:width
%             current_pixel = intermediate_image(i, j);
% 
%             % 确保索引在有效范围内
%             if decrypt_chaos_idx < 1
%                 decrypt_chaos_idx = 1;
%             end
% 
%             chaos_key = uint8(chaos_sequence(decrypt_chaos_idx) * 255);
%             laplace_val = laplace_map(i, j);
% 
%             % 获取邻域像素
%             if i == height && j == width
%                 next_cipher_right = uint8(main_key * 255);
%                 next_cipher_below = uint8(main_key * 255);
%             elseif j == width
%                 next_cipher_right = uint8(main_key * 255);
%                 next_cipher_below = intermediate_image(i+1, j);
%             elseif i == height
%                 next_cipher_right = intermediate_image(i, j+1);
%                 next_cipher_below = uint8(main_key * 255);
%             else
%                 next_cipher_right = intermediate_image(i, j+1);
%                 next_cipher_below = intermediate_image(i+1, j);
%             end
% 
%             diffusion_weight = 1 + abs(laplace_val) / L_max;
%             cipher_diffusion = mod((double(next_cipher_right) + double(next_cipher_below)) * diffusion_weight, 256);
% 
%             % 逆向计算
%        intermediate_pixel = mod(current_pixel - double(chaos_key) - cipher_diffusion + 512, 256);
% 
%             intermediate_image(i, j) = intermediate_pixel;
% 
%             decrypt_chaos_idx = decrypt_chaos_idx - 1;
%         end
%     end
% 
%     % 解密 - 正向扩散的逆（从右下到左上）
%     for i = height:-1:1
%         for j = width:-1:1
%             current_pixel = intermediate_image(i, j);
% 
%             % 确保索引在有效范围内
%             if decrypt_chaos_idx < 1
%                 decrypt_chaos_idx = 1;
%             end
% 
%             chaos_key = uint8(chaos_sequence(decrypt_chaos_idx) * 255);
%             laplace_val = laplace_map(i, j);
% 
%             % 获取邻域像素
%             if i == 1 && j == 1
%                 prev_cipher_left = uint8(main_key * 255);
%                 prev_cipher_above = uint8(main_key * 255);
%             elseif j == 1
%                 prev_cipher_left = uint8(main_key * 255);
%                 prev_cipher_above = intermediate_image(i-1, j);
%             elseif i == 1
%                 prev_cipher_left = intermediate_image(i, j-1);
%                 prev_cipher_above = uint8(main_key * 255);
%             else
%                 prev_cipher_left = intermediate_image(i, j-1);
%                 prev_cipher_above = intermediate_image(i-1, j);
%             end
% 
%             diffusion_weight = 1 + abs(laplace_val) / L_max;
%             cipher_diffusion = mod((double(prev_cipher_left) + double(prev_cipher_above)) * diffusion_weight, 256);
% 
%             % 逆向计算（使用+512避免负数）
%             decrypted_pixel = mod(current_pixel - double(chaos_key) - cipher_diffusion + 512, 256);
%             decrypted_image(i, j) = decrypted_pixel;
% 
%             decrypt_chaos_idx = decrypt_chaos_idx - 1;
%         end
%     end
% end

% function decrypted_image = laplace_diffusion_decrypt(...
%     encrypted_image, main_key, mu, laplace_map, L_max)
% 
%     [height, width] = size(encrypted_image);
% 
%     % 生成解密用的混沌序列（确保与加密一致）
%     total_pixels = height * width;
%     chaos_length = total_pixels * 2;
%         chaos_sequence = generate_chaos_sequence(main_key, mu, chaos_length);
% 
% 
%     % 初始化
%     decrypted_image = zeros(height, width);
%     intermediate_image = encrypted_image;
% 
%     % 解密过程 - 逆向扩散的逆（从左上到右下）
%     decrypt_chaos_idx = chaos_length; % 从序列末尾开始
% 
%     for i = 1:height
%         for j = 1:width
%             current_pixel = intermediate_image(i, j);
% 
%             % 确保索引在有效范围内
%             if decrypt_chaos_idx < 1
%                 decrypt_chaos_idx = 1;
%             end
% 
%             chaos_key = uint8(chaos_sequence(decrypt_chaos_idx) * 255);
%             laplace_val = laplace_map(i, j);
% 
%             % 获取邻域像素
%             if i == height && j == width
%                 next_cipher_right = uint8(main_key * 255);
%                 next_cipher_below = uint8(main_key * 255);
%             elseif j == width
%                 next_cipher_right = uint8(main_key * 255);
%                 next_cipher_below = intermediate_image(i+1, j);
%             elseif i == height
%                 next_cipher_right = intermediate_image(i, j+1);
%                 next_cipher_below = uint8(main_key * 255);
%             else
%                 next_cipher_right = intermediate_image(i, j+1);
%                 next_cipher_below = intermediate_image(i+1, j);
%             end
% 
%             diffusion_weight = 1 + abs(laplace_val) / L_max;
%             %cipher_diffusion = mod((double(next_cipher_right) + double(next_cipher_below)) * diffusion_weight, 256);
%             cipher_diffusion = mod(double(next_cipher_right) + double(next_cipher_below)+double(abs(laplace_val)), 256);
%             % 逆向计算
%        intermediate_pixel = mod(current_pixel - double(chaos_key) - cipher_diffusion + 512, 256);
% 
%             intermediate_image(i, j) = intermediate_pixel;
% 
%             decrypt_chaos_idx = decrypt_chaos_idx - 1;
%         end
%     end
% 
%     % 解密 - 正向扩散的逆（从右下到左上）
%     for i = height:-1:1
%         for j = width:-1:1
%             current_pixel = intermediate_image(i, j);
% 
%             % 确保索引在有效范围内
%             if decrypt_chaos_idx < 1
%                 decrypt_chaos_idx = 1;
%             end
% 
%             chaos_key = uint8(chaos_sequence(decrypt_chaos_idx) * 255);
%             laplace_val = laplace_map(i, j);
% 
%             % 获取邻域像素
%             if i == 1 && j == 1
%                 prev_cipher_left = uint8(main_key * 255);
%                 prev_cipher_above = uint8(main_key * 255);
%             elseif j == 1
%                 prev_cipher_left = uint8(main_key * 255);
%                 prev_cipher_above = intermediate_image(i-1, j);
%             elseif i == 1
%                 prev_cipher_left = intermediate_image(i, j-1);
%                 prev_cipher_above = uint8(main_key * 255);
%             else
%                 prev_cipher_left = intermediate_image(i, j-1);
%                 prev_cipher_above = intermediate_image(i-1, j);
%             end
% 
%             diffusion_weight = 1 + abs(laplace_val) / L_max;
%            % cipher_diffusion = mod((double(prev_cipher_left) + double(prev_cipher_above)) * diffusion_weight, 256);
%             cipher_diffusion = mod(double(prev_cipher_left) + double(prev_cipher_above)+double(abs(laplace_val)), 256);
%             % 逆向计算（使用+512避免负数）
%             decrypted_pixel = mod(current_pixel - double(chaos_key) - cipher_diffusion + 512, 256);
%             decrypted_image(i, j) = decrypted_pixel;
% 
%             decrypt_chaos_idx = decrypt_chaos_idx - 1;
%         end
%     end
% end

function decrypted_image = laplace_diffusion_decrypt(...
    encrypted_image, main_key, mu, laplace_map, L_max)

    [height, width] = size(encrypted_image);

    % 生成解密用的混沌序列（确保与加密一致）
    total_pixels = height * width;
    chaos_length = total_pixels * 2;
        chaos_sequence = generate_chaos_sequence(main_key, mu, chaos_length);


    % 初始化
    decrypted_image = zeros(height, width);
    intermediate_image = encrypted_image;

    % 解密过程 - 逆向扩散的逆（从左上到右下）
    decrypt_chaos_idx = chaos_length; % 从序列末尾开始

  for i = 1:height
    for j = 1:width
        current_pixel = intermediate_image(i, j);

        % 确保索引在有效范围内
        if decrypt_chaos_idx < 1
            decrypt_chaos_idx = 1;
        end

        chaos_key = uint8(chaos_sequence(decrypt_chaos_idx) * 255);
        laplace_val = laplace_map(i, j);

        % 获取邻域像素
        if i == height && j == width
            next_cipher_right = uint8(main_key * 255);
            next_cipher_below = uint8(main_key * 255);
        elseif j == width
            next_cipher_right = uint8(main_key * 255);
            next_cipher_below = intermediate_image(i+1, j);
        elseif i == height
            next_cipher_right = intermediate_image(i, j+1);
            next_cipher_below = uint8(main_key * 255);
        else
            next_cipher_right = intermediate_image(i, j+1);
            next_cipher_below = intermediate_image(i+1, j);
        end

        diffusion_weight = 1 + abs(laplace_val) / L_max;
        cipher_diffusion = mod(double(next_cipher_right) + double(next_cipher_below) + double(abs(laplace_val)), 256);
      %cipher_diffusion = mod(bitxor(bitxor(double(next_cipher_right), double(next_cipher_below)), ...
                                 %double(abs(laplace_val))),256);
        % 使用XOR代替加法
        intermediate_pixel = bitxor(bitxor(current_pixel, double(chaos_key)), cipher_diffusion);
        intermediate_image(i, j) = intermediate_pixel;

        decrypt_chaos_idx = decrypt_chaos_idx - 1;
    end
end

% 解密 - 正向扩散的逆（从右下到左上）
for i = height:-1:1
    for j = width:-1:1
        current_pixel = intermediate_image(i, j);

        % 确保索引在有效范围内
        if decrypt_chaos_idx < 1
            decrypt_chaos_idx = 1;
        end

        chaos_key = uint8(chaos_sequence(decrypt_chaos_idx) * 255);
        laplace_val = laplace_map(i, j);

        % 获取邻域像素
        if i == 1 && j == 1
            prev_cipher_left = uint8(main_key * 255);
            prev_cipher_above = uint8(main_key * 255);
        elseif j == 1
            prev_cipher_left = uint8(main_key * 255);
            prev_cipher_above = intermediate_image(i-1, j);
        elseif i == 1
            prev_cipher_left = intermediate_image(i, j-1);
            prev_cipher_above = uint8(main_key * 255);
        else
            prev_cipher_left = intermediate_image(i, j-1);
            prev_cipher_above = intermediate_image(i-1, j);
        end

        diffusion_weight = 1 + abs(laplace_val) / L_max;
        cipher_diffusion = mod(double(prev_cipher_left) + double(prev_cipher_above) + double(abs(laplace_val)), 256);
       % cipher_diffusion = mod(bitxor(bitxor(double(prev_cipher_left), double(prev_cipher_above)), ...
       %                           double(abs(laplace_val))),256);
        % 使用XOR代替加法
        decrypted_pixel = bitxor(bitxor(current_pixel, double(chaos_key)), cipher_diffusion);
        decrypted_image(i, j) = decrypted_pixel;

        decrypt_chaos_idx = decrypt_chaos_idx - 1;
    end
end
end



