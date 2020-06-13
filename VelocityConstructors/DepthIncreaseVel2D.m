n1=500;
n2=500;
d1=10;
d2=10;
v0=1500;
dv=.6;

% prepare dimesion 1
S1 = d1*(n1-1);
s1 = 0:d1:S1;

% prepare dimension 2
S2 = d2*(n2-1);
s2 = 0:d2:S2;

    [t1,t2] = meshgrid(s1,s2);
    vel = t1.*0+t2.*dv+v0;
    
imagesc(s1,s2,vel)