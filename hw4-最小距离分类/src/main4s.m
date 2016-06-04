% main4s.m
% 根据垂直平分线分类
clear all; close all; clc;

%% dataset
dataset1 = [2 3; 2 2; 2 4; 3 3; 3 4; 2.5 3; 1.5 2; 3.5 2.5; 4 4; 0.5 0.5];
dataset2 = [0 2.5; -2 2; -1 -1; 1 -2; 3 0; -2 -2; -3 -4; -5 -2; 4 -1];

%% get mass
m1 = mean(dataset1);
m2 = mean(dataset2);

%% get paras of sep-hyper
k1 = (m2(2) - m1(2)) / (m2(1) - m1(1));
k2 = -1 / k1;
mid = (m1 + m2) / 2;

%% data for plot
left = min(m1(1), m2(1)); % border of masses
right = max(m1(1), m2(1));
xref = left : 0.1 : right;
yref = k1 * (xref - mid(1)) + mid(2);
x = -8 : 0.1 : 8;
y = k2 * (x - mid(1)) + mid(2); % sep-hyper

%% find fasle points
sign1 = dataset1(:,2) - (k2*(dataset1(:,1)-mid(1)) + mid(2));
sign2 = dataset2(:,2) - (k2*(dataset2(:,1)-mid(1)) + mid(2));
signref1 = m1(2) - (k2*(m1(1)-mid(1)) + mid(2));
signref2 = m2(2) - (k2*(m2(1)-mid(1)) + mid(2));
falsedata1 = dataset1(sign1*signref1 < 0, :);
falsedata2 = dataset2(sign2*signref2 < 0, :);

%% output
fprintf('paras for sep-hyper:\n');
fprintf('k = %.4f  b = %.4f\n', k2, -k2*mid(1)+mid(2));

%% plot
figure; hold on;
plot(dataset1(:,1), dataset1(:,2), 'r*');
plot(dataset2(:,1), dataset2(:,2), 'k*');
plot(m1(1), m1(2), 'ro', 'MarkerFaceColor', 'r');
plot(m2(1), m2(2), 'ko', 'MarkerFaceColor', 'k');
plot(xref, yref, '-.');
plot(x, y);
plot(falsedata1(:,1), falsedata1(:,2), 'co');
plot(falsedata2(:,1), falsedata2(:,2), 'co');
axis equal;
legend('dataset1', 'dataset2','mass of data1', 'mass of data2' , ...
    'line between masses', 'sep hyper', 'false classified');

%% end