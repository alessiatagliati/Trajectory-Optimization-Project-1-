function[waypoints_vector]= insert_to_vector (start_vector, value, index, length)

    waypoints_vector = start_vector;
    for i=(length-1):-1:index
        waypoints_vector(i+1)=waypoints_vector(i);
    end
    waypoints_vector(index) = value;
    
end