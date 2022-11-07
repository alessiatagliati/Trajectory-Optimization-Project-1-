function [lambda,phi,h]=geocentric_to_geodetic (X,Y,Z,a,e)
p=(X^(2)+Y^(2))/(a^(2));
q=(1-e^(2))*Z^(2)/(a^(2));
r= (p+q-e^(4))/6;
s=e^(4)*p*q/(4*r^(3));
t=(1+s+sqrt(s*(2+s)))^(1/3);
u=r*(1+t+(1/t));
v=sqrt(u^(2)+e^(4)*q);
w=e^(2)*(u+v-q)/(2*v);
k=sqrt(u+v+w^(2))-w;
D=(k*sqrt(X^(2)+Y^(2)))/(k+e^(2));
lambda=2*atan(Y/(X+sqrt(X^(2)+Y^(2))));
phi=2*atan(Z/(D+sqrt(D^(2)+Z^(2))));
h=((k+e^(2)-1)/k)*sqrt(D^(2)+Z^(2));
end 


