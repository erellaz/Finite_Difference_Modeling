%% Here we display the Cn coefficients for different orders 
%%in the form of a table
% Line n shows the coefficients to be used for an order 2n stencil

maxorder=6;

table=zeros(maxorder, maxorder+1);

for order =1:1:maxorder;
 [c0 , c ] =HighOrderCoefs( order );
 line=[c0 ; c ; zeros(maxorder-order,1)]';
 table(order,:) =line;
end
table