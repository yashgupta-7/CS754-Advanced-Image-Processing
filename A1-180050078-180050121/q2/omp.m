function f=omp(y,A,e)
    r=y;
    i=0;
    sz=size(A);
    N=sz(2);
    theta=zeros(N,1);
    T=[];
    A_nor =  normc(A);
    cnt = 0;
    while(norm(r)>e & cnt<64)
        cnt = cnt+1;
        [c,d]=max(abs(r'*A_nor));
        T=[T d];
        i=i+1;
        theta(T)=pinv(A(:,T))*y;
        r=y-A(:,T)*theta(T);
        theta;
    end
    f=theta;
end
