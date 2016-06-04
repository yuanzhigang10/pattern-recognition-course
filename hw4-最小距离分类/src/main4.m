% main4s.m
% 根据距中心最小距离分类
clear all; close all; clc;

%% dataset
dataset1 = [2 3; 2 2; 2 4; 3 3; 3 4; 2.5 3; 1.5 2; 3.5 2.5; 4 4; 0.5 0.5];
dataset2 = [0 2.5; -2 2; -1 -1; 1 -2; 3 0; -2 -2; -3 -4; -5 -2; 4 -1];

%% get mass
m1 = mean(dataset1);
m2 = mean(dataset2);

%% get sep-hyper
dm = m1 - m2;
bias = 0.5 * (m1*m1' - m2*m2');
line = [mat2str(dm(1)),'*x1+',mat2str(dm(2)),'*x2-',mat2str(bias),'=0'];
figure; hold on;
h = ezplot(line,[-8,8,-8,8]);
set(h,'Color','b');

%% output
fprintf(['sep-hyper:\n',line,'\n\n']);
fprintf('bias1: %.4f\n', -0.5*norm(m1)^2);
fprintf('bias2: %.4f\n\n', -0.5*norm(m2)^2);

%% classify and plot
for i = 1 : size(dataset1, 1)
    plot(dataset1(i,1), dataset1(i,2), 'r*');
    if norm(dataset1(i,:)-m1) > norm(dataset1(i,:)-m2) % false
        plot(dataset1(i,1), dataset1(i,2), 'co');
    end
end
for i = 1 : size(dataset2, 1)
    plot(dataset2(i,1), dataset2(i,2), 'k*');
    if norm(dataset2(i,:)-m1) < norm(dataset2(i,:)-m2) % false
        plot(dataset2(i,1), dataset2(i,2), 'co');
    end
end

%% plot others
k1 = (m2(2) - m1(2)) / (m2(1) - m1(1));
k2 = -1 / k1;
mid = (m1 + m2) / 2;
left = min(m1(1), m2(1)); % border of masses
right = max(m1(1), m2(1));
xref = left : 0.1 : right;
yref = k1 * (xref - mid(1)) + mid(2);

plot(m1(1), m1(2), 'ro', 'MarkerFaceColor', 'r');
plot(m2(1), m2(2), 'ko', 'MarkerFaceColor', 'k');
plot(xref, yref, 'b-.');
axis equal;

%% end