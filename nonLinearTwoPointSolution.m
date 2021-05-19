function [theta, phi_c] = nonLinearTwoPointSolution(x1,x2)
% minimal 2point solver
    x = x1(1,:);
    y = x1(2,:);
    z = x1(3,:);
    xPrime = x2(1,:);
    yPrime = x2(2,:);
    zPrime = x2(3,:);
    
    f = @(theta,phi_c, i) -x(i)*yPrime(i)*cos(phi_c) + y(i)*xPrime(i)*cos(theta-phi_c) ...
        + z(i)*yPrime(i)*sin(phi_c) + y(i)*zPrime(i)*sin(theta-phi_c);
    
    
    Jf = @(theta, phi_c, i) [-y(i)*xPrime(i)*sin(theta-phi_c) + y(i)*zPrime(i)*cos(theta-phi_c);
            x(i)*yPrime(i)*sin(phi_c) + y(i)*xPrime(i)*sin(theta-phi_c) - ...
            y(i)*zPrime(i)*cos(theta-phi_c) + z(i)*yPrime(i)*cos(phi_c)];
    
    N = 4;
    theta = 0;
    phi_c = 0;
    for i = 1:N
        for j = 1:size(x1,2)
            a(j,:) = Jf(theta, phi_c, j);
            b(j,:) = f(theta, phi_c, j);
        end
            newValues = a^(-1)*b + [theta; phi_c];
        
            theta = newValues(1);
            phi_c = newValues(2);
    end
    f(theta,phi_c,1);
end
