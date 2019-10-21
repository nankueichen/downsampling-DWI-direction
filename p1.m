%
% Here we assume the b values are the same for both diffusion direction
% sampling schemes: 'more_directions.txt' and 'fewer_directions.txt'
%
% It is fine to include b=0 (i.e., non-diffusion imaging) in the list
% 

fileLong = 'more_directions.txt';  
fileShort = 'fewer_directions.txt';

fileID = fopen(fileLong);
infoLong = textscan(fileID, '%f %f %f');
fclose(fileID);
lenLong = length(infoLong{1});

fileID = fopen(fileShort);
infoShort = textscan(fileID, '%f %f %f');
fclose(fileID);
lenShort = length(infoShort{1});

vecShort = zeros(3,lenShort);
vecLong = zeros(3,lenLong);
for cnt = 1: 3
    vecShort(cnt,:)=infoShort{cnt};
    vecLong(cnt,:)=infoLong{cnt};
end

vecLongMatchWithShort = zeros(3,lenShort);
vecLongMatchWithShortIndex = zeros(1,lenShort);
for cnt = 1:lenShort
    tmp = vecShort(:,cnt);
    if norm(tmp)>0 % Here we only work on diffusion imaging (skipping b=0)
        tmp = repmat(tmp,[1 lenLong]);
        tmp2 = dot(tmp,vecLong);
        tmp2 = abs(tmp2); % Note that we take absolute value here (e.g., [1,0,0] and [-1,0,0] have the same effect on diffusion signals)
        tmpL = find(tmp2 == max(tmp2(:)));
        vecLongMatchWithShortIndex(cnt)= tmpL(1);
        vecLongMatchWithShort(:,cnt) = vecLong(:,tmpL(1));
    end
end

figure(1); title('Low angular resolution scan: original'); hold on
for cnt = 1:lenShort
    plot3([-vecShort(1,cnt),vecShort(1,cnt)],[-vecShort(2,cnt),vecShort(2,cnt)],[-vecShort(3,cnt),vecShort(3,cnt)],'b');
%      plot3([0,vecShort(1,cnt)],[0,vecShort(2,cnt)],[0,vecShort(3,cnt)],'b');
end
figure(1); hold off
set(gca, 'CameraPosition', [4000 6000 4000]);
axis equal
grid on

figure(2); title('Low angular resolution down-sampled from high angular resolution'); hold on
for cnt = 1:lenShort
    plot3([-vecLongMatchWithShort(1,cnt),vecLongMatchWithShort(1,cnt)],[-vecLongMatchWithShort(2,cnt),vecLongMatchWithShort(2,cnt)],[-vecLongMatchWithShort(3,cnt),vecLongMatchWithShort(3,cnt)],'g');
%     plot3([0,vecShort(1,cnt)],[0,vecShort(2,cnt)],[0,vecShort(3,cnt)],'b');
end
figure(2); hold off
set(gca, 'CameraPosition', [4000 6000 4000]);
axis equal
grid on

figure(3); title('Combined'); hold on
for cnt = 1:lenShort
    plot3([-vecShort(1,cnt),vecShort(1,cnt)],[-vecShort(2,cnt),vecShort(2,cnt)],[-vecShort(3,cnt),vecShort(3,cnt)],'b');
    plot3([-vecLongMatchWithShort(1,cnt),vecLongMatchWithShort(1,cnt)],[-vecLongMatchWithShort(2,cnt),vecLongMatchWithShort(2,cnt)],[-vecLongMatchWithShort(3,cnt),vecLongMatchWithShort(3,cnt)],'g');
%      plot3([0,vecShort(1,cnt)],[0,vecShort(2,cnt)],[0,vecShort(3,cnt)],'b');
end
figure(3); hold off
set(gca, 'CameraPosition', [4000 6000 4000]);
axis equal
grid on


display(vecLongMatchWithShort')
display(vecLongMatchWithShortIndex);











