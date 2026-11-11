% function [encrypted_image] = laplace_diffusion_encrypt(...
%     original_image, main_key, mu, laplace_map, L_max)
% 
%     [height, width] = size(original_image);
%     total_pixels = height * width;
% 
%     % 生成混沌序列
%     chaos_length = total_pixels * 2;
%     chaos_sequence = generate_chaos_sequence(main_key, mu, chaos_length);
% 
%     % 初始化加密图像
%     encrypted_image = zeros(height, width);
%     chaos_idx = 1;
% 
%     % 正向扩散（左上到右下）
%     for i = 1:height
%         for j = 1:width
%             current_pixel = original_image(i, j);
%             chaos_key = uint8(chaos_sequence(chaos_idx) * 255);
%             laplace_val = laplace_map(i, j);
% 
%             % 获取之前加密的邻域像素
%             if i == 1 && j == 1
%                 prev_cipher_left = uint8(main_key * 255);
%                 prev_cipher_above = uint8(main_key * 255);
%             elseif j == 1
%                 prev_cipher_left = uint8(main_key * 255);
%                 prev_cipher_above = encrypted_image(i-1, j);
%             elseif i == 1
%                 prev_cipher_left = encrypted_image(i, j-1);
%                 prev_cipher_above = uint8(main_key * 255);
%             else
%                 prev_cipher_left = encrypted_image(i, j-1);
%                 prev_cipher_above = encrypted_image(i-1, j);
%             end
% 
%             % 拉普拉斯调制的扩散项
%             diffusion_weight = 1 + abs(laplace_val) / L_max;
%             cipher_diffusion = mod((double(prev_cipher_left) + double(prev_cipher_above)) * diffusion_weight, 256);
% 
%             % 加密计算
%             encrypted_pixel = mod(current_pixel + double(chaos_key) + cipher_diffusion, 256);
%             encrypted_image(i, j) = encrypted_pixel;
% 
%             chaos_idx = chaos_idx + 1;
%         end
%     end
% 
%     % 逆向扩散（右下到左上）
%     for i = height:-1:1
%         for j = width:-1:1
%             current_pixel = encrypted_image(i, j);
%             chaos_key = uint8(chaos_sequence(chaos_idx) * 255);
%             laplace_val = laplace_map(i, j);
% 
%             % 获取之后加密的邻域像素
%             if i == height && j == width
%                 next_cipher_right = uint8(main_key * 255);
%                 next_cipher_below = uint8(main_key * 255);
%             elseif j == width
%                 next_cipher_right = uint8(main_key * 255);
%                 next_cipher_below = encrypted_image(i+1, j);
%             elseif i == height
%                 next_cipher_right = encrypted_image(i, j+1);
%                 next_cipher_below = uint8(main_key * 255);
%             else
%                 next_cipher_right = encrypted_image(i, j+1);
%                 next_cipher_below = encrypted_image(i+1, j);
%             end
% 
%             % 拉普拉斯调制的扩散项
%             diffusion_weight = 1 + abs(laplace_val) / L_max;
%             cipher_diffusion = mod((double(next_cipher_right) + double(next_cipher_below)) * diffusion_weight, 256);
% 
% 
%             % 逆向扩散计算
%             encrypted_pixel = mod(current_pixel + double(chaos_key) + cipher_diffusion, 256);
% 
%             encrypted_image(i, j) = encrypted_pixel;
% 
%             chaos_idx = chaos_idx + 1;
%         end
%     end
% end

% function [encrypted_image] = laplace_diffusion_encrypt(...
%     original_image, main_key, mu, laplace_map, L_max)
% 
%     [height, width] = size(original_image);
%     total_pixels = height * width;
% 
%     % 生成混沌序列
%     chaos_length = total_pixels * 2;
%     chaos_sequence = generate_chaos_sequence(main_key, mu, chaos_length);
% 
%     % 初始化加密图像
%     encrypted_image = zeros(height, width);
%     chaos_idx = 1;
% 
%     % 正向扩散（左上到右下）
%     for i = 1:height
%         for j = 1:width
%             current_pixel = original_image(i, j);
%             chaos_key = uint8(chaos_sequence(chaos_idx) * 255);
%             laplace_val = laplace_map(i, j);
% 
%             % 获取之前加密的邻域像素
%             if i == 1 && j == 1
%                 prev_cipher_left = uint8(main_key * 255);
%                 prev_cipher_above = uint8(main_key * 255);
%             elseif j == 1
%                 prev_cipher_left = uint8(main_key * 255);
%                 prev_cipher_above = encrypted_image(i-1, j);
%             elseif i == 1
%                 prev_cipher_left = encrypted_image(i, j-1);
%                 prev_cipher_above = uint8(main_key * 255);
%             else
%                 prev_cipher_left = encrypted_image(i, j-1);
%                 prev_cipher_above = encrypted_image(i-1, j);
%             end
% 
%             % 拉普拉斯调制的扩散项
%             diffusion_weight = 1 + abs(laplace_val) / L_max;
%             cipher_diffusion = mod(double(prev_cipher_left) + double(prev_cipher_above)+double(abs(laplace_val)), 256);
% 
%             % 加密计算
%             encrypted_pixel = mod(current_pixel + double(chaos_key) + cipher_diffusion, 256);
%             encrypted_image(i, j) = encrypted_pixel;
% 
%             chaos_idx = chaos_idx + 1;
%         end
%     end
% 
%     % 逆向扩散（右下到左上）
%     for i = height:-1:1
%         for j = width:-1:1
%             current_pixel = encrypted_image(i, j);
%             chaos_key = uint8(chaos_sequence(chaos_idx) * 255);
%             laplace_val = laplace_map(i, j);
% 
%             % 获取之后加密的邻域像素
%             if i == height && j == width
%                 next_cipher_right = uint8(main_key * 255);
%                 next_cipher_below = uint8(main_key * 255);
%             elseif j == width
%                 next_cipher_right = uint8(main_key * 255);
%                 next_cipher_below = encrypted_image(i+1, j);
%             elseif i == height
%                 next_cipher_right = encrypted_image(i, j+1);
%                 next_cipher_below = uint8(main_key * 255);
%             else
%                 next_cipher_right = encrypted_image(i, j+1);
%                 next_cipher_below = encrypted_image(i+1, j);
%             end
% 
%             % 拉普拉斯调制的扩散项
%             diffusion_weight = 1 + abs(laplace_val) / L_max;
%             %cipher_diffusion = mod((double(next_cipher_right) + double(next_cipher_below)) * diffusion_weight, 256);
%              cipher_diffusion = mod(double(next_cipher_right) + double(next_cipher_below)+double(abs(laplace_val)), 256);
% 
%             % 逆向扩散计算
%             encrypted_pixel = mod(current_pixel + double(chaos_key) + cipher_diffusion, 256);
% 
%             encrypted_image(i, j) = encrypted_pixel;
% 
%             chaos_idx = chaos_idx + 1;
%         end
%     end
% end

function [encrypted_image] = laplace_diffusion_encrypt(...
    original_image, main_key, mu, laplace_map, L_max)

    [height, width] = size(original_image);
    total_pixels = height * width;

    % 生成混沌序列
    chaos_length = total_pixels * 2;
    chaos_sequence = generate_chaos_sequence(main_key, mu, chaos_length);

    % 初始化加密图像
    encrypted_image = zeros(height, width);
    chaos_idx = 1;

   % 正向扩散（左上到右下）
for i = 1:height
    for j = 1:width
        current_pixel = original_image(i, j);
        chaos_key = uint8(chaos_sequence(chaos_idx) * 255);
        laplace_val = laplace_map(i, j);

        % 获取之前加密的邻域像素
        if i == 1 && j == 1
            prev_cipher_left = uint8(main_key * 255);
            prev_cipher_above = uint8(main_key * 255);
        elseif j == 1
            prev_cipher_left = uint8(main_key * 255);
            prev_cipher_above = encrypted_image(i-1, j);
        elseif i == 1
            prev_cipher_left = encrypted_image(i, j-1);
            prev_cipher_above = uint8(main_key * 255);
        else
            prev_cipher_left = encrypted_image(i, j-1);
            prev_cipher_above = encrypted_image(i-1, j);
        end

        % 拉普拉斯调制的扩散项
        diffusion_weight = 1 + abs(laplace_val) / L_max;
        cipher_diffusion = mod(double(prev_cipher_left) + double(prev_cipher_above) + double(abs(laplace_val)), 256);
          %cipher_diffusion = mod(bitxor(bitxor(double(prev_cipher_left), double(prev_cipher_above)), ...
                                 %double(abs(laplace_val))),256);
        % 使用XOR代替加法
        encrypted_pixel = bitxor(bitxor(current_pixel, double(chaos_key)), cipher_diffusion);
        encrypted_image(i, j) = encrypted_pixel;

        chaos_idx = chaos_idx + 1;
    end
end

  for i = height:-1:1
    for j = width:-1:1
        current_pixel = encrypted_image(i, j);
        chaos_key = uint8(chaos_sequence(chaos_idx) * 255);
        laplace_val = laplace_map(i, j);

        % 获取之后加密的邻域像素
        if i == height && j == width
            next_cipher_right = uint8(main_key * 255);
            next_cipher_below = uint8(main_key * 255);
        elseif j == width
            next_cipher_right = uint8(main_key * 255);
            next_cipher_below = encrypted_image(i+1, j);
        elseif i == height
            next_cipher_right = encrypted_image(i, j+1);
            next_cipher_below = uint8(main_key * 255);
        else
            next_cipher_right = encrypted_image(i, j+1);
            next_cipher_below = encrypted_image(i+1, j);
        end

        diffusion_weight = 1 + abs(laplace_val) / L_max;
        cipher_diffusion = mod(double(next_cipher_right) + double(next_cipher_below) + double(abs(laplace_val)), 256);
        % cipher_diffusion = mod(bitxor(bitxor(double(next_cipher_right), double(next_cipher_below)), ...
                                          %double(abs(laplace_val))),256);
        % 使用XOR代替加法
        encrypted_pixel = bitxor(bitxor(current_pixel, double(chaos_key)), cipher_diffusion);
        encrypted_image(i, j) = encrypted_pixel;

        chaos_idx = chaos_idx + 1;
    end
end
end
