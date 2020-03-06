fig = figure()
hold on

I=double(imread('goldhill.png'));
I = I(1:256,1:256);
subplot(1,2,1);
imshow(I,[]);
title('Original');

% I_noise=I+2*randn(size(I));
% subplot(1,3,2);
% imshow(I_noise,[]);
% title('Original + Noise');

sz=size(I);
% sz=[8,8];
N=sz(1)
M=sz(2)

cnt=zeros(sz);
I_recon=double(zeros(sz));
% U=kron(dctmtx(8)',dctmtx(8)');
% thetanew=eye(64,64);
%         a=thetanew(1:32,1:32);
%         b=thetanew(1:32,33:64);
%         c=thetanew(33:64,1:32);
%         d=thetanew(33:64,33:64);
%         U=idwt2(a,b,c,d,'db1');
%         U;
        
phi=randn(32,64);
for i=1:N-7
    i
    for j=1:M-7
    y=phi*reshape(I(i:i+7,j:j+7)',64,1);
    cnt(i:i+7,j:j+7)=cnt(i:i+7,j:j+7)+1;
%     reconstruct
    x_rec=ista2(y,phi,1,300,30);
    thetanew=reshape(x_rec,8,8)';
        a=thetanew(1:4,1:4);
        b=thetanew(1:4,5:8);
        c=thetanew(5:8,1:4);
        d=thetanew(5:8,5:8);
        inv=idwt2(a,b,c,d,'db1');
%         U=idwt2(a,b,c,d,'db1');

    I_recon(i:i+7,j:j+7)=I_recon(i:i+7,j:j+7)+inv;
    end
end
I_recon=I_recon./cnt;
subplot(1,2,2);
imshow(I_recon,[]);
title('After Reconstruction');
saveas(fig,strcat('q3c/recon_gold','.png'));

rmse=sum(sum((I-I_recon).*(I-I_recon)))/sum(sum(I.*I))
save('q3c/results_gold.mat');