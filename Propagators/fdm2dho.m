function [data snapshot] = fdm2dho(v,model,dz,dx,nt,dt,order,refcond)
%
% model(nz,nx)      model vector
% v(nz,nx)          velocity model
% nx                number of horizontal samples
% nz                number of depth samples
% nt                numer of time samples
% dx                horizontal distance per sample
% dz                depth distance per sample
% dt                time difference per sample
% order             Order of the fdm scheme, example 2, 6, etc...
% refcond           reflectifve condition at the surface not implemented
%                   (refconf=0) or implemented with air layer (refcond=1)
%                   or within the equation (redcon=2)

% add grid points for boundary condition
taper=200;
toptaper=taper*1;
[~,inx] = size(model);

%% Initial conditions extension
model = [repmat(model(:,1),1,taper), model, repmat(model(:,end),1,taper)];
model(end+1:end+taper,:) = repmat(model(end,:),taper,1);
if refcond<=1 % we have to extend upward
  model = [zeros(toptaper,inx+2*taper); model]; %then extend upward    
end %if
figure; imagesc(model); colormap('jet'); title('Wavefield extended');

%Velocity extension
v = [repmat(v(:,1),1,taper), v, repmat(v(:,end),1,taper)];
v(end+1:end+taper,:) = repmat(v(end,:),taper,1);
if refcond==0 %if we do not want a reflective condition at the surface
  v = [repmat(v(1,:),toptaper,1); v]; %then extend upward
elseif refcond==1
  airlayer=repmat(v(1,:),toptaper,1).*0+300;
   v = [airlayer; v]; %then extend upward
end %if
figure; imagesc(v); colormap('jet'); title('Extended velocity');

%% Initialize storage
[nz,nx] = size(model);
data = zeros(nx,nt);
fdm  = zeros(nz,nx,3);


%% Forward-Time Modeling
fdm(:,:,2) = model;
data(:,1)  = model(1,:);

% finite difference coefficients
r = (v*dt/dx).^2;    % wave equation coefficient assuming dx=dz

[c0 , c ] =HighOrderCoefs( order );

% common indicies
iz   = order+1:(nz-order);     % interior z
ix   = order+1:(nx-order);     % interior x

snapshot = zeros(nz,nx,nt);

for it = 2:nt
    % finite differencing on interior
    sum1=0; sum2=0;
    
    for j=1:order
    sum1=sum1+ c(j)*(fdm(iz,ix-j,2)+fdm(iz,ix+j,2));
    end
    
    for k=1:order
    sum2=sum2+c(k)*(fdm(iz-k,ix,2)+fdm(iz+k,ix,2));
    end
    
    fdm(iz,ix,3) = 2.*fdm(iz,ix,2) - fdm(iz,ix,1) + ...
        r(iz,ix).*(2*c0*fdm(iz,ix,2) + sum1 + sum2);
    
    % update fdm for next time iteration
    fdm(:,:,1) = fdm(:,:,2);
    fdm(:,:,2) = fdm(:,:,3);
    
    % update data
    if refcond<=1
    data(:,it) = fdm(toptaper+1,:,2);
    else
    data(:,it) = fdm(1,:,2);   
    end
    
    snapshot(:,:,it) = fdm(:,:,2);
end % time loop

data = data(taper+1:nx-taper,:);
snapshot =snapshot(1:nz-taper,taper+1:nx-taper,:);

if refcond<=1 %we have an extended model
  snapshot =snapshot(toptaper+1:end,:,:);
end %if