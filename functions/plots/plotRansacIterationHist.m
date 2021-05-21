function plotRansacIterationHist(ransacIterations)
%PLOTRANSACITERATIONHIST Summary of this function goes here
%   Detailed explanation goes here
    m = size(ransacIterations,1);
    
    figure
    title 'number of RANSAC iterations needed to find enough inliers'
    hold on
    for i = 1:m
        h=histogram(ransacIterations(i,:));
        %if i~=1
        h.NumBins = 100;
        %end
    end

    xlabel '# iterations'
    ylabel 'incidenses of # inliers'
    legend('1p RANSAC','5p RANSAC');
    mu_1p = mean(ransacIterations(1,:),2);
    mu_5p = mean(ransacIterations(2,:),2);


    txt_1p = ['\leftarrow avg. iteration 1p: ',num2str(mu_1p)];
    text(mu_1p,20,txt_1p)
    txt_5p = ['\leftarrow avg. iteration 5p: ',num2str(mu_5p)];
    text(mu_5p,30,txt_5p)
    
    xline(mu_1p,'b-')%,txt_1p, 'LineWidth',1, 'LabelVerticalAlignment','middle')

    xline(mu_5p,'r-')%,txt_5p,'LineWidth',1)
end

