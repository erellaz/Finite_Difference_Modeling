% Read a velocity profile from a .csv file and expand to a 2D vel model 
M = csvread('/home/xxxxx.csv');
%M
%plot(M(:,1),M(:,2));

%Spline interpolation
x=M(:,1);
v=M(:,2);
xq=(0:50:7050);
figure
vq = interp1(x,v,xq,'spline');
plot(x,v,'o',xq,vq,':.');
title('Spline Interpolation');

vel=repmat(vq',1,150);
imagesc(vel);
