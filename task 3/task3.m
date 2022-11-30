clc;
clear all;
close all;
format long;

%Filter Parameters

SAMPLE = 50;
POINTS = 50;

Max_Error = 14.5 / 1000; % m / km
h = 0.1; %time step (s)

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

%Loading data

data = xlsread('Dados_Medicoes.xls','Dados_1','A7:D300');
Sample_t = data(1:SAMPLE,1);
Sample_x = data(1:SAMPLE,2);
Sample_y = data(1:SAMPLE,3);
Sample_z = data(1:SAMPLE,4);

Data_t = data(SAMPLE + 1:SAMPLE + POINTS,1);
Data_x = data(SAMPLE + 1:SAMPLE + POINTS,2);
Data_y = data(SAMPLE + 1:SAMPLE + POINTS,3);
Data_z = data(SAMPLE + 1:SAMPLE + POINTS,4);

%Initial Data
Ak = expm(A*h);
Ck = C;
Gammak = Gamma;

sigma2 = (Max_Error / 3)^2;
R = [ sigma2 0 0; 0 sigma2 0; 0 0 sigma2];

%x0 calculation
xk_sum = zeros(9,1);
xk_tilde = zeros(9,SAMPLE);
for i = 1:SAMPLE
    yk = [Sample_x(i); Sample_y(i); Sample_z(i)];
    xk_tilde(:,i) = pinv(C) * yk;
    
    xk_sum = xk_sum + xk_tilde(:,i);
end
xk_0 = xk_sum / SAMPLE;

%P0 calculation
P_sum = zeros(9,9);
for i = 1:SAMPLE
    
    P_sum = P_sum + (xk_tilde(:,i)-xk_0)*(xk_tilde(:,i)-xk_0)';
end
P_0 = P_sum / (SAMPLE -1);

Q = Gammak'*P_0*Gammak;

%Filter Setup
Pk = zeros(9,9*POINTS);
Gk = zeros(9,3*POINTS);

Pk(:,1:9)=P_0;

for i = 10:9:POINTS*9
    
    Pk(:,i:i+8) = Ak * Pk(:,i-9:i-1) * Ak' + Gammak * Q * Gammak';
    
    Gk(:,i:i+8) = Pk(:,i:i+8);
end

%Cycle
