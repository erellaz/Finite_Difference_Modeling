function [c0 ,c ] = HighOrderCoefs( N )
%HIGHORDERCOEFS calculates the Cn coefficient for high order spatial
% derivatives (order 2N)
%   See Liu and Sen 2009 "Advanced finite-difference methods for seismic
%   modelling", formula (21)
%   Note that formula (21) is correct for cn but incorrect for c0. 
%   The correct c0 formula is given later in A6.

c=zeros(N,1);

for n=1:N
    prod=1;
    
    for m=1:n-1
    prod=prod*abs(m^2/(m^2-n^2));    
    end %m
    
    for m=n+1:N
    prod=prod*abs(m^2/(m^2-n^2));   
    end %m
    
    c(n)=((-1)^(n+1)/n^2)*prod;
end %m

c0=-2*sum(c); % Liu's paper does not have the correct sign in (21)

end

