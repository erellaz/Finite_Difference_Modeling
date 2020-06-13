function [data] = fdm3dho(v,model,dx,dy,dz,nt,dt,order,refcond)
%
% model(nx,ny,nz)      model vector
% v(nx,ny,nz)          velocity model
% nx                number of horizontal samples dim 1
% ny                number of horizontal samples dim 2
% nz                number of depth samples
% nt                numer of time samples
% dx                horizontal distance per sample dim 1
% dy                horizontal distance per sample dim 2
% dz                depth distance per sample
% dt                time difference per sample
% order             Order of the fdm scheme, example 2, 6, etc...
% refcond           reflectifve condition at the surface not implemented
%                   (refconf=0) or implemented with air layer (refcond=1)
%                   or within the equation (redcon=2)

% add grid points for boundary condition
taper=50;
toptaper=taper*1;

%% Initial conditions extension
model=extend(model,[taper,taper,toptaper],[taper,taper,taper],'zeros','zeros');

%% Velocity extension
if refcond==0 %we do not want a reflective condition at the surface
  v=extend(v,[taper,taper,toptaper],[toptaper,taper,taper],'same','same');
else % we do want a reflective condition at the surface
  v=extend(v,[taper,taper,toptaper],[taper,taper,taper],'same','air');
end %if


%% Initialize storage
[nx,ny,nz] = size(model);
data = zeros(nx,ny,nt);
fdm  = zeros(nx,ny,nz,3);


%% Forward-Time Modeling
fdm(:,:,:,2) = model;
data(:,:,1)  = model(1,:,:);

% finite difference coefficients
r = (v*dt/dx).^2;    % wave equation coefficient assuming dx=dy=dz

[c0 , c ] =HighOrderCoefs( order );

% common indicies
ix   = order+1:(nx-order);     % interior x
iy   = order+1:(ny-order);     % interior y
iz   = order+1:(nz-order);     % interior z

for it = 2:nt
    % finite differencing on interior
    sum1=0; sum2=0; sum3=0;
    
    for j=1:order
    sum1=sum1+ c(j)*(fdm(ix-j,iy,iz,2)+fdm(ix+j,iy,iz,2));
    end
    
    for k=1:order
    sum2=sum2+c(k)*(fdm(ix,iy-k,iz,2)+fdm(ix,iy+k,iz,2));
    end
    
    for l=1:order
    sum3=sum3+c(l)*(fdm(ix,iy,iz-l,2)+fdm(ix,iy,iz+l,2));
    end
    

    
    fdm(ix,iy,iz,3) = 2.*fdm(ix,iy,iz,2) - fdm(ix,iy,iz,1) + ...
        r(ix,iy,iz).*(3*c0*fdm(ix,iy,iz,2) + sum1 + sum2 + sum3);
    
    % update fdm for next time iteration
    fdm(:,:,:,1) = fdm(:,:,:,2);
    fdm(:,:,:,2) = fdm(:,:,:,3);
    
    % update data and manage the z taper according to cases
    if refcond<=1
    data(:,:,it) = fdm(:,:,toptaper+1,2);
    else
    data(:,:,it) = fdm(:,:,1,2);   
    end
    
    %save the calculation to file and manage the x,y,z tapers
    tosave=fdm(taper+1:nx-taper,taper+1:ny-taper,1:nz-taper,2);
    if refcond<=1 %we have an extended model
        tosave =tosave(:,:,toptaper+1:end,:);
    end %if
    save(['snapshot3D-it-',num2str(it),'.mat'],'tosave');
    
end % time loop

%cut out the x and y taper in the data
data = data(taper+1:nx-taper,taper+1:ny-taper,:);


