% read a velocity model and perform FDM 2D on it
% Finite Difference Modeling  

%% Velocity model
[nz,nx] = size(vel);

dx = 25;
dz = 25;
x = (1:nx)*dx;
z = (1:nz)*dz;
order=11;

%% Time step calculation 
vmax=max(max(vel));
% FDMs with dx=dz for the scalar 2D Wave Equation, explicit and time domain  
% Order 2, have a stability limit at 1/sqrt(2)=v*dt/dx.
%dt=0.9*dx/(vmax*sqrt(2));

% For a 2D EFDM order n in space , the stability condition is given 
% by Liu and Sen 2009, and we use 0.9 of the limit 
dt=0.9*dx*EFDMstability(order)/(vmax*sqrt(2));

% Given the stencil order, the grid step (dx=dz) and the calculated dt
% we evaluate the dispersion and propose alternative orders and grid
% adimentional parameter r
Disperionplot(order,vmax*dt/dx);

%% Record length
% determine time samples nt from wave travelime to depth and back to
% surface
vmin = min(min(vel));
nt = round(sqrt((dx*nx)^2 + (dz*nx)^2) *2/vmin/dt);
nt=round(nt/4);
t  = (0:nt-1).*dt;

