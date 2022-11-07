function [X,Y,Z]= geodetic_to_geocentric (lambda,phi,h)
a = 6378.137;
b = 6356.752;
lambdarad=deg2rad(lambda);
phirad=deg2rad(phi);
Rn = a / sqrt(1-(sin(phirad)^2)*(a^2-b^2)/a^2);
X= (Rn+h)*cos(phirad)*cos(lambdarad); %m
Y= (Rn+h)*cos(phirad)*sin(lambdarad); %m
Z= ((Rn*b^(2)/a^(2))+h)*sin(phirad); %m
end 
