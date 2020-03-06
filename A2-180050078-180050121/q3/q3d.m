fig = figure()
hold on
h=[1,2,3,4,3,2,1]/16;
x=zeros(100,1);
el=255*rand(10,1);
% size(x(randperm(100,10)'))
% size(el)
x(randperm(100,10)')=el;

subplot(1,3,1);
plot(x,'-*')
title('Original');

mag=norm(x);
sz1=size(x);
sz2=size(h);
n=sz1(1);
m=sz2(2);
noise=0.05*mag*randn(n+m-1,1);
y=conv(h,x)+noise;

subplot(1,3,2);
plot(y,'-*')
title('Original+Noise');

A=zeros(n+m-1,n);
h=flip(h);
for i=1:n+m-1
%     this row find x^(n+m+1-i)
% start from i+1-m and end at i  map 1 to m of h , add m-i to l,r
l=max(1,i+1-m);
r=min(n,i);
A(i,l:r)=h(l+m-i:r+m-i);
size(A);
end
A;
alpha = eigs(A'*A,1);
x_recon=ista(y,A,0.05*mag,alpha,10000);
% x_recon=x

subplot(1,3,3);
plot(x_recon,'-*')
title('After Reconstruction');
saveas(fig,strcat('q3d/recon','.png'));

rmse_recon = sqrt(sum(sum((x-x_recon).*(x-x_recon))))/sqrt(sum(sum(x.*x)));
save('q3d/results.mat');