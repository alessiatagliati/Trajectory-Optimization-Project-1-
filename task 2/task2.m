clc;
clear all;
close all;
format long;

%Simulation parameters

%Earth cosntants
a = 6378.137;
b = 6356.752;

%Loading
%data = xlsread()

%Waypoints
Wpt_phi = data(:,1);
Wpt_lambda = zeros(MAXPOINTS,1);
Wpt_givry = zeros(MAXPOINTS,1);
Wpt_phi_temp = zeros(MAXPOINTS,1);
Wpt_lambda_temp = zeros(MAXPOINTS,1);

Wpt_X = zeros(MAXPOINTS,1);
Wpt_Y = zeros(MAXPOINTS,1);
Wpt_Z = zeros(MAXPOINTS,1);

        for i = 1:last_point
        
            %calculate the total distance
            [dist_Loxo_segment] = loxodistance (lambdaP1, lambdaP2,phiP1,phiP2);
            total_distance = total_distance + dist_Loxo_segment

            %conversion
            for i=1 : 2
                [X,Y,Z]= geodetic_to_geocentric (Wpt_lambda(i),Wpt_phi(i),0)

                Wpt_X(i) = X;
                Wpt_Y(i) = Y;
                Wpt_Z(i) = Z;
            end
        end