function [P, U] = nonLinearTriangulationLM(K, P1, P2, x1, x2)
    
    P = {P1, P2};
    
    if size(x1,1) < 3
        x1 = [x1; ones(1, size(x1,2))];
    end
    if size(x2,1) < 3
        x2 = [x2; ones(1, size(x2,2))];
    end
    x = {K\x1, K\x2};
    
    U = DLT(x{1},x{2},P1,P2,K);
    
    u = { x{1}, x{2} };
    
    % Pick lambda value from set:
    lambda = 0.1;
    nSteppes = 1000;
    errorList = zeros(1, nSteppes); % init array to store reproj errors
    
    % LM update steps:
    for j = 1:nSteppes
        % Compute the reprojection error and the values of all the residuals for
        % the current solution P,U,u:
        [errorList(j), res] = ComputeReprojectionError(P,U,u);
        % Compute the r and J matrices for the approximate linear least squares
        % problem:
        [r, J] = LinearizeReprojErr(P, U, u);
        
        % Compute the LM update:
        C = J'*J+lambda*speye(size(J, 2));
        c = J'*r;
        deltav = -C\c;

        % Update the variables:
        [P, U] = update_solution(deltav, P, U);
    end
end

