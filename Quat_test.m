clc
q = Quat();
dq = Quat();

a = 15*pi/180;
dq.value = [4*cos(a/2) sin(a/2) 0 0 ]

vec = [0 1 0 ]';

dq.vec_rotate(vec)

dq = dq.normalize()
norm(dq.value)