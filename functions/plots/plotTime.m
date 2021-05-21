function plotTime(ransacTimes)
%PLOTRANSACITERATIONHIST Summary of this function goes here
%   Detailed explanation goes here
    m = size(ransacTimes,1);
    
    figure
    title 'Time elapsed in order to finish RANSAC'
    hold on

	h1=histogram(ransacTimes(1,:));
	h1.NumBins = 1;
	h2=histogram(ransacTimes(2,:));
	h2.NumBins = 15;

    mu_1p = mean(ransacTimes(1,:),2);
    mu_5p = mean(ransacTimes(2,:),2);

    
    txt_1p = ['\leftarrow avg. time 1p: ',num2str(mu_1p)];
    text(mu_1p,20,txt_1p)
    txt_5p = ['\leftarrow avg. time 5p: ',num2str(mu_5p)];
    text(mu_5p,15,txt_5p)
    
    xline(mu_1p,'b-')%,txt_1p, 'LineWidth',1, 'LabelVerticalAlignment','middle')
    xline(mu_5p,'r-')%,txt_5p,'LineWidth',1)

    xlabel 'elapsed time'
    ylabel 'occurances'
    legend('1p RANSAC','5p RANSAC', 'avg 1p RANSAC', 'avg 5p RANSAC');
end

