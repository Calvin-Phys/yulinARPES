function min=minimum(list)
num=size(list,2);
n=1;
for i=1:num
    list_1(n)=list(i);
    n=n+1;
    if i>1
        for k=1:(i-1)
            list_1(n)=abs(list(i)-list(k));
            n=n+1;
        end
    end
end
number=size(list_1,2);
min=100;
for i=1:number
    if list_1(i)<min && list_1(i)>0.00000001
        min=list_1(i);
    end
end
end