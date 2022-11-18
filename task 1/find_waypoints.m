function [phi,lambda]=find_waypoints(phiA,lambdaA,phiB,lambdaB)
delta_lambda=abs(lambdaA-lambdaB);
num_alpha1= (cosd(phiB)*sind(delta_lambda));
den_alpha1=(cosd(phiA)*sind(phiB)-sind(phiA)*cosd(phiB)*cosd(delta_lambda));
num_sigma12=(sqrt((cosd(phiA)*sind(phiB)-sind(phiA)*cosd(phiB)*cosd(delta_lambda))^(2)+(cosd(phiB)*sind(delta_lambda))^(2)));
den_sigma12=(sind(phiA)*sind(phiB)+cosd(phiA)*cosd(phiB)*cosd(delta_lambda));
alpha1= atan2d(num_alpha1,den_alpha1);
sigma12= atan2d(num_sigma12,den_sigma12)
num_alpha0=(sind(alpha1)*cosd(phiA));
den_alpha0=(sqrt((cosd(alpha1))^(2)+(sind(alpha1))^(2)*(sind(phiA))^(2)));
num_sigma01=tand(phiA);
den_sigma01=cosd(alpha1);
alpha0=atan2d(num_alpha0,den_alpha0)
sigma01=atan2d(num_sigma01,den_sigma01)
sigma02=sigma01+sigma12
num_lambda01= (sind(alpha0)*sind(sigma01))
den_lambda01= cosd(sigma01);
lambda01= atan2d(num_lambda01,den_lambda01)
lambda0=lambdaA-lambda01
sigma=0.5*(sigma01+sigma02)
phi= atand((cosd(alpha0)*sind(sigma))/(sqrt((cosd(sigma))^(2)+(sind(alpha0))^(2)*(sind(sigma))^(2))));
num_lambda_lambda0= sind(alpha0)*sind(sigma)
den_lambda_lambda0= cosd(sigma);
lambda_lambda0=atan2d(num_lambda_lambda0,den_lambda_lambda0);
lambda=lambda_lambda0+lambda0;
end
%output adn input in degrees

