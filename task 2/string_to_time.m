function [Time] = string_to_time(Date,POINTS)

    Time = zeros(1,POINTS);
    for i=1:POINTS

        date_string = strsplit(string(Date(i)));
        date_numbers = strsplit(date_string(2),':');

        Time(i) = str2num(date_numbers(1))*3600 + str2num(date_numbers(2))*60 + str2num(date_numbers(3))- Time(1);

    end
    Time(1) = 0;
end