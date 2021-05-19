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
% KITTI image pair - sequence 01
im1 = single(imread('KITTI-01/000000.png'));
im2 = single(imread('KITTI-01/000001.png'));

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

% Extract matches using vl_sift
[x1,x2] = extractMatches(im1,im2);

% Convert to homogeneous coordinates
x1 = [x1; ones(1, size(x1,2))];
x2 = [x2; ones(1, size(x2,2))];

% Normalize Image points
x1 = K\x1;
x2 = K\x2;

[theta, phi_c] = nonLinearTwoPointSolution(x1(:,1:2),x2(:,1:2))
rho = 1;
L = rho*((-sin((theta/2)-phi_c))/(sin(phi_c)+sin(theta-phi_c)))