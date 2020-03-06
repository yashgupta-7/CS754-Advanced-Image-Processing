% load('soft.m');

function theta = ista2(y,phi,lambda,alpha,nit)
%     nit = 50;
%     alpha = max(eigs(A'A,1));
    sz = size(phi);
    n = sz(2);
    phitphi=phi'*phi;
    theta = zeros(n,1);
    for k=1:nit
        thetanew=reshape(theta,8,8)';
        a=thetanew(1:4,1:4);
        b=thetanew(1:4,5:8);
        c=thetanew(5:8,1:4);
        d=thetanew(5:8,5:8);
        inv=idwt2(a,b,c,d,'db1');
        to_mul=reshape(inv',64,1);
        newt=phi'*y-phitphi*to_mul;
        fordwt=reshape(newt,8,8)';
        [a1,b1,c1,d1]=dwt2(fordwt,'db1');
        fin=[a1 b1;c1 d1];
%         size(fin)
        fin2=reshape(fin',64,1);
        theta = soft(theta+(1/alpha)*fin2, lambda/(2*alpha));
        theta;
    end
end