clc;
clear all;
close all;
format long;

%Filter Parameters
A = [0 0 0 1 0 0 0 0 0; 
    0 0 0 0 1 0 0 0 0;
    0 0 0 0 0 1 0 0 0;
    0 0 0 0 0 0 1 0 0;
    0 0 0 0 0 0 0 1 0;
    0 0 0 0 0 0 0 0 1;
    0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0]; 
Gamma = [0 0 0;0 0 0;0 0 0;0 0 0;0 0 0;0 0 0;1 0 0;0 1 0;0 0 1];
C =[1 0 0 0 0 0 0 0 0;
    0 1 0 0 0 0 0 0 0;
    0 0 1 0 0 0 0 0 0];
w = randn(3,1);

%Filter setup

%Cycle
