function target = knn(test, training, group, k)
% knn classify
% Input
%   test:       test data (num1-by-dim)
%   training:	train data (num2-by-dim)
%   group:      group of train data (num2-by-1)
%   k:          number of nearest neighbors (scalar)
% Output
%   target:     target label of test data (num1-by-1)
target = zeros(size(test,1), 1);
unilbl = unique(group); % get group info
for i = 1 : size(test, 1)
    lblcnt = zeros(size(unilbl)); % watch! must init here!
    data = test(i,:);
    datarep = repmat(data, length(training), 1);
    dist = sum(abs(training-datarep).^2, 2) .^ (1/2); % distance vector
    [~, sortidx] = sort(dist); % sort distance vector
    for j = 1 : k % k nearest neighbors
        lbl = group(sortidx(j)); % group of kNN
        lblcnt(unilbl==lbl) = lblcnt(unilbl==lbl) + 1;
    end
    tartmp = find(lblcnt == max(lblcnt));
    if length(tartmp) > 1
        tartmp = 1; % if the number of two labels are equal
    end
    % get the target label
    target(i) = tartmp;
end

end