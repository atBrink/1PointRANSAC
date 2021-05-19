function [optimalPose, optimalE, optimalConsensusSet] = eightPointRANSAC(x1, ...
    x2, K, errThreshold, iterations)
    
    s = 8; % Number of points needed to estimate the Fundamental Matrix
    m = size(x1,2);
    
    % init optimal F & consensus set variables:
    optimalPose = zeros(3,3);
    optimalConsensusSet = [];
    
    for i =1:iterations
        
        % Randomly select s matching pair(s)
        randind = randperm(m,s);
        x1r = x1(:,randind);
        x2r = x2(:,randind);

        % Esimate Fundamental Matrix based on randomly selected matching
        % pairs and the intrinsic camera parameters K:
        F_est = estimateFundamentalMatrix1(x1r, x2r, K);
        
        % Check number of inliers
        sampsonDist = sampsonDistance(x1,x2, F_est);
        currInliers = find(sampsonDist < errThreshold);
        
        if length(currInliers) > length(optimalConsensusSet)
            optimalPose = F_est;
            optimalConsensusSet = currInliers;
        end
    end
    
    % Build the essential matrix based on the best estimated Fundamental
    % Matrix:
    E = K'*optimalPose*K;
    % Check which is the correct Pose estimate with the Cheirality
    % Condition:
    P_est = checkCorrectPoseEstimate(E, x1, x2, K);
    optimalPose = P_est;
    optimalE = E;
end