function displayPoints(aPts, bPts)

    set(gca, 'FontSize', 12)

    hold off
    plot(aPts(:, 1), aPts(:, 2), 'k+')
    hold on
    plot(bPts(:, 1), bPts(:, 2), 'go')
    axis equal
    xlim([min(bPts(:, 1)) - 1.5, max(bPts(:, 1)) + 1.5])
    ylim([min(bPts(:, 2)) - 1.5, max(bPts(:, 2)) + 1.5])

    pbaspect([1, 1, 1])
end