function [q, gyro_error, P, map] = SLAM_init(map_size)
    q = Quat();
    gyro_error = zeros(3,1);
    
    
    P = zeros(6,6);
    P(1,1) = (1*pi/180)^2;
    P(2,2) = (1*pi/180)^2;
    P(3,3) = (1*pi/180)^2;
    
    P(4,4) = (100/3600*pi/180)^2;
    P(5,5) = (100/3600*pi/180)^2;
    P(6,6) = (100/3600*pi/180)^2;
    
    
    F = Feature([NaN, NaN, NaN], NaN); 
    
    
    map.size = 0;
    map.data = repmat(F, map_size,1);
end