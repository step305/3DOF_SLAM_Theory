function [Euler, iWb] = spin_cone(t)
% Creates reference data for AHRS algorithm simulation
% Reference movement of the body is defined by the SPIN-CONE truth model -
% body spinning at a fixed magnitude rotation rate and whose spin axis is
% rotating at a fixed precessional rate
% Ref: Paul G. Savage, Strapdown System Performance Analysis

beta = 30*pi/180;
wc = 0.1;
ws = 1;


% Attitude angles (from navigation frame to body)
phi = (ws-wc*cos(beta))*t;
theta = pi/2-beta;
psi = -wc*t;
Euler = [psi; theta; phi];

% Angular rate
% Wb = [ws; -wc*sin(beta)*sin(phi); -wc*sin(beta)*cos(phi)];

% Integrated angular rate
iWb = zeros(3,1);
if abs(ws) > 0
    iWb(1,1) = ws*t;
    iWb(2,1) = ((wc*sin(beta))/(ws-wc*cos(beta)))*cos(phi);
    iWb(3,1) = -((wc*sin(beta))/(ws-wc*cos(beta)))*sin(phi);
end