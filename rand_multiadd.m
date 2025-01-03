function s=rand_multiadd(N,seed)
    a=69069;
    p=2^32;
    s=zeros(N,1);
    for i=1:N
        s(i)=mod(seed*a+m,p);
        seed=s(i);
    end
    s=s/p;
end