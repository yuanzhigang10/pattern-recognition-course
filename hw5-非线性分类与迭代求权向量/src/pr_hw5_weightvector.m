clear all; close all; clc;

%% data
data1 = [1 1; 2 0; 2 1; 0 2; 1 3];
data2 = [-1 2; 0 0; -1 0; -1 -1; 0 -2];
% extended data
data1 = [data1, ones(length(data1),1)];
data2 = [data2, ones(length(data2),1)];
zmat = [data1; -data2];

%% method1
w1 = [1 1 1];
c = 1;
count = 0;
while count < 100 % iter times constraint
    allpos = 1;
    for i = 1 : size(zmat,1)
        z = zmat(i,:);
        if w1*z' <= 0
            allpos = 0;
            w1 = w1 + c*z; % update weight
            count = count + 1;
        end
    end
    if allpos == 1
        break;
    end
end
disp(['w1 = ', mat2str(w1)]);
disp(['iter count = ', num2str(count)]);

%% method2
w2 = [1 1 1];
count = 0;
while count < 100 % iter times constraint
    posneg = w2 * zmat';
    negidx = find(posneg <= 0);
    if isempty(negidx)
        break;
    end
    zmean = mean(zmat(negidx,:), 1);
    c = -(w2*zmean')/(zmean*zmean') + 1;
    w2 = w2 + c*zmean;
    count = count + 1;
end
disp(['w2 = ', mat2str(w2)]);
disp(['iter count = ', num2str(count)]);

%% show result
figure; hold on;
plot(data1(:,1), data1(:,2), 'mo');
plot(data2(:,1), data2(:,2), 'r*');
f1 = @(x1, x2) w1(1)*x1 + w1(2)*x2 + w1(3);
h1 = ezplot(f1); set(h1, 'Color', 'b', 'LineWidth', 2);
f2 = @(x1, x2) w2(1)*x1 + w2(2)*x2 + w2(3);
h2 = ezplot(f2); set(h2, 'Color', 'g', 'LineWidth', 2);
axis([-4 4 -4 4]);
title('linear classifier');
legend('data 1','data 2','result of alg 1','result of alg 2');

%% end