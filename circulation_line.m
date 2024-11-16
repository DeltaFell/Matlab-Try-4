function circulation = circulation_line(u_inter,v_inter,foil_coords)
    VxC = u_inter(foil_coords(:,1),foil_coords(:,2));
    VyC = v_inter(foil_coords(:,1),foil_coords(:,2));
    circulation = trapz(foil_coords(:,1),VxC) + trapz(foil_coords(:,2),VyC);
    %figure(1)
    %quiver(foil_coords(1:5:end,1),foil_coords(1:5:end,2),VxC(1:5:end).*0.1, VyC(1:5:end).*0.1,'AutoScale','off','linewidth',1)
    %plot(foil_coords(:,1),VxC,'linewidth',2)
    %xlabel('x-coordinates of contour data points')
    %ylabel('Interpolated u component')
    %plot(foil_coords(:,2),VyC,'linewidth',2)
    %xlabel('y-coordinates of contour data points')
    %ylabel('Interpolated v component')
end