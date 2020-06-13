function Dispersionplot(torder,r)
% EFDMSTABILITY calculate the dispersion of the 2D 


minorder=torder-1;
maxorder=torder+1;
numorder=1+maxorder-minorder;

%% Plot to examine the influence of the order
ii=1;
figure;
for order=minorder:1:maxorder
[ d,theta,kh ] = EFDMdispersion(order,r);

[x,y] = pol2cart(theta,kh); xlabel('kh'); ylabel('Theta');
subplot(numorder,2,ii);
surf(x,y,d,'edgecolor','none');
view(0,90);
axis tight; colorbar;
title(['Order ',num2str(order)]);
ii=ii+1;

subplot(numorder,2,ii);
plot(kh,d(1,:),kh,d(39,:),kh,d(78,:),kh,(zeros(1,315)+1));
axis([0 3.15 .7 1.1]); 
xlabel('kh'); 
title('Dispersion at theta=0, theta=Pi/8 and theta=Pi/4');
ii=ii+1;
end

%% Plot to examine the influence of r
ii=1;
figure;
numrr=4;
for rr=1:1:numrr;
percent=100-(rr-1)*20;  
[ d,theta,kh ] = EFDMdispersion(order,(r*percent)/100);

[x,y] = pol2cart(theta,kh); xlabel('kh'); ylabel('Theta');
subplot(numrr,2,ii);
surf(x,y,d,'edgecolor','none');
view(0,90);
axis tight; colorbar;
title(['Percent of r=V*tau/h:',num2str(percent),'% of r']);
ii=ii+1;

subplot(numrr,2,ii);
plot(kh,d(1,:),kh,d(39,:),kh,d(78,:),kh,(zeros(1,315)+1));
axis([0 3.15 .7 1.1]); 
xlabel('kh'); 
title('Dispersion at theta=0, theta=Pi/8 and theta=Pi/4');
ii=ii+1;
end