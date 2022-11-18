function I = simpcomp(a, b, N, f)

% I = simpcomp(a, b, N, f)
%
% Formula di Simpson composita: 
% Inputs:
%    a,b: estremi di integrazione,
%    N: numero di sottointervalli (N=1 formula di integrazione semplice)
%    f: funzione da integrare definita come inline o anonimous
% Output:
%    I: integrale calcolato

% ampiezza dei sottointervalli
h = (b - a) / N;

% inizializzo valore integrale
I = 0;

% ciclo sul numero di sottointervalli
for n = 1:N
    % estremo di sinistra del sottointervallo
    x_s = a + (n - 1) * h;
    
    % estremo di destra del sottointervallo
    x_d = a + n * h;
    
    % punto medio del sottointervallo
    x_m = (x_s + x_d) / 2;
    
    % aggiungo l'integrale sul sottointervallo al valore totale
    % dell'integrale
    I = I + (x_d - x_s) / 6 * (f (x_s) + f (x_d) + 4 * f (x_m));   
end