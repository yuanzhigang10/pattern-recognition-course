clear all; close all; clc;

%% load data from task3_1 and task3_2
% please run script "pr_proj_task3_1.m" and "pr_proj_task3_2.m" first
load task3_1;
load task3_2;

%% show figure for contrast
figure; hold on; grid on;
plot(0:0.1:1, task3_1.tpr_mat, '--', 'linewidth', 1.5);
plot(0:0.1:1, task3_1.tnr_mat, 'r--', 'linewidth', 1.5);
plot(0:0.1:1, task3_2.tpr_mat, 'linewidth', 1.5);
plot(0:0.1:1, task3_2.tnr_mat, 'r', 'linewidth', 1.5);
xlabel('\alpha'); ylabel('rate');
title('classification results');
legend('TPR (no training)', 'TNR (no training)', ...
    'TPR (with training)', 'TNR (with training)');

%% end of script