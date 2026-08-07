% 程序名称：test_circshift
% 2018.6.18 by whp 

clc;clear;close all;
%% 测试circshift指令功能，注意处理的是列向量
A=1:10;
B=circshift(A',3);
B=B';