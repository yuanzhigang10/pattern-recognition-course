function [labels, centers, errors, initseeds] = pr_kmeans(data, k, auto, seeds)
% k-means聚类函数
% inputs:
%   data:   原始数据
%   k:      类别个数
%   auto:   是否自动选取迭代初始点，1代表随机选取，0则根据seeds指定
%   seeds:  指定的迭代初始点，当anto=1时该参数无意义
% outputs:
%   labels:     聚类后各数据点的类标，与data相对应
%   centers:    各个聚类的重心
%   errors:     误差平方和
%   initseeds:  初始的迭代点，auto=1时该输出记录了随机选取的初始迭代点
[num, ~] = size(data);

% 选取迭代初始点
if auto
    ind = randperm(num);
    ind = ind(1:k);
    centers = data(ind, :);
    initseeds = centers;
else
    centers = seeds;
    initseeds = seeds;
end

d = inf;
labels = nan(num, 1);
error = zeros(k, 1);
errors = [];
% k-means迭代
while d > 0
    labels0 = labels;
    dist = pdist2(data, centers);
    [~, labels] = min(dist, [], 2);
    d = sum(labels0 ~= labels);
    for i = 1:k
        centers(i,:) = mean(data(labels==i, :), 1);
        error(i) = sum(pdist2(data(labels==i, :), centers(i,:)).^2);
    end
    errors =  [errors; sum(error)];
end

end