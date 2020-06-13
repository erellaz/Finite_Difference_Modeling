function  video3darray( array , name)
%VIDEO3DARRAY make an imagesc video for visu of a 3D array
% example video3darray( snapshot , 'shot-test.avi')
[nz,nx,nt] = size(array);

vidObj= VideoWriter(name);
vidObj.Quality=100;
open(vidObj);

    for i = 1:nt
    imagesc(squeeze(array(:,:,i)));
    %colormap('seismic');
    colormap('gray');
    caxis([-.1 .1]);
    writeVideo(vidObj,getframe(gcf));
        drawnow;
    end
    close(vidObj);
end

