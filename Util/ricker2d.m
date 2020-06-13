function [rw,s1,s2] = ricker2d(f,n1,d1,n2,d2,i1,i2)
% RICKER creates a 2D causal ricker wavelet signal on rectangular grid
%
% f frequency
% n1 size along dim 1
% d1 step along dim 1
% i1 ricker position along dim 1
% n2 size along dim 2
% d2 step along dim 2
% i2 ricker position along dim 2

% example
% [rw,s1,s2] =ricker2d(40,251,0.001,300, 0.001,0.001*75,0.001*55); %in time
% rw = ricker2d(0.005,300,10,200,10,75*10,0); % in space

% prepare dimesion 1
S1 = d1*(n1-1);
s1 = 0:d1:S1;

% prepare dimension 2
S2 = d2*(n2-1);
s2 = 0:d2:S2;

    [t1,t2] = meshgrid(s1-i1,s2-i2);
    rw = (1-(t1.^2+t2.^2)*f^2*pi^2).*exp(-(t1.^2+t2.^2)*pi^2*f^2);

end