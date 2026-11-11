function decrypted_image = laplace_diffusion_decrypt(...
    encrypted_image, main_key, mu, laplace_map, L_max, chaos_seq)
% Optimized implementation.
% The encryption scheme is unchanged; only type conversions and boundary
% checks inside the scanning loops are reduced.

[height, width] = size(encrypted_image);
total_pixels = height * width;

if nargin < 6 || isempty(chaos_seq)
    chaos_length = total_pixels * 2;
    chaos_seq = generate_chaos_sequence(main_key, mu, chaos_length);
end

keys   = uint8(chaos_seq(1:total_pixels * 2) * 255);
absL   = uint8(mod(abs(laplace_map), 256));
border = uint8(main_key * 255);

intermediate_image = uint8(encrypted_image);

decrypt_idx = total_pixels * 2;

% ---------- inverse of backward diffusion ----------
for i = 1:height
    if i == height
        below = border * ones(1, width, 'uint8');
    else
        below = intermediate_image(i + 1, :);
    end

    for j = 1:width
        if j == width
            right = border;
        else
            right = intermediate_image(i, j + 1);
        end

        s = uint16(right) + uint16(below(j)) + uint16(absL(i, j));
        d = uint8(mod(s, 256));

        v = bitxor(bitxor(intermediate_image(i, j), keys(decrypt_idx)), d);
        intermediate_image(i, j) = v;

        decrypt_idx = decrypt_idx - 1;
    end
end

% ---------- inverse of forward diffusion ----------
for i = height:-1:1
    if i == 1
        above = border * ones(1, width, 'uint8');
    else
        above = intermediate_image(i - 1, :);
    end

    for j = width:-1:1
        if j == 1
            left = border;
        else
            left = intermediate_image(i, j - 1);
        end

        s = uint16(left) + uint16(above(j)) + uint16(absL(i, j));
        d = uint8(mod(s, 256));

        v = bitxor(bitxor(intermediate_image(i, j), keys(decrypt_idx)), d);
        intermediate_image(i, j) = v;

        decrypt_idx = decrypt_idx - 1;
    end
end

decrypted_image = intermediate_image;
end
