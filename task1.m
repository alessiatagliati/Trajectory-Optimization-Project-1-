clc;
clear all;
close all;
format long;

%Simulation parameters
MAXPOINTS = 50;

%Earth cosntants
a = 6378.137; %km
b = 6356.752; %km

%A
AirportA = [41.800278;12.238889;0]; %degrees/m
AirportB = [13.6925;100.75;0]; %degrees/m


lambdaA= AirportA(1); %degrees
phiA= AirportA(2); %degrees
hA= AirportA(3); %km
lambdaB= AirportB(1);%degrees
phiB= AirportB(2);%degrees
hB= AirportB(3);%km

%Waypoints
Wpt_phi = zeros(MAXPOINTS,1);
Wpt_lambda = zeros(MAXPOINTS,1);
Wpt_givry = zeros(MAXPOINTS,1);
Wpt_phi_temp = zeros(MAXPOINTS,1);
Wpt_lambda_temp = zeros(MAXPOINTS,1);

%- TASK I -
%A and B conversion to geocentric
[xA,yA,zA]= geodetic_to_geocentric (lambdaA,phiA,hA);%km
[xB,yB,zB]= geodetic_to_geocentric (lambdaB,phiB,hB);%km

%AB ortodromic distance calculation
[alphaorto] = ortoangle(xA,yA,zA,xB,yB,zB);%radians
[orto_distanceAB ] = radians_to_minutes(alphaorto); %minutes = NM

%AB loxodromic distance calculation
[distLoxo_AB]= loxodistance (lambdaA, lambdaB,phiA,phiB); %NM

%- TASK I -
last_point = 1;
givry_test = 1;
while (last_point) < MAXPOINTS && givry_test > 0
    
    for i = 1:last_point
        givry_test = 0;
        
        %loading points
        if i == 1
            lambdaP1 = lambdaA;
            phiP1 = phiA;
        else
            lambdaP1 = Wpt_lambda(i-1);
            phiP1 = Wpt_phi(i-1);
        end
        if i == last_point
            lambdaP2 = lambdaB;
            phiP2 = phiB;
        else
            lambdaP2 = Wpt_lambda(i);
            phiP2 = Wpt_phi(i);
        end
        %givry correction between those 2 points
        givry_12 = givrycorrection(lambdaP1,lambdaP2,phiP1,phiP2); %degrees
        
        if givry_12 >= 10
            givry_test = givry_test + 1;
            %if it greater than 10, calculate middle point
            
            [phiP3,lambdaP3] = find_waypoints(phiP1,lambdaP1,phiP2,lambdaP2); %degress
            
            %if there is space in the vector, store that point
            if last_point<=MAXPOINTS
                [Wpt_lambda_temp] = insert_to_vector (Wpt_lambda, lambdaP3, i, MAXPOINTS) ;
                [Wpt_phi_temp] = insert_to_vector (Wpt_phi, phiP3, last_point, MAXPOINTS) ;
                [Wpt_givry] = insert_to_vector (Wpt_givry, givry_12, i, MAXPOINTS) ;
            else
                disp("Not enough points")
            end
            
            last_point = last_point +1; 
        else
            Wpt_givry(i) = givry_12;
        end
        %update waypoint array
        Wpt_phi = Wpt_phi_temp;
        Wpt_lambda = Wpt_lambda_temp;
    end   
    
    %check if solution was achieved
    if givry_test == 0
        disp("Solution Found!");
        
        %truncate vectors
        Wpt_phi = Wpt_phi(1:last_point-1);
        Wpt_lambda = Wpt_lambda(1:last_point-1);
        Wpt_givry = Wpt_givry(1:last_point);
        
        Wpt_X = zeros(last_point-1,1);
        Wpt_Y = zeros(last_point-1,1);
        Wpt_Z = zeros(last_point-1,1);

        Wpt_dist = zeros(last_point,1);
        
        %calculating the distance
        total_distance = 0;
        
        for i = 1:last_point
        givry_test = 0;
        
            %loading points
            if i == 1
                lambdaP1 = lambdaA;
                phiP1 = phiA;
            else
                lambdaP1 = Wpt_lambda(i-1);
                phiP1 = Wpt_phi(i-1);
            end
            if i == last_point
                lambdaP2 = lambdaB;
                phiP2 = phiB;
            else
                lambdaP2 = Wpt_lambda(i);
                phiP2 = Wpt_phi(i);
            end

            %calculate the total distance
            [dist_Loxo_segment] = loxodistance (lambdaP1, lambdaP2,phiP1,phiP2); %NM
            total_distance = total_distance + dist_Loxo_segment %NM
            Wpt_dist(i) = dist_Loxo_segment; %NM

            %conversion
            for i=1 : last_point-1
                [X,Y,Z]= geodetic_to_geocentric (Wpt_lambda(i),Wpt_phi(i),0);%km

                Wpt_X(i) = X;
                Wpt_Y(i) = Y;
                Wpt_Z(i) = Z;
            end
        end
        
    else
        disp("Could not find solution!");
    end
 
end