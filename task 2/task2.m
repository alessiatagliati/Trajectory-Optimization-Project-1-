clc;
clear all;
close all;
format long;

%Simulation parameters
POINTS = 269;
DEGREE_MIN = 4;
DEGREE_MAX = POINTS -1;

%precision of the interpolation
PRECISION = 1.852 /1000; %km

%dada position in excel
Collums_DATE = 11;
Collums_LATITUDE = 1;
Collums_LONGITUDE = 2;
Collums_ALTITUDE = 6;
Lines_START_text = 5;
Lines_START_num = 3;
Lines_END_text = Lines_START_text + POINTS-1;
Lines_END_num = Lines_START_num + POINTS-1;

%Loading Data
[num,txt,raw] = xlsread('AFR1125.xlsx','Sheet1')

Date = txt(Lines_START_text:Lines_END_text,Collums_DATE);
Longitude = num(Lines_START_num:Lines_END_num,Collums_LONGITUDE);
Latitude = num(Lines_START_num:Lines_END_num,Collums_LATITUDE);
Altitude = num(Lines_START_num:Lines_END_num,Collums_ALTITUDE);

X = zeros(1,POINTS);
Y = zeros(1,POINTS);
Z = zeros(1,POINTS);

%Date parsing
[Time] = string_to_time(Date,POINTS);

%conversion of the coordinates
for i = 1:POINTS
    [X(i),Y(i),Z(i)]= geodetic_to_geocentric (Longitude(i),Latitude(i),Altitude(i)/1000);
end

%Calculation of the distance
%Cycle initialization
degree = DEGREE_MIN;
delta = 100;
distance_prev = 0;

while (degree <= DEGREE_MAX & delta >= PRECISION)
    
    %Interpolation of the position
    f_X = polyfit(Time,X,degree);
    f_Y = polyfit(Time,Y,degree);
    f_Z = polyfit(Time,Z,degree);

    %derivation
    [f_X_dot] = derivate(f_X,degree);
    [f_Y_dot] = derivate(f_Y,degree);
    [f_Z_dot] = derivate(f_Z,degree);

    %calculation of the total distance
    [distance] = simpcomp(Time, f_X_dot, f_Y_dot, f_Z_dot, POINTS, @f_dot_norm); %km
    
    delta = abs(distance - distance_prev);
    distance_prev = distance;
    degree = degree + 1;
end

%checking the solution
if delta > PRECISION
    disp("Solution did not converge!");
else
    disp("Solution found!");
    distance_final = distance_prev * 0.539956803 %NM
end

%Ploting
xt = zeros(1,POINTS);
yt = zeros(1,POINTS);
zt = zeros(1,POINTS);
xdiff_sum = 0;
ydiff_sum = 0;
zdiff_sum = 0;

for i = 1:POINTS
    t = Time(i);
    %intermolation function values
    xt(i) = polyval(f_X,t); 
    yt(i) = polyval(f_Y,t);
    zt(i) = polyval(f_Z,t);
    
    %square difference
    xdiff_sum = xdiff_sum + (X(i) - xt(i))^2;
    ydiff_sum = ydiff_sum + (Y(i) - yt(i))^2;
    zdiff_sum = zdiff_sum + (Z(i) - zt(i))^2;
    
end
%root mean square
x_mean2 = sqrt(xdiff_sum / POINTS)
y_mean2 = sqrt(ydiff_sum / POINTS)
z_mean2 = sqrt(zdiff_sum / POINTS)

%plots
figure()
plot(Time,X, Time, xt,'--')
title('Interpolation Function vs Raw Data for the X coordinate')
xlabel('Time [s]')
ylabel('X position [km]')
legend('Raw data','Interpolation')

figure()
plot(Time,Y, Time, yt,'--')
title('Interpolation Function vs Raw Data for the Y coordinate')
xlabel('Time [s]')
ylabel('Y position [km]')
legend('Raw data','Interpolation')

figure()
plot(Time,Z, Time, zt,'--')
title('Interpolation Function vs Raw Data for the Z coordinate')
xlabel('Time [s]')
ylabel('Z position [km]')
legend('Raw data','Interpolation')
