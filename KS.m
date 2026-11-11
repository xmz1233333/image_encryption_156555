
clc; clear; close all;

% 参数设置
%a_values = 3:0.01:4;    % 扫描参数 a
a_values = 0:0.1:4;    % 扫描参数 a
e_values = 0:0.1:1;    % 扫描耦合强度 ε
na = numel(a_values);
ne = numel(e_values);
N = 100;               % 晶格长度
L = N;
p = 13;
q_matrix = 7;
perturbation = 1e-8;
N_total = 1000;        % 总迭代步数
N_trans = 300;         % 丢弃热身步数

% 结果存储
KSED = zeros(ne, na);
KSEB = zeros(ne, na);

% 扫描参数
for ia = 1:na
    a = a_values(ia);
    for ie = 1:ne
        e = e_values(ie);
        
        rng(1); % 固定随机种子
        x = rand(1, N);

        lyapunov_sum = zeros(1, N);
        
        % 动力系统演化
        for iter = 1:N_total
            x_new = zeros(1, N);
            x_new_perturbed = zeros(1, N);
            x_perturbed = x+ perturbation * ones(1, N);
            
            for i = 1:N
                left = mod(i - 2, L) + 1;
                right = mod(i, L) + 1;
                j_idx = mod(i + p * i, L) + 1;
                k_idx = mod(q_matrix * i + (p * q_matrix + 1) * i, L) + 1;
                

                % 原始系统映射
               % f_x_i = a * x(i) * (1 - x(i));
               % xlj = sqrt(x(left) * x(j_idx));
               %  xrk = sqrt(x(right) * x(k_idx));
               % f_x_neighbors = a * xlj * (1 - xlj) + a * xrk * (1 - xrk);
               % x_new(i) = (1 - e) * f_x_i + (e / 2) * f_x_neighbors;
                
                f_x_i = mod(100 * sin((pi * x(i))^a) * exp(26 * (1 - x(i))), 1);
                xlj = sqrt(x(left) * x(j_idx));
                xrk = sqrt(x(right) * x(k_idx));
                f_x_neighbors = ...
                    mod(100 * sin((pi*xlj)^a) * exp(26 * (1 -  xlj)), 1) + ...
                    mod(100 * sin((pi*xrk)^a) * exp(26 * (1 -  xrk)), 1);
                x_new(i) = (1 - e) * f_x_i + (e / 2) * f_x_neighbors;
                
                % 扰动系统映射

              %  f_x_i_p = a * x_perturbed(i) * (1 - x_perturbed(i));
              %   xlj_p = sqrt(x_perturbed(left) * x_perturbed(j_idx));
              % xrk_p = sqrt(x_perturbed(right) * x_perturbed(k_idx));
              %  f_x_neighbors_p = a * xlj_p * (1 - xlj_p) + a * xrk_p * (1 - xrk_p);
              %  x_new_perturbed(i) = (1 - e) * f_x_i_p + (e / 2) * f_x_neighbors_p;     

                f_x_i_p = mod(100 * sin((pi * x_perturbed(i))^a) * exp(26 * (1 - x_perturbed(i))), 1);
                xlj_p = sqrt(x_perturbed(left) * x_perturbed(j_idx));
                xrk_p = sqrt(x_perturbed(right) * x_perturbed(k_idx));
                f_x_neighbors_p = ...
                    mod(100 * sin((pi*xlj_p)^a) * exp(26 * (1 -  xlj_p)), 1) + ...
                    mod(100 * sin((pi*xrk_p)^a) * exp(26 * (1 -  xrk_p)), 1);
                x_new_perturbed(i) = (1 - e) * f_x_i_p + (e / 2) * f_x_neighbors_p;

           
            end

            % 计算Lyapunov指数
            if iter > N_trans
                delta = abs(x_new_perturbed - x_new);
                lyapunov_sum = lyapunov_sum + log(delta / perturbation);
              
            end
            x = x_new;
            e=3.99*e*(1-e);
        end

        % 每个格点的Lyapunov指数
        lyapunov_exponents = lyapunov_sum / (N_total - N_trans);
        positive_LE = lyapunov_exponents(lyapunov_exponents > 0);
        KSED(ie, ia) = sum(positive_LE) / N;
        KSEB(ie, ia) = length(positive_LE) / N;
    end
end

% 可视化
[e_grid, a_grid] = meshgrid(e_values, a_values);

figure;
mesh(e_grid, a_grid, KSED');
xlabel('\\epsilon'); ylabel('a'); zlabel('KSED');
title('KSED 值分布'); grid on;

figure;
mesh(e_grid, a_grid, KSEB');
xlabel('\\epsilon'); ylabel('a'); zlabel('KSEB');
title('KSEB 值分布'); grid on;
zlim([0 1]);  % 设置z轴刻度范围为0-1
