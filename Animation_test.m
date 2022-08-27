clc
world = feature_simulator(100);
animation = Animation(world);

a = 45*pi/180;
Cnb = [cos(a) sin(a) 0; ...
       -sin(a) cos(a) 0; ...
       0 0 1]
   
   a = 65*pi/180;
Cnb_est = [cos(a) sin(a) 0; ...
       -sin(a) cos(a) 0; ...
       0 0 1]

   
   world(20).visible = true;
   world(20).matched = true;
animation.Update(world, Cnb, Cnb_est, 112)
%
   world(20).visible = false;
   world(20).matched = false;
animation.Update(world, Cnb, Cnb_est, 112)

