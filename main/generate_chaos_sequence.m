function chaos_sequence = generate_chaos_sequence(initial_key, r, length)
    chaos_sequence = zeros(1, length);
    
    % 初始化混沌系统
    x = initial_key;
    for i = 1:1000  % 瞬态消除
        x = mod(100 * sin((pi *  x)^r) * exp(26 * (1 -  x)), 1);
    end
    
    % 生成混沌序列
    for i = 1:length
        x = mod(100 * sin((pi *  x)^r) * exp(26 * (1 -  x)), 1);
        chaos_sequence(i) = x;
    end
end
