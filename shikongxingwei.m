% 参数设置
N = 100;                % 网格大小（格点数量）
T = 1200;               % 迭代步数
epsilon = 0.1;          % 耦合系数
last_N_steps = 1000;      % 只保存最后 1000 次迭代的状态
a =4;                  % 常数a
e = 0.9;                % 常数e
p = 13;                  % 参数p
q_matrix = 7;           % 参数q_matrix
%b=3.99;
% 初始化状态和存储矩阵
x = rand(N, 1);         % 初始化随机状态
x_record = zeros(N, last_N_steps); % 用于存储每个格点在最后 20 次迭代的状态
   x_new = zeros(1, N);  % Prepare new state
% 进行 CML 迭代
for t = 1:T

    for i = 1:N
        % 计算左右邻居及其他索引
        left = mod(i-2, N) + 1;    % 左邻居
        right = mod(i, N) + 1;     % 右邻居
        j_idx = mod(1 * i + p * i, N) + 1;  % j索引
        k_idx = mod(q_matrix * i + (p * q_matrix + 1) * i, N) + 1;   % k索引
        
        % 计算当前格点和邻居的反馈
       % f_x_i = a * x(i) * (1 - x(i));  % 当前格点的反馈
       % f_x_neighbors = a * sqrt(x(left) * x(j_idx)) * (1 - sqrt(x(left) * x(j_idx))) ...
       %                  + a * sqrt(x(right) * x(k_idx)) * (1 - sqrt(x(right) * x(k_idx))); 

      %  f_x_i =b*log2(1+sin(pi*(a * x(i) * (1 - x(i)))))*(1-log2(1+sin(pi*(a * x(i) * (1 - x(i)))))); 
   %   f_x_neighbors = a * log2(1+sqrt(x(left)*x(j_idx))) * (1 -  log2(1+sqrt(x(left)*x(j_idx)))) ...
                        %  + a * log2(1+sqrt(x(right)*x(k_idx))) * (1 -  log2(1+sqrt(x(right)*x(k_idx))));  

       f_x_i =mod(100*sin((pi*x(i))^a)*exp(26*(1-x(i))),1);
 f_x_neighbors = mod(100*sin((pi*sqrt(x(left)*x(j_idx)))^a)*exp(26*(1-sqrt(x(left)*x(j_idx)))),1)...
                                             +mod(100*sin((pi*sqrt(x(right)*x(k_idx)))^a)*exp(26*(1-sqrt(x(right)*x(k_idx)))),1);
        % 更新状态
        x_new(i) = (1 - e) * f_x_i + (e / 2) * f_x_neighbors;
    end
    e=3.99*e*(1-e);
    % 更新状态
    x = x_new;
    if t > T - last_N_steps
        x_record(:, t - (T - last_N_steps)) = x; % 记录每个格点的状态
    end
end
% 绘制 x_record 矩阵
figure;
hold on;
for i = 1:last_N_steps
    plot(1:N, x_record(:, i));  % 横坐标为 1 到 N，纵坐标为每行数据
end
 set(groot, 'DefaultAxesFontSize', 14);
hold off;
ylim([0 1]); % 固定 y 轴范围

%xlabel('$i$', 'Interpreter', 'latex', 'FontSize', 18, 'FontWeight', 'bold');  % x 轴标签，斜体文字
%ylabel('$x_{i}(n)$', 'Interpreter', 'latex', 'FontSize', 18, 'FontWeight', 'bold');  % y 轴标签，包含下标

yticks(0:0.2:1);
xlabel('\fontname{Times new roman}a', 'FontSize', 25, 'FontWeight', 'normal','FontAngle', 'italic') % 设置x轴标签%  \theta \alpha \beta \mu \eta
ylabel('\fontname{Times new roman}x_{i}(n)', 'FontSize', 25, 'FontWeight', 'normal','FontAngle', 'italic') % 设置y轴标签

% figure(2);
% imagesc(x_record'); % x_record 的转置，使得时间步在纵轴
% %colormap(cool);       % 使用颜色表示状态
% colormap(jet);       % 使用 jet 色图
% colorbar;                % 显示颜色条
% 
% xlabel('格点编号');
% ylabel('时间步长');
% title('CML 系统的时空演化图');
% x_star = a / (1 + a);
% 
% % 将记录的状态二值化
% binary_record = x_record > x_star;
% 
% % 绘制二值化的时空演化图
% figure(3);
% imagesc(binary_record'); % 转置后时间为纵轴
% colormap(gray);          % 使用灰度色图，黑白显示
% colorbar;                % 显示颜色条
% xlabel('格点编号');
% ylabel('时间步长');
% title('二值化的时空演化图（大于不动点为黑，小于为白）');

