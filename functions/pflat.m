function a = pflat(x)
%FPLAT Given homogeneous coordinate array, converting it to 
%   cartesian coordinates.
%
%   INPUT: n*m array of Homogeneous coordinates
%   OUTPUT: n*m arry of cartesian coordinates (w_tilde = 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    n = size(x,1);  % Number of dimensions, last entry is the w_tilde
    m = size(x,2);  % number of coordinate points
    
    w_tilde = x(end,:);	% Homogeneous scalar
    a = x./repmat(w_tilde, [n,1]); % Convert to cartesian coordinates and save in a.
end
