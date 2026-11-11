clc, clear, close all
% Parameters for the system
%mu = 3.9;     % Logistic map parameter
q = 3.99;      % Parameter for e_n update equation
p = 13;        % Matrix parameter p
q_matrix = 7; % Matrix parameter q
N = 100;      % Number of lattice sites
L = N;        % Modulo L, typically the same as N
iterations =1000;  % Number of iterations
% Initialize CML and the dynamic coupling variable e_n
b=3.99;
%e_n = rand(1, N);    % Initialize e_n with random values
%e_n = zeros(1, N); 
% Parameters for the bifurcation diagram
a_range = 0:0.01:4;  
a_points = length(a_range);  
x0_values = zeros(iterations, a_points);  % Store bifurcation points
%x_new = zeros(1, N);  % Prepare new state
% CML Iteration with new custom map
for j = 1:a_points
    a = a_range(j);
    % rng(1); % 设置随机数种子
      x = rand(1, N);      % Initial state, random value
   
    e=0.5;
   x_new = zeros(1, N);  % Prepare new state
    for iter = 1:iterations
        %x_new = zeros(1, N);  % Prepare new state
        %e_new = zeros(1, N);  % Prepare new e_n state
        for i = 1:N
            left = mod(i-2, L) + 1;    % 左邻居
                right = mod(i, L) + 1;     % 右邻居
            % Calculate j and k according to the given matrix
            j_idx = mod(1 * i + p * i, L) + 1;  % mod(L) ensures periodic boundary conditions
            k_idx = mod(q_matrix * i + (p * q_matrix + 1) * i, L) + 1;
   
            f_x_i =mod(100*sin((pi*x(i))^a)*exp(26*(1-x(i))),1);
            f_x_neighbors = mod(100*sin((pi*sqrt(x(left)*x(j_idx)))^a)*exp(26*(1-sqrt(x(left)*x(j_idx)))),1)...
                                             +mod(100*sin((pi*sqrt(x(right)*x(k_idx)))^a)*exp(26*(1-sqrt(x(right)*x(k_idx)))),1);
         %f_x_i = a * x(i) * (1 - x(i));  %原式
           %f_x_neighbors = a * sqrt(x(left) * x(j_idx)) * (1 - sqrt(x(left) * x(j_idx))) ...
                          %  + a * sqrt(x(right) * x(k_idx)) * (1 - sqrt(x(right) * x(k_idx)));             
          % f_x_i = b*log2(1+sin(pi*(a * x(i) * (1 - x(i)))))*(1-log2(1+sin(pi*(a * x(i) * (1 - x(i))))));
          %        f_x_neighbors = a * log2(1+sqrt(x(left)*x(j_idx))) * (1 -  log2(1+sqrt(x(left)*x(j_idx)))) ...
          %                + a * log2(1+sqrt(x(right)*x(k_idx))) * (1 -  log2(1+sqrt(x(right)*x(k_idx))));  
                  
                 
                       %x_new(i) = (1 - e_n(i)) * f_x_i + e_n(i) / 2 * f_x_neighbors;
             x_new(i) = (1 - e) * f_x_i + (e / 2) * f_x_neighbors;
           % e= q * e * (1 - e);
        end
        e= q * e * (1 - e);
         %e= q * log2(1+e) * (1 - log2(1+e));
        % Update the state for the next iteration
        x = x_new;
        % e= q * e * (1 - e);
        % Store bifurcation point (e.g., the central site)
        if iter > 150
            x0_values(iter, j) = x(ceil(N / 2));
        end
    end
end

% Plot the bifurcation diagram
figure;
hold on;
for j = 1:a_points
  plot(a_range(j) * ones(1,850), x0_values(151:end, j), '.', 'MarkerEdgeColor', '[0.7, 0, 0]','MarkerSize', 4);  
end
% grid on;
% title('Bifurcation Diagram with NPDCML');
% xlabel('a');
% ylabel('x(n)');
% xlim([3.4,4]);
grid on;
hold off;  
 set(groot, 'DefaultAxesFontSize', 12);
% ax = gca;
% ax.XAxis.FontSize = 12;
% 
% % 设置y轴刻度标签字体大小
% ax.YAxis.FontSize = 12;
%xticks(0:1:4);
yticks(0:0.2:1);
xlabel('\fontname{Times new roman}a', 'FontSize', 23, 'FontWeight', 'normal','FontAngle', 'italic') % 设置x轴标签%  \theta \alpha \beta \mu \eta
ylabel(['\fontname{Times New Roman}\it x_i', '\rm (n)'], 'FontSize', 23, 'FontWeight', 'normal')
title('Bifurcation Diagram with NPDCML');
%title('Bifurcation Diagram with LLSLC-NPDCML');

