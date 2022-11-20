function [X,Y,Z]= geodetic_to_geocentric (lambda,phi,h)
a = 6378.137;%km
b = 6356.752;%km
lambdarad=deg2rad(lambda);
phirad=deg2rad(phi);
Rn = a / sqrt(1-(sin(phirad)^2)*(a^2-b^2)/a^2);
X= (Rn+h)*cos(phirad)*cos(lambdarad); %km
Y= (Rn+h)*cos(phirad)*sin(lambdarad); %km
Z= ((Rn*b^(2)/a^(2))+h)*sin(phirad); %km
end 
