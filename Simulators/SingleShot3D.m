
%% 3D Finite Difference Modeling  
% Read a 3D velocity model, create initial conditions
% and perform a high order 3D FDM to propagate in time

%% Initial wavefield

% initial wavefield ricker of wave number k
rickpos=50;
rw = ricker3d(0.006,nx,dx,ny,dy,nz,dz,rickpos*dx,rickpos*dy,6*dz);

%% Some displays
% figure;
% imagesc(squeeze(vel(50,:,:)));
% figure;
% imagesc(squeeze(rw(50,:,:))); caxis([-.1 .1]);
% figure;
% imagesc(squeeze(vel(:,50,:)));
% figure;
% imagesc(squeeze(rw(:,50,:))); caxis([-.1 .1]);
% figure;
% imagesc(squeeze(vel(:,:,10)));
% figure;
% imagesc(squeeze(rw(:,:,10))); caxis([-.1 .1]);

%% Wave equation FDM 3D
clear srecord;

%generate the 3D shot record
tic
[srecord] = fdm3dho(vel,rw,dx,dy,dz,nt,dt,order,1); %high order fdm
toc

