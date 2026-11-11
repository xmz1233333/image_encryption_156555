clear; clc; close all;

% 参数设置
a_values = 0:0.01:4;    % 扫描参数 a
na       = numel(a_values);
N_total  = 2000;         % 总迭代步数
N_trans  = 500;          % 丢弃前 N_trans 步热身
LE       = zeros(na,1);

delta = 1e-8;            % 数值微分增量

for ia = 1:na
    a = a_values(ia);
    x = 0.1;  % 初值

    % 热身迭代
    for k = 1:N_trans
       % x=mod(10*sin((10+20*a)*4*pi*(1-x)*x),1);
       % x=mod(10*cos(a*pi*x*(1-x))+1*sin(10*x),1);
       %  x=mod(5*cos(a*pi*x*(1-x))+4*sin(5*x),1);
        %x=a*x*(1-x);

        x=mod(100*sin((pi*x)^a)*exp(26*(1-x)),1);%%1111

    end

    % 正式迭代并累加 log|f'|
    sum_log = 0;
    for k = 1:(N_total - N_trans)
        x1 = x;
        % 迭代函数 f(x1)
            x2=mod(100*sin((pi*x1)^a)*exp(26*(1-x1)),1);
            %x2=a*x1*(1-x1);
        % 数值微分估计导数 f'(x1)
        x1_perturbed = x1 + delta;
       x2_perturbed=mod(100*sin((pi*x1_perturbed)^a)*exp(26*(1-x1_perturbed)),1);
       %x2_perturbed=a*x1_perturbed*(1-x1_perturbed);
        deriv = (x2_perturbed - x2) / delta;
        deriv_abs = max(abs(deriv), 1e-12); % 防止 log(0)

        sum_log = sum_log + log(deriv_abs);

        % 更新迭代
        x = x2;
    end

    LE(ia) = sum_log / (N_total - N_trans);
end

% 绘图
figure;
plot(a_values, LE, 'Color', [0.2 0.6 1], 'LineWidth', 1.5);
hold on;
plot([0,1],[0,0],'k--','LineWidth',1);
%ylim([0, 1]);
xlabel('参数 a','FontSize',25);
ylabel('LE','FontSize',25);






grid on;
hold off;

