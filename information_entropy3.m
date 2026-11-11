% 参数设置
L = 100;             % 格点数量 
lambda =4;      % Logistic映射的混沌参数
e_values = linspace(0, 1, 50);  % 耦合系数从0到1，取50个点
N = 1000;           % 迭代次数 
num_states = 10;    % 将值划分为10个区间用于计算信息熵
q = 3.99;      % Parameter for e_n update equation
p = 13;        % Matrix parameter p
q_matrix =7; % Matrix parameter q
b=3.99;
% 初始化
entropy_matrix = zeros(L, length(e_values)); % 保存熵值
x_values = 1:L;       % x轴：格点
% 遍历每个耦合系数
for e_idx = 1:length(e_values)
    epsilon = e_values(e_idx);  % 当前耦合系数
    rng(0);  % 固定随机种子以确保可重复性
    x = rand(1, L);  % 每个格点的初始值随机在[0,1]之间
    % 用于存储每个格点的状态变化
    state_series = zeros(N, L);  % 用于保存每个格点的状态序列

    % 时间演化迭代
    for n = 1:N
        x_new = zeros(1, L);  % 新状态初始化
        for i = 1:L
            left = mod(i-2, L) + 1;    % 左邻居
            right = mod(i, L) + 1;     % 右邻居
            j_idx = mod(1 * i + p * i, L) + 1;  % mod(L) ensures periodic boundary conditions
            k_idx = mod(q_matrix * i + (p * q_matrix + 1) * i, L) + 1;
            % 逻辑映射
         f_i = lambda * x(i) * (1 - x(i));
         %  f_i = mod(100 * sin((pi * x(i))^lambda) * exp(26 * (1 - x(i))), 1);
            f_x_neighbors = lambda * sqrt(x(left) * x(j_idx)) * (1 - sqrt(x(left) * x(j_idx))) ...
                         + lambda * sqrt(x(right) * x(k_idx)) * (1 - sqrt(x(right) * x(k_idx))); 
               %  f_x_neighbors = mod(100*sin((pi*sqrt(x(left)*x(j_idx)))^lambda)*exp(26*(1-sqrt(x(left)*x(j_idx)))),1)...
                                            % +mod(100*sin((pi*sqrt(x(right)*x(k_idx)))^lambda)*exp(26*(1-sqrt(x(right)*x(k_idx)))),1);
            % 更新状态
            x_new(i) = (1 - epsilon) * f_i + (epsilon / 2) * f_x_neighbors;
        end
         epsilon= 3.99 * epsilon * (1 - epsilon);
        state_series(n, :) = x_new;  % 记录每个格点的状态
        x = x_new;  % 更新状态
    end

    % 计算每个格点的信息熵
    for i = 1:L
        % 获取格点i的整个时间序列
        x_time_series = state_series(:, i);
        % 将时间序列分为10个区间
        [counts, edges] = histcounts(x_time_series, num_states, 'Normalization', 'count');  % 分为10个区间
        prob = counts / N;  % 使用总的迭代次数N来计算每个区间的概率
        % 删除为0的概率
        prob = prob(prob > 0);  % 仅保留大于0的概率
        % 计算信息熵
        if ~isempty(prob)  % 确保概率不为空
            entropy_matrix(i, e_idx) = -sum(prob .* log2(prob));  
        else
            entropy_matrix(i, e_idx) = 0;  % 如果没有有效的概率分布，可以设为0
        end
    end
end

maxValue = max(entropy_matrix(:));
minValue = min(entropy_matrix(:));

% 绘制三维图
[X, Y] = meshgrid(x_values, e_values);  % 创建x（格点）和y（耦合系数）的网格
figure;
mesh(X, Y, entropy_matrix');  % 绘制z为信息熵的三维曲面
xlabel('lattices');
ylabel('ε');
zlim([0,3.5]);
colorbar;



