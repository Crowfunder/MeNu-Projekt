function s=xorshift128(N,seed)
    seedMatrix=uint32([seed, seed*2, seed/3, seed+31]);
    s=zeros(N,1);
    for i=1:N
        tmp=seedMatrix(2);
        tmp=bitxor(tmp,bitshift(tmp,11));
        tmp=bitxor(tmp,bitshift(tmp,-8));
        seedMatrix(2)=seedMatrix(3);
        seedMatrix(3)=seedMatrix(4);
        seedMatrix(4)=seedMatrix(1);
        seedMatrix(1)=bitxor(seedMatrix(1),bitshift(seedMatrix(1),-19));
        seedMatrix(1)=bitxor(seedMatrix(1),tmp);
        s(i)=seedMatrix(1);
    end
end