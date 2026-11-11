function encrypted_image = laplace_diffusion_encrypt(...
    original_image, main_key, mu, laplace_map, L_max, chaos_seq)
% Optimized implementation.
% The encryption scheme is unchanged; only type conversions and boundary
% checks inside the scanning loops are reduced.

[height, width] = size(original_image);
total_pixels = height * width;

if nargin < 6 || isempty(chaos_seq)
    chaos_length = total_pixels * 2;
    chaos_seq = generate_chaos_sequence(main_key, mu, chaos_length);
end

keys   = uint8(chaos_seq(1:total_pixels * 2) * 255);
absL   = uint8(mod(abs(laplace_map), 256));
border = uint8(main_key * 255);

P = uint8(original_image);
encrypted_image = zeros(height, width, 'uint8');

key_idx = 1;

% ---------- forward diffusion ----------
for i = 1:height
    if i == 1
        above = border * ones(1, width, 'uint8');
    else
        above = encrypted_image(i - 1, :);
    end

    left = border;

    for j = 1:width
        s = uint16(left) + uint16(above(j)) + uint16(absL(i, j));
        d = uint8(mod(s, 256));

        v = bitxor(bitxor(P(i, j), keys(key_idx)), d);
        encrypted_image(i, j) = v;

        left = v;
        key_idx = key_idx + 1;
    end
end

% ---------- backward diffusion ----------
for i = height:-1:1
    if i == height
        below = border * ones(1, width, 'uint8');
    else
        below = encrypted_image(i + 1, :);
    end

    right = border;

    for j = width:-1:1
        s = uint16(right) + uint16(below(j)) + uint16(absL(i, j));
        d = uint8(mod(s, 256));

        v = bitxor(bitxor(encrypted_image(i, j), keys(key_idx)), d);
        encrypted_image(i, j) = v;

        right = v;
        key_idx = key_idx + 1;
    end
end
end
