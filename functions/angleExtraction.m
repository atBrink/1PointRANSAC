function theta = angleExtraction(x1, x2)
    % Extract Angle theta from two image point correspondances using
    % equation 10 in the paper:
    % https://doc.rero.ch/record/315821/files/11263_2011_Article_441.pdf
    %
    % INPUT:
    % x1:       3d coordinates of point correspondance in image 1
    % x2:       3d coordinates of point correspondance in image 2
    %
    % OUTPUT:
    % theta:    rotation angle that cooresponds to the movement of a
    %           keypoint between image 1 and 2.
    
    x = x1(1);
    y = x1(2);
    z = x1(3);
    x_prime = x2(1);
    y_prime = x2(2);
    z_prime = x2(3);
    
    theta = -2*atan((y_prime*z - z_prime*y)/(x_prime*z + z_prime*x));
end

