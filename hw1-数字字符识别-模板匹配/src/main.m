clear all; close all; clc;

%% ��������·��
train_path = 'train/';
test_path = 'test/';

%% Ԥ����ѵ������,���ģʽ��֪ʶ
idx = [0,1,2,3,4,6,8,9];
[train_img_bin, pattern_size] = train_preprocess(train_path, idx);

%% ����ʶ������е�Ԥ�ò���
thres = [0.01, 0.73, 0.05];

%% ��ͼƬ�е����ֽ���ʶ��
test = {'1','2','3','4','5','6','����','����'};
size_mat = zeros(length(test), 2);
for i = 1 : length(test)
    eval(['test_img=rgb2gray(imread(''',test_path,test{i},'.bmp''));']);
    size_mat(i,:) = size(test_img);
    
    if i == 7 % ���л���ͼƬ
        test_img = medfilt2(test_img); % ��ֵ�˲�
        thres = [0.01, 0.70, 0.05]; % ��������
    end
    if i == 8 % ��������ͼƬ
        test_img = medfilt2(test_img);
        thres = [0.01, 0.72, 0.05];
    end
    % ����ģʽ����ƥ��
    match = recognize(test_img, train_img_bin, pattern_size, thres, idx);
    % ����ƥ����
    [line1, line2, error_idx] = analysis_match(match);
    fprintf('%s.bmp\t\terror: %d\n', test{i}, length(error_idx));
    % disp(line1); disp(line2);
end

%% �����С��һ�µ�ͼƬ
mean_size = round(mean(size_mat)); % ͼ��ƽ����С
supp = {'����1', '����2'};
thres = [0.01, 0.72, 0.1];
for i = 1 : length(supp)
    eval(['test_img=rgb2gray(imread(''',test_path,supp{i},'.bmp''));']);
    test_img = imresize(test_img, mean_size);
    match = recognize(test_img, train_img_bin, pattern_size, thres, idx);
    [line1, line2, error_idx] = analysis_match(match);
    fprintf('%s.bmp\terror: %d\n', supp{i}, length(error_idx));
    % disp(line1); disp(line2);
end



