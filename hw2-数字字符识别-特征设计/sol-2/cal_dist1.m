function dist = cal_dist1(img_blk, train_img)
% dist1(k) = cal_dist1(img_blk, train_img{k});

[~, w] = size(img_blk);
halfw = floor(w/2);

% 逐行统计
test_sum = [sum(img_blk(:,1:halfw),2); sum(img_blk(:,halfw+1:end),2)];
train_sum = [sum(train_img(:,1:halfw),2); sum(train_img(:,halfw+1:end),2)];
% 归一化
test_sum = test_sum / norm(test_sum);
train_sum = train_sum / norm(train_sum);

dist = norm(test_sum - train_sum);

end