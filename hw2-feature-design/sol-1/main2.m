clear all; close all; clc;

%% ��������·��
train_path = 'train/';
test_path = 'test/';

%% Ԥ����ѵ������,���ģʽ��֪ʶ
idx = [0,1,2,3,4,6,8,9];
len = 50;
pattern = train_preprocess(train_path, idx, len);

%% ��ͼƬ�е����ֽ���ʶ��

test_idx = {'1','2','3','4','5','6','����','����','����1','����2'};
for i = 1 : length(test_idx)
    eval(['test_img=rgb2gray(imread(''',test_path,test_idx{i},'.bmp''));']);
    
    if i == 8
        test_img = medfilt2(test_img); % ��ֵ�˲�
    end
    
    
    % ����ģʽ����ƥ��
    match = recognize(test_img, pattern, idx);
    % ����ƥ����
    [line1, line2, error_idx] = analysis_match(match, i);
    % disp(line1); disp(line2);
    fprintf('%s.bmp\t\terror: %d\n', test_idx{i}, length(error_idx));
    
end



