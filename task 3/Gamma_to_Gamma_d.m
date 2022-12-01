function [Gamma_d,error,N] = Gamma_to_Gamma_d (Gamma,A,h,epsilon,max_it)

    [N,error] = Norm (A,h,epsilon,max_it);
    %only run if the norm did found a solution
    if error == 0
        
        Gamma_sum = eye(size(A));
        
        for j = 1:N
           
            Gamma_sum = Gamma_sum + (A^(j-1)*h^(j)) / factorial(j);
        end
        
        Gamma_d = Gamma_sum * Gamma;
    end

    function [N,error] = Norm (A,h,epsilon,max_it)
        N = 1;
        fro = epsilon + 10;
        
        while N<= max_it && fro >= epsilon
            m = (A*h)^(N)/ factorial(N);
            fro = norm( m, 'fro');
            N = N +1;
        end
        %check for solution and give error
        if fro < epsilon
            error = 0;
        else
            error = 1;
        end
    end
end