function [x1,x2] = extractMatches(im1,im2)

    % Extract features and Descriptors using SIFT from image 1 & 2
    [f1,d1] = vl_sift( im1, 'PeakThresh', 1);
    [f2,d2] = vl_sift( im2, 'PeakThresh', 1);
    
    % Match the descriptors of both images:
    [matches, ~] = vl_ubcmatch(d1,d2);
    
    % Extract matching points:
    x1 = [f1(1,matches(1,:)); f1(2,matches(1,:))];
    x2 = [f2(1,matches(2,:)); f2(2,matches(2,:))];
end