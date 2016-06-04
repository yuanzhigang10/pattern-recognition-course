clear all; close all; clc;

%% ��������·��
train_path = 'train/';
test_path = 'test/';

%% Ԥ����ѵ������,���ģʽ��֪ʶ
train_idx = [0,1,2,3,4,6,8,9];
[train_img, centroid] = train_preprocess(train_path, train_idx);

%% ��ͼƬ�е����ֽ���ʶ��
test_idx = {'1','2','3','4','5','6','����','����'};
% ���������ĺ���
% thres(1) mask�ص��̶ȣ����ڷ��ظ�ʶ����ж�
% thres(2) �����������������ϵ��
% thres(3) �ж�ĳ���������ֵľ�����ֵ
thres = [
    0.2, 0.3, 0.4
    0.2, 0.3, 0.35
    0.2, 0.3, 0.4
    0.2, 0.3, 0.4
    0.2, 0.3, 0.38
    0.2, 0.3, 0.4
    0.2, 0.3, 0.4
    0.2, 0.3, 0.4
    ];
for i = 1 : length(test_idx)
    % for tt = 0.3 : 0.02 : 0.5
        eval(['test_img=rgb2gray(imread(''',test_path,test_idx{i},'.bmp''));']);
        if i == 8
            test_img = medfilt2(test_img); % ��ֵ�˲�
        end
        test_img = ~binarization(test_img); % ����ͼ���ֵ��
        % figure; subplot(2,1,1); imshow(test_img);
        
        % ����ģʽ����ƥ��
        match = recognize(test_img, train_img, centroid, train_idx, thres(i,:));
        
        % ����ƥ����
        [line1, line2, error_idx] = analysis_match(match);
        disp(line1); disp(line2);
        % fprintf('tt: %f\t', tt);
        fprintf('%s.bmp\t\terror: %d\n', test_idx{i}, length(error_idx));
    % end
end

