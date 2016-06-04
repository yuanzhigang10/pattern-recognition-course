function pattern = train_preprocess(train_path, idx, len)
% ��ѵ��ģ�����Ԥ����

num  = length(idx);
pattern = zeros(num, len);

figure;
for i = 1 : num
    eval(['img=imread(''',train_path,num2str(idx(i)),'.bmp'');']);
    img = im2bw(img, graythresh(img));
    img = img(:, sum(~img)~=0); % ȥ�����ұ�Ե�Ĵ���ɫ��
    %subplot(num/2,2,i);
    %imshow(img);
    
    row = sum(~img); % ͳ�Ƹ����к�ɫ���صĸ���
    row = resample(row, len, length(row));
    row(row < 0) = 1e-6;
    row = row / sum(row);
    
    pattern(i,:) = row;
    
    subplot(num/2,2,i);
    plot(row); title(['num ',num2str(idx(i))]);
end

end

