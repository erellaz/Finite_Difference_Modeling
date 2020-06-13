vidObj = VideoWriter('LandSurveyAnimation.avi');
open(vidObj);

%% Plot velocity model
subplot(2,2,1)
imagesc(x,z,vel)
xlabel('Distance (m)'); ylabel('Depth (m)');
title('Velocity Model');
hold on
hshot = plot(x(1),z(1),'w*');
hold off
colormap(seismic)

for ixs = 1:nx % shot loop
    % initial wavefield
    rw = ricker2d(0.008,nx,dx,nz,dz,ixs*dx,0);

    % plot initial wavefield
    set(hshot,'XData',x(ixs),'YData',z(1));
    subplot(2,2,2)
    imagesc(x,z,rw)
    xlabel('Distance (m)'); ylabel('Depth (m)');
    title(['Shot ',num2str(ixs),' at ',num2str(x(ixs)),' m']);
    colormap(seismic)

    % generate shot record
    tic
    [data snapshot] = fdm2d(vel,rw,dz,dx,nt,dt);
    toc
    %save(['faultModelData\snapshot',num2str(ixs),'.mat'],'snapshot');
    %save(['faultModelData\shotfdm',num2str(ixs),'.mat'],'data')

    data = data(1:end,:)';

    if ismember(ixs,[1 nx/2 nx])
        start = 1;
    else
        start = nt;
    end

    for i = start:nt
        % plot shot record evolution
        ds = zeros(nt,nx);
        ds(1:i,:) = data(1:i,:);
        subplot(2,2,3)
        imagesc(x,t,ds)
        xlabel('Distance (m)'), ylabel('Time (s)')
        title('Shot Record')
        caxis([-0.1 0.1])

        % plot wave propagation
        subplot(2,2,4)
        imagesc(x,z,snapshot(:,:,i))
        xlabel('Distance (m)'), ylabel('Depth (m)')
        title(['Wave Propagation t = ',num2str(t(i),'%10.3f')])
        caxis([-0.14 1])

        writeVideo(vidObj,getframe(gcf));
        drawnow;
    end %shot loop
end
close(vidObj);
