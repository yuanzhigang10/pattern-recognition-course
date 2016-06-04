clear all; close all; clc;

%% data
data{1,1} = [2 0; 2 2; 2 4; 3 3];
data{1,2} = [0 3; -2 2; -1 -1; 1 -2; 3 -1];
data{2,1} = [1 1; 2 0; 2 1; 0 2; 1 3];
data{2,2} = [-1 2; 0 0; -1 0; -1 -1; 0 -2];

%% Fisher
for k = 1 : 2
    X1 = data{k,1}; X2 = data{k,2};
    M1 = mean(X1); M2 = mean(X2);
    Xm1 = X1 - repmat(M1, size(X1,1), 1);
    Xm2 = X2 - repmat(M2, size(X2,1), 1);
    S1 = Xm1' * Xm1; S2 = Xm2' * Xm2;
    Sw = S1 + S2;
    W = Sw \ (M1-M2)';
    W = W / norm(W); % project vector
    % project
    Y1 = W' * X1'; Y2 = W' * X2'; % scalar set
    mid = (M1 + M2) / 2; % middle point of mean
    
    %% plot
    Xp1 = [Y1'*W(1), Y1'*W(2)]; % projected data
    Xp2 = [Y2'*W(1), Y2'*W(2)];
    X = [X1; X2]; Xp = [Xp1; Xp2];
    figure; hold on;
    syms x; h1 = ezplot(W(2)/W(1)*x);
    set(h1, 'color', 'y', 'linewidth', 1.5);
    h2 = ezplot(-W(1)/W(2)*(x-mid(1))+mid(2));
    set(h2, 'color', 'g', 'linewidth', 2);
    plot(X1(:,1), X1(:,2), 'ro', 'markerfacecolor', 'r');
    plot(X2(:,1), X2(:,2), 'b^', 'markerfacecolor', 'b');
    plot(Xp1(:,1), Xp1(:,2), 'r*');
    plot(Xp2(:,1), Xp2(:,2), 'b*');
    for i = 1 : size(X,1)
        line([X(i,1), Xp(i,1)], [X(i,2), Xp(i,2)], 'color', [.9 .9 .9]);
    end
    axis([min(X(:,1))-1, max(X(:,1))+1, min(X(:,2))-1, max(X(:,2))+1]);
    axis equal; title(['dataset ', num2str(k)]);
    legend('W', 'sep', '\omega1', '\omega2', 'Y1', 'Y2');
end

%% end of srcipt