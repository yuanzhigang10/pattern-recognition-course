clear all; close all; clc;
omg_1=[2 0;2 2;2 4;3 3];
omg_2=[0 3;-2 2;-1 -1;1 -2;3 -1];
%omg_1=[1 1;2 0;2 1;0 2;1 3];
%omg_2=[-1 2;0 0;-1 0;-1 -1;0 -2];
omg_1_mean=omg_1-repmat(mean(omg_1),size(omg_1,1),1);
omg_2_mean=omg_2-repmat(mean(omg_2),size(omg_2,1),1);
s_1=omg_1_mean'*omg_1_mean;
s_2=omg_2_mean'*omg_2_mean;
s_w=s_1+s_2;
w=s_w^-1*(mean(omg_1)-mean(omg_2))';
w_0=w/norm(w);
mean_point=(mean(omg_1)+mean(omg_2))/2;

x=[-3:0.01:3];
y=(w_0(2)/w_0(1))*x;
y_=-(w_0(1)/w_0(2))*(x-mean_point(1))+mean_point(2);
figure;
hold on;
for i=1:size(omg_1,1)
    plot(omg_1(i,1),omg_1(i,2),'o');
end;
for i=1:size(omg_2,1)
    plot(omg_2(i,1),omg_2(i,2),'x');
end;
plot(x,y);
plot(x,y_,'r');
axis equal tight;