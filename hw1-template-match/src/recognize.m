function match = recognize(test_img, train_img_bin, pattern_size, thres, idx)
% ����ģʽ��֪ʶ, �Բ���ͼ�����ģʽʶ��

%% ģ���С
h = pattern_size(1);
w = pattern_size(2);

%% ������ͼ���ֵ��
% figure;
% subplot(2,1,1); imshow(test_img);
test_img_bin = binarization(test_img);
% subplot(2,1,2); imshow(test_img_bin);

%% ��ͼƬ��Χ����
[H_, W_] = size(test_img_bin);
img_resize = ones(H_+20, W_+20);
img_resize(11:H_+10, 11:W_+10) = test_img_bin;
[H, W] = size(img_resize);
mask = zeros(H, W);
match = [];

%% ɨ�贰ƥ��
for i = 1 : H-h+1
    for j = 1 : W-w+1
        % �жϸ������Ƿ��Ѿ�ʶ�������
        mask_blk = mask(i:i+h-1, j:j+w-1); 
        if sum(mask_blk(:)) > thres(1) * numel(mask_blk)
           continue
        end
        % �Ը�������ÿ��ģ��ƥ��
        img_blk = img_resize(i:i+h-1, j:j+w-1);
        similarity = zeros(length(idx), 1);
        for k = 1 : length(idx)
            similarity(k) = cal_similarity(~train_img_bin(:,:,k), ~img_blk);
        end
        % ������ֵ�ж��Ƿ�ɹ�ƥ��
        [sort_sim, sort_idx] = sort(similarity, 'descend');
        if (sort_sim(1) > thres(2)) && (sort_sim(1)-sort_sim(2) > thres(3))
            mask(i:i+h-1, j:j+w-1) = 1;
            match = [match; floor(i-10+h/2), floor(j-10+w/2), idx(sort_idx(1))];
        end
    end
end

% figure;
% subplot(2,1,1); imshow(img_resize);
% subplot(2,1,2); imshow(mask);

end

