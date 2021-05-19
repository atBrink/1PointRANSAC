function [F_est, E_est] = estimateFundamentalMatrix1(x1,x2,K)
    % normalize image points:
    %N = {Normalization(x1), Normalization(x2)};
    %xn = {N{1}*x1; N{2}*x2};
    xn = {K\x1; K\x2};
    
    % init M matrix and size variables
    n = size(x1,2);
    m = (length(x1(:,1)))^2;
    M = zeros(n, m);

    % Create the M matrix
    for j = 1:n
        % Every row of M is defined as [\bar{x_i}*x_i, \bar{x_i}*y_i ...] which
        % has the size 1x(length(x_i)^2)
        xx = xn{1}(:,j)*xn{2}(:,j)';
        M(j,:) = xx(:)';
    end
    
    % Solve the homogeneous Least square system then extract the solution v:
    [~,~,V] = svd(M);
    v = V(:,end);
    Eapprox = reshape(v, [3,3])';

    % Form an F-matrix from the solution v of the leat squares problem:
    [U,~,V] = svd(Eapprox);

    if det(U*V')>0
        E = U*diag([1, 1, 0])*V';
    else
        V = -V;
        E = U*diag([1, 1, 0])*V';
    end
    E_est = E;
    % Calculate the Un-normalized F-matrix:
    % E = (K')^TFK -> F = inv((K')^T) E inv(K)
    F = K'\E/K;
    %F = N{2}'*Fn*N{1};
    F_est = F./F(3,3);
end