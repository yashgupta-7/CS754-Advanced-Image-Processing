% load('soft.m');

function theta = ista(y,A,lambda,alpha,nit)
%     nit = 50;
%     alpha = max(eigs(A'A,1));
    sz = size(A);
    n = sz(2);
    theta = zeros(n,1);
    for k=1:nit 
        theta = soft(theta+(1/alpha)*A'*(y - A*theta), lambda/(2*alpha));
        theta;
    end
end