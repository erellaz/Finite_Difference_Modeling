function [data snapshot] = fdm2d(v,model,dz,dx,nt,dt)
%
% model(nz,nx)      model vector
% v(nz,nx)          velocity model
% nx                number of horizontal samples
% nz                number of depth samples
% nt                numer of time samples
% dx                horizontal distance per sample
% dz                depth distance per sample
% dt                time difference per sample

% add grid points for boundary condition
taper=20;
model = [repmat(model(:,1),1,taper), model, repmat(model(:,end),1,taper)];
model(end+1:end+taper,:) = repmat(model(end,:),taper,1);
figure; imagesc(model); colormap('jet'); title('Wavefield extended');

v = [repmat(v(:,1),1,taper), v, repmat(v(:,end),1,taper)];
v(end+1:end+taper,:) = repmat(v(end,:),taper,1);
figure; imagesc(v); colormap('jet'); title('Extended velocity');

%% Initialize storage
[nz,nx] = size(model);
data = zeros(nx,nt);
fdm  = zeros(nz,nx,3);

%% Boundary Absorbing Model
iz = 1:taper;
%boundary = (exp(-( (0.015*(taper-iz)).^2 ) )).^10; %for taper=20
%boundary = (exp(-( (0.285*(taper-iz)/(taper-1)).^2 ) )).^10;
boundary = (exp(-( (0.4*(taper-iz)/(taper-1)).^2 ) )).^10;
boundary = boundary';
figure; plot(boundary); colormap('gray'); title('Absorbing boundary');

%% Forward-Time Modeling
fdm(:,:,2) = model;
data(:,1)  = model(1,:);

% finite difference coefficients
a = (v*dt/dx).^2;    % wave equation coefficient
b = 2-4*a;

% common indicies
iz   = 2:(nz-1);     % interior z
ix   = 2:(nx-1);     % interior x
%izb  = 1:nz-taper;      % boundary z

snapshot = zeros(nz,nx,nt);

for it = 2:nt
    % finite differencing on interior
    fdm(iz,ix,3) = b(iz,ix).*fdm(iz,ix,2) - fdm(iz,ix,1) + ...
        a(iz,ix).*(fdm(iz,ix+1,2) + fdm(iz,ix-1,2) + ...
        fdm(iz+1,ix,2) + fdm(iz-1,ix,2));
    
    % finite differencing at ix = 1 and ix = nx (sides)
    fdm(iz,1,3) = b(iz,1).*fdm(iz,1,2) - fdm(iz,1,1) + ...
        a(iz,1).*(fdm(iz,2,2) + fdm(iz+1,1,2) + fdm(iz-1,1,2));
    fdm(iz,nx,3) = b(iz,nx).*fdm(iz,nx,2) - fdm(iz,nx,1) + ...
        a(iz,nx).*(fdm(iz,nx-1,2) + fdm(iz+1,nx,2) + ...
        fdm(iz-1,nx,2));
    
    % finite differencing at iz = 1 and iz = nz (surface, bottom)
    fdm(1,ix,3) = b(1,ix).*fdm(1,ix,2) -  fdm(1,ix,1) + ...
        a(1,ix).*(fdm(2,ix,2) + fdm(1,ix+1,2) + fdm(1,ix-1,2));
    fdm(nz,ix,3)= b(nz,ix).*fdm(nz,ix,2)- fdm(nz,ix,1) + ...
        a(nz,ix).*(fdm(nz-1,ix,2) + fdm(nz,ix+1,2) + fdm(nz,ix-1,2));
    
    % finite differencing at four corners (1,1), (nz,1), (1,nx), (nz,nx)
    fdm(1 ,1 ,3) = b(1 , 1).*fdm(1 ,1 ,2) -fdm(1 ,1 ,1) + ...
        a(1 , 1)*(fdm(2,1,2) + fdm(1,2,2));
    fdm(nz,1 ,3) = b(nz, 1).*fdm(nz,1 ,2) -fdm(nz,1 ,1) + ...
        a(nz, 1)*(fdm(nz,2,2) +fdm(nz-1,1,2));
    fdm(1 ,nx,3) = b(1 ,nx).*fdm(1 ,nx,2) -fdm(1 ,nx,1) + ...
        a(1 ,nx)*(fdm(1,nx-1,2) +fdm(2,nx,2));
    fdm(nz,nx,3) = b(nz,nx).*fdm(nz,nx,2) -fdm(nz,nx,1) + ...
        a(nz,nx)*(fdm(nz-1,nx,2) +fdm(nz,nx-1,2));
    
    % update fdm for next time iteration
    fdm(:,:,1) = fdm(:,:,2);
    fdm(:,:,2) = fdm(:,:,3);
    
    % apply absorbing boundary conditions to 3 sides (not surface)
    izbt  = 1:nz; %redefine izb for cleaner absorbing conditions
    for ixb = 1:taper
        %left side
        fdm(izbt,ixb,1) = boundary(ixb).*fdm(izbt,ixb,1);
        fdm(izbt,ixb,2) = boundary(ixb).*fdm(izbt,ixb,2);
        %right side
        ixb2 = nx-taper+ixb;
        fdm(izbt,ixb2,1) = boundary(nx-ixb2+1).*fdm(izbt,ixb2,1);
        fdm(izbt,ixb2,2) = boundary(nx-ixb2+1).*fdm(izbt,ixb2,2);
        %bottom
        izb2 = nz-taper+ixb;
        fdm(izb2,:,1) = boundary(nz-izb2+1).*fdm(izb2,:,1);
        fdm(izb2,:,2) = boundary(nz-izb2+1).*fdm(izb2,:,2);
    end
    
    % update data
    data(:,it) = fdm(1,:,2);
    
    %{
    subplot(2,2,3),imagesc(data');
    title(['Time index: ',num2str(it)])
    drawnow
    %}
    snapshot(:,:,it) = fdm(:,:,2);
end % time loop

data = data(taper+1:nx-taper,:);
snapshot =snapshot(1:nz-taper,taper+1:nx-taper,:);