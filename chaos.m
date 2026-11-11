clear;  
clc;  
close all;  
  
% 分岔图  
% 离散系统：正弦映射 x_{n+1} = a * sin(pi * x_n)  
%a = 0:0.001:20;   
a = 0:0.0005:10;   
% 选取最后NT次结果  
NT = 300;  
Na = length(a);  
  
% 初始化分岔图数据  
BF_x = zeros(Na, NT);  
  
% 迭代过程  
for k = 1:Na  
    a_k = a(k);  
    % 初始值取0.55  
    x = 0.55;  
   
    % 先初始迭代200次，避免初始值选取引起的干扰  
    for m = 1:200  
            % x=mod(10*sin((10+20*a_k)*4*pi*(1-x)*x),1);
              x=mod(100*sin((pi*x)^a_k)*exp(26*(1-x)),1);
           
    end  
      
    % 然后再迭代NT次，保存结果  
    for m = 1:NT  
       % BF_x(k, m) =3.99*log2(1+sin(pi*a_k*x*(1-x)))*(1-log2(1+sin(pi*a_k*x*(1-x))));  
       %BF_x(k, m) = sin(pi*a_k*x*(1-x));  
       %BF_x(k, m)=mod(5*cos(a_k*pi*x*(1-x))+4*sin(13*x),1);
       % BF_x(k, m)=mod(10*sin((10+20*a_k)*4*pi*(1-x)*x),1);

           BF_x(k, m)=mod(100*sin((pi*x)^a_k)*exp(26*(1-x)),1);
     
    
        x = BF_x(k, m); % 更新x为下一次迭代做准备  
    end  
end  
  
% 分岔图，用x绘图  
figure;  
hold on;  
for k = 1:Na  
    plot(repmat(a(k), 1, NT), BF_x(k, :), '.b');  
end  
hold off;  
 set(groot, 'DefaultAxesFontSize', 12);
% ax = gca;
% ax.XAxis.FontSize = 12;
% 
% % 设置y轴刻度标签字体大小
% ax.YAxis.FontSize = 12;
%xticks(0:1:4);
yticks(0:0.2:1);
xlabel('\fontname{Times new roman}\gamma', 'FontSize', 25, 'FontWeight', 'normal','FontAngle', 'italic') % 设置x轴标签%  \theta \alpha \beta \mu \eta
ylabel('\fontname{Times new roman}x_i', 'FontSize', 25, 'FontWeight', 'normal','FontAngle', 'italic') % 设置y轴标签

