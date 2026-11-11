function chaos_seq_reshaped = generate_zchaos(x0, r, K, M, N)
% 生成混沌序列并重塑为指定维度
% 输入:
%   x0 - Logistic映射初始值
%   r - Logistic映射控制参数
%   K - Z变换阶数
%   M - 图像行数
%   N - 图像列数
% 输出:
%   chaos_seq_reshaped - 重塑后的混沌序列 [K x M x N]

    % 计算需要的混沌序列长度
    chaos_len = K * M * N;
    
    % 瞬态消除长度
    transient_len = 1000;  % 可以根据需要调整
    
    % 生成混沌序列（包括瞬态消除部分）
    chaos_seq = zeros(1, transient_len + chaos_len);
    chaos_seq(1) = x0;
    
    % 先进行瞬态消除
    for i = 2:(transient_len + chaos_len)
        chaos_seq(i) = mod(100 * sin((pi * chaos_seq(i-1))^r) * exp(26 * (1 - chaos_seq(i-1))), 1);
    end
    
    % 丢弃瞬态部分，只取后面的稳定序列
    stable_seq = chaos_seq((transient_len + 1):end);
    
    % 重塑为 [K x M x N] 维度
    chaos_seq_reshaped = reshape(stable_seq, [K, M, N]);
end
