%% Base on the paper: "Advanced finite difference methods for seismic 
%% modeling" Liu and Sen 2009

% Interestingly: the stability formula (16) is a property of the explicit 
% finite difference equation (7) itself.
% NB: This is a 1D analysis.

maxorder=50;

stability=zeros(maxorder,1);

for order =1:1:maxorder;


stability(order)=EFDMstability(order);

end

plot(stability);
xlabel('Order'), ylabel('Stability Factor'), 
title('Stability zone of the 1D EFDM with increasing order of the space stencil.')
