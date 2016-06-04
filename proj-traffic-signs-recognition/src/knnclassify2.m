function [class, kdist] = knnclassify2(test, training, group, k)
% self-defined knn classify
% Input
%   test:       test data (num1-by-dim)
%   training:	train data (num2-by-dim)
%   group:      group of train data (num2-by-1)
%   k:          number of nearest neighbors (scalar)
% Output
%   target:     target label of test data (num1-by-1)
%   kdist:      the dist between test data and kNN (num1-by-1)
class = zeros(size(test,1), 1);
kdist = zeros(size(test,1), 1);
uni_lbl = unique(group); % get group info

%% kNN classify
for i = 1 : size(test, 1)
    lbl_cnt = zeros(size(uni_lbl)); % watch! must init here!
    data = test(i,:);
    datarep = repmat(data, length(training), 1);
    dist = sum(abs(training-datarep).^2, 2) .^ (1/2); % distance vector
    [sort_dist, sort_idx] = sort(dist); % sort distance vector
    for j = 1 : k % k nearest neighbors
        lbl = group(sort_idx(j)); % group of kNN
        lbl_cnt(uni_lbl==lbl) = lbl_cnt(uni_lbl==lbl) + 1;
    end
    tar_tmp = find(lbl_cnt == max(lbl_cnt));
    if length(tar_tmp) > 1
        tar_tmp = tar_tmp(1); % choose the first one
    end
    % get the target label
    class(i) = tar_tmp;
    kdist(i) = mean(sort_dist(1:k)); % mean distance of kNN
end

%% cal the dist between test data and kNN, for threshold
% kdist is normalized within each class
max_kdist = zeros(size(uni_lbl));
for i = 1 : length(uni_lbl)
    max_kdist(i) = max(kdist(class == uni_lbl(i)));
end
for i = 1 : length(kdist)
    kdist(i) = kdist(i) / max_kdist(class(i) == uni_lbl);
end

end