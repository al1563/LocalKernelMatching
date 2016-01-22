function unused = displayPoints(aPts, bPts)

    set(gca, 'FontSize', 12)

    hold off
    aPts.show('go')
    hold on
    bPts.show('b.')
    axis equal
    
%     xlim([bPts.xmin - 1.5, bPts.xmax + 1.5])
%     ylim([bPts.ymin - 1.5, bPts.ymax + 1.5])

    pbaspect([1, 1, 1])
    drawnow

    unused = 1;
end