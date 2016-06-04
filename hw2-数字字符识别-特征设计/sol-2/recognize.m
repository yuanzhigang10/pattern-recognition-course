function match = recognize(test_img, train_img, centroid, idx, thres)
% 根据模式的知识, 对测试图像进行模式识别

%% 获取模板大小信息
num = length(train_img);
size_mat = zeros(num, 2);
for i = 1 : num
    size_mat(i,:) = size(train_img{i});
end
size_max = max(size_mat); % 用最大模板尺寸作为扫描窗大小
h = size_max(1);
w = size_max(2);

%% 扫描窗，数字识别
match = [];
% test_img(end+10, end+10) = 0;
[H, W] = size(test_img);
mask = zeros(H, W); % 防止重复判别的mask
for i = 1 : H-h+1
    for j = 1 : W-w+1
        % 判断该区域是否已经识别出数字
        mask_blk = mask(i:i+h-1, j:j+w-1);
        if sum(mask_blk(:)) > thres(1) * numel(mask_blk)
            continue
        end
        
        % 对该区域用每个模板匹配
        dist1 = zeros(num, 1);
        dist2 = zeros(num, 1);
        for k = 1 : num
            img_blk = test_img(i:i+size_mat(k,1)-1, j:j+size_mat(k,2)-1);
            dist1(k) = cal_dist1(img_blk, train_img{k});
            dist2(k) = cal_dist2(img_blk, centroid{k});
        end
        dist = thres(2)*dist1 + (1-thres(2))*dist2;
        % disp([i, j, min(dist1), min(dist2), min(dist)]);
        
        % 根据阈值判定是否成功匹配
        if min(dist) < thres(3)
            min_idx = find(dist == min(dist));
            min_idx = min_idx(1);
            mask(i:i+h-1, j:j+w-1) = 1; % 处理mask
            match = [match; ...
                floor(i+h/2), floor(j+w/2), idx(min_idx)];
            % disp(match(end,:));
        end
        
    end
end
% subplot(2,1,2); imshow(mask);

end

