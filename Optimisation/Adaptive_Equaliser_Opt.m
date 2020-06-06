intial_pos=[16, 200];
lb = [0 , 0];
ub = [2^10, 5000];
func=@BER_function;
PSoptions = optimoptions(@patternsearch,'Display','iter');
%[out,val]=patternsearch(func,intial_pos,[],[],[],[],lb,ub,PSoptions)
[out,val] =ga(func,2,[],[],[],[],lb,ub)