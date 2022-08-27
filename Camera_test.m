clc
c = Camera();

vec = [0.982 -0.1595 -0.1013];
vec = vec/norm(vec);

[x,y] = c.to_frame(vec)

c.to_vec(x,y)'
vec
c.visible(vec)