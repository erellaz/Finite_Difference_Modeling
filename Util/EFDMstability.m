function [ stability ] = EFDMstability( order )
% EFDMSTABILITY Calculates the stability limit of the 1D 
% arbitrary order EFDM. Based on the paper: "Advanced finite difference 
% methods for seismic modeling" Liu and Sen 2009 formula (16).
%
% This summation is also the base for computing 2D and 3D EFDM stability
% see Liu and Sen "A new time space domain high-order finite-difference
% method for the AWE" formula 60 and 61.

[c0 , c ] =HighOrderCoefs( order );

stability=0;

N1=floor((order+1)/2);

for n=1:N1
    stability=stability+c(2*n-1);
end

stability=1/sqrt(stability);

end

