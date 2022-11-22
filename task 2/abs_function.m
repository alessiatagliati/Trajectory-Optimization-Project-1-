function [f_dot]= abs_function (f_X_dot,f_Y_dot,f_Z_dot)
f_dot= sqrt(f_X_dot^(2)+f_Y_dot^(2)+f_Z_dot^(2));
end 