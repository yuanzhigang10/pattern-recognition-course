function pattern = train_preprocess(train_path, idx, len)
% 对训练模板进行预处理

num  = length(idx);
pattern = zeros(num, len);

figure;
for i = 1 : num
    eval(['img=imread(''',train_path,num2str(idx(i)),'.bmp'');']);
    img = im2bw(img, graythresh(img));
    img = img(:, sum(~img)~=0); % 去除左右边缘的纯白色区
    %subplot(num/2,2,i);
    %imshow(img);
    
    row = sum(~img); % 统计各列中黑色像素的个数
    row = resample(row, len, length(row));
    row(row < 0) = 1e-6;
    row = row / sum(row);
    
    pattern(i,:) = row;
    
    subplot(num/2,2,i);
    plot(row); title(['num ',num2str(idx(i))]);
end

end

