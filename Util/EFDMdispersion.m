function [ d,theta,kh ] = EFDMdispersion(order,r)
% EFDMSTABILITY calculate the dispersion of the 2D 
% arbitrary order EFDM. Based on Liu and Sen 2009

%% Prepare
% order=2;
% r=3000*0.001/10;

[c0 , c ] =HighOrderCoefs( order );
% prepare dimension 1
kh1 = 0:.01:3.14;
% prepare dimension 2
theta1 = 0:.01:6.28;

    [kh,theta] = meshgrid(kh1,theta1);
    summ=zeros(size(kh));
    
 %% Formula from Liu & Sen
        for n=1:order
            summ=summ+c(n).*((sin(n.*kh.*sin(theta)./2)).^2 + (sin(n.*kh.*cos(theta)./2)).^2);
        end
    
    d=(2./(r.*kh)).*asin((r^2.*summ).^.5);
    
%% My own formula, same result as Liu & Sen, but does not look as much as the 2D canonical formula
%     for n=1:order
%              summ=summ+c(n).*(cos(n.*kh.*cos(theta)) + cos(n.*kh.*sin(theta)));
%     end
%     
%     d=(1./(r.*kh)).*acos((r^2.*(c0+summ))+1);
    
%% Canonical Order 2 formula   
% d=(1./(r.*kh)).*asin(r.* (   (sin(.5.*kh.*sin(theta))).^2 + ...
%                            (sin(.5.*kh.*cos(theta))).^2   ).^.5 );

%% Plot
% figure;   
% imagesc(kh1,theta1,d);

% [x,y] = pol2cart(theta,kh); xlabel('kh'); ylabel('Theta');
% 
% hFig = figure();
% set(hFig, 'Position', [0 0 1300 500])
% subplot(1,2,1);
% surf(x,y,d,'edgecolor','none');
% view(0,90);
% axis tight; colorbar;
% 
% subplot(1,2,2);
% plot(kh,d(1,:),kh,d(39,:),kh,d(78,:),kh,(zeros(1,315)+1));
% axis([0 3.15 .7 1.1]); 
% xlabel('kh'); 
% title('Dispersion at theta=0, theta=Pi/8 and theta=Pi/4');

