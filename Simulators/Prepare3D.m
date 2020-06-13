% read a velocity model and perform FDM 3D on it
% Finite Difference Modeling  

%% Velocity model
[nz,nx,ny] = size(vel);

dx = 25;
dy = 25;
dz = 25;
x = (1:nx)*dx;
y = (1:ny)*dy;
z = (1:nz)*dz;
order=11;

%% Time step calculation 
vmax=max(max(max(vel)));
% FDMs with dx=dy=dz for the scalar 3D Wave Equation, explicit and time domain  
% Order 2, have a stability limit at 1/sqrt(3)=v*dt/dx.
%dt=0.9*dx/(vmax*sqrt(3));

% For a 3D EFDM of order n in space , the stability condition is given 
% by Liu and Sen 2009, and we use 0.9 of the limit 
dt=0.9*dx*EFDMstability(order)/(vmax*sqrt(3));

% Given the stencil order, the grid step (dx=dy=dz) and the calculated dt
% we evaluate the dispersion and propose alternative orders and grid
% adimentional parameter r


%% Record length
% determine time samples nt from wave travelime to depth and back to
% surface
vmin = min(min(min(vel)));
nt = round(sqrt((dx*nx)^2 +(dy*ny)^2 +  (dz*nz)^2) *2/vmin/dt);
nt=round(nt/4);
t  = (0:nt-1).*dt;

