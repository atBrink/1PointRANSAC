function [optimalPose, optimalE, optimalConsensusSet,i] = fivePointRANSAC(...
    x1, x2, K, epsilon, errThreshold, iterations)

    m = size(x1,2);
    s = 5; % Number of points needed to reach a solution
    
    % init optimal hypothesis & inliers variables:
    optimalPose = zeros(3,4);
    optimalConsensusSet = 0;
    
    for i = 1:iterations
        % Randomly select s matching pair(s)
        randind = randperm(m,s);
        keyPointFrame1 = x1(:,randind);
        keyPointFrame2 = x2(:,randind);
        
        % Estimate all essential matrices that fit the image points:
        [eMatrix, ~] = fivePoint(keyPointFrame1(1:2,:), ...
            keyPointFrame2(1:2,:), K, K);
        
        if size(eMatrix,2) <1
            continue
        end
        
        % Check which essential matrix is the correct one using the
        % Cheirality condition:
        [E_est,~, ~, ~] = cheirality(eMatrix, x1', x2', K, K);        
        
        % Check inliers:
        sampsonDist = sampsonDistance(x1,x2, E_est);
        currInliers = find(sampsonDist < (errThreshold));

        % Save the pose estimate with the most inliers:
        if length(currInliers) > 100
            % Randomly select s matching pair(s)
            n = size(currInliers,2);
            randind = randperm(n,s);
            refined_keyPointFrame1 = x1(:,currInliers(randind));
            refined_keyPointFrame2 = x2(:,currInliers(randind));

            [eMatrix, ~] = fivePoint(refined_keyPointFrame1(1:2,:), ...
                refined_keyPointFrame2(1:2,:), K, K);
            if size(eMatrix,2) < 1
                continue
            end
            [refined_E_est, refinedP_est, ~, ~] = cheirality(eMatrix, ...
                x1', x2', K, K);  
            
            sampsonDist = sampsonDistance(x1,x2, refined_E_est);
            refinedInliers = find(sampsonDist < (errThreshold));
            
            if length(refinedInliers) > length(optimalConsensusSet)
                optimalPose = refinedP_est;
                optimalE = refined_E_est;
                optimalConsensusSet = refinedInliers;
            end
            % if number of inliers does not change - end loop
            if (length(refinedInliers) == length(optimalConsensusSet)) && ...
                    length(optimalConsensusSet) > epsilon*m
                break
            end
        end
    end
end