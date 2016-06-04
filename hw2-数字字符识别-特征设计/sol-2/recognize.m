function match = recognize(test_img, train_img, centroid, idx, thres)
% ����ģʽ��֪ʶ, �Բ���ͼ�����ģʽʶ��

%% ��ȡģ���С��Ϣ
num = length(train_img);
size_mat = zeros(num, 2);
for i = 1 : num
    size_mat(i,:) = size(train_img{i});
end
size_max = max(size_mat); % �����ģ��ߴ���Ϊɨ�贰��С
h = size_max(1);
w = size_max(2);

%% ɨ�贰������ʶ��
match = [];
% test_img(end+10, end+10) = 0;
[H, W] = size(test_img);
mask = zeros(H, W); % ��ֹ�ظ��б��mask
for i = 1 : H-h+1
    for j = 1 : W-w+1
        % �жϸ������Ƿ��Ѿ�ʶ�������
        mask_blk = mask(i:i+h-1, j:j+w-1);
        if sum(mask_blk(:)) > thres(1) * numel(mask_blk)
            continue
        end
        
        % �Ը�������ÿ��ģ��ƥ��
        dist1 = zeros(num, 1);
        dist2 = zeros(num, 1);
        for k = 1 : num
            img_blk = test_img(i:i+size_mat(k,1)-1, j:j+size_mat(k,2)-1);
            dist1(k) = cal_dist1(img_blk, train_img{k});
            dist2(k) = cal_dist2(img_blk, centroid{k});
        end
        dist = thres(2)*dist1 + (1-thres(2))*dist2;
        % disp([i, j, min(dist1), min(dist2), min(dist)]);
        
        % ������ֵ�ж��Ƿ�ɹ�ƥ��
        if min(dist) < thres(3)
            min_idx = find(dist == min(dist));
            min_idx = min_idx(1);
            mask(i:i+h-1, j:j+w-1) = 1; % ����mask
            match = [match; ...
                floor(i+h/2), floor(j+w/2), idx(min_idx)];
            % disp(match(end,:));
        end
        
    end
end
% subplot(2,1,2); imshow(mask);

end

