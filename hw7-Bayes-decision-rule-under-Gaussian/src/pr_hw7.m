clear all; close all; clc;

%% data
data1 = [3 4; 3 8; 2 6; 4 6];
data2 = [3 0; 3 -4; 1 -2; 5 -2];
p1 = 0.5;
p2 = 0.5;

%% calc
M1 = mean(data1, 1); M2 = mean(data2, 1);
N1 = size(data1, 1); N2 = size(data2, 1);
sig1 = 1/N1 * (data1 - repmat(M1,N1,1))' * (data1 - repmat(M1,N1,1));
sig2 = 1/N2 * (data2 - repmat(M2,N2,1))' * (data2 - repmat(M2,N2,1));
W1 = -0.5 * sig1^(-1); W2 = -0.5 * sig2^(-1);
w1 = sig1 \ M1'; w2 = sig2 \ M2';
w10 = -0.5*M1/sig1*M1' - 0.5*log(det(sig1)) + log(p1);
w20 = -0.5*M2/sig2*M2' - 0.5*log(det(sig2)) + log(p2);

%% disp and show
fprintf('d1(x1,x2) = (%f)*x1^2 + (%f)*x2^2 + (%f)*x1 + (%f)*x2 + (%f)\n', ...
    W1(1,1), W1(2,2), w1(1), w1(2), w10);
fprintf('d2(x1,x2) = (%f)*x1^2 + (%f)*x2^2 + (%f)*x1 + (%f)*x2 + (%f)\n', ...
    W2(1,1), W2(2,2), w2(1), w2(2), w20);
W = W1 - W2; w = w1 - w2; w0 = w10 - w20; % paras of sep-hyperplane
% X^T*W*X + w^T*X + w0 = 0
fprintf('(%f)*x1^2 + (%f)*x2^2 + (%f)*x1 + (%f)*x2 + (%f) = 0\n', ...
    W(1,1), W(2,2), w(1), w(2), w0);
sep = sprintf('(%f)*x1^2 + (%f)*x2^2 + (%f)*x1 + (%f)*x2 + (%f)', ...
    W(1,1), W(2,2), w(1), w(2), w0);
figure; hold on; axis equal;
plot(data1(:,1), data1(:,2), 'ro', 'markerfacecolor', 'r');
plot(data2(:,1), data2(:,2), 'g^', 'markerfacecolor', 'g');
h = ezplot(sep); ylim([-5 9]);
set(h, 'color', 'b', 'linewidth', 1.5)
legend('data 1', 'data 2', 'sep-hyperplane');
title('Bayesian Classification under Gaussian distributions');

%% end of script