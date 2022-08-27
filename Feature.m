classdef Feature
    
    properties
        vector
        vector_body
        id 
        visible
        matched
    end
    
    methods
        % Create ini features (constructor)
        function this = Feature(point, id)
            this.vector(1:3,1) = point/norm(point);
            this.id = id;
            this.vector_body = [0 0 0]';
            this.visible = false;
            this.matched = false;
        end
        
        function result = compare(this, feature)
            result = (this.id == feature.id);
        end
        
    end
end