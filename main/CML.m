function result_matrix = CML(N, iterations, a, e, p, q, x1)
    % 初始化必要的变量
    L=N;
    % 总迭代次数 = 瞬态消除次数 + 需要保存的迭代次数
    transient_iterations = 1000;
    total_iterations = transient_iterations + iterations;
    
    result_matrix = zeros(N, iterations); 
    
    % 进行迭代，先消除瞬态
    for iter = 1:total_iterations  
        x_new1 = zeros(1, N); % 新的状态向量  
        for i = 1:N  
            left = mod(i-2, L) + 1;    % 左邻居
            right = mod(i, L) + 1;     % 右邻居
            j_idx = mod(1 * i + p * i, L) + 1;  
            k_idx = mod(q * i + (p * q + 1) * i, L) + 1;

            % 应用自定义映射函数
            f_x_i = mod(100*sin((pi*x1(i))^a)*exp(26*(1-x1(i))), 1);
            f_x_neighbors = mod(100*sin((pi*sqrt(x1(left)*x1(j_idx)))^a)*exp(26*(1-sqrt(x1(left)*x1(j_idx)))), 1)...
                           + mod(100*sin((pi*sqrt(x1(right)*x1(k_idx)))^a)*exp(26*(1-sqrt(x1(right)*x1(k_idx)))), 1);

            % 更新状态
            x_new1(i) = (1 - e) * f_x_i + (e / 2) * f_x_neighbors;
        end  

        x1 = x_new1;  % 更新状态  
        e = 3.99 * e * (1 - e);  % 更新耦合参数

        % 只有在瞬态消除后，才将当前状态保存到 result_matrix 中
        if iter > transient_iterations
            result_matrix(:, iter - transient_iterations) = x1;  
        end
    end
end
