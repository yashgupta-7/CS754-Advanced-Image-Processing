% load('omp.m');
vid = VideoReader('cars.avi');
vidFrames = read(vid);
nFrames = vid.NumberOfFrames;
T = 3;
vidFrames = vidFrames(end-120:end,end-240:end,:,:);
svid = size(vidFrames);
frames = zeros(svid(1), svid(2), T);
for i=1:T
    frames(:,:,i) = double(rgb2gray(vidFrames(:,:,:,i)));
%     figure;
%     imshow(cast(vidFrames(:,:,i),'uint8'));  %frames are grayscale
end
code = randi(2, svid(1), svid(2), T) - 1 ;
snaps = code.*frames;
cod_snap = zeros(svid(1), svid(2));
for i=1:T 
    cod_snap(:,:) = cod_snap(:,:) + snaps(:,:,i);
    fig = figure();
    subplot(1,2,1);
    axis on;
    imshow(cast(frames(:,:,i),'uint8'));
    title('Snapshot');
    subplot(1,2,2);
    axis on;
    imshow(cast(snaps(:,:,i),'uint8'));
    title('Coded Snapshot');
%     saveas(fig,strcat('T=5f/snap',num2str(i),'.png'));
end
cod_snap = cod_snap + normrnd(0,2,svid(1),svid(2));
fig = figure;
subplot(1,1,1);
axis on;
imshow(cast(cod_snap,'uint8'));
title('With Gaussian Noise');
% saveas(fig,strcat('T=f/cod_snap','.png'));

D = dctmtx(8);
DD = kron(D,D)';
psi = kron(eye(T),DD);

eps = 48;
recon = zeros(svid(1), svid(2), T);
count = zeros(svid(1), svid(2), T);
for i=1:svid(1)-7
    i
    for j=1:svid(2)-7
        codeij = code(i:i+7,j:j+7,:);
        C = [];
        for k=1:T
            Ctemp = diag(reshape(codeij(:,:,k)',64,1))*DD;
            C = [C Ctemp];
        end
%         A = C*psi;
        A = C;
        
        patch = cod_snap(i:i+7,j:j+7);
        y = reshape(patch', 64, 1);
        theta = psi*omp(y,A,eps);
        for k=1:T
            l = 64*(k-1)+1;
            h = 64*k;
%             theta(l:h,:) = DD*theta(l:h,:);
            rcpk = reshape(theta(l:h,:),8,8);
            recon(i:i+7,j:j+7,k) = recon(i:i+7,j:j+7,k) + rcpk';
            count(i:i+7,j:j+7,k) = count(i:i+7,j:j+7,k) + ones(8,8);
        end
        theta;
    end
end

res = recon./count;
for i=1:T
    fig = figure;
    subplot(1,3,1);
    axis on
    imshow(cast(frames(:,:,i),'uint8'));
    title('Snapshot');
    subplot(1,3,2);
    axis on
    imshow(cast(snaps(:,:,i),'uint8'));
    title('Coded Snapshot');
    subplot(1,3,3);
    axis on
    imshow(cast(res(:,:,i),'uint8'));
    title('After Reconstruction');
%     saveas(fig,strcat('T=5f/recon',num2str(i),'.png'));
end

rmse = rssq(rssq(rssq(res-frames)))/rssq(rssq(rssq(frames)));
fprintf('RMSE for T=5 is %s\n', num2str(rmse));
% save('T=5f/results.mat');