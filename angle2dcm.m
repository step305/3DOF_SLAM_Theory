function Cnb = angle2dcm(phi, theta, psi)

Cnb = zeros(3);
Cnb(1,1) = cos(theta)*cos(psi);
Cnb(1,2) = -cos(phi)*sin(psi)+sin(phi)*sin(theta)*cos(psi);
Cnb(1,3) = sin(phi)*sin(psi)+cos(phi)*sin(theta)*cos(psi);
Cnb(2,1) = cos(theta)*sin(psi);
Cnb(2,2) = cos(phi)*cos(psi)+sin(phi)*sin(theta)*sin(psi);
Cnb(2,3) = -sin(phi)*cos(psi)+cos(phi)*sin(theta)*sin(psi);
Cnb(3,1) = -sin(theta);
Cnb(3,2) = sin(phi)*cos(theta);
Cnb(3,3) = cos(phi)*cos(theta);

end