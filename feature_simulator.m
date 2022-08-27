function [ideal_world] = feature_simulator(N)
    % output:
    %   ideal_world - features array (type of Feature, see Feature Class)
    
    
    % create N features on unit sphere in 3D
    ideal_world = repmat(Feature([NaN; NaN; NaN], NaN), N, 1);    
    for i=1:N
        ideal_world(i) = Feature(rand(3,1)-0.5, i);
    end
    
end
