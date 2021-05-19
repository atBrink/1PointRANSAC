function [optimalPose, optimalE, optimalConsensusSet] = onePointRANSAC( ...
    x1, x2, K, errThreshold, iterations)

    m = size(x1,2);
    s = 1; % Number of points needed to reach a solution
    
    % init optimal hypothesis & inliers variables:
    optimalPose = zeros(3,4);
    optimalConsensusSet = 0;
    
    for i = 1:iterations
        % Randomly select s matching pair(s)
        randind = randperm(m,s);
        keyPointFrame1 = x1(:,randind);
        keyPointFrame2 = x2(:,randind);
        
        % Calculate angle theta and a pose estimate:
        theta = angleExtraction(keyPointFrame1, keyPointFrame2);
        rho = 1;
        L = 0.76;
        P_Hypothesis = poseEstimate(theta, L, rho);
        
        %P_Hypothesis = [ 9.999978e-01, 5.272628e-04, -2.066935e-03 -4.690294e-02;
        %    -5.296506e-04, 9.999992e-01, -1.154865e-03, -2.839928e-02;
        %    2.066324e-03, 1.155958e-03, 9.999971e-01, 8.586941e-01];
        
        Tx = [0, -P_Hypothesis(3,4), P_Hypothesis(2,4); 
            P_Hypothesis(3,4), 0, -P_Hypothesis(1,4);
            -P_Hypothesis(2,4), P_Hypothesis(1,4), 0];
        R = P_Hypothesis(:,1:3);
        E_est = Tx*R;
        
        sampsonDist = sampsonDistance(x1,x2, E_est);
        currInliers = find(sampsonDist < (errThreshold));

        % Save the pose estimate with the most inliers:
        if length(currInliers) > 100
            
            % Randomly select s matching pair(s)
            n = size(currInliers,2);
            % Pick new random image correspondance from the set of inliers
            randidx = randperm(n,s);
            refined_keyPointFrame1 = x1(:,currInliers(randidx));
            refined_keyPointFrame2 = x2(:,currInliers(randidx));
            
            % Build new model from the inlier image points:
            refined_theta = angleExtraction(refined_keyPointFrame1, ...
                refined_keyPointFrame2);
            refined_P = poseEstimate(refined_theta, L, rho);
            
            Tx = [0, -refined_P(3,4), refined_P(2,4); 
                    refined_P(3,4), 0, -refined_P(1,4);
                    -refined_P(2,4), refined_P(1,4), 0];
            R = refined_P(:,1:3);
            
            refined_F_est = Tx*R;
            
            % Check inliers of this new refined model:
            sampsonDist = sampsonDistance(x1,x2, refined_F_est);
            refinedInliers = find(sampsonDist < (errThreshold));
            
            if length(refinedInliers) > length(optimalConsensusSet)
                optimalPose = refined_P;
                optimalE = refined_F_est;
                optimalConsensusSet = refinedInliers;
            end
        end
    end 
end