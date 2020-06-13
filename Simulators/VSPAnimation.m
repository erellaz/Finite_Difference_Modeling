    vidObj = VideoWriter('VSP.avi');
    open(vidObj);
   
    figure(gcf)

    ixs = 250; % VSP position
    
    %% Initial wavefield

    % initial wavefield ricker of spatial frequency f
    rw = ricker2d(0.008,nx,dx,nz,dz,ixs*dx,0);

    %% Plot the velocity model
    subplot(2,2,1)
    imagesc(x,z,vel)
    xlabel('Distance (m)'); ylabel('Depth (m)');
    title('Velocity Model');

    wellx=(z*.0)+ixs*dx;
    wellz=z;

        hold on
        hwell = plot(wellx,wellz,'g');
        hold off
    colormap(seismic)
    
    %% Plot initial wavefield
    set(hwell,'XData',wellx,'YData',wellz);
    subplot(2,2,2)
    imagesc(x,z,rw)
    xlabel('Distance (m)'); ylabel('Depth (m)');
    title(['Shot ',num2str(ixs),' at ',num2str(x(ixs)),' m']);
    colormap(seismic)

    % generate shot record
    tic
    [data snaps] = fdm2d(vel,rw,dz,dx,nt,dt);
    toc
    
    data = data(1:end,:)';

    for i = 1:nt
        % plot VSP evolution
        ds = zeros(nz,nt);
        ds(:,1:i) = snaps(1:nz,ixs,1:i);
        subplot(2,2,3)
        imagesc(t,z,ds), xlabel('Time (s)'), ylabel('Depth (m)'), title('VSP')
        caxis([-0.1 0.1])

        % plot wave propagation
        subplot(2,2,4)
        imagesc(x,z,snaps(1:end,1:end,i))
        xlabel('Distance (m)'), ylabel('Depth (m)')
        title(['Wave Propagation t = ',num2str(t(i),'%10.3f')])
        caxis([-0.5 .5])
            hold on 
            plot(wellx,wellz,'g')
            hold off
        writeVideo(vidObj,getframe(gcf));
        drawnow;
    end
    close(vidObj);