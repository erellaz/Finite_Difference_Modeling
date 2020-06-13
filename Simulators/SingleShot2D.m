
% read a velocity model and perform FDM 2D on it
% Finite Difference Modeling  

%% Plot Velocity model
% figure;
% imagesc(x,z,vel)
% xlabel('Distance (m)'); ylabel('Depth (m)');
% title('Velocity Model');
% colormap(jet)


%% Initial wavefield

% initial wavefield ricker of spatial frequency f
rickpos=238;
%rw = ricker2d(0.008,nx,dx,nz,dz,rickpos*dx,0*dz);
rw = ricker2d(0.006,nx,dx,nz,dz,rickpos*dx,6*dz);

%% plot initial wavefield
% figure;
% imagesc(x,z,rw)
% xlabel('Distance (m)'); ylabel('Depth (m)');
% title('Initial wavefield');
% colormap(seismic)


%% Wave equation FDM 2D
% generate shot record
clear ds srecord snapshot;

tic
%[srecord snapshot] = fdm2dsimple(vel,rw,dz,dx,nt,dt);
[srecord snapshot] = fdm2dho(vel,rw,dz,dx,nt,dt,order,1); %high order fdm
toc

%display the shot evolution
figure;
video3darray(snapshot,'ToothWaveNum6down6-1ms-order11.avi')

%Display the shot record
figure;
imagesc(x,t,srecord'), xlabel('X'), ylabel('Time (s)'), title('Shot')
colormap(seismic); %colormap('gray'); 
caxis([-0.1 0.1]);

%Display the VSP record
figure;
ds(:,:) = snapshot(1:nz,rickpos,:);
imagesc(t,z,ds), xlabel('Time (s)'), ylabel('Depth (m)'), title('VSP')
colormap(seismic), caxis([-0.1 0.1]);
