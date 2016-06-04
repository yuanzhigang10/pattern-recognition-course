clear all; close all; clc;

%% data
data1 = [1 2; 2 1; 2 3; 3 2];
data2 = [1 1; 1 3; 3 1; 3 3; 2 2];

%% solution 1
figure; hold on;
plot(data1(:,1), data1(:,2), 'ro', 'MarkerFaceColor', 'r');
plot(data2(:,1), data2(:,2), 'g^', 'MarkerFaceColor', 'g');

f1 = @(x, y) (x-2).^2 + (y-2).^2 - 0.5^2;
h1 = ezplot(f1); set(h1, 'color', 'b');
f2 = @(x, y) (x-2).^2 + (y-2).^2 - 1.2^2;
h2 = ezplot(f2); set(h2, 'color', 'm');

axis([0 4 0 4]); axis equal;
title('nonlinear classifier 1');
legend('data 1', 'data 2', 'c1', 'c2');

%% solution 2
figure; hold on;
plot(data1(:,1), data1(:,2), 'ro', 'MarkerFaceColor', 'r');
plot(data2(:,1), data2(:,2), 'g^', 'MarkerFaceColor', 'g');

f1 = @(x, y) (x-2).^2*3 - (y-2).^2*6 - 1;
h1 = ezplot(f1); set(h1, 'Color', 'b');
f2 = @(x, y) (y-2).^2*3 - (x-2).^2*6 - 1;
h2 = ezplot(f2); set(h2, 'Color', 'm');

axis([0 4 0 4]); axis equal;
title('nonlinear classifier 2');
legend('data 1', 'data 2', 'c1', 'c2');

%% solution 3
t = pi / 4;
rmat = [cos(t), -sin(t); sin(t), cos(t)];
data3 = data1 * rmat';
data4 = data2 * rmat';

figure; hold on;
plot(data1(:,1), data1(:,2), 'ro', 'MarkerFaceColor', 'r');
plot(data2(:,1), data2(:,2), 'g^', 'MarkerFaceColor', 'g');
plot(data3(:,1), data3(:,2), 'co', 'MarkerFaceColor', 'c');
plot(data4(:,1), data4(:,2), 'c^', 'MarkerFaceColor', 'c');
f1 = @(x, y) 2*sin(sqrt(2)*pi*x-pi/2)+2*sqrt(2) - y;
f2 = @(x, y) 2*sin(sqrt(2)*pi*(rmat(1,1)*x+rmat(1,2)*y)-pi/2)+2*sqrt(2) ...
    - (rmat(2,1)*x+rmat(2,2)*y);
h1 = ezplot(f1); set(h1, 'color', 'c');
h2 = ezplot(f2); set(h2, 'color', 'b');
axis([-2 5 0 6]);
axis equal;
title('nonlinear classifier 3');
legend('data 1', 'data 2', ...
    'data 1 after rotation', 'data 2 after rotation', ...
    'classifier after rotation', 'original classifier');

%% end