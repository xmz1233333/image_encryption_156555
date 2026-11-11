function seq = generate_chaos_01(x0, r, M, N)
% 生成 z_encrypt / z_decrypt 使用的 M x N 混沌序列。
% 与 performance_test.m 中的局部函数保持一致。

total = M * N;
seq_length = total + 1000;
seq_vector = zeros(seq_length, 1);
seq_vector(1) = x0;

for k = 2:seq_length
    seq_vector(k) = mod(100 * sin((pi * seq_vector(k-1))^r) * ...
                        exp(26 * (1 - seq_vector(k-1))), 1);
end

seq_vector = seq_vector(1001:end);
seq_vector = seq_vector(1:total);
seq = reshape(seq_vector, [M, N]);
end
