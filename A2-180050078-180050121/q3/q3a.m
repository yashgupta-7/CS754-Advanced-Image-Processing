fig = figure()
hold on

I=double(imread('barbara256.png'));

subplot(1,3,1);
imshow(I,[]);
title('Original');
%%%%%%%%%%%%%%%%CHANGE TO 2
I_noise=I+2*randn(size(I));

subplot(1,3,2);
imshow(I_noise,[]);
title('Original + Noise');

sz=size(I);
N=sz(1);
M=sz(2);
cnt=zeros(sz);
I_recon=double(zeros(sz));
phi=kron(dctmtx(8)',dctmtx(8)');

A = phi;
alpha = eigs(A'*A,1);

for i=1:N-7
    for j=1:M-7
    y=reshape(I_noise(i:i+7,j:j+7)',64,1);
    cnt(i:i+7,j:j+7)=cnt(i:i+7,j:j+7)+1;
%     reconstruct
%     x_rec=istat(y,phi,2,10,25);
    x_rec=ista(y,phi,1,alpha,50);
    I_recon(i:i+7,j:j+7)=I_recon(i:i+7,j:j+7)+reshape(phi*x_rec,8,8)';
    end
end
I_recon=I_recon./cnt;

subplot(1,3,3);
imshow(I_recon,[]);
title('After Reconstruction');
saveas(fig,strcat('q3a/recon_barb','.png'));

rmse_noise =sqrt(sum(sum((I-I_noise).*(I-I_noise))))/sqrt(sum(sum(I.*I)))
rmse_recon =sqrt(sum(sum((I-I_recon).*(I-I_recon))))/sqrt(sum(sum(I.*I)))
save('q3a/results.mat');