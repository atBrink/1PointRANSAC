function distance = sampsonDistance(x1,x2,F)
%SAMPSONDISTANCE Summary of this function goes here
%   Detailed explanation goes here
    Fx1 = F*x1;
    Fx2 = F*x2;
    distance = zeros(1,size(Fx1,2));
    for i=1:size(Fx1,2)
      
        distance(i) = (x2(:,i)'*F*x1(:,i)).^2/(Fx1(1,i)^2 + Fx1(2,i)^2 ...
                            + Fx2(1,i)^2 + Fx2(2,i)^2);
    end
    %distance=(x2'*F*x1)^2./(Fx1(1,:).^2 + Fx1(2,:).^2 ...
    %                        + Fx2(1,:).^2 + Fx2(2,:).^2);

end

