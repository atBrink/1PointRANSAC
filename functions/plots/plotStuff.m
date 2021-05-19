function plotStuff(im1, im2, P, set, K, x1, x2, titleString)

    P1 = [eye(3), zeros(3,1)];
    [P,X] = nonLinearTriangulationLM(K, P1, P, x1,x2);
    P = P{2};
    xproj = pflat(K*P*X);
    
    if size(set,2)>0
        xprojInliers = pflat(K*P*X(:,set));
    else
        xprojInliers = zeros(4,1);
    end
 
    % Camera Center and principal axis
    c1 = pflat(null(P1));
    p1 = P1(3,1:3);
    c = pflat(null(P));
    p = P(3,1:3);
    
    % image points & Projected image points
    fig1 = figure('Name',sprintf('%s Image points & Projected image points', titleString));
    imagesc(im2);
    colormap Gray; hold on;
    plot(x2(1,:),x2(2,:),'b.','DisplayName', 'Image Points');
    plot(xproj(1,:),xproj(2,:), 'ro', 'DisplayName', 'Projected Points');
    plot(xprojInliers(1,:),xprojInliers(2,:), 'go', 'DisplayName', ...
        'Projected Points inliers');
    legend
    title(titleString)
    

    % remove extreme outlier points to make better 3D Plot:
    X_mask = X < (mean(X) + 15);
    X_test=[];
    for i = 1:size(X,2)
        if ~any(X_mask(:,i) == 0)
            X_test(:,end+1) = X(:,i);
        end
    end
    %X_test = X;
    figure('Name','3D points');
    plot3(X_test(1,:),X_test(2,:),X_test(3,:), '.')
    hold on;
    quiver3(c1(1),c1(2),c1(3),p1(1),p1(2),p1(3),5, 'LineWidth', 1, ...
        'MaxHeadSize',0.5, 'DisplayName', 'Principal Axis for P1');
    quiver3(c(1),c(2),c(3),p(1),p(2),p(3),5, 'LineWidth', 1, ...
        'MaxHeadSize',0.5, 'DisplayName', 'Principal Axis for P2');
    xlabel 'x';
    ylabel 'y';
    zlabel 'z';
    legend
end
