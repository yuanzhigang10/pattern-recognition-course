function [train_img, centroid] = train_preprocess(train_path, train_idx)
% ��ѵ��ģ�����Ԥ����

num  = length(train_idx);
size_mat = zeros(num, 2);

train_img = cell(num, 1);
centroid = cell(num, 1);

% figure;
for i = 1 : num
    eval(['img=imread(''',train_path,num2str(train_idx(i)),'.bmp'');']);
    size_mat(i,:) = size(img);
    train_img{i} = ~im2bw(img, graythresh(img));
%     subplot(1,num,i); imshow(train_img{i});
end

for i = 1 : num
    halfw = floor(size_mat(i,2)/2);
    centroid1 = zeros(size_mat(i,1), 1);
    centroid2 = zeros(size_mat(i,1), 1);
    for j = 1 : size_mat(i,1) % ���д�����������
        left = find(train_img{i}(j,1:halfw) == 1); % �ҵ���ߺ�����
        right = find(train_img{i}(j,halfw+1:end) == 1); % �ҵ��ұߺ�����
        if ~isempty(left)
            centroid1(j) = mean(left);
        end
        if ~isempty(right)
            centroid2(j) = mean(right);
        else
            centroid2(j) = halfw;
        end
    end
    temp = [centroid1; centroid2]; % ���һ������
    centroid{i} = temp / norm(temp); % ��һ��
end

end

