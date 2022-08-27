classdef Quat
   
    properties
        value
    end
    
    methods
        function this = Quat
            this.value = [1 0 0 0];
        end
        
        function g = rotate(this, q)
            l0 = this.value(1);
            l1 = this.value(2);
            l2 = this.value(3);
            l3 = this.value(4);

            m = [
                l0 -l1 -l2 -l3
                l1  l0 -l3  l2
                l2  l3  l0 -l1
                l3 -l2  l1  l0
                ];
            g = Quat();
            g.value = (m*q.value')';
        end
        
        function q = conj(this)
            q = Quat();
            this.value = [this.value(1) ...
                -this.value(2) -this.value(3) -this.value(4) ];
        end

        function C = to_dcm(this)
            q0 = this.value(1);
            q1 = this.value(2);
            q2 = this.value(3);
            q3 = this.value(4);

            Cnb_1_1 = q0^2 + q1^2 - q2^2 - q3^2;
            Cnb_1_2 = 2*(q1*q2 - q0*q3);
            Cnb_1_3 = 2*(q1*q3 + q0*q2);

            Cnb_2_1 = 2*(q1*q2 + q0*q3);
            Cnb_2_2 = q0^2 - q1^2 + q2^2 - q3^2;
            Cnb_2_3 = 2*(q2*q3 - q0*q1);

            Cnb_3_1 = 2*(q1*q3 - q0*q2);
            Cnb_3_2 = 2*(q2*q3 + q0*q1);
            Cnb_3_3 = q0^2 - q1^2 - q2^2 + q3^2;

            C = [
                Cnb_1_1 Cnb_1_2 Cnb_1_3
                Cnb_2_1 Cnb_2_2 Cnb_2_3
                Cnb_3_1 Cnb_3_2 Cnb_3_3
                ];
        end
        
        function q = from_dcm(this, C)
            
            q0 = 1/2*(1 + C(1,1) + C(2,2) + C(3,3))^(1/2);
            q1 = (C(3,2) - C(2,3))/(4*q0);
            q2 = (C(1,3)-C(3,1))/(4*q0);
            q3 = (C(2,1)-C(1,2))/(4*q0);

            q = Quat();

            q.value = [q0, q1, q2, q3];
        end
        
        function Eulers = to_angle(this)
            C = this.to_dcm();
            rz = atan2(C(2,1), C(1,1));
            ry = -atan2(C(3,1), sqrt(1 - C(3,1)^2));
            rx = atan2(C(3,2), C(3,3));
            
            Eulers = [rz ry rx];
        end
        
        function q = from_angle(this, Eulers)
            rz = Eulers(1);
            ry = Eulers(2);
            rx = Eulers(3);
           
            sz = sin(rz);
            cz = cos(rz);
            sy = sin(ry);
            cy = cos(ry);
            sx = sin(rx);
            cx = cos(rx);

            Cx = [1 0 0; 0 cx -sx; 0 sx cx];
            Cy = [cy 0 sy; 0 1 0; -sy 0 cy];
            Cz = [cz -sz 0; sz cz 0; 0 0 1];

            q = this.from_dcm(Cz*Cy*Cx);
        end
        
        function new_vec = vec_rotate(this, vec)
           C = this.to_dcm();
           new_vec = C*vec;
        end
        
        function q = normalize(this)
            q = Quat();
            q.value = this.value / norm(this.value);
        end
        
    end
end