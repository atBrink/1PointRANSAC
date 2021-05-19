function P_est = checkCorrectPoseEstimate(E, x1, x2, K)
    % Normalize Image points since E is defined for Normalized image
    % coordinates:
    x = {x1,x2};
    %xn{1,1} = K\x{1};
    %xn{2,1} = K\x{2};
    xn{1,1} = x{1};
    xn{2,1} = x{2};    
    % from Richard Hartley and Andrew Zisserman's Multiple View Geometry:
    % The Camera Pose P = KR[I, -C] can be calculated from E = UDV', where
    % W is predefined, the Pose can be defined 4 different orientations,
    % only 1 is infront of the camera, and needs to be individually
    % checked:
    W = [   0, -1, 0;
            1, 0, 0;
            0, 0, 1];
        
    [U, ~, V] = svd(E);
    u3 = U(:,3);
    P2_1 = [U*W*V', u3];
    P2_2 = [U*W*V', -u3];
    P2_3 = [U*W'*V', u3];
    P2_4 = [U*W'*V', -u3];
    P2_all = {P2_1, P2_2, P2_3, P2_4};
    
    P1 = [eye(3), zeros(3,1)];
    mostPointsInFrontOfCam = 0;
    % Loop through the four pose candidates, the P which yields the most
    % points in front of the camera is the correct one. This is checked by
    % the Cheirality condition.
    for i = 1:length(P2_all)
        P2 = P2_all{i};
        X = DLT(xn{1},xn{2},P1, P2,K);
        
        camCenter = pflat(null(P2));
        
        % Cheirality Condition:
        pointsInfrontOfCam = X(3,:)-camCenter(3) > 0;
        pointsInfrontOfCam = X(:,pointsInfrontOfCam);
        if length(pointsInfrontOfCam) > length(mostPointsInFrontOfCam)
            mostPointsInFrontOfCam = pointsInfrontOfCam;
            P_est = P2;
        end
    end 
end