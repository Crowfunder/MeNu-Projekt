function s=middle_square(N,seed)
    s=zeros(N,1);
    for i=1:N
        square=seed^2;
        squareDigits=double(num2str(square)-double('0'));
        seedDigits=double(num2str(seed)-double('0'));
        [sizeSquare,a]=size(squareDigits);
        if(mod(sizeSquare,2)==1)
            squareDigits=[0]+squareDigits;
        end
      
        for j=3:6
            s(i)=s(i)+squareDigits(j)*10^(6-j);
        end
        seed=s(i)
    end
end
    
