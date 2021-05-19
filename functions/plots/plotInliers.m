function plotInliers(x, ConsensusSet,timestamps)
%PLOTINLIERS Summary of this function goes here
%   Detailed explanation goes here
    m = size(x,2);
    nbrInliers = zeros(2,m);
    nbrMatches = nbrInliers;
    inliers = nbrMatches;
    timestamps=timestamps(1,1:m-1);
    for i = 2:m
        nbrInliers(:,i) = [ length(ConsensusSet{1,i});
                            length(ConsensusSet{2,i})];
        nbrMatches(:,i) = [ length(x{1,i});
                            length(x{2,i})];
        inliers(:,i) = [nbrInliers(1,i)/nbrMatches(1,i);
                        nbrInliers(2,i)/nbrMatches(2,i)];
    end
    figure
    plot(timestamps, inliers(1,2:end),'b--','LineWidth',1)
    hold on
    plot(timestamps, inliers(2,2:end),'r--','LineWidth',1)
    hold off
    xlabel 'time s'
    ylabel 'inliers/matches'
    title 'Fraction of inliers over time'
    axis([0 timestamps(end) 0 1])
    legend('1pRANSAC','5pRANSAC','Location','SouthEast')
end

