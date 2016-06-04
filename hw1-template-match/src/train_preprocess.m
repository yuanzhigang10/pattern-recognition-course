function [train_img_bin, pattern_size] = train_preprocess(train_path, idx)
% ��ѵ��ģ�����Ԥ����ͳһ��С����ֵ��

num  = length(idx);
size_mat = zeros(num, 2);

for i = 1 : num
    eval(['img=imread(''',train_path,num2str(idx(i)),'.bmp'');']);
    size_mat(i,:) = size(img);
end

pattern_size = max(size_mat);
train_img_bin = ones(pattern_size(1), pattern_size(2), num);
% figure;
for i = 1 : num
    eval(['img=imread(''',train_path,num2str(idx(i)),'.bmp'');']);
    bin_temp = im2bw(img, graythresh(img));
    % ���ܲ��㣬ͳһģ���С
    [h, w] = size(bin_temp);
    dh = floor((pattern_size(1)-h) / 2);
    dw = floor((pattern_size(2)-w) / 2);
    train_img_bin(dh+1:dh+h, dw+1:dw+w, i) = bin_temp;
    
    % subplot(2,num,i);
    % imshow(train_img_bin(:,:,i));
end

end

