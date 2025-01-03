function s=middle_square(N,seed)
    s=zeros(N,1);
    for i=1:N
        square=seed^2;
        squareDigits=double(num2str(square)-double('0'));
        seedDigits=double(num2str(seed)-double('0'));
        [a, sizeSquare]=size(squareDigits);
        while (length(squareDigits) ~= 8)
            squareDigits=[0 squareDigits];
        end
      
        for j=3:6
            s(i)=s(i)+squareDigits(j)*10^(6-j);
        end
        seed=s(i);
    end
end
    
