clear all; close all; clc;
%% data
load trainingData;
train1 = training(group==1, :);
train2 = training(group==2, :);

%% kNN classify
kk = floor(sqrt(size(training,1)));
k = [1 3 5 8 10 30 50 80 kk];
for i = 1 : length(k)
    %% classify
    [x, y] = meshgrid((-6:0.1:6), (-6:0.1:6));
    test = [x(:), y(:)];
    target = knn(test, training, group, k(i));
    %% plot
    figure; hold on;
    test1 = test(target==1, :); % classified as 1
    test2 = test(target==2, :); % classified as 2
    plot(test1(:,1), test1(:,2), 'g.');
    plot(test2(:,1), test2(:,2), 'c.');
    plot(train1(:,1), train1(:,2), 'ro');
    plot(train2(:,1), train2(:,2), 'k^');
    title(['kNN Classify (k = ', num2str(k(i)), ')']);
    legend('classified as 1', 'classified as 1', ...
        'train data 1', 'train data 2');
end
%% end of script