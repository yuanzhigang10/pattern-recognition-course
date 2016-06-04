function match = recognize(test_img, pattern, idx)
% 根据模式的知识, 对测试图像进行模式识别

%% 将测试图像二值化
% figure;
% subplot(2,1,1); imshow(test_img);
test_img = binarization(test_img);
% subplot(2,1,2); imshow(test_img_bin);

[H, W] = size(test_img);
[M, N] = size(pattern);
h = floor(H * 0.55);
hcen = [floor((1+h)/2), floor((h+1+H)/2)];
line = [1, h; h+1, H];
%% 匹配
match = [];
for i = 1:2
    img = test_img(line(i,1):line(i,2), :);
    row = [0,0, sum(~img), 0,0];
    % 将值域映射为[0,1]
    row = (row - min(row)) / (max(row) - min(row));
    % 找到可能是数字的位置
    start_idx = find(row~=0 & [0,row(1:end-1)]==0);
    end_idx = find(row==0 & [0,row(1:end-1)]~=0) - 1;
    
    for j = 1 : length(start_idx)
        seg = row(start_idx(j):end_idx(j));
        if (max(seg) < 0.3) || ((end_idx(j)-start_idx(j))/W < 0.02)
            continue;
        end
        left = start_idx(j);
        right = end_idx(j);
        seg = resample(seg, N, length(seg));
        seg(seg < 0) = 1e-6;
        seg = seg / sum(seg); % 将每个片段归一为概率分布
        % 逐模板进行匹配
        kldist = zeros(M, 1);
        for k = 1 : M
            kldist(k) = kldiv(seg, pattern(k,:));
        end
        % 找出分布最相近的数字
        result = idx(kldist==min(kldist));
        % disp([start_idx(j), end_idx(j), result]);
        match = [match; hcen(i),floor((left+right)/2),result];
    end  
end

end

