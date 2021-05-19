function P_est = poseEstimate(theta, L, rho)
    % Estimate pose P from the angle theta using eq. 2 in the paper:
    % https://doc.rero.ch/record/315821/files/11263_2011_Article_441.pdf
    %
    % INPUT:
    % theta:    rotational angle from a matching pair between two images
    % L:        Distance between the camera center and the Back-wheel axis 
    %           of the vehicle
    % rho:      Vehicle Displacement, arbitrarily set to 1
    %
    % OUTPUT:
    % P_est:    Estimated Pose
    
    % Rotational Matrix
    Rv = [cos(theta), -sin(theta), 0;
        sin(theta), cos(theta), 0;
        0,  0,  1];
    
    % Translation Vector
    Tv = [  L*cos(theta) + rho*cos(theta/2) - L;
            rho*sin(theta/2) - L*sin(theta);
            0];
        
    % Build pose matrix P = [R|t]
    P_est = zeros(3,4);
    P_est(:,1:3) = Rv;
    P_est(:,4) = Tv;
end