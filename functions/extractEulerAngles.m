function [alpha, beta, gamma] = extractEulerAngles(R)
%EXTRACTEULERANGLES Summary of this function goes here
%   Detailed explanation goes here
    alpha = atan(R(2,1)/R(1,1));
    beta = atan(-R(3,1)/sqrt(R(3,2)^2+R(3,3)^2));
    gamma = atan(R(3,2)/R(3,3));
end

