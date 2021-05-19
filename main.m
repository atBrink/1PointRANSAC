clc; clear variables; close all;
addpath(genpath('functions'));
% Requires vl_sift 

% 1P RANSAC based on the paper:
% https://doc.rero.ch/record/315821/files/11263_2011_Article_441.pdf

% 8P RANSAC based on Hartley and Zisserman: 
% Richard Hartley and Andrew Zisserman (2003).
% Multiple View Geometry in computer vision. 
% Cambridge University Press. ISBN 978-0-521-54051-3.
% https://cmsc426.github.io/sfm/#estfundmatrix


% KITTI image pair - sequence 00
%im1 = single(imread('KITTI-00/000000.png'));
%im2 = single(imread('KITTI-00/000001.png'));
% From opencv camera calibration: 
% https://docs.opencv.org/4.5.1/d4/d94/tutorial_camera_calibration.html
fx = 718.856;
fy = 718.856;
cx = 607.1928;
cy = 185.2157;
K = [fx, 0, cx; 0, fy, cy; 0, 0, 1];

% Image pair from computer vision course along with K matrix:
%im1 = single(rgb2gray(imread('images/house1.jpg')));
%im2 = single(rgb2gray(imread('images/house2.jpg')));
%K = [4765.29213116007,0,1879.56718436226;0,4752.45199112262,1013.16489596634;0,0,1];
sequence='00';
images = dir(sprintf('KITTI-%s/*.png',sequence));
nbrOfImages = length(images);


errThreshold = 0.0001;
iterations1 = 10;
iterations2 = 20;
iterations5 = 200;
iterations8 = 2000;

nbrOfModels = 2;
x = cell(2,nbrOfImages);
P = cell(2,nbrOfImages);
P{1,1} = [eye(3),zeros(3,1)];
P{2,1} = P{1,1};
E = cell(2,nbrOfImages);
R = cell(2,nbrOfImages);
R{1,1} = zeros(3);
R{2,1} = zeros(3);
optimalConsensusSet = cell(2,nbrOfImages);
rotAngles=cell(2,nbrOfImages);
rotAnglesb=cell(2,nbrOfImages);
rotAnglesc=cell(2,nbrOfImages);
for k = 2:nbrOfImages-1
    im1 = sprintf('KITTI-%s/%s',sequence, images(k-1).name);
    im2 =  sprintf('KITTI-%s/%s',sequence, images(k).name);
    
    im1 = single(imread(im1));
    im2 = single(imread(im2));

    % Extract matches using vl_sift
    [x1,x2] = extractMatches(im1,im2);

    % Convert to homogeneous coordinates
    x1 = [x1; ones(1, size(x1,2))];
    x2 = [x2; ones(1, size(x2,2))];

    % Normalize Image points
    x1 = K\x1;
    x2 = K\x2;
    
    x{1,k-1} = x1;
    x{2,k} = x2;

    %%% 1p
    %tic
    [P1,E{1,k}, optimalConsensusSet{1,k}] = onePointRANSAC(x1, x2, K, ...
        errThreshold, iterations1);
    Pbackup{1,k} = P1;
    P{1,k} = P{1,k-1}+P1;
    %timeRANSAC1 = toc
    %tic
    %%% 2p
    %[P2p,E2, optimalConsensusSet2] = twoPointRANSAC(x1, x2, K, ...
    %    errThreshold, iterations2);
    %timeRANSAC2 = toc
    %%% 5p
    %tic
    [P5,E{2,k}, optimalConsensusSet{2,k}] = fivePointRANSAC(x1, x2, K, ...
        errThreshold, iterations5);
    Pbackup{2,k} = P5;
    P{2,k} = P{2,k-1}+P5;
    %timeRANSAC5 = toc
    %[P8p, set8p, X8p, dd8] = eightPointRANSAC(x1, x2, K, ...
     %errThreshold, iterations8);
     
     % Extract Roll, Pitch, Yaw
     R{1,k} = P{1,k}(:,1:3);
     R{2,k} = P{2,k}(:,1:3);
     
    %[yaw, pitch, roll] = extractEulerAngles(R{1,k});
    %rotAnglesc{1,k} = [yaw; pitch; roll];
    %[yaw, pitch, roll] = extractEulerAngles(R{2,k});
    %rotAnglesc{2,k} = [yaw; pitch; roll];
    
    rotAngles{1,k} = rotm2eul(R{1,k});
    rotAngles{2,k} = rotm2eul(R{2,k});
    %Rb{1,k} = R{1,k-1}+P{1,k}(:,1:3);
    %Rb{2,k} = R{2,k-1}+P{2,k}(:,1:3);
    %rotAnglesd{1,k} = rotm2eul(Rb{1,k});
    %rotAnglesd{2,k} = rotm2eul(Rb{2,k});
    %rotAnglesb{1,k} = rotm2eul(R{1,k}+R{1,k-1});
    %rotAnglesb{2,k} = rotm2eul(R{2,k}+R{2,k-1});
end
%%
timeStamps = load(sprintf('KITTI-%s/times.txt',sequence))';
GT = load(sprintf('KITTI-%s/%s.txt',sequence,sequence));
plotAngles(rotAngles,GT, timeStamps,R)
%plotAngles(rotAnglesb,GT, timeStamps,R)
%plotAngles(rotAnglesc,GT, timeStamps,R)
%plotAngles(rotAnglesd,GT, timeStamps,R)
plotInliers(x, optimalConsensusSet,timeStamps)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check with plots
plotStuff(im1, im2, P1p, optimalConsensusSet1, K, K*x1, K*x2,'1-point RANSAC')
plotStuff(im1, im2, P5p, optimalConsensusSet5, K, K*x1, K*x2,'5-point RANSAC')
%plotStuff(im1, im2, P8p, set8p, X8p, K, x1, x2, '8-point RANSAC')


% Pose Ground truth for KITTI seq.00 for frame 2:
%pose_GT = [ 9.999978e-01, 5.272628e-04, -2.066935e-03 -4.690294e-02;
%            -5.296506e-04, 9.999992e-01, -1.154865e-03, -2.839928e-02;
%            2.066324e-03, 1.155958e-03, 9.999971e-01, 8.586941e-01];
        
% Ground truth for pose 12
%pose_GT = [9.996745e-01, 6.000540e-03, -2.479692e-02, -5.624310e-01;
%           -6.345160e-03, 9.998840e-01, -1.384246e-02, -3.405416e-01;
%           2.471098e-02, 1.399530e-02, 9.995966e-01, 1.029896e+01];

% Pose GT KITTI seq. 01 frame 2:
pose_GT = [9.990498e-01, -1.649780e-03, 4.355194e-02, 5.154656e-02;
            1.760423e-03, 9.999953e-01, -2.502237e-03, -2.424883e-02;
            -4.354760e-02, 2.576529e-03, 9.990480e-01, 1.000725e+00];

poseErr1p = abs(P1p-pose_GT)
sumPoseErr1p = sum(sum(poseErr1p))
sumPoseErr1pOnlyR = sum(sum(poseErr1p(:,1:3)))

poseErr5p = abs(P5p-pose_GT)
sumPoseErr5p = sum(sum(poseErr5p))
sumPoseErr5pOnlyR = sum(sum(poseErr5p(:,1:3)))

%{
fprintf('Diff between 5p and 1p RANSAC R & t: \n')
fprintf('------------------------------------- \n')
fprintf('1-Point RANSAC: \n');
R1 = P1p(:,1:3)
t1 = P1p(:,4)
fprintf('5-Point RANSAC: \n');
R5 = P5p(:,1:3)
t5 = P5p(:,4)
fprintf('Diff:');
Rdiff = abs(abs(R5)-abs(R1))
tDiff = abs(abs(t5)-abs(t1))
%}