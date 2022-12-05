.clc;
clear all;
close all;
format long;

%Filter Parameters
epsilon = 10^(-5);
max_it = 100;

h = 0.1; %time step (s)
TIME = 5*60; %simulation time (s)

SAMPLE = 50;
POINTS = TIME/h;

Max_Error = 25; % km

%matrices
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

data = xlsread('Dados_Medicoes.xls','Dados_2','A3000:D7000');
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

[Gammak,error,N] = Gamma_to_Gamma_d (Gamma,A,h,epsilon,max_it);
if error == 1
    disp('Error during Gamma_d calculation');
end

sigma2 = (Max_Error / 3)^2;
R = [ sigma2 0 0; 0 sigma2 0; 0 0 sigma2];

%x0 calculation
xk_sum = zeros(9,1);
xk_tilde = zeros(9,SAMPLE);
for i = 1:SAMPLE
    yk_Sample = [Sample_x(i); Sample_y(i); Sample_z(i)];
    xk_tilde(:,i) = pinv(C) * yk_Sample;
    
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

for i = 1:POINTS
    
    p_index = i*9;
    g_index = i*3;
    
    if i == 1
        pk_prev = P_0;
    else
        pk_prev = Pk(:,p_index - 17: p_index - 9);
    end
    Pk_1 = Ak * pk_prev * Ak' + Gammak * Q * Gammak';
    
    Gk(:,g_index -2:g_index) = Pk_1 *Ck'*(Ck* Pk_1 * Ck'+R)^(-1);
    
    Pk(:,p_index - 8 :p_index)=( eye(9)-Gk(:,g_index -2:g_index)*Ck)* Pk_1;
    
end
 
Xk = zeros(9,POINTS);

%Cycle
for i = 1:POINTS
    
 
    g_index = i*3;
    
    yk = [Data_x(i); Data_y(i); Data_z(i)];
    
    if i == 1
        xk_prev = xk_0
    else
        xk_prev = Xk(:,i-1);
    end
    Xk_1 = Ak *xk_prev ;
    
    Xk(:,i) = Xk_1 + Gk(:,g_index -2:g_index)*(yk-Ck*Xk_1) ;
  
    
end

%write
output_data = strings(POINTS +1 ,10);
output_data(1,:) = ["Time";"x";"y";"z";"v_x";"v_y";"v_z";"a_x";"a_y";"a_z"];
output_data(2:POINTS +1,2:10) = Xk()';
output_data(2:POINTS +1,1) = Data_t();
xlswrite('Results_task3.xls',output_data,'Simulation 2');

%plots
%position
figure()
plot(Data_t, Data_x,  Data_t, Xk(1,:))
title('Position with Time for the X coodinate')
xlabel('Time [s]')
ylabel('X position [km]')
legend('Raw data','Filter','Location','northwest')

figure()
plot(Data_t, Data_y,  Data_t, Xk(2,:))
title('Position with Time for the Y coodinate')
xlabel('Time [s]')
ylabel('Y position [km]')
legend('Raw data','Filter','Location','northeast')

figure()
plot(Data_t, Data_z,  Data_t, Xk(3,:))
title('Position with Time for the Z coodinate')
xlabel('Time [s]')
ylabel('Z position [km]')
legend('Raw data','Filter','Location','northwest')

%Velocity
figure()
plot(Data_t, Xk(4,:))
title('Velocity with Time for the X coodinate')
xlabel('Time [s]')
ylabel('X velocity [km/s]')
legend('Filter Estimate','Location','northeast')

figure()
plot(Data_t, Xk(5,:))
title('Velocity with Time for the Y coodinate')
xlabel('Time [s]')
ylabel('Y velocity [km/s]')
legend('Filter Estimate','Location','northeast')

figure()
plot(Data_t, Xk(6,:))
title('Velocity with Time for the Z coodinate')
xlabel('Time [s]')
ylabel('Z velocity [km/s]')
legend('Filter Estimate','Location','northeast')

%Acceleration
figure()
plot(Data_t, Xk(7,:))
title('Acceleration with Time for the X coodinate')
xlabel('Time [s]')
ylabel('X acceleration [km/s^2]')
legend('Filter Estimate','Location','northeast')

figure()
plot(Data_t, Xk(8,:))
title('Acceleration with Time for the Y coodinate')
xlabel('Time [s]')
ylabel('Y acceleration [km/s^2]')
legend('Filter Estimate','Location','northeast')

figure()
plot(Data_t, Xk(9,:))
title('Acceleration with Time for the Z coodinate')
xlabel('Time [s]')
ylabel('Z acceleration [km/s^2]')
legend('Filter Estimate','Location','northeast')

%trajectory
figure()
plot3(Data_x,Data_y,Data_z,':')
hold on 
plot3(Xk(1,:),Xk(2,:),Xk(3,:),'r')
title('3D Trajectory')
xlabel('X position [km]')
ylabel('Y position [km]')
zlabel('Z position [km]')
legend('Raw Data','Filter Estimate','Location','northwest')




