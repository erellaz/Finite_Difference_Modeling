n1=100;
n2=100;
n3=100;

d1=10;
d2=10;
d3=10;

v0=1500;
dv=.6;

% prepare dimesion 1
S1 = d1*(n1-1);
s1 = 0:d1:S1;

% prepare dimension 2
S2 = d2*(n2-1);
s2 = 0:d2:S2;

% prepare dimension 3
S3 = d3*(n3-1);
s3 = 0:d3:S3;

    [t1,t2,t3] = meshgrid(s1,s2,s3);;
    vel = t1.*0+t2.*0+t3.*dv+v0;
    
imagesc(s1,s3,squeeze(vel(:,1,:)))