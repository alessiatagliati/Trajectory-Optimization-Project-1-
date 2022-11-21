clc;
clear all;
close all;
format long;

%Simulation parameters
POINTS = 269;
DEGREE = 20;

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

%conversion
for i = 1:POINTS
    [X(i),Y(i),Z(i)]= geodetic_to_geocentric (Longitude(i),Latitude(i),Altitude(i)/1000);
end
%Interpolation
f_X = polyfit(Time,X,DEGREE);
f_Y = polyfit(Time,Y,DEGREE);
f_Z = polyfit(Time,Z,DEGREE);

%derivation
[f_X_dot] = derivate(f_X,DEGREE);
[f_Y_dot] = derivate(f_Y,DEGREE);
[f_Z_dot] = derivate(f_Z,DEGREE);

%calculation of the total distance
[distance] = simpcomp(Time, f_X_dot, f_Y_dot, f_Z_dot, POINTS, @f_dot_norm) %km

%plots
xt = zeros(1,POINTS);
vt = zeros(1,POINTS);
for i = 1:POINTS
    t = Time(i);
    xt(i) = polyval(f_X,t);
    vt(i) = polyval(f_X_dot,t);
end

plot(Time, Altitude)
%plot(Time,X, Time, xt)
%plot(Time, vt)