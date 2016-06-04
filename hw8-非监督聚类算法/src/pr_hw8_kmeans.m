clear all; close all; clc;
%% data
data = load('testSet.txt');
range = [min(data(:,1))-1 max(data(:,1))+1 min(data(:,2))-1 max(data(:,2))+1];
color = ['r', 'g', 'b', 'k'];

%% k = 3
k = 3;
auto = 0;
givenseeds = {
    [-4.822 4.607;-0.7188 -2.493;4.377 4.864]
    [-3.594 2.857;-0.6595 3.111;3.998 2.519]
    [-0.7188 -2.493;0.8458 -3.59;1.149 3.345]
    [-3.276 1.577;3.275 2.958;4.377 4.864]
    };
for i = 1 : 4
    seeds = givenseeds{i};
    % k-means聚类
    [labels, centers, errors, ~] = pr_kmeans(data, k, auto, seeds);
    disp(length(errors)); disp(errors(end));
    figure; hold on;
    % 作图显示
    for label = 1 : k
        datak = data(labels==label, :);
        plot(datak(:,1), datak(:,2), [color(label), '*']);
        plot(seeds(label,1), seeds(label,2), [color(label), 'o'], ...
            'markersize', 8);
        plot(centers(label,1), centers(label,2), [color(label), 'o'], ...
            'markerfacecolor', color(label), 'markersize', 8);
        title(['k = 3, given seeds ', num2str(i)]);
        axis(range); axis equal;
    end
end

%% k = 2, 4
for k = [2 2 2 4 4 4]
    auto = 1; % 自动随机选取初始迭代点
    [labels, centers, errors, initseeds] = pr_kmeans(data, k, auto, []);
    disp(length(errors)); disp(errors(end));
    figure; hold on;
    for label = 1 : k
        datak = data(labels==label, :);
        plot(datak(:,1), datak(:,2), [color(label), '*']);
        plot(initseeds(label,1), initseeds(label,2), [color(label), 'o'], ...
            'markersize', 8);
        plot(centers(label,1), centers(label,2), [color(label), 'o'], ...
            'markerfacecolor', color(label), 'markersize', 8);
        title(['k = ', num2str(k), ', random seeds']);
        axis(range); axis equal;
    end
end

%% end