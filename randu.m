function s=randu(N,seed)
    a=65539;
    p=2^31;
    s=zeros(N,1);
    for i=1:N
        s(i)=mod(a*seed,p);
        seed=s(i);
    end
    s=s/p;
end
