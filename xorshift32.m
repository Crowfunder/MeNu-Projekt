function s=xorshift32(N,seed)
    s=zeros(N,1);
    for i=1:N
        tmp=uint32(seed);
        tmp=bitxor(tmp,bitshift(tmp,17));
        tmp=bitxor(tmp,bitshift(tmp,-7));
        tmp=bitxor(tmp,bitshift(tmp,5));
        s(i)=tmp;
        seed=tmp;
    end
end