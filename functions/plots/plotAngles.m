function plotAngles(rotAngles, GT, timestamps,R)
%PLOTANGLES Summary of this function goes here
%   Detailed explanation goes here
    n = size(rotAngles,1); % number of outputs to compare
    m = size(rotAngles,2)-1; % length of Sequence
    
    timestamps=timestamps(1,1:m);
    
    % Extract ground truth angles:
    GT_angles = zeros(3,m);
    for i =1:m
        GT_i = GT(i,:);
        GTpose = [GT_i(1,1:4); GT_i(1,5:8); GT_i(1,9:12)];
        GT_angles(:,i) = rotm2eul(GTpose(:,1:3));%extractEulerAngles(GTpose(:,1:3));
        %[GT_angles(1,i),GT_angles(2,i), GT_angles(3,i)]  = rotm2eul(GTpose(:,1:3));%extractEulerAngles(GTpose(:,1:3));
    end
    yaw = zeros(n,m);
    pitch = zeros(n,m);
    roll = zeros(n,m);
    %{
    for i = 2:m
        i
        angles1 = rotm2eul(R{1,i});
        angles2 = rotm2eul(R{2,i});
        yaw(1,i) = angles1(1);
        yaw(2,i) = angles2(1);
        pitch(1,i) = angles1(2);
        pitch(2,i) = angles2(2);
        roll(1,i) = angles1(3);
        roll(2,i) = angles2(3);
    end
    %}
    for i = 2:m
        angles1 = rotAngles{1,i};
        angles2 = rotAngles{2,i};
        yaw(1,i) = angles1(1);
        yaw(2,i) = angles2(1);
        pitch(1,i) = angles1(2);
        pitch(2,i) = angles2(2);
        roll(1,i) = angles1(3);
        roll(2,i) = angles2(3);
    end
    figure(name='Comparison of rotational angles');
    title 'Comparison of Angles between the different algorithms and the ground truth'
    xlabel 'sequence #'
    ylabel 'angle'
   
    subplot(3,1,1)
    title 'yaw'
    plot(timestamps,yaw(1,:),'g')
    hold on
    plot(timestamps,yaw(2,:),'b')
    plot(timestamps, GT_angles(1,:), 'r--')
    legend('1pRANSAC', '5pRANSAC','Ground-truth')
    
    subplot(3,1,2)
    title 'pitch'
    plot(timestamps,pitch(1,:),'g')
    hold on
    plot(timestamps,pitch(2,:),'b')
    plot(timestamps, GT_angles(2,:), 'r--')
    legend('1pRANSAC', '5pRANSAC','Ground-truth')
    
    subplot(3,1,3)
    title 'roll'
    plot(timestamps,roll(1,:),'g')
    hold on
    plot(timestamps,roll(2,:),'b')
    plot(timestamps, GT_angles(3,:), 'r--')
    legend('1pRANSAC', '5pRANSAC','Ground-truth')
end

