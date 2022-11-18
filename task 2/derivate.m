function [f_dot] = derivate(f,d)
    exponent = d;
    for i = 1:d+1
        f(i) = f(i)*(exponent);
        exponent = exponent -1;
    end
    f_dot = f;
end