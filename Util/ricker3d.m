function [rw,s1,s2,s3] = ricker3d(f,n1,d1,n2,d2,n3,d3,i1,i2,i3)
% RICKER creates a 2D causal ricker wavelet signal on a cube
%
% f frequency
% n1 size along dim 1
% d1 step along dim 1
% i1 ricker position along dim 1

% n2 size along dim 2
% d2 step along dim 2
% i2 ricker position along dim 2

% n3 size along dim 3
% d3 step along dim 3
% i3 ricker position along dim 3


% Example:
% rw = ricker3d(0.006,300,10,200,10,250,10,75*10,75*10,0); % in space
% Then: 
% imagesc(squeeze(rw(:,75,:))), caxis([-.1 .1]);
% imagesc(squeeze(rw(75,:,:))), caxis([-.1 .1]);
% imagesc(squeeze(rw(:,:,1))), caxis([-.1 .1]);

% prepare dimension 1
S1 = d1*(n1-1);
s1 = 0:d1:S1;

% prepare dimension 2
S2 = d2*(n2-1);
s2 = 0:d2:S2;

% prepare dimension 3
S3 = d3*(n3-1);
s3 = 0:d3:S3;

    [t1,t2,t3] = meshgrid(s1-i1,s2-i2,s3-i3); % because we want z as the fast dimension
    rw = (1-(t1.^2+t2.^2+t3.^2)*f^2*pi^2).*exp(-(t1.^2+t2.^2+t3.^2)*pi^2*f^2);

end