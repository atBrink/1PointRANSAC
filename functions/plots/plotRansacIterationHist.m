function plotRansacIterationHist(ransacIterations)
%PLOTRANSACITERATIONHIST Summary of this function goes here
%   Detailed explanation goes here
    
    figure
    title 'number of RANSAC iterations needed to find enough inliers'
    hold on

    h1=histogram(ransacIterations(1,:));
    h1.NumBins = 10;

    h2=histogram(ransacIterations(2,:));
    h2.NumBins = 10;
    
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

