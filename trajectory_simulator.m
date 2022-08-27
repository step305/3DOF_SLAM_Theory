function [Euler, dthe] =  trajectory_simulator(time, dt)
% AHRS-motion model cone trajectory
% Output:
%   thee ideal Euler angles for camera simulation 
%   three gyros outputs dtheta with ARW, RRW, bias
  
% Input:
%    dt - time step
%    time - simulation time

N = time/dt;

Euler = zeros(3, N+1);
dthe  = zeros(3, N);
t = 0;

[Euler(:, 1), iWb_] = spin_cone(t);

for i=2:N
    [Euler(:, i), iWb] = spin_cone(t);
    Euler(:,i) = mod((Euler(:,i)+pi), 2*pi)-pi;
    dthe(:, i-1) = iWb - iWb_;
    iWb_ = iWb;
    % Euler(:, i) = Euler_;
    t = t + dt;
end
Euler(:, N+1) = [];