function [f_dot] = f_dot_norm(x_dot,y_dot,z_dot)
    f_dot = sqrt(x_dot^2 + y_dot^2 + z_dot^2);
end