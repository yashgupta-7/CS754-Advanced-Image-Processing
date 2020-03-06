fig = figure()
hold on

I=double(imread('barbara256.png'));
% I = I(1:256,1:256);

subplot(1,2,1);
imshow(I,[]);
title('Original');


sz=size(I);
N=sz(1);
M=sz(2);
cnt=zeros(sz);
I_recon=double(zeros(sz));
U=kron(dctmtx(8)',dctmtx(8)');
phi=randn(32,64);

A = phi*U;
alpha = eigs(A'*A,1);

for i=1:N-7
    for j=1:M-7
    y=phi*reshape(I(i:i+7,j:j+7)',64,1);
    cnt(i:i+7,j:j+7)=cnt(i:i+7,j:j+7)+1;
%     reconstruct
    x_rec=ista(y,A,1,alpha,100);
%     x_rec=istat(y,phi*U,2,200,50);
    I_recon(i:i+7,j:j+7)=I_recon(i:i+7,j:j+7)+reshape(U*x_rec,8,8)';
    end
end
I_recon=I_recon./cnt;

subplot(1,2,2);
imshow(I_recon,[]);
title('After Reconstruction');
saveas(fig,strcat('q3b/recon_barb','.png'));

% rmse_noise = sqrt(sum(sum((I-I_noise).*(I-I_noise))))/sqrt(sum(sum(I.*I)))
rmse_recon = sqrt(sum(sum((I-I_recon).*(I-I_recon))))/sqrt(sum(sum(I.*I)))
save('q3b/results_barb.mat');