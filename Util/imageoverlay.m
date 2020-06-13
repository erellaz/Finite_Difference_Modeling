function imageoverlay(G,H,image)
% Example imageoverlay(vel,im,'test4.jpg');

%deal with velocity
C = colormap('jet');  % Get the figure's colormap.
L = size(C,1);
Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));
K = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.


%deal with the waveform
wrap = circular_colormap(gray);
CC = colormap(wrap);  % Get the figure's colormap.
LL = size(CC,1);
%Gss = round(interp1(linspace(min(H(:)),max(H(:)),LL),1:LL,H));
Gss = round(interp1(linspace(-1*max(H(:)),max(H(:)),LL),1:LL,H));
KK = reshape(CC(Gss,:),[size(Gss) 3]); % Make RGB image from scaled.

KK=1-KK;
KKK=K+2*KK;
imwrite(KKK,image);