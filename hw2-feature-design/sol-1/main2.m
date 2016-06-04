clear all; close all; clc;

%% 设置样本路径
train_path = 'train/';
test_path = 'test/';

%% 预处理训练样本,获得模式的知识
idx = [0,1,2,3,4,6,8,9];
len = 50;
pattern = train_preprocess(train_path, idx, len);

%% 对图片中的数字进行识别

test_idx = {'1','2','3','4','5','6','划痕','噪声','补充1','补充2'};
for i = 1 : length(test_idx)
    eval(['test_img=rgb2gray(imread(''',test_path,test_idx{i},'.bmp''));']);
    
    if i == 8
        test_img = medfilt2(test_img); % 中值滤波
    end
    
    
    % 根据模式进行匹配
    match = recognize(test_img, pattern, idx);
    % 分析匹配结果
    [line1, line2, error_idx] = analysis_match(match, i);
    % disp(line1); disp(line2);
    fprintf('%s.bmp\t\terror: %d\n', test_idx{i}, length(error_idx));
    
end



