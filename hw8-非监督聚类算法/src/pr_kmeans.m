function [labels, centers, errors, initseeds] = pr_kmeans(data, k, auto, seeds)
% k-means���ຯ��
% inputs:
%   data:   ԭʼ����
%   k:      ������
%   auto:   �Ƿ��Զ�ѡȡ������ʼ�㣬1�������ѡȡ��0�����seedsָ��
%   seeds:  ָ���ĵ�����ʼ�㣬��anto=1ʱ�ò���������
% outputs:
%   labels:     ���������ݵ����꣬��data���Ӧ
%   centers:    �������������
%   errors:     ���ƽ����
%   initseeds:  ��ʼ�ĵ����㣬auto=1ʱ�������¼�����ѡȡ�ĳ�ʼ������
[num, ~] = size(data);

% ѡȡ������ʼ��
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
% k-means����
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