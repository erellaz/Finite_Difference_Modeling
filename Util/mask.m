function [mas] = mask(nx,nz,taper)

mas=zeros(nz,nx);
mas=mas + 1;

iz = 1:taper;
%boundary = (exp(-( (0.015*(taper-iz)).^2 ) )).^10;
%boundary = (exp(-( (0.285*(taper-iz)/(taper-1)).^2 ) )).^10;
boundary = (exp(-( (0.4*(taper-iz)/(taper-1)).^2 ) )).^10;
boundary = boundary';
figure;
plot(boundary);

iz   = 2:(nz-1); 
izb  = 1:nz;

for ixb = 1:taper
        %left side
        mas(izb,ixb) = boundary(ixb).*mas(izb,ixb);
       
        %right side
        ixb2 = nx-taper+ixb;
        mas(izb,ixb2) = boundary(nx-ixb2+1).*mas(izb,ixb2);
     
        %bottom
        izb2 = nz-taper+ixb;
        mas(izb2,:) = boundary(nz-izb2+1).*mas(izb2,:);

end
 
figure;
imagesc(mas);
colormap('gray');