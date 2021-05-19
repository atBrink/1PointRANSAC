function X = DLT(x1,x2,P1,P2,K)
    % Normalize Correspondance-points
    %xn{1,1} = K\x1;
	%xn{2,1} = K\x2;
    xn{1,1} = x1;
	xn{2,1} = x2;  
    n = size(x1, 2);
    %M = zeros(3*n, 12+n);
    X = [x1; ones(1,n)];
    
    % DLT for Triangulation:
    for j = 1:n
        % Normalized triangulation:
        M = [P1 -xn{1}(:,j) zeros(3,1);
            P2 zeros(3,1) -xn{2}(:,j)];

        [U,S,V] = svd(M);
        v = V(:,end);
        if (v(end) < 0)
            v = -v;
        end
        X(:,j) = v(1:4);
    end
    X = pflat(X); % Convert to Cartesian coordinates
end