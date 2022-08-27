classdef Camera
    properties
        X
        Y
        Cx
        Cy
        fx
        fy
        half_angle
        white_noise
        frame_counter
        N_randoms
    end
    
    methods
        function this = Camera(N_randoms)
            this.X = 640;
            this.Y = 480;
            this.Cx = this.X / 2;
            this.Cy = this.Y / 2;
            this.fx = 200;
            this.fy = 200;
            this.half_angle = 30*pi/180;
            this.frame_counter = uint32(0);
            this.white_noise = 0.25 * randn(1, N_randoms);
            this.N_randoms = N_randoms;
        end
        
        function [u, v] = to_frame(this, vec_body_frame)
            if vec_body_frame(1) <= 0 % if the feature behund the camera
                u = NaN;
                v = NaN;
                return
            end
            
            u = vec_body_frame(2)/vec_body_frame(1) * this.fx;
            v = vec_body_frame(3)/vec_body_frame(1) * this.fy;
            if abs(v)>(this.Y/2)
                u = NaN;
                v = NaN;
                return
            else
                this.frame_counter = this.frame_counter+1;
                if this.frame_counter > this.N_randoms
                    this.frame_counter = 1;
                end;
                v = round(v + this.Cy + this.white_noise(this.frame_counter));
            end
            if abs(u)>(this.X/2)
                u = NaN;
                v = NaN;
            else
                this.frame_counter = this.frame_counter+1;
                if this.frame_counter > this.N_randoms
                    this.frame_counter = 1;
                end;
                u = round(u + this.Cx + this.white_noise(this.frame_counter));
            end
        end
        
        function [vec] = to_vec(this, u, v)
            y = (u-this.Cx)/this.fx;
            z = (v-this.Cy)/this.fy;
            x = sqrt(1-z^2 - y^2);
            vec = [x; y; z];
        end
        
        function vis = visible(this, vec)
            [u, v] = this.to_frame(vec);
            vis = ~(isnan(u*v));
        end
    end
end