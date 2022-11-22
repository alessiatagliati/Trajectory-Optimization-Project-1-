function I = simpcomp(Time, f_x_dot, f_y_dot, f_z_dot, N, f_dot_n)

% I = simpcomp(a, b, N, f)
%
% Formula di Simpson composita: 
% Inputs:
%    a,b: estremi di integrazione,
%    N: numero di sottointervalli (N=1 formula di integrazione semplice)
%    f: funzione da integrare definita come inline o anonimous
% Output:
%    I: integrale calcolato

% inizializzo valore integrale
I = 0;

% ciclo sul numero di sottointervalli
for n = 1:N-1
    % estremo di sinistra del sottointervallo
    x_s = Time(n);
    [x_dot_s,y_dot_s,z_dot_s] = zyz_dot(f_x_dot, f_y_dot, f_z_dot,x_s);
    
    % estremo di destra del sottointervallo
    x_d = Time(n+1);
    [x_dot_d,y_dot_d,z_dot_d] = zyz_dot(f_x_dot, f_y_dot, f_z_dot,x_d);
    
    % punto medio del sottointervallo
    x_m = (x_s + x_d) / 2;
    [x_dot_m,y_dot_m,z_dot_m] = zyz_dot(f_x_dot, f_y_dot, f_z_dot,x_m);
    
    % aggiungo l'integrale sul sottointervallo al valore totale
    % dell'integrale
    I = I + (x_d - x_s) / 6 * (f_dot_n(x_dot_s,y_dot_s,z_dot_s) + f_dot_n(x_dot_d,y_dot_d,z_dot_d) + 4 * f_dot_n(x_dot_m,y_dot_m,z_dot_m));  
    
end
    function [x_dot,y_dot,z_dot] = zyz_dot(f_x_dot, f_y_dot, f_z_dot, s)
        x_dot = polyval(f_x_dot,s);
        y_dot = polyval(f_y_dot,s);
        z_dot = polyval(f_z_dot,s);
    end
end