clear all; close all; clc;

%% data
data1 = [2 0; 2 2; 2 4; 3 3];
data2 = [0 3; -2 2; -1 -1; 1 -2; 3 -1];
p1 = 0.5; p2 = 0.5;
data = [data1; data2];
range = [min(data(:,1))-1 max(data(:,1))+1 min(data(:,2))-1 max(data(:,2))+1];

%% Bayesian Classification
M1 = mean(data1, 1); M2 = mean(data2, 1);
N1 = size(data1, 1); N2 = size(data2, 1);
sig1 = 1/N1 * (data1 - repmat(M1,N1,1))' * (data1 - repmat(M1,N1,1));
sig2 = 1/N2 * (data2 - repmat(M2,N2,1))' * (data2 - repmat(M2,N2,1));
W1 = -0.5 * sig1^(-1); W2 = -0.5 * sig2^(-1);
w1 = sig1 \ M1'; w2 = sig2 \ M2';
w10 = -0.5*M1/sig1*M1' - 0.5*log(det(sig1)) + log(p1);
w20 = -0.5*M2/sig2*M2' - 0.5*log(det(sig2)) + log(p2);
% 显示结果并作图
fprintf('d1(x1,x2) = (%f)*x1^2 + (%f)*x2^2 + (%f)*x1*x2 + (%f)*x1 + (%f)*x2 + (%f)\n', ...
    W1(1,1), W1(2,2), W1(1,2)+ W1(2,1), w1(1), w1(2), w10);
fprintf('d2(x1,x2) = (%f)*x1^2 + (%f)*x2^2 + (%f)*x1*x2 + (%f)*x1 + (%f)*x2 + (%f)\n', ...
    W2(1,1), W2(2,2), W2(1,2)+ W2(2,1), w2(1), w2(2), w20);
W = W1 - W2; w = w1 - w2; w0 = w10 - w20; % paras of sep-hyperplane
% X^T*W*X + w^T*X + w0 = 0
fprintf('(%f)*x1^2 + (%f)*x2^2 + (%f)*x1*x2 + (%f)*x1 + (%f)*x2 + (%f) = 0\n', ...
    W(1,1), W(2,2), W(1,2)+ W(2,1), w(1), w(2), w0);
sep = sprintf('(%f)*x1^2 + (%f)*x2^2 + (%f)*x1*x2 + (%f)*x1 + (%f)*x2 + (%f)', ...
    W(1,1), W(2,2), W(1,2)+ W(2,1), w(1), w(2), w0);
figure; hold on;
plot(data1(:,1), data1(:,2), '*');
plot(data2(:,1), data2(:,2), 'o');
h = ezplot(sep, [-3 5]); set(h, 'color', 'b', 'linewidth', 1.5);
axis(range); axis equal;
legend('data 1', 'data 2', 'sep-hyperplane');
title('Bayesian Classification under Gaussian distributions');

%% Cluster Hierarchy
classes = 1;
N = size(data, 1);
labels = 1 : N;
datadist = pdist2(data, data); % 所有数据点之间的距离信息
figure;
for i = 1 : N
    hold on;
    text(data(i,1), data(i,2), num2str(labels(i)));
end
axis(range); axis equal;
title(['class num: ', num2str(N), ' (original data)']);
% 将结果写入gif
frame = getframe();
im = frame2im(frame);
[X, map] = rgb2ind(im,256);
imwrite(X, map, 'hierarchy.gif', 'gif', 'Loopcount', inf, 'DelayTime', 2);
% 分层聚类
for count = N : -1 : classes+1
    %% 更新距离
    classdist = ones(count) * inf; % 初始化为最大值
    for i = 1 : N-1
        for j = i+1 : N
            if labels(i) == labels(j)
                continue
            else
                dist = datadist(i, j);
                % 仅维护类距离矩阵的上三角阵即可
                lblmin = min(labels(i), labels(j));
                lblmax = max(labels(i), labels(j));
                if classdist(lblmin, lblmax) < dist || classdist(lblmin, lblmax) == inf
                    classdist(lblmin, lblmax) = dist; % 更新
                end
            end
        end
    end
    % 找到距离矩阵中的最小值，准备合并
    [row, col] = find(classdist==min(classdist(:)) & classdist>0, 1);
    %% 合并
    for i = 1 : N
        if labels(i) == col % 需要被合并的数据
            labels(i) = row; % 用row（更小的类标）更新
            disp([num2str(i), ': ', num2str(col), ' --> ', num2str(row)]);
        end
        if labels(i) > col
            labels(i) = labels(i) - 1; % 减少了1个类，类标相应减1
        end
    end
    figure; hold on;
    for i = 1 : N
        hold on;
        text(data(i,1), data(i,2), num2str(labels(i)));
    end
    axis(range); axis equal;
    title(['class num: ', num2str(count-1)]);
    % 将结果写入gif
    frame = getframe();
    im = frame2im(frame);
    [X, map] = rgb2ind(im,256);
    imwrite(X, map, 'hierarchy.gif', 'gif', 'WriteMode', 'append', 'DelayTime', 1);
end

%% end of script